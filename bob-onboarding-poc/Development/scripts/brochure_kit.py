#!/usr/bin/env python3
"""Brochure kit: pure-Python A4 PDF primitives on pycairo (no HTML/CSS/Chromium).

Faithful copy of the kit in build_tech_brief.py (see ../docs/pdf-brochure-system.md),
minus the tech-brief content. Changes: build() takes `author`; FAMILY defaults to Arial
on Windows (Liberation Sans is Arial-metric, so wrapping matches).
Units: CSS-style px at 96 dpi; the cairo context is scaled by 0.75 onto PDF points.
"""
import os
import sys
import cairo

MM = 96 / 25.4
W, H = 210 * MM, 297 * MM
PAD_X, PAD_TOP = 16 * MM, 18 * MM
FOOT_H = 14 * MM
CW = W - 2 * PAD_X  # content width
FAMILY = os.environ.get("BROCHURE_FONT", "Arial" if sys.platform == "win32" else "Liberation Sans")

Y, K, G, T, WHITE, RULE = (
    (0xF5 / 255, 0xB8 / 255, 0),
    (0x11 / 255,) * 3,
    (0x6B / 255,) * 3,
    (0x33 / 255,) * 3,
    (1, 1, 1),
    (0xDD / 255,) * 3,
)

c = None  # current cairo context, set per page
max_y = 0  # lowest content y drawn on the current page (checked against footer)


# ---------- primitives ----------
def font(size_pt, bold=False):
    c.select_font_face(FAMILY, cairo.FONT_SLANT_NORMAL,
                       cairo.FONT_WEIGHT_BOLD if bold else cairo.FONT_WEIGHT_NORMAL)
    c.set_font_size(size_pt * 4 / 3)
    fo = cairo.FontOptions()
    fo.set_hint_metrics(cairo.HINT_METRICS_OFF)  # hinted advances make text wider than Chrome's
    c.set_font_options(fo)


def tw(s, size, bold=False, ls=0.0):
    """Text width in px; ls = letter-spacing in em."""
    font(size, bold)
    return c.text_extents(s).x_advance + ls * size * 4 / 3 * len(s)


def text(x, top, s, size, bold=False, color=K, ls=0.0, lh=None, anchor="l"):
    """Draw s with its line box starting at `top`; returns line height."""
    global max_y
    lh = lh or size * 4 / 3 * 1.2
    px = size * 4 / 3
    base = top + (lh - px * 1.117) / 2 + px * 0.905  # centre glyph box in the line
    w = tw(s, size, bold, ls)
    x = x - w if anchor == "r" else x - w / 2 if anchor == "c" else x
    font(size, bold)
    c.set_source_rgb(*color)
    if ls:
        for ch in s:
            c.move_to(x, base)
            c.show_text(ch)
            x += c.text_extents(ch).x_advance + ls * px
    else:
        c.move_to(x, base)
        c.show_text(s)
    max_y = max(max_y, top + lh)
    return lh


def rect(x, y, w, h, fill):
    global max_y
    c.set_source_rgb(*fill)
    c.rectangle(x, y, w, h)
    c.fill()
    max_y = max(max_y, y + h)


def frame(x, y, w, h, lw, color):
    """CSS-like inside border."""
    c.set_source_rgb(*color)
    c.set_line_width(lw)
    c.rectangle(x + lw / 2, y + lw / 2, w - lw, h - lw)
    c.stroke()


def wrap(segs, width, size, bold=False):
    """Word-wrap. segs: str or [(str, bold)]. Returns lines of [(word, bold, glued)].
    glued = no space before it (segment starts with punctuation right after a word)."""
    if isinstance(segs, str):
        segs = [(segs, bold)]
    words, prev = [], ""
    for s_, b in segs:
        for i, w in enumerate(s_.split()):
            glued = i == 0 and prev != "" and not prev[-1].isspace() and not s_[0].isspace()
            words.append((w, b, glued))
        prev = s_
    space = tw(" ", size)
    lines, cur, cur_w = [], [], 0
    for w, b, g in words:
        ww = tw(w, size, b)
        add = ww + (0 if g or not cur else space)
        if cur and not g and cur_w + add > width:  # glued punctuation never starts a line
            lines.append(cur)
            cur, cur_w = [(w, b, False)], ww
        else:
            cur.append((w, b, g))
            cur_w += add
    return lines + ([cur] if cur else [])


