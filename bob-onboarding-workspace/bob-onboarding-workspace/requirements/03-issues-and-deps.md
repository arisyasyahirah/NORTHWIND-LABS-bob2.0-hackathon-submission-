# 3. One .md per issue, tech stack, auto-install

**Ask (verbatim):** "During scan & review the code base, bob indeed flags the issues... write each issue into a separate .md file, one issue per .md, with a full detailed summary of what the issue is, why it happens etc. Can also include guidance to solve. Bob needs to also know other information and libraries needed for the project and if the newcomer has none of the libraries installed it will automatically install (can make a script)."

## Implementation
- `context/issues/ISSUE-NNN-<slug>.md`, template in `templates.md`: summary, severity, location (`path:line`), why it happens, impact, guidance to solve (approach, not a full patch), how to verify, suggested timeline, confidence. `INDEX.md` lists all.
- Capped by `max_issues` (default 10) — Bobcoin budget.
- Secrets: cite location only, never the value.
- `context/tech-stack.md`: runtimes, libraries, versions, purpose (from manifests, cited).
- `scripts/install_deps.py` (stdlib only): reads the repo's manifests (`requirements*.txt`, `package.json`), detects what is missing, installs it. `--check` = report only. Never sudo / system packages: prints the command instead.
- Checks: `pipeline_tools.py check-issues` (required sections, cited paths exist), `scripts/selftest.py`.

## Known ceilings
- Only pip + npm manifests. Add others (composer, maven, nuget) when the target stack needs them, and the demo target repo is not chosen yet.
- Installing runs the repo's own install scripts (npm postinstall). Fine for the company's own repo only.
