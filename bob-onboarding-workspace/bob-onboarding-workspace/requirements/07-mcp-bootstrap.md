# 7. MCP bootstrap: a person with no MCP connected

**Ask (paraphrased):** if the person running `/onboard` has no MCP set up in their Bob IDE, something must trigger getting the needed MCP in place.

## Finding
- Bob ships no MCP servers. Project config `.bob/mcp.json` is read from the workspace, but the server process + its deps must exist on that machine.
- Our only needed MCP is the email server. Its code is in this repo, so "download" = install deps + register it; no registry.
- IDE toggles ("Use MCP Servers", per-server enable/restart, MCP auto-approve) are UI state. A skill/script cannot flip them (same limit as 04).
- Unconfirmed: whether Bob live-reloads an edited `.bob/mcp.json` or asks to trust project MCP config. Assume restart/enable in Settings → MCP is needed.

## Implementation
- `python scripts/pipeline_tools.py check-mcp [--fix]`: server built? registered (absolute paths, per machine)? deps? SMTP creds? No creds → registered with `--dry-run`. Never reads or prints creds. Self-tested (`scripts/selftest.py`).
- Reuses `install_deps.py` for the server's own manifest (no new installer).
- Skill: new first step "Preflight (email MCP)" runs `check-mcp --fix`; stage 7 confirms `send_onboarding_email` is an available tool before sending.
- `.bob/mcp.json` is git-ignored (machine-specific paths).
- Server convention: `mcp/onboarding-mail/server.py`, Python, loads workspace `.env` itself (keeps secrets out of mcp.json).

## Known ceilings
- Only one server. Adding more means generalising `MCP_NAME` / `MCP_SERVER`.
- Windows: `command` is `sys.executable` of whatever runs the script; if Bob launches servers from a different environment, the path may need a manual edit.
- OAuth-style login is out of scope: SMTP env creds only.
