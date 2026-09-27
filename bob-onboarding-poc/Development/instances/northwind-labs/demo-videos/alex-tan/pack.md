# Welcome to Northwind Labs, Alex
Role: Backend Engineer · Level: Junior · Manager: Priya Menon · Buddy: Daniel Wong · Start: 2026-10-05

## Why we exist
Northwind Labs exists to make field-service logistics simple enough that a **two-person team** can run it from a phone. Every engineering decision should trace back to that goal: reduce complexity, prefer clarity, and ship things that genuinely solve the real problem in front of the customer.

## What you own
As a Backend Engineer on the Platform team you own the API and data layer:

- **Servlet controllers** in `src/java/com/ctms/controller/` — build and maintain HTTP request handlers that coordinate service and data flow to the presentation layer.
- **Service layer** in `src/java/com/ctms/service/` — implement business logic and orchestrate DAO calls (e.g., `MovieService`, `ShowtimeService`).
- **DAO layer** in `src/java/com/ctms/dao/` — maintain database query methods, schema interaction, and data persistence.
- **Model classes** in `src/java/com/ctms/model/` — define and evolve domain objects (`Movie`, `ShowTime`, etc.).
- **Database migrations and seed data** — manage schema changes and initial data.
- **Unit and integration tests** — write test coverage for all DAO, Service, and Servlet code you ship.
- **Code review** — review teammate PRs within one working day.
- **On-call rotation** — join escalation duty from week 4, always paired for the first shift.

## Architecture at a glance
**CTMS** (Cinema Ticketing Management System) is a Jakarta EE web application built on a **layered architecture** (Controller → Service → DAO → Model). It manages cinema operations: movie listings, showtimes, bookings, and user accounts.

> **Term to know — Jakarta EE:** a set of Java specifications for building enterprise web applications.

### System context
**Users:**
- **Employees** (staff, managers, HQ admin) — manage movies, showtimes, bookings.
- **Customers** — browse movies and book tickets.

**External systems:**
- **PostgreSQL database** hosted on Supabase/AWS — all data lives here.
- **Stripe** — handles payment processing (`src/java/com/ctms/service/PaymentService.java`).

### Components
| Layer | Responsibility | Representative file |
|---|---|---|
| Filter | Auth guard; checks session + user role before any page loads | `src/java/com/ctms/filter/AuthFilter.java` |
| Controller (Servlet) | HTTP entry point; receives requests, calls services, redirects to JSP | `src/java/com/ctms/controller/LoginServlet.java` |
| Service | Business logic; orchestrates DAOs, validates permissions | `src/java/com/ctms/service/AccountService.java` |
| DAO | Database queries; CRUD operations per entity | `src/java/com/ctms/dao/CustomerDAO.java` |
| Model | Java bean; holds entity data (id, email, name, etc.) | `src/java/com/ctms/model/Customer.java` |
| DTO | Data Transfer Objects; shapes data for a specific view or API response | `src/java/com/ctms/dto/MovieDTO.java` |
| Util | Helper classes; database connection management | `src/java/com/ctms/util/ConnectionDB.java` |
| Web / JSP | Server-side HTML templates rendered per user role | `web/index.jsp` |

### How a request flows (real files)
Tracing a user login end-to-end:

```
1. Browser → POST /LoginServlet
   (user submits login.jsp form)

2. LoginServlet.doPost()
   src/java/com/ctms/controller/LoginServlet.java:23
   — extracts email & password from request parameters

3. AccountService.verifyByEmail(email, password)
   src/java/com/ctms/service/AccountService.java:32
   — checks both EmployeeDAO and CustomerDAO

4. CustomerDAO.findCustomerByEmail(email)
   src/java/com/ctms/dao/CustomerDAO.java:22
   — executes: SELECT * FROM customer WHERE cust_email = ?

5. ConnectionDB → PostgreSQL (Supabase/AWS)
   src/java/com/ctms/util/ConnectionDB.java:9
   — creates JDBC connection, runs query, returns ResultSet

6. Customer bean built from ResultSet
   src/java/com/ctms/model/Customer.java:14

7. AccountService compares password, returns role string
   src/java/com/ctms/service/AccountService.java:39

8. LoginServlet stores user in HTTP session
   src/java/com/ctms/controller/LoginServlet.java:37

9. AuthFilter checks role on protected paths
   src/java/com/ctms/filter/AuthFilter.java:42

10. Redirect → JSP dashboard rendered in browser
    (e.g., web/staffDashboard.jsp or web/hqDashboard.jsp)
```

