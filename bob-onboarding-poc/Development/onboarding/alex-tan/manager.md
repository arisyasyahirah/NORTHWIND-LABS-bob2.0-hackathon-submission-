# Before Alex Tan starts on 2026-10-05

1. Read flagged.md and the issue INDEX first (2 min). Correct or fill any gaps you spot.
2. Day-1 talk: set role expectations — Alex joins as a Junior Backend Engineer on the Platform team, owning the servlet/service/DAO layer of CTMS_Project. Emphasise the three critical security issues (ISSUE-001, ISSUE-002, ISSUE-003) and that credential rotation is a Day-1 action.
3. Buddy confirmed: Daniel Wong. Weekly 30-min chat for 90 days; walk the code tour (pack.md "Code tour" section) together in week 1.
4. Introductions for the collaborative task (ISSUE-007 + starter task 2): introduce Alex to whoever owns the Tomcat deployment pipeline, and to the team that reviews PRs for `web/WEB-INF/`.
5. Checkpoints together on 2026-10-11 (end of Phase 1); phase check-ins on 2026-11-03, 2026-12-03, 2027-01-03. Expected end: 2027-01-03.

## Access checklist (provision before Day 1)

- [ ] GitHub invite to github.com/northwind-labs
- [ ] Slack workspace invite (northwindlabs.slack.com)
- [ ] Bob IDE seat (bob.ibm.com)
- [ ] VPN/SSO credentials
- [ ] Tomcat/staging environment access

## Notes for manager

- No git remote is configured in CTMS_Project. Confirm the source control workflow with Alex on Day 1.
- The JDK version required by the project was not found in any config file. Confirm the JDK version for the development machine.
- Three hardcoded credential sets need rotation as soon as possible (ISSUE-001, ISSUE-002). Coordinate with whoever holds those secrets before Alex's first day.
- The role definition (`roles/backend-engineer.md`) was written for a generic backend engineer. The CTMS-specific responsibilities are covered in `context/role.md`. Review both before the Day-1 talk.
