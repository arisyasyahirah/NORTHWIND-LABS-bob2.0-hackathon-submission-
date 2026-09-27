# Time & cost of manual onboarding prep — broad → SEA → Malaysia

Companion to [04-patterns](04-patterns.md) and [05-solutions-mapping](05-solutions-mapping.md). Built to answer one question the pitch needs and the earlier research didn't directly cover: **what does it cost, in time and money, for a human to do what this pipeline automates?** Every fact below was fetched and quote-checked against its live source on 2026-09-27, not pulled from a search summary — two candidate stats ($75k/6-week SEA onboarding-cost claim, and an "$18 vs $40/hr SEA overhead" claim) were dropped after the source pages didn't actually contain them.

Evidence grades: **A** = peer-reviewed/large-sample · **B** = cited industry data (e.g. SHRM, Gallup) via a secondary article · **V** = vendor/blog, directional only.

---

## Broad / international

- **Cost per hire, SHRM benchmark**: "The average cost per hire is nearly $4,700," and SHRM separately estimates the **total** cost of a new hire (once soft costs like recruiter time and lost productivity are counted) at **3–4× the position's salary**. [B] — via [devlinpeck.com](https://www.devlinpeck.com/content/employee-onboarding-statistics), citing SHRM.
- **Cost to replace, SHRM**: replacing an employee costs **6–9 months of their salary**. [B] — via [fullscale.io](https://fullscale.io/blog/developer-onboarding-best-practices/), citing SHRM.
- **Cost to replace, Gallup**: losing an employee costs **50–200% of their salary**, and for **technical roles specifically, 100–150%** (peoplekeep.com data, cited in the same piece). [B] — [builtin.com/recruiting/cost-of-turnover](https://builtin.com/recruiting/cost-of-turnover).
- **Admin time**: onboarding a single employee takes **at least a full week of HR admin time at 46.4% of organizations**, and a failed hire costs **$25,000–$50,000**. [B] — via devlinpeck.com, citing Enboarder. *Caveat: this is HR/admin onboarding (paperwork, accounts, equipment), a different scope from the codebase-specific content (architecture, ownership, known issues) this pipeline generates — treat as a floor for the surrounding process, not the content-prep time itself.*
- **Effect of doing it well**: strong onboarding improves new-hire retention by **82%** and productivity by **70%+** (Brandon Hall Group, cited via fullscale.io) [B]; only **12%** of employees strongly agree their company onboards well (Gallup, same source) [B].
- **Closest direct figure (added after re-reading our own LACY notes):** experts at Beko reported spending **20–40 hours per new hire** on onboarding overall ([LACY, arXiv 2603.25391](https://arxiv.org/abs/2603.25391), pre-study survey; see [../LACY_DEEP_DIVE.md](../LACY_DEEP_DIVE.md)). [C, n=2 experts, self-reported] It covers all expert onboarding time (walkthroughs, repeated explaining), not just writing a pack, so it is context for the stakes, not a like-for-like comparison with the pipeline.
- **No industry-wide benchmark exists for "hours to manually write one onboarding pack."** Searched directly for this; found only adjacent proxies (below), not a single citable number. That gap is itself informative: the literature backs *why* it's expensive and doesn't scale (see LACY, already anchoring this project's design — [DECISION_ANCHOR.md](../DECISION_ANCHOR.md)), but nobody has benchmarked the specific task this pipeline replaces.

## SEA

- Malaysia already has the region's highest turnover (**17.4%**) and the highest stated intent to leave (**63%** vs. 53% globally) — established earlier in [02-articles.md](02-articles.md), not re-derived here.
- No SEA-specific onboarding time/cost study was found on direct verification (a promising-looking $75k/6-week claim and an SEA "$18 vs $40/hr" overhead claim both failed to check out against their cited pages — dropped, not used anywhere in this project). Stated as a gap, same honesty standard as the Malaysia-inference limitation already on the landing page.

## Malaysia — the rate this project actually needs

Local developer hourly rates by seniority (2026), for costing the manual alternative in the currency this demo actually runs in: [secondtalent.com/developer-rate-card/malaysia](https://www.secondtalent.com/developer-rate-card/malaysia/) [V]

| Level | Local rate (RM/hr) |
|---|---|
| Junior (0–2 yr) | RM20–35 |
| Mid-level (3–5 yr) | RM35–55 |
| **Senior (5–8 yr)** | **RM55–85** |
| Lead/Architect (8+ yr) | RM85–120 |

In this demo, the pack is prepared *for* a junior hire *by* a manager/senior (Priya Menon, per `pack.md`) — so the senior band (RM55–85/hr) is the right rate to cost the manual alternative against.

---

## The comparison this unlocks

No source hands us a ready-made "X hours" figure, so build it transparently instead of importing a borrowed number that doesn't fit:

1. **What a senior would actually redo by hand**, mapped to this pack's real sections: company/role briefing, an architecture walkthrough, ownership map, a written 10-issue list with file:line evidence for each, a dated task timeline, and a manager brief. The closest real proxy found for *one slice* of this — a dev-workflow onboarding doc — is **~2 hours** per the framework in [document360.com/blog/code-documentation](https://document360.com/blog/code-documentation/) [V]; this pack has roughly 4–5 such sections, plus 10 issues each needing its own investigation and write-up (not covered by that 2-hour figure at all).
2. **Reasonable range, shown as a range because that's what the evidence supports:** roughly **4–8 hours** of senior time for the written pack alone, before a video. State it as an estimate with its reasoning attached, not a fact with a citation it doesn't have — same standard as everywhere else on this page.
3. **Cost at the Malaysia senior rate (RM55–85/hr):** **RM 220 – RM 680** in senior time per hire, for the written pack alone.
4. **What the pipeline actually costs the senior:** the ~20 minutes is machine time (Bob running, no human attention needed); the senior's own time is the **~1-minute approval gate** — at RM55–85/hr that's **roughly RM1–1.50** of senior time per hire.

**Net claim, stated at the confidence it deserves:** this pipeline cuts the senior's own active time on one onboarding pack from an estimated 4–8 hours to about one minute — a ~99% cut in *their* time specifically. That number is a transparent estimate built from real (cited) proxies, not a measured study result, and the landing page should say so exactly that plainly.

## Still open

- **The `manual_hours` field** (`Development/onboarding/alex-tan/intake.yaml`) is blank. This file gives the reasoning and a defensible range (4–8 hrs) to fill it with, or a real number from you if you have a better one — either way, `pipeline_tools.py time` should be re-run once it's set, so the landing page quotes the pipeline's own computed output instead of this doc's manual estimate.
- If more rigor is wanted later: a timed dry run (have an actual senior write the equivalent pack by hand, clock it) would replace this estimate with a measured one — flagged here as the natural next step, same pattern as the other "Next:" items in the landing page's Limitations section.
