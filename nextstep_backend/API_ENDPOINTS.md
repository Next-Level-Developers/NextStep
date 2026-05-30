# NextStep FastAPI Backend - Complete API Endpoints Documentation

## Overview
- **Base URL**: `/api/v1`
- **API Version**: 2.0.0
- **Framework**: FastAPI with async/await
- **Authentication**: JWT (Firebase token exchange)
- **Response Format**: All responses use `{"success": bool, "data": {...}, "error": {...}}`

---

## 1. Authentication (`/auth`)

### 1.1 Firebase Login
- **Endpoint**: `POST /api/v1/auth/firebase/`
- **Status Code**: 201
- **Auth**: ❌ Not Required (public)
- **Request Body**:
  ```json
  {
    "firebase_token": "string (Firebase ID token from client)"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "access": "string (JWT access token)",
      "refresh": "string (JWT refresh token)",
      "is_new_user": boolean,
      "user": {
        "id": "uuid",
        "email": "string",
        "user_type": "student|counsellor|parent",
        "subscription_tier": "free|premium_monthly|premium_annual",
        "profiler_completed": boolean
      }
    }
  }
  ```

### 1.2 Refresh Access Token
- **Endpoint**: `POST /api/v1/auth/token/refresh/`
- **Status Code**: 200
- **Auth**: ❌ Not Required
- **Request Body**:
  ```json
  {
    "refresh": "string (JWT refresh token)"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "access": "string (new JWT access token)"
    }
  }
  ```

---

## 2. Users (`/users`)

### 2.1 Get Current User Profile
- **Endpoint**: `GET /api/v1/users/me/`
- **Status Code**: 200
- **Auth**: ✅ Required (JWT)
- **Query Parameters**: None
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "uuid",
      "email": "string",
      "full_name": "string|null",
      "phone": "string|null",
      "avatar_url": "string|null",
      "user_type": "student|counsellor|parent",
      "subscription_tier": "free|premium_monthly|premium_annual",
      "subscription_expires_at": "ISO8601 datetime|null",
      "parental_consent_given": boolean,
      "created_at": "ISO8601 datetime",
      "student_profile": {
        "academic_stage": "grade_8_9|grade_10|grade_11_12_science|grade_11_12_commerce|grade_11_12_arts|college_year_1_2",
        "grade_or_year": "string|null",
        "school_name": "string|null",
        "city": "string|null",
        "state": "string|null",
        "career_clarity": "clear|few_options|none|wants_to_explore|null",
        "pressure_level": "high|some|low|very_high|null",
        "profiler_completed": boolean,
        "profiler_completed_at": "ISO8601 datetime|null"
      } | null
    }
  }
  ```

### 2.2 Update User Profile
- **Endpoint**: `PATCH /api/v1/users/me/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Request Body** (all optional):
  ```json
  {
    "full_name": "string|null",
    "phone": "string|null"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "uuid",
      "full_name": "string",
      "phone": "string"
    }
  }
  ```

### 2.3 Delete User (Soft Delete)
- **Endpoint**: `DELETE /api/v1/users/me/`
- **Status Code**: 204 No Content
- **Auth**: ✅ Required
- **Response**: Empty

### 2.4 Upload Avatar
- **Endpoint**: `POST /api/v1/users/me/avatar/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Content-Type**: `multipart/form-data`
- **Request**:
  - `file`: File (image binary, required)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "avatar_url": "string (S3 URL)"
    }
  }
  ```

### 2.5 Get Student Profile
- **Endpoint**: `GET /api/v1/users/me/student-profile/`
- **Status Code**: 200
- **Auth**: ✅ Required (student role)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "uuid|null",
      "user_id": "uuid",
      "academic_stage": "string",
      "grade_or_year": "string|null",
      "school_name": "string|null",
      "city": "string|null",
      "state": "string|null",
      "career_clarity": "string|null",
      "pressure_level": "string|null",
      "career_awareness_level": "string|null",
      "profiler_completed": boolean,
      "profiler_completed_at": "ISO8601 datetime|null"
    } | null
  }
  ```

### 2.6 Create/Update Student Profile
- **Endpoint**: `PUT /api/v1/users/me/student-profile/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Request Body**:
  ```json
  {
    "academic_stage": "grade_8_9|grade_10|grade_11_12_science|grade_11_12_commerce|grade_11_12_arts|college_year_1_2",
    "grade_or_year": "string|null",
    "school_name": "string|null",
    "city": "string|null",
    "state": "string|null",
    "career_clarity": "clear|few_options|none|wants_to_explore|null",
    "pressure_level": "high|some|low|very_high|null",
    "career_awareness_level": "narrow|moderate|broad|focused|null"
  }
  ```
