# Development: onboarding pipeline v2

Run: open this folder in Bob IDE, then `/onboard`. Sanity check first: `python scripts/selftest.py` (needs `pycairo`; Windows uses Arial, Linux Liberation Sans; override with env `BROCHURE_FONT`). The optional narrated video needs `piper-tts`, its voice and ffmpeg: `python scripts/make_video.py --doctor` shows what is missing and `--setup` pip-installs all of it (~63 MB voice, a bundled ffmpeg if none; no admin rights). `/onboard` offers this right after intake; without the tools selftest still passes and only skips the render test.

- What was asked and why: [requirements/00-index.md](requirements/00-index.md)
- Stage order: [PIPELINE.md](PIPELINE.md) · Skill: `.bob/skills/onboarding-pipeline/`
- PDF system reference: [docs/pdf-brochure-system.md](docs/pdf-brochure-system.md)
- Narrated tour video (optional stage 6b): [requirements/08-video.md](requirements/08-video.md), storyboard format in the skill's `templates.md`, examples in `docs/demo-videos/`.
- Sample output to compare against: `python scripts/selftest.py out.pdf` renders the fictional fixture.

## Permissions (auto-approve)
Bob IDE: Permissions button beside the Mode selector. Toggles: Read, Edit, Execute, MCP, Skill, Todo, Subtask, Subagent. A skill cannot set these; flip them once per session.
For `/onboard`: Read, Edit, Execute, Skill, Todo, Subtask, Subagent ON; MCP OFF until the dry-run email is verified. Execute+Edit auto-approved can run anything: use a throwaway workspace, keep `.env` in `.bobignore`. The human approval question at stage 5 still stops the run. Unconfirmed: whether reads outside the workspace (the target codebase) still prompt.
Source: https://bob.ibm.com/docs/ide/features/auto-approving-actions
