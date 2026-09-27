#!/usr/bin/env python3
"""Deterministic helpers for the onboarding pipeline (stdlib only).

  timeline <start> <end>            markdown phase table with real dates
  log <dir> <stage> start|end       append a timestamp to <dir>/run-log.md
  check <dir> <repo>                verify citations + issue files + storyboard.json (prints OK or problems)
  slug "<text>" [--email E]         deterministic ASCII file-safe slug (person names; collision-safe with --email)
  names <dir>                       the exact output file names for a run (pdf, zip, mp4)
  guide <dir>                       write the newcomer's start guide: context/README.md + email-newcomer.md (deterministic)
  fix <dir>                         mechanical repairs, no LLM: rebuild issue INDEX, sync storyboard title, copy install_deps.py
  guard <dir> <stage> [--ok]        fix-loop budget: reads the failing output on stdin, prints RETRY k/3 or STOP (exit 1); --ok resets
  deliverables <dir>                list what the newcomer's email must carry (pdf, zip, mp4 if video: yes); exit 1 if one is missing/oversized
  bundle <dir>                      zip <dir>/context -> the names' zip
  check-mcp [--fix]                 preflight: email MCP server built, registered in .bob/mcp.json, deps, creds
"""
import datetime as dt
import hashlib
import json
import os
import re
import sys
import unicodedata
import zipfile
from pathlib import Path

MCP_NAME = "onboarding-mail"
MCP_SERVER = Path("mcp/onboarding-mail/server.py")
SMTP_KEYS = ("SMTP_HOST", "SMTP_PORT", "SMTP_USER", "SMTP_PASS")

PHASES = [(1, 7, "Setup and comprehension"), (8, 30, "First contributions"),
          (31, 60, "Ownership"), (61, 90, "Independence")]
ISSUE_HEADINGS = ["Summary", "Why it happens", "Impact", "Guidance to solve", "How to verify"]
WORDS_PER_SEC = 2.6  # conservative: Piper measured ~2.9 including the gaps between sentences
VIDEO_MAX_S = 170  # narration budget; the submission cap is 180s
TEXT_REF = re.compile(r"[\w./\\-]+\.[A-Za-z0-9]+:\d+")
CITE = re.compile(r"`([A-Za-z0-9_./\\-]+\.[A-Za-z0-9]+)(?::(\d+)(?:-(\d+))?)?`")


def load_flat(path):
    """Flat `key: value  # comment` file -> dict. Enough for intake.yaml (no PyYAML)."""
    out = {}
    for ln in Path(path).read_text(encoding="utf-8").splitlines():
        ln = ln.split(" #")[0].strip()
        if ln and not ln.startswith("#") and ":" in ln:
            k, v = ln.split(":", 1)
            out[k.strip()] = v.strip().strip("\"'")
    return out


WIN_RESERVED = {"con", "prn", "aux", "nul", *(f"com{i}" for i in range(1, 10)), *(f"lpt{i}" for i in range(1, 10))}
ISSUE_FILE = re.compile(r"ISSUE-(\d{3})-[a-z0-9]+(?:-[a-z0-9]+)*\.md")


def slugify(text, limit=40):
    """Accents folded to ASCII, lowercase, every other run of characters -> one '-'. May be '' (e.g. Chinese)."""
    t = unicodedata.normalize("NFKD", str(text)).encode("ascii", "ignore").decode()
    return re.sub(r"[^a-z0-9]+", "-", t.lower()).strip("-")[:limit].strip("-")


def slug(name, root="onboarding", email=None):
    """Folder/file slug for a person. Deterministic (the LLM never invents one); safe on Windows and in URLs;
    never contains '/', '.' or spaces. Names with no Latin letters fall back to hire-<hash>. With `email`,
    an existing run for a DIFFERENT email gets a -2, -3 suffix so two 'Alex Tan' never overwrite each other."""
    base = slugify(name) or "hire-" + hashlib.sha1(str(name).strip().lower().encode()).hexdigest()[:6]
    if base in WIN_RESERVED:
        base += "-hire"
    cand, n = base, 2
    while email and (f := Path(root) / cand / "intake.yaml").is_file() \
            and load_flat(f).get("email", "").lower() != email.lower():
        cand, n = f"{base}-{n}", n + 1
    return cand


def names(d):
    """The one place output file names come from. <company>-onboarding-<slug>[-context|-tour].<ext>, so the
    newcomer's attachments say what they are (a file called alex-tan.pdf says nothing in an inbox)."""
    d = Path(d)
    info = load_flat(d / "intake.yaml") if (d / "intake.yaml").is_file() else {}
    co = slugify(info.get("company", ""), 30)
    base = f"{co}-onboarding-{d.resolve().name}" if co else f"onboarding-{d.resolve().name}"
    return {"base": base, "pdf": d / f"{base}.pdf", "zip": d / f"{base}-context.zip", "mp4": d / f"{base}-tour.mp4"}


CONTEXT_FILES = {
    "AGENTS.md": "the instructions Bob reads first: who you are, the rules, where things are",
    "company.md": "what the company does and how it works",
    "role.md": "your role and what success looks like in 30 days",
    "timeline.md": "your dates, starter tasks and week-1 checkpoints",
    "architecture.md": "how the system is built, one request end to end, and the code tour",
    "tech-stack.md": "what the project needs installed, and why",
    "issues/INDEX.md": "the known problems, one line each",
    "scripts/install_deps.py": "installs the project's declared dependencies (no sudo)",
}
MAX_FIXES = 3  # fix attempts per stage before the loop stops and asks the human (Bobcoins are capped, no top-ups)
MAX_ATTACH_MB = 20  # most mail servers refuse more; the video is ~3-5 MB


def deliverables(d):
    """What the newcomer's email carries: (lines to show, problems). The MP4 is required only when intake says
    `video: yes` (the default), so a failed video render is a loud problem, never a silent omission."""
    d = Path(d)
    info = load_flat(d / "intake.yaml") if (d / "intake.yaml").is_file() else {}
    want_video = info.get("video", "yes").lower() != "no"
    n, lines, problems = names(d), [], []
    for kind, required in (("pdf", True), ("zip", True), ("mp4", want_video)):
        f = n[kind]
        if not f.is_file():
            (problems if required else lines).append(
                f"{'MISSING' if required else 'skipped (video: no)'} {kind}: {f.as_posix()}")
        elif f.stat().st_size > MAX_ATTACH_MB * 1024 * 1024:
            problems.append(f"TOO BIG {kind}: {f.as_posix()} is {f.stat().st_size / 1048576:.0f} MB (limit {MAX_ATTACH_MB} MB)")
        else:
            lines.append(f"attach {kind}: {f.as_posix()} ({f.stat().st_size / 1048576:.1f} MB)")
    body = d / "email-newcomer.md"
    if body.is_file():
        lines.append(f"body: {body.as_posix()}")
    else:
        problems.append(f"MISSING body: {body.as_posix()} (run: pipeline_tools.py guide)")
    return lines, problems