- **Response**: (StudentProfileOut schema)

### 2.7 Submit Parental Consent
- **Endpoint**: `POST /api/v1/users/me/parental-consent/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Request Body**:
  ```json
  {
    "consent_given": boolean,
    "parent_name": "string|null",
    "parent_phone": "string|null"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "parental_consent_given": boolean,
      "parental_consent_at": "ISO8601 datetime|null"
    }
  }
  ```

### 2.8 Generate Share Token for Parents
- **Endpoint**: `POST /api/v1/users/me/share-token/`
- **Status Code**: 201
- **Auth**: ✅ Required
- **Request Body**: (empty)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "share_token": "string (nxt_share_*)",
      "share_url": "string (https://...)",
      "expires_at": "ISO8601 datetime (30 days from now)"
    }
  }
  ```

---

## 3. Profiler (Interest Assessment) (`/profiler`)

### 3.1 Get Profiler Questions
- **Endpoint**: `GET /api/v1/profiler/questions/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Response**:
  ```json
  {
    "success": true,
    "data": [
      {
        "code": "string (Q1, Q2, etc.)",
        "section": "string",
        "section_label": "string",
        "question_text": "string",
        "instruction": "string|null",
        "question_type": "single_choice|multiple_choice|scale",
        "max_selections": "int|null",
        "is_scored": boolean,
        "is_skippable": boolean,
        "options": [
          {
            "index": 0,
            "text": "string",
            "emoji": "string|null",
            "dimension_weights": {
              "A": 1.5,
              "B": 0.5,
              ...
            }
          }
        ]
      }
    ]
  }
  ```
- **Notes**: Questions loaded from `data/questions.json`; Each question has dimension weights for scoring

### 3.2 Start Profiler Session
- **Endpoint**: `POST /api/v1/profiler/sessions/`
- **Status Code**: 201
- **Auth**: ✅ Required
- **Request Body**: (empty)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "session_id": "uuid",
      "session_number": 1,
      "status": "active",
      "total_questions": "int",
      "questions_answered": 0,
      "started_at": "ISO8601 datetime"
    }
  }
  ```

### 3.3 Get Session Progress
- **Endpoint**: `GET /api/v1/profiler/sessions/{session_id}/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `session_id`: UUID
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "session_id": "uuid",
      "session_number": 1,
      "status": "active|completed",
      "total_questions": "int",
      "questions_answered": "int",
      "questions_skipped": "int",
      "last_answered_code": "string|null",
      "started_at": "ISO8601 datetime"
    }
  }
  ```

