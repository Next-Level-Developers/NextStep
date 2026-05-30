# NextStep — FastAPI Server & API Contract
> **Version:** 2.0 | **Backend:** FastAPI + SQLAlchemy (Async) | **Database:** PostgreSQL (AWS RDS) | **Auth:** Firebase + JWT (python-jose) | **Storage:** AWS S3 | **Deployment:** AWS EC2

> ⚠️ **MIGRATION NOTICE**
> This document supersedes `NextStep_Server_API_Contract.md` v1.0 (Django + DRF).
> The **entire backend is being rewritten** from Django to FastAPI.
> All API endpoints, response shapes, and error codes remain identical — only the server implementation changes. The Flutter app requires no changes.

---

## Table of Contents

1. [Migration Summary — Django → FastAPI](#1-migration-summary--django--fastapi)
2. [FastAPI Project Directory Structure](#2-fastapi-project-directory-structure)
3. [Tech Stack & Dependencies](#3-tech-stack--dependencies)
4. [Environment Variables (.env)](#4-environment-variables-env)
5. [Application Setup & Config](#5-application-setup--config)
6. [API Conventions](#6-api-conventions)
7. [Authentication Flow](#7-authentication-flow)
8. [Module 1 — Auth & Users](#8-module-1--auth--users)
9. [Module 2 — Onboarding & Interest Profiler](#9-module-2--onboarding--interest-profiler)
10. [Module 3 — Career Universe](#10-module-3--career-universe)
11. [Module 4 — Career Recommendations](#11-module-4--career-recommendations)
12. [Module 5 — Career Actions (Save, View, Compare)](#12-module-5--career-actions-save-view-compare)
13. [Module 6 — Roadmaps & Progress](#13-module-6--roadmaps--progress)
14. [Module 7 — AI Conversations](#14-module-7--ai-conversations-general-ai--career-ai)
15. [Module 8 — Content (Stories & Resources)](#15-module-8--content-stories--resources)
16. [Module 9 — Subscriptions & Payments](#16-module-9--subscriptions--payments)
17. [Module 10 — Notifications & Check-ins](#17-module-10--notifications--check-ins)
18. [Module 11 — Analytics Events](#18-module-11--analytics-events)
19. [Module 12 — Counsellor Dashboard](#19-module-12--counsellor-dashboard)
20. [Module 13 — Parent Share View](#20-module-13--parent-share-view)
21. [Error Reference](#21-error-reference)
22. [FastAPI Settings Overview](#22-fastapi-settings-overview)
23. [Database Migrations with Alembic](#23-database-migrations-with-alembic)
24. [Running the Server](#24-running-the-server)

---

## 1. Migration Summary — Django → FastAPI

### Why We Are Switching

| Reason | Detail |
|---|---|
| **Async-native** | FastAPI is ASGI-first. Django is WSGI-based (async support is partial). For AI streaming and concurrent DB queries, FastAPI wins. |
| **Performance** | FastAPI + uvicorn + asyncpg is significantly faster under load than Django + gunicorn + psycopg2. |
| **Type safety** | Pydantic v2 schema validation replaces DRF serializers with full Python type hints throughout. |
| **Auto-docs** | FastAPI generates interactive Swagger UI (`/docs`) and ReDoc (`/redoc`) from your code — zero manual effort. |
| **Smaller footprint** | No ORM magic, no middleware bloat. You control the stack explicitly. |

---

### What Changes (Backend Only)

| Django Concept | FastAPI Equivalent |
|---|---|
| `manage.py` | `uvicorn app.main:app` + `alembic` CLI |
| `settings.py` | `core/config.py` — Pydantic `BaseSettings` |
| `urls.py` | `APIRouter` in each module + `app.include_router()` |
| `views.py` | `routers/` — async route handler functions |
| `serializers.py` | `schemas/` — Pydantic `BaseModel` classes |
| `models.py` (Django ORM) | `models/` — SQLAlchemy 2.0 async ORM |
| `migrations/` | Alembic migrations (`alembic/versions/`) |
| `permissions.py` | FastAPI `Depends()` — dependency injection |
| `firebase_backend.py` | `core/firebase_auth.py` — async dependency |
| `SimpleJWT` | `python-jose` — JWT encoding/decoding |
| `django-filter` | Query parameter `Annotated` types in route signatures |
| `django-storages` | Direct `aioboto3` S3 client |
| `django-cors-headers` | `fastapi.middleware.cors.CORSMiddleware` |
| `gunicorn` (WSGI) | `uvicorn` (ASGI) |
| `celery` + `redis` | `celery` (still used) + `redis` (unchanged) |

### What Does NOT Change

- All API endpoint URLs are identical
- All request/response JSON shapes are identical
- All error codes and HTTP status codes are identical
- Database schema (PostgreSQL on AWS RDS) is unchanged
- AWS S3 bucket structure is unchanged
- Firebase Auth integration is unchanged
- Razorpay payment flow is unchanged
- Flutter app requires zero changes

---

## 2. FastAPI Project Directory Structure

```
nextstep_backend/
│
├── main.py                            # FastAPI app entry point
├── requirements.txt
├── pyproject.toml
├── .env                               # ← Actual env file (gitignored)
├── .env.example                       # ← Committed safe template
├── alembic.ini                        # Alembic config
├── Dockerfile
├── docker-compose.yml
│
├── alembic/                           # Database migrations (replaces Django migrations/)
│   ├── env.py
│   ├── script.py.mako
│   └── versions/
│       └── 001_initial_schema.py
│
├── core/                              # App-wide shared config
│   ├── __init__.py
│   ├── config.py                      # Pydantic BaseSettings → reads .env
│   ├── database.py                    # SQLAlchemy async engine + session factory
│   ├── dependencies.py                # Shared FastAPI Depends() functions
│   ├── firebase_auth.py               # Firebase Admin SDK init + async token verifier
│   ├── security.py                    # JWT encode/decode (python-jose)
│   ├── permissions.py                 # Permission dependencies (IsStudent, IsCounsellor…)
│   ├── s3_service.py                  # aioboto3 S3 upload helpers
│   └── exceptions.py                  # Custom HTTPException subclasses + global handler
│
├── models/                            # SQLAlchemy ORM models (DB table definitions)
│   ├── __init__.py
│   ├── user.py                        # User, StudentProfile, SchoolOrganisation, SchoolMembership
│   ├── profiler.py                    # ProfilerSession, ProfilerResponse, InterestProfile
│   ├── career.py                      # Career, CareerDomain, CareerCluster
│   ├── recommendation.py              # CareerRecommendation, CareerView, CareerSave
│   ├── roadmap.py                     # Roadmap, RoadmapStep, RoadmapStepProgress
│   ├── ai_chat.py                     # AIConversation, AIMessage
│   ├── content.py                     # RealPeopleStory, LearningResource
│   ├── subscription.py                # SubscriptionPlan, SubscriptionTransaction
│   ├── notification.py                # Notification, CheckInPrompt
│   └── analytics.py                   # AnalyticsEvent
│
├── schemas/                           # Pydantic request/response schemas (replaces serializers.py)
│   ├── __init__.py
│   ├── user.py
│   ├── profiler.py
│   ├── career.py
│   ├── recommendation.py
│   ├── roadmap.py
│   ├── ai_chat.py
│   ├── content.py
│   ├── subscription.py
│   ├── notification.py
│   └── analytics.py
│
├── routers/                           # Route handlers (replaces views.py + urls.py)
│   ├── __init__.py
│   ├── auth.py                        # /api/v1/auth/
│   ├── users.py                       # /api/v1/users/
│   ├── profiler.py                    # /api/v1/profiler/
│   ├── careers.py                     # /api/v1/careers/
│   ├── recommendations.py             # /api/v1/recommendations/
│   ├── roadmaps.py                    # /api/v1/roadmaps/
│   ├── ai_chat.py                     # /api/v1/ai/
│   ├── content.py                     # /api/v1/content/
│   ├── subscriptions.py               # /api/v1/subscriptions/
│   ├── notifications.py               # /api/v1/notifications/
│   ├── check_ins.py                   # /api/v1/check-ins/
│   ├── analytics.py                   # /api/v1/analytics/
│   ├── counsellor.py                  # /api/v1/counsellor/
│   └── share.py                       # /api/v1/share/
│
├── services/                          # Business logic (replaces DRF service layer)
│   ├── __init__.py
│   ├── scoring_engine.py              # Dimension score computation logic
│   ├── matching_engine.py             # Cosine similarity + tag overlap
│   ├── roadmap_generator.py           # Template-based roadmap generation
│   ├── ai_service.py                  # Claude API wrapper + context injection
│   ├── context_builder.py             # Builds system prompt from student profile
│   └── razorpay_service.py            # Razorpay SDK wrapper
│
├── tasks/                             # Celery async tasks (unchanged from Django version)
│   ├── __init__.py
│   ├── celery_app.py                  # Celery app init
│   ├── recommendation_tasks.py        # generate_career_recommendations
│   └── notification_tasks.py          # Push notification tasks
│
└── scripts/                           # Seed scripts (now run directly with Python)
    ├── seed_careers.py
    ├── seed_domains.py
    └── seed_questions.py
```

---

## 3. Tech Stack & Dependencies

### `requirements.txt`

```
# ── Core Framework ─────────────────────────────────────────────
fastapi==0.115.x
uvicorn[standard]==0.32.x          # ASGI server (replaces gunicorn)
python-multipart==0.0.x            # Required for file uploads (UploadFile)

# ── Database ────────────────────────────────────────────────────
sqlalchemy[asyncio]==2.0.x         # Async ORM (replaces Django ORM)
asyncpg==0.30.x                    # Async PostgreSQL driver (replaces psycopg2-binary)
alembic==1.14.x                    # Database migrations (replaces Django migrations)

# ── Auth ────────────────────────────────────────────────────────
firebase-admin==6.x                # Firebase token verification (unchanged)
python-jose[cryptography]==3.x     # JWT encode/decode (replaces djangorestframework-simplejwt)
passlib[bcrypt]==1.7.x             # Password hashing utilities

# ── AWS ─────────────────────────────────────────────────────────
aioboto3==13.x                     # Async S3 client (replaces django-storages + boto3)
boto3==1.x                         # Sync fallback for scripts

# ── Config & Env ────────────────────────────────────────────────
pydantic-settings==2.x             # Reads .env into BaseSettings (replaces python-decouple)
pydantic==2.x                      # Request/response validation (replaces DRF serializers)

# ── AI ──────────────────────────────────────────────────────────
anthropic==0.x                     # Claude API SDK (unchanged)

# ── Payments ────────────────────────────────────────────────────
razorpay==1.x                      # Razorpay SDK (unchanged)

# ── Async Tasks ─────────────────────────────────────────────────
celery==5.x                        # Async task queue (unchanged)
redis==5.x                         # Celery broker + caching (unchanged)

# ── HTTP Client (for internal service calls) ─────────────────────
httpx==0.28.x                      # Async HTTP client

# ── Utilities ───────────────────────────────────────────────────
Pillow==11.x                       # Image handling
python-slugify==8.x                # Slug generation
```

---

## 4. Environment Variables (.env)

Create `.env` in the project root. **Never commit this file.**

```bash
# ──────────────────────────────────────────────────────────────
# NextStep — FastAPI Environment Configuration
# Copy this file to .env and fill in all values.
# Do NOT commit .env to version control.
# ──────────────────────────────────────────────────────────────

# ── App ────────────────────────────────────────────────────────
APP_ENV=development                           # development | production
APP_SECRET_KEY=your-super-secret-key-here     # Used for JWT signing — use a 64+ char random string
APP_DEBUG=True                                # Set False in production
ALLOWED_HOSTS=api.nextstep.app,localhost      # Comma-separated

# ── Database (AWS RDS PostgreSQL) ──────────────────────────────
DB_HOST=nextstep.xxxxxxxxxxxx.ap-south-1.rds.amazonaws.com
DB_PORT=5432
DB_NAME=nextstep_db
DB_USER=nextstep_user
DB_PASSWORD=your-rds-password-here

# Constructed automatically in config.py from the above four vars:
# DATABASE_URL=postgresql+asyncpg://nextstep_user:password@host:5432/nextstep_db

# ── JWT ────────────────────────────────────────────────────────
JWT_SECRET_KEY=your-jwt-secret-key-here       # Separate from APP_SECRET_KEY
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_MINUTES=60            # 1 hour
JWT_REFRESH_TOKEN_EXPIRE_DAYS=30

# ── AWS S3 ─────────────────────────────────────────────────────
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS_S3_BUCKET_NAME=nextstep-assets
AWS_S3_REGION=ap-south-1                      # Mumbai region

# ── Firebase Admin SDK ─────────────────────────────────────────
# Option A — Path to service account JSON file (EC2 deployment)
FIREBASE_CREDENTIALS_PATH=/home/ec2-user/firebase-service-account.json

# Option B — Inline JSON (for Docker / ECS deployments)
# FIREBASE_CREDENTIALS_JSON={"type": "service_account", "project_id": "nextstep-xxx", ...}

# ── Anthropic Claude AI ────────────────────────────────────────
ANTHROPIC_API_KEY=sk-ant-api03-xxxxxxxxxxxxxxxxxxxxxxxx
AI_MODEL=claude-sonnet-4-20250514
AI_MAX_TOKENS=1000
AI_FREE_DAILY_MESSAGE_LIMIT=5

# ── Razorpay ───────────────────────────────────────────────────
RAZORPAY_KEY_ID=rzp_live_XXXXXXXXXXXX
RAZORPAY_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# ── Redis (Celery broker + caching) ────────────────────────────
REDIS_URL=redis://localhost:6379/0
# For AWS ElastiCache:
# REDIS_URL=redis://your-cluster.xxxxxx.ng.0001.apse1.cache.amazonaws.com:6379/0

# ── CORS ───────────────────────────────────────────────────────
CORS_ORIGINS=http://localhost:8080,https://nextstep.app
```

---

## 5. Application Setup & Config

### `core/config.py` — Pydantic BaseSettings

This replaces Django's `settings/base.py`, `settings/development.py`, and `settings/production.py`.
Pydantic automatically reads values from the `.env` file.

```python
from pydantic_settings import BaseSettings, SettingsConfigDict
from functools import lru_cache
from typing import List


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    # App
    APP_ENV: str = "development"
    APP_SECRET_KEY: str
    APP_DEBUG: bool = False
    ALLOWED_HOSTS: List[str] = ["localhost"]

    # Database
    DB_HOST: str
    DB_PORT: int = 5432
    DB_NAME: str
    DB_USER: str
    DB_PASSWORD: str

    @property
    def DATABASE_URL(self) -> str:
        return f"postgresql+asyncpg://{self.DB_USER}:{self.DB_PASSWORD}@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"

    # JWT
    JWT_SECRET_KEY: str
    JWT_ALGORITHM: str = "HS256"
    JWT_ACCESS_TOKEN_EXPIRE_MINUTES: int = 60
    JWT_REFRESH_TOKEN_EXPIRE_DAYS: int = 30

    # AWS S3
    AWS_ACCESS_KEY_ID: str
    AWS_SECRET_ACCESS_KEY: str
    AWS_S3_BUCKET_NAME: str
    AWS_S3_REGION: str = "ap-south-1"

    # Firebase
    FIREBASE_CREDENTIALS_PATH: str | None = None
    FIREBASE_CREDENTIALS_JSON: str | None = None

    # AI (Anthropic)
    ANTHROPIC_API_KEY: str
    AI_MODEL: str = "claude-sonnet-4-20250514"
    AI_MAX_TOKENS: int = 1000
    AI_FREE_DAILY_MESSAGE_LIMIT: int = 5

    # Razorpay
    RAZORPAY_KEY_ID: str
    RAZORPAY_SECRET: str

    # Redis / Celery
    REDIS_URL: str = "redis://localhost:6379/0"

    # CORS
    CORS_ORIGINS: List[str] = ["http://localhost:8080", "https://nextstep.app"]


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
```

---

### `core/database.py` — Async SQLAlchemy Engine

Replaces Django's `DATABASES` setting and ORM connection management.

```python
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.orm import DeclarativeBase
from core.config import settings

engine = create_async_engine(
    settings.DATABASE_URL,
    pool_size=10,
    max_overflow=20,
    pool_pre_ping=True,          # Reconnect on stale RDS connections
    echo=settings.APP_DEBUG,     # Logs SQL in dev; disable in production
)

AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    expire_on_commit=False,
    class_=AsyncSession,
)


class Base(DeclarativeBase):
    pass


async def get_db() -> AsyncSession:
    """FastAPI dependency — injects a DB session into route handlers."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
```

---

### `main.py` — FastAPI Application Entry Point

Replaces Django's `nextstep/urls.py` + `wsgi.py` + `asgi.py`.

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from core.config import settings
from core.exceptions import nextstep_exception_handler, NexStepException
from routers import (
    auth, users, profiler, careers, recommendations,
    roadmaps, ai_chat, content, subscriptions,
    notifications, check_ins, analytics, counsellor, share,
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: initialise Firebase Admin SDK
    from core.firebase_auth import init_firebase
    init_firebase()
    yield
    # Shutdown: close DB connections
    from core.database import engine
    await engine.dispose()


app = FastAPI(
    title="NextStep API",
    version="2.0.0",
    description="Career discovery platform — FastAPI backend",
    docs_url="/docs" if settings.APP_DEBUG else None,   # Disable Swagger in production
    redoc_url="/redoc" if settings.APP_DEBUG else None,
    lifespan=lifespan,
)

# ── CORS ────────────────────────────────────────────────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Global Exception Handler ────────────────────────────────────
app.add_exception_handler(NexStepException, nextstep_exception_handler)

# ── Routers (all prefixed at /api/v1/) ─────────────────────────
API_V1 = "/api/v1"

app.include_router(auth.router,            prefix=f"{API_V1}/auth",           tags=["Auth"])
app.include_router(users.router,           prefix=f"{API_V1}/users",          tags=["Users"])
app.include_router(profiler.router,        prefix=f"{API_V1}/profiler",       tags=["Profiler"])
app.include_router(careers.router,         prefix=f"{API_V1}/careers",        tags=["Careers"])
app.include_router(recommendations.router, prefix=f"{API_V1}/recommendations",tags=["Recommendations"])
app.include_router(roadmaps.router,        prefix=f"{API_V1}/roadmaps",       tags=["Roadmaps"])
app.include_router(ai_chat.router,         prefix=f"{API_V1}/ai",             tags=["AI Chat"])
app.include_router(content.router,         prefix=f"{API_V1}/content",        tags=["Content"])
app.include_router(subscriptions.router,   prefix=f"{API_V1}/subscriptions",  tags=["Subscriptions"])
app.include_router(notifications.router,   prefix=f"{API_V1}/notifications",  tags=["Notifications"])
app.include_router(check_ins.router,       prefix=f"{API_V1}/check-ins",      tags=["Check-ins"])
app.include_router(analytics.router,       prefix=f"{API_V1}/analytics",      tags=["Analytics"])
app.include_router(counsellor.router,      prefix=f"{API_V1}/counsellor",     tags=["Counsellor"])
app.include_router(share.router,           prefix=f"{API_V1}/share",          tags=["Share"])


@app.get("/health")
async def health_check():
    return {"status": "ok", "version": "2.0.0"}
```

---

### `core/dependencies.py` — Auth Dependencies

Replaces DRF `authentication_classes` and `permission_classes` on each view.

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession
from core.database import get_db
from core.security import decode_access_token
from models.user import User
from uuid import UUID

bearer_scheme = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: AsyncSession = Depends(get_db),
) -> User:
    """Validates Bearer JWT and returns the authenticated User row."""
    token = credentials.credentials
    payload = decode_access_token(token)   # Raises 401 if invalid/expired
    user_id: UUID = payload.get("sub")
    user = await db.get(User, user_id)
    if not user or not user.is_active:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")
    return user


async def require_student(current_user: User = Depends(get_current_user)) -> User:
    if current_user.user_type != "student":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Students only")
    return current_user


async def require_counsellor(current_user: User = Depends(get_current_user)) -> User:
    if current_user.user_type != "counsellor":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Counsellors only")
    return current_user


async def require_premium(current_user: User = Depends(get_current_user)) -> User:
    if current_user.subscription_tier == "free":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="SUBSCRIPTION_REQUIRED")
    return current_user
```

---

## 6. API Conventions

### Base URL
```
https://api.nextstep.app/api/v1/
```

### Request Headers (all authenticated endpoints)

```
Authorization: Bearer <jwt_token>
Content-Type: application/json
Accept: application/json
X-App-Version: 1.0.0          # Optional: Flutter app version
```

### Standard Response Envelope

All responses follow this envelope (implemented as a Pydantic generic):

```json
{
  "success": true,
  "data": { ... },
  "message": "Optional human-readable message"
}
```

```python
# schemas/base.py
from pydantic import BaseModel
from typing import Generic, TypeVar, Optional

T = TypeVar("T")

class APIResponse(BaseModel, Generic[T]):
    success: bool = True
    data: T
    message: Optional[str] = None
```

### Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "PROFILER_SESSION_NOT_FOUND",
    "message": "No active profiler session found for this user.",
    "details": {}
  }
}
```

```python
# core/exceptions.py
from fastapi import Request
from fastapi.responses import JSONResponse

class NexStepException(Exception):
    def __init__(self, code: str, message: str, http_status: int, details: dict = {}):
        self.code = code
        self.message = message
        self.http_status = http_status
        self.details = details

async def nextstep_exception_handler(request: Request, exc: NexStepException):
    return JSONResponse(
        status_code=exc.http_status,
        content={"success": False, "error": {"code": exc.code, "message": exc.message, "details": exc.details}},
    )
```

### Pagination (list endpoints)

```json
{
  "success": true,
  "data": {
    "count": 305,
    "next": "https://api.nextstep.app/api/v1/careers/?page=2",
    "previous": null,
    "results": [ ... ]
  }
}
```

Query params: `?page=1&page_size=20`

```python
# core/pagination.py
from fastapi import Query
from typing import Annotated

PageParam     = Annotated[int, Query(ge=1, default=1)]
PageSizeParam = Annotated[int, Query(ge=1, le=50, default=20)]
```

### HTTP Status Codes Used

| Code | Meaning |
|---|---|
| `200` | OK — successful GET / PATCH |
| `201` | Created — successful POST |
| `204` | No Content — successful DELETE |
| `400` | Bad Request — validation error |
| `401` | Unauthorized — missing or invalid token |
| `403` | Forbidden — authenticated but insufficient permission |
| `404` | Not Found |
| `409` | Conflict — e.g. resource already exists |
| `422` | Unprocessable — business logic error |
| `429` | Rate Limited |
| `500` | Internal Server Error |

> **FastAPI Note:** FastAPI automatically returns `422 Unprocessable Entity` for Pydantic validation failures (missing fields, wrong types). This matches our existing error format.

---

## 7. Authentication Flow

NextStep uses **Firebase Auth** for identity and **python-jose JWT** for API access tokens.

### Step 1 — Firebase Login (Flutter side)
Flutter calls Firebase directly. Firebase returns a **Firebase ID Token**.

### Step 2 — Exchange for NextStep JWT

```
POST /api/v1/auth/firebase/
```

Flutter sends Firebase ID Token. Server verifies via Firebase Admin SDK, creates/retrieves the `User` row, and returns a NextStep JWT pair.

**Request Body:**
```json
{
  "firebase_token": "eyJhbGciOiJSUzI1NiIsInR5....."
}
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "access": "<jwt_access_token>",
    "refresh": "<jwt_refresh_token>",
    "is_new_user": true,
    "user": {
      "id": "uuid",
      "email": "student@example.com",
      "user_type": "student",
      "subscription_tier": "free",
      "profiler_completed": false
    }
  }
}
```

**FastAPI Route Implementation:**
```python
# routers/auth.py
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from core.database import get_db
from core.firebase_auth import verify_firebase_token
from core.security import create_access_token, create_refresh_token
from schemas.auth import FirebaseLoginRequest, AuthResponse

router = APIRouter()

@router.post("/firebase/", status_code=201, response_model=APIResponse[AuthResponse])
async def firebase_login(
    body: FirebaseLoginRequest,
    db: AsyncSession = Depends(get_db),
):
    firebase_user = await verify_firebase_token(body.firebase_token)
    user, is_new = await get_or_create_user(db, firebase_user)
    return {
        "success": True,
        "data": {
            "access": create_access_token(str(user.id)),
            "refresh": create_refresh_token(str(user.id)),
            "is_new_user": is_new,
            "user": user,
        }
    }
```

### Step 3 — Refresh Token

```
POST /api/v1/auth/token/refresh/
```

**Request Body:**
```json
{
  "refresh": "<jwt_refresh_token>"
}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "access": "<new_access_jwt>"
  }
}
```

---

## 8. Module 1 — Auth & Users

### URLs prefix: `/api/v1/users/`

---

### `GET /api/v1/users/me/`
Get the currently authenticated user's full profile.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "3f9c1a2b-...",
    "email": "riya@example.com",
    "full_name": "Riya Sharma",
    "phone": "+91 9876543210",
    "avatar_url": "https://nextstep-assets.s3.amazonaws.com/avatars/uuid.jpg",
    "user_type": "student",
    "subscription_tier": "free",
    "subscription_expires_at": null,
    "parental_consent_given": false,
    "created_at": "2025-06-01T10:00:00Z",
    "student_profile": {
      "academic_stage": "grade_11_12_science",
      "grade_or_year": "11",
      "school_name": "Delhi Public School",
      "city": "New Delhi",
      "state": "Delhi",
      "career_clarity": "few_options",
      "pressure_level": "high",
      "profiler_completed": true,
      "profiler_completed_at": "2025-06-01T10:30:00Z"
    }
  }
}
```

---

### `PATCH /api/v1/users/me/`
Update the authenticated user's core profile fields.

**Auth:** Required

**Request Body (all fields optional):**
```json
{
  "full_name": "Riya Sharma",
  "phone": "+91 9876543210"
}
```

**Response `200`:** Same shape as `GET /api/v1/users/me/`

---

### `DELETE /api/v1/users/me/`
Soft-delete the account. Sets `is_active = false`.

**Auth:** Required | **Response `204`:** Empty body

---

### `POST /api/v1/users/me/avatar/`
Upload profile picture to S3.

**Auth:** Required

**Request:** `multipart/form-data`
```
file: <image_file>     (max 5MB, jpg/png/webp)
```

**FastAPI Note:** Use `UploadFile` — requires `python-multipart` installed.

```python
from fastapi import APIRouter, UploadFile, File, Depends
from core.s3_service import upload_avatar_to_s3

@router.post("/me/avatar/")
async def upload_avatar(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    avatar_url = await upload_avatar_to_s3(file, current_user.id)
    current_user.avatar_url = avatar_url
    await db.commit()
    return {"success": True, "data": {"avatar_url": avatar_url}}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "avatar_url": "https://nextstep-assets.s3.amazonaws.com/avatars/uuid.jpg"
  }
}
```

---

### `GET /api/v1/users/me/student-profile/`

**Auth:** Required | **Permission:** `user_type == "student"`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "user_id": "uuid",
    "academic_stage": "grade_11_12_science",
    "grade_or_year": "11",
    "school_name": "Delhi Public School",
    "city": "New Delhi",
    "state": "Delhi",
    "career_clarity": "few_options",
    "pressure_level": "high",
    "career_awareness_level": "narrow",
    "profiler_completed": true,
    "profiler_completed_at": "2025-06-01T10:30:00Z"
  }
}
```

---

### `PUT /api/v1/users/me/student-profile/`
Create or fully update the student profile (used after onboarding SC-1 → SC-3).

**Auth:** Required

**Request Body:**
```json
{
  "academic_stage": "grade_11_12_science",
  "grade_or_year": "11",
  "school_name": "Delhi Public School",
  "city": "New Delhi",
  "state": "Delhi",
  "career_clarity": "few_options",
  "pressure_level": "high",
  "career_awareness_level": "narrow"
}
```

**Enum values (validated by Pydantic):**
- `academic_stage`: `grade_8_9` | `grade_10` | `grade_11_12_science` | `grade_11_12_commerce` | `grade_11_12_arts` | `college_year_1_2`
- `career_clarity`: `clear` | `few_options` | `none` | `wants_to_explore`
- `pressure_level`: `high` | `some` | `low` | `very_high`
- `career_awareness_level`: `narrow` | `moderate` | `broad` | `focused`

**Response `200`:** Same shape as `GET /api/v1/users/me/student-profile/`

---

### `POST /api/v1/users/me/parental-consent/`

**Auth:** Required

**Request Body:**
```json
{
  "consent_given": true,
  "parent_name": "Ramesh Sharma",
  "parent_phone": "+91 9876500000"
}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "parental_consent_given": true,
    "parental_consent_at": "2025-06-01T10:00:00Z"
  }
}
```

---

### `POST /api/v1/users/me/share-token/`
Generate a shareable parent-view token.

**Auth:** Required

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "share_token": "nxt_share_abc123xyz",
    "share_url": "https://app.nextstep.app/parent-view/nxt_share_abc123xyz",
    "expires_at": "2025-07-01T00:00:00Z"
  }
}
```

---

## 9. Module 2 — Onboarding & Interest Profiler

### URLs prefix: `/api/v1/profiler/`

---

### `GET /api/v1/profiler/questions/`
Get full profiler questions set. Called once on app start, cached in Flutter.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "code": "SC-1",
      "section": "context",
      "section_label": "About You",
      "question_text": "What is your current academic stage?",
      "question_type": "single_select",
      "is_scored": false,
      "options": [
        {
          "index": 0,
          "text": "Grade 8 or 9 — Still exploring, no stream yet",
          "emoji": "🏫",
          "dimension_weights": {}
        }
      ]
    },
    {
      "code": "Q1",
      "section": "free_time",
      "section_label": "What You Do With Free Time",
      "question_text": "It's a free Saturday with zero obligations. What are you most likely doing?",
      "instruction": "Pick the one that feels most like you.",
      "question_type": "single_select",
      "is_scored": true,
      "options": [
        {
          "index": 0,
          "text": "Drawing, designing, making something visual or creative",
          "emoji": "🎨",
          "dimension_weights": { "C": 1.0 }
        },
        {
          "index": 1,
          "text": "Exploring technology — coding, building apps, tinkering with electronics",
          "emoji": "💻",
          "dimension_weights": { "T": 1.0 }
        }
      ]
    }
  ]
}
```

---

### `POST /api/v1/profiler/sessions/`
Start a new profiler session.

**Auth:** Required | **Request Body:** _(empty)_

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "session_id": "uuid",
    "session_number": 1,
    "status": "in_progress",
    "total_questions": 27,
    "questions_answered": 0,
    "started_at": "2025-06-01T10:00:00Z"
  }
}
```

---

### `GET /api/v1/profiler/sessions/{session_id}/`
Get session progress — for resuming interrupted sessions.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "session_id": "uuid",
    "session_number": 1,
    "status": "in_progress",
    "total_questions": 27,
    "questions_answered": 12,
    "questions_skipped": 1,
    "last_answered_code": "Q8",
    "started_at": "2025-06-01T10:00:00Z"
  }
}
```

---

### `POST /api/v1/profiler/sessions/{session_id}/responses/`
Submit one or more responses. Supports single or batch submission.

**Auth:** Required

**Request Body:**
```json
{
  "responses": [
    {
      "question_code": "SC-1",
      "question_section": "context",
      "selected_option_index": [1],
      "skipped": false
    },
    {
      "question_code": "Q2",
      "question_section": "free_time",
      "selected_option_index": [0, 5],
      "skipped": false
    }
  ]
}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "session_id": "uuid",
    "questions_answered": 15,
    "questions_skipped": 1,
    "progress_percent": 55
  }
}
```

---

### `POST /api/v1/profiler/sessions/{session_id}/complete/`
Finalize the session. Server runs scoring engine and triggers recommendations.

**Auth:** Required | **Request Body:** _(empty)_

**Server-side processing:**
1. Validate all required questions are answered
2. Run `scoring_engine.compute_dimension_scores(session_id)` → scores 0–100
3. Write `interest_profiles` row (`is_active = True`, deactivate previous)
4. Trigger Celery task: `generate_career_recommendations.delay(user_id, profile_id)`
5. Set `student_profiles.profiler_completed = True`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "session_id": "uuid",
    "status": "completed",
    "time_taken_seconds": 342,
    "interest_profile": {
      "id": "uuid",
      "dimension_scores": {
        "C": 82, "A": 74, "T": 68, "S": 41, "E": 35, "P": 12
      },
      "top_dimensions": ["C", "A", "T"],
      "computed_at": "2025-06-01T10:05:42Z"
    },
    "recommendations_ready": false,
    "recommendations_eta_seconds": 3
  }
}
```

---

### `GET /api/v1/profiler/profile/`
Get active interest profile for the current user.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "session_id": "uuid",
    "is_active": true,
    "dimension_scores": {
      "C": 82, "A": 74, "T": 68, "S": 41, "E": 35, "P": 12
    },
    "top_dimensions": ["C", "A", "T"],
    "career_cluster_weights": {
      "Design & Visual Arts": 0.87,
      "Gaming & Animation": 0.81,
      "AI & Data Science": 0.72
    },
    "awareness_known_careers": ["UX Designer", "Robotics Engineer"],
    "computed_at": "2025-06-01T10:05:42Z"
  }
}
```

---

## 10. Module 3 — Career Universe

### URLs prefix: `/api/v1/careers/`

---

### `GET /api/v1/careers/`
List careers with filtering, sorting, and search.

**Auth:** Required

**Query Parameters:**

| Parameter | Type | Description |
|---|---|---|
| `search` | string | Full-text search on `name`, `one_liner`, `skills_needed` |
| `domain_slug` | string | Filter by domain, e.g. `technology-software` |
| `dimension_tags` | string (comma) | Filter by tags, e.g. `C,A` (OR match) |
| `india_viability` | string | `very_high`, `high`, `medium`, `low` |
| `future_score_min` | int | Minimum future score (1–10) |
| `is_emerging` | bool | `true` to show future careers only |
| `ordering` | string | `future_score`, `-future_score`, `name` |
| `page` | int | Pagination |
| `page_size` | int | Default 20, max 50 |

**FastAPI Note:** Filters are declared as typed query parameters in the route signature — no external filter package needed.

```python
@router.get("/")
async def list_careers(
    search: str | None = None,
    domain_slug: str | None = None,
    dimension_tags: str | None = None,   # "C,A" → split to list
    india_viability: str | None = None,
    future_score_min: int | None = Query(None, ge=1, le=10),
    is_emerging: bool | None = None,
    ordering: str = "-future_score",
    page: PageParam = 1,
    page_size: PageSizeParam = 20,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    ...
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "count": 305,
    "next": "https://api.nextstep.app/api/v1/careers/?page=2",
    "previous": null,
    "results": [
      {
        "id": "uuid",
        "slug": "ux-designer",
        "name": "UX Designer",
        "one_liner": "You design how apps and websites feel to use.",
        "domain": {
          "id": "uuid",
          "slug": "design-visual-arts",
          "name": "Design & Visual Arts",
          "short_name": "Design"
        },
        "dimension_tags": ["C", "A", "S"],
        "india_viability": "very_high",
        "future_score": 9,
        "is_emerging": false,
        "salary_entry_lpa": "4–8",
        "salary_mid_lpa": "12–22",
        "salary_senior_lpa": "25–45"
      }
    ]
  }
}
```

---

### `GET /api/v1/careers/{slug}/`
Full career detail page.

**Auth:** Required | **Path Parameter:** `slug` — e.g. `ux-designer`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "slug": " ",
    "name": "UX Designer",
    "one_liner": "You design how apps and websites feel to use.",
    "domain": { "slug": "design-visual-arts", "name": "Design & Visual Arts", "short_name": "Design" },
    "dimension_tags": ["C", "A", "S"],
    "india_viability": "very_high",
    "future_score": 9,
    "future_score_reasoning": "Demand for UX designers in India is growing 35% year-on-year...",
    "typical_day": "Morning: Review user interview feedback...",
    "skills_needed": ["Empathy", "User Research", "Figma", "Wireframing"],
    "entry_paths": ["Any degree + portfolio", "B.Des (NID / Symbiosis)"],
    "salary_entry_lpa": "4–8",
    "salary_mid_lpa": "12–22",
    "salary_senior_lpa": "25–45",
    "is_emerging": false,
    "last_reviewed_at": "2025-03-01",
    "related_careers": [
      { "slug": "ui-designer", "name": "UI Designer", "one_liner": "...", "future_score": 8 }
    ],
    "is_saved": false,
    "user_match_score": 87
  }
}
```

---

### `GET /api/v1/careers/domains/`
List all career domains.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "slug": "technology-software",
      "name": "Technology & Software Engineering",
      "short_name": "Technology",
      "india_relevance": "very_high",
      "growth_forecast_2035": "strong",
      "entry_path_summary": "B.Tech / BCA / Self-taught / Bootcamps",
      "career_count": 22,
      "display_order": 1
    }
  ]
}
```

---

### `GET /api/v1/careers/domains/{slug}/`
Domain with all its careers.

**Auth:** Required | **Response:** Same as `GET /api/v1/careers/domains/` with a `careers` array.

---

### `GET /api/v1/careers/clusters/`
All 8 career clusters (used in Q24 and discovery mode).

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Technology, AI, Engineering",
      "q24_description": "You wake up and spend your day building digital systems...",
      "domain_count": 4,
      "career_count": 67
    }
  ]
}
```

---

### `GET /api/v1/careers/compare/`
Side-by-side comparison of 2–3 careers. Premium feature.

**Auth:** Required | **Permission:** Premium subscription (or max 1 free comparison/day)

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `slugs` | string (comma) | Yes | 2–3 career slugs, e.g. `ux-designer,ui-designer` |

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "careers": [
      {
        "slug": "ux-designer",
        "name": "UX Designer",
        "dimension_tags": ["C", "A", "S"],
        "future_score": 9,
        "india_viability": "very_high",
        "salary_entry_lpa": "4–8",
        "salary_mid_lpa": "12–22",
        "salary_senior_lpa": "25–45",
        "user_skill_overlap_count": 3,
        "user_skill_overlap": ["Analytical Thinking", "Communication"],
        "work_style": "desk_collaborative",
        "time_to_first_job_months": 24,
        "entry_difficulty": "medium"
      }
    ],
    "comparison_dimensions": ["salary", "future_score", "skill_overlap", "entry_difficulty", "india_viability"]
  }
}
```

---

## 11. Module 4 — Career Recommendations

### URLs prefix: `/api/v1/recommendations/`

---

### `GET /api/v1/recommendations/`
Personalized career matches for the current user.

**Auth:** Required

**Query Parameters:**

| Parameter | Type | Description |
|---|---|---|
| `tier` | string | `full_match` \| `partial_match` \| `discovery_match` |
| `limit` | int | Default 15, max 30 |

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "interest_profile_id": "uuid",
    "generated_at": "2025-06-01T10:05:45Z",
    "total_matches": 15,
    "recommendations": [
      {
        "rank": 1,
        "match_score": 92,
        "match_tier": "full_match",
        "tag_overlap_count": 3,
        "is_novel": true,
        "career": {
          "slug": "ux-designer",
          "name": "UX Designer",
          "one_liner": "You design how apps and websites feel to use.",
          "dimension_tags": ["C", "A", "S"],
          "domain_short_name": "Design",
          "future_score": 9,
          "india_viability": "very_high",
          "salary_entry_lpa": "4–8",
          "is_emerging": false
        }
      }
    ]
  }
}
```

