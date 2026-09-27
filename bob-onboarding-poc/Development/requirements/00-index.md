# v2 requirements — index

Source: review of the v1 onboarding pipeline (2026-09-26). Each item has its own file so nothing gets lost. Status is updated as work lands.

| # | Ask | File | Status |
|---|-----|------|--------|
| 1 | Whole pipeline as one invocable skill | [01-skill-invocation.md](01-skill-invocation.md) | built |
| 2 | Intake: ask codebase, company summary, timeline, newcomer details | [02-intake.md](02-intake.md) | built |
| 3 | One `.md` per issue + tech stack + auto-install script | [03-issues-and-deps.md](03-issues-and-deps.md) | built |
| 4 | Permission bypass while the pipeline runs | [04-permissions.md](04-permissions.md) | documented (user action in IDE) |
| 5 | Newcomer receives PDF + `.md` context folder | [05-newcomer-delivery.md](05-newcomer-delivery.md) | built; closed (nothing further intended) |
| 7 | Second review: flaws and fixes | [07-review-fixes.md](07-review-fixes.md) | code/docs fixed; evidence needs Bob |
| 6 | PDF design via pdf-brochure-system | [06-pdf-design.md](06-pdf-design.md) | built |
| 8 | Narrated tour video beside the PDF (optional stage 6b) | [08-video.md](08-video.md) | built, selftest covers it; needs a real Bob run |
| 9 | Deterministic naming for run folders, PDF, zip, video, issue files | [09-naming.md](09-naming.md) | built, selftest covers it |
| 11 | Newcomer start guide: what to do with the PDF, video and .md folder; Bob IDE setup (newcomer only) | [11-newcomer-guide.md](11-newcomer-guide.md) | built, selftest covers it; steps need a real newcomer run |
| 10 | Fix loop: if a step fails, repair and re-check, bounded | [10-fix-loop.md](10-fix-loop.md) | built, selftest covers the tools; the LLM half needs a real Bob run |
| 7 | Person with no MCP: trigger setup of the needed MCP | [07-mcp-bootstrap.md](07-mcp-bootstrap.md) | built (script + skill preflight); server itself not built yet |
| 12 | Channel research: email brevity, video flow-focus, narration–slide redundancy checks | [12-channel-research.md](12-channel-research.md) | built; selftest covers all three |

## Open items (need the user)
1. Run the evidence plan in Bob (`BOB_PROMPTS.md`), screenshot into `bob_sessions/`.
2. Bob's auto-approve settings are per-IDE-UI toggles; a skill cannot flip them. See 04.
3. The pack's PDF renderer needs `pycairo` (+ Arial/Liberation Sans). Already the chosen kit per item 6, but it is a new dependency for the *pipeline runner's* machine. Confirm.
4. The video stage adds pip-installed packages to the runner's machine, offered with one question right after intake and installed by `make_video.py --setup`: `piper-tts` (+ ~63 MB voice) and, only if there is no ffmpeg, `imageio-ffmpeg` (a bundled ffmpeg). No admin rights, no PATH edits, skippable. Confirm you accept them. Also confirm the submission's video length limit (vault notes say 3 min; unverified).

## Constraints carried over from v1 (still binding)
- Human approval gate stays. Auto-approve of tool prompts is NOT approval of the pack.
- Target codebase is read-only. No secrets/PII copied into issues, pack, or repo.
- No new dependency without asking; stdlib first.
- Never invent facts, URLs, emails.
