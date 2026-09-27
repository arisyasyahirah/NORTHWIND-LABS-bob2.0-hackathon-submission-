# Backend Engineer Role — CTMS_Project

> **For:** Alex Tan — Junior Backend Engineer  
> **Pipeline:** CTMS_Project Onboarding

---

## Team

You are on the **Platform team**, which owns the API layer and the data layer of every product Northwind Labs ships. In the CTMS_Project specifically, "the API and data layer" means the Java servlet controllers, the service classes, the DAO (Data Access Object) classes, and the database models — all the code that handles requests and talks to the database, before any HTML is produced.

---

## What the CTMS_Project Is

**CTMS** stands for Cinema Ticket Management System. It is a **Jakarta EE web application** (Java, JSP pages, Servlets) built with NetBeans and Apache Ant. It manages:

- Movies and their metadata (title, genre, rating, poster, trailer)
- Showtimes (which movie plays in which hall, and when)
- Customer bookings and seat selection
- Payments via the **Stripe** API
- Employee roles: staff, manager, and HQ (head-quarters) — each with different pages and permissions

The stack at a glance:

| Layer | Technology |
|---|---|
| Language | Java (Jakarta EE / Servlet API) |
| View | JSP (JavaServer Pages) + JSTL |
| Database | PostgreSQL, hosted on Supabase, connected via JDBC |
| Payments | Stripe Java SDK (stripe-java-32.1.0.jar) |
| HTTP client | OkHttp (okhttp-5.3.2.jar) |
| JSON | Gson (gson-2.14.0.jar) |
| Build tool | Apache Ant (`build.xml`) — **not Maven or Gradle** |

> **For juniors:** Jakarta EE is the standard Java platform for building web applications. A *Servlet* is a Java class that receives HTTP requests (GET, POST) and sends back responses. JSP (JavaServer Pages) is a templating system that lets you embed Java expressions in HTML. JDBC is the standard Java API for running SQL queries against a database.

---

## Package Structure — What You Own

All source code lives under `CTMS_Project/src/java/com/ctms/`. The packages you are directly responsible for are:

### com.ctms.controller — HTTP entry points
These are the **Servlet classes** that handle incoming HTTP requests. Each servlet maps to a URL defined in [`web/WEB-INF/web.xml`](../../../../../CTMS_Project/web/WEB-INF/web.xml). They read request parameters, call the service layer, then forward to a JSP or send a JSON response.

Key servlets you will work with most often:

