#!/usr/bin/env python3
"""Render onboarding/<slug>/pack.md + intake.yaml -> <company>-onboarding-<slug>.pdf (see pipeline_tools.py names).

  python render_pdf.py onboarding/<slug> [out.pdf]

Markdown subset: # ## ### headings, paragraphs, - / 1. lists, | tables |, > callouts,
```code```, **bold** and `code` (both render bold: the kit has only normal/bold).
Adds what the kit lacks: automatic pagination (measure, then place; tables repeat their
header row across pages). Requires pycairo. See ../docs/pdf-brochure-system.md.
"""
import datetime as dt
import re
import sys
from pathlib import Path

try:
    import cairo
    import brochure_kit as bt
except ImportError:
    sys.exit("PDF step needs pycairo: `pip install pycairo` (Arch: python-cairo). "
             "Without it, send pack.md and the context zip instead of a PDF.")
from pipeline_tools import load_flat, names

BOTTOM = bt.H - bt.FOOT_H - 16
CW = bt.CW
BODY, SMALL = 9.5, 8.6
GREY = (0xF2 / 255,) * 3


# ---------- markdown -> blocks ----------
def inline(s):
    """`**bold**` and `code` -> [(text, bold)]."""
    parts = re.split(r"(\*\*|`)", s)
    segs, bold = [], False
    for p in parts:
        if p in ("**", "`"):
            bold = not bold
        elif p:
            segs.append((p, bold))
    return segs or [("", False)]


def parse(md):
    blocks, lines, i, seen_h1 = [], md.splitlines(), 0, False

    def cells(ln):
        return [c.strip() for c in ln.strip().strip("|").split("|")]

    while i < len(lines):
        ln = lines[i]
        s = ln.strip()
        if not s or s == "---" or s.startswith("<"):
            i += 1
        elif s.startswith("```"):
            i += 1
            code = []
            while i < len(lines) and not lines[i].strip().startswith("```"):
                code.append(lines[i].rstrip())
                i += 1
            i += 1
            blocks += [("code", code), ("space", 8)]
        elif s.startswith("#"):
            lvl = len(s) - len(s.lstrip("#"))
            kind = ("h1", "h2", "h3")[min(lvl, 3) - 1]
            n_h2 = sum(b[0] == "h2" for b in blocks) + 1
            blocks.append((kind, s.lstrip("# ").strip(), n_h2))
            seen_h1 |= lvl == 1
            i += 1
            if lvl == 1 and i < len(lines) and lines[i].strip() and not lines[i].startswith(("#", "|", "-")):
                blocks.append(("meta", inline(lines[i].strip())))
                i += 1
        elif s.startswith("|"):
            rows = []
            while i < len(lines) and lines[i].strip().startswith("|"):
                r = cells(lines[i])
                if not all(re.fullmatch(r":?-{2,}:?", c) for c in r):
                    rows.append(r)
                i += 1
            n = len(rows[0])
            wts = [min(max(8, max(len(r[k]) if k < len(r) else 0 for r in rows)), 45) for k in range(n)]
            widths = [CW * x / sum(wts) for x in wts]
            hdr = [[(c.upper(), True)] for c in rows[0]]
            blocks.append(("trow", hdr, widths, True, hdr))
            for r in rows[1:]:
                r = (r + [""] * n)[:n]
                blocks.append(("trow", [inline(c) for c in r], widths, False, hdr))
            blocks.append(("space", 8))
        elif re.match(r"([-*]|\d+\.)\s", s):
            while i < len(lines) and re.match(r"\s*([-*]|\d+\.)\s", lines[i]):
                m = re.match(r"\s*([-*]|\d+\.)\s+(.*)", lines[i])
                blocks.append(("li", "•" if m.group(1) in "-*" else m.group(1), inline(m.group(2))))
                i += 1
            blocks.append(("space", 6))
        elif s.startswith(">"):
            q = []
            while i < len(lines) and lines[i].strip().startswith(">"):
                q.append(lines[i].strip().lstrip("> "))
                i += 1
            blocks += [("quote", inline(" ".join(q))), ("space", 8)]
        else:
            p = []
            while i < len(lines) and lines[i].strip() and not re.match(r"\s*(#|\||```|>|([-*]|\d+\.)\s)", lines[i]):
                p.append(lines[i].strip())
                i += 1
            blocks.append(("p", inline(" ".join(p))))
    return blocks


