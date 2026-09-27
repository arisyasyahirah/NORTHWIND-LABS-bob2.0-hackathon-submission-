"""Drive the onboarding-mail MCP server over STDIO and call send_onboarding_email."""
import json, os, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).parent.parent  # bob-onboarding-workspace/

# Load .env
env_file = ROOT / ".env"
env = dict(os.environ)
if env_file.exists():
    for ln in env_file.read_text(encoding="utf-8-sig").splitlines():
        if "=" in ln and not ln.startswith("#"):
            k, v = ln.split("=", 1)
            env[k.strip()] = v.strip()

server = ROOT / "mcp" / "onboarding-mail" / "server.py"
# usage: python scripts/send_via_mcp.py <slug> [--to addr]   (--to overrides the newcomer address, e.g. a test inbox)
slug = sys.argv[1]
run = ROOT / "onboarding" / slug
info = dict(l.split(":", 1) for l in (run / "intake.yaml").read_text(encoding="utf-8").splitlines() if ":" in l and not l.startswith("#"))
info = {k.strip(): v.strip() for k, v in info.items()}
to = sys.argv[sys.argv.index("--to") + 1] if "--to" in sys.argv else info["email"]
co = info["company"]

body = (run / "email-newcomer.md").read_text(encoding="utf-8")
attachments = [str(p) for p in sorted(run.glob("*")) if p.suffix in {".pdf", ".zip", ".mp4"}]  # ponytail: globs the run dir; fine for one hire per folder

def frame(obj: dict) -> bytes:
    payload = json.dumps(obj).encode()
    return b"Content-Length: " + str(len(payload)).encode() + b"\r\n\r\n" + payload

INIT = frame({
    "jsonrpc": "2.0", "id": 0, "method": "initialize",
    "params": {"protocolVersion": "2024-11-05",
               "capabilities": {}, "clientInfo": {"name": "send-script", "version": "1"}}
})

CALL = frame({
    "jsonrpc": "2.0", "id": 1, "method": "tools/call",
    "params": {
        "name": "send_onboarding_email",
        "arguments": {
            "to": to,
            "subject": f"Welcome to {co}, {info['name']} — your onboarding pack is attached",
            "body": body,
            "brand_name": info.get("brand_name") or co,
            "brand_accent": info.get("brand_accent", ""),
            "attachment_paths": attachments,
        }
    }
})

proc = subprocess.Popen(
    [sys.executable, str(server)],
    stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    env=env,
)

# send init + call then close stdin so the server's readline loop exits
proc.stdin.write(INIT + CALL)
proc.stdin.close()

stdout, stderr = proc.communicate(timeout=30)

def read_messages(data: bytes):
    msgs = []
    while data:
        if b"Content-Length:" not in data:
            break
        hdr_end = data.index(b"\r\n\r\n")
        hdr = data[:hdr_end].decode()
        length = None
        for line in hdr.splitlines():
            if line.lower().startswith("content-length:"):
                length = int(line.split(":", 1)[1].strip())
        if length is None:
            break
        body_start = hdr_end + 4
        msgs.append(json.loads(data[body_start:body_start + length]))
        data = data[body_start + length:]
    return msgs

msgs = read_messages(stdout)
for m in msgs:
    print(json.dumps(m, indent=2))

if stderr:
    print("STDERR:", stderr.decode(errors="replace"), file=sys.stderr)