### 3.4 Submit Responses
- **Endpoint**: `POST /api/v1/profiler/sessions/{session_id}/responses/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `session_id`: UUID
- **Request Body**:
  ```json
  {
    "responses": [
      {
        "question_code": "Q1",
        "question_section": "interests",
        "selected_option_index": [0, 2],
        "skipped": false
      }
    ]
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "session_id": "uuid",
      "questions_answered": "int",
      "questions_skipped": "int",
      "progress_percent": "int"
    }
  }
  ```

### 3.5 Complete Session & Generate Profile
- **Endpoint**: `POST /api/v1/profiler/sessions/{session_id}/complete/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `session_id`: UUID
- **Request Body**: (empty)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "session_id": "uuid",
      "status": "completed",
      "time_taken_seconds": "int|null",
      "interest_profile": {
        "id": "uuid",
        "dimension_scores": {
          "A": 8.5,
          "B": 7.2,
          "C": 6.1,
          ...
        },
        "top_dimensions": ["A", "B", "C"],
        "computed_at": "ISO8601 datetime"
      },
      "recommendations_ready": false,
      "recommendations_eta_seconds": 3
    }
  }
  ```
- **Side Effects**: Creates InterestProfile, deactivates previous profiles, marks StudentProfile.profiler_completed = true

### 3.6 Get Active Interest Profile
- **Endpoint**: `GET /api/v1/profiler/profile/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "uuid",
      "session_id": "uuid",
      "is_active": true,
      "dimension_scores": { ... },
      "top_dimensions": ["A", "B", "C"],
      "career_cluster_weights": { ... },
      "awareness_known_careers": ["career_slug1", ...] | null,
      "computed_at": "ISO8601 datetime"
    }
  }
  ```
- **Error**: 422 if profiler not completed

---

## 4. Careers (`/careers`)

### 4.1 List Careers (with filtering & pagination)
- **Endpoint**: `GET /api/v1/careers/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Query Parameters**:
  - `search`: string (optional) - Search in name & one_liner
  - `domain_slug`: string (optional) - Filter by domain
  - `dimension_tags`: string (optional) - Comma-separated tags for overlap filtering
  - `india_viability`: string (optional) - Filter by viability
  - `future_score_min`: int (optional, 1-10) - Minimum future score
  - `is_emerging`: boolean (optional) - Filter emerging careers
  - `ordering`: string (default: "-future_score") - "future_score" | "-future_score" | "name"
  - `page`: int (default: 1, min: 1) - Page number
  - `page_size`: int (default: 20, min: 1, max: 100) - Results per page
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "count": "int (total results)",
      "next": "string (URL)|null",
      "previous": "string (URL)|null",
      "results": [
        {
          "id": "uuid",
          "slug": "software-engineer",
          "name": "Software Engineer",
          "one_liner": "Build digital products",
          "domain": {
            "id": "uuid",
            "slug": "technology",
            "name": "Technology",
            "short_name": "Tech"
          },
          "dimension_tags": ["A", "T", "C"],
          "india_viability": "high|medium|low",
          "future_score": 8,
          "is_emerging": false,
          "salary_entry_lpa": "6–10",
          "salary_mid_lpa": "12–18",
          "salary_senior_lpa": "20–30"
        }
      ]
    }
  }
  ```

### 4.2 Get Career Detail
- **Endpoint**: `GET /api/v1/careers/{slug}/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `slug`: string - Career slug (e.g., "software-engineer")
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "uuid",
      "slug": "software-engineer",
      "name": "Software Engineer",
      "one_liner": "Build digital products",
      "domain": { ... },
      "dimension_tags": ["A", "T"],
      "india_viability": "high",
      "future_score": 8,
      "future_score_reasoning": "Strong demand in India...",
      "typical_day": "Code reviews, meetings, debugging...",
      "skills_needed": ["Python", "JavaScript", "SQL"],
      "entry_paths": ["B.Tech CS", "Bootcamp"],
      "salary_entry_lpa": "6–10",
      "salary_mid_lpa": "12–18",
      "salary_senior_lpa": "20–30",
      "is_emerging": false,
      "last_reviewed_at": "2025-12-15",
      "related_careers": [
        {
          "slug": "full-stack-developer",
          "name": "Full-Stack Developer",
          "one_liner": "...",
          "future_score": 8
        }
      ],
      "is_saved": false,
      "user_match_score": null
    }
  }
  ```

### 4.3 List Career Domains
- **Endpoint**: `GET /api/v1/careers/domains/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Response**:
  ```json
  {
    "success": true,
    "data": [
      {
        "id": "uuid",
        "slug": "technology",
        "name": "Technology",
        "short_name": "Tech",
        "india_relevance": "Very high demand",
        "growth_forecast_2035": "40% growth expected",
        "entry_path_summary": "B.Tech, Bootcamps, Self-learning",
        "career_count": 25,
        "display_order": 1
      }
    ]
  }
  ```

### 4.4 Get Domain with Careers
- **Endpoint**: `GET /api/v1/careers/domains/{slug}/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `slug`: string - Domain slug
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "uuid",
      "slug": "technology",
      "name": "Technology",
      "short_name": "Tech",
      "careers": [
        {
          "slug": "software-engineer",
          "name": "Software Engineer",
          "one_liner": "Build digital products",
          "future_score": 8
        }
      ]
    }
  }
  ```

