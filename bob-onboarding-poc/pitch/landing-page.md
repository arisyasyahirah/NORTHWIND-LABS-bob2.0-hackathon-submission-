# Landing page copy (v2 — curated from the full POC)

Source of truth for the landing page (Vercel deploy target, per current plan). Pulled from, and citing, the actual project docs rather than restated from memory:
`submission-form.md`, `Development/PIPELINE.md`, `pitch/pipeline-walkthrough.md`, `Development/bob_sessions/northwindlabs_task01_onboarding_pipeline_summary.md`, `Development/risk-mitigation.md`, `Development/onboarding/alex-tan/pack.md`, `Research/DECISION_ANCHOR.md`, `Research/onboarding-research.md`, `Research/synthesis/03-mixed.md`, `Research/channel-comparison/02-email-plus-pdf.md`, `Research/synthesis/06-time-cost-comparison.md` (new — live-fetched and quote-checked 2026-09-27), `Research/synthesis/02-articles.md`, `Research/onboarding-research.md`.

---

## Brand (confirmed, not guessed)

Found in the actual delivered artifact — the onboarding email's `_html_body()` (`bob_sessions/…summary.md`): **black header band `#111111`, yellow wordmark `#f5b800`.** This is the real brand already shipped to the newcomer's inbox, so the landing page reuses it exactly rather than inventing a new palette.

---

## Hero

**Eyebrow:** IBM Bob 2.0 Hackathon — Proof of Concept

**Title:** Bob Onboarding Pipeline

**Tagline:** One `/onboard` command in Bob IDE scans a real codebase and hands a new hire a personalised onboarding pack — a PDF, a narrated code tour, one file per real issue found, and a context folder for their own Bob.

