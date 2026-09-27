# Pure-Python PDF Brochure System (pycairo)

Reusable kit for generating styled, print-ready A4 PDFs with **only Python + pycairo**. No HTML, no CSS, no Chromium, no other Python packages.

Built and proven on two documents: `Trending_Tech_Stack_2026_py.pdf` (tech summary) and `Second_Phone_Picks_2026.pdf` (phone buying guide).

## 1. Files

| File | Role |
|------|------|
| `build_tech_brief.py` | **The kit** (primitives, components, cover, `build()`) plus the tech-brief content and pages |
| `build_phone_brief.py` | A second document. Imports the kit as `bt`, defines its own data and pages, calls `bt.build()` |

To reuse in another project, copy the kit part of `build_tech_brief.py` (everything above `# ---------- content ----------`, plus `page_cover`, `build`) into a `brochure_kit.py`, and write one script per document, like `build_phone_brief.py` does.

## 2. Requirements

- Python 3, `pycairo` (already installed here; on Arch it is the `python-cairo` package).
- The font **Liberation Sans** installed (`FAMILY` constant). If missing, cairo silently falls back to its default font and line breaks change.
- Optional, for checking output: `pdftoppm` (poppler) to rasterise pages, `pdfinfo`, `xdg-open` to view.

## 3. Core concepts

### 3.1 Units
All coordinates are **CSS-style px at 96 dpi**. The PDF surface is in points, so every page does `c.scale(0.75, 0.75)`. Font sizes are passed in **pt** and converted internally (`size_pt * 4/3` px).

| Constant | Value |
|----------|-------|
| `MM` | `96/25.4` px per mm |
| `W, H` | A4: 210 × 297 mm in px |
| `PAD_X, PAD_TOP` | 16 mm, 18 mm |
| `FOOT_H` | 14 mm footer bar |
| `CW` | content width = `W - 2*PAD_X` |

### 3.2 Global drawing state
The kit uses two **module globals**:
- `c`: the current cairo context. `build()` sets it per page.
- `max_y`: lowest y touched by content on the current page. `rect()` and `text()` update it; `footer()` restores it. `page_end()` asserts `max_y <= H - FOOT_H - 8`, so a build **fails loudly if content runs into the footer**.

Consequence: another module must go through the kit (`bt.text(...)`, `bt.build(...)`) so it reads the kit's globals. Do not copy functions into another module without their globals.

### 3.3 Measure-then-draw
There is no layout engine. Components measure themselves first, then draw. Every measurable function takes `draw=True`:
- `para(..., draw=False)` returns height only.
- `tags(..., draw=False)`, `tile(..., draw=False)`, `card(..., draw=False)` likewise.
- `tile_row` / `card_row` measure all items, take the max height, then draw each at that height. That is how equal-height rows work.

### 3.4 Flow layout
Pages are hand-flowed with a `y` cursor. Helpers return the next y:
```python
y = bt.header("Kicker", "Title")          # kicker + h2 + yellow bar, returns y below
y += bt.tile_row(bt.PAD_X, y, bt.CW, [tileA, tileB]) + 14
y = bt.bar_after(y + 8, "Sub heading", 18)
y += bt.card_row(y, [cardA, cardB])
bt.footer("BRAND", " · subtitle", "03")
```

## 4. API reference (kit)

### Primitives
| Function | Notes |
|----------|-------|
| `font(size_pt, bold)` | Selects font and size, turns **hint metrics off** (see pitfalls) |
| `tw(s, size, bold, ls)` | Text width px. `ls` = letter-spacing in em |
| `text(x, top, s, size, bold, color, ls, lh, anchor)` | Draws in a line box starting at `top` with height `lh`; baseline is centred in the box. `anchor` is `"l"`, `"c"`, `"r"`. Returns `lh` |
| `rect(x, y, w, h, fill)` | Filled rectangle |
| `frame(x, y, w, h, lw, color)` | Border drawn **inside** the box, like CSS `border-box` |
| `wrap(segs, width, size, bold)` | `segs` is a string or `[(text, bold), ...]`. Returns lines of `(word, bold, glued)` |
| `para(x, y, w, segs, size, lh_ratio=1.5, color, bold, draw)` | Wrapped paragraph with inline bold. Returns height |
| `texture()` | 135° hairlines, 1 px every 15 px at alpha .035, clipped to page |
| `footer(bold_part, rest, right)` | 14 mm black bar; brand in yellow |
| `header(kicker, title, size=26)` | Returns y after the accent bar |
| `bar_after(y, title, size)` | Heading + accent bar at an arbitrary y |
| `page_end()` | Overflow assertion (called by `build`) |

### Components (data shapes)
```python
tile  = (code, title, body, [tags], hot)      # code: 2-3 char badge; hot: yellow fill
card  = (label, [bullet, ...])                # bulleted, wrapped
# tile_row(x, y, w, [tile, ...])   1-2 tiles, equal height   -> returns height
# card_row(y, [card, card])        exactly 2 columns          -> returns height
# tags(x, y, w, [str], hot)        chip row, wraps            -> returns height
```

### Cover and build
```python
page_cover(line1="TRENDING", line2a="TECH ", line2b="STACK", panel="2026",
           blurb="...", brand="TECH BRIEF", credit="...")
build(out, pages=None, title="...")   # pages = sequence of zero-arg callables
```
Each page function draws everything itself, including its footer. `build()` for each page: new context, scale 0.75, white background, texture, reset `max_y`, call page, `page_end()`, `show_page()`.

## 5. Design tokens (edit at top of the kit to retheme)