### 4.5 List Career Clusters
- **Endpoint**: `GET /api/v1/careers/clusters/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Response**:
  ```json
  {
    "success": true,
    "data": [
      {
        "id": "uuid",
        "name": "Creative Arts",
        "q24_description": "...",
        "domain_count": 5,
        "career_count": 0
      }
    ]
  }
  ```

### 4.6 Compare Careers
- **Endpoint**: `GET /api/v1/careers/compare/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Query Parameters**:
  - `slugs`: string (required) - Comma-separated career slugs (2-3)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "careers": [
        {
          "slug": "software-engineer",
          "name": "Software Engineer",
          "dimension_tags": ["A", "T"],
          "future_score": 8,
          "india_viability": "high",
          "salary_entry_lpa": "6–10",
          "salary_mid_lpa": "12–18",
          "salary_senior_lpa": "20–30",
          "user_skill_overlap_count": 2,
          "user_skill_overlap": ["Python", "JavaScript"],
          "work_style": null,
          "time_to_first_job_months": null,
          "entry_difficulty": null
        }
      ],
      "comparison_dimensions": ["salary", "future_score", "skill_overlap", "entry_difficulty", "india_viability"]
    }
  }
  ```
- **Error**: 422 if not 2-3 careers provided

---

## 5. Recommendations (`/recommendations`)

### 5.1 List Personalized Recommendations
- **Endpoint**: `GET /api/v1/recommendations/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Query Parameters**:
  - `tier`: string (optional) - Filter by match_tier ("full_match" | "partial_match" | "discovery_match")
  - `limit`: int (default: 15, 1-30)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "interest_profile_id": "uuid",
      "generated_at": "ISO8601 datetime",
      "total_matches": 15,
      "recommendations": [
        {
          "rank": 1,
          "match_score": 92,
          "match_tier": "full_match",
          "tag_overlap_count": 3,
          "is_novel": false,
          "career": {
            "slug": "software-engineer",
            "name": "Software Engineer",
            "one_liner": "Build digital products",
            "dimension_tags": ["A", "T", "C"],
            "domain_short_name": "Tech",
            "future_score": 8,
            "india_viability": "high",
            "salary_entry_lpa": "6–10",
            "is_emerging": false
          }
        }
      ]
    }
  }
  ```
- **Error**: 422 if profiler not completed (no interest profile)

### 5.2 Regenerate Recommendations
- **Endpoint**: `POST /api/v1/recommendations/regenerate/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Request Body**: (empty)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "status": "regenerating",
      "eta_seconds": 3
    }
  }
  ```
- **Notes**: Triggers async task in production

### 5.3 List Saved Careers
- **Endpoint**: `GET /api/v1/recommendations/saved/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "count": "int",
      "results": [
        {
          "save_id": "uuid",
          "saved_at": "ISO8601 datetime",
          "notes": "string|null",
          "career": {
            "slug": "software-engineer",
            "name": "Software Engineer",
            "future_score": 8,
            "domain_short_name": "Tech",
            "salary_entry_lpa": "6–10"
          }
        }
      ]
    }
  }
  ```

---

## 6. Roadmaps (`/roadmaps`)

### 6.1 List User's Roadmaps
- **Endpoint**: `GET /api/v1/roadmaps/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Response**:
  ```json
  {
    "success": true,
    "data": [
      {
        "id": "uuid",
        "career": {
          "slug": "software-engineer",
          "name": "Software Engineer",
          "domain_short_name": "Tech"
        },
        "academic_stage": "grade_11_12_science",
        "generation_method": "template",
        "is_active": true,
        "total_steps": 3,
        "completed_steps": 1,
        "completion_percent": 33,
        "generated_at": "ISO8601 datetime"
      }
    ]
  }
  ```