**CTA buttons:** [Read the PDF](#pdf) · [Watch the tour](#video) · [Full source on GitHub](#repo)

---

## The problem — not an anecdote, a recurring pattern

A new hire's first weeks run on a stale README and a senior's re-explained memory — every hire gets a different ramp-up, and the team pays for it twice. Bob Onboarding Pipeline turns "explain the codebase" into one command: Bob interviews the manager, scans the real repo, and builds a pack personalised to that hire's role, start date, and buddy.

**The same pattern shows up across four independent methodologies** — a time-diary field study, a 65,000-developer survey, a large industry DX survey, and interviews at Microsoft — none of them citing each other, all landing on the same shape of problem:

| Finding | Source |
|---|---|
| Developers spend **~58% of their time** on program comprehension, not writing code (79 devs, 3,244 working hours, field study) | Xia et al., IEEE TSE 2018 [A] — [PDF](https://baolingfeng.github.io/papers/tsecomprehension.pdf) |
| **61% of developers** spend 30+ min/day searching for answers; **managers pay too** — 61% spend 30+ min/day *answering* them | Stack Overflow Developer Survey 2024 [S, ~65k devs] — [link](https://survey.stackoverflow.co/2024/professional-developers) |
| **50% of developers lose 10+ hours/week** to non-coding friction; the #1 named time-waster is *finding information* — ahead of writing code itself | Atlassian State of Developer Experience 2025 [V/S] — [link](https://www.atlassian.com/blog/bitbucket/developer-experience-report-2025) |
| **82%** say understanding *why* code is built the way it is takes real effort, **66%** call it a serious problem — and developers skip design docs (don't trust them to stay current) and **interrupt teammates instead** | LaToza et al., ICSE 2006 (Microsoft) [A] — [PDF](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/p492-latoza.pdf) |
| Newcomers ask **44 recurring types of questions** ("where is X?", "how does this data get here?") that no single document answers | Sillito et al., FSE 2006 [A] — [DOI](https://dl.acm.org/doi/10.1145/1181775.1181779) |

**Reading it together:** the pattern isn't "onboarding docs are a bit outdated" — it's that comprehension is the *dominant* activity (not an edge case), the knowledge that would fix it is tacit and undocumented by default, and when it's missing, the cost doesn't disappear, it moves onto a senior's calendar as interruptions. That's the specific cost this pipeline targets: it externalises what would otherwise live only in a senior's head, once, per hire, with citations back to real files and lines.

**It compounds, it doesn't stay flat:** only **12%** of employees strongly agree their company onboards well (Gallup), and **80% of new hires who feel undertrained plan to quit soon, vs. 7% of those who feel well-trained** ([Paychex/Fortune](https://www.paychex.com/articles/human-resources/the-onboarding-crisis)) — so a bad first few weeks isn't just slow, it's a retention risk.

**Narrowing to Southeast Asia, then Malaysia** (full trail in [`Research/synthesis/02-articles.md`](../Research/synthesis/02-articles.md)):
- SEA turnover is **16.6%**; **Malaysia is the region's highest at 17.4%** (Aon, 2026, 1,200+ businesses).
- **63% of Malaysian tech professionals intend to change jobs within 12 months, vs. 53% globally** (Hays Malaysia, ~10k professionals, Aug 2025).
- Malaysia has a roughly **10× shortfall**: government targets 50,000 skilled engineers/year, universities produce ~5,000 (The Diplomat, May 2026) — meaning companies can't hire their way out and have to make less-experienced hires productive faster, the exact problem a personalised, evidence-grounded pack targets.
- **Honestly stated gap:** there is no Malaysia-specific study measuring onboarding *itself* — the turnover/shortage data above is solid and Malaysia-specific, but the link to onboarding quality is inferred from the international mechanism, not locally measured. Same standard as the rest of this page.

---

## How it works — step by step

Condensed from the real 10-stage pipeline (`PIPELINE.md`) and a live run's screenshots (`pitch/pipeline-walkthrough.md`), in order:

1. **Preflight.** Bob activates the `onboarding-pipeline` skill and checks its own MCP email server is registered.
   ![Bob kicks off preflight and activates the onboarding skill](screenshots/01-kickoff-preflight.png)
2. **Intake.** Bob asks for the codebase path (read-only, never modified), the company, and the newcomer's role, start date, manager, and buddy.
   ![Stage 0 intake — codebase, company, and video toggle options](screenshots/04-stage0-intake-batchA-options.png)
3. **Generate — 4 subagents in parallel.** Company & role, architecture & code tour, issue scan, and tech stack all run at once against the real repo.
   ![Stage 1 — four subagents generating in parallel](screenshots/08-stage1-generate-subagents.png)
4. **Deterministic check.** Plain Python — not the model — verifies every cited file and line actually exists in the repo, and that the video script only retells facts already in the pack. Nothing is graded by the thing that wrote it.
5. **Flag.** Anything Bob couldn't confirm goes on a short "flagged for review" list (3–6 bullets) instead of burying it in the full pack.
6. **Human approval — hard stop.** A person reviews the flagged list and the issue index and must approve before anything renders or sends. Tool auto-approve does not count.
   ![Stage 5 — human approval gate showing the flagged issues table](screenshots/10-stage5-human-approval-issues.png)
7. **Render.** The PDF and, if requested, the narrated video are generated from the approved pack.
   ![Stage 6 — rendered onboarding PDF preview](screenshots/13-stage6-pdf-preview.png)
8. **Package & send.** Context folder is zipped, a setup guide is generated for the newcomer, and both the newcomer and manager get an email through the MCP server Bob built for this.
   ![Stage 7 — sent email verified in the test inbox](screenshots/20-verify-ethereal-inbox-email.png)

All 8 images above are real screenshots from the actual run (`pitch/screenshots/`, 22 total; these 6 are the representative subset) — not mockups or stock images.

---

## See it in action

### <a name="pdf"></a>The onboarding PDF
7 pages, personalised for "Alex Tan," a junior backend hire joining the Platform team.
Embed/link: `northwind-labs-onboarding-alex-tan.pdf`

### <a name="video"></a>The narrated code tour
97 seconds. Generated from a 9-scene storyboard via Piper TTS + ffmpeg — every line in it traces back to a fact already in the PDF.
Embed/link: `northwind-labs-onboarding-alex-tan-tour.mp4`

### The context pack
What the newcomer loads into their own Bob to get an assistant that already knows their company, role, and codebase.
Link: `northwind-labs-onboarding-alex-tan-context.zip`

---

## What Bob found — 10 issues, real ones

Verbatim from the generated pack (`pack.md`), severity and titles only — the per-hire fix-by dates aren't relevant here:

| ID | Issue | Severity |
|---|---|---|
| ISSUE-001 | Hardcoded Database Credentials in Source Code | critical |
| ISSUE-002 | Hardcoded Stripe API Key and Webhook Secret | critical |
| ISSUE-003 | Passwords Stored and Compared in Plain Text | critical |
| ISSUE-004 | SQL Syntax Bug in CustomerDAO.deleteCustomer | high |
| ISSUE-005 | No Unit or Integration Tests in the Repository | high |
| ISSUE-006 | Database Connection Per-Request Leak (No Connection Pool) | high |
| ISSUE-007 | Duplicate Servlet Declarations in web.xml | medium |
| ISSUE-008 | AuthFilter Does Not Handle Null Session Attribute Safely | medium |
| ISSUE-009 | Customer Password Exposed in Session / Model Object | medium |
| ISSUE-010 | No Input Validation or Output Encoding on JSP Pages | medium |

Each one is its own file with evidence at file and line, and guidance — never a silent patch.

---

## Results

From the actual `/onboard` run against a Java/JSP web app (Cinema Ticket Management System), logged stage by stage in `run-log.md` — not a mockup:

| Metric | Value |
|---|---|
| Issues found | 10 (incl. 3 sets of hardcoded credentials) |
| PDF | 7 pages |
| Narrated video | 97s, 4.0 MB |
| Context zip | packaged, loadable into the newcomer's own Bob |
| Emails sent | 2 (newcomer + manager), via a Bob-built MCP server, to a test inbox |
| Machine time — the pack | ~21 minutes (`pipeline_tools.py time`, excl. approval and the optional video) |
| Machine time — optional video | 35 minutes in this run (layout fix loop + re-render) |
| Human time | ~1 minute approval (+ ~2 min answering intake) |

### Time & cost — the manual alternative

No published study benchmarks "hours to hand-write one onboarding pack" — checked directly, see [`Research/synthesis/06-time-cost-comparison.md`](../Research/synthesis/06-time-cost-comparison.md) for the search trail, including two candidate stats that were dropped after their source pages didn't actually back them up. So this is built transparently instead of importing a number that doesn't fit:

| | Manual (senior writes it) | This pipeline |
|---|---|---|
| Time | **~4–8 hrs** (estimate — mapped against this pack's actual sections: architecture, ownership, 10 issues with evidence, timeline, manager brief; closest real proxy is ~2 hrs for a dev-workflow doc alone, per [document360.com](https://document360.com/blog/code-documentation/)) | ~20 min machine + **~1 min** human (approval gate) |
| Cost, at Malaysia senior-dev rate (RM55–85/hr, [secondtalent.com](https://www.secondtalent.com/developer-rate-card/malaysia/)) | **RM 220 – 680** in senior time | **~RM 1–1.50** (the 1-minute approval) |

**Net claim, at the confidence it deserves:** roughly a 99% cut in the *senior's own active time* per hire — a transparent estimate built from real cited proxies, not a measured study result. `manual_hours` in `intake.yaml` is still blank; filling it with a real number (this range, or your own) and re-running `pipeline_tools.py time` would replace this estimate with the pipeline's own computed output.

### Impact, if this scales (projected, not measured — this PoC ran once)

Framed honestly as "why this would matter," not as a result this one run proved:

- Program comprehension eats **~58% of a developer's time** (Xia et al., IEEE TSE 2018, 79 devs). A pack that front-loads architecture, ownership, and known issues targets that specific cost — this run didn't measure a reduction in it.
- New hires who *feel* undertrained are far more likely to leave early — **80% plan to quit soon, vs. 7% of those who feel well-trained** (Paychex/Fortune 2023 survey, general workforce, not developer-specific). Cited as motivation for why onboarding quality matters, not as this project's own retention data.
- New hires reach their 10th pull request in **91 days on average, vs. 49 with daily AI-tool use** (DX 2025, 6 multinational enterprises) — the source itself flags this as **correlational, not causal** (faster developers may simply adopt AI more). Included because it's the closest available proxy for "faster ramp-up," not because it isolates this pipeline's effect.
- The stakes if onboarding fails are large regardless of exact hours: replacing a technical hire costs **100–150% of their annual salary** (Gallup/peoplekeep, via [builtin.com](https://builtin.com/recruiting/cost-of-turnover)), and Malaysia already has the region's highest turnover (17.4%) and intent-to-leave (63%) — see [`Research/synthesis/02-articles.md`](../Research/synthesis/02-articles.md). The ~4–8 hrs this pipeline saves per hire (see Time & cost, above) is the small, provable number; this is the larger number it's a hedge against.

---

## Advantages & limitations — stated plainly

Pulled directly from the project's own design decision (`Research/DECISION_ANCHOR.md`) and risk triage (`Development/risk-mitigation.md`), not softened for the pitch.

### Advantages

- **Personalised per hire, not one generic tour.** Role, experience level, start date, buddy, and starter tasks are specific to the named person — most comparable tools (e.g. LACY) generate one tour per repo, reused for everyone.
- **A portable artifact, not a tool you must install first.** PDF + email land before day 1; a live IDE-embedded tour needs the tool set up before it delivers any value.
- **Grounded, not self-graded.** A deterministic Python check — not the LLM — confirms every citation exists in the repo before anything ships.
- **A human always signs off.** The approval gate is narrowed to a short flagged list (3–6 bullets), not skipped — same idea as a code-review tool surfacing only the diff, not the whole file.
- **Fresh per hire, not stale once.** Unlike a one-time tour published once and reused for months, this pack regenerates from the live repo for every new hire, so it barely goes stale.
- **Questions go somewhere real.** The email's reply-to is the newcomer's actual buddy — no new Q&A system to build or maintain.

### Limitations (and what would come next)

- **Proof of concept, tested on one project so far.** Not yet validated across multiple codebases or a real onboarding cohort — stated here, not hidden. *Next: run it against a second, larger real codebase.*
- **The Malaysia-specific need is inferred, not locally measured.** It's built from a directly-measured international mechanism (comprehension cost) plus a peer-reviewed Malaysian skill-gap study — not a local onboarding study, which was out of scope for a 48-hour build. *Next: a real regional onboarding study, if this moves past PoC.*
- **Some of the underlying research is early-stage.** Several supporting studies are arXiv preprints or small samples (LACY n=5/2, TARS n=18); the headline claim leans on the one large peer-reviewed result. *Mitigated by leaning hardest on that result, not the smaller ones — see Sources below.*
- **No live Q&A tool.** Follow-up questions route to the buddy's inbox via reply-to, not an interactive assistant. *Deliberate scope cut, not an oversight — see Sources for why a named mentor already does most of this job.*
- **Headless automation (`bob run`) unconfirmed.** The pipeline runs interactively inside Bob IDE; it doesn't depend on headless/CI execution working.

---

## Grounded in research, not vibes

The Problem section above already sourced *why the problem is real*. These are different sources, backing *why the design is built this specific way* (human-curated, personalized, portable PDF) — not a repeat of the same citations. Full bibliography in the repo's `Research/` folder:

| Design choice | Backed by |
|---|---|
| A human curates before anything sends, rather than shipping raw AI output | Expert-curated code tours score **83%** on comprehension quizzes vs. **57%** for AI-only tours (real deployment, Beko) — LACY, arXiv 2603.25391 — [link](https://arxiv.org/abs/2603.25391) |
| Personalised per hire, not a generic tour | Integration depends on early experimentation and being able to check your own progress — Dagenais et al., ICSE 2010 (IBM Research) — [link](https://research.ibm.com/publications/moving-into-a-new-software-project-landscape) |
| Malaysia framing in the Problem section | Malaysian employers' largest graduate skill gap is communication & collaboration, then problem-solving (376 employers) — Tee et al., F1000Research 2024 — [link](https://f1000research.com/articles/13-389) |
| A PDF with diagrams and tables, not plain text | Text + diagrams together produce large, consistent learning gains (multimedia effect, pooled g = 0.37) — Mayer multimedia meta-analysis — [link](https://experts.illinois.edu/en/publications/a-meta-analysis-of-richard-mayers-multimedia-learning-research-se/) |

---

## Under the hood (for judges skimming fast)

Bob-native, not a hosted web app: a packaged Bob skill (`/onboard`) runs the 10 stages above end to end in Agent mode. Bob also **built its own delivery tool** mid-run — a stdlib MCP email server (`send_onboarding_email`, 14 passing unit tests) — registered it, hit a bug (attachment param mismatch), fixed it, and re-sent. Full technical + Bob-usage writeup: see the repo.

---

## Footer

- **Full source & docs:** https://github.com/arisyasyahirah/NORTHWIND-LABS-bob2.0-hackathon-submission-
- **Built for:** IBM Bob 2.0 Hackathon (lablab.ai)
- **Status:** proof of concept, tested on one project so far

---

## Open placeholders (fill before HTML build)

- Confirm PDF/video embedded inline vs. link-out — moot for the `.gitignore`/repo problem now that deploy is via Vercel (uploads a local folder directly, not git), but still a real design choice
- ~~Decide which screenshots get embedded~~ — resolved: 6 of the 22 real screenshots (`pitch/screenshots/*.png`) are now embedded as actual images in "How it works," not just filename-referenced. Remaining 16 stay linkable from the full walkthrough (`pitch/pipeline-walkthrough.md`) if a judge wants the complete trail.
