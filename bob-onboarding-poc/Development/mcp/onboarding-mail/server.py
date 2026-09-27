#!/usr/bin/env python3
"""STDIO MCP server — onboarding-mail.

Exposes one tool: send_onboarding_email(to, subject, body, attachment_paths, reply_to).
SMTP credentials come from environment variables (SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS).
Run with --dry-run to log the call instead of sending; pipeline_tools.py check-mcp adds this
flag automatically when no SMTP credentials are found.

Wire protocol: MCP STDIO (JSON-RPC 2.0 with Content-Length framing, same as LSP).
Only stdlib is used; no third-party packages required.
"""
import email.mime.base
import email.mime.multipart
import email.mime.text
import email.utils
import html as _html_escape_mod
import json
import logging
import os
import re
import smtplib
import sys
from email import encoders
from pathlib import Path

# ---------------------------------------------------------------------------
# Logging — always to stderr; stdout is the protocol channel.
# ---------------------------------------------------------------------------
logging.basicConfig(stream=sys.stderr, level=logging.INFO,
                    format="%(asctime)s [onboarding-mail] %(levelname)s %(message)s")
log = logging.getLogger("onboarding-mail")

DRY_RUN = "--dry-run" in sys.argv
SERVER_NAME = "onboarding-mail"
SERVER_VERSION = "0.1.0"

# ---------------------------------------------------------------------------
# Tool schema (JSON Schema subset that Bob / MCP clients understand).
# ---------------------------------------------------------------------------
TOOL = {
    "name": "send_onboarding_email",
    "description": (
        "Send an onboarding email with optional file attachments. "
        "Uses SMTP credentials from the environment. "
        "In --dry-run mode the call is logged but no email is sent."
    ),
    "inputSchema": {
        "type": "object",
        "properties": {
            "to": {
                "type": "string",
                "description": "Recipient email address.",
            },
            "subject": {
                "type": "string",
                "description": "Email subject line.",
            },
            "body": {
                "type": "string",
                "description": "Plain-text email body (UTF-8).",
            },
            "attachment_paths": {
                "type": "array",
                "items": {"type": "string"},
                "description": "Absolute or workspace-relative file paths to attach.",
                "default": [],
            },
            "reply_to": {
                "type": "string",
                "description": "Reply-To address (buddy email, else manager email).",
                "default": "",
            },
            "brand_name": {
                "type": "string",
                "description": "Company name for the HTML header/footer (intake.yaml brand_name, else company).",
                "default": "",
            },
            "brand_accent": {
                "type": "string",
                "description": "Accent colour as #rrggbb (intake.yaml brand_accent). Default is a neutral yellow.",
                "default": "",
            },
        },
        "required": ["to", "subject", "body"],
    },
}


# ---------------------------------------------------------------------------
# Branded HTML template (newcomer email only — wraps plain-text body).
# ---------------------------------------------------------------------------
# Palette mirrors the PDF brochure kit: near-black header, yellow accent.
_BG        = "#f5f5f5"
_CARD_BG   = "#ffffff"
_HEADER_BG = "#111111"
_ACCENT    = "#f5b800"       # default accent; overridable per call via brand_accent
_TEXT      = "#1a1a1a"
_MUTED     = "#555555"
_BORDER    = "#e0e0e0"
_MONO_BG   = "#f0f0f0"

# Recognise the section-header lines that guide() emits ("Set up Bob …:").
_SECTION_RE = re.compile(r"^[A-Z][^.!?]{5,}:$")
# Detect numbered list items ("1. …").
_ITEM_RE    = re.compile(r"^(\d+)\.\s+(.+)$")
# Auto-link URLs inside text.
_URL_RE     = re.compile(r"(https?://[^\s<>\"']+)")


def _linkify(text: str) -> str:
    """Wrap bare URLs in <a> tags; escape everything else."""
    parts = _URL_RE.split(_html_escape_mod.escape(text))
    out = []
    for i, part in enumerate(parts):
        # _URL_RE has one capturing group → odd indices are the captured URL
        # (already HTML-escaped by the split on the escaped string, but the
        # URL itself is safe — re-unescape it for the href).
        if i % 2 == 1:
            url = _html_escape_mod.unescape(part)
            out.append(
                f'<a href="{url}" style="color:{_ACCENT};text-decoration:none;">'
                f"{part}</a>"
            )
        else:
            out.append(part)
    return "".join(out)


