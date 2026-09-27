---
name: onboarding-effectiveness-research
description: "Research papers on technical developer onboarding — codebase comprehension, architecture knowledge, code tours, AI-generated onboarding — and how each shapes the Bob onboarding PoC"
metadata:
  node_type: memory
  type: reference
  originSessionId: 54373b6a-d3eb-4b3c-a38f-dfe67c8deed3
  modified: 2026-09-26T04:45:50.770Z
---

# Technical onboarding: getting a developer productive in a codebase

Researched 2026-09-26 for the [ibm-bob-2-hackathon-requirements](requirements.md) PoC. Canvas: `bob-onboarding.canvas`.
Focus: the codebase and architecture. The people side (buddy, manager) is in the short appendix.

## 1. The cost: comprehension is most of the job
- **Xia, Bao, Lo, Xing, Hassan, Li: "Measuring Program Comprehension: A Large-Scale Field Study with Professionals"** (IEEE TSE 2018 / ICSE 2018). 79 professional developers, 7 real projects, 3,244 working hours.
  - Developers spent **~58% of their time on program comprehension**.
  - **Junior developers** spent a significantly higher share than seniors.
  - **Maintenance-phase projects** needed significantly more comprehension time than new projects.
  - https://baolingfeng.github.io/papers/tsecomprehension.pdf
  - → The problem statement: a new hire on an existing codebase is the worst case on both counts.

## 2. What newcomers actually struggle with
- **LaToza, Venolia, DeLine: "Maintaining Mental Models: A Study of Developer Work Habits"** (ICSE 2006, Microsoft).
  - Developers build rich mental models of code that are **rarely written down**, so they live in people's heads.
  - The biggest problem is **rationale**. 82% agreed it takes a lot of effort to understand *why the code is implemented the way it is*, and 66% called rationale a serious problem.
  - Developers **skip design docs and interrupt teammates instead**, because the docs aren't trusted to be current.
  - https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/p492-latoza.pdf
- **Sillito, Murphy, De Volder: "Questions Programmers Ask During Software Evolution Tasks"** (FSE 2006; extended in IEEE TSE 2008). A catalog of **44 question types**, running from finding a focus point ("where is X?") to building understanding of groups of subgraphs ("how does this data get here?").
  - https://dl.acm.org/doi/10.1145/1181775.1181779
- **Dagenais, Ossher, Bellamy, Robillard, De Vries: "Moving into a New Software Project Landscape"** (ICSE 2010, IBM Research). A grounded-theory study of 18 newcomers across 18 projects. Three factors drive integration: **early experimentation, internalizing structures and cultures, and progress validation**.
  - https://research.ibm.com/publications/moving-into-a-new-software-project-landscape
- **Steinmacher et al.: systematic review of newcomer barriers** (IST 2015). 15 barriers in 5 categories. A key one is **finding a way to start**.
  - https://www.sciencedirect.com/science/article/abs/pii/S0950584914002390

## 3. Architecture knowledge: what to explain and how
- **"An Explanation of Software Architecture Explanations"** (arXiv 2503.08628, 2025). Interviews with 17 professionals.
  - Good explanations adapt to the **listener's role, experience and goals**.
  - Listeners want **structure, behaviour and decision rationale**, plus the system context.
  - It proposes the "Explanation Window": adjust the functionality scope and the level of detail.
  - https://arxiv.org/abs/2503.08628
- **"A Study of Documentation for Software Architecture"** (arXiv 2305.17286). A controlled study with 65 participants.
  - The documentation *format* (narrative vs. structured) made **no significant difference**.
  - **Prior exposure to the source code** was the dominant factor, and "apply/create" questions were answered using the code.
  - → Link the architecture explanation into real files. Don't write a standalone essay.
  - https://arxiv.org/abs/2305.17286
- **CIAO: "Code In Architecture Out"** (arXiv 2604.08293). An LLM workflow that turns a GitHub repo into system-level architecture docs, using a template based on **ISO 42010, SEI Views & Beyond, and C4**.
  - 22 developers reviewed docs for repos they had contributed to, and found them **valuable, comprehensible, broadly accurate**.
  - Weak spots: diagrams, high-level context, deployment views.
  - Generating the docs takes **a few minutes and is cheap**.
  - https://arxiv.org/abs/2604.08293
- **AgenticAKM** (arXiv 2602.04445). Splitting architecture recovery across specialized agents (extract → retrieve → generate → validate) produced **better Architecture Decision Records (ADRs)** than a single prompt (user study, 29 repos).
  - https://arxiv.org/abs/2602.04445
  - → Evidence that Bob's subagent split is the right design, not just a feature demo.

