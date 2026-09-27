# 6. PDF design

**Ask (verbatim):** "We also need a pdf design, utilizing the pdf-brochure-system.md, to make a replicant to be used during the pdf generating."

## Implementation
- `docs/pdf-brochure-system.md`: copy of the reference (original in `~/OS/`).
- `scripts/brochure_kit.py`: faithful copy of the kit (primitives, tile, card, cover, `build`) minus the tech-brief content. Changes: `author` parameter (was hard-coded), `FAMILY` defaults to Arial on Windows (Bob users are on Windows), `self_check` kept.
- `scripts/render_pdf.py <onboarding/slug>`: reads `pack.md` + `intake.yaml`, builds cover + contents + auto-paginated body in the kit's style (yellow accent, black footer, bar headers, tables, bullets, callouts). Two-pass build so contents page numbers are real.
- The kit has no auto-pagination; render_pdf.py adds a measure-then-place flow that breaks pages.

## Limits (inherited)
Latin text only; no images/links; inline `code` renders bold; one accent palette (retheme via tokens in the kit); needs `pycairo`.
