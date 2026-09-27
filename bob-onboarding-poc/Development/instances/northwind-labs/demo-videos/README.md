# Demo videos

Rendered examples of the optional stage 6b (`scripts/make_video.py`). The `.webm` copies exist because VS Code's preview cannot play the MP4's AAC audio on some Linux builds; the MP4 is the real output.

- `northwind/sample.mp4`: the fixture in `scripts/fixtures/sample/`, rendered by the pipeline command with real code excerpts from `scripts/fixtures/repo`. Regenerate: `python scripts/make_video.py <copy of fixtures/sample> --repo scripts/fixtures/repo --check`.
- `alex-tan/`: a longer, realistic story built from a real Bob-generated pack (`pack.md` here is rebuilt from the PDF text). Its `storyboard.json` is the reference for a full-length script. Its code target (the CTMS repo) is not in this workspace, so `alex-tan.mp4` was rendered by an earlier build that fell back to showing paths instead of code; the current `make_video.py` requires the repo and will not render this one without it.
