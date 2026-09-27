# ISSUE-009: Customer Password Exposed in Session / Model Object

Severity: medium
Category: security
Location: `src/java/com/ctms/model/Customer.java:14-21`, `src/java/com/ctms/dao/CustomerDAO.java:36`
Suggested timeline: 2026-10-19 → 2026-11-03

## Summary

The `Customer` model (Customer.java lines 14–21) includes a `cust_password` field with a `getPassword()` accessor. CustomerDAO.java at line 36 uses `SELECT *` (or an equivalent projection that includes `cust_password`), loading the password column into the `Customer` object, which is then stored in the HTTP session. This means the plain-text password (or, after ISSUE-003 is fixed, the password hash) travels from the database into every session object for every logged-in customer.

## Why it happens

The `Customer` class was modelled as a direct mirror of the database table without distinguishing between fields needed for authentication versus fields needed for the application session. The `SELECT *` pattern in the DAO pulls all columns indiscriminately, and no projection or DTO pattern is used to strip sensitive fields before the object is stored in the session.

## Impact

- The plain-text password (pre-ISSUE-003 fix) is held in memory in every active session and is serialisable to disk if Tomcat session persistence is enabled — a session file or heap dump exposes all active users' passwords.
- Even after ISSUE-003 is fixed and the field contains a BCrypt hash, leaking the hash is undesirable: it provides an offline brute-force target and confirms the hashing algorithm.
- Any logging framework, debug endpoint, or monitoring tool that serialises the session or calls `toString()` on the `Customer` object may inadvertently log the password or hash.

## Guidance to solve

1. **After ISSUE-003 is fixed**, create a session DTO (e.g., `CustomerSession`) that contains only the fields needed post-login (e.g., `custId`, `name`, `email`, `membershipType`) — no password field.
2. Update `CustomerDAO` to use an explicit column list in its `SELECT` statement that excludes `cust_password`, and map to the `CustomerSession` DTO.
3. Remove `getPassword()` and the `cust_password` field from Customer.java (or from whatever object is stored in the session).
4. Keep Customer.java (with the password field) only for the authentication query path, and discard it immediately after `BCrypt.checkpw()` succeeds — do not store it in the session.

## How to verify

- After login, retrieve the session attribute and confirm it is a `CustomerSession` (or equivalent) object with no `password` field.
- `session.getAttribute("customer").getPassword()` (or equivalent) does not compile / does not exist.
- A heap dump of a running instance shows no plain-text passwords or BCrypt hashes in session objects.
- `grep "getPassword" src/java/com/ctms/` returns only the authentication-specific code path, not any session-storage path.

## Related

- ISSUE-003: Passwords Stored and Compared in Plain Text (must be fixed first; this issue refines the post-fix state)
- ISSUE-001: Hardcoded Database Credentials in Source Code (broader credentials hygiene)
