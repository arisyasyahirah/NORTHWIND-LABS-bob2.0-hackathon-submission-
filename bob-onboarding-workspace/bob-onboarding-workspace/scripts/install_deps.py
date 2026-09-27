#!/usr/bin/env python3
"""Check a repo's declared dependencies and install what is missing (stdlib only).

  python install_deps.py <repo_path> [--check]

Reads requirements*.txt (pip) and package.json (npm). --check reports only.
Never uses sudo or system package managers: for a missing runtime it prints what to install.
Exit code 1 if anything is still missing/failed.
"""
import json
import re
import shutil
import subprocess
import sys
from importlib import metadata
from pathlib import Path

NAME = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]*")


def pip_missing(repo):
    """[(requirement line, file)] not installed in this interpreter."""
    out = []
    for f in sorted(repo.glob("requirements*.txt")):
        for ln in f.read_text(encoding="utf-8", errors="replace").splitlines():
            ln = ln.split(" #")[0].strip()
            m = NAME.match(ln)
            if not m or ln.startswith("-") or "://" in ln:
                continue
            try:
                metadata.version(m.group(0))
            except metadata.PackageNotFoundError:
                out.append((ln, f.name))
    return out


def npm_missing(repo):
    p = repo / "package.json"
    if not p.is_file():
        return []
    pkg = json.loads(p.read_text(encoding="utf-8"))
    deps = {**pkg.get("dependencies", {}), **pkg.get("devDependencies", {})}
    return [d for d in deps if not (repo / "node_modules" / d / "package.json").is_file()]


def run(cmd, cwd=None):
    print("  $", " ".join(cmd))
    return subprocess.run(cmd, cwd=cwd).returncode == 0


def main(repo, check_only):
    repo = Path(repo).resolve()
    assert repo.is_dir(), f"not a directory: {repo}"
    bad = 0
    pip = pip_missing(repo)
    print(f"pip: {len(pip)} missing" + (f" ({', '.join(r for r, _ in pip)})" if pip else ""))
    if pip and not check_only:
        if sys.prefix == sys.base_prefix:
            print("  warning: not in a virtualenv; pip may refuse or pollute the system Python")
        bad += not run([sys.executable, "-m", "pip", "install", *[r for r, _ in pip]])
    elif pip:
        bad += 1
    if (repo / "package.json").is_file():
        npm = npm_missing(repo)
        print(f"npm: {len(npm)} missing" + (f" ({', '.join(npm)})" if npm else ""))
        if npm and shutil.which("npm") is None:
            print("  npm not found: install Node.js (https://nodejs.org) then re-run")
            bad += 1
        elif npm and not check_only:
            bad += not run(["npm", "install"], cwd=repo)
        elif npm:
            bad += 1
    print("DONE" if not bad else "INCOMPLETE" if not check_only else "MISSING (run without --check to install)")
    return 1 if bad else 0


def self_test():
    import tempfile
    with tempfile.TemporaryDirectory() as d:
        r = Path(d)
        (r / "requirements.txt").write_text("# c\n-r other.txt\nnot-a-real-pkg-xyz==1.0  # x\nhttps://x/y.whl\n")
        (r / "package.json").write_text('{"dependencies":{"left-pad":"1"},"devDependencies":{"jest":"1"}}')
        assert pip_missing(r) == [("not-a-real-pkg-xyz==1.0", "requirements.txt")], pip_missing(r)
        (r / "node_modules/left-pad").mkdir(parents=True)
        (r / "node_modules/left-pad/package.json").write_text("{}")
        assert npm_missing(r) == ["jest"]
        assert main(r, True) == 1


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if a != "--check"]
    if len(args) != 1:
        sys.exit(__doc__)
    sys.exit(main(args[0], "--check" in sys.argv))