| Servlet | URL mapping | Purpose |
|---|---|---|
| [`LoginServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/LoginServlet.java) | `/LoginServlet` | Authenticates customers and employees |
| [`HomeServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/HomeServlet.java) | `/HomeServlet` | Landing page data |
| [`ViewMovieListServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/ViewMovieListServlet.java) | `/ViewMovieListServlet` | Public movie listing |
| [`ViewMovieDetailServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/ViewMovieDetailServlet.java) | `/ViewMovieDetailServlet` | Single movie detail page |
| [`AddNewMovieServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/AddNewMovieServlet.java) | `/AddNewMovieServlet` | Admin: create a new movie |
| [`UpdateMovieServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/UpdateMovieServlet.java) | `/UpdateMovieServlet` | Admin: edit a movie |
| [`DeleteMovieServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/DeleteMovieServlet.java) | `/DeleteMovieServlet` | Admin: remove a movie |
| [`ShowtimeServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/ShowtimeServlet.java) | `/ShowtimeServlet` | List showtimes |
| [`AddShowtimeServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/AddShowtimeServlet.java) | `/AddShowtimeServlet` | Create a showtime |
| [`UpdateShowtimeServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/UpdateShowtimeServlet.java) | `/UpdateShowtimeServlet` | Edit a showtime |
| [`DeleteShowtimeServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/DeleteShowtimeServlet.java) | `/DeleteShowtimeServlet` | Remove a showtime |
| [`BookingScheduleServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/BookingScheduleServlet.java) | `/BookingScheduleServlet` | Customer booking flow |
| [`PaymentServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/PaymentServlet.java) | `/PaymentServlet` | Initiates a Stripe payment intent |
| [`WebhookServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/WebhookServlet.java) | `/WebhookServlet` | Receives Stripe webhook events |
| [`RegisterServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/RegisterServlet.java) | `/RegisterServlet` | Customer registration |
| [`ProfileServlet`](../../../../../CTMS_Project/src/java/com/ctms/controller/ProfileServlet.java) | `/profileServlet` | View/edit customer profile |

### com.ctms.service — Business logic
Service classes sit between the controller and the database. They contain the *rules* of the application: validating input, orchestrating multiple DAO calls, calling external APIs (Stripe). A controller should never query the database directly — it calls a service instead.

Key service classes:

- [`AccountService`](../../../../../CTMS_Project/src/java/com/ctms/service/AccountService.java) — login, registration, profile management
- [`MovieService`](../../../../../CTMS_Project/src/java/com/ctms/service/MovieService.java) — movie CRUD logic
- [`ShowtimeService`](../../../../../CTMS_Project/src/java/com/ctms/service/ShowtimeService.java) — showtime scheduling logic
- [`PaymentService`](../../../../../CTMS_Project/src/java/com/ctms/service/PaymentService.java) — creates Stripe `PaymentIntent` objects, stores results via `PaymentDAO`
- [`MenuService`](../../../../../CTMS_Project/src/java/com/ctms/service/MenuService.java) — food/menu management

> ⚠️ **Credential warning:** `PaymentService` contains a hardcoded Stripe secret key at [PaymentService.java:19](../../../../../CTMS_Project/src/java/com/ctms/service/PaymentService.java). Do not copy, log, or commit this value. Raise moving it to an environment variable as a task with your manager.

### com.ctms.dao — Database access
DAO (Data Access Object) classes are the **only** place that SQL runs. Each DAO corresponds to one database table or domain entity and performs CRUD operations using JDBC `PreparedStatement`s.

| DAO | Manages |
|---|---|
| [`CustomerDAO`](../../../../../CTMS_Project/src/java/com/ctms/dao/CustomerDAO.java) | `customer` table — accounts, login lookup |
| [`EmployeeDAO`](../../../../../CTMS_Project/src/java/com/ctms/dao/EmployeeDAO.java) | `employee` table — staff/manager/HQ accounts |
| [`MovieDAO`](../../../../../CTMS_Project/src/java/com/ctms/dao/MovieDAO.java) | `movie` table — film catalogue |
| [`ShowtimeDAO`](../../../../../CTMS_Project/src/java/com/ctms/dao/ShowtimeDAO.java) | `showtime` table — scheduling |
| [`FoodDAO`](../../../../../CTMS_Project/src/java/com/ctms/dao/FoodDAO.java) | `food` table — concession menu |
| [`PaymentDAO`](../../../../../CTMS_Project/src/java/com/ctms/dao/PaymentDAO.java) | `payment` table — Stripe payment records |

Database connections are opened via [com.ctms.util.ConnectionDB](../../../../../CTMS_Project/src/java/com/ctms/util/ConnectionDB.java).

> ⚠️ **Credential warning:** `ConnectionDB` contains hardcoded database credentials (JDBC URL, username, and password) at [`ConnectionDB.java:8–15`](../../../../../CTMS_Project/src/java/com/ctms/util/ConnectionDB.java). Never copy or share these values. This is a known issue to raise with your manager on Day 1.

### com.ctms.model — Data objects
Plain Java classes (no logic, just fields + getters/setters) that represent database rows. These are passed between layers.

| Model | Represents |
|---|---|
| [`Customer`](../../../../../CTMS_Project/src/java/com/ctms/model/Customer.java) | A registered customer (id, email, name, phone) |
| [`Employee`](../../../../../CTMS_Project/src/java/com/ctms/model/Employee.java) | A cinema employee (staff, manager, or HQ) |
| [`Movie`](../../../../../CTMS_Project/src/java/com/ctms/model/Movie.java) | A film (title, duration, genre, rating, poster, banner) |
| [`Showtime`](../../../../../CTMS_Project/src/java/com/ctms/model/ShowTime.java) | A scheduled screening (movieId, hallId, date, startTime, endTime) |
| [`Food`](../../../../../CTMS_Project/src/java/com/ctms/model/Food.java) | A concession item |
| [`Payment`](../../../../../CTMS_Project/src/java/com/ctms/model/Payment.java) | A Stripe payment record (paymentId, clientSecret, amount, currency, status) |

### com.ctms.dto — Data Transfer Objects
DTOs are lightweight objects used to carry data between layers when the full model would carry too much (or the wrong shape of) data. For example, [`ShowtimeHallDTO`](../../../../../CTMS_Project/src/java/com/ctms/dto/ShowtimeHallDTO.java) combines showtime and hall information in one object for the booking schedule view.

### com.ctms.filter — Request filters
Jakarta EE `Filter` classes that run *before* a request reaches its servlet. The two filters protect pages by role:

- [`AuthFilter`](../../../../../CTMS_Project/src/java/com/ctms/filter/AuthFilter.java) — checks the user's session `userType` attribute against a required role (`employee` or `customer`). Redirects to login.jsp if the check fails.
- [`LoginFilter`](../../../../../CTMS_Project/src/java/com/ctms/filter/LoginFilter.java) — related login-state guard.

Role protection is configured in [web.xml](../../../../../CTMS_Project/web/WEB-INF/web.xml): `/employee/*` requires role `employee`; /customer/profile.jsp requires role `customer`.

### com.ctms.util — Utilities
- [`ConnectionDB`](../../../../../CTMS_Project/src/java/com/ctms/util/ConnectionDB.java) — opens and closes a JDBC `Connection` to the PostgreSQL database on Supabase. Every DAO instantiates one of these.
- [`TimeUtil`](../../../../../CTMS_Project/src/java/com/ctms/util/TimeUtil.java) — date/time helper methods.

---

## How a Request Flows Through the System

Understanding this flow is a key 30-day milestone. Here is an example for a customer loading the movie listing:

```
Browser GET /ViewMovieListServlet
    ↓
ViewMovieListServlet.doGet()          ← com.ctms.controller
    ↓
MovieService.getAllMovies()            ← com.ctms.service
    ↓
MovieDAO.findAll() → SQL SELECT        ← com.ctms.dao
    ↓
ConnectionDB.getConnection() → JDBC   ← com.ctms.util
    ↓  (PostgreSQL on Supabase)
ResultSet → List<Movie>               ← com.ctms.model
    ↑ back up through service/controller
    ↓
request.setAttribute("movies", list)
    ↓
RequestDispatcher → movieList.jsp     ← web/movieList.jsp (JSP view)
    ↓
HTML response to browser
```

For payments, the flow additionally calls out to the **Stripe API** (via `PaymentService`) and receives asynchronous confirmation back through the **Stripe webhook** at `WebhookServlet`.

---

## Your Responsibilities

From the role definition (`roles/backend-engineer.md`):

1. **REST-style servlet endpoints** — adding, fixing, and maintaining com.ctms.controller servlets
2. **Database schema changes and migrations** — any time a model or DAO changes, the underlying PostgreSQL schema must be updated consistently; keep track of what changed and why
3. **Unit and integration tests** — write tests that cover service and DAO logic; ask your buddy about the current test setup on Day 1
4. **PR reviews** — review teammates' pull requests within 1 working day of request
5. **On-call** — paired on-call starts in week 4; you will shadow first

---

## Practical Notes for Week 1

- The build tool is **Apache Ant** (`build.xml`), not Maven or Gradle. Open the project in **NetBeans** for the smoothest experience; it uses the `nbproject/` configuration files.
- There is currently **no git remote** configured. Ask your buddy how source control is handled for this project.
- Database credentials and the Stripe secret key are currently **hardcoded in source files** (see warnings above). Treat them as sensitive — do not paste them anywhere, and flag the issue to your manager on Day 1.
- The `web/WEB-INF/lib/mysql-connector-j-9.6.0.jar` is present in the lib folder but the codebase uses PostgreSQL, not MySQL. This is an existing artefact; do not add MySQL-specific code.

---

## Success After 30 Days

You are on track if you can say yes to all of the following:

- [ ] Local development environment starts without asking for help
- [ ] 3 or more PRs merged, including at least one that touches the data layer (a DAO class or a schema change)
- [ ] 5 or more PR reviews completed on teammates' changes
- [ ] Can explain the request flow — from HTTP request through controller → service → DAO → database → response — in your own words, using a real example from the CTMS codebase
