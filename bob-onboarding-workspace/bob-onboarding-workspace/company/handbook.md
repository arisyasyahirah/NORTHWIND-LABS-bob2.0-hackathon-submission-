# Northwind Labs — Company Handbook (fictional sample)

> Fictional company for the IBM Bob 2.0 hackathon PoC. No real data.

## Mission
Make field-service logistics simple enough that a two-person team can run it from a phone.

## Values
1. **Ship small, ship often.** Small, reviewable changes beat big-bang releases.
2. **Quality is everyone's job.** Nobody "throws it over the wall" to QA.
3. **Write it down.** If it isn't documented, it doesn't exist.
4. **Customer first, not customer only.** Solve the real problem, not the loudest request.
5. **Own it end to end.** You build it, you ship it, you watch it in production.

## Ways of working
- Work is tracked in GitHub Issues; every PR links an issue.
- PRs stay under ~400 changed lines; bigger work is split behind feature flags.
- Every PR needs one approving review and green CI before merge.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `chore:`).
- Decisions that affect more than one team get a short ADR in `docs/adr/`.
- Core hours 10:00–15:00 local; async by default, meetings by exception.
- On-call rotation starts after week 4, always paired for the first shift.

## First-week norms
- Day 1: laptop, accounts, local environment running.
- Day 2–3: ship one small fix to production (a "first PR").
- Day 5: 30-min check-in with manager — what's confusing, what's missing from this handbook.

## Internal links & access (fictional, for this PoC)
- **GitHub org:** github.com/northwind-labs — the target codebase is chosen per run at intake.
- **Team chat:** northwindlabs.slack.com — start in `#eng-onboarding`, your team channel is named after your squad.
- **IT / accounts:** it-help@northwindlabs.example — provisions your GitHub org invite, Bob IDE seat, and VPN/SSO.
- **Dev tool:** Bob IDE — install via bob.ibm.com (real vendor, real install docs; everything else on this list is fictional for the PoC).
