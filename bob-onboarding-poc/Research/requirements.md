---
name: ibm-bob-2-hackathon-requirements
description: "IBM Bob 2.0 hackathon (lablab.ai, Sep 25-27 2026) — challenge, deliverables, rules, judging, Bobcoin budget"
metadata:
  node_type: memory
  type: reference
  originSessionId: 54373b6a-d3eb-4b3c-a38f-dfe67c8deed3
  modified: 2026-09-26T04:25:10.842Z
---

# IBM Bob 2.0 Hackathon — Requirements

Researched 2026-09-26. Sources:
- https://lablab.ai/ai-hackathons/ibm-bob-2-hackathon (main page)
- https://lablab-ibm-bob-2-hackathon-guide.s3.us.cloud-object-storage.appdomain.cloud/index.html (official guide)
- https://developer.ibm.com/events/ibm-bob-20-hackathon/

## Timing
- Online, Sep 25–27 2026 (48h build). Registration closed Sep 24.
- **Submission deadline: Sep 27, 11:00 AM EDT = Sep 27, 11:00 PM MYT.**
- Note: Bob IDE v1.0.3 / v2.0.0 stop working Sep 30 → use v2.0.2+.

## Challenge
Build a solution that improves a specific **developer workflow** (onboarding, debugging, code review, testing, app maintenance, release/deploy).
1. Define a problem where time/effort/errors are too high today.
2. Build a **working prototype** with IBM Bob 2.0 on a real or sample project.
3. Use Agent mode, parallel tasks, subagents, and document understanding across multiple steps, not just code completion.
4. Show measurable impact: time saved, less manual effort, fewer errors/less rework.

## Hard rules
- **Bob IDE required** (Bob Shell optional). Bob IDE must be a *core* component, or the project isn't eligible for judging.
- Use the **hackathon-provisioned Bob account** (Enterprise plan, `ibm-coding-challenge-*`, us-east). Don't burn personal credits.
- **40 Bobcoins per person**, with no top-ups. Split work across teammates to pool the budget.
- Any other framework/tech is allowed. watsonx.ai and watsonx Orchestrate are optional extras.
- Data: bring your own. No client data, no PII, no social-media data, no confidential data. Public web data only if terms allow commercial use, and keep a list of sources.
- **No IBM Cloud credentials in the repo.** IBM scans for them and suspends the account. Use the template's `.gitignore` + `.bobignore`.
- Submissions must be original and MIT-compliant. IBM employees are not eligible.

## Deliverables (lablab.ai submission form)
**Basic info:** Project title, short description, long description, IBM Bob usage statement, tech/category tags.
**App & code:** public repo URL, Bob task session summary screenshots, demo app platform, application URL.
**Media:** cover image, MP4 video, slide deck.

Details:
- **Long description = Problem & Solution Statement, ≤500 words**: problem, target users, how they interact, why it's novel.
- **IBM Bob Usage Statement, ≤500 words**: how/where Bob was used throughout development (plus watsonx use if any).
- **Video ≤3 min** (judges stop at 3:00), at least **90s of the solution running**, narrated, showing Bob's role.
- **Public repo** (GitHub/GitLab/Bitbucket) with the Bob-assisted code. Optional template: https://github.com/watsonxhackathon/ibm-hackathon-template
- **`bob_sessions/` folder in the repo** holding screenshots of every relevant task session summary, **from each team member**:
  - Bob IDE chat → Tasks → pick task (select "All" if the work spans multiple workspaces) → click task header → screenshot the consumption summary.
  - PNG, named like `teamname_task01_short_desc_summary.png`.

## Judging (4 criteria)
1. **Application of Technology**: completeness, and a clear application of Bob 2.0.
2. **Presentation**: clarity of the video, slides, and write-up.
3. **Business Value**: impact on a high-priority problem.
4. **Originality**: uniqueness of the solution and of how Bob is applied.

## Prizes
$12k pool on lablab: $5k / $3k / $2k, plus 20 × $100 for a qualified submission + post-event feedback form. (IBM page says $10k; lablab is authoritative.)

## Example use cases (from the guide)
Onboarding assistant · code review/quality coach · automated testing hub · release-readiness assistant · legacy modernization accelerator.

## Related (not this event)
- IBM Dev Day: Bob in Action hackathon (BeMyApp), Aug 28–30 2026, IBM i / IBM Z focus. Already over.
- AI Builders Challenge with IBM Bob (BeMyApp): https://aibuilderschallenge-bob.bemyapp.com/

## Bob 2.0 capabilities (for solution design)
- **MCP**: yes. `.bob/mcp.json` (project) or `~/.bob/settings/mcp.json` (global). STDIO + streamable HTTP, OAuth 2.1. No preinstalled servers. Bob can scaffold an MCP server for you (TS). Per-tool auto-approve. https://bob.ibm.com/docs/ide/configuration/mcp/mcp-in-bob
- **Skills**: `.bob/skills/<name>/SKILL.md` + supporting files/scripts. Auto-activated by description. https://bob.ibm.com/docs/ide/features/skills
- **Custom modes, rules, subagents, AGENTS.md via /init.**
- **Bob Shell headless**: `bob run --mode agent --max-cost <bobcoins> --format json "..."`. All tools are pre-approved in `bob run`, so it works in scripts/CI. `--team-id` is needed with a `general` API key. https://bob.ibm.com/docs/shell/getting-started/start-bobshell-non-interactive
- Bob does NOT generate video/audio natively; that needs external tooling.

## Our idea (updated 2026-09-26, v2): developer onboarding pipeline
- Theme fit: developer onboarding (repo + role + engineering culture), not generic HR onboarding.
- **What it is:** a manager/senior dev runs `/onboard` in Bob IDE. Bob interviews them (codebase, company + value, newcomer name/position/work email, start/end dates), scans the codebase, and produces for the newcomer a branded PDF and a context folder of `.md` files for the newcomer's own Bob (company, role, timeline, architecture, tech stack, **one `.md` per issue found**, install script). Human approval gate before render/send.
- **Differentiators to lead with (Originality):** personalised per hire; issue scanning with one file per issue and guidance; context folder that becomes the newcomer's Bob context; deterministic citation check (no self-grading) + approval gate. Not "we generate a pack".
- **Scope (v2):** full pipeline, PDF + zip email with approval gate. Full spec: `Development/PIPELINE.md`; asks and review outcomes: `Development/requirements/` (00-index, 07-review-fixes).
- **Video:** REQUIRED by the submission form (≤3 min, ≥90s running). The earlier "video dropped" note was a v1 scope cut and is reversed.
- **Bob usage / evidence:** to satisfy the `bob_sessions/` rule and Bob-as-core-component, Bob must review/harden the pipeline scripts, build the email MCP server (`--dry-run`), and run `/onboard`; each task is screenshotted. Plan: `Development/BOB_PROMPTS.md`.
- **Permissions:** Bob IDE auto-approve toggles (Read, Edit, Execute, MCP, Skill, Todo, Subtask, Subagent) are IDE UI state; a skill cannot set them. `bob run` (Shell) pre-approves all tools but is unconfirmed for our account, so the IDE path is primary. Human approval gate is never bypassed.
- **Demo target:** a public MIT repo chosen per run (planned: `miguelgrinberg/microblog`). No client data; the earlier trial project path is removed.
- **Measurable impact:** `pipeline_tools.py time` (machine time excluding human approval) vs an honest manual estimate.
- **Status:** built and self-tested locally; not yet run in Bob; email MCP server not built; no `bob_sessions/` screenshots yet.
