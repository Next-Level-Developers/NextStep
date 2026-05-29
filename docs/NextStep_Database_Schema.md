# NextStep — Database Schema
> Stack: Django ORM → PostgreSQL (AWS RDS Free Tier) | Auth: Firebase | Storage: AWS S3

---

## Design Principles

- Firebase owns identity. Django stores only `firebase_uid` — never passwords.
- UUIDs as primary keys everywhere (safe for distributed inserts, no sequential guessing).
- Dimension scores stored as `JSONB` — flexible, indexed, queryable.
- Career tags stored as `VARCHAR[]` (Postgres array) — fast `&&` overlap queries for matching.
- Soft-deletes (`is_active` flag) on all user-facing data so nothing is unrecoverable.
- All monetary values in paise (integer) — no floating-point currency bugs.

---

## Schema Groups

1. Users & Auth
2. Onboarding & Interest Profiling
3. Career Universe
4. Career Matching & Recommendations
5. Roadmaps & Progress
6. AI Conversations
7. Content (Stories, Resources)
8. Subscriptions & Access Control
9. Notifications & Check-ins
10. Analytics & Events

---

## 1. Users & Auth

### `users`
Core identity table. Firebase handles passwords and tokens — this table stores profile data only.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK, default gen_random_uuid() | |
| `firebase_uid` | VARCHAR(128) | UNIQUE, NOT NULL | From Firebase Auth |
| `email` | VARCHAR(255) | UNIQUE, NOT NULL | Synced from Firebase |
| `full_name` | VARCHAR(200) | NULLABLE | Collected post-profiler |
| `phone` | VARCHAR(20) | NULLABLE | Optional, India format |
| `avatar_url` | TEXT | NULLABLE | S3 path |
| `user_type` | VARCHAR(20) | NOT NULL | `student`, `parent`, `counsellor`, `school_admin` |
| `subscription_tier` | VARCHAR(20) | NOT NULL, default `free` | `free`, `premium`, `school` |
| `subscription_expires_at` | TIMESTAMPTZ | NULLABLE | NULL = free tier |
| `parental_consent_given` | BOOLEAN | default FALSE | Required for users under 16 |
| `parental_consent_at` | TIMESTAMPTZ | NULLABLE | |
| `is_active` | BOOLEAN | default TRUE | Soft delete |
| `created_at` | TIMESTAMPTZ | default NOW() | |
| `updated_at` | TIMESTAMPTZ | auto-update | |

**Indexes:** `firebase_uid`, `email`, `subscription_tier`

---

### `student_profiles`
Extended profile for students. Separated from `users` to keep the core table lean.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id, UNIQUE | One profile per student |
| `academic_stage` | VARCHAR(30) | NOT NULL | `grade_8_9`, `grade_10`, `grade_11_12_science`, `grade_11_12_commerce`, `grade_11_12_arts`, `college_year_1_2` |
| `grade_or_year` | VARCHAR(10) | NULLABLE | e.g. `"10"`, `"Year 1"` |
| `school_name` | VARCHAR(255) | NULLABLE | |
| `city` | VARCHAR(100) | NULLABLE | |
| `state` | VARCHAR(100) | NULLABLE | India state |
| `career_clarity` | VARCHAR(30) | NULLABLE | `clear`, `few_options`, `none`, `wants_to_explore` |
| `pressure_level` | VARCHAR(20) | NULLABLE | `high`, `some`, `low`, `very_high` |
| `career_awareness_level` | VARCHAR(20) | NULLABLE | `narrow` (5-10), `moderate` (20-30), `broad`, `focused` |
| `profiler_completed` | BOOLEAN | default FALSE | |
| `profiler_completed_at` | TIMESTAMPTZ | NULLABLE | |
| `created_at` | TIMESTAMPTZ | default NOW() | |
| `updated_at` | TIMESTAMPTZ | auto-update | |

---

### `school_organisations`
For B2B school/institute partnerships.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `name` | VARCHAR(255) | NOT NULL | |
| `type` | VARCHAR(30) | NOT NULL | `school`, `coaching_institute`, `college` |
| `city` | VARCHAR(100) | | |
| `state` | VARCHAR(100) | | |
| `contact_email` | VARCHAR(255) | | |
| `licence_seats` | INTEGER | default 0 | Max students allowed |
| `licence_expires_at` | TIMESTAMPTZ | NULLABLE | |
| `is_active` | BOOLEAN | default TRUE | |
| `created_at` | TIMESTAMPTZ | default NOW() | |

