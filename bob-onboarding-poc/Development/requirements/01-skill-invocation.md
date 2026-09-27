# 1. Whole pipeline as a skill

**Ask (verbatim):** "We need to make the whole pipeline as a skill where the senior dev/manager can just invoke in a command to make the skill go through the pipeline at ease."

## Acceptance
- One command, `/onboard`, runs intake → scan → pack → check → flag → approve → PDF + context bundle → send.
- Manager answers questions in chat; no file editing required.
- Works from a fresh Bob workspace that contains this folder.

## Implementation
- Skill: `.bob/skills/onboarding-pipeline/SKILL.md` (replaces v1 `onboarding-pack`; its steps are folded in).
- Templates: `.bob/skills/onboarding-pipeline/templates.md`.
- Command: `.bob/commands/onboard.md` → `/onboard [@hires/x.yaml]`. Format verified against Bob docs (filename = command name, `description`/`argument-hint` frontmatter, `$1` args).
- Helper scripts: `scripts/pipeline_tools.py` (timeline, run log, checks).