| Token | Value | Use |
|-------|-------|-----|
| `Y` | `#F5B800` | Accent |
| `K` | `#111111` | Text, borders, footer |
| `G` | `#6B6B6B` | Kickers, secondary text |
| `T` | `#333333` | Body text |
| `RULE` | `#DDDDDD` | Table dividers |
| Body | 9.5 pt, line-height 1.5 | |
| h2 | 26 pt bold uppercase; sub-heading 18–20 pt | |
| Tile padding | 20 px vertical, 18 px horizontal, 1.5 px border | |
| Grid gap | 14 px | |

Flat style rules: no shadows, no rounded corners, no colour gradients.

## 6. Creating a new document (recipe)

```python
import sys
from functools import partial
import brochure_kit as bt          # or build_tech_brief as bt

FOOT = ("MY BRAND", " · subtitle")

def page_one():
    y = bt.header("Overview", "Page Title")
    y += bt.para(bt.PAD_X, y, bt.CW, "Body text...", 9.5)
    bt.footer(*FOOT, "02")

if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else "out.pdf"
    cover = partial(bt.page_cover, line1="MY", line2a="NEW ", line2b="DOC",
                    panel="2026", brand="MY BRAND", blurb="...", credit="...")
    bt.build(out, (cover, page_one), "My Document")
```
Then verify visually:
```bash
python3 my_doc.py out.pdf && pdftoppm -r 60 -png out.pdf pg   # then look at pg-*.png
```
Keep content as data constants at the top (lists of tuples), and pages as functions that lay that data out. `build_phone_brief.py` shows the pattern, including a custom table drawn from primitives.

## 7. Adding a new component

1. Write `thing(x, y, w, item, h=None, draw=True)`.
2. Compute height first from the same constants you draw with; return it. Keep the measure and draw constants **identical**, or rows drift (the tile's `hh` header height must match what draw does).
3. Draw only `if draw`.
4. Add a `thing_row` if it needs equal heights.
5. Anything drawn through `rect()`/`text()` counts toward the overflow check automatically.

## 8. Pitfalls (each one hit while building)

| Pitfall | Detail |
|---------|--------|
| **Hinted metrics** | cairo's default hinted advances make text wider than browsers. `font()` turns them off. Removing that changes wrapping |
| **Punctuation after bold** | Segments like `", stretched"` follow a bold word. `wrap()` marks that first token *glued*, so no space is drawn before it and it never starts a line. Without this you get `word , next` |
| **`para()` returns height, `text()` returns line height** | Do not mix them up when advancing `y` |
| **Cards ignore inline bold** | `card()` joins words back into plain strings. Only `para()` supports `[(text, bold)]` |
| **Letter-spacing** | Implemented per character, so kerning is lost when `ls != 0`. Use it only on uppercase labels |
| **Baseline maths** | `text()` assumes Liberation Sans ascent .905 and glyph box 1.117 em. A different font needs those two constants adjusted |
| **Bold weight** | Only normal/bold exist. `weight 900` in the old HTML spec maps to bold |
| **Cover title** | Assumes two lines at 40 pt: `line1` and `line2a + line2b`. Long text overlaps the framed panel: roughly 11 characters per line at 40 pt ("PHONE PICKS" just fits; "TECH STACK" fits). Lower the 40 pt size or move the panel for longer titles |
| **Cover panel text** | 52 pt in a 78 mm panel. "RM1.5K" fits; longer strings will not |
| **Hard-coded page numbers** | The tech brief's TOC and the footer page numbers are literal strings |
| **Module globals** | `c` and `max_y` live in the kit module. Call kit functions via the module; a partial application like `partial(bt.page_cover, ...)` is fine |
| **Editing by patch script** | A regex/string patch once deleted a function that sat between two markers. Prefer targeted edits and rebuild after each change |

## 9. Limitations (known ceilings)

- No automatic pagination: a page that overflows fails the build; you split it by hand.
- Toy font API: no kerning, ligatures or complex scripts (CJK, Arabic, Indic will not shape correctly). Latin/Malay is fine.
- Fonts are referenced, not embedded by choice; rendering elsewhere depends on the font available there.
- No links, bookmarks or images in the kit (cairo can do them: `PDFSurface` link tags, `set_source_surface` for PNGs). Not built because nothing needed them.
- Only metadata title is set (`author` is hard-coded to `"Tech Brief"` in `build()`; change it per project).
- Two-column layouts only for tiles and cards; the phone table is custom code, not a component.
- Tests: `self_check()` asserts wrap widths and glue behaviour; page overflow is asserted on every build. There is no pixel/visual regression test.

## 10. Porting checklist

- [ ] Copy the kit into the new project; keep `MM/W/H/PAD` constants and token block together
- [ ] Confirm `python3 -c "import cairo"` works and Liberation Sans is installed (`fc-list | grep -i liberation`)
- [ ] Change tokens (`Y`, `K`, `G`, `T`) and `FAMILY` for the new brand
- [ ] Parametrise anything still hard-coded (`author` metadata, footer text, `TECH BRIEF` wordmark default)
- [ ] Write content as data, pages as functions, register them in the `build()` tuple
- [ ] Build, rasterise, look at every page (overflow assertion does not catch overlaps, only footer collisions)
- [ ] Keep a `self_check()` for any new parsing or layout logic

## 11. Why this approach (trade-off)

| | HTML/CSS + headless Chromium | This system |
|---|---|---|
| Lines of code | About 100 for 4 pages | About 450 kit + content |
| Text reflow | Automatic | Manual, but measured; equal-height rows are handled |
| Dependencies | Chromium | pycairo only |
| Output control | Good | Exact, coordinate-level |
| Data-driven / batch | Needs templating | Native: it is already Python |

Choose it when the PDF is generated from data, must run headless without a browser, or needs exact placement. Choose HTML/CSS when the layout is text-heavy and changes often.
