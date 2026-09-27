# 8. Narrated tour video (optional stage 6b)

**Ask:** "make a narrative video based on [the pack]", then "implement this into the pipeline and make sure it's detailed so it fits perfectly". Built and tested as a separate feature first, then integrated (2026-09-26).

## What the newcomer gets
`<company>-onboarding-<slug>-tour.mp4` (name from `pipeline_tools.py names`), about 2 minutes: a story that follows the pack's one real request flow through the code. Slides in the PDF's style, one lit-up hop per scene with the real `path:line` and a code excerpt, bullets that appear as they are spoken, captions, a voice. Delivered to the newcomer in the same email as the PDF and the context zip (three attachments). Not inside the context zip: that is for the newcomer's Bob, which cannot use a video.

## How it fits the pipeline
| Where | What | Why there |
|---|---|---|
| Intake | `video: yes|no` (default yes) | costs tokens/time; the manager may not want it |
| Preflight | `make_video.py --doctor` (informational) | tell the user early what is missing |
| Stage 2 Merge | Bob writes `storyboard.json` next to `pack.md` (template in `templates.md`) | it is LLM work like the pack, so it gets the same checks and the same gate |
| Stage 3 Check | `pipeline_tools.py check` validates it (stdlib only) | deterministic: schema, title = pack H1, every flow ref exists in the repo and in the pack, no emails/URLs/dates, length budget |
| Stage 4/5 | one line in `flagged.md`; the gate mentions the script | the human can read the narration before approving |
| Stage 6b | `make_video.py onboarding/<slug> --repo <codebase_path> --check` | deterministic, after approval, like the PDF render |
| Stage 7 | `deliverables` lists PDF + zip + MP4 (MP4 required when `video: yes`, max 20 MB); the email carries all three | a missing/oversized file stops and asks; never silently dropped |

## Design decisions
- **Storyboard, not auto-narrated sections.** Reading sections aloud was flat and overflowed on a real pack. A story needs choices, which is LLM work. Rendering is code.
- **No invented facts.** Every `path:line` must be in `pack.md`; narration may not contain emails, URLs or ISO dates; excerpts come from the repo, never from the model.
- **Secrets.** Excerpts skip `.env`/key files, stay inside the repo, and mask string literals on credential-looking lines (regex: a guardrail, not a guarantee; the approval gate is the backstop).
- **Bob installs the tools, after one question.** Right after intake, if `video: yes` and `--doctor` finds gaps, Bob asks once and runs `make_video.py --setup`: pip-installs `piper-tts` (offline TTS, MIT-licensed wrapper), downloads the ~63 MB English voice, and installs `imageio-ffmpeg` (a bundled ffmpeg) only if the machine has none. No admin rights, no system package manager, no PATH changes. Tested on a simulated fresh machine (empty venv, no ffmpeg on PATH): doctor reported 3 problems, setup fixed all 3, a render then passed its check. If setup fails or the user declines, Bob asks whether to continue without the video (`video: no`); it is never dropped silently.
- **PDF-consistent look.** A private copy of `brochure_kit.py` re-pointed to 16:9, so the video and the PDF cannot drift (and the PDF renderer's globals are untouched).
- **Compatibility.** Output is H.264 + 44.1 kHz stereo AAC: 22.05 kHz mono AAC played silent in VS Code's preview.

## Limits / unverified
- Voice is Piper's `en_US-lessac-medium`: clear but synthetic. English only. Upgrade path noted in `research/ibm-bob-hackathon/Research/onboarding-video-research.md` (Kokoro, needs Python 3.10-3.13).
- Not tested on Windows (the Bob users' platform): fonts fall back to Arial/Consolas via the kit; whether `pip install piper-tts` and `imageio-ffmpeg` work there is unverified (the fresh-machine test above ran on Linux). If Bob's Python is an externally-managed one, setup needs a virtual environment (setup says so).
- Slides are static (no motion), no syntax colours.
- Video length limit unverified (vault says 3 min): `MAX_S` in `make_video.py`, budget in `pipeline_tools.py`.
- Not yet run inside Bob IDE.

## Files
`scripts/make_video.py` (render, `--doctor`, `--setup`, self-test) · `scripts/pipeline_tools.py` (`check_storyboard`) · `scripts/fixtures/sample/storyboard.json` (fixture) · `docs/demo-videos/` (rendered examples) · `.bob/skills/onboarding-pipeline/` (stage instructions + template).