def _html_body(plain: str, subject: str = "", brand_name: str = "", brand_accent: str = "") -> str:
    """Convert the plain-text onboarding email body to branded HTML.

    The converter is structural, not wording-changing: it recognises the
    fixed shape that pipeline_tools.guide() always produces and maps each
    paragraph type to a styled HTML block.  The text of every line is
    preserved verbatim (only escaped and linkified).
    """
    brand_plain = _html_escape_mod.escape(brand_name.strip() or "Onboarding")
    brand = brand_plain.upper()
    accent = brand_accent if re.fullmatch(r"#[0-9a-fA-F]{6}", brand_accent or "") else _ACCENT
    # Split into logical paragraphs separated by one or more blank lines.
    paras: list[list[str]] = []
    current: list[str] = []
    for raw in plain.splitlines():
        line = raw.rstrip()
        if line:
            current.append(line)
        else:
            if current:
                paras.append(current)
                current = []
    if current:
        paras.append(current)

    def render_para(lines: list[str]) -> str:
        """Turn one paragraph (list of non-empty lines) into HTML."""
        # Detect a block of numbered list items.
        if all(_ITEM_RE.match(l) for l in lines):
            items_html = "".join(
                f'<li style="margin:0 0 10px 0;padding-left:4px;">'
                f'{_linkify(_ITEM_RE.match(l).group(2))}</li>'
                for l in lines
            )
            return (
                f'<ol style="margin:0 0 18px 0;padding-left:22px;'
                f'color:{_TEXT};font-size:15px;line-height:1.6;">'
                f"{items_html}</ol>"
            )

        # Single line that looks like a section header ("Set up Bob …:").
        if len(lines) == 1 and _SECTION_RE.match(lines[0]):
            return (
                f'<p style="margin:24px 0 6px 0;font-size:11px;font-weight:700;'
                f'letter-spacing:0.12em;text-transform:uppercase;color:{_MUTED};">'
                f"{_html_escape_mod.escape(lines[0].rstrip(':'))}</p>"
            )

        # Everything else: join lines into a paragraph.
        text = " ".join(lines)
        return (
            f'<p style="margin:0 0 16px 0;font-size:15px;line-height:1.6;'
            f'color:{_TEXT};">{_linkify(text)}</p>'
        )

    body_html = "\n".join(render_para(p) for p in paras)

    # Extract first name from "Hi <Name>," greeting if present.
    first_name = ""
    if paras and paras[0] and paras[0][0].startswith("Hi "):
        first_name = paras[0][0][3:].rstrip(",").strip().split()[0]

    return f"""\
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head>
<body style="margin:0;padding:0;background:{_BG};font-family:-apple-system,Segoe UI,Arial,sans-serif;">
<table width="100%" cellpadding="0" cellspacing="0" border="0"
       style="background:{_BG};min-height:100vh;">
  <tr><td align="center" style="padding:32px 16px;">

    <!-- Card -->
    <table width="600" cellpadding="0" cellspacing="0" border="0"
           style="max-width:600px;width:100%;background:{_CARD_BG};
                  border:1px solid {_BORDER};border-radius:4px;overflow:hidden;">

      <!-- Header band -->
      <tr>
        <td style="background:{_HEADER_BG};padding:22px 32px;line-height:1;">
          <span style="font-size:13px;font-weight:700;letter-spacing:0.18em;
                       text-transform:uppercase;color:{accent};">{brand}</span>
          <span style="display:block;margin-top:6px;font-size:11px;
                       letter-spacing:0.1em;text-transform:uppercase;
                       color:rgba(255,255,255,0.55);">DEVELOPER ONBOARDING</span>
        </td>
      </tr>

      <!-- Hero strip -->
      <tr>
        <td style="background:{accent};padding:16px 32px;">
          <span style="font-size:18px;font-weight:700;color:{_HEADER_BG};">
            {'Welcome, ' + first_name + '.' if first_name else subject or 'Welcome.'}
          </span>
        </td>
      </tr>

      <!-- Body -->
      <tr>
        <td style="padding:28px 32px 24px 32px;">
          {body_html}
        </td>
      </tr>

      <!-- Footer -->
      <tr>
        <td style="background:{_BG};border-top:1px solid {_BORDER};
                   padding:14px 32px;text-align:center;">
          <span style="font-size:11px;color:{_MUTED};">
            {brand_plain} &mdash; this message and its attachments are for
            {first_name or 'the named recipient'} only.
          </span>
        </td>
      </tr>

    </table>
  </td></tr>
</table>
</body>
</html>"""


