---
name: synthesis-04-patterns
description: Recurring patterns across all onboarding research/articles and what each implies for the Bob onboarding-pack skill design
metadata:
  node_type: memory
  type: reference
  originSessionId: 54373b6a-d3eb-4b3c-a38f-dfe67c8deed3
  modified: 2026-09-26T04:54:48.732Z
---

# 4 · Recurring patterns → design implications

Part of the [ibm-bob-2-hackathon-requirements](../requirements.md) research. Built from [synthesis-01-research-papers](01-research-papers.md), [synthesis-02-articles](02-articles.md), [synthesis-03-mixed](03-mixed.md). Compiled 2026-09-26.
This is the file to pull from when writing the Problem Statement and the Bob Usage Statement (500 words each).

---

## Pattern 1: Comprehension, not writing code, is the bottleneck — everywhere
Appears in: Xia et al. (58% of time), Atlassian (finding info is the #1 time-waster, not coding), Stack Overflow (30–60+ min/day searching), DX (91 days to the 10th PR).
**Implication:** the product should be judged on comprehension time saved, not lines of code generated. This is already the [onboarding-effectiveness-research](../onboarding-research.md) design (architecture section, code tour). Keep the demo's "before/after" metric framed as *time to first productive PR*, matching DX's own metric, since judges may know it.

## Pattern 2: The knowledge that matters most is the knowledge nobody wrote down
Appears in: LaToza et al. (82% — rationale is tacit), Sillito et al. (44 unanswered question types), Stack Overflow (managers spend 30+ min/day *answering*, confirming the tacit-knowledge queue is real).
**Implication:** the skill must **cite its source** for every "why" claim (ADR, README, commit, comment) and say **"Unknown — ask your buddy"** rather than guess. This is already in [onboarding-effectiveness-research](../onboarding-research.md) rule 2. Reinforce it: this single rule is the direct fix for the single most cited problem across both research and industry data.

## Pattern 3: Pure AI underperforms; curated/hybrid AI wins
Appears in: LACY (83% vs 57%), the LLM code-tour study (unreliable self-grading), METR (AI can slow experienced devs down), Onboarding Buddy (weak n=8 result for an AI-only assistant).
**Implication:** don't pitch "Bob replaces the manager/mentor". Pitch "Bob drafts, a human curates before sending" — this is your **human approval gate**, and it's now backed by the strongest single number in the whole research set (83 vs 57). Say this explicitly in the video: it pre-empts the "isn't this just removing humans entirely" judge question.

## Pattern 4: Turnover and skill gaps compound as you localize
Appears in: Aon (Malaysia's turnover is the *highest* in a region that's already above international churn), Hays (63% vs 53% global intent-to-leave), The Diplomat (10x engineer shortfall), Tee et al. (communication/problem-solving gap in Malaysian graduates).
**Implication:** this is the strongest, most defensible "Business Value" argument, because it's not one number, it's four independent sources agreeing that the *local* case is worse than the *global* case on every axis (turnover, intent to leave, pipeline, and the exact soft skills onboarding relies on). Use the chain from [synthesis-03-mixed](03-mixed.md), but flag clearly which parts are inferred vs measured — a judge who checks a source and finds you overstated it will mark down Originality/Presentation harder than if you'd underclaimed.

## Pattern 5: Structure the response around what newcomers actually do, not what companies think they need
Appears in: Sillito et al. (44 real questions), Dagenais et al. (early experimentation, progress validation), Steinmacher et al. ("finding a way to start" is the top barrier).
**Implication:** don't structure the pack as generic HR content ("welcome!", "our values"). Structure it as: run it first → a code tour that answers real newcomer questions → checkpoints that let the hire verify their own progress. This is already the current skill design; the pattern confirms it rather than changing it.

## Pattern 6: Depth should adapt to the person, not be one-size-fits-all
Appears in: the modelling study (below-median hires gained +15 points; above-median regressed slightly), TARS (personalization → 26% faster), Explanation Window (tailor to role/experience/goals).
**Implication:** the `experience: junior/mid/senior` field already added to the hire file is directly supported by 3 separate sources. Worth stating in the Bob Usage Statement as a deliberate design choice, not a nice-to-have.

---

## Net takeaway for the pitch
Every pattern points the same direction: **the problem is real and measured internationally, the human fix (mentors) doesn't scale, naive AI fixes underperform without a human gate, and Malaysia's labour market makes the whole problem larger and more frequent than the global average.** The PoC's specific design choices (cited rationale, human curation gate, adaptive depth, real-file code tour) each map to a specific finding, not a guess.

**Weakest link to flag honestly, if asked:** there is no direct study measuring developer-onboarding-specifically in Malaysia or SEA. The local case is built by chaining separate, real numbers (turnover, skill gaps, pipeline shortfall) onto an international mechanism (58% comprehension time), not by a single study that measured all of it together. See the inferred/measured table in [synthesis-03-mixed](03-mixed.md).