def para(x, y, w, segs, size, lh_ratio=1.5, color=T, bold=False, draw=True):
    """Paragraph; returns height."""
    lh = size * 4 / 3 * lh_ratio
    lines = wrap(segs, w, size, bold)
    if draw:
        for i, line in enumerate(lines):
            cx = x
            for k, (word, b, g) in enumerate(line):
                if k and not g:
                    cx += tw(" ", size)
                text(cx, y + i * lh, word, size, b, color, lh=lh)
                cx += tw(word, size, b)
    return len(lines) * lh


def texture():
    """135deg hairlines, 1px every 15px (perpendicular), rgba(0,0,0,.035)."""
    c.save()
    c.rectangle(0, 0, W, H)
    c.clip()
    c.set_source_rgba(0, 0, 0, 0.035)
    c.set_line_width(1)
    step = 15 * 2 ** 0.5
    n = -H
    while n < W + H:
        c.move_to(n, 0)  # x + y = const  ->  "/" lines
        c.line_to(n - H, H)
        n += step
    c.stroke()
    c.restore()


def footer(left_bold, left_rest, right):
    global max_y
    saved, top = max_y, H - FOOT_H
    rect(0, top, W, FOOT_H, K)
    x = PAD_X
    text(x, top, left_bold, 8, True, Y, ls=0.06, lh=FOOT_H)
    x += tw(left_bold, 8, True, 0.06)
    text(x, top, left_rest, 8, False, WHITE, ls=0.06, lh=FOOT_H)
    text(W - PAD_X, top, right, 8, False, WHITE, ls=0.06, lh=FOOT_H, anchor="r")
    max_y = saved  # footer is not content; page_end() checks content only


def header(kicker, title, size=26, y=PAD_TOP, with_kicker=True):
    """Kicker + h2 + yellow bar. Returns y after the bar's bottom margin."""
    if with_kicker:
        y += text(PAD_X, y, kicker.upper(), 8.5, True, G, ls=0.22, lh=12)
    return bar_after(y, title, size)


def bar_after(y, title, size):
    lh = size * 4 / 3
    text(PAD_X, y, title.upper(), size, True, K, ls=-0.01, lh=lh)
    y += lh + 10
    rect(PAD_X, y, 60, 8, Y)
    return y + 8 + 14


def page_end():
    """Check nothing overflowed into the footer."""
    limit = H - FOOT_H - 8
    assert max_y <= limit, f"content overflows footer: {max_y:.0f} > {limit:.0f}"


# ---------- components ----------
def tags(x, y, w, items, hot, draw=True):
    sz, ch, gap = 8, 17, 4
    cx, cy = x, y
    for t in items:
        cw = tw(t, sz, True) + 12
        if cx + cw > x + w and cx > x:
            cx, cy = x, cy + ch + gap
        if draw:
            rect(cx, cy, cw, ch, WHITE if hot else K)
            text(cx + cw / 2, cy, t, sz, True, K if hot else WHITE, lh=ch, anchor="c")
        cx += cw + gap
    return cy + ch - y


def tile(x, y, w, item, h=None, draw=True):
    """Icon tile. Returns its height (h forces a height for equal rows)."""
    code, title, body, tag_list, hot = item
    px, py = 18, 20
    inner = w - 2 * px
    bw = max(30, tw(code, 11, True) + 16)
    hh = 30 + 8 + 16 * 1.2 + 4
    bh = para(0, 0, inner, body, 9.6, draw=False)
    th = tags(0, 0, inner, tag_list, hot, draw=False)
    total = 2 * py + hh + bh + 7 + th
    total = max(total, h or 0)
    if draw:
        rect(x, y, w, total, Y if hot else WHITE)
        frame(x, y, w, total, 1.5, K)
        cy = y + py
        rect(x + px, cy, bw, 30, K if hot else Y)
        text(x + px + bw / 2, cy, code, 11, True, Y if hot else K, lh=30, anchor="c")
        cy += 38
        cy += text(x + px, cy, title.upper(), 12, True, K, lh=16 * 1.2) + 4
        cy += para(x + px, cy, inner, body, 9.6) + 7
        tags(x + px, cy, inner, tag_list, hot)
    return total


def tile_row(x, y, w, items, gap=14):
    """One or two tiles side by side with equal heights. Returns row height."""
    tw_ = (w - gap * (len(items) - 1)) / len(items)
    h = max(tile(0, 0, tw_, it, draw=False) for it in items)
    for i, it in enumerate(items):
        tile(x + i * (tw_ + gap), y, tw_, it, h=h)
    return h