# ---------- measure / draw ----------
def h1_size(t):
    sz = 20
    while sz > 12 and bt.tw(t.upper(), sz, True, -0.01) > CW:
        sz -= 1
    return sz


def height(b):
    k = b[0]
    if k == "h1":
        return 12 + h1_size(b[1]) * 4 / 3 + 10 + 8 + 14
    if k == "h2":
        return 12 + 20 * 4 / 3 + 10 + 8 + 14
    if k == "h3":
        return 22
    if k == "meta":
        return bt.para(0, 0, CW, b[1], SMALL, 1.4, draw=False) + 12
    if k == "p":
        return bt.para(0, 0, CW, b[1], BODY, draw=False) + 8
    if k == "li":
        return bt.para(0, 0, CW - 18, b[2], BODY, draw=False) + 3
    if k == "quote":
        return bt.para(0, 0, CW - 16, b[1], SMALL, 1.4, draw=False) + 10
    if k == "code":
        return sum(bt.para(0, 0, CW - 24, [(ln or " ", False)], 8, 1.35, draw=False) for ln in b[1]) + 16
    if k == "trow":
        return max(bt.para(0, 0, w - 12, c, SMALL, 1.35, draw=False) for c, w in zip(b[1], b[2])) + 12
    return b[1]  # space


def draw(b, y):
    k = b[0]
    if k == "h1":
        sz = h1_size(b[1])
        y += bt.text(bt.PAD_X, y, "ONBOARDING PACK", 8.5, True, bt.G, ls=0.22, lh=12)
        bt.bar_after(y, b[1], sz)
    elif k == "h2":
        y += bt.text(bt.PAD_X, y, f"SECTION {b[2]:02d}", 8.5, True, bt.G, ls=0.22, lh=12)
        bt.bar_after(y, b[1], 20)
    elif k == "h3":
        bt.text(bt.PAD_X, y, b[1].upper(), 11, True, bt.K, ls=0.02, lh=18)
    elif k == "meta":
        bt.para(bt.PAD_X, y, CW, b[1], SMALL, 1.4, bt.G)
    elif k == "p":
        bt.para(bt.PAD_X, y, CW, b[1], BODY)
    elif k == "li":
        bt.text(bt.PAD_X + 2, y, b[1], BODY, b[1] != "•", bt.T, lh=BODY * 4 / 3 * 1.5)
        bt.para(bt.PAD_X + 18, y, CW - 18, b[2], BODY)
    elif k == "quote":
        h = bt.para(bt.PAD_X + 14, y + 4, CW - 16, b[1], SMALL, 1.4, bt.G)
        bt.rect(bt.PAD_X, y + 4, 4, h, bt.Y)
    elif k == "code":
        bt.rect(bt.PAD_X, y, CW, height(b), GREY)
        cy = y + 8
        for ln in b[1]:
            cy += bt.para(bt.PAD_X + 12, cy, CW - 24, [(ln or " ", False)], 8, 1.35)
    elif k == "trow":
        _, cs, ws, is_h, _h = b
        h = height(b)
        if is_h:
            bt.rect(bt.PAD_X, y, CW, h, bt.K)
        x = bt.PAD_X
        for c, w in zip(cs, ws):
            bt.para(x + 6, y + 6, w - 12, c, 8 if is_h else SMALL, 1.35, bt.Y if is_h else bt.T)
            x += w
        if not is_h:
            bt.rect(bt.PAD_X, y + h - 1, CW, 1, bt.RULE)


# ---------- layout ----------
def layout(blocks):
    """-> (pages: list of [(block, y)], sections: [(title, page_index)])."""
    pages, cur, sections = [], [], []
    y = bt.PAD_TOP
    for i, b in enumerate(blocks):
        h = height(b)
        assert h <= BOTTOM - bt.PAD_TOP, f"block too tall for one page: {b[0]} {str(b[1])[:40]}"
        need = h
        if b[0] in ("h1", "h2", "h3"):  # keep heading with the start of what follows
            nxt = next((n for n in blocks[i + 1:] if n[0] != "space"), None)
            need += min(height(nxt), 70) if nxt else 0
        if b[0] == "space" and y == bt.PAD_TOP:
            continue
        gap = (14 if b[0] == "h2" else 8 if b[0] == "h3" else 0) if y != bt.PAD_TOP else 0
        if cur and y + gap + need > BOTTOM:
            pages.append(cur)
            cur, y = [], bt.PAD_TOP
            gap = 0
            if b[0] == "trow" and not b[3]:  # repeat table header on the new page
                hb = ("trow", b[4], b[2], True, b[4])
                cur.append((hb, y))
                y += height(hb)
        y += gap
        cur.append((b, y))
        if b[0] == "h2":
            sections.append((b[1], len(pages)))
        y += h
    if cur:
        pages.append(cur)
    return pages, sections


