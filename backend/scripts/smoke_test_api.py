import json
import os
import time
import urllib.error
import urllib.request
from pathlib import Path

BASE_URL = os.environ.get("BASE_URL", "http://127.0.0.1:8000").rstrip("/")
FIREBASE_TOKEN = os.environ.get("FIREBASE_TOKEN")
REPORT_PATH = Path(__file__).resolve().parents[2] / "docs" / "SMOKE_TEST_REPORT.md"

if not FIREBASE_TOKEN:
    raise SystemExit("FIREBASE_TOKEN is not set in environment")


def request(method, path, headers=None, body=None):
    url = f"{BASE_URL}{path}"
    req_headers = headers or {}
    data = None
    if body is not None:
        data = json.dumps(body).encode("utf-8")
        req_headers.setdefault("Content-Type", "application/json")
    req = urllib.request.Request(url, data=data, headers=req_headers, method=method)
    start = time.time()
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            raw = resp.read()
            duration_ms = int((time.time() - start) * 1000)
            text = raw.decode("utf-8", errors="replace")
            return resp.status, duration_ms, text
    except urllib.error.HTTPError as e:
        duration_ms = int((time.time() - start) * 1000)
        text = e.read().decode("utf-8", errors="replace")
        return e.code, duration_ms, text
    except Exception as e:
        duration_ms = int((time.time() - start) * 1000)
        return 0, duration_ms, f"{type(e).__name__}: {e}"


def truncate(text, limit=800):
    text = text.strip()
    if len(text) <= limit:
        return text
    return text[:limit] + "..."


def redact_tokens(text):
    try:
        data = json.loads(text)
    except Exception:
        return text

    def scrub(obj):
        if isinstance(obj, dict):
            return {
                k: ("<redacted>" if k in {"access", "refresh", "firebase_token"} else scrub(v))
                for k, v in obj.items()
            }
        if isinstance(obj, list):
            return [scrub(i) for i in obj]
        return obj

    return json.dumps(scrub(data), ensure_ascii=True, indent=2)


results = []

# 1) Auth exchange
status, ms, text = request(
    "POST",
    "/api/v1/auth/firebase/",
    body={"firebase_token": FIREBASE_TOKEN},
)
results.append(("POST /api/v1/auth/firebase/", status, ms, redact_tokens(truncate(text))))

access_token = None
if status in (200, 201):
    try:
        data = json.loads(text)
        access_token = data.get("data", {}).get("access")
    except Exception:
        pass

headers_auth = {}
if access_token:
    headers_auth["Authorization"] = f"Bearer {access_token}"

# 2) Public: plans
status, ms, text = request("GET", "/api/v1/subscriptions/plans/")
results.append(("GET /api/v1/subscriptions/plans/", status, ms, redact_tokens(truncate(text))))

# 3) Users: me
status, ms, text = request("GET", "/api/v1/users/me/", headers=headers_auth)
results.append(("GET /api/v1/users/me/", status, ms, redact_tokens(truncate(text))))

# 4) Profiler: questions
status, ms, text = request("GET", "/api/v1/profiler/questions/", headers=headers_auth)
results.append(("GET /api/v1/profiler/questions/", status, ms, redact_tokens(truncate(text))))

# 5) Profiler: create session
session_id = None
status, ms, text = request("POST", "/api/v1/profiler/sessions/", headers=headers_auth)
results.append(("POST /api/v1/profiler/sessions/", status, ms, redact_tokens(truncate(text))))
if status in (200, 201):
    try:
        data = json.loads(text)
        session_id = data.get("data", {}).get("session_id")
    except Exception:
        pass

# 6) Profiler: get session
if session_id:
    status, ms, text = request(
        "GET",
        f"/api/v1/profiler/sessions/{session_id}/",
        headers=headers_auth,
    )
    results.append(("GET /api/v1/profiler/sessions/{id}/", status, ms, redact_tokens(truncate(text))))

# 7) Profiler: profile (may be 404 until completed)
status, ms, text = request("GET", "/api/v1/profiler/profile/", headers=headers_auth)
results.append(("GET /api/v1/profiler/profile/", status, ms, redact_tokens(truncate(text))))

# 8) Recommendations (may be 422 until profiler completed)
status, ms, text = request("GET", "/api/v1/recommendations/", headers=headers_auth)
results.append(("GET /api/v1/recommendations/", status, ms, redact_tokens(truncate(text))))

# 9) Careers: list
status, ms, text = request("GET", "/api/v1/careers/?page=1&page_size=5", headers=headers_auth)
results.append(("GET /api/v1/careers/", status, ms, redact_tokens(truncate(text))))

# 10) Careers: domains
status, ms, text = request("GET", "/api/v1/careers/domains/", headers=headers_auth)
results.append(("GET /api/v1/careers/domains/", status, ms, redact_tokens(truncate(text))))

# 11) Careers: clusters
status, ms, text = request("GET", "/api/v1/careers/clusters/", headers=headers_auth)
results.append(("GET /api/v1/careers/clusters/", status, ms, redact_tokens(truncate(text))))

# 12) Notifications (likely empty)
status, ms, text = request("GET", "/api/v1/notifications/", headers=headers_auth)
results.append(("GET /api/v1/notifications/", status, ms, redact_tokens(truncate(text))))

# 13) Analytics events (fire-and-forget)
status, ms, text = request(
    "POST",
    "/api/v1/analytics/events/",
    headers=headers_auth,
    body={
        "event_name": "smoke_test",
        "session_id": "smoke_test_session",
        "properties": {"source": "api_smoke"},
    },
)
results.append(("POST /api/v1/analytics/events/", status, ms, redact_tokens(truncate(text))))

REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)

lines = []
lines.append("# NextStep API Smoke Test Report")
lines.append("")
lines.append(f"- Base URL: {BASE_URL}")
lines.append("- Date: 2026-05-30")
lines.append("- Auth: Firebase exchange -> SimpleJWT access token")
lines.append("")
lines.append("## Results")
lines.append("")
lines.append("| Endpoint | Status | Time (ms) | Notes |")
lines.append("|---|---:|---:|---|")

for endpoint, status, ms, text in results:
    note = "OK" if 200 <= status < 300 else ("Expected" if status in (404, 409, 422, 403) else "Failed")
    if status == 0:
        note = "Failed"
    lines.append(f"| {endpoint} | {status} | {ms} | {note} |")

lines.append("")
lines.append("## Response Samples")
lines.append("")
for endpoint, status, ms, text in results:
    lines.append(f"### {endpoint}")
    lines.append("")
    lines.append(f"- Status: {status}")
    lines.append(f"- Time: {ms} ms")
    lines.append("")
    lines.append("```json")
    lines.append(text if text else "")
    lines.append("```")
    lines.append("")

REPORT_PATH.write_text("\n".join(lines), encoding="utf-8")
print(f"Report written to {REPORT_PATH}")
