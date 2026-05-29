# NextStep — Django Server & API Contract
> **Version:** 1.0 | **Backend:** Django + DRF | **Database:** PostgreSQL (AWS RDS) | **Auth:** Firebase + DRF SimpleJWT | **Storage:** AWS S3 | **Deployment:** AWS EC2

---

## Table of Contents

1. [Django Project Directory Structure](#1-django-project-directory-structure)
2. [Tech Stack & Dependencies](#2-tech-stack--dependencies)
3. [API Conventions](#3-api-conventions)
4. [Authentication Flow](#4-authentication-flow)
5. [Module 1 — Auth & Users](#5-module-1--auth--users)
6. [Module 2 — Onboarding & Interest Profiler](#6-module-2--onboarding--interest-profiler)
7. [Module 3 — Career Universe](#7-module-3--career-universe)
8. [Module 4 — Career Recommendations](#8-module-4--career-recommendations)
9. [Module 5 — Career Actions (Save, View, Compare)](#9-module-5--career-actions-save-view-compare)
10. [Module 6 — Roadmaps & Progress](#10-module-6--roadmaps--progress)
11. [Module 7 — AI Conversations (General AI + Career AI)](#11-module-7--ai-conversations-general-ai--career-ai)
12. [Module 8 — Content (Stories & Resources)](#12-module-8--content-stories--resources)
13. [Module 9 — Subscriptions & Payments](#13-module-9--subscriptions--payments)
14. [Module 10 — Notifications & Check-ins](#14-module-10--notifications--check-ins)
15. [Module 11 — Analytics Events](#15-module-11--analytics-events)
16. [Module 12 — Counsellor Dashboard](#16-module-12--counsellor-dashboard)
17. [Module 13 — Parent Share View](#17-module-13--parent-share-view)
18. [Error Reference](#18-error-reference)
19. [Django Settings Overview](#19-django-settings-overview)

---

## 1. Django Project Directory Structure

```
nextstep_backend/
│
├── manage.py
├── requirements.txt
├── .env.example
├── Dockerfile
├── docker-compose.yml
│
├── nextstep/                          # Core Django project config
│   ├── __init__.py
│   ├── urls.py                        # Root URL router → api/v1/
│   ├── wsgi.py
│   ├── asgi.py
│   └── settings/
│       ├── __init__.py
│       ├── base.py                    # Common settings
│       ├── development.py             # Local dev overrides
│       └── production.py             # AWS EC2 / production settings
│
├── apps/                              # All Django apps live here
│   │
│   ├── users/                         # AUTH & USER MANAGEMENT
│   │   ├── models.py                  # User, StudentProfile, SchoolOrganisation, SchoolMembership
│   │   ├── serializers.py
│   │   ├── views.py                   # Auth, Me, StudentProfile endpoints
│   │   ├── urls.py                    # /api/v1/auth/, /api/v1/users/
│   │   ├── permissions.py             # IsStudent, IsCounsellor, IsSchoolAdmin
│   │   ├── firebase_backend.py        # Firebase token → Django user
│   │   └── migrations/
│   │
│   ├── profiler/                      # INTEREST PROFILER
│   │   ├── models.py                  # ProfilerSession, ProfilerResponse, InterestProfile
│   │   ├── serializers.py
│   │   ├── views.py                   # Session CRUD, answer submission, completion
│   │   ├── urls.py                    # /api/v1/profiler/
│   │   ├── scoring_engine.py          # Dimension score computation logic
│   │   └── migrations/
│   │
│   ├── careers/                       # CAREER UNIVERSE
│   │   ├── models.py                  # Career, CareerDomain, CareerCluster
│   │   ├── serializers.py             # List vs Detail serializers
│   │   ├── views.py                   # List, Detail, Search, Compare, Domain views
│   │   ├── urls.py                    # /api/v1/careers/
│   │   ├── filters.py                 # DRF filter backends
│   │   └── migrations/
│   │
│   ├── recommendations/               # MATCHING ENGINE
│   │   ├── models.py                  # CareerRecommendation, CareerView, CareerSave
│   │   ├── serializers.py
│   │   ├── views.py                   # Recommendations, save/unsave, view tracking
│   │   ├── urls.py                    # /api/v1/recommendations/
│   │   ├── matching_engine.py         # Cosine similarity + tag overlap logic
│   │   └── migrations/
│   │
│   ├── roadmaps/                      # ROADMAPS & PROGRESS
│   │   ├── models.py                  # Roadmap, RoadmapStep, RoadmapStepProgress
│   │   ├── serializers.py
│   │   ├── views.py                   # Generate, list, detail, step progress
│   │   ├── urls.py                    # /api/v1/roadmaps/
│   │   ├── generator.py               # Template-based roadmap generation logic
│   │   └── migrations/
│   │
│   ├── ai_chat/                       # AI CONVERSATIONS
│   │   ├── models.py                  # AIConversation, AIMessage
│   │   ├── serializers.py
│   │   ├── views.py                   # Conversation CRUD, message streaming
│   │   ├── urls.py                    # /api/v1/ai/
│   │   ├── ai_service.py              # Claude API wrapper, context injection
│   │   ├── context_builder.py         # Injects student profile into AI prompt
│   │   └── migrations/
│   │
│   ├── content/                       # STORIES & RESOURCES
│   │   ├── models.py                  # RealPeopleStory, LearningResource
│   │   ├── serializers.py
│   │   ├── views.py
│   │   ├── urls.py                    # /api/v1/content/
│   │   └── migrations/
│   │
│   ├── subscriptions/                 # SUBSCRIPTIONS & PAYMENTS
│   │   ├── models.py                  # SubscriptionPlan, SubscriptionTransaction
│   │   ├── serializers.py
│   │   ├── views.py                   # Plan list, Razorpay order, verify payment
│   │   ├── urls.py                    # /api/v1/subscriptions/
│   │   ├── razorpay_service.py        # Razorpay SDK wrapper
│   │   └── migrations/
│   │
│   ├── notifications/                 # NOTIFICATIONS & CHECK-INS
│   │   ├── models.py                  # Notification, CheckInPrompt
│   │   ├── serializers.py
│   │   ├── views.py
│   │   ├── urls.py                    # /api/v1/notifications/, /api/v1/check-ins/
│   │   └── migrations/
│   │
│   └── analytics/                     # EVENT TRACKING
│       ├── models.py                  # AnalyticsEvent
│       ├── serializers.py
│       ├── views.py                   # Ingest events
│       ├── urls.py                    # /api/v1/analytics/
│       └── migrations/
│
├── utils/
│   ├── pagination.py                  # Custom DRF pagination classes
│   ├── s3_service.py                  # S3 file upload helpers
│   ├── firebase_auth.py               # Firebase Admin SDK init + token verifier
│   └── permissions.py                 # Shared custom DRF permissions
│
└── scripts/
    ├── seed_careers.py                # Seeds 300+ careers from JSON
    ├── seed_domains.py
    └── seed_questions.py              # Seeds profiler questions
```

---

## 2. Tech Stack & Dependencies

### `requirements.txt`

```
# Core
django==4.2.x
djangorestframework==3.15.x
django-cors-headers==4.x

# Database
psycopg2-binary==2.9.x         # PostgreSQL adapter
django-extensions==3.x

# Auth
firebase-admin==6.x            # Firebase token verification
djangorestframework-simplejwt==5.x

# AWS
boto3==1.x                     # S3 + other AWS services
django-storages==1.x           # Django integration for S3

# AI
anthropic==0.x                 # Claude API SDK

# Payments
razorpay==1.x

# Filtering & Search
django-filter==23.x

# Env
python-decouple==3.x           # .env management

# Utilities
Pillow==10.x                   # Image handling
celery==5.x                    # Async tasks (notifications, AI calls)
redis==5.x                     # Celery broker + caching
gunicorn==21.x                 # WSGI server for EC2
```

---

## 3. API Conventions

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

All responses follow this envelope:

```json
{
  "success": true,
  "data": { ... },
  "message": "Optional human-readable message"
}
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

---

## 4. Authentication Flow

NextStep uses **Firebase Auth** for identity management and **DRF SimpleJWT** for API access.

### Step 1 — Firebase Login (Flutter side)
Flutter calls Firebase directly to sign in (email/password, Google, phone OTP). Firebase returns a **Firebase ID Token**.

### Step 2 — Exchange for Django JWT

```
POST /api/v1/auth/firebase/
```

Flutter sends the Firebase ID Token. Django verifies it via Firebase Admin SDK, creates or retrieves the `User` record, and returns a Django JWT pair.

**Request Body:**
```json
{
  "firebase_token": "eyJhbGciOiJSUzI1NiIsInR5..."
}
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "access": "<django_access_jwt>",
    "refresh": "<django_refresh_jwt>",
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

### Step 3 — Refresh Token

```
POST /api/v1/auth/token/refresh/
```

**Request Body:**
```json
{
  "refresh": "<django_refresh_jwt>"
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

## 5. Module 1 — Auth & Users

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

**Auth:** Required

**Response `204`:** Empty body

---

### `POST /api/v1/users/me/avatar/`
Upload profile picture to S3.

**Auth:** Required

**Request:** `multipart/form-data`
```
file: <image_file>     (max 5MB, jpg/png/webp)
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
Get the extended student profile.

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

**Enum values:**
- `academic_stage`: `grade_8_9` | `grade_10` | `grade_11_12_science` | `grade_11_12_commerce` | `grade_11_12_arts` | `college_year_1_2`
- `career_clarity`: `clear` | `few_options` | `none` | `wants_to_explore`
- `pressure_level`: `high` | `some` | `low` | `very_high`
- `career_awareness_level`: `narrow` | `moderate` | `broad` | `focused`

**Response `200`:** Same shape as `GET /api/v1/users/me/student-profile/`

---

### `POST /api/v1/users/me/parental-consent/`
Record parental consent (required for users under 16).

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

## 6. Module 2 — Onboarding & Interest Profiler

### URLs prefix: `/api/v1/profiler/`

The profiler runs in **5 phases**: SC questions (context) → Q1–Q20 (scored questions) → Q21–Q22 (awareness) → Q23–Q24 (final signal) → Completion & scoring.

---

### `GET /api/v1/profiler/questions/`
Get the full set of profiler questions. Called once on app start and cached locally in Flutter.

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
        },
        {
          "index": 1,
          "text": "Grade 10 — Choosing my stream soon",
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
    },
    {
      "code": "Q2",
      "section": "free_time",
      "question_text": "When you watch YouTube or scroll through content, what kind of videos do you keep coming back to?",
      "instruction": "Pick up to 2.",
      "question_type": "multi_select",
      "max_selections": 2,
      "is_scored": true,
      "options": [
        {
          "index": 0,
          "text": "Behind-the-scenes of films, animation, design, or art",
          "emoji": "🎬",
          "dimension_weights": { "C": 1.0 }
        }
      ]
    }
  ]
}
```

---

### `POST /api/v1/profiler/sessions/`
Start a new profiler session. If the user already has a completed session, a new retake session is created.

**Auth:** Required

**Request Body:** _(empty)_

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
Get session progress — used to resume interrupted sessions.

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
Submit one or more question responses. Can send batch (multiple answers at once) or one at a time.

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
      "question_code": "Q1",
      "question_section": "free_time",
      "selected_option_index": [0],
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

**Notes:**
- `selected_option_index` is always an array (supports multi-select questions like Q2, Q19, Q20, Q21)
- For skipped questions: `"skipped": true` and `"selected_option_index": []`
- Server validates `question_code` exists and `selected_option_index` values are within option bounds

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
Finalize the session. Server runs the scoring engine, writes `InterestProfile`, and triggers career recommendation generation.

**Auth:** Required

**Request Body:** _(empty)_

**Processing (server-side):**
1. Validates all non-skippable questions are answered
2. Runs `scoring_engine.compute_dimension_scores(session_id)` → normalised scores 0–100
3. Creates `interest_profiles` row with `is_active = True` (deactivates previous)
4. Triggers async task: `generate_career_recommendations(user_id, interest_profile_id)`
5. Updates `student_profiles.profiler_completed = True`

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
        "C": 82,
        "A": 74,
        "T": 68,
        "S": 41,
        "E": 35,
        "P": 12
      },
      "top_dimensions": ["C", "A", "T"],
      "computed_at": "2025-06-01T10:05:42Z"
    },
    "recommendations_ready": false,
    "recommendations_eta_seconds": 3
  }
}
```

> **Flutter note:** Poll `GET /api/v1/recommendations/` after ~3 seconds to get recommendations once `recommendations_ready` becomes `true`.

---

### `GET /api/v1/profiler/profile/`
Get the active interest profile for the current user.

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
      "C": 82,
      "A": 74,
      "T": 68,
      "S": 41,
      "E": 35,
      "P": 12
    },
    "top_dimensions": ["C", "A", "T"],
    "career_cluster_weights": {
      "Design & Visual Arts": 0.87,
      "Gaming & Animation": 0.81,
      "AI & Data Science": 0.72,
      "Architecture & Urban Planning": 0.68,
      "Film, Media & Broadcasting": 0.61
    },
    "awareness_known_careers": ["UX Designer", "Robotics Engineer"],
    "computed_at": "2025-06-01T10:05:42Z"
  }
}
```

**Response `404`:** If user has not completed the profiler yet.

---

## 7. Module 3 — Career Universe

### URLs prefix: `/api/v1/careers/`

---

### `GET /api/v1/careers/`
List careers with filtering, sorting, and search. Used for browse/explore screens.

**Auth:** Required

**Query Parameters:**

| Parameter | Type | Description |
|---|---|---|
| `search` | string | Full-text search on `name`, `one_liner`, `skills_needed` |
| `domain_slug` | string | Filter by domain, e.g. `technology-software` |
| `dimension_tags` | string (comma) | Filter by tags, e.g. `C,A` (OR match) |
| `india_viability` | string | `very_high`, `high`, `medium`, `low` |
| `future_score_min` | int | Minimum future score (1–10) |
| `is_emerging` | bool | `true` to show 🔮 future careers only |
| `ordering` | string | `future_score`, `-future_score`, `name` |
| `page` | int | Pagination |
| `page_size` | int | Default 20, max 50 |

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
        "one_liner": "You design how apps and websites feel to use — bridging user needs with product goals.",
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
Get full career detail page.

**Auth:** Required

**Path Parameter:** `slug` — URL-safe career identifier, e.g. `ux-designer`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "slug": "ux-designer",
    "name": "UX Designer",
    "one_liner": "You design how apps and websites feel to use — bridging user needs with product goals.",
    "domain": {
      "slug": "design-visual-arts",
      "name": "Design & Visual Arts",
      "short_name": "Design"
    },
    "dimension_tags": ["C", "A", "S"],
    "india_viability": "very_high",
    "future_score": 9,
    "future_score_reasoning": "Demand for UX designers in India is growing 35% year-on-year driven by the rapid expansion of digital products. AI tools will automate some visual tasks but empathy and user research cannot be automated.",
    "typical_day": "Morning: Review user interview feedback. Afternoon: Sketch wireframes for a new onboarding flow. Evening: Review with engineering and adjust based on technical constraints.",
    "skills_needed": ["Empathy", "User Research", "Figma", "Wireframing", "Communication", "Analytical Thinking"],
    "entry_paths": ["Any degree + portfolio", "B.Des (NID / Symbiosis)", "Google UX Certificate (Coursera)"],
    "salary_entry_min_paise": 400000000,
    "salary_entry_max_paise": 800000000,
    "salary_entry_lpa": "4–8",
    "salary_mid_lpa": "12–22",
    "salary_senior_lpa": "25–45",
    "is_emerging": false,
    "last_reviewed_at": "2025-03-01",
    "related_careers": [
      {
        "slug": "ui-designer",
        "name": "UI Designer",
        "one_liner": "You design the visual elements of apps and websites.",
        "future_score": 8
      },
      {
        "slug": "product-designer",
        "name": "Product Designer",
        "one_liner": "You own the end-to-end experience of a digital product.",
        "future_score": 9
      }
    ],
    "is_saved": false,
    "user_match_score": 87
  }
}
```

> `is_saved` and `user_match_score` are injected per-user if authenticated.

---

### `GET /api/v1/careers/domains/`
List all career domains. Used for browse-by-domain screen.

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
Get a domain with all its careers.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "slug": "technology-software",
    "name": "Technology & Software Engineering",
    "short_name": "Technology",
    "india_relevance": "very_high",
    "growth_forecast_2035": "strong",
    "entry_path_summary": "B.Tech / BCA / Self-taught / Bootcamps",
    "careers": [
      {
        "slug": "software-engineer",
        "name": "Software Engineer",
        "one_liner": "...",
        "dimension_tags": ["T", "A"],
        "future_score": 9,
        "india_viability": "very_high"
      }
    ]
  }
}
```

---

### `GET /api/v1/careers/clusters/`
Get all 8 high-level career clusters (used in Q24 and discovery mode).

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Technology, AI, Engineering",
      "q24_description": "You wake up and spend your day building digital systems, training AI models, or solving engineering problems.",
      "domain_count": 4,
      "career_count": 67
    }
  ]
}
```

---

### `GET /api/v1/careers/compare/`
Side-by-side comparison of 2–3 careers. Premium feature for non-free users.

**Auth:** Required | **Permission:** `subscription_tier != "free"` or max 1 comparison/day on free

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `slugs` | string (comma) | Yes | 2 or 3 career slugs, e.g. `ux-designer,ui-designer,product-designer` |

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
        "user_skill_overlap": ["Analytical Thinking", "Communication", "User Research"],
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

## 8. Module 4 — Career Recommendations

### URLs prefix: `/api/v1/recommendations/`

---

### `GET /api/v1/recommendations/`
Get the personalized career matches for the current user. Returns the Career Map screen data.

**Auth:** Required

**Query Parameters:**

| Parameter | Type | Description |
|---|---|---|
| `tier` | string | `full_match` | `partial_match` | `discovery_match` |
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
      },
      {
        "rank": 8,
        "match_score": 71,
        "match_tier": "discovery_match",
        "tag_overlap_count": 1,
        "is_novel": true,
        "career": {
          "slug": "data-visualisation-specialist",
          "name": "Data Visualisation Specialist",
          "one_liner": "You turn complex data into charts, stories, and visuals people actually understand.",
          "dimension_tags": ["A", "C", "T"],
          "future_score": 8
        }
      }
    ]
  }
}
```

**Response `422`:** If profiler not yet completed:
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

**Auth:** Required

**Request Body:** _(empty)_

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "status": "regenerating",
    "eta_seconds": 3
  }
}
```

---

## 9. Module 5 — Career Actions (Save, View, Compare)

---

### `GET /api/v1/recommendations/saved/`
Get all saved/bookmarked careers for the user.

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
Save / bookmark a career.

**Auth:** Required

**Request Body (optional):**
```json
{
  "notes": "Looks interesting — research more"
}
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "save_id": "uuid",
    "career_slug": "ux-designer",
    "saved_at": "2025-06-02T09:12:00Z"
  }
}
```

**Response `409`:** If already saved:
```json
{
  "success": false,
  "error": {
    "code": "ALREADY_SAVED",
    "message": "Career already bookmarked."
  }
}
```

---

### `DELETE /api/v1/careers/{slug}/save/`
Remove a saved career.

**Auth:** Required

**Response `204`:** Empty body

---

### `PATCH /api/v1/careers/{slug}/save/`
Update notes on a saved career.

**Auth:** Required

**Request Body:**
```json
{
  "notes": "Updated note after reading roadmap"
}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "save_id": "uuid",
    "notes": "Updated note after reading roadmap"
  }
}
```

---

### `POST /api/v1/careers/{slug}/view/`
Track that the student viewed a career card or detail page. Fire-and-forget from Flutter.

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
{
  "success": true,
  "data": {
    "view_id": "uuid"
  }
}
```

---

## 10. Module 6 — Roadmaps & Progress

### URLs prefix: `/api/v1/roadmaps/`

---

### `GET /api/v1/roadmaps/`
List all roadmaps generated for the current user.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "career": {
        "slug": "ux-designer",
        "name": "UX Designer",
        "domain_short_name": "Design"
      },
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
Generate a new roadmap for a specific career. Uses template-based generation (v1) referencing student's `academic_stage`.

**Auth:** Required

**Request Body:**
```json
{
  "career_slug": "ux-designer"
}
```

**Server logic:**
1. Check if active roadmap already exists for `(user_id, career_id)` → return existing
2. Fetch template steps for `(career_slug, academic_stage)`
3. Create `Roadmap` + `RoadmapStep` records
4. Return full roadmap

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "career": {
      "slug": "ux-designer",
      "name": "UX Designer"
    },
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
      },
      {
        "id": "uuid",
        "step_order": 2,
        "category": "skill_to_learn",
        "title": "Learn Figma basics",
        "description": "Figma is the industry-standard tool for UX design. The free plan is enough to start.",
        "timeframe": "30 days",
        "resource_url": "https://www.figma.com/resources/learn-design/",
        "resource_label": "Figma Learn — Official Free Course",
        "is_premium": false,
        "status": "not_started",
        "completed_at": null
      },
      {
        "id": "uuid",
        "step_order": 6,
        "category": "project_to_build",
        "title": "Redesign an app you use daily and document your process",
        "description": "Pick any app (Swiggy, IRCTC, etc.) and redesign one user flow. Document user pain points and your design decisions in a Notion or Figma document.",
        "timeframe": "3 months",
        "resource_url": null,
        "resource_label": null,
        "is_premium": true,
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
Get a roadmap with all steps and their current progress status.

**Auth:** Required

**Response `200`:** Same shape as `POST /api/v1/roadmaps/` response body.

---

### `PATCH /api/v1/roadmaps/{roadmap_id}/steps/{step_id}/progress/`
Update progress on a specific roadmap step.

**Auth:** Required

**Request Body:**
```json
{
  "status": "completed",
  "notes": "Done! Took me 2 weeks."
}
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
Get a summary of all roadmaps and skill-building progress. Used for the **Progress Tracker** dashboard screen.

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

## 11. Module 7 — AI Conversations (General AI + Career AI)

### URLs prefix: `/api/v1/ai/`

Two types of AI exist in NextStep:

| Type | `conversation_type` | Context Injected | Purpose |
|---|---|---|---|
| **General AI** | `general` | Student's full interest profile + academic stage + saved careers | Personalized career guidance — answers any question the student has |
| **Career AI** | `career_specific` | Above + the full career record for the specific career | Deep Q&A about one specific career |

---

### `GET /api/v1/ai/conversations/`
List all AI conversations for the current user.

**Auth:** Required

**Query Parameters:** `?conversation_type=general` or `?conversation_type=career_specific`

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "conversation_type": "career_specific",
      "career": {
        "slug": "ux-designer",
        "name": "UX Designer"
      },
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

For `general` type, omit `career_slug`.

**Server logic:**
1. Fetch `InterestProfile` (active) + `StudentProfile` for the user
2. If `career_specific`, fetch full career record
3. Build system prompt via `context_builder.build_system_prompt()`
4. Call Claude API with injected context + first message
5. Save conversation + both messages (user + assistant) to DB

**System prompt built by `context_builder.py` (General AI example):**
```
You are NextStep's AI career guide — warm, knowledgeable, and honest.
You are speaking with a student who has completed the NextStep interest profiler.

Student context:
- Academic stage: Grade 11, Science stream
- Interest profile: Creative (82/100), Analytical (74/100), Technical (68/100), Social (41/100), Entrepreneurial (35/100), Physical (12/100)
- Top career matches: UX Designer, Product Designer, Motion Graphics Artist
- Saved careers: UX Designer
- Career clarity level: few_options
- Pressure level: high

Guidelines:
- Keep responses concise and practical — this student is on a mobile app.
- Always connect advice back to their specific interest profile and context.
- Surface career options they may not have considered based on their profile.
- If they ask about a specific career, give honest, India-specific information.
- Do not invent salary data — use only what is in the career database.
- Keep a warm, encouraging, non-judgmental tone.
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "conversation_id": "uuid",
    "conversation_type": "career_specific",
    "career": {
      "slug": "ux-designer",
      "name": "UX Designer"
    },
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
        "content": "Great question! UX Design is about making apps and websites feel easy and enjoyable to use. As a Grade 11 Science student, you're actually in a great position — UX doesn't require a specific degree...",
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
Get a conversation with its full message history.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "conversation_id": "uuid",
    "conversation_type": "career_specific",
    "career": {
      "slug": "ux-designer",
      "name": "UX Designer"
    },
    "title": "What skills do I need?",
    "message_count": 6,
    "started_at": "2025-06-02T12:00:00Z",
    "last_message_at": "2025-06-02T12:30:00Z",
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
        "created_at": "2025-06-02T12:00:03Z"
      }
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
{
  "content": "What degree should I study to become a UX Designer?"
}
```

**Server logic:**
1. Fetch full conversation history from `ai_messages`
2. Rebuild system prompt (fresh from DB — never stored in messages)
3. Send `[system_prompt + all previous messages + new user message]` to Claude API
4. Save new user message + assistant reply to DB
5. Update `ai_conversations.last_message_at` and `message_count`

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
      "content": "The great news is that UX Design doesn't require a specific degree. Many UX designers in India come from Engineering, Psychology, Commerce, even Arts backgrounds. What matters most is your portfolio...",
      "tokens_used": 287,
      "model_version": "claude-sonnet-4-20250514",
      "created_at": "2025-06-02T12:05:02Z"
    }
  }
}
```

**Error `403`:** If user hits message limit on free tier:
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
Archive (soft-delete) a conversation.

**Auth:** Required

**Response `204`:** Empty body

---

## 12. Module 8 — Content (Stories & Resources)

### URLs prefix: `/api/v1/content/`

---

### `GET /api/v1/careers/{slug}/stories/`
Get real people stories for a specific career.

**Auth:** Required | Free users see 1 story; Premium users see all.

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
        "story_text": "I studied Commerce. Everyone told me to do CA. Then I discovered UX through a random YouTube video. I did one free course, built two personal projects, and got my first job at 22.",
        "is_premium": false
      },
      {
        "id": "uuid",
        "person_name": "Arjun",
        "person_age": 30,
        "person_city": "Bengaluru",
        "story_text": "...",
        "is_premium": true,
        "locked": true
      }
    ]
  }
}
```

---

### `GET /api/v1/careers/{slug}/resources/`
Get curated learning resources for a specific career.

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
      },
      {
        "id": "uuid",
        "title": "Interaction Design Foundation",
        "url": "https://www.interaction-design.org/",
        "provider": "IDF",
        "resource_type": "course",
        "is_free": false
      }
    ]
  }
}
```

---

## 13. Module 9 — Subscriptions & Payments

### URLs prefix: `/api/v1/subscriptions/`

Payments use **Razorpay** (India-first payment gateway).

---

### `GET /api/v1/subscriptions/plans/`
Get all available subscription plans.

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
    },
    {
      "id": "uuid",
      "name": "premium_yearly",
      "display_name": "Premium — Yearly",
      "price_paise": 149900,
      "price_inr": 1499,
      "duration_days": 365,
      "features": { ... }
    }
  ]
}
```

