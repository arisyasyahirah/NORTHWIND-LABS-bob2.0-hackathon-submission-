# CTMS Architecture — Cinema Ticket Management System

> **Audience:** Alex Tan — Junior Backend Engineer, Northwind Labs
> **Rule:** Backtick citations use repo-relative paths. Anything not evidenced is flagged "Unknown — ask your buddy."

---

## 1. System Context

| Actor | Description | Restriction level |
|---|---|---|
| **Customer** | Browses movies, books tickets, views profile | n/a (session userType = "Customer") |
| **Staff** | Front-of-house staff; views dashboards | 1 |
| **Manager** | Branch manager; manages showtimes and cinema ops | 2 |
| **HQ** | Head-office admin; full access | 3 |

Restriction levels drive post-login redirects — see `src/java/com/ctms/controller/LoginServlet.java:63`.

What the system does:
- **Browse & book** — customers browse the catalogue, view showtimes, select seats, pay.
- **Payment** — Stripe handles charges via `src/java/com/ctms/service/PaymentService.java:11`; Stripe webhooks are received at `src/java/com/ctms/controller/WebhookServlet.java:17`.
- **Cinema management** — employees manage movies, showtimes, and food menus.
- **Auth** — `src/java/com/ctms/filter/AuthFilter.java:18` guards all protected routes.

---

## 2. Containers

```
Browser (JSP pages)
       │ HTTP
       ▼
Jakarta EE Servlet Container (Apache Tomcat)
Context path: /SAD_Project  [web/META-INF/context.xml]
  Filters: AuthFilter (/employee/*, /customer/profile.jsp)
  Servlets: 18 classes in com.ctms.controller
  Services: AccountService, MovieService, ShowtimeService, PaymentService, MenuService
  DAOs: CustomerDAO, EmployeeDAO, MovieDAO, ShowtimeDAO, PaymentDAO, FoodDAO
       │ JDBC (PostgreSQL)          │ HTTPS
       ▼                            ▼
PostgreSQL on Supabase          Stripe API
[src/java/com/ctms/util/        Key at src/java/com/ctms/service/PaymentService.java:19
 ConnectionDB.java:8]         Secret at src/java/com/ctms/controller/WebhookServlet.java:19
```

Filter-to-URL mappings (from `web/WEB-INF/web.xml:166-191`):

| Filter | URL pattern |
|---|---|
| EmployeeAuthFilter | `/employee/*` |
| CustomerAuthFilter | /customer/profile.jsp |

Both map to `src/java/com/ctms/filter/AuthFilter.java`.

---

## 3. Component Inventory

### Controllers — com.ctms.controller

| File | Purpose |
|---|---|
| `src/java/com/ctms/controller/LoginServlet.java` | Auth, session, role redirect |
| `src/java/com/ctms/controller/RegisterServlet.java` | New customer registration |
| `src/java/com/ctms/controller/HomeServlet.java` | Employee landing page |
| `src/java/com/ctms/controller/ViewMovieListServlet.java` | Public movie listing |
| `src/java/com/ctms/controller/ViewMovieDetailServlet.java` | Single movie detail |
| `src/java/com/ctms/controller/AddNewMovieServlet.java` | HQ: add movie |
| `src/java/com/ctms/controller/UpdateMovieServlet.java` | HQ: edit movie |
| `src/java/com/ctms/controller/DeleteMovieServlet.java` | HQ: delete movie |
| `src/java/com/ctms/controller/ManageMovieServlet.java` | HQ: movie management dashboard |
| `src/java/com/ctms/controller/ShowtimeServlet.java` | List showtimes |
| `src/java/com/ctms/controller/AddShowtimeServlet.java` | Manager: add showtime |
| `src/java/com/ctms/controller/DeleteShowtimeServlet.java` | Manager: delete showtime |
| `src/java/com/ctms/controller/UpdateShowtimeServlet.java` | Manager: edit showtime |
| `src/java/com/ctms/controller/BookingScheduleServlet.java` | Seat selection / schedule |
| `src/java/com/ctms/controller/PaymentServlet.java` | Initiate Stripe payment |
| `src/java/com/ctms/controller/WebhookServlet.java` | Receive Stripe webhook events |
| `src/java/com/ctms/controller/ProfileServlet.java` | Customer profile view/edit |
| `src/java/com/ctms/controller/LogoutServlet.java` | Invalidate session |

### Services — com.ctms.service

| File | Purpose |
|---|---|
| `src/java/com/ctms/service/AccountService.java` | Login, registration, permission check |
| `src/java/com/ctms/service/MovieService.java` | Movie CRUD orchestration |
| `src/java/com/ctms/service/ShowtimeService.java` | Showtime scheduling logic |
| `src/java/com/ctms/service/PaymentService.java` | Stripe PaymentIntent creation ⚠️ hardcoded key at :19 |
| `src/java/com/ctms/service/MenuService.java` | Food menu logic |

### DAOs — com.ctms.dao

| File | Notes |
|---|---|
| `src/java/com/ctms/dao/CustomerDAO.java` | ⚠️ SQL bug at line 105: DELETE FROM TABLE customer |
| `src/java/com/ctms/dao/EmployeeDAO.java` | Employee lookup by email and restriction level |
| `src/java/com/ctms/dao/MovieDAO.java` | Movie queries |
| `src/java/com/ctms/dao/ShowtimeDAO.java` | Showtime queries |
| `src/java/com/ctms/dao/PaymentDAO.java` | Payment record persistence |
| `src/java/com/ctms/dao/FoodDAO.java` | Food/menu queries |

