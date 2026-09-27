# ISSUE-003: Passwords Stored and Compared in Plain Text

Severity: critical
Category: security
Location: `src/java/com/ctms/service/AccountService.java:37-40`
Suggested timeline: 2026-10-19 → 2026-11-03

## Summary

Login authentication in AccountService.java at lines 37–40 compares the submitted password against the stored value using `.equals()` with no hashing. Passwords are persisted to and retrieved from the database as plain text. There is no BCrypt, Argon2, PBKDF2, or any other password-hashing mechanism anywhere in `AccountService`, `CustomerDAO`, or `EmployeeDAO`.

## Why it happens

No password-hashing library was included in `WEB-INF/lib` and no hashing step was introduced in the registration or login flow. The DAO `INSERT` statements write the raw password string, and the `SELECT` query returns it unchanged; the service layer then performs a direct string comparison.

## Impact

- A database breach (via SQL injection, a compromised DB host, or a backup leak) exposes every user's password in clear text.
- Because people reuse passwords, a single breach can compromise users' accounts on other services.
- Even with database access controls in place, internal actors (DBAs, ops staff) can read all passwords at any time.
- This may also constitute a compliance violation under PDPA (Thailand), GDPR, and similar data-protection regulations.

## Guidance to solve

1. **Add jBCrypt** (or Spring Security Crypto's `BCryptPasswordEncoder`) to `WEB-INF/lib` / pom.xml.
2. **Registration**: replace the plain-text `INSERT` with `BCrypt.hashpw(rawPassword, BCrypt.gensalt())` before persisting.
3. **Login**: replace the `.equals()` comparison with `BCrypt.checkpw(submitted, storedHash)`.
4. **Migrate existing rows**: write a one-off migration script that reads each plain-text password, hashes it, and updates the row. Run it once before deploying the new code.
5. Ensure `Customer.getPassword()` (see ISSUE-009) is removed so the hash is never needlessly loaded into the session object.

## How to verify

- A newly registered user's `cust_password` column in the database starts with `$2a$` (BCrypt prefix).
- `AccountService.verifyByEmail()` calls `BCrypt.checkpw()` and the login flow succeeds with the correct password.
- The login flow fails (cleanly, no exception) with an incorrect password.
- `grep -r "\.equals(.*password\|password.*\.equals(" src/` returns no matches in the authentication path.

## Related

- ISSUE-009: Customer Password Exposed in Session / Model Object (password in model/DAO should be removed after hashing fix)
- ISSUE-005: No Unit or Integration Tests (AccountService.verifyByEmail is a prime candidate for the first unit test)
