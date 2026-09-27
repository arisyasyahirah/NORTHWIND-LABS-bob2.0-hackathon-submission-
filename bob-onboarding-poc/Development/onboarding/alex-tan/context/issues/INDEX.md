# Issues
| ID | Title | Severity | Category | Location | Timeline |
|---|---|---|---|---|---|
| [ISSUE-001](ISSUE-001-hardcoded-database-credentials.md) | Hardcoded Database Credentials in Source Code | critical | security | `src/java/com/ctms/util/ConnectionDB.java:8-15` | 2026-10-12 → 2026-10-19 |
| [ISSUE-002](ISSUE-002-hardcoded-stripe-api-key.md) | Hardcoded Stripe API Key and Webhook Secret | critical | security | `src/java/com/ctms/service/PaymentService.java:19`, `src/java/com/ctms/controller/WebhookServlet.java:19` | 2026-10-12 → 2026-10-19 |
| [ISSUE-003](ISSUE-003-passwords-stored-in-plain-text.md) | Passwords Stored and Compared in Plain Text | critical | security | `src/java/com/ctms/service/AccountService.java:37-40` | 2026-10-19 → 2026-11-03 |
| [ISSUE-004](ISSUE-004-sql-bug-deletecustomer.md) | SQL Syntax Bug in CustomerDAO.deleteCustomer | high | bug | `src/java/com/ctms/dao/CustomerDAO.java:105` | 2026-10-05 → 2026-10-11 |
| [ISSUE-005](ISSUE-005-no-unit-or-integration-tests.md) | No Unit or Integration Tests in the Repository | high | tests | `src/java/com/ctms/` (no test directories found) | 2026-10-19 → 2026-11-03 |
| [ISSUE-006](ISSUE-006-db-connection-per-request-leak.md) | Database Connection Per-Request Leak (No Connection Pool) | high | performance | `src/java/com/ctms/util/ConnectionDB.java:20-31`, `src/java/com/ctms/dao/CustomerDAO.java:14-16`, `src/java/com/ctms/dao/MovieDAO.java:12-14` | 2026-10-19 → 2026-11-03 |
| [ISSUE-007](ISSUE-007-duplicate-servlet-declarations.md) | Duplicate Servlet Declarations in web.xml | medium | maintainability | `web/WEB-INF/web.xml:4-7`, `web/WEB-INF/web.xml:133-147` | 2026-10-12 → 2026-10-19 |
| [ISSUE-008](ISSUE-008-authfilter-null-session-attribute.md) | AuthFilter Does Not Handle Null Session Attribute Safely | medium | bug | `src/java/com/ctms/filter/AuthFilter.java:41-50` | 2026-10-19 → 2026-11-03 |
| [ISSUE-009](ISSUE-009-customer-password-in-session.md) | Customer Password Exposed in Session / Model Object | medium | security | `src/java/com/ctms/model/Customer.java:14-21`, `src/java/com/ctms/dao/CustomerDAO.java:36` | 2026-10-19 → 2026-11-03 |
| [ISSUE-010](ISSUE-010-no-input-validation-or-output-encoding.md) | No Input Validation or Output Encoding on JSP Pages | medium | security | `web/register.jsp`, `web/login.jsp`, servlet request.getParameter calls in controllers | 2026-11-04 → 2026-11-17 |