**Response `422`:** Profiler not yet completed:
```json
{
  "success": false,
  "error": {
    "code": "PROFILER_NOT_COMPLETED",
    "message": "Complete the interest profiler to see your career matches."
  }
}
```

---

### `POST /api/v1/recommendations/regenerate/`
Force-regenerate recommendations (e.g. after profiler retake).

**Auth:** Required | **Request Body:** _(empty)_

**Response `200`:**
```json
{
  "success": true,
  "data": { "status": "regenerating", "eta_seconds": 3 }
}
```

---

## 12. Module 5 — Career Actions (Save, View, Compare)

---

### `GET /api/v1/recommendations/saved/`
Get all bookmarked careers.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "count": 4,
    "results": [
      {
        "save_id": "uuid",
        "saved_at": "2025-06-02T09:12:00Z",
        "notes": "Looks great, research more",
        "career": {
          "slug": "ux-designer",
          "name": "UX Designer",
          "future_score": 9,
          "domain_short_name": "Design",
          "salary_entry_lpa": "4–8"
        }
      }
    ]
  }
}
```

---

### `POST /api/v1/careers/{slug}/save/`
Bookmark a career.

**Auth:** Required

**Request Body (optional):**
```json
{ "notes": "Looks interesting — research more" }
```

**Response `201`:**
```json
{
  "success": true,
  "data": { "save_id": "uuid", "career_slug": "ux-designer", "saved_at": "2025-06-02T09:12:00Z" }
}
```

**Response `409`:** Already saved.

---

### `DELETE /api/v1/careers/{slug}/save/`
Remove bookmark. **Auth:** Required | **Response `204`:** Empty body

---

### `PATCH /api/v1/careers/{slug}/save/`
Update notes on a saved career.

**Auth:** Required

**Request Body:**
```json
{ "notes": "Updated note after reading roadmap" }
```

**Response `200`:**
```json
{
  "success": true,
  "data": { "save_id": "uuid", "notes": "Updated note after reading roadmap" }
}
```

---

### `POST /api/v1/careers/{slug}/view/`
Track career view. Fire-and-forget from Flutter.

**Auth:** Required

**Request Body:**
```json
{
  "source": "recommendation",
  "time_spent_seconds": 45,
  "reached_roadmap": false
}
```

**Enum `source`:** `recommendation` | `search` | `related` | `ai_suggestion` | `saved` | `domain_browse`

**Response `201`:**
```json
{ "success": true, "data": { "view_id": "uuid" } }
```

---

## 13. Module 6 — Roadmaps & Progress

### URLs prefix: `/api/v1/roadmaps/`

---

### `GET /api/v1/roadmaps/`
List all roadmaps for the current user.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "career": { "slug": "ux-designer", "name": "UX Designer", "domain_short_name": "Design" },
      "academic_stage": "grade_11_12_science",
      "generation_method": "template",
      "is_active": true,
      "total_steps": 12,
      "completed_steps": 3,
      "completion_percent": 25,
      "generated_at": "2025-06-01T10:10:00Z"
    }
  ]
}
```

