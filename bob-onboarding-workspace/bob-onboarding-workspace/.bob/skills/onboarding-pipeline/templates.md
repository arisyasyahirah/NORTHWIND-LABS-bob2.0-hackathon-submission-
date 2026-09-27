# Templates

## Issue file: `context/issues/ISSUE-NNN-<slug>.md`
Name: `ISSUE-` + three digits (001, 002, … no gaps) + `-` + lowercase slug (`python scripts/pipeline_tools.py slug "<title>"`) + `.md`. First line `# ISSUE-NNN: <title>` with the same number. Stage 3 checks both.
```
# ISSUE-NNN: <short title>
Severity: critical|high|medium|low · Category: bug|security|performance|maintainability|tests|dependency|docs · Confidence: NN%
Location: `path:line` (add more `path:line` lines if needed)
Suggested timeline: <start date> → <end date>   (inside the onboarding window)

## Summary
What is wrong, in 2-3 sentences.
## Why it happens
Root cause, with evidence from the code (cite `path:line`; never paste secret values).
## Impact
What breaks or who is affected, and when.
## Guidance to solve
Numbered approach. Name the files/functions to change. No full patch.
## How to verify
The test or manual check that proves it is fixed.
## Related
Other issues / tour stops / starter tasks.
```
Required headings (checked by script): Summary, Why it happens, Impact, Guidance to solve, How to verify.

## Issue index: `context/issues/INDEX.md`
Table: ID · title (link) · severity · category · location · timeline.

## Pack: `pack.md` (PDF source; the renderer supports `#`, `##`, `###`, bullets, numbered lists, tables, `>` callouts, `**bold**`, fenced code)
```
# Welcome to <Company>, <Name>
Role: <position> · Level: <experience> · Manager: <manager> · Buddy: <buddy> · Start: <start_date> · End: <end_date>

## Why we exist          (company summary + value)
## What you own
## Timeline              (the table from pipeline_tools.py timeline)
## Architecture at a glance
## Run it first
## Code tour             (6-10 stops, path:line; the video storyboard may only cite references that appear in this pack)
## Issues we found       (table: ID · title · severity · timeline; full detail in the context folder)
## Starter tasks         (quick win → collaborative → real slice, with dates)
## People to meet        (table: name · role · ask them for · how to reach)
## Where things live     (table: item · location; include the code repository address when a source gives one: the newcomer's start guide sends them here to clone it)
## Day-1 accounts & access   (owned by IT/manager, not generated)
## Week-1 checkpoints    (questions only; answers live in context/timeline.md)
## Sources
```
"Not specified — ask your manager." for anything not in a source. Never invent URLs, emails, channels.

## Manager: `manager.md`
```
# Before <Name> starts on <start_date>
1. Read flagged.md and the issue INDEX first (2 min). Correct/fill gaps.
2. Day-1 talk: role and expectations <from role.md>.
3. Buddy confirmed: <buddy>. Weekly 30-min chat for 90 days; walk the code tour in week 1.
4. Introductions for the collaborative task: <people/teams>.
5. Checkpoints together on <date>; check-ins on <timeline dates>. Expected end: <end_date>.
```

## Newcomer context: `context/AGENTS.md`  (read by the newcomer's Bob)
```
# Context for <Name>'s Bob
You are helping <Name>, <position> at <Company>, onboarding <start_date> → <end_date>.
Read first: company.md, role.md, timeline.md, architecture.md, tech-stack.md, issues/INDEX.md. If <Name> asks how to set anything up, point them to README.md in this folder (generated; do not improvise Bob IDE steps).
Rules: target repo path is <codebase_path> (adjust to local clone). Explain the why, cite path:line, never invent; say "ask your buddy" when unknown. Issues in issues/ are the source of truth for known problems; help <Name> fix them per their guidance and timeline.
First action: run `python context/scripts/install_deps.py <repo path>` (add --check to preview).
```

## Newcomer start guide: `context/README.md` and `email-newcomer.md` (GENERATED, do not write)
Stage 6c runs `pipeline_tools.py guide`. It writes the newcomer's start guide (what to do with the PDF, the video and the context folder; Bob IDE setup: install, workspace folder, clone, Open Folder, copy AGENTS.md to the workspace root because Bob only auto-loads one there, first chat message; Ask vs Agent mode; @ mentions; file list) and the email body from the same text. Facts about Bob IDE in it come from Bob's docs (bob.ibm.com/docs/ide), not from the model.

## Storyboard: `storyboard.json` (the video's script; stage 2, only if `video: yes`)
Rendered by `scripts/make_video.py` into a narrated, captioned tour: slides in the PDF's style, one voice, real code shown for the flow scenes. Validated at stage 3. **It re-tells `pack.md`; it adds no facts.**
```
{ "title": "<exactly the H1 of pack.md>",
  "scenes": [ ...4 to 16 scenes... ] }
```
Scene kinds (`say` is what the voice reads; the screen shows only keywords):
```
{"kind": "cover",  "meta": ["Role: … · Level: … · Manager: … · Buddy: …"], "say": "<welcome, 1-2 sentences>"}
{"kind": "points", "title": "<slide title>", "points": ["<=90 chars", ...1-6], "say": ["one sentence per bullet", ...]}
{"kind": "flow",   "kicker": "<The login story · 2 of 6>", "title": "<this hop>",
 "nodes": ["Browser|user", "LoginServlet|controller", ...2-6, "Name|layer"], "active": <index in nodes>,
 "point": "<=110 chars, the one thing to remember", "refs": ["path/in/repo.ext:LINE", ...1-3], "say": "<1-2 sentences>"}
```
- Exactly one `cover`, first. `meta` = the pack's Role line without the Start/End dates.
- `points` with `say` as a list (same length as `points`) reveals each bullet as its sentence is spoken. Prefer that over one long string.
- `flow`: the first ref is shown as a real code excerpt (3 lines either side, cited line highlighted); extra refs show as paths. Use the same `nodes` in every hop of one story and move `active` along them (redo the node list only if the path changes). Each ref must be a real `path:line` in the target repo AND appear in `pack.md` verbatim (take them from the request flow and the code tour).

**Arc** (drop or merge scenes if the pack lacks the material; never pad):
1. `cover`.
2. `points` "Why we exist" (company mission, from the pack).
3. `points` "What you own" (role, from the pack).
4. `flow` x 4-6: follow the pack's ONE end-to-end request flow, one hop per scene, in order, `active` advancing. Say what happens and why it matters, in plain language.
5. `points` "Before you touch anything": the 2-3 most important real findings (top issues, missing tests, sharp edges) from the pack. Nothing the pack marks Unknown.
6. `points` "Your first week": from the starter tasks and first week. Use "day five" / "week two", never ISO dates.
7. `points` "Who to ask": buddy, manager, IT by role and first name. For anything the pack marks "Unknown — ask your buddy", say to ask the buddy.

**Narration rules** (the check enforces the mechanical ones):
- Spoken English, sentences of at most about 25 words. Total 250-350 words (about 2 minutes); over about 440 words fails.
- Say class or function names, not paths. "line 23" is fine.
- No emails, URLs or ISO dates in `say` (check fails). No credential values, ever.
- An acronym the voice would mangle: write it spaced (`D A O`, `J S P`); captions collapse it to DAO / JSP automatically. Avoid rare jargon; it gets read literally.
- Do not claim more than the pack does. If the pack says "Draft — unverified", either leave it out or say it is a draft.

Worked example: `scripts/fixtures/sample/storyboard.json` (small); a full realistic one: `docs/demo-videos/alex-tan/storyboard.json`.