---

### `POST /api/v1/subscriptions/create-order/`
Create a Razorpay order. Flutter uses this to initialise the Razorpay payment sheet.

**Auth:** Required

**Request Body:**
```json
{
  "plan_id": "uuid"
}
```

**Server logic:**
1. Fetch plan by `plan_id`
2. Create `SubscriptionTransaction` with `status = "pending"`
3. Call `razorpay.order.create(amount, currency, receipt)`
4. Return order details to Flutter

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
Verify Razorpay payment signature after Flutter completes payment. Activates the subscription.

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

**Server logic:**
1. Fetch `SubscriptionTransaction` by `transaction_id`
2. Verify HMAC signature: `HMAC_SHA256(razorpay_order_id + "|" + razorpay_payment_id, razorpay_secret)`
3. If valid → update transaction `status = "success"` + update `users.subscription_tier` + set `subscription_expires_at`
4. If invalid → update transaction `status = "failed"` + return error

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

**Response `400`:** Signature mismatch:
```json
{
  "success": false,
  "error": {
    "code": "PAYMENT_SIGNATURE_INVALID",
    "message": "Payment verification failed. Please contact support."
  }
}
```

---

### `GET /api/v1/subscriptions/me/`
Get the current user's active subscription status.

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
    "plan": {
      "name": "premium_monthly",
      "display_name": "Premium — Monthly",
      "price_inr": 299
    }
  }
}
```

---

## 14. Module 10 — Notifications & Check-ins

### URLs prefix: `/api/v1/notifications/` and `/api/v1/check-ins/`

---

### `GET /api/v1/notifications/`
Get all in-app notifications for the current user.

**Auth:** Required

**Query Parameters:** `?is_read=false` to get only unread

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

**Notification `type` enums:** `roadmap_reminder` | `check_in` | `new_career_match` | `subscription_expiry` | `profiler_retake_suggestion`

---

### `PATCH /api/v1/notifications/{notification_id}/read/`
Mark a single notification as read.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "is_read": true,
    "read_at": "2025-06-03T09:15:00Z"
  }
}
```