---

### `school_memberships`
Links students and counsellors to a school organisation.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `organisation_id` | UUID | FK → school_organisations.id | |
| `role` | VARCHAR(20) | NOT NULL | `student`, `counsellor`, `admin` |
| `joined_at` | TIMESTAMPTZ | default NOW() | |

**Unique constraint:** `(user_id, organisation_id)`

---

## 2. Onboarding & Interest Profiling

### `profiler_sessions`
One row per profiler attempt. Students can retake — each retake is a new session.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `session_number` | SMALLINT | NOT NULL, default 1 | Increments on retake |
| `status` | VARCHAR(20) | NOT NULL, default `in_progress` | `in_progress`, `completed`, `abandoned` |
| `total_questions` | SMALLINT | default 24 | |
| `questions_answered` | SMALLINT | default 0 | For progress bar |
| `questions_skipped` | SMALLINT | default 0 | |
| `started_at` | TIMESTAMPTZ | default NOW() | |
| `completed_at` | TIMESTAMPTZ | NULLABLE | |
| `time_taken_seconds` | INTEGER | NULLABLE | |

**Index:** `user_id`, `status`

---

### `profiler_responses`
Every individual answer a student gives during a session.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `session_id` | UUID | FK → profiler_sessions.id | |
| `question_code` | VARCHAR(10) | NOT NULL | e.g. `Q1`, `SC-1`, `Q24` |
| `question_section` | VARCHAR(30) | NOT NULL | `context`, `free_time`, `problem_solving`, `work_style`, `values`, `subjects`, `skills`, `awareness`, `final_signal` |
| `selected_option_index` | SMALLINT[] | NOT NULL | Array supports multi-select questions |
| `dimension_weights` | JSONB | NOT NULL | e.g. `{"C": 1, "A": 0.5}` |
| `skipped` | BOOLEAN | default FALSE | |
| `answered_at` | TIMESTAMPTZ | default NOW() | |

**Index:** `session_id`

---

### `interest_profiles`
The computed dimension scores after profiler completion. One row per completed session.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `session_id` | UUID | FK → profiler_sessions.id, UNIQUE | |
| `is_active` | BOOLEAN | default TRUE | Only one active profile per user |
| `dimension_scores` | JSONB | NOT NULL | `{"C": 82, "A": 74, "T": 68, "S": 41, "E": 35, "P": 12}` |
| `top_dimensions` | VARCHAR(2)[] | NOT NULL | e.g. `["C", "A", "T"]` |
| `career_cluster_weights` | JSONB | NOT NULL | Weighted cluster scores used for matching |
| `awareness_known_careers` | VARCHAR(100)[] | NULLABLE | Careers ticked in Q21 |
| `computed_at` | TIMESTAMPTZ | default NOW() | |

**Index:** `user_id`, `is_active`

> **Query tip:** `WHERE is_active = TRUE AND user_id = $1` always returns the current working profile.

---

## 3. Career Universe

### `careers`
Master career database. 300+ rows, mostly seeded — updated quarterly.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `slug` | VARCHAR(100) | UNIQUE, NOT NULL | URL-safe, e.g. `ux-designer` |
| `name` | VARCHAR(150) | NOT NULL | Display name |
| `one_liner` | VARCHAR(300) | NOT NULL | "What you actually do" in one sentence |
| `domain_id` | UUID | FK → career_domains.id | |
| `dimension_tags` | VARCHAR(2)[] | NOT NULL | e.g. `["C", "A", "T"]` — max 3 |
| `india_viability` | VARCHAR(20) | NOT NULL | `very_high`, `high`, `medium`, `low` |
| `future_score` | SMALLINT | CHECK 1–10 | |
| `future_score_reasoning` | TEXT | NULLABLE | Shown to users |
| `typical_day` | TEXT | NULLABLE | Narrative paragraph |
| `skills_needed` | TEXT[] | NULLABLE | Array of skill labels |
| `entry_paths` | TEXT[] | NULLABLE | e.g. `["B.Tech", "BCA", "Self-taught"]` |
| `salary_entry_min_paise` | BIGINT | NULLABLE | Annual, in paise |
| `salary_entry_max_paise` | BIGINT | NULLABLE | |
| `salary_mid_min_paise` | BIGINT | NULLABLE | |
| `salary_mid_max_paise` | BIGINT | NULLABLE | |
| `salary_senior_min_paise` | BIGINT | NULLABLE | |
| `salary_senior_max_paise` | BIGINT | NULLABLE | |
| `related_career_ids` | UUID[] | NULLABLE | Cross-links to similar careers |
| `is_emerging` | BOOLEAN | default FALSE | Future careers flagged 🔮 |
| `is_active` | BOOLEAN | default TRUE | |
| `last_reviewed_at` | DATE | NULLABLE | For quarterly refresh tracking |
| `created_at` | TIMESTAMPTZ | default NOW() | |
| `updated_at` | TIMESTAMPTZ | auto-update | |

