# Bob evidence plan (run these INSIDE Bob IDE, in order)

Why: the hackathon scores "Bob usage" and requires session evidence. Bob reviews, hardens and extends the pipeline, builds the missing MCP server, and runs it. In the usage statement describe only what Bob actually did in these tasks. Each item below is ONE Bob task. After each, screenshot the task summary (Tasks → the task → header) into `bob_sessions/` as `teamname_taskNN_desc_summary.png`.

## 0. Setup (no Bob)
- Demo target (public, MIT, small): `git clone https://github.com/miguelgrinberg/microblog` **outside** this workspace. Verify the license file yourself before use.
- Open `Development/` as the Bob workspace root. `git init` here is fine; confirm before any push.
- Permissions: README "Permissions" (MCP off for now).

## 1. Independent review (Ask/Agent mode)
> Read AGENTS.md, PIPELINE.md, the onboarding-pipeline skill and everything in scripts/ (including make_video.py and the storyboard check). Run `python scripts/selftest.py`. List real defects or missing edge cases (Windows paths, empty repos, huge repos). Fix the ones you are confident about and add a test for each.

## 2. Build the email MCP server (Code mode, "Enable MCP Server Creation" on)
> Build a local STDIO MCP server with one tool `send_onboarding_email(to, subject, body, attachment_paths, reply_to)`. SMTP from env SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS, never hardcoded. Add `--dry-run`: log to, subject, reply_to and attachment names instead of sending. Add a small test. Register it in .bob/mcp.json. Prefer the standard library.
Then turn the MCP permission toggle ON.

## 3. Run the pipeline to the approval gate (Agent mode)
> /onboard <path to microblog clone> @instances/northwind-labs/instance.yaml @instances/northwind-labs/hires/alex-tan.yaml
Confirm the `probe` output, answer intake (put your honest hand-prep estimate in `manual_hours`). Bob stops at the Flagged list. Screenshot the summary AND the flagged list.

## 4. Approve, render, send (same conversation)
Approve. Bob renders the PDF and context zip, then (if `video: yes`; the video tools are installed with one question right after intake) the narrated MP4, and calls the email tool (dry-run) with the attachments. Then Bob runs `pipeline_tools.py time`. Screenshot the summary and the timing output: that is your measurable-impact number.

## 5. Optional before/after (Ask mode)
> Onboard Alex Tan to this repo with one plain prompt, no skill. Save as onboarding/plain.md.
Compare with the pipeline pack: does it cite real files? does it flag unknowns? does it have per-issue files? Run `pipeline_tools.py check` on both. Shows what the gate and the citation check add.

## Cut order if time runs short
1 and 3 first (review + a real run), then 2 (dry-run email), then 4, then 5. Never skip 3.
