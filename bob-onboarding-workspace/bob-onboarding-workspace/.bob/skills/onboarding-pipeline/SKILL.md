---
name: onboarding-pipeline
description: Run the full developer onboarding pipeline end to end. Asks the manager for the codebase, company info, timeline and the newcomer's details; scans the codebase; writes one .md per issue, a tech-stack file and an install script; builds the onboarding pack, a context folder for the newcomer's Bob, a branded PDF and (optionally) a narrated tour video; gates on human approval; then emails the newcomer. Use when someone says onboard, /onboard, or asks to onboard a new hire.
---

Read `templates.md` (same folder) before writing any output. Authoritative stage order: `PIPELINE.md`.
All paths below are relative to the workspace root. Naming is deterministic; never type a slug or a file name yourself. `<slug>` = `python scripts/pipeline_tools.py slug "<full name>" --email <email>` (accents folded, ASCII, collision-safe: a second "Alex Tan" with another email becomes `alex-tan-2`). Output root: `onboarding/<slug>/`. The exact output files come from `python scripts/pipeline_tools.py names onboarding/<slug>`, which prints `pdf`, `zip`, `mp4` paths: `<company>-onboarding-<slug>.pdf`, `…-context.zip`, `…-tour.mp4`. Use those paths for rendering and for the email attachments.

Log every stage: `python scripts/pipeline_tools.py log onboarding/<slug> "<stage>" start|end`. Use exactly these stage names: `0 intake`, `1 generate`, `2 merge`, `3 check`, `4 flag`, `5 approval`, `6 render`, `6b video`, `6c package`, `7 send` (the timing report excludes the human approval wait).

<FixLoop>
When a deterministic step fails (stage 3 check, 6 PDF render, 6b video render, 7 deliverables or send), do not retry freely and do not give up at once. Use this bounded loop, with the step's stage name as `<stage>`:
1. Save the failing output. Run `python scripts/pipeline_tools.py fix onboarding/<slug>` (mechanical repairs, no cost: always rebuilds `issues/INDEX.md` from the issue files, since it is derived and goes stale after any issue edit, so never hand-edit it; syncs the storyboard title to the pack H1, copies `install_deps.py`). Re-run the step. Only when the step really passed (exit 0), run `python scripts/pipeline_tools.py guard onboarding/<slug> "<stage>" --ok` and move on.
2. Still failing: pipe the failing output into `python scripts/pipeline_tools.py guard onboarding/<slug> "<stage>"` (stdin). `RETRY k/3`: make the smallest edit that addresses the named cause (table below), re-run the step, and go back to 1. `STOP …` (budget spent, or the same problems came back so nothing improved): stop fixing, show the user the last output plus what you tried, and ask how to proceed. Never loop more than `guard` allows.
Rules for every fix:
- Fix the cause the message names. Do not rewrite unrelated content, and never edit a script, a check or a threshold to make it pass.
- Never fix by silently deleting or inventing. Before approval: every removed citation, dropped issue or softened claim goes into `flagged.md`. After approval (stages 6, 6b, 7): change layout and wording only (shorten, split, reword), never a fact, and re-run stage 3 after any edit to `pack.md` or `storyboard.json`. If the only fix changes a fact, STOP and ask.
- A missing dependency (pycairo, piper-tts, the voice, ffmpeg) is not a fix-loop problem: `make_video.py --setup` handles the video ones (pip only, after asking once); pycairo follows stage 6's ask-first instructions.
Known failures and the smallest fix:
| Output contains | Fix |
|---|---|
| `MISSING <path>` / `LINE <path:line>` (citation) | `grep` the repo for the real location and correct the citation; if it does not exist, remove the citation and flag it |
| `<issue>: missing '## …'` / `missing 'Severity:'` | add that section from the template, using only evidence already in the file |
| `file name must be ISSUE-NNN-` / `issue numbers must run` / `first line must be` | rename the file (slug from `pipeline_tools.py slug "<title>"`), fix its first line, renumber without gaps, update INDEX and every reference, then run `fix` |
| `not listed in INDEX.md`, `MISSING issues/INDEX.md`, a stale citation inside `INDEX.md`, storyboard `title … must equal` | `fix` does it (after correcting the issue file if the cause is there) |
| `issues > max_issues` | drop the lowest-severity issues, flag them |
| storyboard: `bullet is over 90`, `'point' is required`, `'say' as a list needs one line per bullet`, `'active' must be an index`, `'refs' must be` | edit that scene to the schema in `templates.md` |
| storyboard: `narration is about … s` | cut words (keep the arc), aim for about 300 words |
| storyboard: `no emails or URLs`, `no ISO dates` | reword: "day five", "week two", a role instead of an address |
| storyboard: `is not cited in pack.md` / `MISSING … in the repo` / `appears in the text but not in pack.md` | use a `path:line` the pack already cites (and that exists), or drop the reference |
| `content overflows footer` while rendering the PDF | shorten the longest section of `pack.md` (fewer or shorter table rows, tighter bullets), re-render |
| `content overflows footer` while rendering the video | shorten that scene: fewer or shorter bullets, a shorter `point`, one ref |
| `TOO BIG` (deliverables) | re-render the video with fewer scenes; the PDF/zip should never be near the limit |
| `MISSING pdf` / `MISSING zip` / `MISSING mp4` (deliverables) | re-run the stage that makes it (6 or 6b) inside its own loop |
| MCP send error | run `check-mcp`, retry once, then STOP and ask |
</FixLoop>