**Indexes:** 
- `slug` (unique lookup)
- `domain_id`
- `GIN index on dimension_tags` — for `dimension_tags && ARRAY['C','A']` overlap queries
- `future_score`
- `india_viability`

---

### `career_domains`
The 25 top-level domains (Technology, Healthcare, Design, etc.)

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `slug` | VARCHAR(80) | UNIQUE | e.g. `technology-software` |
| `name` | VARCHAR(150) | NOT NULL | e.g. `Technology & Software Engineering` |
| `short_name` | VARCHAR(60) | NOT NULL | e.g. `Technology` |
| `india_relevance` | VARCHAR(20) | | `very_high`, `high`, `medium` |
| `growth_forecast_2035` | VARCHAR(20) | | `very_strong`, `strong`, `moderate` |
| `entry_path_summary` | VARCHAR(300) | | |
| `display_order` | SMALLINT | | For UI ordering |
| `is_active` | BOOLEAN | default TRUE | |

---

### `career_clusters`
The 8 high-level clusters shown to students in Q24 (broader than domains).

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `name` | VARCHAR(100) | NOT NULL | e.g. `Technology, AI, Engineering` |
| `q24_description` | TEXT | | The Q24 option text |
| `domain_ids` | UUID[] | | Domains that belong to this cluster |

---

## 4. Career Matching & Recommendations

### `career_recommendations`
Generated when a student completes (or retakes) the profiler. One set per profile.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `interest_profile_id` | UUID | FK → interest_profiles.id | |
| `career_id` | UUID | FK → careers.id | |
| `match_score` | SMALLINT | NOT NULL, CHECK 0–100 | e.g. 87 |
| `match_tier` | VARCHAR(20) | NOT NULL | `full_match` (3/3 tags), `partial_match` (2/3), `discovery_match` (1/3 + high future score) |
| `tag_overlap_count` | SMALLINT | NOT NULL | 1, 2, or 3 |
| `display_rank` | SMALLINT | NOT NULL | Sort order shown to student |
| `is_novel` | BOOLEAN | default FALSE | TRUE if career was NOT in student's awareness list (Q21) |
| `generated_at` | TIMESTAMPTZ | default NOW() | |

**Index:** `user_id`, `interest_profile_id`

> **Matching logic runs in Python/Django**, not in DB. Profile→career cosine similarity computed server-side on session completion, results written here. Regenerated on retake.

---

### `career_views`
Tracks which career cards a student tapped and how long they read.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `career_id` | UUID | FK → careers.id | |
| `source` | VARCHAR(30) | | `recommendation`, `search`, `related`, `ai_suggestion` |
| `viewed_at` | TIMESTAMPTZ | default NOW() | |
| `time_spent_seconds` | INTEGER | NULLABLE | |
| `reached_roadmap` | BOOLEAN | default FALSE | Did they continue to the Plan step? |

**Index:** `user_id`, `career_id`

---

### `career_saves`
Student's saved / bookmarked careers.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `career_id` | UUID | FK → careers.id | |
| `saved_at` | TIMESTAMPTZ | default NOW() | |
| `notes` | TEXT | NULLABLE | Student's personal note |

**Unique constraint:** `(user_id, career_id)`

---

## 5. Roadmaps & Progress

### `roadmaps`
A personalised roadmap generated for a student + career combination.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `career_id` | UUID | FK → careers.id | |
| `interest_profile_id` | UUID | FK → interest_profiles.id | Profile used to generate |
| `academic_stage` | VARCHAR(30) | NOT NULL | Snapshot of stage at generation time |
| `generation_method` | VARCHAR(20) | default `template` | `template`, `ai_generated` |
| `is_active` | BOOLEAN | default TRUE | |
| `generated_at` | TIMESTAMPTZ | default NOW() | |
| `last_updated_at` | TIMESTAMPTZ | auto-update | |

**Unique constraint:** `(user_id, career_id)` where `is_active = TRUE`

---

