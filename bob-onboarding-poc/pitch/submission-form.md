# lablab submission: Basic Information (paste-ready)

## Submission Title (5–50 chars)
Bob Onboarding Pipeline

## Short Description (50–255 chars)
One /onboard command in Bob IDE scans a real codebase and builds a personalised onboarding pack per hire: PDF, narrated tour video, one file per issue, and a context folder for their own Bob. Claims are citation-checked; a human approves before send.

## Long Description (Problem & Solution, ≤500 words)
**Problem.** A new developer's first weeks are slow and inconsistent. They get a stale README and a wiki link, while a senior spends days re-explaining where the code starts, what is broken, and which tools to install. The knowledge lives in people's heads, so every hire gets a different experience, and the team pays for it twice: the newcomer's ramp-up time and the senior's lost time.

**Solution.** Bob Onboarding Pipeline turns that into one command. A manager or senior developer runs /onboard in Bob IDE. Bob interviews them (codebase, company, the newcomer's role, dates, buddy and manager), scans the real repository, and produces a personalised pack for that hire:
- a branded PDF covering the company, the role, the codebase, first tasks and a dated timeline;
- one Markdown file per real issue found (bugs, security, missing tests), each with evidence at file and line and guidance, not a patch;
- a context folder that the newcomer loads into their own Bob, so they get an AI assistant that already knows their company, role and codebase;
- an optional narrated code-tour video;
- a separate brief for the manager.

**Why it can be trusted.** Onboarding material that invents facts is worse than none. So the pipeline never lets the model grade itself. Plain Python checks that every cited file and line exists, that issue files follow the template, and that the video script only retells the pack. Anything Bob cannot confirm is written as "Unknown, ask your buddy" and listed on a flagged list. A human must approve that list before anything is rendered or sent. Tool auto-approve does not count as approval. The target codebase is read-only, and secrets are never copied.

**Target users.** Engineering managers and senior developers who onboard people, and the new hires themselves. Newcomers need no account to read the PDF; they load the context zip into their own Bob.

**What is different.** It is personalised per hire, grounded in the actual code, and delivered on several channels (email, PDF, video, and a Bob-ready context folder), following the onboarding research we reviewed. Naming, dates, the newcomer's setup guide and all checks are deterministic code, so runs are repeatable and testable. The core is generic: everything client-specific lives in an instances/ folder, so a new company is a folder, not a code change.

**Result.** In our demo run on a small Java web app, Bob found 10 issues (including three sets of hardcoded credentials), produced a 7-page PDF, a context zip and a narrated tour video, and delivered them by email through an MCP server. Machine time was about 20 minutes plus one minute of human approval, against an estimated [X] hours by hand. This is a proof of concept tested on one project so far.

## IBM Bob Usage Statement (≤500 words)
Bob IDE is the core of the project. This statement describes the Bob pipeline itself: a Bob-native workflow that runs inside Agent mode, where every stage of the demo run was a Bob task, screenshotted in the bob_sessions/ folder of the repo.

**Skill and command.** The workflow is packaged as a Bob skill (.bob/skills/onboarding-pipeline) with a /onboard command. Bob follows the skill's stage list exactly: intake, generate, merge, check, flag, approval, render, package, send.

**Agent mode and parallel subagents.** Bob asks the intake questions with its follow-up question tool, then launches four subagents in parallel: company and role, architecture and code tour, issue scan, and tech stack. Bob reads the target repository (source, manifests, docs) and turns it into the context folder, including one Markdown file per issue with evidence at file and line.

**MCP server creation.** Bob built the onboarding-mail MCP server, a local STDIO server exposing send_onboarding_email(to, subject, body, attachment_paths, reply_to). SMTP credentials come only from environment variables, and a --dry-run mode logs the call instead of sending. Bob also added the branded HTML email template and 14 unit tests, registered the server in .bob/mcp.json, and then used the tool to send the newcomer and manager emails, with the PDF, the context zip and the video attached, to a test inbox.

**Fix loop.** When the deterministic check failed (for example, citations to files that do not exist, or narration that was too long), Bob applied the skill's bounded fix loop: mechanical repair first, then the smallest edit that addressed the named cause, re-run, at most three attempts per stage. It moved unverifiable claims onto the flagged list instead of deleting or inventing content.

**Human-in-the-loop gate.** Bob stops at stage 5 and shows the flagged list and the issue index. It renders and sends only after the human approves.

**Rendering and delivery.** Bob ran the PDF renderer, the narrated video generator (text-to-speech and ffmpeg), the packaging step and the email tool, and ran the pipeline's timing report, which produced the measured run time we report.

We did not use watsonx.ai or watsonx Orchestrate.