---

### `POST /api/v1/roadmaps/`
Generate a roadmap for a specific career.

**Auth:** Required

**Request Body:**
```json
{ "career_slug": "ux-designer" }
```

**Server logic:**
1. Check for existing active roadmap for `(user_id, career_id)` → return existing
2. Fetch template steps for `(career_slug, academic_stage)`
3. Create `Roadmap` + `RoadmapStep` records
4. Return full roadmap

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "career": { "slug": "ux-designer", "name": "UX Designer" },
    "academic_stage": "grade_11_12_science",
    "generation_method": "template",
    "is_active": true,
    "generated_at": "2025-06-01T10:10:00Z",
    "steps": [
      {
        "id": "uuid",
        "step_order": 1,
        "category": "first_30_days",
        "title": "Complete the Google UX Design Certificate introduction module",
        "description": "Start with the free audit track on Coursera. Takes about 3 hours.",
        "timeframe": "30 days",
        "resource_url": "https://www.coursera.org/learn/foundations-user-experience-design",
        "resource_label": "Google UX Design Certificate — Coursera",
        "is_premium": false,
        "status": "not_started",
        "completed_at": null
      }
    ]
  }
}
```

**Step `category` enums:** `first_30_days` | `subject_focus` | `skill_to_learn` | `project_to_build` | `internship` | `certification` | `college_target` | `alternative_path`

---

### `GET /api/v1/roadmaps/{roadmap_id}/`
Get a roadmap with all steps and progress.

**Auth:** Required | **Response:** Same as `POST /api/v1/roadmaps/` response.

---

### `PATCH /api/v1/roadmaps/{roadmap_id}/steps/{step_id}/progress/`
Update progress on a roadmap step.

**Auth:** Required

**Request Body:**
```json
{ "status": "completed", "notes": "Done! Took me 2 weeks." }
```

**Enum `status`:** `not_started` | `in_progress` | `completed`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "step_id": "uuid",
    "status": "completed",
    "completed_at": "2025-06-15T14:00:00Z",
    "roadmap_completion_percent": 33
  }
}
```