<Steps>
<Step name="Preflight (email MCP)">
Run `python scripts/pipeline_tools.py check-mcp --fix`. Nothing is downloaded from a registry: the server code lives in this repo (`mcp/onboarding-mail/`). The script registers it in `.bob/mcp.json` (per-machine paths), installs its deps via `install_deps.py`, and registers it with `--dry-run` if `.env` has no SMTP creds. It never reads or prints credentials.
- `NOT BUILT`: continue with the pipeline (stages 0-6 are still a valid run); tell the user once that stage 7 will be skipped until BOB_PROMPTS step 4 is done.
- Registration changed: tell the user once to open Settings → MCP, make sure "Use MCP Servers" is on, and enable/restart `onboarding-mail`. A skill cannot flip these; do not claim it connected.
- Any other problem line: show it, and continue unless it is `BAD JSON`.
</Step>

<Step name="0 Intake">
Use the ask-followup-question tool. If arguments were given, the first is the codebase path and a `.yaml` one is a hire file: use them and ask only what is missing. Ask in 2 batches; offer sensible defaults where marked.
Batch A (project):
- Target codebase path (absolute), unless already given. There is NO default project: every run names its own. Read-only, never modify it.
  Then pin it down: run `python scripts/pipeline_tools.py probe "<path>"` and show the output (name, git remote, manifests, languages, top-level layout). Ask the manager to confirm this is the right project. If not, ask again. Keep the confirmed name as `project_name`.
- Company name, and where its description lives (handbook path/URL/README). If none, ask for 3-5 lines: what the company does and its value.
- Max issues to report (default 10).
- Include a narrated tour video with the PDF? yes|no (default yes). It is a bonus output: it never blocks the PDF or the email.
Batch B (newcomer + timeline):
- Newcomer full name, position they enroll into, work email. All three required; do not proceed without them.
- Start date and expected end date (default: start + 90 days). Format YYYY-MM-DD.
- Manager name+email, buddy name+email (optional; if absent write "Not specified — ask your manager"), experience junior|mid|senior (default mid), and optionally `manual_hours`: an honest estimate of how long this prep takes by hand (used for the timing comparison).
Once name and email are known, compute `<slug>` (above) and use it for everything, including the first `log` call. Write `onboarding/<slug>/intake.yaml` as flat `key: value` lines: name, position, email, company, project_name, codebase_path, start_date, end_date, manager, manager_email, buddy, buddy_email, experience, max_issues, manual_hours, video (yes|no).
Then: `python scripts/pipeline_tools.py timeline <start_date> <end_date>` and keep its markdown table for `timeline.md`. Never compute dates yourself.
**Video tools (only if `video: yes`)**: run `python scripts/make_video.py --doctor`. `OK` = nothing to do. If it lists problems, ask ONCE with ask-followup-question: "Install the video tools now? It pip-installs piper-tts (text-to-speech), the ~63 MB English voice and, if this machine has no ffmpeg, a bundled copy. No admin rights needed; a few minutes." On yes: run `python scripts/make_video.py --setup` now, before the long generate stage, then `--doctor` must print `OK`. If setup fails, show the pip message (an `externally-managed-environment` error means a virtual environment is needed) and ask whether to continue without the video. On no, or if the user chooses to continue without it: set `video: no` in `intake.yaml` and skip the storyboard and stage 6b.
</Step>

