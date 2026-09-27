---
name: synthesis-01-research-papers
description: "Synthesis of peer-reviewed and preprint research on developer onboarding problems, international → regional → Malaysia"
metadata:
  node_type: memory
  type: reference
  originSessionId: 54373b6a-d3eb-4b3c-a38f-dfe67c8deed3
  modified: 2026-09-26T04:53:29.801Z
---

# 1 · Research paper synthesis: the problems of onboarding developers

Part of the [ibm-bob-2-hackathon-requirements](../requirements.md) research. Next: [synthesis-02-articles](02-articles.md) → [synthesis-03-mixed](03-mixed.md) → [synthesis-04-patterns](04-patterns.md).
Full paper list and design rules: [onboarding-effectiveness-research](../onboarding-research.md). Compiled 2026-09-26.

Evidence grades: **A** = peer-reviewed with a large sample · **B** = peer-reviewed, small sample · **C** = arXiv preprint.

---

## Level 1: International

### Problem 1: Understanding code, not writing it, is the main cost
- **Xia et al., IEEE TSE 2018** [A]: across 79 professional developers and 3,244 hours, **~58% of time went to program comprehension**. Juniors and developers on maintenance projects spent significantly more.
- **Arch. documentation study, arXiv 2305.17286** [C]: in a study of 65 participants, **prior exposure to source code** predicted architecture understanding. The format of the docs did not.
- → Onboarding is mostly a *comprehension* problem, and it is worst for exactly the people being onboarded: juniors joining existing systems.

### Problem 2: The critical knowledge is tacit and undocumented
- **LaToza et al., ICSE 2006** [A, Microsoft]: mental models of code "live in heads". **82%** say understanding *why* code is the way it is takes a lot of effort, and **66%** call rationale a serious problem. Developers **skip design docs** (they don't trust them to be current) and **interrupt teammates** instead.
- **Sillito et al., FSE 2006** [A]: newcomers ask **44 recurring types of questions**, from "where is X?" to "how does this data get here?". Most of them aren't answered by any single document.
- **Arch. Explanations, arXiv 2503.08628** [C]: architecture is mostly passed on *orally*. People being onboarded want structure, behaviour **and rationale**, tailored to their role.
- → What the new hire needs most is exactly what nobody wrote down.

### Problem 3: Newcomers don't know where to start
- **Steinmacher et al., IST 2015** [A, systematic review]: 15 barriers in 5 categories. The key technical one is **finding a way to start**.
- **Dagenais et al., ICSE 2010** [A, IBM Research, 18 newcomers across 18 projects]: integration depends on **early experimentation, internalizing the structure, and being able to check your own progress**. Without those, newcomers stall.

### Problem 4: Human mentoring works but doesn't scale
- **LACY, arXiv 2603.25391** [C, industry deployment at Beko]: expert walkthroughs are the most effective support but are "**expensive, repetitive, and do not scale**". Expert-curated tours scored **83%** on comprehension quizzes vs **57%** for AI-only tours.
- **Ju et al., ICSE 2021** [A, Microsoft]: mentors are the bridge between newcomer and team. Task choice (a quick win first) shapes confidence.
- → Seniors are the bottleneck, and the obvious fix (pure AI) loses about 26 quiz points.

### Problem 5: AI-generated onboarding is unreliable without guardrails
- **LLM code tours, arXiv 2607.26987** [C, 26 devs]: when the LLM judged tour quality itself, the judgements showed **sycophancy, confabulation, incoherence**.
- **Onboarding Buddy, arXiv 2503.23421** [C, n=8]: an AI onboarding assistant got only moderate helpfulness (3.26/4).
- **CIAO, arXiv 2604.08293** [C, 22 devs]: LLM-written architecture docs were rated broadly accurate, but weak on diagrams, context and deployment.

---

## Level 2: Regional (ASEAN / Asia-Pacific)
- **Gap: I found no peer-reviewed study specifically on developer onboarding in Southeast Asia.** The regional evidence is industry data (see [synthesis-02-articles](02-articles.md)).
- Note: LACY (Türkiye) and the modelling study (arXiv 2510.07010, a SaaS company) are non-Western industry settings. They aren't SEA, but they show the problems aren't Silicon-Valley-specific.

## Level 3: Local (Malaysia)
- **Tee, Wong, Dada, Song, Ng, "Demand for digital skills, skill gaps and graduate employability: Evidence from employers in Malaysia", F1000Research 13:389 (2024)** [B, peer-reviewed; 376 employers registered with the Malaysian Productivity Corporation, in Klang Valley, Johor and Penang].
  - Current top digital skills in demand: **information & data literacy**, problem-solving, digital content creation.
  - **Largest gap between graduates and employer needs: communication & collaboration** (μ = −0.927), then **problem-solving** (−0.864), then safety (−0.771).
  - https://f1000research.com/articles/13-389
  - → Malaysian graduates arrive weakest in exactly the skills onboarding relies on: asking, collaborating, and finding information.
- **Modelling study, arXiv 2510.07010** [C, not Malaysian]: less-prepared new hires gained the most (+15 points) from structured comprehension support. That's relevant because Malaysia hires graduates to fill the gap (see articles).
- **Gap:** I found no Malaysian study on *developer onboarding or codebase knowledge transfer* specifically.

---

## Synthesis: what the research says the problem is
1. Onboarding a developer is **mostly a comprehension problem** (58% of time), and it is **worst for juniors on existing codebases**.
2. The knowledge that matters most, the **why**, is **tacit**. It lives in seniors' heads, and the docs are distrusted.
3. Newcomers **stall at the start** unless they can experiment early and check their own progress.
4. **Mentoring is the gold standard but doesn't scale**, and pure-AI replacements lose accuracy and trust.
5. Locally, the research points at **graduates arriving with collaboration and problem-solving gaps**, which raises the cost of every onboarding.

**Evidence strength:** strong internationally (several peer-reviewed studies agree). **Thin regionally and locally**: one Malaysian peer-reviewed study, and it's about graduate skills, not onboarding itself.
