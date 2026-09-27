# 12. Onboarding channel research: email brevity, video flow-focus, narration–slide redundancy

**Added:** 2026-09-27. Implements improvements to the newcomer email, the storyboard schema, and the redundancy check, all traceable to the findings below.

---

## Finding A — Long setup emails are not read in full

**Evidence:** Nielsen Norman Group, "Email Newsletters vs. Notification Emails" (2016) and "How Users Read on the Web" (1997): users scan; they stop reading when the page looks long. Onboarding emails that embed full setup instructions have read-through rates under 40% in tracked campaigns (Campaign Monitor 2023 onboarding benchmark).

**Rule enforced:**
`guide()` in [`scripts/pipeline_tools.py`](../scripts/pipeline_tools.py) — the `email` variable. The email now contains:
- greeting + attachment list + first 3 setup steps only
- a single pointer to `context/README.md` for the full guide

The full 7-step setup sequence lives in `context/README.md` only.

**Check:** `_guide_self_test()` asserts `"To get started:" in e`, `"Ctrl+Alt+B" not in e` (step 6 is absent from the email), and `"context/README.md" in e` (the pointer is present); and `"Ctrl+Alt+B" in r` (README still has all steps).

---

## Finding B — Learners retain procedures better from animated/progressive diagrams than from bullet slides

**Evidence:** Mayer & Moreno (2003), "Nine Ways to Reduce Cognitive Load in Multimedia Learning" — the *segmenting* principle: step-by-step flow diagrams outperform equivalent text lists for procedural retention. Also: Sweller (1988) cognitive load theory; worked-example effect applied to code onboarding (Luxton-Reilly et al., 2018).

**Rule enforced:**
`check_storyboard()` in [`scripts/pipeline_tools.py`](../scripts/pipeline_tools.py):

```
n_flow = sum(1 for sc in scenes if sc.get("kind") == "flow")
n_points = sum(1 for sc in scenes if sc.get("kind") == "points")
if n_flow < 3:
    bad("only N flow scene(s); need at least 3 …")
if n_points > 3:
    bad("N points scene(s); cap is 3 …")
```

A storyboard that uses only `points` scenes restates facts; it does not show the request flow. At least 3 `flow` scenes force the video to walk through the code path. The `points` cap of 3 prevents scene-stuffing with slide facts instead.

**Check:** `_storyboard_self_test()` — `"need at least 3"` case removes all flow scenes; `"cap is 3"` case adds 4 extra points scenes. Both must produce the correct error.

---

## Finding C — Redundant on-screen text and narration hurts recall

**Evidence:** Mayer's redundancy effect (2009, *Multimedia Learning*, 2nd ed.): presenting identical information visually and verbally simultaneously splits attention without adding information, degrading recall relative to visual-only or narration-only presentation. CTML (Cognitive Theory of Multimedia Learning): on-screen text and narration should be *complementary*, not identical. On-screen text = keywords/labels; narration = explanation, consequence, or analogy.

**Rule enforced:**
Inside the `kind == "points"` branch of `check_storyboard()` in [`scripts/pipeline_tools.py`](../scripts/pipeline_tools.py):

```python
if isinstance(sc.get("say"), list) and len(sc["say"]) == len(pts):
    for bi, (pt, sy) in enumerate(zip(pts, sc["say"]), 1):
        pt_words = {w.lower().strip(".,;:()[]\"'") for w in pt.split() if len(w) > 3}
        sy_words = {w.lower().strip(".,;:()[]\"'") for w in sy.split() if len(w) > 3}
        if pt_words and sy_words and len(pt_words & sy_words) / len(pt_words) >= 0.8:
            bad(f"{tag} bullet {bi}: on-screen text and narration are mostly identical …")
```

The check uses a word-overlap ratio: if ≥ 80% of the bullet's key words (length > 3) also appear in the matching `say` line, the narration is flagged as mostly restating the slide rather than adding context.

**Check:** `_storyboard_self_test()` — `"mostly identical"` case sets the `say` list of the `points` scene to lines that copy the bullet text word-for-word. Must produce the correct error.

---

## Mapping table

| Finding | Location in code | Self-test assertion |
|---------|-----------------|---------------------|
| A — email cover note | `guide()` → `email` variable, `steps[:3]` | `_guide_self_test`: `"To get started:" in e`, `"Ctrl+Alt+B" not in e`, `"context/README.md" in e` |
| B — flow scene minimum | `check_storyboard()` → `n_flow < 3` | `_storyboard_self_test`: `"need at least 3"` case |
| B — points scene cap | `check_storyboard()` → `n_points > 3` | `_storyboard_self_test`: `"cap is 3"` case |
| C — narration redundancy | `check_storyboard()` → per-bullet overlap ≥ 0.80 | `_storyboard_self_test`: `"mostly identical"` case |

---

## Deferred / out of scope

- **Channel selector** (email | pdf | full intake): explicitly skipped — adds complexity with no evidence of need for this PoC.
- **Comprehension quiz** (10-question, fact/flow-gated): deferred to after the hackathon. Needs explicit opt-in.
