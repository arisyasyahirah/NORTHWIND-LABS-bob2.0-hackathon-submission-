# Flagged items — Alex Tan onboarding

Review these before approving. Correct or accept each one.

- **Role definition is generic:** The role file (`roles/backend-engineer.md`) describes a generic backend engineer. It was used as-is since no CTMS-specific role file exists. The CTMS-specific responsibilities are drafted in `context/role.md` and marked accordingly. Verify the responsibilities and 30-day success criteria match what is actually expected of Alex.

- **No git remote configured:** The CTMS_Project has no git remote (`git remote: none`). The source control workflow is unknown — how code is reviewed and merged could not be determined from the codebase. All references to GitHub Issues and PRs in `pack.md` are taken from the Northwind Labs handbook, not from the CTMS project directly. The manager should confirm the actual workflow before Alex's first day.

- **JDK and Tomcat versions unknown:** Neither the required JDK version nor the Tomcat version is specified anywhere in the project files. Alex will need to ask their buddy on day one.

- **Three hardcoded credential sets:** `src/java/com/ctms/util/ConnectionDB.java:8-15` (DB), `src/java/com/ctms/service/PaymentService.java:19` (Stripe key), `src/java/com/ctms/controller/WebhookServlet.java:19` (webhook secret) are all hardcoded in source. These are classified as ISSUE-001 and ISSUE-002 (both critical). Rotation must happen before Alex has source access. The issues are flagged and documented; the manager must coordinate with whoever holds these secrets.

- **LoginFilter purpose unknown:** `src/java/com/ctms/filter/LoginFilter.java` exists in the codebase but was not readable during the scan (its role and registration could not be confirmed). Marked "Unknown — ask your buddy" in architecture.md.

- **Video script: 10 scenes, about 107 s of narration; flow scenes will show code from the target repo (credential-looking lines are masked).** The narration does not mention any Unknown or Draft items — it relies only on confirmed findings.
