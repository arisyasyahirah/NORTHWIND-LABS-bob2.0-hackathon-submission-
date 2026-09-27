# LACY reverse-engineered

Kara, İsmail, Ateş, Tamcı, İyigün, Aslangül, Devran, Uçar, Tüzün. **"LACY: Simulating Expert Mentoring for Software Onboarding with Code Tours."** FSE 2026 Companion (industry track). Bilkent University + Beko. arXiv:2603.25391.
Replication package: https://figshare.com/s/6a261d3382b116d8494f

This is our chosen anchor (see the pick rationale at the bottom). Everything below is reverse-engineered from the paper text, not from using the tool.

---

## 1. How it works

LACY is a **VS Code extension**. Two roles: **codebase experts** (create tours) and **codebase learners** (consume them). The same person can be both, on different projects.

It ships 3 tour-generation pipelines, sitting on a human↔AI spectrum:

| Pipeline | Who authors | AI involvement |
|---|---|---|
| Manual Guided Tour | expert only | none — preserves tacit knowledge AI can't infer |
| **AI-Assisted Guided Tour** (the core one) | expert + AI | expert scopes it, AI drafts, expert edits/approves |
| Exploratory Tour | learner (self-serve) | fully automatic, no expert in the loop — used when no guided tour exists yet |

### The AI-Assisted Guided Tour pipeline, step by step
1. **Expert scopes it.** Inside the IDE, the expert highlights files/code segments to define what the tour covers. Input can be typed or **spoken** (speech-to-text via ElevenLabs).
2. **AI drafts it.** The scoped context goes into a prompt template. Production model: **Gemini-2.5-Flash** (falls back to local/on-prem models if external LLM use is restricted). Output is structured JSON: ordered tour steps, each an explanation anchored to a file location, plus quiz items.
3. **Expert reviews and edits** the JSON in an editable in-IDE interface — this is the human gate. Edits observed in their study clustered around: adjusting complexity, adding domain-specific context, adding warnings/edge cases.
4. **Publish & assign.** Finalized tour is stored in an internal DB and assigned to specific learners/teams.
5. **Learner consumes it** in-IDE: sequential steps, each highlighting the relevant code, notes attachable per step, async Q&A back to the expert, then a quiz at the end.

### Supporting features (each ties to a specific pain point they found in interviews)
- **Voice-to-Tour**: record an expert explaining code live (e.g. during a real pairing session) → LLM turns the transcript + which files were touched, in what order → a structured tour. This is their answer to "the best explanations happen once, informally, and are never captured."
- **Podcast**: tour content → a 2-speaker (expert/learner) dialogue script → TTS audio (ElevenLabs), NotebookLM-style. A secondary modality, not the primary learning path (rated lower than the tour itself, M=3.2–3.4/5).
- **Quizzes**: AI drafts questions from the tour content, expert reviews/adds domain-specific ones, each question links back to its tour step so a wrong answer sends the learner back to the relevant code.
- **Expert dashboard**: per-learner completion + quiz scores, aggregate stats across teams, the async Q&A inbox, assign tours to learners/track completion.

---

## 2. Architecture

```
                    ┌─────────────────────────────┐
  Expert (voice/text,│  Module 1: Context & Prompt │
  cursor-selects     │  Preparation                │
  files/code) ───────▶  - STT (ElevenLabs)          │
                    │  - file/code-segment scope   │
                    └──────────────┬──────────────┘
                                   │ formatted prompt
                                   ▼
                    ┌─────────────────────────────┐
                    │  Module 2: AI-Driven Tour   │
                    │  Generation                  │
                    │  - LLM (Gemini-2.5-Flash,    │
                    │    or local model)           │
                    │  - → structured JSON:        │
                    │    tour steps + explanations │
                    │    + quiz items              │
                    │  - podcast: 2-speaker script  │
                    │    → TTS (ElevenLabs)         │
                    └──────────────┬──────────────┘
                                   │ editable draft
                                   ▼
                    ┌─────────────────────────────┐
                    │  Module 3: Collaborative     │
                    │  Review, Feedback & Iteration│
                    │  - expert edits/approves     │
                    │  - publish → internal DB     │
                    │  - assign to learner group   │
                    └──────────────┬──────────────┘
                                   │
                     ┌─────────────┴─────────────┐
                     ▼                           ▼
            Learner (in-IDE tour,        Expert Dashboard
            notes, async Q&A,            (completion, quiz
            quiz at the end)             scores, Q&A inbox)
```