## 4. Code tours and AI-generated onboarding: what works, what fails
- **LACY: "Simulating Expert Mentoring for Software Onboarding with Code Tours"** (arXiv 2603.25391). An industry deployment at Beko on a 30K+ LOC legacy finance system.
  - Learners scored **83% on comprehension quizzes with expert-curated tours vs. 57% with AI-only tours**.
  - They preferred tours to self-study and expected to need fewer expert consultations. Experts found writing tours less work than live walkthroughs.
  - **→ The key caveat: AI drafts plus human curation clearly beat pure AI.**
  - https://arxiv.org/abs/2603.25391
- **"Debugging Unfamiliar Codebases with Code Tours Generated and Evaluated by Local LLMs"** (arXiv 2607.26987). 26 developers.
  - They preferred tours that **scale detail with code length, don't restate the code, are scannable, and have a guiding tone**.
  - **LLM self-evaluation of tour quality was unreliable**: sycophancy, confabulation, incoherence.
  - → Verify with deterministic checks (does the path exist?), not by having the LLM grade itself.
  - https://arxiv.org/abs/2607.26987
- **Onboarding Buddy: multi-agent LLM + RAG + chain-of-thought** (arXiv 2503.23421). Very close to our idea.
  - Only **8 participants** in one project, with a helpfulness score of 3.26/4. It's weak evidence, but it's **prior art: position against it** (ours adds role tailoring, culture mapping, and a human gate).
  - https://arxiv.org/abs/2503.23421
- **TARS: Theory-of-Mind agent for personalized code comprehension** (arXiv 2607.15948). Explanations adapted to the developer's expertise and role.
  - Tasks were **26% faster** with lower cognitive load (n=18, controlled experiment).
  - https://arxiv.org/abs/2607.15948
- **"Teaching Modelling for Software Comprehension in New-Hire Onboarding"** (arXiv 2510.07010). 31 new hires.
  - No significant gain across the whole cohort, but **below-median hires gained +15 points (significant)**.
  - → Adapt the depth of the pack to the hire's experience.
  - https://arxiv.org/abs/2510.07010
- **"Knowledge Activation: AI Skills as the Institutional Knowledge Primitive"** (arXiv 2603.14805). Encodes institutional knowledge (architecture decisions, deployment procedures) as agent **Skills**.
  - Yahoo survey of 67 engineers: **2.6 h/week saved**, NPS +35.
  - → Direct backing for building the solution as a Bob skill.
  - https://arxiv.org/abs/2603.14805

## Design rules for the PoC (derived from the above)
| # | Rule | Evidence |
|---|---|---|
| 1 | **Architecture section in C4-style levels**: system context → containers/components → one end-to-end request flow. | CIAO, Explanation Window |
| 2 | **Explain the *why*, not just the *what***. Pull rationale from ADRs, commit messages and comments. If the rationale is unknown, write **"Ask your buddy"**. Never guess. | LaToza (82%), Explanation Window |
| 3 | **Code tour, not an essay**: 6–10 ordered stops as `file:line` plus 1–2 lines each. Scale detail to the code, don't restate it, keep a guiding tone. | Arch-doc study (code exposure dominates), LLM code-tour study |
| 4 | **Organize the tour around real newcomer questions**: where does a request enter? where does data get stored? how do I run the tests? | Sillito (44 questions) |
| 5 | **Run it first**: day 1 = local environment + one small edit you can see working. | Dagenais (early experimentation), Steinmacher |
| 6 | **Progress checkpoints**: 3–5 comprehension questions, each answered by a file path, to self-check at the end of week 1. | Dagenais (progress validation), LACY quizzes |
| 7 | **Adapt depth to experience** (`experience: junior/mid/senior` in the hire file). | TARS, modelling study, Explanation Window |
| 8 | **Subagents per concern** (codebase / architecture / culture / role). | AgenticAKM, CIAO |
| 9 | **A human expert curates before sending.** Self-check = deterministic path existence, not the LLM judging itself. | LACY (83% vs 57%), LLM code-tour study |
| 10 | **Ship it as a Bob skill** so the institutional knowledge can be reused. | Knowledge Activation |

## Pitch lines (measured claims only)
- "Developers spend ~58% of their time just understanding code, and new hires on legacy systems spend the most." (Xia et al.)
- "The hardest thing to learn is *why* the code is the way it is, and that lives in people's heads." (LaToza et al.)
- "AI-only onboarding underperforms (57% vs 83%), so Bob drafts and a senior curates." (LACY)

## Appendix: the people side (kept short)
- The 4 Cs framework (Bauer/SHRM): Compliance, Clarification, Culture, Connection.
- Microsoft: buddies → +23% satisfaction. "Buddy helped me become productive" rose from 56% to 97% as meetings increased (self-reported).
- Google: a just-in-time 5-item manager checklist → ~25% faster to productivity (Google-reported).
- Ju et al. ICSE 2021 (arXiv 2103.05055): quick-win → collaborative → complex task sequence.
- Gallup: only 12% strongly agree their organization onboards well.
