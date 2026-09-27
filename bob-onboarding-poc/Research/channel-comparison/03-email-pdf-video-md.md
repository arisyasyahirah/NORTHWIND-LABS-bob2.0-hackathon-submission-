# Condition 3: Email + PDF + video + context .md files

Part of the channel comparison: [01 email](01-email-only.md) · [02 email + PDF](02-email-plus-pdf.md) · [03 email + PDF + video + context .md](03-email-pdf-video-md.md). Written 2026-09-27.

## What this condition is in our project
Everything in condition 2, plus:
- **Video**: `<company>-onboarding-<slug>-tour.mp4`, ~170 s max, narrated (Piper TTS), built from `storyboard.json` (`make_video.py`, optional stage 6b). Scenes: cover, points, request-flow diagram, real code excerpts for the `path:line` tour. Not in the context zip.
- **Context .md folder** (`context/`): `README.md` (start guide, generated), `pack.md`, `issues/ISSUE-NNN-<slug>.md` + `INDEX.md`, install script. Bob reads these in the IDE so the newcomer can ask questions grounded in the pack and the repo.

## Evidence
| Finding | Source | Fit to our case |
|---|---|---|
| RCT (clinical procedures): video group beat illustrated-text group on the **practical** exam (P<0.001, and at follow-up P<0.01); **no difference** on theoretical knowledge. | [PMC4140394](https://pmc.ncbi.nlm.nih.gov/articles/PMC4140394/) (abstract only; page blocked for full text) | Video helps *procedural/how-to* content (run it, follow the flow), not facts. Medical students, not developers. |
| Developers: video learners applied the tool faster, bottom-line performance ~equal; text was cheaper to produce and faster to finish. Learners prefer video to *learn*, text to *look up*. | [arXiv 1704.00074](https://arxiv.org/abs/1704.00074) | Best direct evidence, and it is a caution: video is not clearly better for developers. It is complementary. |
| **Redundancy**: identical on-screen text + narration can interfere with learning. | [PubMed 15573552](https://pubmed.ncbi.nlm.nih.gov/15573552/) | Our slides show keywords, not the narrated sentence; `check_storyboard` and the video-research upgrades target this. |
| Animation/simulation effects are **less consistent** than text+diagrams; larger for inference/transfer than for facts. | [Meta-analysis](https://experts.illinois.edu/en/publications/a-meta-analysis-of-richard-mayers-multimedia-learning-research-se/) | Do not expect video to beat the PDF on recall of facts. Expect it on "how does the request flow". |
| Software guidance works best when **showing** is combined with **saying** (annotations/screen control + speech), with a trade-off against learner agency. | [arXiv 2603.02567](https://arxiv.org/abs/2603.02567) | Supports narration + on-screen code together. Warns against fully passive delivery. |
| Multimodal restructured docs: higher task success, lower load. | [arXiv 2605.19174](https://arxiv.org/abs/2605.19174) | Supports the layered set over a single channel. |
| Expert-curated tours + quizzes + podcast: 83% vs 57% quiz score; adopted in production at Beko. | [arXiv 2603.25391](https://arxiv.org/abs/2603.25391) | Closest design anchor (see [DECISION_ANCHOR](../DECISION_ANCHOR.md)). Confirms multi-format + curation works; it did not isolate video. |

Vendor claims ("video onboarding improves retention 82%", "72% say video improves onboarding") appear in Panopto/Wyzowl/Glassdoor-sourced marketing pages. They describe onboarding *programmes*, not video vs text, so they are **not used** as evidence here.

## Strengths
- Covers both use modes the evidence separates: video to *learn* the flow, PDF/`.md` to *look up*.
- Context folder makes the pack **queryable** in Bob (ask "why is ISSUE-001 high?"), which no static format offers.
- Segments naturally: 3-minute video, one-page-per-topic PDF, one file per issue (segmenting principle).

## Weaknesses
- Highest cost: TTS install (Piper ~63 MB voice), ffmpeg, render time, extra check stage; Windows path unverified.
- More things to open = more chance the newcomer opens none. Evidence that extra channels raise completion: not found.
- Synthetic voice is a known weak spot for the voice principle (see vault note `onboarding-video-research`).
- Video and PDF can drift from the repo. Both are generated from `pack.md`, which the gate approves, but nothing re-checks after send.

## Verdict for the PoC
Best expected outcome, but the *video's* marginal value over condition 2 is the least proven part. The `.md` context folder is the piece with a distinct mechanism (interactive Q&A in Bob). Keep video optional (`video: yes|no`), as built.

## Hypotheses (untested)
- H3a: highest score on flow/architecture questions; equal to condition 2 on fact recall (matches PMC4140394 and the Mayer meta-analysis).
- H3b: shortest time to first run and first PR; the video's contribution to this is smaller than the context folder's.

## Proposed experiment (small, LACY-style)
Three groups (or three sessions with the same person on different fictional repos), same pack:
| Measure | How |
|---|---|
| Recall | 10-question quiz: 5 fact (dates, owner), 5 flow (what calls what), same as LACY's quiz method |
| Time to first run | stopwatch, from opening materials to app printing a query |
| Time to first meaningful action | e.g. locating ISSUE-001's code |
| Preference | 3 questions: which did you open, which did you return to |
Report effect direction only; N will be too small for significance. Record in `bob_sessions/`.

## Gaps
- No study compares email vs email+PDF vs +video for technical onboarding. Our comparison is assembled from adjacent work.
- The one direct developer study (text vs video, N=42) is on a tool tutorial, not a codebase onboarding.
- No evidence found on synthetic-voice narration for onboarding specifically.
