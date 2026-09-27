# 9. Naming (run folders, PDF, zip, video, issue files)

**Ask:** "naming is essential for the file and PDF generation" (2026-09-26).

## Problem
`<slug>` was "newcomer name, lowercase, spaces to `-`", typed by the LLM: not reproducible, broken by accents (`José`), apostrophes, non-Latin names, path tricks, and Windows reserved names; two people with the same name overwrote each other's folder. The newcomer's attachments were literally `alex-tan.pdf`, `alex-tan-context.zip`: unhelpful in an inbox.

## Rules (all in `scripts/pipeline_tools.py`, all deterministic, all tested by `selftest.py`)
| Thing | Rule | Example |
|---|---|---|
| Run folder / slug | `slug "<name>" --email <email>`: fold accents to ASCII, lowercase, non-alphanumerics to `-`, max 40, never `/` `.` or spaces. No Latin letters (e.g. Chinese): `hire-<6-char hash>` (stable, distinct). Windows reserved (`nul`, `aux`, `com1`...) get `-hire`. Same name, different email: `-2`, `-3`. Same email: same folder. | `José Ángel O'Brien` -> `jose-angel-o-brien`; `Nul` -> `nul-hire`; second Alex Tan -> `alex-tan-2` |
| PDF | `<company>-onboarding-<slug>.pdf` | `northwind-labs-onboarding-alex-tan.pdf` |
| Context zip | `<company>-onboarding-<slug>-context.zip` | |
| Video | `<company>-onboarding-<slug>-tour.mp4` | |
| No company in intake | `onboarding-<slug>…` | |
| Issue files | `ISSUE-NNN-<slug>.md`, NNN = 001.. with no gaps or repeats, first line `# ISSUE-NNN: <title>` with the same number | `ISSUE-001-sql-injection.md` |

`pipeline_tools.py names onboarding/<slug>` prints the exact `pdf`, `zip`, `mp4` paths; `render_pdf.py`, `bundle` and `make_video.py` all take their default output name from it, and the skill tells Bob to use those paths for the email attachments instead of building names by hand. `check` (stage 3) fails on badly named or mis-numbered issue files.

## Limits
- Company name is slugged the same way, max 30 chars; a company with no Latin letters is dropped from the file name.
- The PDF kit itself is Latin-text only (existing limit), so non-Latin newcomer names still render poorly inside the PDF even though the file name is fine.
- Only names are slugged. The human-readable text inside the PDF and email keeps the real name.
