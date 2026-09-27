#!/usr/bin/env python3
"""Render onboarding/<slug>/storyboard.json -> <company>-onboarding-<slug>-tour.mp4: a narrated, captioned tour.

  python make_video.py onboarding/<slug> [out.mp4] [--repo PATH] [--no-captions] [--check]
  python make_video.py --doctor     list what is missing (exit 1 if not ready)
  python make_video.py --setup      pip-install everything it needs: piper-tts, the voice, a bundled ffmpeg if none

Deterministic: no LLM here. Bob writes storyboard.json at stage 2; pipeline_tools.py check validates it at
stage 3 (schema, every path:line exists in the repo AND in pack.md, no emails/urls/dates in the narration,
length budget); this script re-validates, then draws slides with the PDF brochure kit (pycairo, 16:9),
speaks each sentence with Piper (offline TTS), captions it, and joins the clips with ffmpeg.
Code excerpts are read from --repo (default: codebase_path in intake.yaml), never leave it, and lines that
look like credentials are masked. Missing repo/file -> the scene shows the path instead.
"""
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import wave
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
try:
    import cairo
except ImportError:
    sys.exit("Video step needs pycairo: `pip install pycairo` (Arch: python-cairo). Without it, skip the video.")
import importlib.util

from pipeline_tools import check_storyboard, load_flat, names


