# 11. Newcomer start guide (newcomer only)

**Ask:** "we need to add extra guidance in terms of what to do with the PDF, video and .md folder. How to set up the Bob IDE with the folder .md" and "this one is for the newcomer only" (2026-09-26).

## Problem
The newcomer received three attachments and no instructions beyond one line in a PDF card and a one-line README template. Nobody had said what order to use them in, or how to get a zip of `.md` files into Bob IDE. One non-obvious trap: our `AGENTS.md` sits inside `context/`, but Bob only loads an `AGENTS.md` at the workspace root automatically, so unzipping and opening would silently give the newcomer's Bob no context.

## What was built
`pipeline_tools.py guide <dir>` (stage 6c, after the video, before `bundle`) writes, from one source:
| Output | Where it goes |
|---|---|
| `email-newcomer.md` | the body of the newcomer's email (stage 7 sends it unchanged) |
| `context/README.md` | inside the zip: the same steps plus how to work with Bob and an accurate file list |
| the PDF's "Start here" card | shorter pointer to the two above (`render_pdf.py`) |

Content, in order: the three files and what to do with each (PDF first, ~20 min; video second, only if it exists; zip = load into Bob); Bob IDE setup: install from bob.ibm.com/download and sign in, make `onboarding-workspace` and unzip the zip into it, clone the project beside it (address from the PDF's "Where things live", else ask the buddy), File → Open Folder, trust prompt, **copy `context/AGENTS.md` to the workspace root**, open chat (Ctrl+Alt+B / Option+Cmd+B), first message `Read @/context/README.md and help me finish the setup.`; installing dependencies via `install_deps.py --check`; Ask vs Agent mode and keeping auto-approve off while learning; `@` mentions; good first questions; who to ask.

## Decisions
- **Generated, not LLM-written.** The Bob IDE steps must be exact; a model would improvise UI steps. The text is fixed code, with names, dates and the buddy filled in from `intake.yaml` and the file list read from the folder.
- **Newcomer only.** Not added to `manager.md` or the manager's email.
- **Truthful about what exists.** The video is mentioned only if the MP4 exists; the PDF is replaced by `pack.md` if the PDF was declined; the file list is scanned from `context/`.
- **No inline backticks** in the generated files, so stage 3's citation check does not read paths in them as repo citations (tested).
- **`deliverables` requires `email-newcomer.md`** before sending.

## Sources (Bob IDE facts)
Bob docs: quickstart (download, open chat shortcut, modes, Permissions, trust prompt), start-a-project (workspace-root `AGENTS.md` applied to new conversations), context-window-management (`@/path` mentions; whole-folder mentions discouraged). bob.ibm.com/docs/ide.

## Unverified
- The exact menu label "File → Open Folder": the docs show Clone/Open; Bob is a desktop IDE and a workspace-root concept is documented, but the label is my inference.
- Whether a workspace containing `context/` and the clone lets Bob read both without prompts (README notes reads outside the workspace may prompt).
- Windows unzip wording ("right-click, Extract All") is generic Windows behaviour, not from Bob docs.
- Not yet followed by a real newcomer on a clean machine.