---

### `GET /api/v1/roadmaps/progress-summary/`
Summary across all roadmaps. Used for the Progress Tracker dashboard.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "active_roadmaps": 2,
    "total_steps_across_all": 24,
    "completed_steps": 5,
    "overall_completion_percent": 21,
    "roadmaps": [
      {
        "id": "uuid",
        "career_name": "UX Designer",
        "total_steps": 12,
        "completed_steps": 3,
        "completion_percent": 25,
        "next_step": {
          "id": "uuid",
          "title": "Learn Figma basics",
          "category": "skill_to_learn",
          "timeframe": "30 days"
        }
      }
    ],
    "interest_profile_summary": {
      "top_dimensions": ["C", "A", "T"],
      "dimension_scores": { "C": 82, "A": 74, "T": 68, "S": 41, "E": 35, "P": 12 }
    },
    "top_3_matched_careers": ["ux-designer", "product-designer", "motion-graphics-designer"]
  }
}
```

---

## 14. Module 7 — AI Conversations (General AI + Career AI)

### URLs prefix: `/api/v1/ai/`

| Type | `conversation_type` | Context Injected | Purpose |
|---|---|---|---|
| **General AI** | `general` | Interest profile + academic stage + saved careers | Personalized career guidance |
| **Career AI** | `career_specific` | Above + full career record | Deep Q&A about one specific career |

---

### `GET /api/v1/ai/conversations/`
List all AI conversations.

**Auth:** Required | **Query Params:** `?conversation_type=general`

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "conversation_type": "career_specific",
      "career": { "slug": "ux-designer", "name": "UX Designer" },
      "title": "What skills do I need to become a UX Designer?",
      "message_count": 6,
      "last_message_at": "2025-06-02T12:30:00Z",
      "is_active": true
    }
  ]
}
```