def guide(d):
    """The newcomer's start guide, generated (never LLM-written, so Bob IDE steps cannot be invented):
    context/README.md (goes in the zip) and email-newcomer.md (the email body). Run AFTER the PDF, video and
    context are final: the file list and the video paragraph reflect what actually exists. No inline
    backticks on purpose, so `check` does not read paths in here as repo citations. Returns the two paths."""
    d = Path(d)
    info = load_flat(d / "intake.yaml") if (d / "intake.yaml").is_file() else {}
    n = names(d)
    first = (info.get("name", "").split() or ["there"])[0]
    company = info.get("company", "the team")
    who = info.get("buddy") or info.get("manager") or "your manager"
    if who.lower().startswith("not specified"):
        who = info.get("manager") if info.get("manager") and not info["manager"].lower().startswith("not specified") else "your manager"
    mgr_raw = info.get("manager", "")
    mgr = mgr_raw if mgr_raw and not mgr_raw.lower().startswith("not specified") else ""
    # Build "If you get stuck" contact line: buddy and/or manager
    if who != mgr and mgr:
        stuck_contacts = f"{who} (buddy) or {mgr} (manager)"
    else:
        stuck_contacts = who
    start = info.get("start_date", "")
    pdf = n["pdf"].name if n["pdf"].is_file() else "pack.md"
    video = n["mp4"].name if n["mp4"].is_file() else None
    ws = "onboarding-workspace"
    rows = [f"1. {pdf}: your onboarding pack. Read this first (about 20 minutes): the company, your role, the codebase, your first tasks and your first week."]
    if video:
        rows.append(f"{len(rows) + 1}. {video}: a short narrated video tour of the codebase, with captions. Watch it after the PDF and before you open the code.")
    rows.append(f"{len(rows) + 1}. {n['zip'].name}: the context for Bob IDE (your personal AI assistant for this codebase). Do not read it by hand: load it into Bob with the steps below.")
    repo, pdir = info.get("repo_url", ""), info.get("project_dir", "") or "project"
    if repo:
        get_code = (f"Get the code: run: git clone {repo} — or open that URL in a browser, click the green Code button, and choose Download ZIP. "
                    f"Either way, put the {pdir} folder inside {ws}/ so you have {ws}/{pdir}/. If you cannot access the repo, ask {who}.")
    else:
        get_code = f"Get the code: ask {who} for the repository address and put the project folder inside {ws}/ so you have {ws}/{pdir}/."
    open_code = f"In Bob IDE choose File, Open Folder and pick {ws}/{pdir}. If Bob asks whether you trust the authors, choose Yes."
    steps = [
        "Install Bob IDE from https://bob.ibm.com/download and sign in. Your account is arranged on day 1: see \"Day-1 accounts & access\" in the PDF.",
        f"Create a folder called {ws}. Unzip the context zip into it (Windows: right-click, Extract All) so you have {ws}/context/.",
        get_code,
        open_code,
        f"Copy context/AGENTS.md up one level to {ws}/AGENTS.md. Bob loads an AGENTS.md at the workspace root into every new conversation automatically; inside context/ it would not be loaded.",
        "Open Bob's chat (Ctrl+Alt+B on Windows, Option+Cmd+B on Mac, or the Bob icon), start a new conversation with the plus sign, and send: Read @/context/README.md and help me finish the setup.",
        f"If you get stuck at any point, {stuck_contacts} is your first point of contact for setup problems.",
    ]
    listing, seen, ctx = [], set(), d / "context"
    for f in sorted(ctx.rglob("*")) if ctx.is_dir() else []:
        rel = f.relative_to(ctx).as_posix()
        if not f.is_file() or rel == "README.md":
            continue
        if rel.startswith("issues/ISSUE-"):
            if "issues" not in seen:
                seen.add("issues")
                cnt = len(list((ctx / "issues").glob("ISSUE-*.md")))
                listing.append(f"- issues/ISSUE-NNN-*.md ({cnt} file{"" if cnt == 1 else "s"}): one known problem each, with evidence, guidance to solve it and how to verify it")
        else:
            listing.append(f"- {rel}: {CONTEXT_FILES.get(rel, 'supporting material')}")
    readme = (
        f"# Start here, {first}\n\nYou received these files. Do them in this order (roughly 30 minutes):\n\n"
        + "\n".join(rows)
        + "\n\n## Set up Bob IDE with this folder\n\n"
        + "\n".join(f"{i}. {t}" for i, t in enumerate(steps, 1))
        + "\n\nTo install the project's dependencies, ask Bob to run this (it only reads the manifest and installs, no sudo):\n\n"
        "```\npython context/scripts/install_deps.py <path to your clone> --check\n```\n\n"
        "Drop --check to install for real. On Windows use py instead of python if python is not found.\n\n"
        "## How to work with Bob here\n\n"
        "- Ask mode is read-only: use it to explore. Agent mode can change files and run commands, always asking first: approve only what you understand, and keep auto-approve off while you learn.\n"
        "- Point Bob at files with @, for example @/context/architecture.md. Avoid mentioning whole folders: it is slower and costs more.\n"
        "- Good first questions: Walk me through the code tour in @/context/architecture.md. Which issue should I start with, and why? What do I need to know before I touch the data layer?\n"
        f"- Bob only knows what is in these files. Where they say \"Unknown — ask your buddy\", ask {who}. Never paste passwords or keys into a chat.\n\n"
        "## What is in this folder\n\n" + "\n".join(listing) + "\n")
    # Email is a short cover note: greeting, attachments, first 3 actions, pointer to README.
    # The full setup steps live in context/README.md only — not duplicated in the email.
    email = (
        f"Hi {first},\n\nWelcome to {company}. Everything for your first week is attached:\n\n" + "\n".join(rows)
        + "\n\nTo get started:\n\n" + "\n".join(f"{i}. {t}" for i, t in enumerate(steps[:3], 1))
        + f"\n\nThe full setup guide (all steps, plus how to work with Bob) is in context/README.md inside the zip. Stuck? Reply to this email: it reaches {who}."
        + (f"\n\nSee you on {start}." if start else "") + "\n")
    ctx.mkdir(parents=True, exist_ok=True)
    (ctx / "README.md").write_text(readme, encoding="utf-8")
    (d / "email-newcomer.md").write_text(email, encoding="utf-8")
    return ctx / "README.md", d / "email-newcomer.md"


