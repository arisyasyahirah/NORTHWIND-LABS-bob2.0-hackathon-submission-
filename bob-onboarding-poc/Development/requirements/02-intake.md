# 2. Intake questions + timeline

**Ask (verbatim):** "Bob needs to ask the user which code base/project that needs to scan and review. Ofc it needs to do the usual make a summary of the whole company and its value... I think we might include the timeline, I feel everything needs a timeline when it starts and when it ends expectedly. I also think bob needs to ask the personal details of the newcomer: Name, Position it will enroll, work email."

## Interpretation
- Bob asks (ask-followup-question) before anything else: codebase path, company name + where its description lives, newcomer name / position / work email, start date, expected end date, plus optional manager, buddy, experience level, max issues.
- Company summary + value: written from provided sources only (handbook/README/site text). If none, Bob asks the manager for a few lines. Never invented.
- "Everything has a timeline" applied in three places:
  1. **Onboarding timeline** — start → expected end, phases with dates (`timeline.md`, PDF).
  2. **Each issue** — suggested fix window inside the onboarding period.
  3. **Pipeline run itself** — start/end timestamp per stage in `run-log.md`.
- Dates are computed by `scripts/pipeline_tools.py timeline`, not by the LLM.
- Answers saved to `onboarding/<slug>/intake.yaml`. Contains a real email → `onboarding/` is gitignored.
- If `@hires/<x>.yaml` is passed, its fields prefill and only missing fields are asked.

## Update: no default project (2026-09-26)
The trial project path and is removed everywhere. Every run names its own codebase: `/onboard <path>` or asked at intake. Bob then runs `pipeline_tools.py probe <path>` (name, git remote, manifests, languages, layout) and the manager confirms before any scan. `project_name` is stored in `intake.yaml`.