---

### `POST /api/v1/ai/conversations/`
Start a new AI conversation.

**Auth:** Required

**Request Body:**
```json
{
  "conversation_type": "career_specific",
  "career_slug": "ux-designer",
  "first_message": "I'm in Grade 11 Science. What is UX Design and how do I start?"
}
```

**FastAPI Route (async):**
```python
@router.post("/conversations/", status_code=201)
async def start_conversation(
    body: StartConversationRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    # 1. Fetch student profile + interest profile
    # 2. Optionally fetch career record
    # 3. Build system prompt via context_builder
    # 4. Call Anthropic SDK (async)
    response = await anthropic_client.messages.create(
        model=settings.AI_MODEL,
        max_tokens=settings.AI_MAX_TOKENS,
        system=system_prompt,
        messages=[{"role": "user", "content": body.first_message}],
    )
    # 5. Save conversation + messages
    ...
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "conversation_id": "uuid",
    "conversation_type": "career_specific",
    "career": { "slug": "ux-designer", "name": "UX Designer" },
    "title": "I'm in Grade 11 Science. What is UX Design and how do I start?",
    "messages": [
      {
        "id": "uuid",
        "role": "user",
        "content": "I'm in Grade 11 Science. What is UX Design and how do I start?",
        "created_at": "2025-06-02T12:00:00Z"
      },
      {
        "id": "uuid",
        "role": "assistant",
        "content": "Great question! UX Design is about making apps and websites feel easy...",
        "tokens_used": 312,
        "model_version": "claude-sonnet-4-20250514",
        "created_at": "2025-06-02T12:00:03Z"
      }
    ]
  }
}
```

