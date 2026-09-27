# 5. What the newcomer receives

**Ask (verbatim):** "During Onboarding the newcomer will receive: the onboarding PDF; .md folder. This .md folder will contain each of the issues and the company background and other information needed for the job for the newcomer's bob. It's basically a context file for the newcomer bob's context. I also think we need" ← (cut off; user later confirmed nothing further)

## Implementation
Email to newcomer carries two attachments: `<company>-onboarding-<slug>.pdf` and `…-context.zip`, plus `…-tour.mp4` (narrated tour, see [08-video.md](08-video.md)) when `video: yes` (default). `pipeline_tools.py deliverables` checks all three exist and are under 20 MB before stage 7 sends; a missing file stops the run and asks. The MP4 is not in the zip.
```
context/
  README.md        how to load this into Bob (unzip into workspace, open, run install script)
  AGENTS.md        Bob-readable context: who you are, company, role, timeline, rules, where things are
  company.md  role.md  timeline.md  architecture.md  tech-stack.md
  issues/INDEX.md  issues/ISSUE-NNN-*.md
  scripts/install_deps.py
```
- The email body is `email-newcomer.md`, and `context/README.md` carries the same steps (see [11-newcomer-guide.md](11-newcomer-guide.md)).
- MCP email tool gains `attachment_paths` (list) — v1 spec had one `attachment_path`.
- Manager still gets `manager.md` checklist (unchanged).