# ---------------------------------------------------------------------------
# SMTP send / dry-run.
# ---------------------------------------------------------------------------
def _send(to: str, subject: str, body: str,
          attachment_paths: list, reply_to: str, brand_name: str = "", brand_accent: str = "") -> str:
    """Build and send the message. Returns a human-readable result string."""
    host = os.environ.get("SMTP_HOST", "")
    port = int(os.environ.get("SMTP_PORT", "587"))
    user = os.environ.get("SMTP_USER", "")
    password = os.environ.get("SMTP_PASS", "")

    if not (host and user and password):
        raise RuntimeError(
            "SMTP_HOST, SMTP_USER and SMTP_PASS must be set in the environment. "
            "Run with --dry-run when no credentials are available."
        )

    # Outer container: mixed (allows attachments).
    msg = email.mime.multipart.MIMEMultipart("mixed")
    msg["From"] = user
    msg["To"] = to
    msg["Subject"] = subject
    msg["Date"] = email.utils.formatdate(localtime=True)
    msg["Message-ID"] = email.utils.make_msgid(domain=host)
    if reply_to:
        msg["Reply-To"] = reply_to

    # Inner alternative: plain-text + HTML.  Clients pick the last part they
    # can render, so HTML goes last per RFC 2046.
    alt = email.mime.multipart.MIMEMultipart("alternative")
    alt.attach(email.mime.text.MIMEText(body, "plain", "utf-8"))
    alt.attach(email.mime.text.MIMEText(_html_body(body, subject, brand_name, brand_accent), "html", "utf-8"))
    msg.attach(alt)

    attached = []
    for raw in attachment_paths:
        p = Path(raw)
        if not p.is_file():
            log.warning("attachment not found, skipping: %s", p)
            continue
        with p.open("rb") as fh:
            part = email.mime.base.MIMEBase("application", "octet-stream")
            part.set_payload(fh.read())
        encoders.encode_base64(part)
        part.add_header("Content-Disposition", "attachment", filename=p.name)
        msg.attach(part)
        attached.append(p.name)

    with smtplib.SMTP(host, port) as smtp:
        smtp.ehlo()
        smtp.starttls()
        smtp.login(user, password)
        smtp.sendmail(user, [to], msg.as_bytes())

    return (
        f"sent to={to!r} subject={subject!r} reply_to={reply_to!r} "
        f"attachments={attached}"
    )


def _dry_run(to: str, subject: str, body: str,
             attachment_paths: list, reply_to: str, brand_name: str = "", brand_accent: str = "") -> str:
    """Log the call without sending anything. Returns a log summary."""
    names = [Path(p).name for p in attachment_paths]
    summary = (
        f"[DRY-RUN] to={to!r} subject={subject!r} reply_to={reply_to!r} "
        f"attachments={names} body_chars={len(body)}"
    )
    log.info(summary)
    return summary


# ---------------------------------------------------------------------------
# JSON-RPC / MCP wire protocol helpers.
# ---------------------------------------------------------------------------
def _read_message(stream) -> dict | None:
    """Read one Content-Length-framed JSON-RPC message from *stream*.
    Returns None on EOF."""
    header = b""
    while True:
        ch = stream.read(1)
        if not ch:
            return None          # EOF
        header += ch
        if header.endswith(b"\r\n\r\n"):
            break

    length = None
    for line in header.split(b"\r\n"):
        if line.lower().startswith(b"content-length:"):
            length = int(line.split(b":", 1)[1].strip())
    if length is None:
        raise ValueError(f"No Content-Length in header: {header!r}")

    body = stream.read(length)
    return json.loads(body.decode("utf-8"))


