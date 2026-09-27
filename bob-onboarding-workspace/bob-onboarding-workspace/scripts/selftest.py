#!/usr/bin/env python3
"""One-command check for the whole toolchain: python scripts/selftest.py
Runs every module self-test, then the fixture end to end: citation + storyboard check, bundle, PDF render.
The video render is optional (needs piper-tts, ffmpeg, the voice): see make_video.py --doctor."""
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import install_deps, pipeline_tools  # noqa: E402

try:
    import brochure_kit, make_video, render_pdf
except ImportError:
    brochure_kit = make_video = render_pdf = None
    print("WARNING: pycairo missing, PDF tests skipped (pip install pycairo)")

pipeline_tools.self_test()
install_deps.self_test()
if brochure_kit:
    brochure_kit.self_check()
    render_pdf.self_test()
    make_video.self_test()  # drawing + safety rules always; a real render only if piper/ffmpeg/voice exist

fx = HERE / "fixtures"
assert pipeline_tools.check(fx / "sample", fx / "repo") == [], pipeline_tools.check(fx / "sample", fx / "repo")
bad = fx / "sample" / "context" / "issues" / "ISSUE-002-bad.md"
bad.write_text("# ISSUE-002: x\nLocation: `app/nope.py:1`\n", encoding="utf-8")
try:
    probs = pipeline_tools.check(fx / "sample", fx / "repo")
finally:
    bad.unlink()
assert any("MISSING app/nope.py" in p for p in probs) and any("missing '## Impact'" in p for p in probs), probs
bad = fx / "sample" / "context" / "issues" / "ISSUE-3-Bad Name.md"  # naming rules: 3 digits + lowercase slug, no gaps
bad.write_text("# ISSUE-3: x\n", encoding="utf-8")
try:
    probs = pipeline_tools.check(fx / "sample", fx / "repo")
finally:
    bad.unlink()
assert any("file name must be ISSUE-NNN-" in p for p in probs), probs

with tempfile.TemporaryDirectory() as t:
    if not render_pdf:
        print("ALL OK (without PDF)")
        sys.exit(0)
    import shutil
    d = Path(t) / "sample"
    shutil.copytree(fx / "sample", d)
    n = render_pdf.render(d)
    pdf = pipeline_tools.names(d)["pdf"]
    assert pdf.name == "northwind-labs-onboarding-sample.pdf", pdf.name
    assert pdf.stat().st_size > 5000 and pdf.read_bytes()[:4] == b"%PDF" and n >= 3
    z = pipeline_tools.bundle(d)
    import zipfile
    assert z.name == "northwind-labs-onboarding-sample-context.zip", z.name
    assert "context/issues/ISSUE-001-sql-injection.md" in zipfile.ZipFile(z).namelist()
    if len(sys.argv) > 1:
        shutil.copy(pdf, sys.argv[1])
print("ALL OK")