---

### `POST /api/v1/notifications/mark-all-read/`
Mark all notifications as read.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "marked_read_count": 5
  }
}
```

---

### `GET /api/v1/check-ins/`
Get pending check-in prompts for the current user.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "prompt_type": "career_still_interested",
      "career": {
        "slug": "ux-designer",
        "name": "UX Designer"
      },
      "question": "It's been a month since you added UX Designer to your list. Still feeling interested?",
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
Submit a check-in response.

**Auth:** Required

**Request Body:**
```json
{
  "response": "still_yes"
}
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

## 15. Module 11 — Analytics Events

### URLs prefix: `/api/v1/analytics/`

Fire-and-forget event logging. Flutter sends events; server saves to `analytics_events` table.

---

### `POST /api/v1/analytics/events/`
Log an analytics event.

**Auth:** Required (unauthenticated events logged with `user_id = null`)

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
{
  "success": true,
  "data": {
    "event_id": "uuid"
  }
}
```

---

## 16. Module 12 — Counsellor Dashboard

### URLs prefix: `/api/v1/counsellor/`

**Permission:** `user_type == "counsellor"` AND member of a `school_organisation`

---

### `GET /api/v1/counsellor/dashboard/`
Get aggregated, anonymised stats for the counsellor's school/organisation.

**Auth:** Required | **Permission:** `IsCounsellor`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "organisation": {
      "id": "uuid",
      "name": "Delhi Public School",
      "type": "school",
      "licence_seats": 500
    },
    "students_total": 342,
    "students_profiler_completed": 198,
    "profiler_completion_rate_percent": 58,
    "top_career_interests": [
      { "career_slug": "software-engineer", "career_name": "Software Engineer", "student_count": 47 },
      { "career_slug": "ux-designer", "career_name": "UX Designer", "student_count": 31 },
      { "career_slug": "data-scientist", "career_name": "Data Scientist", "student_count": 28 }
    ],
    "top_domains": [
      { "domain_short_name": "Technology", "student_count": 89 },
      { "domain_short_name": "Design", "student_count": 54 }
    ],
    "dimension_distribution": {
      "C": 45,
      "A": 62,
      "T": 78,
      "S": 38,
      "E": 22,
      "P": 14
    }
  }
}
```

