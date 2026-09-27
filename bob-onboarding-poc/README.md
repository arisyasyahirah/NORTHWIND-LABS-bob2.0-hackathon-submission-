# IBM Bob 2.0 Hackathon — Onboarding Pack PoC

Status: **v2 built and run end-to-end in Bob (2026-09-27): PDF + tour video + context zip emailed via the onboarding-mail MCP server to a test inbox.**


## Structure

- **[Research/](Research/)** — everything backing the design decisions: hackathon rules, the onboarding-effectiveness literature (papers + industry articles, international → SEA → Malaysia), the solutions-mapping across 5 patterns, and the LACY deep dive that anchors the whole approach.
- **[Research/channel-comparison/](Research/channel-comparison/)** — evidence for email vs email+PDF vs email+PDF+video+context .md (one file each + `04-synthesis.md` with the recurring patterns; gaps and untested hypotheses flagged).
- **[Development/](Development/)** — the build. v2 pipeline: `/onboard` skill (`.bob/skills/onboarding-pipeline`), helper scripts (timeline, checks, install-deps, PDF via a pycairo brochure kit, optional narrated tour video via Piper + ffmpeg), and `requirements/` capturing the v2 asks. Architecture: the workspace root is a generic core (no client data); client specifics live in `Development/instances/<client>/` and reach the pipeline via intake. Also: `mcp/onboarding-mail/` (stdlib STDIO MCP email server, 14 tests), `scripts/send_via_mcp.py`, `bob_sessions/` (run summary), `requirements/12-channel-research.md` (short cover-note email, flow-focused video, narration-redundancy check). `onboarding/` run output is gitignored. `/build-pipeline` (skill `build-onboarding-pipeline`) rebuilds/extends the workspace from the spec or scaffolds a new `instances/<client>/`.

## Next step
Add real Bob session screenshots to `Development/bob_sessions/`, then finish the hackathon submission.

## Note on Research/
These are the working notes behind the design decisions, bundled so the repo is self-contained.