### `roadmap_steps`
Individual steps within a roadmap. Ordered sequence.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `roadmap_id` | UUID | FK → roadmaps.id | |
| `step_order` | SMALLINT | NOT NULL | 1, 2, 3… |
| `category` | VARCHAR(30) | NOT NULL | `subject_focus`, `skill_to_learn`, `project_to_build`, `internship`, `certification`, `first_30_days` |
| `title` | VARCHAR(300) | NOT NULL | |
| `description` | TEXT | NULLABLE | |
| `timeframe` | VARCHAR(50) | NULLABLE | e.g. `30 days`, `Grade 11`, `Before college` |
| `resource_url` | TEXT | NULLABLE | Free resource link |
| `resource_label` | VARCHAR(200) | NULLABLE | e.g. `Google UX Certificate on Coursera` |
| `is_premium` | BOOLEAN | default FALSE | Locked behind subscription |

**Index:** `roadmap_id`

---

### `roadmap_step_progress`
Tracks which steps a student has completed.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `roadmap_step_id` | UUID | FK → roadmap_steps.id | |
| `status` | VARCHAR(20) | NOT NULL, default `not_started` | `not_started`, `in_progress`, `completed` |
| `completed_at` | TIMESTAMPTZ | NULLABLE | |
| `notes` | TEXT | NULLABLE | Student notes on this step |

**Unique constraint:** `(user_id, roadmap_step_id)`
**Index:** `user_id`

---

## 6. AI Conversations

### `ai_conversations`
One conversation thread per context. Stores the full exchange for continuity.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `conversation_type` | VARCHAR(20) | NOT NULL | `general` (General AI), `career_specific` (Career AI) |
| `career_id` | UUID | FK → careers.id, NULLABLE | Only set for `career_specific` type |
| `title` | VARCHAR(300) | NULLABLE | Auto-generated from first message |
| `is_active` | BOOLEAN | default TRUE | |
| `started_at` | TIMESTAMPTZ | default NOW() | |
| `last_message_at` | TIMESTAMPTZ | | Updated on each message |
| `message_count` | INTEGER | default 0 | |

**Index:** `user_id`, `conversation_type`

---

### `ai_messages`
Individual messages within a conversation.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `conversation_id` | UUID | FK → ai_conversations.id | |
| `role` | VARCHAR(10) | NOT NULL | `user`, `assistant` |
| `content` | TEXT | NOT NULL | Message text |
| `tokens_used` | INTEGER | NULLABLE | For cost tracking |
| `model_version` | VARCHAR(50) | NULLABLE | e.g. `claude-sonnet-4-20250514` |
| `created_at` | TIMESTAMPTZ | default NOW() | |

**Index:** `conversation_id`, `created_at`

> **Context injection strategy:** When sending to AI, server attaches student's `interest_profile`, `academic_stage`, and (for career AI) the full `career` record. These are never stored in `ai_messages` — they are injected fresh per request from the DB.

---

## 7. Content

### `real_people_stories`
Professional stories linked to a career. Can be used in Career Deep Dive.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `career_id` | UUID | FK → careers.id | |
| `person_name` | VARCHAR(150) | NOT NULL | e.g. `Shreya` (first name only for privacy) |
| `person_age` | SMALLINT | NULLABLE | |
| `person_city` | VARCHAR(100) | NULLABLE | |
| `person_background` | VARCHAR(300) | NULLABLE | e.g. `Studied Commerce, no design degree` |
| `story_text` | TEXT | NOT NULL | The narrative |
| `is_premium` | BOOLEAN | default FALSE | |
| `is_active` | BOOLEAN | default TRUE | |
| `created_at` | TIMESTAMPTZ | default NOW() | |

---

### `learning_resources`
Curated free resources linked to specific skills or roadmap step categories.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `title` | VARCHAR(300) | NOT NULL | |
| `url` | TEXT | NOT NULL | |
| `provider` | VARCHAR(150) | | e.g. `Coursera`, `YouTube`, `Internshala` |
| `resource_type` | VARCHAR(30) | | `course`, `video`, `article`, `internship_platform`, `certification` |
| `career_ids` | UUID[] | | Careers this resource is relevant to |
| `skill_tags` | TEXT[] | | |
| `is_free` | BOOLEAN | default TRUE | |
| `is_active` | BOOLEAN | default TRUE | |
| `created_at` | TIMESTAMPTZ | default NOW() | |

---

## 8. Subscriptions & Access Control