---

### `GET /api/v1/counsellor/students/`
Get list of students in the counsellor's organisation. Returns anonymised profiles only (no PII without explicit consent).

**Auth:** Required | **Permission:** `IsCounsellor`

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

## 17. Module 13 — Parent Share View

### URLs prefix: `/api/v1/share/`

A student can generate a shareable token to let parents view a read-only version of their profile.

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

### `GET /api/v1/share/profile/{share_token}/`
Get the parent-friendly read-only student profile view. **No auth required** — token is the credential.

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
      },
      {
        "rank": 2,
        "career_name": "Product Designer",
        "salary_entry_lpa": "6–12",
        "salary_senior_lpa": "30–55",
        "future_score": 9
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

## 18. Error Reference

### Standard Error Codes

| Code | HTTP | Description |
|---|---|---|
| `INVALID_FIREBASE_TOKEN` | 401 | Firebase token verification failed |
| `TOKEN_EXPIRED` | 401 | Django JWT access token expired |
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
| `VALIDATION_ERROR` | 400 | Request body field validation failed |
| `INTERNAL_ERROR` | 500 | Unexpected server error |

---

## 19. Django Settings Overview

### `nextstep/settings/base.py` (key sections)

```python
# Apps
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "rest_framework",
    "corsheaders",
    "django_filters",
    "storages",
    "apps.users",
    "apps.profiler",
    "apps.careers",
    "apps.recommendations",
    "apps.roadmaps",
    "apps.ai_chat",
    "apps.content",
    "apps.subscriptions",
    "apps.notifications",
    "apps.analytics",
]

# DRF
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ],
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.IsAuthenticated",
    ],
    "DEFAULT_PAGINATION_CLASS": "utils.pagination.StandardResultsSetPagination",
    "PAGE_SIZE": 20,
    "DEFAULT_FILTER_BACKENDS": [
        "django_filters.rest_framework.DjangoFilterBackend",
        "rest_framework.filters.SearchFilter",
        "rest_framework.filters.OrderingFilter",
    ],
}

# CORS (Flutter uses localhost during dev, nextstep.app in prod)
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8080",
    "https://nextstep.app",
]

# Database (overridden per environment)
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": env("DB_NAME"),
        "USER": env("DB_USER"),
        "PASSWORD": env("DB_PASSWORD"),
        "HOST": env("DB_HOST"),      # AWS RDS endpoint
        "PORT": "5432",
    }
}

# S3 Media Storage
DEFAULT_FILE_STORAGE = "storages.backends.s3boto3.S3Boto3Storage"
AWS_STORAGE_BUCKET_NAME = env("AWS_S3_BUCKET_NAME")
AWS_S3_REGION_NAME = "ap-south-1"    # Mumbai region

# Celery (async tasks: notifications, AI calls)
CELERY_BROKER_URL = env("REDIS_URL")   # ElastiCache or EC2 Redis

# JWT
from datetime import timedelta
SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(hours=1),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=30),
}

# AI (Anthropic)
ANTHROPIC_API_KEY = env("ANTHROPIC_API_KEY")
AI_MODEL = "claude-sonnet-4-20250514"
AI_MAX_TOKENS = 1000
AI_FREE_DAILY_MESSAGE_LIMIT = 5

# Payments (Razorpay)
RAZORPAY_KEY_ID = env("RAZORPAY_KEY_ID")
RAZORPAY_SECRET = env("RAZORPAY_SECRET")

# Firebase
FIREBASE_CREDENTIALS_PATH = env("FIREBASE_CREDENTIALS_PATH")
```

### `.env.example`

```bash
# Django
DJANGO_SECRET_KEY=your-secret-key-here
DJANGO_DEBUG=False
ALLOWED_HOSTS=api.nextstep.app,localhost

# Database (AWS RDS)
DB_NAME=nextstep_db
DB_USER=nextstep_user
DB_PASSWORD=your-rds-password
DB_HOST=nextstep.xxxxxxxxxxxx.ap-south-1.rds.amazonaws.com

# AWS S3
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS_S3_BUCKET_NAME=nextstep-assets

# Redis (for Celery)
REDIS_URL=redis://localhost:6379/0

# Firebase Admin SDK
FIREBASE_CREDENTIALS_PATH=/home/ec2-user/firebase-service-account.json

# Anthropic (Claude AI)
ANTHROPIC_API_KEY=sk-ant-api03-xxxxxxxxxxxxxxxxxxxxxxxx

# Razorpay
RAZORPAY_KEY_ID=rzp_live_XXXXXXXXXXXX
RAZORPAY_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

*NextStep Server & API Contract v1.0*
*Aligned with: NextStep_Product_Document.md v1.0, NextStep_Database_Schema.md v1.0*
*Stack: Django 4.2 + DRF | PostgreSQL (AWS RDS) | Firebase Auth | AWS EC2 | AWS S3 | Claude AI | Razorpay*
