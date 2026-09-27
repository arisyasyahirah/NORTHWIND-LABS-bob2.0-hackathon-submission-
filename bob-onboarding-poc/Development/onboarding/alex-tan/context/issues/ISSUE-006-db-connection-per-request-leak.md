# ISSUE-006: Database Connection Per-Request Leak (No Connection Pool)

Severity: high
Category: performance
Location: `src/java/com/ctms/util/ConnectionDB.java:20-31`, `src/java/com/ctms/dao/CustomerDAO.java:14-16`, `src/java/com/ctms/dao/MovieDAO.java:12-14`
Suggested timeline: 2026-10-19 → 2026-11-03

## Summary

Every DAO constructor instantiates a new `ConnectionDB`, which opens a brand-new JDBC connection (a full TCP + TLS handshake to Supabase) for each incoming request. There is no connection pool (HikariCP, Apache DBCP, etc.) and no JNDI `DataSource` configured at the container level. Under concurrent load this rapidly exhausts the Supabase free-tier connection limit, causing new requests to fail.

## Why it happens

`ConnectionDB` was written as a simple utility wrapper with no awareness of pooling. Each DAO accepts a `ConnectionDB` object in its constructor and holds the connection for the duration of the request. No `ServletContextListener` or application-level singleton exists to manage a shared pool. Because the problem only manifests under concurrent load, it may not be obvious during single-user local testing.

## Impact

- Under concurrent users, the Supabase connection limit is reached and new connections are refused with a "too many clients already" error.
- Each connection establishment (TCP handshake + TLS negotiation + PostgreSQL authentication) adds 50–200 ms of latency to every request, even for simple queries.
- Connections may not be reliably closed if an exception is thrown mid-request, leading to slow connection leaks even at low traffic.
- As the application grows, this becomes the primary scalability bottleneck before any business logic is reached.

## Guidance to solve

1. **Add HikariCP** to `WEB-INF/lib` (or as a dependency). HikariCP is the fastest and simplest JDBC pool for Tomcat.
2. **Create a `DataSourceFactory`** (or a `ServletContextListener`) that initialises a single `HikariDataSource` at application startup, configured with `maximumPoolSize`, `connectionTimeout`, and the env-var credentials from ISSUE-001.
3. **Refactor DAOs** to accept a `DataSource` (or `Connection` retrieved from it) rather than instantiating `ConnectionDB` themselves. Each DAO method should obtain a connection from the pool at the start and return it (via `try-with-resources`) at the end.
4. **Remove `ConnectionDB`** once all DAOs are migrated; it is both the credential leak and the pooling problem.
5. Tackle ISSUE-001 and this issue together — the `DataSource` configuration is the natural place to inject credentials from environment variables.

## How to verify

- A load test (e.g., 50 concurrent users via Apache JMeter or k6) shows a stable, bounded number of active DB connections (≤ pool size).
- No "too many clients" or "connection refused" errors appear in Tomcat or Supabase logs during the load test.
- Response time per request drops noticeably compared to baseline (no per-request connection overhead).
- `grep -r "new ConnectionDB" src/` returns no results after migration.

## Related

- ISSUE-001: Hardcoded Database Credentials in Source Code (ConnectionDB.java is also the source of hardcoded credentials)
- ISSUE-005: No Unit or Integration Tests (write pool integration tests before and after this refactor)