Solid lines = the primary flow. Dashed lines (not reproduced above) = optional shortcuts, e.g. skipping straight to Exploratory Tour with no expert step at all.

**Stack, concretely:** VS Code extension (client) + an internal database (tours + podcasts as BLOBs) + Gemini-2.5-Flash for text generation + ElevenLabs for STT and TTS. No custom model training — it's prompt-engineering plus a UI/workflow layer around off-the-shelf APIs. That's the whole trick: the "AI" part is a thin wrapper, and **the workflow around the human review step is the actual invention.**

---

## 3. Why the impact is significant

### The numbers, all of them (not just the headline)
| Metric | Guided (AI + expert curation) | Exploratory (AI-only) | Gap |
|---|---|---|---|
| Quiz score | **83%** | 57% | **+26 points** |
| Expert rating of learner comprehension | 79% | 76.8% | +2.2 points |
| Time to complete | ~25 min | ~35 min | curated tours were **~10 min faster**, despite being 3–5 steps *longer* |
| "Tour felt like a senior dev walking me through it" | 4.2/5 | 3.8/5 | — |

### The finding that matters most for our pitch: the perception–performance gap
Learners only **moderately** agreed curation added value over AI-only (M=3.4/5) — but their actual quiz scores told a different story (+26 points). The paper's own read: *"organizations that rely on satisfaction ratings alone will systematically undervalue [curation] and default to the faster AI-only path."*

**This is the single most important sentence in the paper for our design.** It says: don't ask users if they think the human gate is worth it — they'll say "eh, AI alone felt fine." The gate has to be a design decision backed by measurement, not user preference, because users can't self-assess what they don't know they're missing.

### Why it worked (mechanism, not just outcome)
- Experts spent time on what AI *can't* infer: "domain context, design rationale, and organizational knowledge." AI handled drafting/structuring. Clean division of labor, not overlap.
- One IT Director, on why AI-only isn't enough: *"Only about 20% of the code handles the critical business logic, and AI cannot tell you which 20%."* — AI doesn't know what to prioritize; that's the exact thing expert curation adds.
- Reduced expert burden **at the workflow level, not just per-session**: creating one guided tour ≈ 30 min of expert time (vs. 20 min for one live walkthrough) — but a *tour* serves N learners, so **per-learner expert time drops from 20 min to 30/N min**. One senior dev's quote: *"onboarding has effectively been reduced to a couple of minutes of setup and guidance with code tours I prepared, instead of time-consuming walkthrough sessions."*
- Organizational bus-factor motivation: the two engineers with deep knowledge of the test codebase (a 30K+ LOC legacy finance system, Bankhet) had **already moved into management** — the knowledge was actively at risk of being lost, not hypothetically.
- Beko adopted it into production after the study, not just as a research demo.

---

## 4. Other things worth knowing before we borrow from it