### 6.2 Create Roadmap for a Career
- **Endpoint**: `POST /api/v1/roadmaps/`
- **Status Code**: 201
- **Auth**: ✅ Required
- **Request Body**:
  ```json
  {
    "career_slug": "software-engineer"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "uuid",
      "career": {
        "slug": "software-engineer",
        "name": "Software Engineer"
      },
      "academic_stage": "grade_11_12_science",
      "generation_method": "template",
      "is_active": true,
      "generated_at": "ISO8601 datetime",
      "steps": [
        {
          "id": "uuid",
          "step_order": 1,
          "category": "first_30_days",
          "title": "Research Software Engineer career path",
          "description": "Spend time understanding...",
          "timeframe": "30 days",
          "resource_url": "string|null",
          "resource_label": "string|null",
          "is_premium": false,
          "status": "not_started",
          "completed_at": null
        }
      ]
    }
  }
  ```
- **Error**: 
  - 404 if career not found
  - 409 if active roadmap already exists for career
  - 422 if profiler not completed

### 6.3 Get Roadmap Detail
- **Endpoint**: `GET /api/v1/roadmaps/{roadmap_id}/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `roadmap_id`: UUID
- **Response**: (same structure as POST create response)

### 6.4 Update Roadmap Step Progress
- **Endpoint**: `PATCH /api/v1/roadmaps/{roadmap_id}/steps/{step_id}/progress/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `roadmap_id`: UUID
  - `step_id`: UUID
- **Request Body**:
  ```json
  {
    "status": "not_started|in_progress|completed",
    "notes": "string|null"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "step_id": "uuid",
      "status": "completed",
      "completed_at": "ISO8601 datetime|null",
      "roadmap_completion_percent": 33
    }
  }
  ```

### 6.5 Get Progress Summary (All Roadmaps)
- **Endpoint**: `GET /api/v1/roadmaps/progress-summary/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "active_roadmaps": 2,
      "total_steps_across_all": 6,
      "completed_steps": 2,
      "overall_completion_percent": 33,
      "roadmaps": [
        {
          "id": "uuid",
          "career_name": "Software Engineer",
          "total_steps": 3,
          "completed_steps": 1,
          "completion_percent": 33,
          "next_step": {
            "id": "uuid",
            "title": "Start building core skills",
            "category": "skill_to_learn",
            "timeframe": "60 days"
          } | null
        }
      ],
      "interest_profile_summary": {
        "top_dimensions": ["A", "B", "C"],
        "dimension_scores": { ... }
      } | null,
      "top_3_matched_careers": []
    }
  }
  ```

---

## 7. AI Chat (`/ai`)

