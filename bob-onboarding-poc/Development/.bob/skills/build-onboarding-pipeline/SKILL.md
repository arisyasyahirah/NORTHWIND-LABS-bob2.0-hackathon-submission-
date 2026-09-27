---
name: build-onboarding-pipeline
description: Build (or rebuild/extend) the whole generic onboarding pipeline workspace from its written spec, stage by stage with a test gate after each, or scaffold a new client instance under instances/<client>/. Use when someone says build the pipeline, bootstrap the workspace, rebuild onboarding, /build-pipeline, or "new instance" / "new client".
---

The spec is the docs in this workspace, not this skill: `AGENTS.md` (rules, core vs instance), `PIPELINE.md` (stages, gates, decisions: do not reopen), `requirements/00-index.md` (one file per ask). This skill only fixes the build order and the gates. Read a step's requirement file before building it; do not restate it.

Ask first with ask-followup-question: mode **build** (core) or **instance** (new client)? If the core files already exist, default to extending: read each file, change only what is missing or wrong, never rewrite a working file.

<Rules>
- The core is generic: no company, repo, brand, person or address in any core file. Client specifics go in `instances/<client>/` and reach the core only via `intake.yaml` keys with generic fallbacks.
- Stdlib first. Ask before any dependency (pycairo for the PDF kit and piper-tts for video are already accepted; both are asked at run time).
- Every stage ends with its check passing and one runnable self-check left behind. Never weaken a check to pass it. Two failed attempts at a stage: stop and ask.
- Fictional data only in fixtures and instances. No secrets in files; SMTP from env only.
- Log each finished stage in `bob_sessions/build-log.md` (stage, files, check output): it is the session evidence.
</Rules>

<Build>
Order matters: each stage uses the previous one. Gate = the command must exit 0.
1. **Repo rules**: `AGENTS.md`, `.gitignore` (`.env`, `onboarding/`, `.bob/mcp.json`, `.venv/`, `scripts/voices/`, `__pycache__/`), `.bobignore` (`.env`). Gate: files exist, no client names in them.
2. **Tools** (`requirements/09-naming.md`, `10-fix-loop.md`, `03-issues-and-deps.md`): `scripts/pipeline_tools.py` (slug, names, timeline, probe, log, check, fix, guard, guide, bundle, deliverables, check-mcp, time) + `scripts/install_deps.py` + `scripts/fixtures/` (a tiny fictional repo and sample pack). Gate: `python -c "import sys; sys.path.insert(0,'scripts'); import pipeline_tools as p; p.self_test()"` exits 0.
3. **PDF** (`06-pdf-design.md`, `docs/pdf-brochure-system.md`): `brochure_kit.py`, `render_pdf.py`. Ask before installing pycairo. Gate: `python scripts/selftest.py` renders the fixture PDF.
4. **Video, optional** (`08-video.md`, `12-channel-research.md`): `make_video.py` with `--doctor`, `--setup`, storyboard check. Gate: selftest (drawing only is fine when piper is missing; say so).
5. **Email MCP** (`07-mcp-bootstrap.md`): `mcp/onboarding-mail/server.py` (stdlib STDIO, `send_onboarding_email`, `--dry-run`, brand via `brand_name`/`brand_accent` args, neutral default) + `test_server.py`. Gate: `python mcp/onboarding-mail/test_server.py` ALL OK. Register with `pipeline_tools.py check-mcp --fix`, then remind the user to enable it in Settings → MCP (a skill cannot).
6. **Skill + command** (`01-skill-invocation.md`, `02-intake.md`, `05`, `11`): `.bob/skills/onboarding-pipeline/{SKILL.md,templates.md}` and `.bob/commands/onboard.md`, matching `PIPELINE.md` stage names exactly. Gate: every script command the skill calls exists (`grep` each `pipeline_tools.py <cmd>` against the script).
7. **Docs**: `README.md` (run steps, permissions from `04-permissions.md`), keep `PIPELINE.md` and `requirements/` in sync with what was built (status column).
8. **Full check**: `python scripts/selftest.py` ALL OK, `test_server.py` ALL OK, then grep the core (everything outside `instances/`, `scripts/fixtures/`, `onboarding/`, `bob_sessions/`) for client names: must be empty.
Finish by telling the user the next step: `/onboard @instances/<client>/instance.yaml` in Bob, and to screenshot task summaries into `bob_sessions/`.
</Build>

<Instance>
Scaffold `instances/<client>/` (slug from `python scripts/pipeline_tools.py slug "<client name>"`). Ask: company name, one-paragraph description or handbook path, brand name and accent `#rrggbb` (optional), default repo URL and project folder (optional), roles the client hires for. Create only what was given:
- `instance.yaml`: flat `key: value`; keys are intake keys (`company`, `company_source`, `brand_name`, `brand_accent`, `repo_url`, `project_dir`, `roles_dir`). Omit unknown keys; never invent values.
- `company/handbook.md` from the description, `roles/<role-slug>.md` per role (draft, mark "Draft — unverified"), `hires/` empty, and a short `README.md` with the run line `/onboard @instances/<client>/instance.yaml`.
Never edit anything outside `instances/<client>/`. Gate: `python scripts/pipeline_tools.py slug` works on the client name and `instance.yaml` has no key the intake does not know.
</Instance>
