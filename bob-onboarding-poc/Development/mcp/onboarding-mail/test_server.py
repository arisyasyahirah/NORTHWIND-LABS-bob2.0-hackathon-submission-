#!/usr/bin/env python3
"""Self-contained test suite for mcp/onboarding-mail/server.py.

Run:  python test_server.py
No external dependencies — stdlib only.
"""
import io
import json
import os
import sys
import tempfile
import textwrap
from pathlib import Path
from unittest.mock import MagicMock, patch

# Ensure we import the sibling server module regardless of cwd.
sys.path.insert(0, str(Path(__file__).parent))
import server as srv


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _frame(obj: dict) -> bytes:
    """Encode a dict as a Content-Length-framed message."""
    data = json.dumps(obj).encode()
    return (
        f"Content-Length: {len(data)}\r\n"
        f"Content-Type: application/json\r\n\r\n"
    ).encode() + data


def _roundtrip(*messages: dict, dry_run: bool = True) -> list[dict]:
    """Feed *messages* through serve() and return all responses as dicts."""
    inp = b"".join(_frame(m) for m in messages)
    out = io.BytesIO()

    # Patch DRY_RUN in the module so each test controls it.
    with patch.object(srv, "DRY_RUN", dry_run):
        srv.serve(stdin=io.BytesIO(inp), stdout=out)

    # Parse all responses from the output buffer.
    out.seek(0)
    responses = []
    while True:
        header = b""
        while not header.endswith(b"\r\n\r\n"):
            ch = out.read(1)
            if not ch:
                return responses
            header += ch
        length = None
        for line in header.split(b"\r\n"):
            if line.lower().startswith(b"content-length:"):
                length = int(line.split(b":", 1)[1].strip())
        if length is None:
            raise ValueError(f"No Content-Length: {header!r}")
        body = out.read(length)
        responses.append(json.loads(body))


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

def test_initialize():
    """Server responds to initialize with capabilities and server info."""
    resps = _roundtrip({"jsonrpc": "2.0", "id": 1, "method": "initialize",
                         "params": {"protocolVersion": "2024-11-05", "capabilities": {}}})
    assert len(resps) == 1, resps
    r = resps[0]
    assert r["id"] == 1
    assert r["result"]["serverInfo"]["name"] == "onboarding-mail"
    assert "tools" in r["result"]["capabilities"]
    print("  PASS test_initialize")


