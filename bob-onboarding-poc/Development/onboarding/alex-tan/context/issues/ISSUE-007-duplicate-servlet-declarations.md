# ISSUE-007: Duplicate Servlet Declarations in web.xml

Severity: medium
Category: maintainability
Location: `web/WEB-INF/web.xml:4-7`, `web/WEB-INF/web.xml:133-147`
Suggested timeline: 2026-10-12 → 2026-10-19

## Summary

`PaymentServlet` and `WebhookServlet` are each declared twice in web.xml — once near the top of the file (lines 4–7) and again at lines 133–147. The Jakarta EE Servlet specification forbids duplicate `<servlet-name>` entries within the same deployment descriptor. The actual runtime behaviour when duplicates are present is container-dependent: lenient containers silently use the last declaration, while strict containers (and Jakarta EE compliance checkers) reject the deployment entirely.

## Why it happens

The duplicate entries are a copy-paste error introduced when the payment servlets were added to the project. Because Tomcat's default mode is relatively lenient, the duplication did not cause an immediate deployment failure, making it easy to miss.

## Impact

- On strict or updated containers the application may fail to deploy, producing a "duplicate servlet-name" error.
- Even on lenient containers, the effective configuration is ambiguous: servlet-mapping and init-param values in the second declaration may silently override the first without any warning.
- As the file grows, the duplicates add noise and make it harder to audit which servlets are registered and under what URLs.

## Guidance to solve

1. Open `web/WEB-INF/web.xml` and compare the two sets of declarations for `PaymentServlet` and `WebhookServlet`.
2. Keep the authoritative declaration (confirm class names and `<servlet-mapping>` entries are correct) and **remove the duplicate block at lines 133–147**.
3. Validate the final web.xml against the Jakarta EE schema using an XML validator or by running `xmllint --schema servlet-4_0.xsd web/WEB-INF/web.xml`.
4. Redeploy and confirm no warnings are emitted in the Tomcat startup log.

## How to verify

- `grep -c "PaymentServlet" web/WEB-INF/web.xml` returns `1` (inside a `<servlet-class>` element).
- `grep -c "WebhookServlet" web/WEB-INF/web.xml` returns `1`.
- Tomcat deploys the application cleanly with no `WARN` or `SEVERE` messages related to servlet declarations.
- Payment and webhook endpoints respond correctly after the cleanup.

## Related

- ISSUE-002: Hardcoded Stripe API Key and Webhook Secret (`WebhookServlet` is the same file affected by the credential issue)