<Step name="1 Generate (parallel subagents)">
Depth by `experience`: junior = explain concepts; mid = codebase specifics; senior = architecture and trade-offs.
Run these subagents in parallel, each returns concise markdown. Never invent: rationale only from ADRs/READMEs/commits/code comments with a cited source, else "Unknown — ask your buddy". Skip `.env`, credentials, client/personal data in the target. Never copy secret values anywhere.
- **Company & role**: `context/company.md` (what the company does, its value, mission, values, ways of working, links — only from provided sources) and `context/role.md` (responsibilities, 30-day success for `position`). If no role file exists (`roles/<position-slug>.md`), draft from the position title + codebase and add "Draft — unverified" to the Flagged list.
- **Architecture & code tour**: `context/architecture.md`: C4-style (system context, containers/components, ONE end-to-end request flow through real files), cited rationale, then run/test steps and a 6-10 stop code tour (`path:line` + 1-2 lines each).
- **Issue scan**: find up to `max_issues` real problems (bugs, security, performance, maintainability, missing tests, dependency risk, docs gaps). Rank by severity, then write ONE file per issue: `context/issues/ISSUE-NNN-<slug>.md` per the issue template (NNN = 001, 002, … with no gaps; `<slug>` from `pipeline_tools.py slug "<issue title>"`; the first line is `# ISSUE-NNN: <title>`; stage 3 enforces this), plus `context/issues/INDEX.md`. Each needs evidence at `path:line`. Give guidance to solve, not a full patch. Suggested timeline must fall inside the onboarding window (use dates from the timeline table).
- **Tech stack**: `context/tech-stack.md`: runtimes, libraries and versions the project needs, each with purpose and the manifest it came from. Then `mkdir -p onboarding/<slug>/context/scripts && cp scripts/install_deps.py onboarding/<slug>/context/scripts/`.
</Step>

