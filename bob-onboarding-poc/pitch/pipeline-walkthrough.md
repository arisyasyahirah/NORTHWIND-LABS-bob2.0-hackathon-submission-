# Bob Onboarding Pipeline — Screenshot Walkthrough

Screenshots from a live run of the `/onboard` pipeline (see [PIPELINE.md](../Development/PIPELINE.md)), onboarding fictional hire Alex Tan into Northwind Labs / CTMS_Project. Ordered by pipeline stage for presentation.

## Kickoff & Preflight

![Kickoff](screenshots/01-kickoff-preflight.png)
Session starts, Bob explores the workspace and activates the `onboarding-pipeline` skill.

![Ask for codebase path](screenshots/02-ask-codebase-path.png)
Preflight: Bob asks for the absolute path to the target codebase to scan (read-only).

![Probe & confirm codebase](screenshots/03-probe-confirm-codebase.png)
Bob probes the path, identifies CTMS_Project as a Java/JSP Clinical Trial Management System, and confirms before proceeding.

## Stage 0 — Intake

![Batch A options](screenshots/04-stage0-intake-batchA-options.png)
Batch A: target codebase, company (Northwind Labs), max issues, and video toggle — offered as quick-pick options.

![Intake running](screenshots/05-stage0-intake-running.png)
Bob pulls prefill from `hires/alex-tan.yaml`, writes `intake.yaml`, and checks video tooling availability.

![Batch B follow-up](screenshots/06-stage0-intake-batchB-followup.png)
Batch B: newcomer + timeline details (name, role, email, start/end dates, manager, buddy, experience level).

## Approval to Run

![Approve full pipeline](screenshots/07-approve-full-pipeline.png)
Full 10-stage plan shown for approval before executing (Preflight → Intake → Generate → Merge → Check → Flag → Human approval → Render PDF/video → Package → Send).

## Stage 1 — Generate

![Parallel subagents](screenshots/08-stage1-generate-subagents.png)
Four subagents run in parallel: role/architecture context, tech stack, and issue scan.

## Stage 4 — Flag

![Flag approval](screenshots/09-stage4-flag-approval.png)
Stage 3 check passes; Bob logs progress and requests approval to write `flagged.md`.

## Stage 5 — Human Approval (hard stop)

![Approval issues table](screenshots/10-stage5-human-approval-issues.png)
Flagged issues (bugs, security, maintainability) presented with file locations and target-fix dates.

![Approval full view](screenshots/11-stage5-human-approval-full.png)
Same approval gate — decision options: approve all stages, skip video, review script first, or request a correction.

## Stage 6 — Render

![Video budget exceeded](screenshots/12-stage6b-video-budget-exceeded.png)
Optional Stage 6b (narrated video render) hits the Bobcoin budget cap mid-layout-fix.

![PDF preview](screenshots/13-stage6-pdf-preview.png)
Rendered onboarding PDF opened in VS Code — table of contents and welcome cards.

## Pipeline Complete

![Files written](screenshots/14-pipeline-complete-files.png)
All deliverables listed: PDF, narrated tour video, context zip, manager briefing, flagged issues, video storyboard, etc.

## Stage 7 — Send Email

![Confirm real recipient (a)](screenshots/15-stage7-confirm-real-email-a.png)
Bob notices `intake.yaml`'s email is a fictional placeholder and asks for a real send-to address before dispatching.

![Confirm real recipient (b)](screenshots/16-stage7-confirm-real-email-b.png)
User nudges Bob to actually send the files; Bob re-confirms deliverables and the destination address.

![Email stage details & open flags](screenshots/17-stage7-email-details-flags.png)
Stage 7 spec: attachments, reply-to (buddy), manager email body, plus open flags needing human follow-up (credential rotation, undocumented versions, no git remote).

![Sending via MCP](screenshots/18-stage7-sending-via-mcp.png)
SMTP credentials verified, `send_onboarding_email` MCP tool invoked for the newcomer email.

![Email sent, bug fixed](screenshots/19-stage7-email-sent-fixed-bug.png)
Caught a key mismatch (`attachment_paths` vs `attachments`) in `send_via_mcp.py`, fixed it, and confirmed the email sent with all three attachments.

## Verification

![Ethereal inbox — email received](screenshots/20-verify-ethereal-inbox-email.png)
Sent email viewed in the Ethereal test inbox, confirming subject, headers, and attachments.

![Ethereal messages list](screenshots/21-verify-ethereal-messages-list.png)
Full message history in the test mailbox across pipeline re-runs.

## Bob Home

![Bob home screen](screenshots/22-bob-home-recent-tasks.png)
Recent Tasks view showing the completed onboarding pipeline run and Bobcoin usage (79%).