def card(x, y, w, label, bullets, h=None, draw=True):
    px, py = 18, 20
    chip_h = 12 * 1.3 + 4
    lh = 9.8 * 4 / 3 * 1.6
    inner = w - 2 * px - 14
    body = sum(len(wrap(b, inner, 9.8)) for b in bullets) * lh
    total = max(2 * py + chip_h + 8 + body, h or 0)
    if draw:
        frame(x, y, w, total, 1.5, K)
        cy = y + py
        cw = tw(label.upper(), 9, True) + 16
        rect(x + px, cy, cw, chip_h, Y)
        text(x + px + 8, cy, label.upper(), 9, True, K, lh=chip_h)
        cy += chip_h + 8
        for b in bullets:
            lines = wrap(b, inner, 9.8)
            text(x + px, cy, "•", 9.8, False, T, lh=lh)
            for ln in lines:
                text(x + px + 14, cy, " ".join(w_ for w_, _, _ in ln), 9.8, False, T, lh=lh)
                cy += lh
    return total


def card_row(y, cards, gap=14):
    w = (CW - gap) / 2
    h = max(card(0, 0, w, *cd, draw=False) for cd in cards)
    for i, cd in enumerate(cards):
        card(PAD_X + i * (w + gap), y, w, *cd, h=h)
    return h



# ---------- cover + build ----------
def page_cover(line1, line2a, line2b, panel, blurb, brand, credit, foot_rest=""):
    """Titles fit about 11 characters per line at 40 pt; panel about 6 characters at 52 pt."""
    rect(W - 62 * MM, 0, 62 * MM, 190 * MM, Y)
    rect(PAD_X, PAD_TOP, 22, 22, K)
    rect(PAD_X + 11, PAD_TOP + 11, 11, 11, Y)
    text(PAD_X + 30, PAD_TOP, brand, 10, True, K, ls=0.14, lh=22)
    pw, ph = 78 * MM, 96 * MM
    px_, py_ = W - PAD_X - pw, 70 * MM
    rect(px_, py_, pw, ph, K)
    frame(px_ + 10, py_ + 10, pw - 20, ph - 20, 2, Y)
    text(px_ + 18, py_ + ph - 16 - 52 * 4 / 3, panel, 52, True, Y, lh=52 * 4 / 3)
    y = PAD_TOP + 22 + 62 * MM
    lh = 40 * 4 / 3 * 0.95
    text(PAD_X, y, line1, 40, True, K, ls=-0.02, lh=lh)
    y += lh
    tx = PAD_X + tw(line2a, 40, True, -0.02)
    rect(tx, y, tw(line2b, 40, True, -0.02) + 12, lh, Y)
    text(PAD_X, y, line2a, 40, True, K, ls=-0.02, lh=lh)
    text(tx + 6, y, line2b, 40, True, K, ls=-0.02, lh=lh)
    y += lh + 10
    rect(PAD_X, y, 60, 8, Y)
    y += 8 + 14
    para(PAD_X, y, 95 * MM, blurb, 11)
    footer(brand, foot_rest, credit)


def build(out, pages, title, author):
    """pages: sequence of zero-arg callables; each draws its own footer."""
    global c, max_y
    surf = cairo.PDFSurface(out, W * 0.75, H * 0.75)
    surf.set_metadata(cairo.PDF_METADATA_TITLE, title)
    surf.set_metadata(cairo.PDF_METADATA_AUTHOR, author)
    for pg in pages:
        c = cairo.Context(surf)
        c.scale(0.75, 0.75)
        rect(0, 0, W, H, WHITE)
        texture()
        max_y = 0
        pg()
        page_end()
        surf.show_page()
    surf.finish()


def self_check():
    """Wrapped lines fit their width; punctuation after bold words gets no stray space."""
    global c
    c = cairo.Context(cairo.ImageSurface(cairo.FORMAT_ARGB32, 10, 10))
    segs = [("One ", False), ("bold", True), (", then", False), (" more", False)]
    for width in (60, 250, 600):
        for ln in wrap(segs, width, 9.5):
            used = sum(tw(w, 9.5, b) for w, b, _ in ln)
            assert used <= width + 8, (width, used)
    assert wrap("", 100, 9) == []
    assert sum(g for ln in wrap(segs, 9999, 9.5) for _, _, g in ln) == 1
    print("kit self-check ok")


if __name__ == "__main__":
    self_check()
