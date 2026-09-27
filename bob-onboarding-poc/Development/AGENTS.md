# Project context (read first)

IBM Bob 2.0 hackathon PoC: **developer onboarding pipeline**. Deadline Sep 27 2026, 11:00 PM MYT. This folder is the Bob IDE workspace root.

## Goal
A senior dev/manager runs `/onboard`, answers intake questions, and Bob produces for the newcomer: a branded PDF and a context folder (company, role, timeline, architecture, tech stack, one `.md` per issue, install script) that the newcomer loads into their own Bob. Gated by human approval, then emailed.

## Layout
- `.bob/skills/onboarding-pipeline/`: the skill (`SKILL.md` steps, `templates.md`). Follow it exactly. `.bob/commands/onboard.md`: the `/onboard` command. `.bob/skills/build-onboarding-pipeline/` + `/build-pipeline`: builds/extends this whole workspace from the spec (build order + gates) or scaffolds a new `instances/<client>/`.
- `PIPELINE.md`: authoritative stage order and gates. `requirements/`: the v2 asks, one file each.
- `scripts/`: `pipeline_tools.py` (timeline, log, check, bundle), `install_deps.py` (shipped to the newcomer), `render_pdf.py` + `brochure_kit.py` (PDF), `make_video.py` (optional narrated video from `storyboard.json`). `python scripts/selftest.py` checks all.
- **Core vs instance.** Everything outside `instances/` is the generic core ("the bible": rules, pipeline, scripts, skill, MCP server). Never hardcode a company, repo, brand, person or address into it. Anything client-specific goes in `instances/<client>/` (`instance.yaml` prefill, `company/`, `roles/`, `hires/`, samples) and reaches the pipeline only through `onboarding/<slug>/intake.yaml`. Need a new per-client value? Add an optional intake key with a generic fallback, never a constant. Example instance: `instances/northwind-labs/`.
- `onboarding/<slug>/`: generated output (gitignored, contains real emails).

## Rules
- Never invent facts: rationale only from ADRs/READMEs/commits/comments, cited; else "Unknown — ask your buddy". Never invent URLs, emails, channels.
- Never render or send before the human approves the Flagged list. Auto-approve of tool prompts does not count as approval.
- The target codebase is READ-ONLY. Skip `.env`, credentials, personal/client records. Never copy secret values into any file; cite `path:line` only.
- SMTP creds only from env, never committed. Email server needs `--dry-run`. Test inbox only. No IBM Cloud credentials in the repo.
- The newcomer's start guide (`context/README.md`, `email-newcomer.md`) is generated at stage 6c by `pipeline_tools.py guide`; never write or edit it by hand, and never put it in the manager's material.
- Failures: follow the skill's Fix loop (`fix`, then `guard`; max 3 attempts per stage, stop when nothing improves, then ask). Never weaken a check, script or threshold to pass it; never fix by silently deleting or inventing content; after approval change wording/layout only.
- Dates: only from `pipeline_tools.py timeline`. Names: only from `pipeline_tools.py slug` and `names`; never type a slug or an output file name.
- Video: `storyboard.json` only re-tells `pack.md` (no new facts, no emails/URLs/dates in the narration). Never render it before approval. Never play or open the MP4; `make_video.py --check` is the evidence. Video tools: `make_video.py --doctor`, and after ONE ask right after intake `make_video.py --setup` (pip only; never sudo or a system package manager); a missing dep or failed render is reported and the user is asked; the video is never dropped silently, and the PDF and zip are never held hostage by it. Before sending, run `pipeline_tools.py deliverables`.
- Prefer installed tools; stdlib first. Ask before adding a dependency (pycairo is already accepted for the PDF kit).
- Budget: 40 Bobcoins/person, no top-ups. Scan only what is needed; respect `max_issues`.

## Evidence
Screenshot each Bob task summary into `bob_sessions/` (`teamname_task01_desc_summary.png`).