**Study design, so we can judge how strong the evidence really is:**
- Within-subjects: **5 learners**, each did both conditions (guided vs. exploratory), order counterbalanced. 2 domain experts (16 and 22 years' experience). This is a **small n** — real developers, real stakes (ecological validity is high), but not a large-sample RCT. Treat +26 points as a strong signal from a small, realistic study, not as a population-level guarantee.
- No traditional-documentation baseline — Bankhet had no existing docs to compare against.
- Learners: avg. 4.6 years' programming experience, but little/no prior exposure to Bankhet specifically.

**Baseline pain, before LACY (their pre-study survey), useful for our own problem statement:**
- 80% of learners had only an *informal* mentor; 20% had none.
- 80% were reluctant to interrupt colleagues; 80% didn't know what to ask (two separate, both at 80%).
- Time to productivity: 40% took 5+ months.
- Experts: 20–40 hours spent per new hire; repetitive explaining rated M=4.5/5 as a burden.

**Threats to validity the authors flag themselves:**
- **Tour staleness**: tours reference concrete code, so they can rot as code changes. They argue tours are cheaper to regenerate than to maintain as living docs — this is a claim, not something they measured over time.
- **LLM/organizational risk**: some orgs won't allow an external LLM on their code; they note local-model fallback but didn't evaluate it.
- Self-reported survey data (subjective).

**Prior art LACY positions itself against** (useful — these are papers *we* haven't separately covered):
- **CodeTour** (Microsoft's real VS Code extension, 422k+ installs) — manual-only, no AI, no assignment-to-learner tracking beyond basic linking.
- **Balfroid et al.** (2024/2025) — fully-automated code tours for *debugging* scenarios (stack traces → CodeQL → GPT-3.5), not onboarding. LACY explicitly forks from this into onboarding + hybrid curation.
- **Onboarding Buddy** (Ionescu et al. 2025) — the same paper we already cited in [synthesis-05-solutions-mapping](synthesis/05-solutions-mapping.md); LACY name-checks it as an example of *minimizing* human interaction, in contrast to their own hybrid stance.
- Cited stat worth reusing: Khojah et al. found 62% of ChatGPT use in software engineering is *consultation* (asking, not generating), and Kumar et al. found experienced devs get expert-level answers from AI 70% of the time vs. 48% for less-experienced devs — i.e. **AI helps people who already understand the codebase more than newcomers who don't**. This is a good supporting citation for why raw AI chat isn't enough for onboarding specifically.

**Their own stated future work** (gaps *we* could credibly claim to fill, which strengthens our originality argument):
> "generating code tours from codebase analysis, version control, extracting historical data or design documents, and **proposing starter implementation tasks for newcomers beyond quizzes**."

That last clause is close to our starter-task feature. Worth citing as: "LACY's own authors flag starter-task generation as future work; our skill implements it."

---

## 5. How this maps onto our `onboarding-pack` skill

| LACY concept | Our equivalent | Note |
|---|---|---|
| Module 1: expert scopes files | our `hires/*.yaml` + `roles/*.md` scope the subagents | ours is pre-scoped by role, not manually highlighted per-session |
| Module 2: AI drafts JSON tour | our 4 subagents draft the markdown pack | we use markdown, they use structured JSON + a custom renderer |
| Module 3: expert edits/approves before publish | our "senior/manager curates" step | direct match — same rationale (the 83 vs 57 finding) |
| Quiz, linked to tour steps | our week-1 checkpoints, linked to file paths | direct match |
| Dashboard (completion, scores) | **not built** — out of scope for a PoC | explicitly the biggest structural gap vs. LACY |
| Voice-to-Tour | **not built** | would require live-session capture; not feasible in the hackathon window |
| Starter-task generation | our quick-win/collaborative/real-slice tasks | LACY doesn't have this yet (their own future-work item) — this is a genuine point of originality over LACY, not just over the market |
| IDE-embedded delivery | our delivery is a **portable PDF + email** | deliberate difference — no IDE lock-in for day-1 value, at the cost of no in-context navigation |

**Bottom line for the pitch:** we're not cloning LACY, we're taking its one load-bearing, measured design decision (curate before publish) and its one acknowledged gap (starter-task generation) and building around both, in a lighter, portable form suited to a 48-hour build.

Full per-module architecture mapping (which Bob mechanism realizes which LACY module, plus the diagram): [Development/bob-implementation-architecture.md](../Development/bob-implementation-architecture.md).