### Models, DTOs, Filters, Utilities

- Models: Customer, Employee, Movie, ShowTime, Payment, Food (plain Java objects)
- DTOs: BannerDTO, DateTimeDTO, MovieDTO, ShowTimeDTO, ShowtimeHallDTO
- Filters: `src/java/com/ctms/filter/AuthFilter.java` (role check); LoginFilter — Unknown, ask your buddy
- Utilities: `src/java/com/ctms/util/ConnectionDB.java` (JDBC); TimeUtil — Unknown, ask your buddy

---

## 4. End-to-End Request Flow — "A Customer Logs In"

```
Browser POSTs to /LoginServlet
  ↓
AuthFilter checks session — no session yet, passes through
  ↓
LoginServlet.doPost() [src/java/com/ctms/controller/LoginServlet.java:23]
  reads email and password params
  ↓
AccountService.verifyByEmail() [src/java/com/ctms/service/AccountService.java:32]
  ↓
CustomerDAO.findCustomerByEmail() [src/java/com/ctms/dao/CustomerDAO.java:22]
or EmployeeDAO.findEmployeeByEmail()
  ↓
ConnectionDB → JDBC → PostgreSQL on Supabase [src/java/com/ctms/util/ConnectionDB.java:8]
  ↓
ResultSet → Customer or Employee model
  ↓
AccountService plain-text .equals() password check [src/java/com/ctms/service/AccountService.java:37]
  (ISSUE-003: no hashing)
  ↓
LoginServlet sets session attributes: email, userType
  ↓
Branch by restriction level [src/java/com/ctms/controller/LoginServlet.java:63]:
  restriction=3 (HQ)      → /HomeServlet
  restriction=2 (Manager) → /ShowtimeServlet
  restriction=1 (Staff)   → /HomeServlet
  Customer                → index.jsp
```

| Hop | File | Line |
|---|---|---|
| Form submission | `web/WEB-INF/web.xml` | /LoginServlet mapping |
| Servlet entry | `src/java/com/ctms/controller/LoginServlet.java:23` | doPost |
| Credential check | `src/java/com/ctms/service/AccountService.java:32` | verifyByEmail |
| DAO query | `src/java/com/ctms/dao/CustomerDAO.java:22` | findCustomerByEmail |
| DB connection | `src/java/com/ctms/util/ConnectionDB.java:8` | JDBC URL |
| Role redirect | `src/java/com/ctms/controller/LoginServlet.java:63` | restriction branch |

---

## 5. Build and Run

Prerequisites: Apache Tomcat, JDK (version Unknown — ask your buddy), Apache Ant.

Build:
```
ant clean
ant build
```
(targets defined in build/build.xml — check for exact target names)

Deploy: drop the WAR into Tomcat webapps/ and access at `http://localhost:<port>/SAD_Project/`.
Context path from `web/META-INF/context.xml`.

No unit test sources were found. Testing approach — Unknown, ask your buddy.

---

## 6. Code Tour

| Stop | File | What to look at |
|---|---|---|
| 1 | `src/java/com/ctms/util/ConnectionDB.java:6` | JDBC URL and username — credentials hardcoded (ISSUE-001) |
| 2 | `src/java/com/ctms/filter/AuthFilter.java:18` | How session-based auth guards routes by role |
| 3 | `src/java/com/ctms/controller/LoginServlet.java:19` | Full login flow: params → verify → session → redirect |
| 4 | `src/java/com/ctms/service/AccountService.java:32` | verifyByEmail: plain-text password comparison (ISSUE-003) |
| 5 | `src/java/com/ctms/dao/CustomerDAO.java:22` | PreparedStatement pattern; SQL bug at line 105 (ISSUE-004) |
| 6 | `src/java/com/ctms/dao/MovieDAO.java:17` | getAllMovies: clean DAO pattern, good reference |
| 7 | `src/java/com/ctms/controller/PaymentServlet.java:16` | Stripe payment intent creation |
| 8 | `src/java/com/ctms/service/PaymentService.java:11` | Stripe SDK; hardcoded key at line 19 (ISSUE-002) |
| 9 | `src/java/com/ctms/controller/WebhookServlet.java:17` | Webhook handler; hardcoded secret at line 19 (ISSUE-002) |

---

## 7. Known Findings Summary

| # | Severity | File | Finding |
|---|---|---|---|
| 1 | critical | `src/java/com/ctms/util/ConnectionDB.java:8` | Hardcoded DB credentials |
| 2 | critical | `src/java/com/ctms/service/PaymentService.java:19` | Hardcoded Stripe API key |
| 3 | critical | `src/java/com/ctms/controller/WebhookServlet.java:19` | Hardcoded webhook secret |
| 4 | critical | `src/java/com/ctms/service/AccountService.java:37` | Plain-text password comparison |
| 5 | high | `src/java/com/ctms/dao/CustomerDAO.java:105` | SQL syntax bug in deleteCustomer |

Full details in context/issues/.

---

## 8. What Is Not Yet Known (ask your buddy)

- JDK and Tomcat versions required
- Staging/production environment URLs
- Role of LoginFilter and TimeUtil
- Test strategy
- Git remote and branching workflow
- CI/CD pipeline
