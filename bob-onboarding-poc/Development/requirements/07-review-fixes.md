# 7. Second review: flaws and what we did (2026-09-26)

| Flaw | Action | Status |
|---|---|---|
| Evidence gap (no MCP server, no Bob session screenshots yet) | `BOB_PROMPTS.md` rewritten as an evidence plan: Bob reviews/hardens the scripts, builds the email MCP server, runs `/onboard` | **needs the user, in Bob** |
| Originality moderate | Lead the pitch with: personalisation per hire, issue scanning (one file per issue), newcomer-Bob context folder, deterministic citation check + approval gate. Not "we generate a pack" | wording, for statements/video |
| Client-data risk (real project path) | Path removed everywhere; project chosen per run and confirmed by `probe`. Demo target: public MIT repo `miguelgrinberg/microblog` (license verified via GitHub API: MIT, 83 KB, Python) | done |
| Business value asserted | `pipeline_tools.py time` gives per-stage and machine time (excl. human approval) vs `manual_hours`. Skill logs stages and runs it at the end | built; number needs a real run |
| PDF one-way | Accepted. `reply_to` = buddy. No Q&A loop (decided) | accepted |
| Extra deps / platform | Missing pycairo now gives an actionable message, selftest skips PDF tests with a warning, skill falls back to `pack.md`. Font defaults to Arial on Windows. No Windows path anywhere | done |
| Repo hygiene | Wikilinks in Research/ converted to relative links; vault path and local `/home/...` path removed; DECISION_ANCHOR date fixed; root `.gitignore` added | done |

Item 5 (newcomer delivery): user confirmed nothing further was intended. Closed.