### Why it's built this way
- **Layered design** separates HTTP concerns (Servlet) from business rules (Service) from SQL (DAO) — makes each layer independently testable. Source: package structure and class naming conventions in code.
- **Prepared statements** in DAOs prevent SQL injection. Source: `src/java/com/ctms/dao/CustomerDAO.java:27`.
- **Filter + session** enforces role-based access; `AuthFilter` runs before any employee page. Source: `src/java/com/ctms/filter/AuthFilter.java:29`.
- **Why Ant / Jakarta EE:** Unknown — ask your buddy.
- **Why Supabase/PostgreSQL:** Unknown — ask your buddy.

## Run it first
### Prerequisites
| Tool | Version | Notes |
|---|---|---|
| Java JDK | 11+ | Required by Jakarta Servlet 6.1 (`web/WEB-INF/web.xml`) |
| Apache Ant | Any recent | Build tool (`build.xml`) |
| Apache Tomcat | 10+ | Jakarta EE 6.1-compatible servlet container |
| PostgreSQL | 14+ | DB engine (`src/java/com/ctms/util/ConnectionDB.java`) |

### Steps to run
1. **Clone / copy** the CTMS_Project directory to your machine.
2. **Configure the database connection** — credentials are currently hardcoded in `src/java/com/ctms/util/ConnectionDB.java:8`. Ask your buddy for the current dev-database credentials or to set up a local PostgreSQL instance.
3. **Build with Ant:**
```bash
ant clean build
```
4. **Deploy to Tomcat:** copy the built WAR to `$CATALINA_HOME/webapps/`, then start Tomcat.
5. **Open** `http://localhost:8080/CTMS_Project/` in your browser.
6. **Verify login** works — navigate to `web/login.jsp`, sign in, and confirm you land on a dashboard.

### Run tests
No automated test suite is present in the codebase. There are no JUnit or integration-test files. Writing the first test is part of your starter tasks.

## Code tour
Follow these 8 stops in order — they answer the questions you'll actually ask in week 1.

| # | Stop | What it does |
|---|---|---|
| 1 | `src/java/com/ctms/controller/LoginServlet.java:23` | **Where requests enter.** `doPost()` receives HTTP form data and delegates to the service layer. Every Servlet in `controller/` follows this pattern. |
| 2 | `src/java/com/ctms/filter/AuthFilter.java:29` | **How auth is enforced.** `doFilter()` checks the session before any request reaches a protected page. If there's no valid session, it bounces the user to login. |
| 3 | `src/java/com/ctms/util/ConnectionDB.java:9` | **How the DB connection is made.** A new JDBC connection is created on demand. There is no connection pool — each DAO gets its own. Close connections to avoid resource leaks. |
| 4 | `src/java/com/ctms/service/AccountService.java:32` | **Where business logic lives.** `verifyByEmail()` queries both EmployeeDAO and CustomerDAO to find a user and check their password — this logic doesn't belong in the Servlet or the DAO. |
| 5 | `src/java/com/ctms/dao/MovieDAO.java:17` | **How data is fetched.** `getAllMovies()` shows the DAO pattern: prepare SQL → execute → map ResultSet rows to domain objects → return list. |
| 6 | `src/java/com/ctms/model/Movie.java:6` | **What a domain object looks like.** A plain Java class with fields, a constructor, and getters/setters. No logic here — just data. |
| 7 | `src/java/com/ctms/controller/PaymentServlet.java:21` | **A complex multi-step operation.** Calls PaymentService which creates a Stripe PaymentIntent AND inserts a local DB record — two external systems in one flow. |
| 8 | `web/login.jsp:1` | **Where views live.** JSP files in `web/` are the UI. They post to Servlets and render data set in the request/session scope. |

## How we work
Work is async-first and tracked openly. Core hours are **10:00–15:00 local time** — outside that window, default to written communication.

- All work is tracked in **GitHub Issues**; every PR must link to an issue before review.
- **PRs stay under ~400 changed lines.** Larger work is split behind feature flags.
- Every PR needs **one approving review** and **green CI** before merge.
- Commit messages follow **Conventional Commits**: `feat:`, `fix:`, `chore:`.
- Cross-team decisions get a short **ADR** (Architecture Decision Record) in `docs/adr/`.
- **On-call** starts week 4, always paired for the first shift.