def _write_message(stream, obj: dict) -> None:
    """Write one Content-Length-framed JSON-RPC message to *stream*."""
    data = json.dumps(obj, ensure_ascii=False).encode("utf-8")
    frame = (
        f"Content-Length: {len(data)}\r\n"
        f"Content-Type: application/json\r\n\r\n"
    ).encode("ascii") + data
    stream.write(frame)
    stream.flush()


def _ok(req_id, result: dict) -> dict:
    return {"jsonrpc": "2.0", "id": req_id, "result": result}


def _err(req_id, code: int, message: str) -> dict:
    return {"jsonrpc": "2.0", "id": req_id, "error": {"code": code, "message": message}}


# ---------------------------------------------------------------------------
# Request handlers.
# ---------------------------------------------------------------------------
def _handle(msg: dict) -> dict | None:
    """Dispatch one JSON-RPC request. Returns a response dict or None (for notifications)."""
    method = msg.get("method", "")
    req_id = msg.get("id")          # None for notifications
    params = msg.get("params") or {}

    if method == "initialize":
        return _ok(req_id, {
            "protocolVersion": "2024-11-05",
            "capabilities": {"tools": {}},
            "serverInfo": {"name": SERVER_NAME, "version": SERVER_VERSION},
        })

    if method == "initialized":
        log.info("client initialised" + (" [dry-run]" if DRY_RUN else ""))
        return None                 # notification — no response

    if method == "tools/list":
        return _ok(req_id, {"tools": [TOOL]})

    if method == "tools/call":
        name = params.get("name")
        if name != "send_onboarding_email":
            return _err(req_id, -32601, f"Unknown tool: {name!r}")

        args = params.get("arguments") or {}
        to = args.get("to", "")
        subject = args.get("subject", "")
        body = args.get("body", "")
        attachments = args.get("attachment_paths") or []
        reply_to = args.get("reply_to") or ""
        brand_name = args.get("brand_name") or ""
        brand_accent = args.get("brand_accent") or ""

        if not to or not subject or not body:
            return _err(req_id, -32602,
                        "send_onboarding_email: 'to', 'subject' and 'body' are required")

        try:
            fn = _dry_run if DRY_RUN else _send
            result = fn(to, subject, body, attachments, reply_to, brand_name, brand_accent)
            return _ok(req_id, {
                "content": [{"type": "text", "text": result}],
                "isError": False,
            })
        except Exception as exc:                        # noqa: BLE001
            log.error("send failed: %s", exc)
            return _ok(req_id, {
                "content": [{"type": "text", "text": f"ERROR: {exc}"}],
                "isError": True,
            })

    if method == "ping":
        return _ok(req_id, {})

    # Unknown method — return error only for requests (id present), drop notifications.
    if req_id is not None:
        return _err(req_id, -32601, f"Method not found: {method!r}")
    return None


# ---------------------------------------------------------------------------
# Main loop.
# ---------------------------------------------------------------------------
def serve(stdin=None, stdout=None) -> None:
    """Read MCP messages from *stdin*, write responses to *stdout*.
    Defaults to sys.stdin.buffer / sys.stdout.buffer for the real server."""
    r = stdin  if stdin  is not None else sys.stdin.buffer
    w = stdout if stdout is not None else sys.stdout.buffer
    log.info("onboarding-mail MCP server starting" + (" [dry-run]" if DRY_RUN else ""))
    while True:
        try:
            msg = _read_message(r)
        except Exception as exc:                        # noqa: BLE001
            log.error("read error: %s", exc)
            break
        if msg is None:
            log.info("EOF — shutting down")
            break
        log.debug("← %s", msg.get("method"))
        try:
            resp = _handle(msg)
        except Exception as exc:                        # noqa: BLE001
            log.error("handler error: %s", exc)
            resp = _err(msg.get("id"), -32603, f"Internal error: {exc}")
        if resp is not None:
            log.debug("→ %s", resp.get("result", resp.get("error")))
            _write_message(w, resp)


if __name__ == "__main__":
    serve()
