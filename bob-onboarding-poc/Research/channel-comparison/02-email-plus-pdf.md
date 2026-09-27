# Condition 2: Onboarding email + onboarding PDF

Part of the channel comparison: [01 email](01-email-only.md) · [02 email + PDF](02-email-plus-pdf.md) · [03 email + PDF + video + context .md](03-email-pdf-video-md.md). Written 2026-09-27.

## What this condition is in our project
Email (cover note) plus `<company>-onboarding-<slug>.pdf`, rendered by `render_pdf.py` from `pack.md` via the pycairo brochure kit: why we exist, what you own, timeline table, architecture at a glance, run-it-first steps, issues table, starter tasks, people to meet, sources.

## Evidence
| Finding | Source | Fit to our case |
|---|---|---|
| Multimedia effect: pooled effect of Mayer's principles **g = 0.37** (1990-2022). **Text + diagrams** gave large, consistent effects on factual, inferential and transfer outcomes. | [Meta-analysis, U. Illinois](https://experts.illinois.edu/en/publications/a-meta-analysis-of-richard-mayers-multimedia-learning-research-se/) | Strongest argument for the PDF over plain email: it can hold tables, a request-flow diagram and a timeline. Effects are lab-based, mostly students. |
| Restructuring onboarding docs with multimedia-learning rules (task-based chunks, no redundancy, visuals) gave higher task success and **lower cognitive load** (N=14 newcomers, between-subjects). | [arXiv 2605.19174](https://arxiv.org/abs/2605.19174) | Same domain (software onboarding docs). Small N; treat as a signal. |
| For developers learning a tool, a **text** tutorial let learners finish faster; video learners applied faster; end performance roughly equal (N=42). Learners **use text to look things up**. | [arXiv 1704.00074](https://arxiv.org/abs/1704.00074) | PDF's real job is reference: the newcomer returns to it for the timeline and the issue list. |
| Mentor-guided tours: 83% quiz score vs 57% for AI-only tours; participants preferred tours over traditional self-study. | [LACY, arXiv 2603.25391](https://arxiv.org/abs/2603.25391) | Says a static doc/self-study is the weaker baseline, and *expert curation* matters more than format. Our pipeline has a human approval gate for this reason. |
| Dense, inconsistent, fragmented docs cause abandonment. | [arXiv 2605.19174](https://arxiv.org/abs/2605.19174) | Design rule: one PDF, fixed section order, `Not specified: ask your manager` instead of invented facts. |

## Strengths
- Durable, printable, offline, attachable (<20 MB cap in our `deliverables` check).
- Can show structure: timeline table, severity-tagged issues, diagram-able request flow.
- Good lookup behaviour: newcomers return to it (text tutorial finding).

## Weaknesses
- Passive. The newcomer reads about `main() -> get_user()` but never sees it in code; no path:line context is clickable in a PDF.
- Static: goes stale when the repo moves; nothing checks it after send.
- Some newcomers won't open an attachment on day 1 (link/attachment open rates are low in the email evidence above; no PDF-specific number found).

## Verdict for the PoC
This is the **minimum useful deliverable**. Adds structure and lookup value over email alone at low cost. It does not by itself give a newcomer a way to *work* with the codebase (that is what the context folder does; see condition 3).

## Hypotheses (untested)
- H2a: higher recall of timeline, ownership and issue list than email only; still weak on "how the code flows".
- H2b: shorter time to first run than email only, because run steps are numbered and complete.

## Gaps
No study found comparing email vs email+PDF for *technical* onboarding. The g = 0.37 figure is for multimedia principles in general, not for PDFs.