---

### `GET /api/v1/ai/conversations/{conversation_id}/`
Get conversation with full message history.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "conversation_id": "uuid",
    "conversation_type": "career_specific",
    "career": { "slug": "ux-designer", "name": "UX Designer" },
    "title": "What skills do I need?",
    "message_count": 6,
    "started_at": "2025-06-02T12:00:00Z",
    "last_message_at": "2025-06-02T12:30:00Z",
    "messages": [
      { "id": "uuid", "role": "user", "content": "...", "created_at": "..." },
      { "id": "uuid", "role": "assistant", "content": "...", "created_at": "..." }
    ]
  }
}
```

---

### `POST /api/v1/ai/conversations/{conversation_id}/messages/`
Send a new message to an existing conversation.

**Auth:** Required

**Request Body:**
```json
{ "content": "What degree should I study to become a UX Designer?" }
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "user_message": {
      "id": "uuid",
      "role": "user",
      "content": "What degree should I study to become a UX Designer?",
      "created_at": "2025-06-02T12:05:00Z"
    },
    "assistant_message": {
      "id": "uuid",
      "role": "assistant",
      "content": "The great news is that UX Design doesn't require a specific degree...",
      "tokens_used": 287,
      "model_version": "claude-sonnet-4-20250514",
      "created_at": "2025-06-02T12:05:02Z"
    }
  }
}
```

**Error `403`:** Free tier daily limit reached:
```json
{
  "success": false,
  "error": {
    "code": "AI_MESSAGE_LIMIT_REACHED",
    "message": "You've used your free AI messages for today. Upgrade to Premium for unlimited access.",
    "upgrade_url": "/api/v1/subscriptions/plans/"
  }
}
```

---

### `DELETE /api/v1/ai/conversations/{conversation_id}/`
Soft-delete a conversation.

**Auth:** Required | **Response `204`:** Empty body

---

## 15. Module 8 — Content (Stories & Resources)

---

### `GET /api/v1/careers/{slug}/stories/`
Real people stories for a specific career.

**Auth:** Required | Free tier: 1 story; Premium: all

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "career_slug": "ux-designer",
    "stories": [
      {
        "id": "uuid",
        "person_name": "Shreya",
        "person_age": 27,
        "person_city": "Pune",
        "person_background": "Studied Commerce, no design degree",
        "story_text": "I studied Commerce. Everyone told me to do CA...",
        "is_premium": false
      },
      {
        "id": "uuid",
        "person_name": "Arjun",
        "story_text": null,
        "is_premium": true,
        "locked": true
      }
    ]
  }
}
```