### 7.1 List Conversations
- **Endpoint**: `GET /api/v1/ai/conversations/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Query Parameters**:
  - `conversation_type`: string (optional) - "general" | "career_specific"
- **Response**:
  ```json
  {
    "success": true,
    "data": [
      {
        "id": "uuid",
        "conversation_type": "career_specific",
        "career": {
          "slug": "software-engineer",
          "name": "Software Engineer"
        } | null,
        "title": "Asking about software engineering...",
        "message_count": 4,
        "last_message_at": "ISO8601 datetime",
        "is_active": true
      }
    ]
  }
  ```

### 7.2 Start Conversation
- **Endpoint**: `POST /api/v1/ai/conversations/`
- **Status Code**: 201
- **Auth**: ✅ Required
- **Request Body**:
  ```json
  {
    "conversation_type": "general|career_specific",
    "career_slug": "software-engineer|null",
    "first_message": "What does a software engineer do?"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "conversation_id": "uuid",
      "conversation_type": "career_specific",
      "career": {
        "slug": "software-engineer",
        "name": "Software Engineer"
      } | null,
      "title": "What does a software engineer do?",
      "messages": [
        {
          "id": "uuid",
          "role": "user",
          "content": "What does a software engineer do?",
          "created_at": "ISO8601 datetime"
        },
        {
          "id": "uuid",
          "role": "assistant",
          "content": "Thank you for your question...",
          "tokens_used": 150,
          "model_version": "claude-haiku-4.5",
          "created_at": "ISO8601 datetime"
        }
      ]
    }
  }
  ```

### 7.3 Get Conversation History
- **Endpoint**: `GET /api/v1/ai/conversations/{conversation_id}/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `conversation_id`: UUID
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "conversation_id": "uuid",
      "conversation_type": "career_specific",
      "career": { ... } | null,
      "title": "...",
      "message_count": 4,
      "started_at": "ISO8601 datetime",
      "last_message_at": "ISO8601 datetime",
      "messages": [ ... ]
    }
  }
  ```

### 7.4 Send Message to Conversation
- **Endpoint**: `POST /api/v1/ai/conversations/{conversation_id}/messages/`
- **Status Code**: 201
- **Auth**: ✅ Required
- **Path Parameters**:
  - `conversation_id`: UUID
- **Request Body**:
  ```json
  {
    "content": "What skills do I need?"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "user_message": {
        "id": "uuid",
        "role": "user",
        "content": "What skills do I need?",
        "created_at": "ISO8601 datetime"
      },
      "assistant_message": {
        "id": "uuid",
        "role": "assistant",
        "content": "Great follow-up question...",
        "tokens_used": 200,
        "model_version": "claude-haiku-4.5",
        "created_at": "ISO8601 datetime"
      }
    }
  }
  ```

### 7.5 Delete Conversation
- **Endpoint**: `DELETE /api/v1/ai/conversations/{conversation_id}/`
- **Status Code**: 204 No Content
- **Auth**: ✅ Required
- **Path Parameters**:
  - `conversation_id`: UUID
- **Response**: Empty

---

## 8. Content (`/content`)

### 8.1 Get Career Stories
- **Endpoint**: `GET /api/v1/content/careers/{slug}/stories/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `slug`: string - Career slug
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "career_slug": "software-engineer",
      "stories": [
        {
          "id": "uuid",
          "person_name": "Rajesh Kumar",
          "person_age": 28,
          "person_city": "Bangalore",
          "person_background": "B.Tech Computer Science",
          "story_text": "When I started my journey... (hidden if premium-only & user is free)",
          "is_premium": false,
          "locked": false
        }
      ]
    }
  }
  ```

### 8.2 Get Career Resources
- **Endpoint**: `GET /api/v1/content/careers/{slug}/resources/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `slug`: string - Career slug
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "career_slug": "software-engineer",
      "resources": [
        {
          "id": "uuid",
          "title": "Introduction to Python",
          "url": "https://...",
          "provider": "Coursera",
          "resource_type": "course|article|video|podcast",
          "is_free": true
        }
      ]
    }
  }
  ```

---

## 9. Subscriptions (`/subscriptions`)

### 9.1 List Subscription Plans
- **Endpoint**: `GET /api/v1/subscriptions/plans/`
- **Status Code**: 200
- **Auth**: ❌ Not Required
- **Response**:
  ```json
  {
    "success": true,
    "data": [
      {
        "id": "uuid",
        "name": "premium_monthly",
        "display_name": "Premium Monthly",
        "price_paise": 49900,
        "price_inr": 499,
        "duration_days": 30,
        "features": {
          "career_matches": 50,
          "career_detail_full": true,
          "roadmap_steps_visible": 10,
          "ai_messages_per_day": 50,
          "stories_per_career": 5,
          "career_comparison": true,
          "parent_share": true,
          "progress_tracker": true
        }
      }
    ]
  }
  ```

### 9.2 Create Razorpay Order
- **Endpoint**: `POST /api/v1/subscriptions/create-order/`
- **Status Code**: 201
- **Auth**: ✅ Required
- **Request Body**:
  ```json
  {
    "plan_id": "uuid"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "transaction_id": "uuid",
      "razorpay_order_id": "order_...",
      "amount_paise": 49900,
      "currency": "INR",
      "razorpay_key_id": "rzp_live_..."
    }
  }
  ```

### 9.3 Verify Payment
- **Endpoint**: `POST /api/v1/subscriptions/verify-payment/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Request Body**:
  ```json
  {
    "transaction_id": "uuid",
    "razorpay_order_id": "order_...",
    "razorpay_payment_id": "pay_...",
    "razorpay_signature": "signature_..."
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "subscription_tier": "premium_monthly",
      "subscription_expires_at": "ISO8601 datetime",
      "transaction_id": "uuid",
      "payment_id": "pay_..."
    }
  }
  ```

### 9.4 Get Current Subscription
- **Endpoint**: `GET /api/v1/subscriptions/me/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "subscription_tier": "free|premium_monthly|premium_annual",
      "subscription_expires_at": "ISO8601 datetime|null",
      "days_remaining": 25,
      "is_active": true,
      "plan": null
    }
  }
  ```

