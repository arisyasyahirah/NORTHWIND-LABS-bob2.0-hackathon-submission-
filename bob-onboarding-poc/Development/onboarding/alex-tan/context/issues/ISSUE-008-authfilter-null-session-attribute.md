# ISSUE-008: AuthFilter Does Not Handle Null Session Attribute Safely

Severity: medium
Category: bug
Location: `src/java/com/ctms/filter/AuthFilter.java:41-50`
Suggested timeline: 2026-10-19 → 2026-11-03

## Summary

In AuthFilter.java at line 42, the `userType` attribute is read from the current session. The `loggedIn` check at line ~43 only verifies that the `"email"` attribute is present in the session. If a session exists with `"email"` set but without a `"userType"` attribute, `userType` will be `null`, and the comparison at line 49 — `!requiredRole.equals(userType)` — will throw a `NullPointerException`, producing a 500 Internal Server Error instead of a clean redirect to the login page.

## Why it happens

The guard condition checks only `"email"` to determine whether a user is logged in, but does not verify that `"userType"` is also present. Because `userType` is the receiver of the `.equals()` call in the wrong orientation (`!requiredRole.equals(userType)` is actually safer if `requiredRole` is never null — but the inverse `!userType.equals(requiredRole)` would NPE), the bug is subtle. If the current code reads `userType.equals(...)` at line 49, a null `userType` will NPE regardless of orientation.

## Impact

- Any HTTP request where the session contains `"email"` but not `"userType"` (e.g., a partially initialised session after a login failure or session tampering) results in an unhandled `NullPointerException`.
- The 500 error reveals stack trace information to the browser if Tomcat is running in development mode, which can aid an attacker in enumerating internal class names.
- The user receives no actionable feedback — they see a 500 error page instead of being redirected to log in again.

## Guidance to solve

1. After reading `userType` from the session, add an explicit null-guard:

   ```java
   String userType = (String) session.getAttribute("userType");
   if (userType == null) {
       response.sendRedirect(request.getContextPath() + "/login.jsp");
       return;
   }
   ```

2. Ensure the `.equals()` comparison is in the safe orientation: `requiredRole.equals(userType)` (constant on the left) to tolerate any remaining null path.
3. Review the login servlet to confirm that `"userType"` is always set in the session immediately after a successful login, so the null state cannot arise from a valid login flow.

## How to verify

- Manually create a session with `"email"` set but `"userType"` absent (e.g., via a browser developer tool or a test harness) and make a request to a protected URL.
- The request results in a redirect to login.jsp with an HTTP 302, not a 500 error.
- No `NullPointerException` appears in the Tomcat logs during the test.

## Related

- ISSUE-010: No Input Validation or Output Encoding on JSP Pages (AuthFilter is part of the same request-security layer)
- ISSUE-005: No Unit or Integration Tests (AuthFilter logic is a good candidate for a filter unit test)