## Our values in your daily work
| Value | What it means in this codebase |
|---|---|
| Ship small, ship often | Break a new endpoint into focused PRs under 400 lines. If a feature needs a schema change, a service method, and a servlet — open them as separate sequential PRs behind a feature flag. |
| Quality is everyone's job | Write a JUnit test for every DAO and Service method you touch. The codebase has none yet; your first PR sets the standard. |
| Write it down | Add Javadoc to every public method you introduce. |
| Customer first, not customer only | Read the linked GitHub Issue before writing code. |
| Own it end to end | After your PR merges, watch CI and the deployment log. |

## People to meet
| Name | Role | Ask them for | How to reach |
|---|---|---|---|
| Priya Menon | Engineering Manager | Role expectations, 30-day goals | Not specified — ask your manager |
| Daniel Wong | Buddy | Day-to-day code questions, code tour walkthrough, weekly 30-min chat for 90 days | Not specified — ask your manager |
| IT Help | IT / Accounts | GitHub org invite, Bob IDE seat, VPN/SSO | it-help@northwindlabs.example |
| Team channel | Team (async) | Quick questions to the wider team | #eng-onboarding on northwindlabs.slack.com (then your squad channel) |

## Where things live
| Item | Location |
|---|---|
| Company handbook | `company/handbook.md` (this workspace) — ask manager for live link |
| Role spec | `roles/backend-engineer.md` (this workspace) |
| Codebase (CTMS) | github.com/northwind-labs (fictional org) |
| Dev tool | Bob IDE — install via bob.ibm.com |
| This onboarding pack | `onboarding/alex-tan.md` (this workspace) |

## Day-1 accounts & access
Owned by IT and your manager — not self-serve. Email **it-help@northwindlabs.example** on Day 1 to request:

- GitHub org invite (github.com/northwind-labs)
- Bob IDE account (bob.ibm.com)
- VPN / SSO credentials
- Slack workspace (northwindlabs.slack.com)

## Your first week
| Day | Focus |
|---|---|
| Day 1 | Laptop set up, accounts provisioned, local environment running, meet Priya and Daniel |
| Day 2–3 | Complete code tour stops 1–4, start Quick Win task, open your first PR |
| Day 4 | Continue code tour stops 5–8, start Collaborative task conversation with Daniel |
| Day 5 | 30-min check-in with Priya — what's confusing, what's missing; run through Week-1 checkpoints together |

## Starter tasks
### Task 1 — Quick win (Day 2–3)
**Fix the `genere` typo in the Movie model**

The `Movie` class has a misspelled field name (`genere` instead of `genre`) visible across the DAO, service, and JSP layers.

- **File:** `src/java/com/ctms/model/Movie.java:12`
- **Done when:** Rename field and all getters/setters; update all callers; movie list page still renders correctly.

### Task 2 — Collaborative task (Week 1)
**Refactor MovieDAO to centralise Movie object construction**

- **File:** `src/java/com/ctms/dao/MovieDAO.java`
- **Who to involve:** Daniel Wong.

### Task 3 — Real slice (Week 2)
**Implement `getShowtimesByMovieIdAndCinema()` service method**

- **Done when:** Method returns the correct filtered list; at least one unit test written for the service method.

## Week-1 checkpoints
Answer these by the end of day 5. Go through them with Priya in your check-in.

1. **Where is the Movie model defined and what fields does it hold?**
<details><summary>Answer</summary>

</details>
2. **How does MovieDAO fetch all movies from the database?**
3. **What does MovieService do differently from MovieDAO?**
4. **How does ViewMovieListServlet connect the Service layer to the web?**

## 30-day success
From the role file:

- **Local environment running without help.** → You can start Tomcat, connect to the dev DB, and see the CTMS app in your browser with no assistance.
- **3+ merged PRs, including one touching the data layer.** → At minimum: the typo fix, the DAO refactor, and the new showtime filter.
- **Has reviewed at least 5 PRs.** → Engage with teammates' PRs daily.
- **Can explain the request flow from API call to database and back.** → Walk through the login flow end-to-end with Priya on day 30.

## Sources
| Fact / claim | Source |
|---|---|
| Mission statement | `company/handbook.md` |
