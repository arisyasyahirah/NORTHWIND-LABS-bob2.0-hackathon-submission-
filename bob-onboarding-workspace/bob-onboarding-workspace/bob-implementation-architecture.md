# How we implement this with Bob — mapped to LACY's architecture

> v2 note: stage order, outputs and the email tool signature are superseded by `PIPELINE.md`; the LACY mapping below still holds.

Companion to LACY_DEEP_DIVE.md (LACY's own architecture) and DECISION_ANCHOR.md (why we anchored on it). This file is the other half: **given LACY's 3-module shape, which specific Bob mechanism realizes each one, and where we deliberately deviate.**

Status: planning. Nothing below has been run yet — this is the spec `SKILL.md` and `BOB_PROMPTS.md` are built from.

---

## Side-by-side: LACY's modules vs. our Bob implementation

| LACY module | LACY mechanism | Our Bob mechanism | Why the swap |
|---|---|---|---|
| 1. Context & Prompt Preparation | Expert manually highlights files/code in the IDE, per session, live | Bob reads `hires/<name>.yaml` → looks up `roles/<role>.md` + `company/handbook.md` + the target codebase (chosen at intake) via context mentions (`@file`) and document understanding | We scope by **role match**, not by a human re-selecting code every time — trades LACY's per-session precision for zero manual step per hire |
| 2. AI-Driven Generation | One LLM call (Gemini-2.5-Flash) → structured JSON (tour steps + quiz) | Bob's **Agent mode**, split into **4 parallel subagents** (architecture / code tour & setup / culture / role) defined in `SKILL.md`, output = markdown sections merged into one pack | Judging criteria explicitly reward Agent mode + subagents + parallel tasks; also lets each subagent specialize its prompt instead of one generic tour-generation call |
| 3. Collaborative Review & Feedback | Expert edits/approves in an editable UI; published to an internal DB + dashboard | **(a)** Bob runs a deterministic shell self-check (does every cited `path:line` exist?) as an agentic tool-use step, **before** a human ever sees it. **(b)** Manager/senior reads the pack and approves before send (plain human review, no dashboard) | We add an automated pre-filter LACY doesn't have (see LLM code-tour study on unreliable self-grading — ours checks *facts*, not *quality*, so it's deterministic, not another LLM judging itself). We don't build a dashboard: out of scope for the time we have. |
| *(LACY has no delivery step — tour stays in-IDE)* | — | **Bob writes its own delivery pipeline**: a PDF renderer (Code mode, one script) + an **MCP server** for email (Bob scaffolds it on request, per `.bob/mcp.json`) | This is the piece LACY doesn't need to solve (their artifact never leaves the IDE) but we do, because our pack has to reach someone who isn't in Bob yet on day 1 |

---

## Architecture diagram (our version)

```
hires/<name>.yaml ── role ──▶ roles/<role>.md
                 └── reads ──▶ company/handbook.md
target codebase ─────────────────────────────────┐
                                               ▼
                    ┌──────────────────────────────────────┐
                    │  Bob Agent mode, skill: onboarding-pack │
                    │  (.bob/skills/onboarding-pack/SKILL.md) │
                    │                                        │
                    │   ┌───────────┐ ┌───────────────────┐ │
                    │   │ Subagent:  │ │ Subagent: Code tour│ │   ← parallel,
                    │   │ Architecture│ │ & setup            │ │     each a
                    │   └───────────┘ └───────────────────┘ │     separate
                    │   ┌───────────┐ ┌───────────────────┐ │     Bob task
                    │   │ Subagent:  │ │ Subagent: Role     │ │
                    │   │ Culture    │ │                    │ │
                    │   └───────────┘ └───────────────────┘ │
                    └───────────────────┬────────────────────┘
                                        │ merge
                                        ▼
                    onboarding/<name>.md + onboarding/<name>-manager.md
                                        │
                                        ▼
                    ┌──────────────────────────────────────┐
                    │ Deterministic self-check (shell tool  │
                    │ call inside the same Bob session):    │
                    │ every cited path:line actually exists │
                    └───────────────────┬────────────────────┘
                                        │ pass
                                        ▼
                    👤 manager/senior reads & approves
                                        │ approved
                                        ▼
                    Bob (Code mode) → scripts/render_pdf.py → PDF
                                        │
                                        ▼
                    Bob-built MCP server: send_onboarding_email(...)
                        (SMTP creds from .env, never hardcoded)
                                        │
                          ┌─────────────┴─────────────┐
                          ▼                           ▼
                   new hire gets PDF pack      manager gets checklist
```

Every box that says "Bob" is one Bob **task**. Each task's session summary gets screenshotted into `bob_sessions/` — the hackathon's required evidence, and incidentally a natural artifact of this exact pipeline shape (see the hackathon requirements).

---

## What's Bob-specific that LACY has no equivalent for

- **MCP server creation.** LACY never needed to leave the IDE. We do (PDF + email), so we lean on Bob's ability to scaffold an MCP server on request instead of hand-writing SMTP plumbing.
- **Skills as the reuse unit.** `SKILL.md` is exactly the "Knowledge Activation" pattern from [[synthesis-05-solutions-mapping]] — institutional knowledge (how to onboard, for this company) encoded once, reusable per hire, instead of a one-off prompt.
- **Headless `bob run`** (optional, unconfirmed under the hackathon account — see the hackathon requirements). If available, the whole pipeline above can run as one non-interactive command with `--max-cost`, which is the closest we get to "less human involvement" from the original brief, without giving up the approval gate.

## Who actually runs Bob, and who needs repo access when

Same split as LACY: **the expert generates, the learner only receives.** The new hire is never the one opening Bob against the codebase.

- **Generation-time access** (scanning the target codebase (chosen at intake), running the skill): done by whoever already has it — a manager, a senior on the team, or a platform/DevEx owner. In our PoC this is a local clone, using that person's own already-configured git credentials. Nothing new to provision.
- **Delivery-time access** (receiving the pack): zero. The new hire gets a PDF by email. No GitHub account, no Bob account, no repo access required to get value from this.
- **Day-1 access** (when the hire actually starts touching code, day 2–3 per the starter tasks): a normal IT-provisioning step — GitHub org invite, Bob IDE account, repo permissions, VPN/SSO. Bob doesn't generate these; they're tracked as a **Compliance** checklist item in the pack itself (`## Day-1 accounts & access`), owned by IT/the manager.
- **Production-scale alternative** (not built in this PoC): instead of a local clone, Bob connects to a **GitHub MCP server** using a read-only, repo-scoped PAT or GitHub App token owned by a service account. This lets generation run headless — e.g. triggered automatically by an HR system webhook the moment a new-hire record is created — with no human cloning anything. Worth naming in the pitch as "how this scales," not something to build in the time left.
- **For the hackathon demo:** use a public, permissively licensed repo as the target (read-only, no credential story, no client data).

## What's still an open question (planning stage, not yet decided)
- Where the target codebase comes from — resolved: the manager names it at intake; Bob confirms it with `pipeline_tools.py probe`.
- Exact form of the deterministic self-check command (likely a short shell one-liner Bob is instructed to run and interpret, not a separate script).
- Whether the hackathon-provisioned Bob account exposes an API key for `bob run`, or whether the whole flow has to happen inside the IDE chat instead.
