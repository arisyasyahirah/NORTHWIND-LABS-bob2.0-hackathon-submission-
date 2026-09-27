# 4. Permission bypass

**Ask (verbatim):** "Permission while using the IDE, I think we need the bypass permission like other coding agents have whenever bob is running its pipeline and if it's not within the bob IDE capability then we can ignore this."

## Finding (verified in Bob docs)
Bob IDE has 8 auto-approve toggles: **Read, Edit, Execute, MCP, Skill, Todo, Subtask, Subagent**, under the **Permissions button** beside the Mode selector. Docs warn Execute/Edit are high risk. No documented allow/deny command list or outside-workspace toggle.
Sources: bob.ibm.com/docs/ide/features/auto-approving-actions

## What this means
- It is **IDE UI state**. A skill or repo file cannot switch it on. So: partial capability. Documented steps, user flips toggles once per session.
- Recommended set for `/onboard`: Read, Edit, Execute, Skill, Todo, Subtask, Subagent ON. **MCP OFF** until the dry-run send is verified, then ON.
- Target codebase lives outside the workspace; reads there may still prompt (not documented either way — unconfirmed).
- Auto-approve ≠ human approval gate. The Flagged-for-review stop is a chat question and stays.
- Blast radius: Execute+Edit auto-approved means Bob can run anything. Mitigations already in the design: target repo read-only by rule, `.bobignore` for `.env`, run in a throwaway workspace, no IBM Cloud creds in repo.
