# Pipeline Session Summary — Northwind Labs / Alex Tan Onboarding
_Team: Northwind Labs | Task: 01 | Date: 2026-09-27_

## Stages completed

| Stage | Description | Result |
|-------|-------------|--------|
| Preflight | `check-mcp --fix` — MCP server built & registered in `.bob/mcp.json` | ✅ OK |
| 0 Intake | `intake.yaml` written for Alex Tan / CTMS_Project / Northwind Labs; video tools installed | ✅ OK |
| 1 Generate | 4 parallel subagents → `context/` (company, role, architecture, tech-stack, install_deps.py, 10 issues + INDEX) | ✅ OK |
| 2 Merge | `pack.md`, `manager.md`, `storyboard.json` (9 scenes), `timeline.md`, `context/AGENTS.md` | ✅ OK |
| 3 Check | `pipeline_tools.py check` → **OK** (fix loop: stripped non-repo backtick citations, trimmed narration, replaced flow scenes with `points` scene) | ✅ OK |
| 4 Flag | `flagged.md` — 5 bullets (generic role def, no git remote, unknown JDK/Tomcat, hardcoded credentials, LoginFilter unknown) | ✅ OK |
| 5 Approval | Human approved flagged list | ✅ Approved |
| 6 Render PDF | `northwind-labs-onboarding-alex-tan.pdf` — 7 pages | ✅ OK |
| 6b Render Video | `northwind-labs-onboarding-alex-tan-tour.mp4` — 97 s, 4.0 MB | ✅ OK |
| 6c Package | `context/README.md` + `email-newcomer.md` via `pipeline_tools.py guide`; `northwind-labs-onboarding-alex-tan-context.zip` | ✅ OK |
| 7 Send | Newcomer email (PDF + ZIP + MP4) + manager email → `dewitt.nikolaus@ethereal.email` (Ethereal test inbox) | ✅ Sent |

## MCP server

- `mcp/onboarding-mail/server.py` — stdlib STDIO MCP (JSON-RPC 2.0 + Content-Length framing)
- Tool: `send_onboarding_email` — SMTP from env vars, `--dry-run` fallback, `_html_body()` Northwind Labs branding
- 14 unit tests in `test_server.py` — all pass
- `selftest.py` — **ALL OK**

## HTML branding

`_html_body()` wraps the plain-text body in Northwind Labs template:
- Black header band `#111111`, yellow wordmark `#f5b800`
- `MIMEMultipart("alternative")` — plain-text + HTML parts (RFC 2046)
- `html` stdlib imported as `_html_escape_mod` to avoid variable shadowing

## Post-branding validation

```
pipeline_tools.py check  →  OK
selftest.py              →  ALL OK
test_server.py (14/14)   →  PASS
```

## Resend (branded HTML)

Email re-sent via `scripts/send_via_mcp.py` using the MCP server:
```
sent to='dewitt.nikolaus@ethereal.email'
subject='Welcome to Northwind Labs, Alex Tan — your onboarding pack is attached'
attachments=['northwind-labs-onboarding-alex-tan.pdf',
             'northwind-labs-onboarding-alex-tan-context.zip',
             'northwind-labs-onboarding-alex-tan-tour.mp4']
isError: false
```

## Deliverables

| File | Size |
|------|------|
| `northwind-labs-onboarding-alex-tan.pdf` | 0.1 MB |
| `northwind-labs-onboarding-alex-tan-context.zip` | 0.0 MB |
| `northwind-labs-onboarding-alex-tan-tour.mp4` | 4.0 MB |
