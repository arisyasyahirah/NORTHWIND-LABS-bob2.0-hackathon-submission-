# 10. Fix loop (if something fails, solve it, then re-check)

**Ask:** "we need to have a loop check where if something fails it would solve it" (2026-09-26).

## Problem
Stage 3 said "fix or remove each failure and re-run until it prints OK": unbounded and unguided. Stages 6, 6b and 7 had no recovery at all (a failure meant giving up or silently dropping a file). Bobcoins are capped at 40 per person with no top-ups, so a loop that never converges is a real cost, and a loop that "fixes" by deleting the evidence defeats the checks.

## Design
Bob (the LLM) does the judgement; deterministic code does the bookkeeping, so the loop cannot run away.
```
step fails -> fix (free, mechanical) -> re-run -> pass? -> guard --ok
                                            |no
                    guard <stage> (stdin = failing output)
                     RETRY k/3 -> Bob makes the smallest edit named by the message -> re-run
                     STOP      -> ask the user (output + what was tried)
```
| Piece | What | Where |
|---|---|---|
| `pipeline_tools.py fix <dir>` | Always rebuilds `issues/INDEX.md` from the issue files (it is derived, so it must never go stale after an issue edit), syncs the storyboard title to the pack's H1, copies `install_deps.py`. Idempotent, no LLM, never rewrites authored wording. | script |
| `pipeline_tools.py guard <dir> <stage>` | Counts failures per stage in `attempts.json` (max 3). Stops early when the same set of problems returns (order-independent): a fix that changed nothing will not work on try 3. `--ok` resets the stage. Each failure is logged in `run-log.md`. | script |
| Message-to-fix table | Each known failure message maps to the smallest fix | skill `<FixLoop>` |
| Where it applies | stage `3 check`, `6 render`, `6b video`, `7 deliverables`, MCP send | skill steps |

## Rules that keep "solving" honest
- Fix the cause the message names; never edit a script, check or threshold to pass.
- No silent deletion or invention. Before approval, every removed citation/dropped issue/softened claim goes into `flagged.md`, which the human sees at the gate.
- After approval only layout and wording change, never a fact, and any edit to `pack.md`/`storyboard.json` re-runs stage 3. A fix that would change a fact = STOP and ask.
- Missing dependencies are not loop problems: they follow the step's ask-first flow.

## Limits
- The repair half (Bob reading a message and editing) is judgement; only the tools are tested. It needs a real Bob run to see how often 3 attempts suffice.
- `fix` covers only three mechanical cases. Renumbering issues, citation repair and overflow shortening stay with Bob (table gives the recipe).
- `attempts.json` sits in the run folder (gitignored with `onboarding/`).