---

## 10. Notifications (`/notifications`)

### 10.1 List Notifications
- **Endpoint**: `GET /api/v1/notifications/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Query Parameters**:
  - `is_read`: boolean (optional) - Filter by read status
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "unread_count": 3,
      "results": [
        {
          "id": "uuid",
          "type": "recommendation_ready|roadmap_milestone|new_story|system_alert",
          "title": "Your recommendations are ready!",
          "body": "Check out 15 careers...",
          "is_read": false,
          "sent_at": "ISO8601 datetime",
          "read_at": null
        }
      ]
    }
  }
  ```

### 10.2 Mark Notification as Read
- **Endpoint**: `PATCH /api/v1/notifications/{notification_id}/read/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `notification_id`: UUID
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "uuid",
      "is_read": true,
      "read_at": "ISO8601 datetime"
    }
  }
  ```

### 10.3 Mark All Notifications as Read
- **Endpoint**: `POST /api/v1/notifications/mark-all-read/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Request Body**: (empty)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "marked_read_count": 5
    }
  }
  ```

---

## 11. Check-Ins (`/check-ins`)

### 11.1 List Pending Check-ins
- **Endpoint**: `GET /api/v1/check-ins/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Response**:
  ```json
  {
    "success": true,
    "data": [
      {
        "id": "uuid",
        "prompt_type": "career_interest_confirmation",
        "career": {
          "slug": "software-engineer",
          "name": "Software Engineer"
        } | null,
        "question": "Still feeling interested in Software Engineer?",
        "options": [
          {
            "value": "still_yes",
            "label": "Yes, definitely!"
          },
          {
            "value": "not_sure",
            "label": "I'm not sure anymore"
          },
          {
            "value": "moved_on",
            "label": "I've moved on to something else"
          }
        ],
        "sent_at": "ISO8601 datetime"
      }
    ]
  }
  ```

### 11.2 Respond to Check-in
- **Endpoint**: `POST /api/v1/check-ins/{check_in_id}/respond/`
- **Status Code**: 200
- **Auth**: ✅ Required
- **Path Parameters**:
  - `check_in_id`: UUID
- **Request Body**:
  ```json
  {
    "response": "still_yes|not_sure|moved_on"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "check_in_id": "uuid",
      "response": "still_yes",
      "responded_at": "ISO8601 datetime",
      "next_action": null
    }
  }
  ```

---

## 12. Analytics (`/analytics`)

### 12.1 Log Event
- **Endpoint**: `POST /api/v1/analytics/events/`
- **Status Code**: 201
- **Auth**: ✅ Required
- **Request Body**:
  ```json
  {
    "event_name": "career_viewed|career_saved|roadmap_started|profiler_completed",
    "session_id": "string|null",
    "career_id": "uuid|null",
    "properties": {
      "custom_key": "custom_value"
    } | null
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "event_id": "uuid"
    }
  }
  ```
- **Notes**: Fire-and-forget endpoint; logged asynchronously

---

## 13. Counsellor Dashboard (`/counsellor`)

### 13.1 Get Counsellor Dashboard
- **Endpoint**: `GET /api/v1/counsellor/dashboard/`
- **Status Code**: 200
- **Auth**: ✅ Required (counsellor role)
- **Response**:
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
      "students_total": 250,
      "students_profiler_completed": 180,
      "profiler_completion_rate_percent": 72,
      "top_career_interests": [],
      "top_domains": [],
      "dimension_distribution": {}
    }
  }
  ```