<Step name="2 Merge">
Write from the subagent outputs:
- `onboarding/<slug>/pack.md` (PDF source, about 3-4 pages, plain language) per the pack template.
- `onboarding/<slug>/manager.md` per the manager template.
- `onboarding/<slug>/context/timeline.md` (timeline table + starter tasks + checkpoints with dates).
- `onboarding/<slug>/context/AGENTS.md` per the template (context for the newcomer's Bob). Do NOT write `context/README.md` or the newcomer's email text: stage 6c generates both, so the Bob IDE setup steps are exact and never improvised.
Exactly 3 starter tasks (quick win, collaborative, real slice; prefer real issues from the scan) and 3-5 week-1 checkpoints, each with a date from the timeline.
- If `video: yes`: write `onboarding/<slug>/storyboard.json`, the script of the tour video, per the Storyboard template in `templates.md`. It is a re-telling of `pack.md`, not new research: every fact, name and `path:line` comes from the pack, and every flow `path:line` must appear in the pack exactly as written. Skip if `video: no`.
</Step>

<Step name="3 Deterministic self-check">
Do not grade yourself; run:
`python scripts/pipeline_tools.py check onboarding/<slug> "<codebase_path>"`
It verifies every `path` / `path:line` citation exists (line within file), every issue file has the required sections, and, if `storyboard.json` exists, its schema, that its title equals the pack's H1, that every flow reference exists in the repo AND in `pack.md`, that the narration has no emails/URLs/dates and fits the length budget (about 170 s). If it does not print `OK`, follow the Fix loop with stage `3 check` until it does or `guard` says STOP. Names that are legitimately outside the repo (e.g. `.env`) may show; interpret, don't blindly delete.
</Step>

<Step name="4 Flag">
Write `onboarding/<slug>/flagged.md`: 3-6 bullets — every "Unknown — ask your buddy", every removed citation, every low-confidence issue (<80%), any "Draft — unverified" role. If none, one line saying so. If a storyboard exists, add one bullet: `Video script: <N> scenes, about <S> s of narration; flow scenes will show code from the target repo (credential-looking lines are masked)`, and one bullet per narration line that leans on an "Unknown" or "Draft" item.
</Step>

<Step name="5 HUMAN APPROVAL (hard stop)">
Show `flagged.md` plus the issue INDEX (titles + severity). Not the full pack. If a storyboard exists, say the video script is `storyboard.json` and offer to show its narration; do not paste it unasked. Ask for approval with the ask-followup-question tool. Auto-approve settings never count as approval. If corrected: fix (Fix loop, stage `3 check`), re-run stage 3, ask again. Render and send nothing until explicit approval.
</Step>

<Step name="6 Render PDF">
`python scripts/render_pdf.py onboarding/<slug>` → the `pdf` path from `names`. Needs `pycairo`; if `import cairo` fails, tell the user and ask before installing anything; if they decline, skip the PDF and attach `pack.md` instead. Any other failure (for example `content overflows footer`): Fix loop, stage `6 render`.
The context zip is built at 6c, after the video, so the start guide inside it matches what exists.
</Step>

<Step name="6b Render video (optional)">
Only if `video: yes` and `storyboard.json` exists, after approval. Log stage `6b video`. The video is part of what the newcomer receives, so it is never dropped silently: on any failure below, tell the user what failed and ask (ask-followup-question) whether to fix it or send without the video. Do not block the PDF and zip either way.
1. `python scripts/make_video.py --doctor` must print `OK` (it was installed after intake). If it does not (setup was skipped or the environment changed), run `python scripts/make_video.py --setup` after telling the user what it installs (piper-tts, the voice, a bundled ffmpeg if needed; pip only, no admin rights). If that fails or they decline, record `video skipped: <reason>` in the summary and continue to stage 7 (the deliverables check will ask about the missing file).
2. `python scripts/make_video.py onboarding/<slug> --repo "<codebase_path>" --check` → the `mp4` path from `names`. It re-validates the storyboard, draws slides in the PDF's style, speaks and captions each sentence, and `--check` confirms audio, non-silence and length. Takes about a minute. Never play the file; the check is the evidence.
3. If it prints `storyboard problems` or a scene overflows, use the Fix loop with stage `6b video`: edit `storyboard.json` per the table (wording only, no new facts), re-run stage 3, render again. On STOP, ask the user as above.
The MP4 is NOT part of the context zip (that is for the newcomer's Bob).
</Step>

<Step name="6c Package (newcomer start guide + zip)">
Log stage `6c package`. Everything the newcomer receives is final now (PDF, video or the decision to skip it), so run in this order:
1. `python scripts/pipeline_tools.py guide onboarding/<slug>`. It writes `context/README.md` (start guide: what to do with the PDF, the video and the context folder, how to set up Bob IDE with it, how to work with Bob, an accurate list of every file in the folder) and `email-newcomer.md` (the email body). Deterministic: it names the video only if the MP4 exists and the PDF only if it exists (else `pack.md`). Do not edit either file by hand; if a step is wrong, change `guide()` in `pipeline_tools.py`.
2. `python scripts/pipeline_tools.py bundle onboarding/<slug>` → the `zip` path from `names` (paths inside start with `context/`).
This guidance is for the newcomer only: it is not added to `manager.md` or the manager's email.
</Step>

<Step name="7 Send">
First run `python scripts/pipeline_tools.py deliverables onboarding/<slug>`. It lists the attachments the newcomer's email must carry: the PDF, the context zip and, when `video: yes`, the MP4 (limit 20 MB each), plus the email body file. If it exits non-zero, run the Fix loop with stage `7 deliverables` (re-run the stage that makes the missing file, in its own loop). On STOP, show the problem lines and ask the user to fix it or to approve sending without that file (a declined pycairo means attach `pack.md` instead of the PDF). Never send a partial set without that explicit answer.
Then use the `send_onboarding_email` MCP tool (see `PIPELINE.md`), after approval only:
1. To the newcomer: subject "Welcome to <company>", attachments exactly the `attach …` paths that `deliverables` printed (PDF, context zip, and the MP4 when `video: yes`), body = the contents of the `body:` file it printed (`email-newcomer.md`, generated at 6c; send it unchanged); `reply_to` = buddy email (else manager email).
2. To the manager: `manager.md` as the body.
First confirm `send_onboarding_email` is among your available MCP tools. If it is not (MCP off, server not enabled, or not built), stop, repeat the preflight instructions (Settings → MCP → enable `onboarding-mail`), and do not improvise SMTP. Dry-run logging is acceptable.
Finish by running `python scripts/pipeline_tools.py time onboarding/<slug> <manual_hours if given>` and give one summary: files written, the timing output (including `6b video`), whether the video was attached (or why not), open flags.
</Step>
</Steps>
