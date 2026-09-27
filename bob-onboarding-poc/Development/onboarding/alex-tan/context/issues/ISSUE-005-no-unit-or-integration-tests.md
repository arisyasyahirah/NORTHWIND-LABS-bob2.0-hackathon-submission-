# ISSUE-005: No Unit or Integration Tests in the Repository

Severity: high
Category: tests
Location: `src/java/com/ctms/` (no test directories found)
Suggested timeline: 2026-10-19 → 2026-11-03

## Summary

The repository contains no test classes whatsoever. There are no JUnit or Mockito JARs in `WEB-INF/lib`, no test source directories (e.g., `src/test/`), and no test targets in `build.xml`. Every code path — DAOs, services, filters, and servlets — runs entirely without automated verification.

## Why it happens

Tests were never written during initial development; no test framework was configured in the build system. Without a configured test target or directory convention, the absence of tests is not immediately visible as a problem in day-to-day development.

## Impact

- Regressions introduced during feature development or bug-fixing go undetected until they reach production.
- Onboarding engineers (including Alex) have no automated safety net when making changes to DAOs or service classes — a breaking change may not be caught until manual testing.
- The SQL bug in ISSUE-004 (`DELETE FROM TABLE`) is a direct example of a defect that a single unit test would have caught before it was ever committed.
- Refactoring the connection pooling (ISSUE-006) or password hashing (ISSUE-003) without tests is high-risk.

## Guidance to solve

1. **Add JUnit 5** (`junit-jupiter-api`, `junit-jupiter-engine`) and **Mockito** to `WEB-INF/lib` or as Maven/Gradle dependencies.
2. **Configure a test target** in `build.xml` (or migrate to Maven/Gradle) that compiles and runs tests under `src/test/java/`.
3. **Prioritise these first tests** (good onboarding tasks for Phase 2):
   - `CustomerDAOTest`: mock the `Connection` / `PreparedStatement` and verify that `deleteCustomer` sends `"DELETE FROM customer WHERE cust_id = ?"` (validates the ISSUE-004 fix).
   - `AccountServiceTest`: verify that `verifyByEmail` calls `BCrypt.checkpw()` after the ISSUE-003 fix.
   - `MovieDAOTest`: verify basic CRUD SQL strings are well-formed.
4. **Add integration tests** in Phase 3 using an in-memory H2 database or a Testcontainers PostgreSQL container to exercise the full DAO→DB round-trip.
5. Enforce tests in CI so that the build fails if tests are absent or red.

## How to verify

- `ant test` (or `mvn test` / `gradle test`) runs without errors and prints a green summary.
- At least one test exists for each of `AccountService`, `CustomerDAO`, and `MovieDAO`.
- A coverage report (JaCoCo or equivalent) shows meaningful coverage of the service and DAO layers.

## Related

- ISSUE-004: SQL Syntax Bug in CustomerDAO.deleteCustomer (first recommended test target)
- ISSUE-003: Passwords Stored and Compared in Plain Text (AccountService test validates the hashing fix)
- ISSUE-006: Database Connection Per-Request Leak (pooling refactor is safer with tests in place first)