def _private_kit():
    """The brochure kit keeps page size and the current canvas in module globals. The video needs a 16:9 page,
    so it gets its OWN copy of the module; sharing render_pdf's would break the PDF in the same process."""
    spec = importlib.util.spec_from_file_location("brochure_kit_video", HERE / "brochure_kit.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


bt = _private_kit()

VOICE_NAME = "en_US-lessac-medium"
VOICES = Path(os.environ.get("PIPER_VOICE_DIR", HERE / "voices"))
PX_W, PX_H = 1280, 720  # output size; the kit draws on a 960x540 logical canvas scaled by 4/3
# The kit reads these module globals at call time, so re-pointing them (on our private copy) re-lays it out for 16:9.
bt.W, bt.H, bt.PAD_X, bt.PAD_TOP, bt.FOOT_H = 960, 540, 48, 34, 64  # 64px bottom band: brand footer, or captions
bt.CW = bt.W - 2 * bt.PAD_X
MONO = os.environ.get("BROCHURE_MONO", "Consolas" if sys.platform == "win32" else "Liberation Mono")
BRAND = "ONBOARDING PACK"
MAX_S = 180  # hackathon cap per the vault notes (judges stop at 3:00); raise if the submission form says otherwise
SPELLED = re.compile(r"\b[A-Z](?: [A-Z]){2,}\b")  # "D A O" is written spaced so the voice spells it; captions show DAO
MAX_CAPTION = 150  # chars per caption piece; two lines fit the band
SECRET = re.compile(r"(?i)pass(word)?|secret|token|api[_-]?key|credential|jdbc:|\buser(name)?\b\s*=")
NO_EXCERPT = re.compile(r"(?i)\.env|\.pem|\.key|secret|credential")


# ---------- dependencies ----------
def ffmpeg_exe():
    """ffmpeg on PATH, else the copy bundled by the pip package imageio-ffmpeg (what --setup installs when the
    machine has none, so nothing has to be installed by hand or added to PATH). None if neither exists."""
    found = shutil.which("ffmpeg")
    if found:
        return found
    try:
        import imageio_ffmpeg
        return imageio_ffmpeg.get_ffmpeg_exe()
    except Exception:  # not installed, or the bundled binary is absent for this platform
        return None


def missing():
    """[] when the video step can run; else one actionable line per problem."""
    out = []
    if not ffmpeg_exe():
        out.append("ffmpeg not found: python scripts/make_video.py --setup installs a bundled copy (pip: imageio-ffmpeg)")
    try:
        import piper  # noqa: F401
        have_piper = True
    except ImportError:
        have_piper = False
        out.append("piper-tts not installed: python scripts/make_video.py --setup")
    if not (VOICES / f"{VOICE_NAME}.onnx").is_file():
        out.append(f"voice model {VOICE_NAME} not in {VOICES}: python scripts/make_video.py --setup"
                   + ("" if have_piper else " (after installing piper-tts)"))
    return out


def setup():
    """Install everything the video needs, with pip only (no sudo, no system package manager, no PATH edits):
    piper-tts, the ~63 MB English voice, and a bundled ffmpeg if the machine has none. Idempotent."""
    def pip(*pkgs):
        try:
            subprocess.run([sys.executable, "-m", "pip", "install", *pkgs], check=True)
        except subprocess.CalledProcessError:
            sys.exit(f"pip could not install {' '.join(pkgs)}. If it says 'externally-managed-environment', create a "
                     "virtual environment (python -m venv .venv), activate it, and run --setup again.")
    try:
        import piper  # noqa: F401
    except ImportError:
        pip("piper-tts")
    if not (VOICES / f"{VOICE_NAME}.onnx").is_file():
        VOICES.mkdir(parents=True, exist_ok=True)
        subprocess.run([sys.executable, "-m", "piper.download_voices", VOICE_NAME, "--download-dir", str(VOICES)], check=True)
    if not ffmpeg_exe():
        pip("imageio-ffmpeg")
    if m := missing():
        sys.exit("setup finished but still not ready:\n  " + "\n  ".join(m))
    print("video tools ready")


# ---------- captions ----------
def chunks(say):
    """Narration -> pieces of at most ~MAX_CAPTION chars: sentences, long ones split at commas."""
    out = []
    for sent in re.split(r"(?<=[.!?])\s+", say.strip()):
        cur = ""
        for part in re.split(r"(?<=,)\s+", sent):
            if cur and len(cur) + len(part) + 1 > MAX_CAPTION:
                out.append(cur)
                cur = part
            else:
                cur = f"{cur} {part}".strip()
        if cur:
            out.append(cur)
    return out


def caption_text(piece):
    return SPELLED.sub(lambda m: m.group().replace(" ", ""), piece)


def foot(heading, i, n, caption):
    """Bottom band: the caption when there is one, else the brand footer."""
    if not caption:
        return bt.footer(BRAND, " · " + heading, f"{i:02d}/{n:02d}")
    top = bt.H - bt.FOOT_H
    bt.rect(0, top, bt.W, bt.FOOT_H, bt.K)
    bt.rect(0, top, 6, bt.FOOT_H, bt.Y)
    lines = [" ".join(w for w, _, _ in ln) for ln in bt.wrap(caption, bt.CW - 30, 14)]
    lh = 14 * 4 / 3 * 1.35
    y = top + (bt.FOOT_H - len(lines) * lh) / 2
    for ln in lines:
        y += bt.text(bt.W / 2, y, ln, 14, False, bt.WHITE, lh=lh, anchor="c")


# ---------- drawing (brochure kit) ----------
def fit(s, w, size, bold=False):
    while s and bt.tw(s, size, bold) > w:
        s = s[:-2] + "…" if s.endswith("…") else s[:-1] + "…"
    return s


def canvas():
    s = cairo.ImageSurface(cairo.FORMAT_RGB24, PX_W, PX_H)
    bt.c = cairo.Context(s)
    bt.c.scale(PX_W / bt.W, PX_H / bt.H)
    bt.rect(0, 0, bt.W, bt.H, bt.WHITE)
    bt.texture()
    bt.max_y = 0
    return s


def bullets(y, texts):
    for t in texts[:6]:
        bt.rect(bt.PAD_X, y + 10, 11, 11, bt.Y)
        bt.frame(bt.PAD_X, y + 10, 11, 11, 1.2, bt.K)
        y += max(bt.para(bt.PAD_X + 28, y, bt.CW - 28, t, 18, 1.35, color=bt.K), 32) + 12
    return y


def code_box(y, lines):
    """Black panel of plain lines (used for path chips)."""
    lines = lines[:6]
    h = 24 + len(lines) * 22
    bt.rect(bt.PAD_X, y, bt.CW, h, bt.K)
    bt.rect(bt.PAD_X, y, 6, h, bt.Y)
    saved, bt.FAMILY = bt.FAMILY, MONO
    for i, ln in enumerate(lines):
        bt.text(bt.PAD_X + 26, y + 12 + i * 22, fit(ln, bt.CW - 50, 11), 11, False, bt.WHITE, lh=22)
    bt.FAMILY = saved
    return y + h + 10


def excerpt(repo, ref, half):
    """[(lineno, text, is_cited_line)] around `path:line` in the repo, or None (no repo/file/unsafe path).
    Never leaves the repo, skips secret-looking files, masks string literals on secret-looking lines."""
    if repo is None:
        return None
    rel, _, ln = ref.rpartition(":")
    f = (repo / rel).resolve()
    if not f.is_relative_to(repo) or not f.is_file() or NO_EXCERPT.search(f.name):
        return None
    lines, n = f.read_text(encoding="utf-8", errors="replace").splitlines(), int(ln)
    if not 1 <= n <= len(lines):
        return None
    out = []
    for k in range(max(1, n - half), min(len(lines), n + half) + 1):
        t = lines[k - 1].replace("\t", "    ")
        if SECRET.search(t):
            t = re.sub(r"\"[^\"]*\"|'[^']*'", '"•••"', t)  # credentials must never reach a video
        out.append((k, t, k == n))
    return out


def excerpt_box(y, ref, ex):
    """Black code panel with line numbers; the cited line sits on a yellow bar."""
    h = 30 + len(ex) * 22 + 10
    bt.rect(bt.PAD_X, y, bt.CW, h, bt.K)
    bt.rect(bt.PAD_X, y, 6, h, bt.Y)
    bt.text(bt.PAD_X + 26, y + 6, ref, 9, True, bt.Y, ls=0.06, lh=20)
    saved, bt.FAMILY = bt.FAMILY, MONO
    for j, (k, t, hit) in enumerate(ex):
        ry = y + 30 + j * 22
        if hit:
            bt.rect(bt.PAD_X + 6, ry, bt.CW - 6, 22, bt.Y)
        bt.text(bt.PAD_X + 26, ry, str(k).rjust(3), 11, False, bt.K if hit else (0.55, 0.55, 0.55), lh=22)
        bt.text(bt.PAD_X + 64, ry, fit(t, bt.CW - 90, 11), 11, hit, bt.K if hit else bt.WHITE, lh=22)
    bt.FAMILY = saved
    return y + h + 10


def refs_box(y, refs, repo):
    """First ref as a real code excerpt (if the repo has it), the rest as path chips."""
    ex = excerpt(repo, refs[0], 3 if len(refs) == 1 else 2)
    if ex:
        y = excerpt_box(y, refs[0], ex)
        refs = refs[1:]
    return code_box(y, refs) if refs else y


def finish(path, s, i, n, heading, caption):
    bt.page_end()  # fails loudly if content runs into the bottom band
    bt.rect(0, bt.H - bt.FOOT_H - 4, bt.W * i / n, 4, bt.Y)  # progress bar, sits on the band's top edge
    foot(heading, i, n, caption)
    s.write_to_png(str(path))


def cover(path, title, meta_lines, n, caption=None):
    s = canvas()
    bt.rect(bt.W - 300, 0, 300, bt.H - bt.FOOT_H - 8, bt.Y)  # yellow panel, like the PDF cover
    pw, ph, px, py = 210, 250, bt.W - 300 + 45, 110
    bt.rect(px, py, pw, ph, bt.K)
    bt.frame(px + 10, py + 10, pw - 20, ph - 20, 2, bt.Y)
    bt.text(px + 24, py + ph - 24 - 46 * 4 / 3, "ONE", 46, True, bt.Y, lh=46 * 4 / 3)
    bt.text(px + 24, py + ph - 24 - 46 * 4 / 3 * 2, "DAY", 46, True, bt.Y, lh=46 * 4 / 3)
    bt.rect(bt.PAD_X, bt.PAD_TOP, 22, 22, bt.K)
    bt.rect(bt.PAD_X + 11, bt.PAD_TOP + 11, 11, 11, bt.Y)
    bt.text(bt.PAD_X + 30, bt.PAD_TOP, BRAND, 10, True, bt.K, ls=0.14, lh=22)
    pre, _, name = title.rpartition(", ")
    if not pre:
        pre, name = title, ""
    size = 32
    while bt.tw(pre, size, True, -0.02) > 560 and size > 20:
        size -= 2
    lh, y = size * 4 / 3 * 0.95, 130
    y += bt.text(bt.PAD_X, y, pre + ("," if name else ""), size, True, bt.K, ls=-0.02, lh=lh)
    if name:
        bt.rect(bt.PAD_X, y, bt.tw(name, size, True, -0.02) + 12, lh, bt.Y)
        y += bt.text(bt.PAD_X + 6, y, name, size, True, bt.K, ls=-0.02, lh=lh)
    y += 12
    bt.rect(bt.PAD_X, y, 60, 8, bt.Y)
    y += 8 + 22
    tag_list = [t.strip().upper() for ln in meta_lines for t in ln.split(" · ") if t.strip()]
    tag_list = [t for t in tag_list if not re.search(r"\d{4}-\d{2}-\d{2}", t)]  # dates stay in the pack's timeline
    bt.tags(bt.PAD_X, y, 560, tag_list, hot=False)
    finish(path, s, 1, n, title, caption)


def points_slide(path, i, n, title, points, heading, caption=None):
    s = canvas()
    y = bt.header(f"{i:02d} / {n:02d}", title, size=26, y=bt.PAD_TOP)
    bullets(y + 10, points)
    finish(path, s, i, n, heading, caption)


def flow_scene(path, i, n, sc, heading, repo=None, caption=None):
    """A chain of nodes with one lit up, the step's headline, and the real file:line."""
    s = canvas()
    y = bt.header(sc.get("kicker", ""), sc["title"], size=26, y=bt.PAD_TOP)
    nodes, act, gap = sc["nodes"], sc["active"], 22
    w = (bt.CW - gap * (len(nodes) - 1)) / len(nodes)
    y += 14
    for k, node in enumerate(nodes):
        name, _, sub = node.partition("|")
        x = bt.PAD_X + k * (w + gap)
        if k == act:
            bt.rect(x, y, w, 58, bt.Y)
            bt.frame(x, y, w, 58, 2.5, bt.K)
        elif k < act:
            bt.rect(x, y, w, 58, bt.K)
        else:
            bt.rect(x, y, w, 58, bt.WHITE)
            bt.frame(x, y, w, 58, 1.5, bt.K)
        fg = bt.WHITE if k < act else bt.K if k == act else bt.G
        bt.text(x + w / 2, y + 8, fit(name, w - 10, 10.5, True), 10.5, True, fg, lh=22, anchor="c")
        bt.text(x + w / 2, y + 30, fit(sub.upper(), w - 10, 7.5, True), 7.5, True,
                bt.Y if k < act else bt.K if k == act else bt.G, ls=0.1, lh=18, anchor="c")
        if k < len(nodes) - 1:  # arrow to the next node
            ax, ay = x + w + 3, y + 29
            bt.c.set_source_rgb(*bt.K)
            bt.c.set_line_width(2)
            bt.c.move_to(ax, ay)
            bt.c.line_to(ax + gap - 9, ay)
            bt.c.stroke()
            bt.c.move_to(ax + gap - 4, ay)
            bt.c.line_to(ax + gap - 11, ay - 5)
            bt.c.line_to(ax + gap - 11, ay + 5)
            bt.c.fill()
    y += 58 + 38
    y += bt.para(bt.PAD_X, y, bt.CW, sc["point"], 22, 1.3, color=bt.K, bold=True) + 22
    refs_box(y, sc["refs"], repo)
    finish(path, s, i, n, heading, caption)


# ---------- storyboard -> scenes -> video ----------
def story_scenes(sb, repo):
    """storyboard dict -> [(draw(png_path, caption), narration)]. A points scene whose `say` is a list becomes
    one sub-scene per bullet, revealing the bullets as they are spoken."""
    sc, n, out = sb["scenes"], len(sb["scenes"]), []
    for i, x in enumerate(sc, 1):
        if x["kind"] == "cover":
            out.append((lambda p, c=None, x=x: cover(p, sb["title"], x["meta"], n, c), x["say"]))
        elif x["kind"] == "flow":
            out.append((lambda p, c=None, i=i, x=x: flow_scene(p, i, n, x, sb["title"], repo, c), x["say"]))
        else:
            says = x["say"] if isinstance(x["say"], list) else [x["say"]]
            steps = range(1, len(x["points"]) + 1) if len(says) > 1 else [len(x["points"])]
            for k, say in zip(steps, says):
                out.append((lambda p, c=None, i=i, x=x, k=k: points_slide(p, i, n, x["title"], x["points"][:k], sb["title"], c), say))
    return out


def ffmpeg(*args):
    subprocess.run([ffmpeg_exe(), "-y", "-loglevel", "error", *args], check=True)


def build(scenes, out, captions=True):
    from piper import PiperVoice  # imported late so tests and --doctor work without it
    voice = PiperVoice.load(str(VOICES / f"{VOICE_NAME}.onnx"))
    pieces = [(draw, part) for draw, say in scenes for part in chunks(say)]  # one clip per sentence
    with tempfile.TemporaryDirectory() as td:
        td, clips = Path(td), []
        for i, (draw, part) in enumerate(pieces, 1):
            png, wav, mp4 = td / f"{i}.png", td / f"{i}.wav", td / f"{i}.mp4"
            draw(png, caption_text(part) if captions else None)
            with wave.open(str(wav), "wb") as wf:
                voice.synthesize_wav(part, wf)
            # 44.1k stereo AAC: 22.05k mono (Piper's native) plays silent in VS Code/Electron previews
            ffmpeg("-loop", "1", "-i", str(png), "-i", str(wav), "-c:v", "libx264", "-tune", "stillimage",
                   "-c:a", "aac", "-ar", "44100", "-ac", "2", "-pix_fmt", "yuv420p", "-r", "24",
                   "-shortest", str(mp4))
            clips.append(mp4)
        lst = td / "list.txt"
        lst.write_text("".join(f"file '{p.as_posix()}'\n" for p in clips))
        ffmpeg("-f", "concat", "-safe", "0", "-i", str(lst), "-c", "copy", "-movflags", "+faststart", str(out))


def check(out, lo=20, hi=MAX_S):
    """Fail if the MP4 lacks audio/video, is silent, or is outside [lo, hi] seconds. Uses ffmpeg only (ffprobe
    is not shipped with the bundled copy)."""
    info = subprocess.run([ffmpeg_exe(), "-hide_banner", "-i", str(out), "-af", "volumedetect", "-vn", "-f", "null", "-"],
                          capture_output=True, text=True).stderr
    t = re.search(r"Duration: (\d+):(\d+):([\d.]+)", info)
    assert t, "ffmpeg could not read the file"
    dur = int(t[1]) * 3600 + int(t[2]) * 60 + float(t[3])
    assert re.search(r"Stream #\S+: Video:", info) and re.search(r"Stream #\S+: Audio:", info), "missing audio or video stream"
    assert float(re.search(r"mean_volume: (-?[\d.]+)", info).group(1)) > -40, "audio is silent"
    assert lo <= dur <= hi, f"duration {dur:.0f}s outside {lo}-{hi}s"
    return dur


def render(d, out=None, repo=None, captions=True):
    """onboarding/<slug> -> names(d)["mp4"] (<company>-onboarding-<slug>-tour.mp4). Returns the output path."""
    d = Path(d)
    sb_file = d / "storyboard.json"
    if not sb_file.is_file():
        sys.exit(f"no {sb_file}: Bob writes it at stage 2 (see templates.md). Nothing to render.")
    if (m := missing()):
        sys.exit("Video step is not ready:\n  " + "\n  ".join(m) + "\nSkip the video (send without it) or fix the above.")
    info = load_flat(d / "intake.yaml") if (d / "intake.yaml").is_file() else {}
    repo = Path(repo or info.get("codebase_path", "")).resolve()
    if problems := check_storyboard(d, repo):
        sys.exit("storyboard problems (fix storyboard.json, then re-run):\n  " + "\n  ".join(problems))
    out = Path(out or names(d)["mp4"])
    build(story_scenes(json.loads(sb_file.read_text(encoding="utf-8")), repo), out, captions)
    return out


def self_test():
    """Drawing and safety rules always; a full render only if piper + ffmpeg + the voice are present."""
    fx = HERE / "fixtures"
    with tempfile.TemporaryDirectory() as td:
        td = Path(td)
        repo = (td / "repo").resolve()
        (repo / "util").mkdir(parents=True)
        (repo / "util/ConnectionDB.java").write_text(
            'class C {\n  static final String URL = "jdbc:postgresql://h:5432/db";\n'
            '  static final String USER = "postgres.abc";\n  static final String PASSWORD = "hunter2";\n'
            '  int ok = 1;\n}\n')
        (repo / ".env").write_text('API_KEY="abc"\n')
        ex = excerpt(repo, "util/ConnectionDB.java:5", 3)
        txt = "\n".join(t for _, t, _ in ex)
        assert "hunter2" not in txt and "jdbc:" not in txt and "postgres.abc" not in txt, "secret leaked"
        assert [k for k, _, hit in ex if hit] == [5], "exactly the cited line must be marked"
        assert excerpt(repo, ".env:1", 1) is None, "secret file excerpted"
        assert excerpt(repo, "../../../../etc/passwd:1", 1) is None, "path traversal"
        assert excerpt(repo, "util/ConnectionDB.java:99", 1) is None, "line out of range"
        assert excerpt(None, "a.py:1", 1) is None, "no repo must fall back"

        assert " ".join(chunks("One. Two, three, four.")) == "One. Two, three, four."
        long_say = "Word, " * 60 + "end."
        assert all(len(p) <= MAX_CAPTION + 10 for p in chunks(long_say)), "caption pieces too long"
        assert caption_text("queries D A O and J S P, plus A B") == "queries DAO and JSP, plus A B"

        # every scene kind draws, with and without a caption, inside the layout limits
        sb = json.loads((fx / "sample" / "storyboard.json").read_text(encoding="utf-8"))
        scenes = story_scenes(sb, (fx / "repo").resolve())
        assert len(scenes) > len(sb["scenes"]), "points scenes with a say list must split into sub-scenes"
        for k, (draw, say) in enumerate(scenes):
            for cap in (None, caption_text(chunks(say)[0])):
                p = td / f"s{k}.png"
                draw(p, cap)
                assert p.stat().st_size > 2000, f"scene {k} did not draw"

        missing_deps = missing()
        if missing_deps:
            print("WARNING: video render test skipped:", "; ".join(missing_deps))
            print("video self-check ok (drawing only)")
            return
        import shutil
        d = td / "sample"
        shutil.copytree(fx / "sample", d)
        out = render(d, repo=fx / "repo")
        assert out.name == "northwind-labs-onboarding-sample-tour.mp4" and check(out, lo=10) > 10
    print("video self-check ok")


if __name__ == "__main__":
    a = sys.argv[1:]
    args = [x for x in a if not x.startswith("--")]
    if "--setup" in a:
        setup()
    elif "--doctor" in a:
        m = missing()
        print("\n".join(m) if m else "OK")
        sys.exit(1 if m else 0)
    elif not args:
        sys.exit(__doc__)
    else:
        repo = a[a.index("--repo") + 1] if "--repo" in a else None
        if repo:
            args.remove(repo)
        out = render(args[0], args[1] if len(args) > 1 else None, repo, "--no-captions" not in a)
        print(f"wrote {out}" + (f" ({check(out):.0f}s, OK)" if "--check" in a else ""))
