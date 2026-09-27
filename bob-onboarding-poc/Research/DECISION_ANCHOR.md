# Decision: anchor solution = LACY

Decided 2026-09-26. Full comparison: [synthesis-05-solutions-mapping](synthesis/05-solutions-mapping.md). Deep dive on the pick: [LACY_DEEP_DIVE.md](LACY_DEEP_DIVE.md).

## Why LACY, over the other candidates

| Candidate | Why not the anchor |
|---|---|
| CIAO | Generates docs, no human gate, no personalization to one hire |
| AgenticAKM | ADRs only, small-scope output (29-repo study, no deployment) |
| Glean / Backstage / Sourcegraph | Retrieval/search infra — out of scope to build in the time left |
| TARS | Personalization only, n=18, no deployed system |
| "Good first issue" | A labeling convention, not a generatable artifact |
| **LACY** | **Deployed on a real 30K+ LOC production system (Beko), the strongest number in the whole set (83% vs 57%), and it's a code tour + human curation — nearly the exact shape of what we're already building** |

LACY wins on every axis that matters for judging: it's deployed (not a lab study), it has the clearest number, and structurally it's almost the same pipeline as our `onboarding-pack` skill — AI drafts a tour, a human curates before it reaches the learner.

## What this means concretely

Our `SKILL.md` already *is* a LACY-shaped pipeline. We didn't restructure it for this — say so explicitly in the video and the Bob Usage Statement:

> "Our design mirrors LACY (Beko, 2026), the strongest published result on this problem: AI-only onboarding tours scored 57% comprehension, expert-curated ones scored 83%. That's why Bob drafts and a manager/senior curates before anything reaches the new hire."

That single sentence pre-empts the "why not just let the AI send it" judge question with a cited number, not an opinion.

## Where we differentiate from LACY (our originality claim)

Don't pitch this as "we copied LACY." Pitch the things LACY doesn't do:
1. **LACY produces one generic tour per repo.** Ours is **personalized per named hire** — role, experience level, and the specific starter tasks assigned to them.
2. **LACY is an IDE-embedded live tour.** Ours is a **portable artifact** (PDF + email) that exists before day 1, no tool install required to get value from stop 1.
3. **LACY's own authors list "proposing starter implementation tasks for newcomers" as future work** (see deep dive, §4). Our quick-win/collaborative/real-slice task sequence already does this.

The other patterns from [synthesis-04-patterns](synthesis/04-patterns.md) (adaptive depth, cited-rationale-or-flag-it, quick-win task ordering) aren't competing alternatives to LACY — they're supporting evidence folded into the same pipeline, each backed by its own smaller study. Keep them as support, not co-equal picks.

## What we're explicitly not building (scope cut)
Don't add anything Sourcegraph/Glean-shaped (semantic search infra, cross-tool retrieval), and don't attempt LACY's dashboard, Voice-to-Tour, or podcast features. Out of scope for the time left, and would dilute the LACY-anchored pitch with an unrelated capability we can't finish or demo well.