# ---------- document ----------
def render(d, out=None):
    d = Path(d)
    info = load_flat(d / "intake.yaml")
    blocks = parse((d / "pack.md").read_text(encoding="utf-8"))
    bt.c = cairo.Context(cairo.ImageSurface(cairo.FORMAT_ARGB32, 10, 10))  # for measuring
    pages, sections = layout(blocks)
    company = info.get("company", "Company")
    brand = company.upper()[:24]
    foot = (brand, " · Onboarding")
    start, end = dt.date.fromisoformat(info["start_date"]), dt.date.fromisoformat(info["end_date"])
    days = (end - start).days

    def cover():
        bt.page_cover("WELCOME", "TO THE ", "TEAM", start.strftime("%b %d").upper(),
                      f"{info['name']} · {info['position']}. {start} to {end}. Read this first, "
                      f"then open the context folder in Bob.", brand, f"Prepared for {info['name']}",
                      " · Onboarding")

    def contents():
        y = bt.header("Overview", "Contents") + 2
        for n, (title, pg) in enumerate(sections, 1):
            rh = 34
            bt.rect(bt.PAD_X, y + rh - 1, CW, 1, bt.RULE)
            bt.rect(bt.PAD_X, y + 6, 30, 22, bt.Y)
            bt.text(bt.PAD_X + 15, y + 6, f"{n:02d}", 10, True, bt.K, lh=22, anchor="c")
            bt.text(bt.PAD_X + 44, y, title.upper()[:60], 10, True, bt.K, lh=rh)
            bt.text(bt.W - bt.PAD_X, y, f"P. {pg + 3}", 10, False, bt.G, lh=rh, anchor="r")
            y += rh
        y += 18
        y += bt.tile_row(bt.PAD_X, y, CW, [
            ("YOU", info["name"], f"{info['position']}. Level: {info.get('experience', 'not set')}. "
             f"Work email: {info['email']}", [company], True),
            ("DAY", "Timeline", f"{start} to {end}, {days} days.", [f"Start {start}", f"End {end}"], False),
        ]) + 14
        bt.card_row(y, [
            ("Your people", [f"Manager: {info.get('manager') or 'ask your manager'}",
                             f"Buddy: {info.get('buddy') or 'ask your manager'}"]),
            ("Start here", ["Read this pack, then watch the video if it came with your email",
                            "Set up Bob IDE with the context zip: steps in your email and in context/README.md",
                            "Then follow the Timeline section"]),
        ])
        bt.footer(*foot, "02")

    def body(items, n):
        def page():
            for b, y in items:
                draw(b, y)
            bt.footer(*foot, f"{n:02d}")
        return page

    bt.build(str(out or names(d)["pdf"]),
             [cover, contents] + [body(p, i + 3) for i, p in enumerate(pages)],
             f"Onboarding pack: {info['name']}", company)
    return len(pages) + 2


def self_test():
    md = ("# Welcome to Acme, Sam\nRole: dev · Level: mid\n\n## Why\nWe make **things**, and `a.py:3` too.\n\n"
          "- one\n- two\n\n| A | B |\n|---|---|\n| x | y |\n\n> note\n\n```\ncode\n```\n")
    bl = parse(md)
    assert [b[0] for b in bl][:4] == ["h1", "meta", "h2", "p"], bl
    assert bl[3][1][1] == ("things", True) and bl[3][1][2] == (", and ", False)
    assert sum(b[0] == "trow" for b in bl) == 2 and any(b[0] == "code" for b in bl)
    bt.c = cairo.Context(cairo.ImageSurface(cairo.FORMAT_ARGB32, 10, 10))
    many = parse("## S\n" + "\n".join(f"| {i} | row {i} |" if i else "| a | b |\n|--|--|" for i in range(120)))
    pages, secs = layout(many)
    assert len(pages) > 1 and pages[1][0][0][3] is True, "header row must repeat on page 2"
    print("render self-check ok")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    print("wrote", sys.argv[2] if len(sys.argv) > 2 else "PDF", "-", render(*sys.argv[1:3]), "pages")