---

### `GET /api/v1/careers/{slug}/resources/`
Curated learning resources for a specific career.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "career_slug": "ux-designer",
    "resources": [
      {
        "id": "uuid",
        "title": "Google UX Design Certificate",
        "url": "https://www.coursera.org/professional-certificates/google-ux-design",
        "provider": "Coursera",
        "resource_type": "certification",
        "is_free": true
      }
    ]
  }
}
```

---

## 16. Module 9 — Subscriptions & Payments

### URLs prefix: `/api/v1/subscriptions/`

---

### `GET /api/v1/subscriptions/plans/`
All available subscription plans.

**Auth:** Not required

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "free",
      "display_name": "Free",
      "price_paise": 0,
      "price_inr": 0,
      "duration_days": null,
      "features": {
        "career_matches": 5,
        "career_detail_full": false,
        "roadmap_steps_visible": 3,
        "ai_messages_per_day": 5,
        "stories_per_career": 1,
        "career_comparison": false,
        "parent_share": false,
        "progress_tracker": false
      }
    },
    {
      "id": "uuid",
      "name": "premium_monthly",
      "display_name": "Premium — Monthly",
      "price_paise": 29900,
      "price_inr": 299,
      "duration_days": 30,
      "features": {
        "career_matches": 999,
        "career_detail_full": true,
        "roadmap_steps_visible": 999,
        "ai_messages_per_day": 999,
        "stories_per_career": 999,
        "career_comparison": true,
        "parent_share": true,
        "progress_tracker": true
      }
    }
  ]
}
```

---

### `POST /api/v1/subscriptions/create-order/`
Create a Razorpay order. Flutter uses this to initialise the payment sheet.

**Auth:** Required

**Request Body:**
```json
{ "plan_id": "uuid" }
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "transaction_id": "uuid",
    "razorpay_order_id": "order_XXXXXXXXXX",
    "amount_paise": 29900,
    "currency": "INR",
    "razorpay_key_id": "rzp_live_XXXXXXXXXXXX"
  }
}
```

---

### `POST /api/v1/subscriptions/verify-payment/`
Verify Razorpay signature and activate subscription.

**Auth:** Required

**Request Body:**
```json
{
  "transaction_id": "uuid",
  "razorpay_order_id": "order_XXXXXXXXXX",
  "razorpay_payment_id": "pay_XXXXXXXXXX",
  "razorpay_signature": "HMAC_SHA256_SIGNATURE"
}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "subscription_tier": "premium_monthly",
    "subscription_expires_at": "2025-07-01T10:00:00Z",
    "transaction_id": "uuid",
    "payment_id": "pay_XXXXXXXXXX"
  }
}
```

---

### `GET /api/v1/subscriptions/me/`
Current user's active subscription.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "subscription_tier": "premium_monthly",
    "subscription_expires_at": "2025-07-01T10:00:00Z",
    "days_remaining": 29,
    "is_active": true,
    "plan": { "name": "premium_monthly", "display_name": "Premium — Monthly", "price_inr": 299 }
  }
}
```

---

## 17. Module 10 — Notifications & Check-ins

### URLs prefix: `/api/v1/notifications/` and `/api/v1/check-ins/`

---

### `GET /api/v1/notifications/`
All in-app notifications.

**Auth:** Required | **Query Params:** `?is_read=false`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "unread_count": 2,
    "results": [
      {
        "id": "uuid",
        "type": "roadmap_reminder",
        "title": "You have a roadmap step due",
        "body": "Time to check off 'Learn Figma basics' on your UX Designer roadmap.",
        "is_read": false,
        "sent_at": "2025-06-03T08:00:00Z",
        "read_at": null
      }
    ]
  }
}
```

---

### `PATCH /api/v1/notifications/{notification_id}/read/`
Mark notification as read.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": { "id": "uuid", "is_read": true, "read_at": "2025-06-03T09:15:00Z" }
}
```

---

### `POST /api/v1/notifications/mark-all-read/`
Mark all notifications read.

**Auth:** Required | **Response `200`:** `{ "success": true, "data": { "marked_read_count": 5 } }`

---

### `GET /api/v1/check-ins/`
Pending check-in prompts.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "prompt_type": "career_still_interested",
      "career": { "slug": "ux-designer", "name": "UX Designer" },
      "question": "It's been a month since you added UX Designer. Still feeling interested?",
      "options": [
        { "value": "still_yes", "label": "Yes, definitely!" },
        { "value": "not_sure", "label": "I'm not sure anymore" },
        { "value": "moved_on", "label": "I've moved on to something else" }
      ],
      "sent_at": "2025-07-01T08:00:00Z"
    }
  ]
}
```

---

### `POST /api/v1/check-ins/{check_in_id}/respond/`
Submit check-in response.

**Auth:** Required

**Request Body:**
```json
{ "response": "still_yes" }
```

**Enum `response`:** `still_yes` | `not_sure` | `moved_on`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "check_in_id": "uuid",
    "response": "still_yes",
    "responded_at": "2025-07-01T09:00:00Z",
    "next_action": null
  }
}
```

---

## 18. Module 11 — Analytics Events

### URLs prefix: `/api/v1/analytics/`

---

### `POST /api/v1/analytics/events/`
Log an analytics event. Fire-and-forget.

**Auth:** Required (unauthenticated: `user_id = null`)

**Request Body:**
```json
{
  "event_name": "career_viewed",
  "session_id": "flutter_session_abc123",
  "career_id": "uuid",
  "properties": {
    "source": "recommendation",
    "time_spent_seconds": 45,
    "scroll_depth_percent": 72
  }
}
```

**Standard event names:**

| Event | When |
|---|---|
| `app_opened` | App launch |
| `profiler_started` | First question shown |
| `profiler_section_completed` | Each section done |
| `profiler_completed` | Q24 submitted |
| `profiler_abandoned` | App closed mid-profiler |
| `career_map_viewed` | Recommendations screen loaded |
| `career_viewed` | Career detail page opened |
| `career_saved` | Career bookmarked |
| `career_unsaved` | Bookmark removed |
| `roadmap_generated` | Roadmap created |
| `roadmap_step_completed` | Step marked done |
| `ai_message_sent` | User sends AI message |
| `ai_conversation_started` | New AI conversation |
| `subscription_upgrade_tapped` | Upgrade CTA tapped |
| `subscription_purchased` | Payment verified |
| `check_in_responded` | Check-in answered |
| `share_profile_tapped` | Parent share button tapped |

**Response `201`:**
```json
{ "success": true, "data": { "event_id": "uuid" } }
```

---

## 19. Module 12 — Counsellor Dashboard

### URLs prefix: `/api/v1/counsellor/`

**Permission:** `user_type == "counsellor"` AND member of a `school_organisation`

---

### `GET /api/v1/counsellor/dashboard/`
Aggregated, anonymised stats for counsellor's school.

**Auth:** Required | **Permission:** `require_counsellor`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "organisation": { "id": "uuid", "name": "Delhi Public School", "type": "school", "licence_seats": 500 },
    "students_total": 342,
    "students_profiler_completed": 198,
    "profiler_completion_rate_percent": 58,
    "top_career_interests": [
      { "career_slug": "software-engineer", "career_name": "Software Engineer", "student_count": 47 },
      { "career_slug": "ux-designer", "career_name": "UX Designer", "student_count": 31 }
    ],
    "top_domains": [
      { "domain_short_name": "Technology", "student_count": 89 }
    ],
    "dimension_distribution": { "C": 45, "A": 62, "T": 78, "S": 38, "E": 22, "P": 14 }
  }
}
```

---

### `GET /api/v1/counsellor/students/`
Anonymised student list for the counsellor's organisation.

**Auth:** Required | **Permission:** `require_counsellor`

