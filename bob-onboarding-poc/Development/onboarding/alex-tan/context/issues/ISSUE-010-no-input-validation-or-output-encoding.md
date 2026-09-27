# ISSUE-010: No Input Validation or Output Encoding on JSP Pages

Severity: medium
Category: security
Location: `web/register.jsp`, `web/login.jsp`, servlet request.getParameter calls in controllers
Suggested timeline: 2026-11-04 → 2026-11-17

## Summary

Request parameters are taken directly from `request.getParameter()` and passed to DAO methods without any length, format, or content validation. JSP output pages do not consistently use `<c:out value="${...}"/>` or `fn:escapeXml()` to encode user-supplied data before rendering it in HTML. Both omissions are present in the reviewed files: `web/register.jsp`, `web/login.jsp`, and the corresponding servlet controllers.

## Why it happens

No validation utility or filter was established during initial development. The JSTL escaping pattern (`<c:out>`, `fn:escapeXml`) was not adopted as a convention, and no code review checklist enforced it. Because the application works correctly for well-formed inputs, the risk is invisible during normal development and testing.

## Impact

- **Cross-Site Scripting (XSS)**: a user who submits a script tag (e.g., `<script>alert(1)</script>`) as their name at registration will have that string stored in the database. If it is rendered unescaped in any JSP, it executes in the browser of any user viewing that page — including staff/admin pages.
- **Database errors / DoS via oversized input**: without length validation, a client can submit a string far exceeding the database column size, causing an unhandled `SQLException` and a 500 error.
- **Data integrity**: without format validation (e.g., email regex, numeric ID checks), malformed data can be persisted, breaking downstream queries.

## Guidance to solve

1. **Add a `ValidationUtil` class** with static methods that check:
   - String length against the database column limits (e.g., `name` ≤ 100 chars, `email` ≤ 255 chars).
   - Email format via `^[^@\s]+@[^@\s]+\.[^@\s]+$` or Apache Commons Validator.
   - Numeric IDs are actually numeric (Integer.parseInt with error handling).
2. **Call `ValidationUtil`** at the top of each `doPost` method in the servlet controllers, returning a 400 or re-displaying the form with an error message if validation fails.
3. **Replace bare `${expression}` in JSPs** with `<c:out value="${expression}"/>` or `${fn:escapeXml(expression)}` for every output of user-supplied data. Ensure the JSTL taglib declarations are present at the top of each affected JSP.
4. Set the `<error-page>` entries in web.xml for 400, 404, and 500 to custom error JSPs so that stack traces are never shown to end users.

## How to verify

- Submit `<script>alert('xss')</script>` as the first name field at registration. Any page that subsequently displays that value must render it as escaped HTML text, not execute it.
- Submit a string of 10,000 characters in the email field; the server returns a 400 with a validation error, not a 500.
- Submit `abc` as a numeric customer ID in a URL parameter; the server returns a 400 or 404, not a 500 `NumberFormatException`.
- Review all JSPs: `grep -r "\${" web/` — every occurrence that outputs user data must be wrapped in `<c:out>` or `fn:escapeXml`.

## Related

- ISSUE-008: AuthFilter Does Not Handle Null Session Attribute Safely (same request-security layer)
- ISSUE-003: Passwords Stored and Compared in Plain Text (validation on password length/complexity is a natural addition)
- ISSUE-005: No Unit or Integration Tests (validation logic is highly unit-testable)
