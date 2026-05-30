"""
NextStep FastAPI Application — Main Entry Point.

Run: uvicorn main:app --reload --port 8000
"""

from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from core.config import settings
from core.exceptions import NexStepException, nextstep_exception_handler
from core.firebase_auth import init_firebase

# Import all models so SQLAlchemy knows about them
import models  # noqa: F401

# Import routers
from routers import auth, users, profiler, careers, recommendations
from routers import roadmaps, ai_chat, content, subscriptions
from routers import notifications, check_ins, analytics, counsellor, share


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Startup / shutdown lifecycle."""
    # ── Startup ────────────────────────────────────────────────
    init_firebase()
    print(f"[Start] NextStep API started (env={settings.APP_ENV})")
    yield
    # ── Shutdown ───────────────────────────────────────────────
    print("[Shutdown] NextStep API shutting down")


app = FastAPI(
    title="NextStep API",
    description="Career guidance platform for Indian students — FastAPI backend",
    version="2.0.0",
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
)

# ── CORS ───────────────────────────────────────────────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Global Exception Handler ──────────────────────────────────
app.add_exception_handler(NexStepException, nextstep_exception_handler)


# ── Unhandled Exception Handler ───────────────────────────────
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Catch-all for unhandled exceptions."""
    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "error": {
                "code": "INTERNAL_ERROR",
                "message": "An unexpected error occurred." if not settings.APP_DEBUG else str(exc),
                "details": {},
            },
        },
    )


# ── Mount Routers ─────────────────────────────────────────────
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Auth"])
app.include_router(users.router, prefix="/api/v1/users", tags=["Users"])
app.include_router(profiler.router, prefix="/api/v1/profiler", tags=["Profiler"])
app.include_router(careers.router, prefix="/api/v1/careers", tags=["Careers"])
app.include_router(recommendations.router, prefix="/api/v1/recommendations", tags=["Recommendations"])
app.include_router(roadmaps.router, prefix="/api/v1/roadmaps", tags=["Roadmaps"])
app.include_router(ai_chat.router, prefix="/api/v1/ai", tags=["AI Chat"])
app.include_router(content.router, prefix="/api/v1/content", tags=["Content"])
app.include_router(subscriptions.router, prefix="/api/v1/subscriptions", tags=["Subscriptions"])
app.include_router(notifications.router, prefix="/api/v1/notifications", tags=["Notifications"])
app.include_router(check_ins.router, prefix="/api/v1/check-ins", tags=["Check-Ins"])
app.include_router(analytics.router, prefix="/api/v1/analytics", tags=["Analytics"])
app.include_router(counsellor.router, prefix="/api/v1/counsellor", tags=["Counsellor"])
app.include_router(share.router, prefix="/api/v1/share", tags=["Share"])


# ── Health Check ──────────────────────────────────────────────
@app.get("/health", tags=["Health"])
async def health_check():
    return {"status": "ok", "version": "2.0.0", "env": settings.APP_ENV}