### `subscription_plans`
Defines available plans (seed data — rarely changes).

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `name` | VARCHAR(50) | UNIQUE | `free`, `premium_monthly`, `premium_yearly`, `school` |
| `price_paise` | INTEGER | NOT NULL | 0 for free |
| `duration_days` | INTEGER | NULLABLE | 30, 365, etc. |
| `features` | JSONB | NOT NULL | Feature flags |

---

### `subscription_transactions`
Payment records. Integrate with Razorpay for India.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `plan_id` | UUID | FK → subscription_plans.id | |
| `razorpay_order_id` | VARCHAR(200) | UNIQUE, NULLABLE | |
| `razorpay_payment_id` | VARCHAR(200) | NULLABLE | |
| `amount_paise` | INTEGER | NOT NULL | |
| `status` | VARCHAR(20) | NOT NULL | `pending`, `success`, `failed`, `refunded` |
| `created_at` | TIMESTAMPTZ | default NOW() | |
| `updated_at` | TIMESTAMPTZ | auto-update | |

---

## 9. Notifications & Check-ins

### `check_in_prompts`
Monthly check-ins sent to keep students engaged and profiles fresh.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `career_id` | UUID | FK → careers.id, NULLABLE | Career being checked on |
| `prompt_type` | VARCHAR(30) | NOT NULL | `career_still_interested`, `roadmap_milestone`, `profile_update` |
| `sent_at` | TIMESTAMPTZ | | |
| `responded_at` | TIMESTAMPTZ | NULLABLE | |
| `response` | VARCHAR(20) | NULLABLE | `still_yes`, `not_sure`, `moved_on` |

---

### `notifications`
In-app and push notification log.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id | |
| `type` | VARCHAR(50) | NOT NULL | `roadmap_reminder`, `check_in`, `new_career_match`, `subscription_expiry` |
| `title` | VARCHAR(200) | NOT NULL | |
| `body` | TEXT | | |
| `is_read` | BOOLEAN | default FALSE | |
| `sent_at` | TIMESTAMPTZ | default NOW() | |
| `read_at` | TIMESTAMPTZ | NULLABLE | |

---

## 10. Analytics & Events

### `analytics_events`
Lightweight event stream. Feed into PostHog or Mixpanel — also kept in DB for school dashboards.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | UUID | PK | |
| `user_id` | UUID | FK → users.id, NULLABLE | NULL for anonymous |
| `session_id` | VARCHAR(100) | NULLABLE | App session (not profiler session) |
| `event_name` | VARCHAR(100) | NOT NULL | e.g. `profiler_started`, `career_viewed`, `roadmap_step_completed` |
| `properties` | JSONB | NULLABLE | Flexible payload |
| `career_id` | UUID | NULLABLE | Denormalised for fast career analytics |
| `organisation_id` | UUID | NULLABLE | For school-level dashboards |
| `occurred_at` | TIMESTAMPTZ | default NOW() | |

**Index:** `user_id`, `event_name`, `occurred_at`  
**Partition by:** `occurred_at` (monthly partitions — this table grows fast)

---

## Key Relationships Summary

```
users
 ├── student_profiles (1:1)
 ├── school_memberships (1:many)
 ├── profiler_sessions (1:many)
 │    └── profiler_responses (1:many)
 ├── interest_profiles (1:many, 1 active)
 ├── career_recommendations (via interest_profile)
 ├── career_saves (many:many with careers)
 ├── roadmaps (1:many)
 │    └── roadmap_steps → roadmap_step_progress
 ├── ai_conversations (1:many)
 │    └── ai_messages (1:many)
 └── analytics_events (1:many)

careers
 ├── career_domains (many:1)
 ├── career_recommendations (1:many)
 ├── career_views (1:many)
 ├── roadmaps (1:many)
 ├── real_people_stories (1:many)
 └── ai_conversations (1:many, career-specific)
```

---

## AWS Free Tier Fit

| Service | Usage | Free Tier Limit |
|---|---|---|
| RDS PostgreSQL (db.t3.micro) | All tables above | 750 hrs/month, 20GB storage |
| S3 | Avatar images, exports | 5GB storage, 20k GET requests |
| EC2 (t2.micro) | Django app server | 750 hrs/month |
| Firebase | Auth only | Spark plan: unlimited Auth |

> **Tip:** Enable RDS automated backups (free within the 20GB limit). Enable S3 versioning only for the uploads bucket, not the static assets bucket.

---

*NextStep Database Schema v1.0 — aligned with product document v1.0*
