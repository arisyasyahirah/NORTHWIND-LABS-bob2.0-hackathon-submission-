# Synthesis: email vs email+PDF vs email+PDF+video+context .md

Sources and per-condition detail: [01](01-email-only.md) · [02](02-email-plus-pdf.md) · [03](03-email-pdf-video-md.md). Broader onboarding synthesis: [../synthesis/04-patterns.md](../synthesis/04-patterns.md). Written 2026-09-27.

## Bottom line
No study tests these three bundles head to head for technical onboarding. Across the adjacent evidence, the same few patterns recur, and they predict the order **email < email+PDF < email+PDF+video+context**, with most of the gain from the PDF and the context folder, and the least-proven gain from the video.

## Recurring patterns

| # | Pattern | Where it shows up | Strength |
|---|---|---|---|
| P1 | **Structure and load beat channel.** How content is chunked and de-cluttered matters more than which medium carries it. | Restructured docs cut cognitive load and raised task success ([2605.19174](https://arxiv.org/abs/2605.19174)); email fails on overload, not on being email; redundancy interferes ([15573552](https://pubmed.ncbi.nlm.nih.gov/15573552/)) | Strong (3 independent lines) |
| P2 | **Learn vs look-up split.** Video is preferred for *learning* something new, text for *looking up* a missed detail. | Dev text-vs-video study ([1704.00074](https://arxiv.org/abs/1704.00074)); text+diagram effects are large and consistent (Mayer meta-analysis, g = 0.37) | Medium (one direct dev study, N=42) |
| P3 | **Video helps procedures and flow, not facts.** | Clinical RCT: better practical exam, no theory difference ([PMC4140394](https://pmc.ncbi.nlm.nih.gov/articles/PMC4140394/)); animation effects larger on inference/transfer than facts (meta-analysis); devs applied faster with video but ended equal | Medium (different domains agree in direction) |
| P4 | **Words + pictures beat words alone; identical words twice hurt.** Diagrams/tables add, duplicated narration and on-screen text subtract. | Mayer meta-analysis; redundancy study; "show it, don't just say it" ([2603.02567](https://arxiv.org/abs/2603.02567)) | Strong |
| P5 | **Curation beats raw generation.** Expert-checked material outperforms AI-only. | LACY: 83% vs 57% quiz ([2603.25391](https://arxiv.org/abs/2603.25391)). Ties to our approval gate | Medium (one study, but our design anchor) |
| P6 | **Passive delivery gets ignored or under-used.** People skim/discard email; a passive video is not clearly better than text if learners are unmotivated; agency matters. | Bulk-email studies (22% retained, open-then-discard); dev study's "provided you manage to motivate learners"; 2603.02567 agency trade-off | Medium |
| P7 | **A named human still anchors it.** Mentoring is a top factor; even the best tool aims to cut expert consultations, not remove them. | [1311.1334](https://arxiv.org/abs/1311.1334); LACY | Medium |
| P8 | **Evidence quality is thin and adjacent.** Students, small N, different domains, lab settings; the loud numbers come from vendors. | All three files' Gaps sections; Panopto/Wyzowl/Glassdoor figures excluded | (meta-pattern) |

## What the patterns imply per condition

| | Email | Email+PDF | Email+PDF+video+.md |
|---|---|---|---|
| Structure/load (P1) | Poor: cannot chunk a technical pack | Good: fixed sections, tables | Good: layered, one file per issue |
| Diagrams (P4) | None | Yes | Yes, plus animated flow |
| Learn (P2/P3) | Weak | Weak-medium (reads *about* the flow) | Best: video shows flow and code |
| Look-up (P2) | Poor | Best single artefact | PDF + searchable `.md` |
| Interactivity (P6) | None | None | Bob Q&A over the context folder |
| Curation (P5) | n/a | Gate before send | Gate covers pack, PDF, storyboard |
| Cost/friction | Lowest | Low | Highest (TTS, ffmpeg, render) |

## Where patterns conflict
- **P2 vs "more channels = better":** if video mainly duplicates the PDF, P1 (overload) and P6 (more things to open) argue against it. Video earns its place only by covering the *flow*, which the PDF shows worst.
- **P3 vs our video content:** facts (dates, owners, issue lists) belong in the PDF and `.md`. Putting them in narration wastes the medium. The storyboard should carry flow, code path and "what to do first", which matches the shipped scenes (points, flow, code).

## Design implications for the PoC
1. **Email = cover note** (P1, P6): 5-8 lines, buddy named (P7), points to the rest.
2. **PDF = reference** (P2, P4): tables and diagram, fixed order, no invented facts.
3. **Video = one job: the request flow and first code read** (P3). Keywords on screen, sentences in audio (P4 redundancy). Keep optional.
4. **Context `.md` folder = the queryable layer** (P6): the only interactive piece. Its distinct value should be tested first.
5. **Keep the human gate** (P5) and the named buddy (P7).

## Suggested test order (cheapest signal first)
1. Context folder vs none, on the flow questions (largest expected effect, cheapest to build).
2. PDF vs email, on recall of timeline and issues.
3. Video vs no video, on flow questions and time to first run only. Skip fact recall (P3 predicts no gain).

## Confidence
Direction of the ordering: moderate. Size of any effect for *our* bundle: unknown. P5 and P1 are the most trustworthy patterns; P2 and P3 rest on one developer study plus non-developer studies. All H-numbered hypotheses in 01-03 remain untested.
