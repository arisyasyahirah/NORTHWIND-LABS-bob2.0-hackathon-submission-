# ISSUE-001: Hardcoded Database Credentials in Source Code

Severity: critical
Category: security
Location: `src/java/com/ctms/util/ConnectionDB.java:8-15`
Suggested timeline: 2026-10-12 → 2026-10-19

## Summary

The JDBC URL, username, and password are hardcoded as `static final` string literals in ConnectionDB.java at lines 8–15. **Do not copy or log the credential values** — reference the file and line numbers only. These values are compiled directly into the deployed JAR, making them trivially extractable by anyone with access to the artifact or repository.

## Why it happens

There is no environment variable or config-file injection pattern in place. The fields are declared as compile-time constants rather than values resolved at runtime from `System.getenv()`, a properties file, or a JNDI `DataSource`. Because Java `static final` fields are inlined by the compiler, the credentials also appear as plain strings in the bytecode of any class that references them.

## Impact

- Any developer, contractor, or CI runner with read access to the source repository can extract the live database credentials.
- Credentials cannot be rotated without editing the source, rebuilding, and redeploying the application.
- If the repository is ever made public or leaked, the database is immediately compromised.

## Guidance to solve

1. **Remove the hardcoded literals** from ConnectionDB.java.
2. Read credentials at runtime using `System.getenv("DB_URL")`, `System.getenv("DB_USER")`, and `System.getenv("DB_PASSWORD")`.
3. Preferred alternative: configure a JNDI `DataSource` in context.xml (Tomcat) and look it up via `InitialContext`; this keeps credentials outside the WAR entirely.
4. Add the relevant env-var names to .env.example (no values) so developers know what to set locally.
5. After the fix, **rotate the database credentials** immediately — treat the old values as compromised.
6. Add `.env` and `*.properties` (with secrets) to `.gitignore` to prevent future accidents.

## How to verify

- Running `grep -r "jdbc:" src/` returns no results.
- Running `grep -r "DB_" src/` shows only `System.getenv(...)` calls, never string literals containing a host or password.
- The application starts and connects to the database using only values supplied via environment variables or JNDI, with no credentials in source or bytecode.

## Related

- ISSUE-002: Hardcoded Stripe API Key and Webhook Secret (same root pattern)
- ISSUE-006: Database Connection Per-Request Leak (ConnectionDB.java is also the source of the pooling problem)
- ISSUE-009: Customer Password Exposed in Session / Model Object (broader credentials/secrets hygiene)