**Query Parameters:** `?profiler_completed=true` | `?academic_stage=grade_11_12_science`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "count": 342,
    "results": [
      {
        "student_id": "uuid",
        "display_name": "Student #1",
        "academic_stage": "grade_11_12_science",
        "profiler_completed": true,
        "top_matched_careers": ["Software Engineer", "Data Scientist", "AI Engineer"],
        "roadmaps_active": 1,
        "last_active_at": "2025-06-02T00:00:00Z"
      }
    ]
  }
}
```

---

## 20. Module 13 — Parent Share View

### URLs prefix: `/api/v1/share/`

---

### `GET /api/v1/share/profile/{share_token}/`
Read-only student profile for parents. **No auth required** — token is the credential.

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "student_first_name": "Riya",
    "academic_stage": "Grade 11 Science",
    "profiler_completed": true,
    "top_matched_careers": [
      {
        "rank": 1,
        "career_name": "UX Designer",
        "one_liner": "Designs how apps and websites feel to use.",
        "salary_entry_lpa": "4–8",
        "salary_senior_lpa": "25–45",
        "future_score": 9,
        "future_score_label": "High growth",
        "entry_path_summary": "Any degree + portfolio. No UPSC, no NEET."
      }
    ],
    "roadmap_summary": {
      "career_name": "UX Designer",
      "immediate_actions": [
        "Complete Google UX Design Certificate on Coursera (free)",
        "Learn Figma — free online"
      ]
    },
    "counsellor_cta": {
      "text": "Want to discuss this with a counsellor?",
      "url": "https://nextstep.app/counsellors"
    }
  }
}
```

**Response `404`:** Token expired or invalid.

---

## 21. Error Reference

### Standard Error Codes

| Code | HTTP | Description |
|---|---|---|
| `INVALID_FIREBASE_TOKEN` | 401 | Firebase token verification failed |
| `TOKEN_EXPIRED` | 401 | JWT access token expired |
| `PERMISSION_DENIED` | 403 | User type doesn't have access |
| `SUBSCRIPTION_REQUIRED` | 403 | Feature requires premium subscription |
| `PROFILER_NOT_COMPLETED` | 422 | Action requires completed profiler |
| `PROFILER_SESSION_NOT_FOUND` | 404 | Session ID doesn't exist or doesn't belong to user |
| `CAREER_NOT_FOUND` | 404 | Career slug doesn't exist |
| `ROADMAP_ALREADY_EXISTS` | 409 | Active roadmap for this career already exists |
| `ALREADY_SAVED` | 409 | Career already bookmarked |
| `AI_MESSAGE_LIMIT_REACHED` | 403 | Daily free AI message limit hit |
| `AI_SERVICE_UNAVAILABLE` | 503 | Claude API unreachable |
| `PAYMENT_SIGNATURE_INVALID` | 400 | Razorpay HMAC verification failed |
| `SHARE_TOKEN_INVALID` | 404 | Parent share token invalid or expired |
| `RATE_LIMITED` | 429 | Too many requests |
| `VALIDATION_ERROR` | 422 | Pydantic request body validation failed |
| `INTERNAL_ERROR` | 500 | Unexpected server error |

---

## 22. FastAPI Settings Overview

### `core/config.py` — Environment-based settings
See [Section 5](#5-application-setup--config) for the complete `Settings` class.

Key values at a glance:

```python
# Database
DATABASE_URL    → postgresql+asyncpg://user:pass@rds-host:5432/nextstep_db

# JWT
JWT_ALGORITHM              = "HS256"
ACCESS_TOKEN_EXPIRE        = 60 minutes
REFRESH_TOKEN_EXPIRE       = 30 days

# AWS (Mumbai)
AWS_S3_REGION              = "ap-south-1"

# AI
AI_MODEL                   = "claude-sonnet-4-20250514"
AI_MAX_TOKENS              = 1000
AI_FREE_DAILY_MESSAGE_LIMIT= 5

# Celery
REDIS_URL                  = redis://localhost:6379/0
```

### CORS

```python
# main.py — already configured
CORSMiddleware(
    allow_origins=["http://localhost:8080", "https://nextstep.app"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Firebase Init

```python
# core/firebase_auth.py
import firebase_admin
from firebase_admin import credentials, auth as firebase_auth

def init_firebase():
    if settings.FIREBASE_CREDENTIALS_PATH:
        cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
    else:
        import json
        cred = credentials.Certificate(json.loads(settings.FIREBASE_CREDENTIALS_JSON))
    firebase_admin.initialize_app(cred)

async def verify_firebase_token(token: str) -> dict:
    try:
        return firebase_auth.verify_id_token(token)
    except Exception:
        raise NexStepException(
            code="INVALID_FIREBASE_TOKEN",
            message="Firebase token verification failed.",
            http_status=401,
        )
```

---

## 23. Database Migrations with Alembic

Replaces Django's `python manage.py makemigrations` and `python manage.py migrate`.

### Initial Setup

```bash
# Install Alembic (already in requirements.txt)
pip install alembic

# Initialise Alembic in the project
alembic init alembic
```

### `alembic.ini` — Key setting

```ini
# Point at the same DB as the app
sqlalchemy.url = postgresql+asyncpg://nextstep_user:password@host:5432/nextstep_db
```

### `alembic/env.py` — Async setup

```python
from core.database import Base
from core.config import settings
import asyncio
from alembic import context
from sqlalchemy.ext.asyncio import create_async_engine

# Import all models so Alembic can detect them
import models.user, models.profiler, models.career, models.recommendation
import models.roadmap, models.ai_chat, models.content, models.subscription
import models.notification, models.analytics

target_metadata = Base.metadata

def run_migrations_online():
    connectable = create_async_engine(settings.DATABASE_URL)
    # ... async migration runner
```

### Common Commands

```bash
# Create a new migration (auto-detect model changes)
alembic revision --autogenerate -m "add_user_table"

# Apply all pending migrations
alembic upgrade head

# Roll back one migration
alembic downgrade -1

# View migration history
alembic history --verbose

# Check current DB version
alembic current
```

---

## 24. Running the Server

### Local Development

```bash
# 1. Clone the repo
git clone https://github.com/nextstep/nextstep-backend.git
cd nextstep-backend

# 2. Create virtual environment
python -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Set up environment
cp .env.example .env
# Edit .env with your actual values

# 5. Apply DB migrations
alembic upgrade head

# 6. Seed the database
python scripts/seed_careers.py
python scripts/seed_domains.py
python scripts/seed_questions.py

# 7. Start the server
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# 8. Start the Celery worker (separate terminal)
celery -A tasks.celery_app worker --loglevel=info
```

Server is available at:
- API: `http://localhost:8000/api/v1/`
- Swagger docs: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`
- Health check: `http://localhost:8000/health`

---

### Docker (Local)

```yaml
# docker-compose.yml
version: "3.9"

services:
  api:
    build: .
    command: uvicorn main:app --host 0.0.0.0 --port 8000
    ports:
      - "8000:8000"
    env_file:
      - .env
    depends_on:
      - db
      - redis

  worker:
    build: .
    command: celery -A tasks.celery_app worker --loglevel=info
    env_file:
      - .env
    depends_on:
      - redis

  db:
    image: postgres:16
    environment:
      POSTGRES_DB: nextstep_db
      POSTGRES_USER: nextstep_user
      POSTGRES_PASSWORD: localpassword
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

```bash
docker-compose up --build
```

---

### Production (AWS EC2)

```bash
# On the EC2 instance (Ubuntu 24.04)

# 1. Install Python 3.12 and dependencies
sudo apt update && sudo apt install python3.12 python3.12-venv redis-server -y

# 2. Clone and set up
git clone https://github.com/nextstep/nextstep-backend.git /home/ubuntu/nextstep
cd /home/ubuntu/nextstep
python3.12 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 3. Set up .env (copy from secrets manager or paste manually)
cp .env.example .env
nano .env    # Fill in all production values; APP_DEBUG=False

# 4. Run migrations
alembic upgrade head

# 5. Start uvicorn (production — multiple workers)
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4

# 6. Run behind Nginx (recommended)
# Nginx proxies :443 → uvicorn :8000
# Use certbot for SSL

# 7. Start Celery worker as a systemd service
# See: /etc/systemd/system/nextstep-worker.service
```

### `Dockerfile`

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

*NextStep Server & API Contract v2.0 — FastAPI Migration*
*Supersedes: NextStep_Server_API_Contract.md v1.0 (Django + DRF)*
*Aligned with: NextStep_Product_Document.md v1.0, NextStep_Database_Schema.md v1.0*
*Stack: FastAPI 0.115 + SQLAlchemy 2.0 Async | PostgreSQL (AWS RDS) | Firebase Auth | AWS EC2 | AWS S3 | Alembic | Claude AI | Razorpay | Celery + Redis*
