# Pitch video script: Bob Onboarding Pipeline (3:00 cut)

Audience: IBM Bob 2.0 hackathon judges (lablab.ai). Criteria to hit: Application of Technology, Presentation, Business Value, Originality.
Speaking pace ~130 words/min. `[X]` = fill in before recording; do not guess.

**Rule check:** video **≤ 3:00, judges stop at 3:00, ≥ 90 s of the solution running**. This script targets exactly 3:00, with the live-demo block held at 105 s of screen time — comfortably clears the 90 s floor even though the narration under it is much shorter (see the note after that block).

**Source of truth:** pulled directly from the speaker notes on the pitch deck (Team Onboard — [deck link](https://claude.ai/artifact/CTW8Rd5TA4vtQGmwR3M6cS)), 9 slides. This deck no longer has a separate 5:00 version — the whole thing is now built to 3:00.

## What got cut from the earlier 5:00 draft
- The two problem-evidence slides (58%/82% stats, the "docs go stale" diagram) — compressed to one line in the cover beat.
- The "Bob usage" slide (skill/command/MCP-server breakdown) — dropped entirely. If a judge asks about it live, it's in the written 500-word Bob Usage Statement instead.
- The architecture diagram merged into the solution beat instead of its own slide.

## 3:00 script

Rows 3–7 (`live-intake` through `live-send`) are the live-demo block — 105 s of screen time total, clearing the ≥90 s requirement (see the note after the table for why the narration under it looks short).

| Time | Slide | On screen | Narration |
|---|---|---|---|
| 0:00–0:15 | `cover` | Title card: "Day one, a stale README." Slow / Expensive / Inconsistent | "A new developer joins. They get a stale README, and their senior repeats the same explanations for every hire. Onboarding is slow, expensive, and different every time." |
| 0:15–0:35 | `solution` | `/onboard` line + flowchart: Intake → Generate ×4 → Verify → Approve → Render → Send | "We built an onboarding pipeline inside Bob IDE. One command, `/onboard`. Four subagents scan the codebase in parallel, a deterministic check verifies every citation, and nothing renders or sends until a human approves." |
| 0:35–0:55 | `live-intake` | **LIVE**: Bob asking for the codebase path, then probing it | "Live run. The manager points Bob at a codebase, and Bob confirms the project. Company, brand and repo come from an instance file, so the core stays generic." |
| 0:55–1:20 | `live-generate` | **LIVE**: four subagents launching in parallel, "10 issues found" badge — hold on this a beat, let the tool calls actually scroll | "Four subagents run in parallel and find ten real issues in this Java app, including hardcoded credentials, each with evidence at file and line. Then a deterministic check verifies every path exists. Anything it can't confirm goes into a flagged list. Bob never invents a fact." |
| 1:20–1:40 | `live-approval` | **LIVE**: the approval gate, flagged issues + decision options — hold long enough for judges to read the table | "Now the human gate. The manager sees the flagged items and the issue index, and has to explicitly say yes. Auto-approve doesn't count." |
| 1:40–2:00 | `live-outputs` | **LIVE**: rendered PDF, table of contents and welcome cards | "Approved. Bob renders a branded PDF, a narrated code tour, and a context folder the newcomer loads straight into their own Bob." |
| 2:00–2:20 | `live-send` | **LIVE**: Ethereal inbox, email received with 3 attachments | "Delivery goes through an email MCP server Bob built itself. The newcomer gets the pack; the manager gets a separate brief." |
| 2:20–2:45 | `impact` | Big numbers: ~20 min vs. 20–40 hrs (LACY, Beko) | "The run took about 20 minutes of machine time and one minute of human approval. Industry data puts manual onboarding at 20 to 40 hours of expert time per hire." |
| 2:45–3:00 | `close` | Closing statement + `/build-pipeline` · `instances/<client>` · Team Onboard | "A generic core, a folder per client, a human in control. Thanks." |

**Why the live block works at only ~65 s of actual talking inside a 105 s slot:** the narration is deliberately sparse so judges can watch Bob actually work — the subagents running, the issues table, the PDF opening. Per the recording tips below, record the real run once, then edit: hold each shot for its full window in the table above even where nobody's talking, rather than padding with words. That screen time is what satisfies the ≥90 s rule, not word count.

## Recording tips
- Record the live run once, then cut the *waiting* (installs, long tool calls) but keep the *result* on screen for its full window — the table above assumes held shots, not padded narration.
- Show real terminal and Bob UI throughout; judges want proof it runs, not a mock-up.
- If you're short on time on the day: cut from `solution` (skip straight to the diagram, drop the sentence) before you cut anything from the live block — the demo footage is what the ≥90 s rule and the *Application of Technology* criterion actually hinge on.
- `[X]` doesn't appear in this cut — the impact line now uses the sourced 20–40 hrs figure (LACY), not a placeholder.