### 13.2 List Students in Organization
- **Endpoint**: `GET /api/v1/counsellor/students/`
- **Status Code**: 200
- **Auth**: ✅ Required (counsellor role)
- **Query Parameters**:
  - `profiler_completed`: boolean (optional)
  - `academic_stage`: string (optional)
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "count": 180,
      "results": [
        {
          "student_id": "uuid",
          "display_name": "Student #1",
          "academic_stage": "grade_11_12_science",
          "profiler_completed": true,
          "top_matched_careers": [],
          "roadmaps_active": 2,
          "last_active_at": null
        }
      ]
    }
  }
  ```

---

## 14. Share View (`/share`)

### 14.1 Get Shared Student Profile (No Auth)
- **Endpoint**: `GET /api/v1/share/profile/{share_token}/`
- **Status Code**: 200
- **Auth**: ❌ Not Required (token is credential)
- **Path Parameters**:
  - `share_token`: string - Share token from user (format: "nxt_share_*")
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "student_first_name": "Student",
      "academic_stage": "Grade 11 Science",
      "profiler_completed": true,
      "top_matched_careers": [],
      "roadmap_summary": null,
      "counsellor_cta": {
        "text": "Want to discuss this with a counsellor?",
        "url": "https://nextstep.app/counsellors"
      }
    }
  }
  ```
- **Error**: 400 if invalid/expired token

---

## 15. Health Check

### 15.1 Health Status
- **Endpoint**: `GET /health`
- **Status Code**: 200
- **Auth**: ❌ Not Required
- **Response**:
  ```json
  {
    "status": "ok",
    "version": "2.0.0",
    "env": "development|staging|production"
  }
  ```

---

## Error Handling

All error responses follow this format:
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": {}
  }
}
```

Common error codes:
- `PROFILER_NOT_COMPLETED` (422) - User must complete profiler first
- `CAREER_NOT_FOUND` (404) - Career/resource doesn't exist
- `PROFILER_SESSION_NOT_FOUND` (404) - Session invalid or doesn't belong to user
- `VALIDATION_ERROR` (422) - Invalid request parameters
- `PERMISSION_DENIED` (403) - Insufficient permissions
- `INTERNAL_ERROR` (500) - Server error
- `PAYMENT_SIGNATURE_INVALID` (400) - Razorpay signature verification failed
- `SHARE_TOKEN_INVALID` (400) - Invalid or expired share token

---

## Authentication

### JWT Token Flow
1. Client obtains Firebase ID token from Firebase client SDK
2. Client sends `POST /api/v1/auth/firebase/` with Firebase token
3. Backend validates token with Firebase, creates/returns user, issues JWT pair
4. Client stores `access` (short-lived, ~15 min) and `refresh` (long-lived, ~7 days)
5. Client includes `Authorization: Bearer <access_token>` in requests
6. When access expires, use `POST /api/v1/auth/token/refresh/` with refresh token

### Headers
- **Authorization**: `Bearer <JWT_access_token>` (all authenticated endpoints)
- **Content-Type**: `application/json` (POST/PATCH with JSON body)
- **Content-Type**: `multipart/form-data` (file uploads)

---

## Pagination

- **Query Parameters**: `page` (1-indexed, default: 1), `page_size` (default: 20, max: 100)
- **Response Fields**: `count` (total), `next` (pagination URL or null), `previous`, `results`

---

## Enum Values

**User Types**: `student` | `counsellor` | `parent`
**Subscription Tiers**: `free` | `premium_monthly` | `premium_annual`
**Academic Stages**: `grade_8_9` | `grade_10` | `grade_11_12_science` | `grade_11_12_commerce` | `grade_11_12_arts` | `college_year_1_2`
**Roadmap Step Status**: `not_started` | `in_progress` | `completed`
**Conversation Types**: `general` | `career_specific`
**Match Tiers**: `full_match` | `partial_match` | `discovery_match`
**India Viability**: `high` | `medium` | `low`
**Dimension Codes**: `A` | `B` | `C` | `T` | ... (from profiler questions)

---

## Notes

- All timestamps are in ISO8601 format with UTC timezone
- Salary values in "LPA" format (Lakhs Per Annum, Indian currency)
- Paise is the smallest unit of INR (100 paise = 1 INR)
- Career slugs are URL-friendly lowercase with hyphens
- All UUIDs are returned as strings, not binary
- Async tasks (recommendations generation, event logging) run in background Celery workers
- Premium features are gated by `subscription_tier`
- Some endpoints are role-locked (e.g., counsellor dashboard requires `user_type == "counsellor"`)

---

**Generated**: May 30, 2026  
**API Version**: 2.0.0  
**Backend Framework**: FastAPI 0.104+  
**Documentation**: See `/docs` endpoint for interactive Swagger UI