def _issue_row(f):
    t = f.read_text(encoding="utf-8")
    num = re.match(r"#\s*(ISSUE-\d{3})\s*:\s*(.+)", t)
    pick = lambda pat: (re.search(pat, t, re.M | re.I) or [None, "?"])[1].strip()
    return (f"| [{num[1] if num else f.stem}]({f.name}) | {num[2].strip() if num else f.stem} | {pick(r'Severity:\s*(\w+)')} "
            f"| {pick(r'Category:\s*(\w+)')} | {pick(r'^Location:\s*(.+)$')} | {pick(r'^Suggested timeline:\s*(.+)$')} |")


def fix(d):
    """Mechanical repairs that need no judgement, so the fix loop spends no Bobcoins on them. Idempotent.
    Returns what it changed. Never touches the wording of content Bob or a human wrote."""
    d, done = Path(d), []
    idir = d / "context" / "issues"
    files = sorted(idir.glob("ISSUE-*.md")) if idir.is_dir() else []
    index = idir / "INDEX.md"
    if files:  # INDEX is derived data: always regenerate, so it can never go stale after an issue file is edited
        head = "# Issues\n| ID | Title | Severity | Category | Location | Timeline |\n|---|---|---|---|---|---|\n"
        want = head + "\n".join(_issue_row(f) for f in files) + "\n"
        if not index.is_file() or index.read_text(encoding="utf-8") != want:
            index.write_text(want, encoding="utf-8")
            done.append("rebuilt context/issues/INDEX.md from the issue files")
    sb, pack = d / "storyboard.json", d / "pack.md"
    if sb.is_file() and pack.is_file():
        h1 = next((ln[2:].strip() for ln in pack.read_text(encoding="utf-8").splitlines() if ln.startswith("# ")), "")
        try:
            data = json.loads(sb.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            data = None
        if isinstance(data, dict) and h1 and data.get("title") != h1:
            data["title"] = h1
            sb.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
            done.append("storyboard.json title set to pack.md's H1")
    dep = d / "context" / "scripts" / "install_deps.py"
    if (d / "context").is_dir() and not dep.exists():
        dep.parent.mkdir(parents=True, exist_ok=True)
        dep.write_bytes((Path(__file__).parent / "install_deps.py").read_bytes())
        done.append("copied install_deps.py into context/scripts/")
    return done


def guard(d, stage, problems=None, mx=MAX_FIXES):
    """Bounded fix loop. Call after each failure of `stage` with its output; call with problems=None on success
    to reset. Returns (may_retry, message). Stops when the budget is spent OR the same problems come back
    (a fix that changed nothing will not work on attempt 3 either)."""
    f = Path(d) / "attempts.json"
    st = json.loads(f.read_text(encoding="utf-8")) if f.is_file() else {}
    if problems is None:
        st.pop(stage, None)
        f.write_text(json.dumps(st, indent=2), encoding="utf-8")
        return True, f"OK {stage}"
    fp = hashlib.sha1("\n".join(sorted(x.strip() for x in problems.splitlines() if x.strip())).encode()).hexdigest()[:12]
    rec = st.setdefault(stage, {"failures": 0, "seen": []})
    rec["failures"] += 1
    stuck = fp in rec["seen"]
    rec["seen"].append(fp)
    f.write_text(json.dumps(st, indent=2), encoding="utf-8")
    log(d, f"{stage} fix-loop", f"failure {rec['failures']}")
    if stuck:
        return False, f"STOP {stage}: the same problems came back after a fix attempt (nothing improved). Ask the user."
    if rec["failures"] > mx:
        return False, f"STOP {stage}: {mx} fix attempts used and it still fails. Ask the user."
    return True, f"RETRY {stage}: fix attempt {rec['failures']} of {mx}"


def timeline(start, end):
    s, e = dt.date.fromisoformat(start), dt.date.fromisoformat(end)
    assert e > s, "end date must be after start date"
    rows = []
    for i, (a, b, goal) in enumerate(PHASES):
        ps = s + dt.timedelta(days=a - 1)
        if ps > e:
            break
        last = i == len(PHASES) - 1 or s + dt.timedelta(days=PHASES[i + 1][0] - 1) > e
        pe = e if last else s + dt.timedelta(days=b - 1)
        rows.append((goal, ps, min(pe, e)))
    lines = ["| Phase | Start | End | Goal |", "|---|---|---|---|"]
    for n, (goal, ps, pe) in enumerate(rows, 1):
        lines.append(f"| {n} | {ps} | {pe} | {goal} |")
    return "\n".join(lines)


def log(d, stage, event):
    p = Path(d) / "run-log.md"
    p.parent.mkdir(parents=True, exist_ok=True)
    if not p.exists():
        p.write_text("# Run log\n\n| Time | Stage | Event |\n|---|---|---|\n", encoding="utf-8")
    with p.open("a", encoding="utf-8") as f:
        f.write(f"| {dt.datetime.now().isoformat(timespec='seconds')} | {stage} | {event} |\n")


def check(d, repo):
    d, repo = Path(d), Path(repo)
    problems = []
    for md in sorted(d.rglob("*.md")):
        if md.name == "run-log.md":
            continue
        for m in CITE.finditer(md.read_text(encoding="utf-8")):
            rel, a, b = m.groups()
            f = repo / rel
            if not f.is_file():
                if (d / rel).exists() or (d / "context" / rel).exists() or (d.parent.parent / rel).exists():
                    continue  # bundle/workspace file, not a repo citation
                problems.append(f"MISSING {rel} (in {md.name})")
                continue
            line = int(b or a or 1)
            n = sum(1 for _ in f.open("rb"))
            if line > n:
                problems.append(f"LINE {rel}:{line} > {n} lines (in {md.name})")
    idir = d / "context" / "issues"
    files = sorted(idir.glob("ISSUE-*.md"))
    index = idir / "INDEX.md"
    if not index.exists():
        problems.append("MISSING issues/INDEX.md")
    nums = []
    for f in files:
        t = f.read_text(encoding="utf-8")
        m = ISSUE_FILE.fullmatch(f.name)
        if not m:
            problems.append(f"{f.name}: file name must be ISSUE-NNN-<lowercase-slug>.md (python scripts/pipeline_tools.py slug \"<title>\")")
        else:
            nums.append(int(m[1]))
            head = re.match(r"#\s*ISSUE-(\d{3})\b", t)
            if not head or head[1] != m[1]:
                problems.append(f"{f.name}: first line must be '# ISSUE-{m[1]}: <title>'")
        for h in ISSUE_HEADINGS:
            if not re.search(rf"^##\s+{re.escape(h)}\s*$", t, re.M):
                problems.append(f"{f.name}: missing '## {h}'")
        for k in ("Severity:", "Location:", "Suggested timeline:"):
            if k not in t:
                problems.append(f"{f.name}: missing '{k}'")
        if index.exists() and f.name not in index.read_text(encoding="utf-8"):
            problems.append(f"{f.name}: not listed in INDEX.md")
    if nums != list(range(1, len(nums) + 1)):
        problems.append(f"issue numbers must run 001..{len(nums):03d} with no gaps or repeats (got {sorted(nums)})")
    if (d / "intake.yaml").exists():
        mx = int(load_flat(d / "intake.yaml").get("max_issues", 10))
        if len(files) > mx:
            problems.append(f"{len(files)} issues > max_issues {mx}")
    return problems + check_storyboard(d, repo)


def _say_lines(sc):
    say = sc.get("say", "")
    return [str(x) for x in (say if isinstance(say, list) else [say])]


def check_storyboard(d, repo):
    """Validate <d>/storyboard.json (the video script Bob writes at stage 2). [] if fine or absent.
    Schema, cover title == pack.md H1, every structured flow ref exists in the repo AND in pack.md,
    any file:line typed in free text appears in pack.md, no emails/urls/ISO dates in the narration,
    narration length within budget. Stdlib only, so it runs without the video dependencies."""
    d, repo = Path(d), Path(repo)
    f = d / "storyboard.json"
    if not f.is_file():
        return []
    try:
        sb = json.loads(f.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        return [f"storyboard.json: BAD JSON {e}"]
    if not (isinstance(sb, dict) and isinstance(sb.get("title"), str) and isinstance(sb.get("scenes"), list)):
        return ["storyboard.json: needs 'title' (string) and 'scenes' (list)"]
    P = []

    def bad(m):
        P.append(f"storyboard.json: {m}")

    scenes = sb["scenes"]
    if not 4 <= len(scenes) <= 16:
        bad(f"{len(scenes)} scenes; use 4-16")
    n_flow = sum(1 for sc in scenes if sc.get("kind") == "flow")
    n_points = sum(1 for sc in scenes if sc.get("kind") == "points")
    if n_flow < 3:
        bad(f"only {n_flow} flow scene(s); need at least 3 — the video must show the request flow, not just restate facts")
    if n_points > 3:
        bad(f"{n_points} points scene(s); cap is 3 — use flow scenes for procedure, points scenes for context only")
    pack = (d / "pack.md").read_text(encoding="utf-8") if (d / "pack.md").is_file() else None
    if pack is None:
        bad("pack.md must sit next to storyboard.json")
    else:
        h1 = next((ln[2:].strip() for ln in pack.splitlines() if ln.startswith("# ")), "")
        if sb["title"] != h1:
            bad(f"title {sb['title']!r} must equal pack.md's H1 {h1!r}")
    words, flow_refs = 0, []
    for n, sc in enumerate(scenes, 1):
        tag = f"scene {n}"
        if not isinstance(sc, dict) or sc.get("kind") not in ("cover", "points", "flow"):
            bad(f"{tag}: kind must be cover|points|flow")
            continue
        kind = sc["kind"]
        if (n == 1) != (kind == "cover"):
            bad(f"{tag}: exactly scene 1 is the cover")
        if kind == "cover" and not (isinstance(sc.get("meta"), list) and all(isinstance(x, str) for x in sc["meta"])):
            bad(f"{tag}: cover needs meta (list of strings)")
        if kind == "points":
            pts = sc.get("points")
            if not (isinstance(sc.get("title"), str) and isinstance(pts, list) and 1 <= len(pts) <= 6
                    and all(isinstance(x, str) and x for x in pts)):
                bad(f"{tag}: points needs a title and 1-6 non-empty bullets")
                continue
            if any(len(x) > 90 for x in pts):
                bad(f"{tag}: a bullet is over 90 characters (slides show keywords; the voice says the rest)")
            if isinstance(sc.get("say"), list) and len(sc["say"]) != len(pts):
                bad(f"{tag}: 'say' as a list needs one line per bullet ({len(pts)})")
            # Redundancy check: flag bullets whose key words are mostly repeated in their say line.
            if isinstance(sc.get("say"), list) and len(sc["say"]) == len(pts):
                for bi, (pt, sy) in enumerate(zip(pts, sc["say"]), 1):
                    pt_words = {w.lower().strip(".,;:()[]\"'") for w in pt.split() if len(w) > 3}
                    sy_words = {w.lower().strip(".,;:()[]\"'") for w in sy.split() if len(w) > 3}
                    if pt_words and sy_words and len(pt_words & sy_words) / len(pt_words) >= 0.8:
                        bad(f"{tag} bullet {bi}: on-screen text and narration are mostly identical — "
                            "slides show keywords; the voice adds context")
        if kind == "flow":
            nodes, act, refs = sc.get("nodes"), sc.get("active"), sc.get("refs")
            if not (isinstance(sc.get("title"), str) and isinstance(nodes, list) and 2 <= len(nodes) <= 6
                    and all(isinstance(x, str) for x in nodes)):
                bad(f"{tag}: flow needs a title and 2-6 nodes ('Name|layer')")
            elif not (isinstance(act, int) and not isinstance(act, bool) and 0 <= act < len(nodes)):
                bad(f"{tag}: 'active' must be an index into nodes")
            if not (isinstance(sc.get("point"), str) and 0 < len(sc["point"]) <= 110):
                bad(f"{tag}: 'point' is required, at most 110 characters")
            if isinstance(refs, list) and 1 <= len(refs) <= 3 and all(isinstance(x, str) for x in refs):
                flow_refs += [(n, r) for r in refs]
            else:
                bad(f"{tag}: 'refs' must be 1-3 'path:line' strings")
        lines = _say_lines(sc)
        if not all(x.strip() for x in lines):
            bad(f"{tag}: 'say' must be non-empty text")
        words += sum(len(x.split()) for x in lines)
        for x in lines:
            if "@" in x or re.search(r"https?://|www\.", x):
                bad(f"{tag}: no emails or URLs in the narration (never spoken, never invented)")
            if re.search(r"\d{4}-\d{2}-\d{2}", x):
                bad(f"{tag}: no ISO dates in the narration (spoken badly); say 'week two', 'day five'")
    est = words / WORDS_PER_SEC
    if est > VIDEO_MAX_S:
        bad(f"narration is about {est:.0f}s ({words} words), over {VIDEO_MAX_S}s: cut to roughly 300 words")
    if flow_refs and not repo.is_dir():
        bad(f"repo not found: {repo}")
        flow_refs = []
    for n, r in flow_refs:  # structured refs: must be real in the repo, and cited in the pack
        rel, _, ln = r.rpartition(":")
        rp = Path(rel)
        if not ln.isdigit() or rp.is_absolute() or ".." in rp.parts:
            bad(f"scene {n}: '{r}' is not a repo-relative path:line")
        elif not (repo / rp).is_file():
            bad(f"scene {n}: MISSING {rel} in the repo")
        elif int(ln) > sum(1 for _ in (repo / rp).open("rb")):
            bad(f"scene {n}: LINE {r} is past the end of the file")
        elif pack is not None and r not in pack:
            bad(f"scene {n}: {r} is not cited in pack.md (do not invent references)")
    if pack is not None:  # free-text path:line mentions must also come from the pack
        for r in sorted(set(TEXT_REF.findall(json.dumps(sb))) - {r for _, r in flow_refs}):
            if r not in pack:
                bad(f"'{r}' appears in the text but not in pack.md")
    return P


def bundle(d):
    d = Path(d)
    out = names(d)["zip"]
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
        for f in sorted((d / "context").rglob("*")):
            if f.is_file():
                z.write(f, Path("context") / f.relative_to(d / "context"))
    return out


def _smtp_ready(ws):
    """True if all SMTP_* are set in the environment or the workspace .env (KEY=VALUE)."""
    env = dict(os.environ)
    f = Path(ws) / ".env"
    if f.is_file():
        for ln in f.read_text(encoding="utf-8").splitlines():
            k, eq, v = ln.partition("=")
            if eq and not ln.lstrip().startswith("#"):
                env[k.strip()] = v.strip().strip("\"'")
    return all(env.get(k) for k in SMTP_KEYS)


def check_mcp(ws, fix=False):
    """Preflight for the email MCP server; [] = ready. fix=True registers it in .bob/mcp.json
    (absolute paths, so the file is per-machine) and installs the server's deps.
    No SMTP creds -> registered with --dry-run (emails logged, not sent). Never touches creds."""
    ws = Path(ws).resolve()
    server = ws / MCP_SERVER
    if not server.is_file():
        return [f"NOT BUILT {MCP_SERVER.as_posix()}: run BOB_PROMPTS step 4 (Bob builds it); stage 7 cannot send until then"]
    cfg_path = ws / ".bob" / "mcp.json"
    try:
        cfg = json.loads(cfg_path.read_text(encoding="utf-8")) if cfg_path.is_file() else {}
    except json.JSONDecodeError as e:
        return [f"BAD JSON {cfg_path}: {e} (not overwritten, fix by hand)"]
    creds = _smtp_ready(ws)
    want = {"command": sys.executable, "args": [str(server)] + ([] if creds else ["--dry-run"]),
            "cwd": str(ws), "alwaysAllow": [], "disabled": False}
    have = cfg.get("mcpServers", {}).get(MCP_NAME, {})
    problems = []
    if any(have.get(k) != want[k] for k in ("command", "args", "cwd")) or have.get("disabled", False):
        if fix:
            cfg.setdefault("mcpServers", {})[MCP_NAME] = {**have, **want}
            cfg_path.parent.mkdir(exist_ok=True)
            cfg_path.write_text(json.dumps(cfg, indent=2) + "\n", encoding="utf-8")
            print(f"registered '{MCP_NAME}' in {cfg_path}" + ("" if creds else " (--dry-run: no SMTP_* in .env/env)"))
        else:
            problems.append(f"NOT REGISTERED (or outdated) '{MCP_NAME}' in .bob/mcp.json: run check-mcp --fix")
    d = server.parent
    if any(d.glob("requirements*.txt")) or (d / "package.json").is_file():
        import install_deps
        if install_deps.main(d, check_only=not fix):
            problems.append(f"DEPS missing for {d.name}: python scripts/install_deps.py {d.relative_to(ws).as_posix()}")
    return problems


def _mcp_self_test():
    import tempfile
    saved = {k: os.environ.pop(k, None) for k in SMTP_KEYS}
    try:
        with tempfile.TemporaryDirectory() as t:
            ws = Path(t)
            assert check_mcp(ws)[0].startswith("NOT BUILT")
            (ws / MCP_SERVER).parent.mkdir(parents=True)
            (ws / MCP_SERVER).write_text("# stub\n")
            (ws / ".bob").mkdir()
            (ws / ".bob/mcp.json").write_text('{"mcpServers": {"other": {"command": "x"}}}')
            assert check_mcp(ws)[0].startswith("NOT REGISTERED")
            assert check_mcp(ws, fix=True) == [] and check_mcp(ws) == []
            servers = json.loads((ws / ".bob/mcp.json").read_text())["mcpServers"]
            assert "other" in servers and servers[MCP_NAME]["args"][-1] == "--dry-run", servers
            (ws / ".env").write_text("SMTP_HOST=h\nSMTP_PORT=25\nSMTP_USER=u\nSMTP_PASS=p\n")
            assert check_mcp(ws)[0].startswith("NOT REGISTERED")  # creds appeared: drop --dry-run
            assert check_mcp(ws, fix=True) == []
            assert "--dry-run" not in json.loads((ws / ".bob/mcp.json").read_text())["mcpServers"][MCP_NAME]["args"]
            (ws / ".bob/mcp.json").write_text("{bad")
            assert check_mcp(ws, fix=True)[0].startswith("BAD JSON")
    finally:
        os.environ.update({k: v for k, v in saved.items() if v is not None})


def timing(d, manual_hours=None):
    """Pair start/end rows of run-log.md. Machine time excludes stages named 'approval' (human wait)."""
    ev, rows = {}, []
    for ln in (Path(d) / "run-log.md").read_text(encoding="utf-8").splitlines():
        c = [x.strip() for x in ln.strip("|").split("|")]
        if len(c) == 3 and c[2] in ("start", "end"):
            ts = dt.datetime.fromisoformat(c[0])
            if c[2] == "start":
                ev[c[1]] = ts
            elif c[1] in ev:
                rows.append((c[1], (ts - ev.pop(c[1])).total_seconds()))
    machine = sum(s for n, s in rows if "approval" not in n.lower())
    out = [f"{n}: {s / 60:.1f} min" for n, s in rows] + [f"machine time (excl. human approval): {machine / 60:.1f} min"]
    if manual_hours:
        out.append(f"manual estimate: {manual_hours} h -> {manual_hours * 3600 / max(machine, 1):.0f}x faster")
    return "\n".join(out)


MANIFESTS = ["package.json", "requirements*.txt", "pyproject.toml", "composer.json", "pom.xml",
             "build.gradle", "go.mod", "Cargo.toml", "Gemfile", "*.csproj", "*.sln", "Dockerfile", "README*"]
SKIP = {".git", "node_modules", "venv", ".venv", "__pycache__", "vendor", "dist", "build"}


def probe(repo):
    """Deterministic identity of a codebase, so Bob and the manager confirm the right project."""
    r = Path(repo).resolve()
    assert r.is_dir(), f"not a directory: {r}"
    cfg = r / ".git" / "config"
    remote = next((m.group(1) for m in re.finditer(r"url\s*=\s*(\S+)", cfg.read_text(errors="replace"))), "none") if cfg.is_file() else "none (not a git checkout)"
    exts, n = {}, 0
    for root, dirs, files in __import__("os").walk(r):
        dirs[:] = [x for x in dirs if x not in SKIP]
        for f in files:
            n += 1
            e = Path(f).suffix.lower()
            if e:
                exts[e] = exts.get(e, 0) + 1
        if n > 20000:
            break
    top = sorted(x.name + ("/" if x.is_dir() else "") for x in r.iterdir() if x.name not in SKIP and not x.name.startswith("."))
    found = sorted({m.name for g in MANIFESTS for m in r.glob(g)})
    langs = ", ".join(f"{e} ({c})" for e, c in sorted(exts.items(), key=lambda kv: -kv[1])[:6])
    return (f"name: {r.name}\npath: {r}\ngit remote: {remote}\nmanifests: {', '.join(found) or 'none found'}\n"
            f"top languages by file count: {langs or 'none'}\ntop-level: {', '.join(top[:25])}")


def self_test():
    _mcp_self_test()
    t = timeline("2026-10-05", "2027-01-03").splitlines()
    assert len(t) == 6 and "| 4 | 2026-12-04 | 2027-01-03 |" in t[-1], t
    short = timeline("2026-10-05", "2026-10-20").splitlines()  # 16 days: phases 1-2, last clipped
    assert len(short) == 4 and short[-1].startswith("| 2 | 2026-10-12 | 2026-10-20"), short
    long_ = timeline("2026-10-05", "2027-03-01").splitlines()  # >90d: last phase stretches
    assert long_[-1].endswith("Independence |") and "2027-03-01" in long_[-1]
    info = probe(Path(__file__).parent / "fixtures" / "repo")
    assert "name: repo" in info and "requirements.txt" in info and ".py (1)" in info, info
    import tempfile
    with tempfile.TemporaryDirectory() as td:
        (Path(td) / "run-log.md").write_text("| Time | Stage | Event |\n|---|---|---|\n"
            "| 2026-10-05T10:00:00 | 1 generate | start |\n| 2026-10-05T10:06:00 | 1 generate | end |\n"
            "| 2026-10-05T10:06:00 | 5 approval | start |\n| 2026-10-05T11:06:00 | 5 approval | end |\n")
        r = timing(td, 2)
        assert "machine time (excl. human approval): 6.0 min" in r and "20x faster" in r, r
    try:
        timeline("2026-10-05", "2026-10-05")
        raise SystemExit("expected failure")
    except AssertionError:
        pass
    _storyboard_self_test()
    _naming_self_test()
    _deliverables_self_test()
    _fix_loop_self_test()
    _guide_self_test()


def _guide_self_test():
    import tempfile
    fx = Path(__file__).parent / "fixtures"
    with tempfile.TemporaryDirectory() as t:
        d = Path(t) / "alex-tan"
        (d / "context" / "issues").mkdir(parents=True)
        (d / "context/issues/INDEX.md").write_text("# Issues\n")
        (d / "context/issues/ISSUE-001-a.md").write_text("# ISSUE-001: a\n")
        (d / "context/AGENTS.md").write_text("# a\n")
        (d / "context/weird.md").write_text("# w\n")
        (d / "intake.yaml").write_text("name: Alex Tan\ncompany: Acme Co\nbuddy: Daniel Wong\nmanager: Priya Menon\nstart_date: 2026-10-05\nvideo: yes\n")
        n = names(d)
        n["pdf"].write_bytes(b"%PDF")
        n["zip"].write_bytes(b"PK")
        n["mp4"].write_bytes(b"x")
        readme, email = guide(d)
        r, e = readme.read_text(encoding="utf-8"), email.read_text(encoding="utf-8")
        assert r.startswith("# Start here, Alex") and n["pdf"].name in r and n["mp4"].name in r and n["zip"].name in r
        assert "Daniel Wong" in r and "Daniel Wong" in e and "See you on 2026-10-05." in e
        assert "- AGENTS.md: the instructions Bob reads first" in r and "issues/ISSUE-NNN-*.md (1 file)" in r
        assert "- weird.md: supporting material" in r and "- README.md" not in r, "unknown files listed by name; README not listed"
        assert "onboarding-workspace/AGENTS.md" in r and "Ctrl+Alt+B" in r and "@/context/README.md" in r
        assert "`" not in e and not any("`" in ln and "```" not in ln for ln in r.splitlines()), "inline backticks would look like citations"
        # Item 1: email is a cover note — full steps in README only, first 3 in email.
        assert "To get started:" in e, "email must open with cover-note header"
        assert "Ctrl+Alt+B" not in e, "full step list must not appear in email"
        assert "context/README.md" in e, "email must point to README for full guide"
        assert "## Set up Bob IDE with this folder" in r, "README must keep the full steps section"
        assert "Ctrl+Alt+B" in r, "README must include all steps including step 6"
        # Core is generic: no repo/project baked in; instance values come only from intake.yaml.
        assert "git clone" not in r and "github.com/" not in r.replace("bob.ibm.com", "") and "onboarding-workspace/project" in r
        (d / "intake.yaml").write_text("name: Alex Tan\ncompany: Acme Co\nrepo_url: https://example.com/x.git\nproject_dir: Proj\n")
        r2 = guide(d)[0].read_text(encoding="utf-8")
        assert "git clone https://example.com/x.git" in r2 and "onboarding-workspace/Proj" in r2
        (d / "intake.yaml").write_text("name: Alex Tan\ncompany: Acme Co\nbuddy: Daniel Wong\nmanager: Priya Menon\nstart_date: 2026-10-05\nvideo: yes\n")
        guide(d)
        probs = check(d, fx / "repo")  # the stub issue file fails on purpose; the generated docs must add nothing
        assert not any("README.md" in x or "email-newcomer" in x for x in probs), probs
        assert deliverables(d)[1] == [], deliverables(d)
        n["mp4"].unlink()  # no video: the guide must not promise one
        (d / "intake.yaml").write_text("name: Alex Tan\ncompany: Acme Co\nmanager: Priya Menon\nstart_date: 2026-10-05\nvideo: no\n")
        r, e = guide(d)[0].read_text(encoding="utf-8"), email.read_text(encoding="utf-8")
        assert "video tour" not in r and "video tour" not in e and "ask Priya Menon" in e
        n["pdf"].unlink()  # PDF declined: the pack.md fallback is named instead
        assert "1. pack.md:" in guide(d)[0].read_text(encoding="utf-8")
        email.unlink()
        assert deliverables(d)[1][-1].startswith("MISSING body")


def _fix_loop_self_test():
    import tempfile
    fx = Path(__file__).parent / "fixtures"
    with tempfile.TemporaryDirectory() as t:
        d = Path(t) / "run"
        (d / "context" / "issues").mkdir(parents=True)
        for f in ("ISSUE-001-sql-injection.md",):
            (d / "context" / "issues" / f).write_bytes((fx / "sample/context/issues" / f).read_bytes())
        (d / "context" / "issues" / "ISSUE-002-other.md").write_text(
            "# ISSUE-002: Other thing\nSeverity: low · Category: docs · Confidence: 70%\nLocation: `app/main.py:1`\n"
            "Suggested timeline: 2026-10-13 → 2026-10-20\n", encoding="utf-8")
        (d / "context" / "issues" / "INDEX.md").write_text("# Issues\n| ISSUE-001-sql-injection.md |\n")  # ISSUE-002 missing
        (d / "pack.md").write_bytes((fx / "sample/pack.md").read_bytes())
        sb = json.loads((fx / "sample/storyboard.json").read_text(encoding="utf-8"))
        sb["title"] = "Something the model made up"
        (d / "storyboard.json").write_text(json.dumps(sb), encoding="utf-8")
        before = check_storyboard(d, fx / "repo")
        assert any("must equal pack.md's H1" in x for x in before), before
        done = fix(d)
        assert len(done) == 3 and any("INDEX" in x for x in done) and any("title" in x for x in done), done
        idx = (d / "context/issues/INDEX.md").read_text(encoding="utf-8")
        assert "[ISSUE-002](ISSUE-002-other.md) | Other thing | low | docs |" in idx and "ISSUE-001" in idx, idx
        assert (d / "context/scripts/install_deps.py").is_file()
        assert not any("must equal" in x for x in check_storyboard(d, fx / "repo"))
        assert fix(d) == [], "fix must be idempotent"
        issue = d / "context/issues/ISSUE-002-other.md"  # an edited issue must not leave a stale INDEX behind
        issue.write_text(issue.read_text(encoding="utf-8").replace("`app/main.py:1`", "`app/main.py:11`"), encoding="utf-8")
        assert fix(d) == ["rebuilt context/issues/INDEX.md from the issue files"]
        assert "`app/main.py:11`" in (d / "context/issues/INDEX.md").read_text(encoding="utf-8")

        # guard: budget, no-progress detection, reset on success
        g = lambda txt: guard(d, "3 check", txt)
        assert g("A") == (True, "RETRY 3 check: fix attempt 1 of 3")
        assert g("B")[0] and g("C")[0] is True
        assert g("D") == (False, "STOP 3 check: 3 fix attempts used and it still fails. Ask the user.")
        assert guard(d, "3 check", None)[0] and guard(d, "6 render", "X\nY")[0]  # success resets; stages are independent
        assert guard(d, "6 render", "Y\nX")[0] is False, "same problems, any order, means no progress"
        assert guard(d, "3 check", "A")[0], "counter was reset"
        assert "fix-loop" in (d / "run-log.md").read_text(encoding="utf-8")


def _deliverables_self_test():
    import tempfile
    with tempfile.TemporaryDirectory() as t:
        d = Path(t) / "alex-tan"
        d.mkdir()
        (d / "intake.yaml").write_text("name: Alex Tan\ncompany: Acme\nvideo: yes\n")
        n = names(d)
        n["pdf"].write_bytes(b"%PDF")
        n["zip"].write_bytes(b"PK")
        (d / "email-newcomer.md").write_text("Hi\n")
        lines, probs = deliverables(d)
        assert len(probs) == 1 and probs[0].startswith("MISSING mp4"), probs  # video wanted but absent: loud
        n["mp4"].write_bytes(b"x" * 1000)
        lines, probs = deliverables(d)
        assert probs == [] and [x.split(":")[0] for x in lines] == ["attach pdf", "attach zip", "attach mp4", "body"], (lines, probs)
        with n["mp4"].open("wb") as f:
            f.truncate((MAX_ATTACH_MB + 1) * 1024 * 1024)  # sparse, costs nothing
        assert deliverables(d)[1][0].startswith("TOO BIG mp4")
        n["mp4"].unlink()
        (d / "intake.yaml").write_text("name: Alex Tan\ncompany: Acme\nvideo: no\n")
        lines, probs = deliverables(d)
        assert probs == [] and any("skipped (video: no)" in x for x in lines), (lines, probs)
        n["pdf"].unlink()
        assert deliverables(d)[1][0].startswith("MISSING pdf")


def _naming_self_test():
    import tempfile
    cases = {"Alex Tan": "alex-tan", "  Nur Aisyah binti Ahmad ": "nur-aisyah-binti-ahmad",
             "José Ángel O'Brien-Smith": "jose-angel-o-brien-smith", "../../etc/passwd": "etc-passwd",
             "Nul": "nul-hire", "AUX": "aux-hire"}
    for src, want in cases.items():
        assert slug(src, root="/nonexistent") == want, (src, slug(src, root="/nonexistent"))
    long_ = slug("Anantojo Mendan Anak Roselina Lunsa Very Long Family Name Indeed")
    assert len(long_) <= 40 and not long_.endswith("-"), long_
    han = slug("李伟")
    assert han.startswith("hire-") and han == slug("李伟") and han != slug("王芳"), han  # stable, distinct
    assert all(re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)*", slug(x)) for x in list(cases) + ["李伟", "!!!", ""])
    with tempfile.TemporaryDirectory() as t:
        (Path(t) / "alex-tan").mkdir()
        (Path(t) / "alex-tan" / "intake.yaml").write_text("name: Alex Tan\nemail: a@x.co\ncompany: Acme Co.\n")
        assert slug("Alex Tan", t, "A@X.co") == "alex-tan"  # same person: same folder (case-insensitive email)
        assert slug("Alex Tan", t, "b@x.co") == "alex-tan-2"  # different person, same name: no overwrite
        n = names(Path(t) / "alex-tan")
        assert n["pdf"].name == "acme-co-onboarding-alex-tan.pdf", n
        assert n["zip"].name == "acme-co-onboarding-alex-tan-context.zip" and n["mp4"].name == "acme-co-onboarding-alex-tan-tour.mp4"
        (Path(t) / "bob").mkdir()  # no intake.yaml / no company: still a sane name
        assert names(Path(t) / "bob")["pdf"].name == "onboarding-bob.pdf"


def _storyboard_self_test():
    import copy
    import tempfile
    fx = Path(__file__).parent / "fixtures"
    good = json.loads((fx / "sample" / "storyboard.json").read_text(encoding="utf-8"))
    assert check_storyboard(fx / "sample", fx / "repo") == [], check_storyboard(fx / "sample", fx / "repo")

    def problems(mutate):
        sb = copy.deepcopy(good)
        mutate(sb)
        with tempfile.TemporaryDirectory() as t:
            (Path(t) / "pack.md").write_text((fx / "sample" / "pack.md").read_text(encoding="utf-8"), encoding="utf-8")
            (Path(t) / "storyboard.json").write_text(json.dumps(sb), encoding="utf-8")
            return check_storyboard(t, fx / "repo")

    flow = lambda sb: next(x for x in sb["scenes"] if x["kind"] == "flow")
    points = lambda sb: next(x for x in sb["scenes"] if x["kind"] == "points")
    cases = {
        "MISSING": lambda sb: flow(sb).update(refs=["app/nope.py:1"]),
        "LINE": lambda sb: flow(sb).update(refs=["app/main.py:999"]),
        "not cited in pack.md": lambda sb: flow(sb).update(refs=["requirements.txt:1"]),
        "not a repo-relative": lambda sb: flow(sb).update(refs=["../secret.py:1"]),
        "'active'": lambda sb: flow(sb).update(active=9),
        "one line per bullet": lambda sb: points(sb).update(say=["only one", "two"]),
        "no emails or URLs": lambda sb: points(sb).update(say="Write to a@b.co now."),
        "no ISO dates": lambda sb: points(sb).update(say="Start on 2026-10-05."),
        "must equal pack.md's H1": lambda sb: sb.update(title="Something else"),
        "appears in the text but not in pack.md": lambda sb: points(sb).update(points=["see app/other.py:3"]),
        "over 170s": lambda sb: points(sb).update(say="word " * 500),
        "exactly scene 1 is the cover": lambda sb: sb["scenes"].pop(0),
        # Item 2: flow scene count and points scene cap
        "need at least 3": lambda sb: [sb["scenes"].remove(x) for x in list(sb["scenes"]) if x.get("kind") == "flow"],
        "cap is 3": lambda sb: [sb["scenes"].extend([
            {"kind": "points", "title": f"Extra {i}", "points": ["Alpha", "Beta"],
             "say": ["One thing.", "Another thing."]} for i in range(4)
        ])],
        # Item 3: redundant bullet/narration
        "mostly identical": lambda sb: points(sb).update(
            say=["The backend and API service.", "Database seed data and migrations.", "Reviews within one working day."]),
    }
    for want, mutate in cases.items():
        got = problems(mutate)
        assert any(want in g for g in got), (want, got)
    with tempfile.TemporaryDirectory() as t:
        (Path(t) / "storyboard.json").write_text("{bad")
        assert "BAD JSON" in check_storyboard(t, fx / "repo")[0]
        assert check_storyboard(Path(t) / "nope", fx / "repo") == []  # no storyboard: video is optional


if __name__ == "__main__":
    a = sys.argv[1:]
    if a[:1] == ["timeline"] and len(a) == 3:
        print(timeline(a[1], a[2]))
    elif a[:1] == ["log"] and len(a) == 4:
        log(a[1], a[2], a[3])
    elif a[:1] == ["check"] and len(a) == 3:
        p = check(a[1], a[2])
        print("\n".join(p) if p else "OK")
        sys.exit(1 if p else 0)
    elif a[:1] == ["time"] and len(a) in (2, 3):
        print(timing(a[1], float(a[2]) if len(a) == 3 else None))
    elif a[:1] == ["probe"] and len(a) == 2:
        print(probe(a[1]))
    elif a[:1] == ["slug"] and len(a) in (2, 4) and (len(a) == 2 or a[2] == "--email"):
        print(slug(a[1], email=a[3] if len(a) == 4 else None))
    elif a[:1] == ["names"] and len(a) == 2:
        print("\n".join(f"{k}: {v.as_posix() if hasattr(v, 'as_posix') else v}" for k, v in names(a[1]).items()))
    elif a[:1] == ["guide"] and len(a) == 2:
        print("\n".join(x.as_posix() for x in guide(a[1])))
    elif a[:1] == ["fix"] and len(a) == 2:
        done = fix(a[1])
        print("\n".join("fixed: " + x for x in done) if done else "nothing mechanical to fix")
    elif a[:1] == ["guard"] and len(a) in (3, 4) and (len(a) == 3 or a[3] == "--ok"):
        ok, msg = guard(a[1], a[2], None if len(a) == 4 else sys.stdin.read())
        print(msg)
        sys.exit(0 if ok else 1)
    elif a[:1] == ["deliverables"] and len(a) == 2:
        lines, problems = deliverables(a[1])
        print("\n".join(lines + problems))
        sys.exit(1 if problems else 0)
    elif a[:1] == ["bundle"] and len(a) == 2:
        print(bundle(a[1]))
    elif a[:1] == ["check-mcp"] and a[1:] in ([], ["--fix"]):
        p = check_mcp(".", "--fix" in a)
        print("\n".join(p) if p else "OK")
        sys.exit(1 if p else 0)
    else:
        sys.exit(__doc__)