def test_initialized_notification():
    """'initialized' is a notification — server must NOT reply to it."""
    resps = _roundtrip(
        {"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {}},
        # No id → notification; server must swallow it silently.
        {"jsonrpc": "2.0",           "method": "initialized"},
    )
    # Only the initialize response comes back.
    assert len(resps) == 1, resps
    assert resps[0]["id"] == 1
    print("  PASS test_initialized_notification")


def test_tools_list():
    """tools/list returns exactly one tool: send_onboarding_email."""
    resps = _roundtrip({"jsonrpc": "2.0", "id": 2, "method": "tools/list"})
    tools = resps[0]["result"]["tools"]
    assert len(tools) == 1
    assert tools[0]["name"] == "send_onboarding_email"
    schema = tools[0]["inputSchema"]
    assert set(schema["required"]) == {"to", "subject", "body"}
    print("  PASS test_tools_list")


def test_dry_run_call():
    """tools/call in dry-run mode logs and returns a summary — no SMTP needed."""
    resps = _roundtrip(
        {
            "jsonrpc": "2.0", "id": 3,
            "method": "tools/call",
            "params": {
                "name": "send_onboarding_email",
                "arguments": {
                    "to": "alex.tan@example.com",
                    "subject": "Welcome to Northwind Labs",
                    "body": "Hi Alex, see attachments.",
                    "attachment_paths": [],
                    "reply_to": "daniel.wong@example.com",
                },
            },
        },
        dry_run=True,
    )
    assert len(resps) == 1
    r = resps[0]["result"]
    assert r["isError"] is False
    text = r["content"][0]["text"]
    assert "[DRY-RUN]" in text
    assert "alex.tan@example.com" in text
    assert "Welcome to Northwind" in text
    assert "daniel.wong@example.com" in text
    print("  PASS test_dry_run_call")


def test_dry_run_with_attachment():
    """Attachment names appear in the dry-run summary."""
    with tempfile.NamedTemporaryFile(suffix=".pdf", delete=False) as tmp:
        tmp.write(b"%PDF-1.4 %%EOF")
        tmp_path = tmp.name
    try:
        resps = _roundtrip(
            {
                "jsonrpc": "2.0", "id": 4,
                "method": "tools/call",
                "params": {
                    "name": "send_onboarding_email",
                    "arguments": {
                        "to": "alex@example.com",
                        "subject": "Onboarding",
                        "body": "See attached.",
                        "attachment_paths": [tmp_path],
                    },
                },
            },
            dry_run=True,
        )
        text = resps[0]["result"]["content"][0]["text"]
        assert Path(tmp_path).name in text, f"attachment name missing: {text}"
        print("  PASS test_dry_run_with_attachment")
    finally:
        os.unlink(tmp_path)


def test_missing_required_fields():
    """tools/call without required fields returns an error response."""
    resps = _roundtrip(
        {
            "jsonrpc": "2.0", "id": 5,
            "method": "tools/call",
            "params": {
                "name": "send_onboarding_email",
                "arguments": {"to": "x@example.com"},  # subject and body missing
            },
        },
        dry_run=True,
    )
    r = resps[0]
    assert "error" in r, r
    assert r["error"]["code"] == -32602
    print("  PASS test_missing_required_fields")


def test_unknown_tool():
    """tools/call with an unknown tool name returns method-not-found."""
    resps = _roundtrip(
        {
            "jsonrpc": "2.0", "id": 6,
            "method": "tools/call",
            "params": {"name": "nonexistent_tool", "arguments": {}},
        },
        dry_run=True,
    )
    r = resps[0]
    assert "error" in r
    assert r["error"]["code"] == -32601
    print("  PASS test_unknown_tool")


def test_unknown_method():
    """Unknown methods return method-not-found."""
    resps = _roundtrip(
        {"jsonrpc": "2.0", "id": 7, "method": "no_such_method"},
        dry_run=True,
    )
    assert resps[0]["error"]["code"] == -32601
    print("  PASS test_unknown_method")


def test_ping():
    """ping returns an empty result."""
    resps = _roundtrip({"jsonrpc": "2.0", "id": 8, "method": "ping"})
    assert resps[0]["result"] == {}
    print("  PASS test_ping")


def test_send_smtp_no_creds():
    """tools/call in live mode without SMTP creds returns isError=True."""
    # Strip any ambient SMTP env vars for this test.
    clean_env = {k: v for k, v in os.environ.items()
                 if k not in ("SMTP_HOST", "SMTP_PORT", "SMTP_USER", "SMTP_PASS")}
    with patch.dict(os.environ, clean_env, clear=True):
        resps = _roundtrip(
            {
                "jsonrpc": "2.0", "id": 9,
                "method": "tools/call",
                "params": {
                    "name": "send_onboarding_email",
                    "arguments": {
                        "to": "a@b.com",
                        "subject": "s",
                        "body": "b",
                    },
                },
            },
            dry_run=False,      # live mode, but no creds → must fail gracefully
        )
    r = resps[0]["result"]
    assert r["isError"] is True
    assert "SMTP_HOST" in r["content"][0]["text"] or "ERROR" in r["content"][0]["text"]
    print("  PASS test_send_smtp_no_creds")


def test_framing():
    """_read_message / _write_message are inverse operations."""
    obj = {"jsonrpc": "2.0", "id": 99, "method": "ping"}
    buf = io.BytesIO()
    srv._write_message(buf, obj)
    buf.seek(0)
    result = srv._read_message(buf)
    assert result == obj
    print("  PASS test_framing")


def test_html_body_structure():
    """_html_body wraps the plain-text body in the Northwind brand template."""
    body = (
        "Hi Alex,\n\n"
        "Welcome to Northwind Labs. Everything for your first week is attached:\n\n"
        "1. pack.pdf: your onboarding pack.\n"
        "2. context.zip: load into Bob IDE.\n\n"
        "Set up Bob in about 10 minutes:\n\n"
        "1. Install Bob IDE from https://bob.ibm.com/download and sign in.\n"
        "2. Create a folder called onboarding-workspace.\n\n"
        "See you on 2026-10-05."
    )
    html = srv._html_body(body, subject="Welcome to Northwind Labs", brand_name="Northwind Labs")

    # Structural checks — wording must be preserved verbatim.
    assert "NORTHWIND LABS" in html,            "header wordmark missing"
    assert "DEVELOPER ONBOARDING" in html,       "subhead missing"
    assert "Welcome, Alex." in html,             "hero greeting missing"
    assert "your onboarding pack." in html,      "item 1 text changed"
    assert "load into Bob IDE." in html,         "item 2 text changed"
    assert "See you on 2026-10-05." in html,     "closing line changed"

    # Layout checks.
    assert html.count("<ol") == 2,               "expected 2 ordered lists (attachments + steps)"
    assert html.count("<li") == 4,               "expected 4 list items total"
    assert 'href="https://bob.ibm.com/download"' in html, "URL not linkified"

    # Brand palette present.
    assert "#111111" in html,  "header bg colour missing"
    assert "#f5b800" in html,  "accent colour missing"

    # Plain text untouched — no wording introduced.
    assert "Hi Alex," in html,                   "greeting must appear unchanged"
    print("  PASS test_html_body_structure")


def test_html_body_escaping():
    """Special HTML characters in the plain body are escaped."""
    body = "Hi Bob,\n\nSend <script>alert(1)</script> & 'quotes'."
    html = srv._html_body(body)
    assert "<script>" not in html
    assert "&lt;script&gt;" in html
    assert "&amp;" in html
    print("  PASS test_html_body_escaping")


def test_html_body_no_name():
    """_html_body works when the greeting doesn't start with 'Hi'."""
    body = "Hello,\n\nPlain body with no named greeting."
    html = srv._html_body(body, subject="Onboarding", brand_name="Northwind Labs")
    assert "NORTHWIND LABS" in html
    assert "Onboarding" in html   # subject used as fallback in hero
    print("  PASS test_html_body_no_name")


# ---------------------------------------------------------------------------
# Runner
# ---------------------------------------------------------------------------

def test_html_body_brand_is_parameter():
    """Core has no built-in company: default is neutral, brand comes from the call."""
    plain = "Hi Sam,\n\nWelcome."
    d = srv._html_body(plain, "Welcome")
    assert "NORTHWIND" not in d and "ONBOARDING" in d
    b = srv._html_body(plain, "Welcome", brand_name="Acme <Co>", brand_accent="#00aa55")
    assert "ACME &LT;CO&GT;" in b.upper() and "#00aa55" in b
    assert "#f5b800" in srv._html_body(plain, "W", brand_accent="red;evil"), "bad accent must fall back"


TESTS = [
    test_initialize,
    test_initialized_notification,
    test_tools_list,
    test_dry_run_call,
    test_dry_run_with_attachment,
    test_missing_required_fields,
    test_unknown_tool,
    test_unknown_method,
    test_ping,
    test_send_smtp_no_creds,
    test_framing,
    test_html_body_structure,
    test_html_body_escaping,
    test_html_body_no_name,
    test_html_body_brand_is_parameter,
]


def main():
    failed = []
    for t in TESTS:
        try:
            t()
        except Exception as exc:
            print(f"  FAIL {t.__name__}: {exc}")
            failed.append(t.__name__)
    print()
    if failed:
        print(f"FAILED: {', '.join(failed)}")
        sys.exit(1)
    print(f"ALL OK ({len(TESTS)} tests)")


if __name__ == "__main__":
    main()
