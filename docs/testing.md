# NextStep API — Testing Guide & Report Prompt
> **Version:** 1.0 | `| **Auth:** Firebase + DRF SimpleJWT

---

## How to Use This Document

This guide is structured as a **prompt-based testing reference**. For each module, you will find:

- The endpoint to call
- What to send (headers, body, params)
- What to verify in the response
- Edge cases and negative tests to run
- What to record in the report

Use a tool like **Postman**, **Insomnia**, or **curl** to execute the tests. After each test, fill in the result columns in the report table at the end.

---

## Pre-Testing Setup

Before running any test, complete this checklist:

**Environment Variables to configure:**
```
BASE_URL = https://api.nextstep.app/api/v1
FIREBASE_TOKEN = <obtain from Firebase Auth — use test account>
JWT_ACCESS_TOKEN = <exchange Firebase token via /auth/firebase/>
JWT_REFRESH_TOKEN = <received alongside access token>
```

**Test User Accounts to prepare:**
- `student_free@test.com` — free tier student with completed profiler
- `student_premium@test.com` — premium tier student
- `student_new@test.com` — new user, profiler NOT completed
- `counsellor@test.com` — counsellor account linked to a school organisation

**Standard Auth Header (attach to all authenticated requests):**
```
Authorization: Bearer <JWT_ACCESS_TOKEN>
Content-Type: application/json
Accept: application/json
```

---

## Module 1 — Authentication & Token Flow

**Purpose:** Verify Firebase → Django JWT exchange, token refresh, and logout/invalidation.

### Test 1.1 — Firebase Token Exchange
```
POST /api/v1/auth/firebase/
Body: { "firebase_token": "<valid_firebase_id_token>" }
```
Verify:
- Status is `201`
- Response contains `access`, `refresh`, `is_new_user`, and `user` fields
- `user.user_type` is one of `student` / `counsellor`
- `user.subscription_tier` is present (default `free`)
- `access` token is a valid JWT (decode and check `exp` is ~1 hour from now)

Negative test — send an expired or malformed Firebase token:
- Expect `401` with error code `INVALID_FIREBASE_TOKEN`

### Test 1.2 — Token Refresh
```
POST /api/v1/auth/token/refresh/
Body: { "refresh": "<JWT_REFRESH_TOKEN>" }
```
Verify:
- Status is `200`
- A new `access` token is returned
- Old access token still works until expiry (test this)

Negative test — send an invalid or already-used refresh token:
- Expect `401` with error code `TOKEN_EXPIRED`

### Test 1.3 — Unauthenticated Request Guard
```
GET /api/v1/users/me/
(No Authorization header)
```
Verify:
- Status is `401`
- `success` is `false`
- Error code is returned

---

## Module 2 — Users & Student Profile

**Purpose:** Verify profile retrieval, update, avatar upload, and student profile management.

### Test 2.1 — Get Current User
```
GET /api/v1/users/me/
Auth: student_free token
```
Verify:
- Status is `200`
- `data.id`, `data.email`, `data.user_type` are present
- `data.student_profile` is nested with `academic_stage`, `profiler_completed`, etc.
- No passwords or sensitive Firebase data are exposed

### Test 2.2 — Update User Name and Phone
```
PATCH /api/v1/users/me/
Body: { "full_name": "Test User", "phone": "+91 9999999999" }
```
Verify:
- Status is `200`
- Updated fields are reflected in the response
- Unpatched fields are unchanged (e.g. email, user_type)

### Test 2.3 — Avatar Upload
```
POST /api/v1/users/me/avatar/
Content-Type: multipart/form-data
Body: file = <valid .jpg image under 5MB>
```
Verify:
- Status is `200`
- `avatar_url` points to an S3 URL (starts with `https://nextstep-assets.s3.amazonaws.com`)
- URL is accessible (open in browser)

Negative tests:
- Upload a file over 5MB → expect `400`
- Upload a `.pdf` file → expect `400`

### Test 2.4 — Create Student Profile (Onboarding)
```
PUT /api/v1/users/me/student-profile/
Body:
{
  "academic_stage": "grade_11_12_science",
  "grade_or_year": "11",
  "school_name": "Test School",
  "city": "Mumbai",
  "state": "Maharashtra",
  "career_clarity": "few_options",
  "pressure_level": "high",
  "career_awareness_level": "narrow"
}
```
Verify:
- Status is `200`
- All submitted fields are returned correctly
- Enum values are accepted (test all valid `academic_stage` options)

Negative test — send an invalid enum value for `academic_stage`:
- Expect `400` with `VALIDATION_ERROR`

### Test 2.5 — Parental Consent
```
POST /api/v1/users/me/parental-consent/
Body: { "consent_given": true, "parent_name": "Test Parent", "parent_phone": "+91 9876500000" }
```
Verify:
- Status is `200`
- `parental_consent_given` is `true`
- `parental_consent_at` timestamp is returned

### Test 2.6 — Account Soft Delete
```
DELETE /api/v1/users/me/
```
Verify:
- Status is `204`
- Subsequent GET /users/me/ with same token returns `401` or `403`
- Verify in DB that `is_active = false` (if you have DB access)

---

## Module 3 — Interest Profiler

**Purpose:** Verify the full profiler flow — questions, session creation, answer submission, and completion with scoring.

### Test 3.1 — Fetch All Questions
```
GET /api/v1/profiler/questions/
```
Verify:
- Status is `200`
- At least 27 questions are returned
- Each question has `code`, `question_type`, `is_scored`, and `options`
- Context questions (SC-1 to SC-5) have `is_scored: false`
- Scored questions (Q1–Q24) have `is_scored: true` and `dimension_weights` in options

### Test 3.2 — Start a New Session
```
POST /api/v1/profiler/sessions/
Body: (empty)
```
Verify:
- Status is `201`
- `session_id` (UUID) is returned
- `status` is `in_progress`
- `total_questions` is `27`
- `questions_answered` is `0`
- Save the `session_id` for subsequent tests

### Test 3.3 — Resume Session
```
GET /api/v1/profiler/sessions/{session_id}/
```
Verify:
- Status is `200`
- `session_id` matches
- Progress fields are accurate

Negative test — use a session ID belonging to another user:
- Expect `404` with `PROFILER_SESSION_NOT_FOUND`

### Test 3.4 — Submit Responses (Batch)
```
POST /api/v1/profiler/sessions/{session_id}/responses/
Body:
{
  "responses": [
    { "question_code": "SC-1", "question_section": "context", "selected_option_index": [1], "skipped": false },
    { "question_code": "Q1", "question_section": "free_time", "selected_option_index": [0], "skipped": false },
    { "question_code": "Q2", "question_section": "free_time", "selected_option_index": [0, 1], "skipped": false }
  ]
}
```
Verify:
- Status is `200`
- `questions_answered` increments correctly
- `progress_percent` updates

Negative tests:
- Submit an invalid `question_code` (e.g. `"Q99"`) → expect `400`
- Submit `selected_option_index` out of bounds → expect `400`
- Submit more selections than `max_selections` on multi-select questions → expect `400`

### Test 3.5 — Complete Session (Scoring)
After answering all 27 questions:
```
POST /api/v1/profiler/sessions/{session_id}/complete/
Body: (empty)
```
Verify:
- Status is `200`
- `status` is `completed`
- `interest_profile.dimension_scores` contains keys `C`, `A`, `T`, `S`, `E`, `P` with values 0–100
- `top_dimensions` lists 2–3 dimension codes
- `recommendations_ready` is `false` with `recommendations_eta_seconds` around 3
- Wait 5 seconds, then call GET /recommendations/ and verify it returns results

Negative test — complete a session that is already completed:
- Expect `409` or graceful handling

### Test 3.6 — Get Active Interest Profile
```
GET /api/v1/profiler/profile/
```
Verify:
- Status is `200` for `student_free` (profiler completed)
- Status is `404` for `student_new` (profiler not done yet)
- `dimension_scores` sums to a reasonable distribution
- `career_cluster_weights` is present and has domain names as keys

---

## Module 4 — Career Universe

**Purpose:** Verify career list, detail, domain browsing, clusters, comparison, and search/filter behaviour.

### Test 4.1 — List All Careers (Paginated)
```
GET /api/v1/careers/?page=1&page_size=20
```
Verify:
- Status is `200`
- `data.count` is >= 300 (seeded with 300+ careers)
- `data.next` points to page 2
- Each career has `slug`, `name`, `one_liner`, `future_score`, `india_viability`, `salary_entry_lpa`

### Test 4.2 — Search Careers
```
GET /api/v1/careers/?search=designer
```
Verify:
- Status is `200`
- All results contain "designer" in `name`, `one_liner`, or related fields
- Empty search query returns all careers (paginated)

### Test 4.3 — Filter by Domain
```
GET /api/v1/careers/?domain_slug=design-visual-arts
```
Verify:
- All returned careers belong to Design & Visual Arts domain

### Test 4.4 — Filter by Future Score
```
GET /api/v1/careers/?future_score_min=8&ordering=-future_score
```
Verify:
- All careers have `future_score >= 8`
- Results are sorted highest score first

### Test 4.5 — Filter Emerging Careers
```
GET /api/v1/careers/?is_emerging=true
```
Verify:
- All returned careers have `is_emerging: true`

### Test 4.6 — Career Detail
```
GET /api/v1/careers/ux-designer/
```
Verify:
- Status is `200`
- Full detail fields are present: `typical_day`, `skills_needed`, `entry_paths`, `future_score_reasoning`, `salary_*_lpa`
- `is_saved` is a boolean
- `user_match_score` is returned (if profiler completed)
- `related_careers` array is non-empty

Negative test — use a non-existent slug:
- Expect `404` with `CAREER_NOT_FOUND`

### Test 4.7 — List Domains
```
GET /api/v1/careers/domains/
```
Verify:
- Status is `200`
- Multiple domains returned with `slug`, `name`, `career_count`

### Test 4.8 — Domain Detail with Careers
```
GET /api/v1/careers/domains/technology-software/
```
Verify:
- Status is `200`
- `careers` array is non-empty
- Each career inside has `slug`, `name`, `future_score`

### Test 4.9 — Career Clusters
```
GET /api/v1/careers/clusters/
```
Verify:
- Status is `200`
- 8 clusters returned
- Each cluster has `name`, `q24_description`, `career_count`

### Test 4.10 — Career Comparison (Premium Feature)
```
GET /api/v1/careers/compare/?slugs=ux-designer,ui-designer,product-designer
Auth: student_premium token
```
Verify:
- Status is `200`
- `careers` array has exactly 3 items
- Each career has `user_skill_overlap`, `entry_difficulty`, `time_to_first_job_months`

Negative tests:
- Use `student_free` token (free tier) → expect `403` with `SUBSCRIPTION_REQUIRED` or limited use
- Supply only 1 slug → expect `400` (minimum 2 required)
- Supply 4 slugs → expect `400` (maximum 3)

---

## Module 5 — Career Recommendations

**Purpose:** Verify personalized match generation, tier filtering, and regeneration.

### Test 5.1 — Get Recommendations (After Profiler Complete)
```
GET /api/v1/recommendations/
Auth: student_free token (profiler completed)
```
Verify:
- Status is `200`
- `recommendations` array is non-empty (up to 15 by default)
- Each item has `rank`, `match_score` (0–100), `match_tier`, `career` object
- `match_tier` values are `full_match`, `partial_match`, or `discovery_match`
- Rank 1 has the highest `match_score`

### Test 5.2 — Filter by Tier
```
GET /api/v1/recommendations/?tier=full_match
```
Verify:
- All returned recommendations have `match_tier: "full_match"`

### Test 5.3 — Recommendations Without Profiler
```
GET /api/v1/recommendations/
Auth: student_new token (profiler NOT done)
```
Verify:
- Status is `422`
- Error code is `PROFILER_NOT_COMPLETED`

### Test 5.4 — Force Regenerate Recommendations
```
POST /api/v1/recommendations/regenerate/
Body: (empty)
```
Verify:
- Status is `200`
- Response contains `status: "regenerating"` and `eta_seconds`
- After waiting, GET /recommendations/ returns fresh results

---

## Module 6 — Career Actions (Save, View, Notes)

**Purpose:** Verify bookmarking, unsaving, note updates, and view tracking.

### Test 6.1 — Save a Career
```
POST /api/v1/careers/ux-designer/save/
Body: { "notes": "Research this more" }
```
Verify:
- Status is `201`
- `save_id` is returned
- `career_slug` matches

Negative test — save the same career again:
- Expect `409` with `ALREADY_SAVED`

### Test 6.2 — List Saved Careers
```
GET /api/v1/recommendations/saved/
```
Verify:
- Status is `200`
- Previously saved career appears in results
- `save_id`, `saved_at`, and `notes` are present

### Test 6.3 — Update Save Notes
```
PATCH /api/v1/careers/ux-designer/save/
Body: { "notes": "Checked roadmap — looks great" }
```
Verify:
- Status is `200`
- `notes` field is updated in the response

### Test 6.4 — Unsave a Career
```
DELETE /api/v1/careers/ux-designer/save/
```
Verify:
- Status is `204`
- Career no longer appears in GET /recommendations/saved/

### Test 6.5 — Track a Career View
```
POST /api/v1/careers/ux-designer/view/
Body: { "source": "recommendation", "time_spent_seconds": 45, "reached_roadmap": false }
```
Verify:
- Status is `200` or `201`
- Request is fire-and-forget; response should be fast

---

## Module 7 — Roadmaps & Progress

**Purpose:** Verify roadmap generation, step listing, progress updates, and summary dashboard.

### Test 7.1 — Generate a Roadmap
```
POST /api/v1/roadmaps/
Body: { "career_slug": "ux-designer" }
Auth: student_free (profiler completed)
```
Verify:
- Status is `201`
- `steps` array is non-empty (expect 10–15 steps)
- Steps include all category types: `first_30_days`, `skill_to_learn`, `project_to_build`, etc.
- Step `status` defaults to `not_started`
- Steps have `step_order` starting from 1

Negative test — generate for a non-existent career slug:
- Expect `404` with `CAREER_NOT_FOUND`

### Test 7.2 — Duplicate Roadmap Request
```
POST /api/v1/roadmaps/
Body: { "career_slug": "ux-designer" }
(Same career as Test 7.1, while roadmap is still active)
```
Verify:
- Server returns the existing roadmap (not a new one)
- Status may be `200` or `201` — document actual behaviour

### Test 7.3 — Get a Roadmap by ID
```
GET /api/v1/roadmaps/{roadmap_id}/
```
Verify:
- Status is `200`
- Same shape as POST response
- Step progress states are reflected correctly

### Test 7.4 — Update Step Progress
```
PATCH /api/v1/roadmaps/{roadmap_id}/steps/{step_id}/progress/
Body: { "status": "in_progress", "notes": "Started the Coursera course" }
```
Verify:
- Status is `200`
- `status` updates to `in_progress`
- `roadmap_completion_percent` updates accordingly

Then mark the same step `completed`:
```
PATCH /api/v1/roadmaps/{roadmap_id}/steps/{step_id}/progress/
Body: { "status": "completed" }
```
Verify:
- `completed_at` timestamp is set
- Completion percentage increases

Negative test — send an invalid `status` value:
- Expect `400` with `VALIDATION_ERROR`

### Test 7.5 — Progress Summary Dashboard
```
GET /api/v1/roadmaps/progress-summary/
```
Verify:
- Status is `200`
- `active_roadmaps`, `total_steps_across_all`, `completed_steps`, `overall_completion_percent` are present
- `roadmaps` array matches generated roadmaps
- `interest_profile_summary` has `top_dimensions` and `dimension_scores`

---

## Module 8 — AI Conversations

**Purpose:** Verify conversation creation, multi-turn messaging, type switching (general vs career-specific), and free tier message limit.

### Test 8.1 — Start a Career-Specific AI Conversation
```
POST /api/v1/ai/conversations/
Body:
{
  "conversation_type": "career_specific",
  "career_slug": "ux-designer",
  "first_message": "I'm in Grade 11 Science. What is UX Design and how do I start?"
}
```
Verify:
- Status is `201`
- `conversation_id` is returned
- `messages` array has exactly 2 items: user message and assistant reply
- Assistant reply is non-empty and contextually relevant
- `tokens_used` and `model_version` fields are present on the assistant message
- Save `conversation_id` for follow-up tests

### Test 8.2 — Start a General AI Conversation
```
POST /api/v1/ai/conversations/
Body:
{
  "conversation_type": "general",
  "first_message": "What career should someone like me pursue?"
}
```
Verify:
- Status is `201`
- No `career` object in response (since type is general)
- Assistant reply references the student's profile/interests

### Test 8.3 — Send Follow-Up Message
```
POST /api/v1/ai/conversations/{conversation_id}/messages/
Body: { "content": "What degree should I study to become a UX Designer?" }
```
Verify:
- Status is `201`
- Both `user_message` and `assistant_message` are in the response
- Assistant response is contextually aware of the prior message

### Test 8.4 — Retrieve Conversation History
```
GET /api/v1/ai/conversations/{conversation_id}/
```
Verify:
- Status is `200`
- `messages` array contains all messages in order (user, assistant, user, assistant...)
- `message_count` matches actual number of messages

### Test 8.5 — List All Conversations
```
GET /api/v1/ai/conversations/
GET /api/v1/ai/conversations/?conversation_type=career_specific
```
Verify:
- Status is `200`
- Conversations are listed for the current user only
- Filter by type works correctly

### Test 8.6 — AI Message Limit (Free Tier)
Using `student_free` account, send more than 5 AI messages in a single day:
```
POST /api/v1/ai/conversations/{conversation_id}/messages/
(Repeat until limit is hit)
```
Verify:
- After the 5th message, the 6th request returns `403`
- Error code is `AI_MESSAGE_LIMIT_REACHED`
- Response includes `upgrade_url`

### Test 8.7 — Archive a Conversation
```
DELETE /api/v1/ai/conversations/{conversation_id}/
```
Verify:
- Status is `204`
- Conversation no longer appears in list

---

## Module 9 — Content (Stories & Resources)

**Purpose:** Verify gated stories and curated learning resources per career.

### Test 9.1 — Fetch Stories (Free User)
```
GET /api/v1/careers/ux-designer/stories/
Auth: student_free token
```
Verify:
- Status is `200`
- At least 1 story is visible (non-premium)
- Premium stories have `locked: true` and no `story_text`

### Test 9.2 — Fetch Stories (Premium User)
```
GET /api/v1/careers/ux-designer/stories/
Auth: student_premium token
```
Verify:
- All stories are returned with full `story_text`
- No stories have `locked: true`

### Test 9.3 — Fetch Learning Resources
```
GET /api/v1/careers/ux-designer/resources/
```
Verify:
- Status is `200`
- Resources include `title`, `url`, `provider`, `resource_type`, `is_free`
- `resource_type` values are from expected enum set (course, certification, book, etc.)

---

## Module 10 — Subscriptions & Payments

**Purpose:** Verify plan listing, Razorpay order creation, payment verification, and subscription status.

### Test 10.1 — List Subscription Plans (No Auth)
```
GET /api/v1/subscriptions/plans/
(No Authorization header)
```
Verify:
- Status is `200` (this is a public endpoint)
- 3 plans returned: `free`, `premium_monthly`, `premium_yearly`
- `price_paise` is `0` for free plan
- Feature limits differ per plan

### Test 10.2 — Create a Razorpay Order
```
POST /api/v1/subscriptions/create-order/
Body: { "plan_id": "<premium_monthly_plan_uuid>" }
```
Verify:
- Status is `201`
- `razorpay_order_id` begins with `order_`
- `amount_paise` matches plan `price_paise` (29900 for monthly)
- `razorpay_key_id` is present
- `transaction_id` is a UUID

### Test 10.3 — Verify Payment (Valid Signature)
```
POST /api/v1/subscriptions/verify-payment/
Body:
{
  "transaction_id": "<uuid from order creation>",
  "razorpay_order_id": "order_XXXXXXXXXX",
  "razorpay_payment_id": "pay_XXXXXXXXXX",
  "razorpay_signature": "<valid HMAC_SHA256 signature>"
}
```
Note: Use Razorpay test keys and compute signature using `HMAC_SHA256(order_id|payment_id, secret)`.

Verify:
- Status is `200`
- `subscription_tier` is updated to `premium_monthly`
- `subscription_expires_at` is ~30 days from now

### Test 10.4 — Verify Payment (Invalid Signature)
```
POST /api/v1/subscriptions/verify-payment/
(Same body but with a tampered/invalid signature)
```
Verify:
- Status is `400`
- Error code is `PAYMENT_SIGNATURE_INVALID`

### Test 10.5 — Get Subscription Status
```
GET /api/v1/subscriptions/me/
Auth: student_premium token
```
Verify:
- Status is `200`
- `is_active` is `true`
- `days_remaining` is a positive integer
- `plan` object is nested correctly

---

## Module 11 — Notifications & Check-ins

**Purpose:** Verify notification listing, read/unread state, bulk mark-read, and check-in response flow.

### Test 11.1 — List Notifications
```
GET /api/v1/notifications/
```
Verify:
- Status is `200`
- `unread_count` is accurate
- Notification types are from known enum (roadmap_reminder, check_in, etc.)

### Test 11.2 — List Unread Only
```
GET /api/v1/notifications/?is_read=false
```
Verify:
- All returned notifications have `is_read: false`

### Test 11.3 — Mark Notification as Read
```
PATCH /api/v1/notifications/{notification_id}/read/
```
Verify:
- Status is `200`
- `is_read` is `true`
- `read_at` timestamp is set
- Re-fetching notifications shows updated `unread_count`

### Test 11.4 — Mark All as Read
```
POST /api/v1/notifications/mark-all-read/
```
Verify:
- Status is `200`
- `marked_read_count` reflects number of previously unread notifications
- Subsequent GET shows `unread_count: 0`

### Test 11.5 — Get Check-in Prompts
```
GET /api/v1/check-ins/
```
Verify:
- Status is `200`
- Each check-in has `prompt_type`, `question`, and `options`
- `options` are from expected enum: `still_yes`, `not_sure`, `moved_on`

### Test 11.6 — Respond to a Check-in
```
POST /api/v1/check-ins/{check_in_id}/respond/
Body: { "response": "still_yes" }
```
Verify:
- Status is `200`
- `response` and `responded_at` are returned

Negative test — send an invalid response value:
- Expect `400` with `VALIDATION_ERROR`

---

## Module 12 — Analytics Events

**Purpose:** Verify event ingestion for all standard event names.

### Test 12.1 — Log a Career Viewed Event
```
POST /api/v1/analytics/events/
Body:
{
  "event_name": "career_viewed",
  "session_id": "test_session_001",
  "career_id": "<valid_career_uuid>",
  "properties": {
    "source": "recommendation",
    "time_spent_seconds": 45,
    "scroll_depth_percent": 72
  }
}
```
Verify:
- Status is `201`
- `event_id` UUID is returned

### Test 12.2 — Log Multiple Event Types
Repeat Test 12.1 for each of these event names (all should return `201`):

- `app_opened`
- `profiler_started`
- `profiler_completed`
- `career_saved`
- `roadmap_generated`
- `roadmap_step_completed`
- `ai_message_sent`
- `subscription_upgrade_tapped`
- `check_in_responded`
- `share_profile_tapped`

### Test 12.3 — Unauthenticated Event
```
POST /api/v1/analytics/events/
(No Authorization header)
Body: { "event_name": "app_opened", "session_id": "anon_session_001" }
```
Verify:
- Check if endpoint accepts unauthenticated events (contract states `user_id = null` in this case)
- Document actual behaviour

---

## Module 13 — Counsellor Dashboard

**Purpose:** Verify counsellor-only access, organisation stats, and student anonymised list.

### Test 13.1 — Access Dashboard as Counsellor
```
GET /api/v1/counsellor/dashboard/
Auth: counsellor token
```
Verify:
- Status is `200`
- `organisation` object is present with `name`, `licence_seats`
- `students_total`, `profiler_completion_rate_percent` are present
- `top_career_interests`, `top_domains`, `dimension_distribution` are populated

### Test 13.2 — Access Dashboard as Student (Permission Check)
```
GET /api/v1/counsellor/dashboard/
Auth: student_free token
```
Verify:
- Status is `403`
- Error code is `PERMISSION_DENIED`

### Test 13.3 — List Students
```
GET /api/v1/counsellor/students/
Auth: counsellor token
```
Verify:
- Status is `200`
- Student records are anonymised (`display_name` is `Student #N`, not real name)
- No PII fields (email, phone) are exposed
- `profiler_completed`, `top_matched_careers`, `last_active_at` are present

### Test 13.4 — Filter Students
```
GET /api/v1/counsellor/students/?profiler_completed=true
GET /api/v1/counsellor/students/?academic_stage=grade_11_12_science
```
Verify:
- Filters work and narrow results correctly

---

## Module 14 — Parent Share View

**Purpose:** Verify share token generation and token-based public access.

### Test 14.1 — Generate Share Token
```
POST /api/v1/users/me/share-token/
Auth: student_premium token
```
Verify:
- Status is `201`
- `share_token` begins with `nxt_share_`
- `share_url` is a valid URL
- `expires_at` is a future date

Negative test — use `student_free` token (parent share is a premium feature):
- Expect `403` with `SUBSCRIPTION_REQUIRED`

### Test 14.2 — Access Parent View with Token (No Auth)
```
GET /api/v1/share/profile/{share_token}/
(No Authorization header)
```
Verify:
- Status is `200`
- Response contains `student_first_name`, `academic_stage`, `top_matched_careers`, `roadmap_summary`
- No sensitive PII like email or phone is exposed
- `counsellor_cta` is present

### Test 14.3 — Invalid or Expired Token
```
GET /api/v1/share/profile/invalid_token_xyz/
```
Verify:
- Status is `404`
- Error code is `SHARE_TOKEN_INVALID`

---

## Global Negative Tests

These tests apply to all authenticated endpoints:

### Test G.1 — Expired Access Token
Use a JWT token that has expired (modify `exp` claim or wait for expiry):
- Expect `401` with `TOKEN_EXPIRED`

### Test G.2 — Malformed Token
Send a garbage string as the Bearer token:
- Expect `401`

### Test G.3 — Rate Limiting
Rapidly send 50+ requests in quick succession to any endpoint:
- Expect `429` after threshold
- Error code should be `RATE_LIMITED`

### Test G.4 — Response Envelope Consistency
For every `200`/`201` response across all tests, verify:
- `success: true`
- `data` object is present

For every `4xx`/`5xx` response, verify:
- `success: false`
- `error.code` is a known error code from the Error Reference
- `error.message` is a human-readable string

### Test G.5 — CORS Headers
Send a request from `http://localhost:8080` (or use `Origin` header):
- Verify `Access-Control-Allow-Origin` is set correctly

---

## Test Execution Order (Recommended)

Follow this order for a clean first-run:

1. Auth (Module 1) — get tokens
2. Users (Module 2) — create and verify profiles
3. Profiler (Module 3) — complete the full profiler flow
4. Careers (Module 4) — browse and retrieve career data
5. Recommendations (Module 5) — verify personalized matches appear
6. Career Actions (Module 6) — save/unsave, view tracking
7. Roadmaps (Module 7) — generate and update progress
8. AI Conversations (Module 8) — chat flows, limit testing
9. Content (Module 9) — stories and resources
10. Subscriptions (Module 10) — upgrade flow
11. Notifications & Check-ins (Module 11)
12. Analytics (Module 12) — event logging
13. Counsellor (Module 13) — switch to counsellor account
14. Parent Share (Module 14) — generate and consume share token

---

## Test Report Template

Copy and fill this table after completing each test.

| Test ID | Endpoint | Method | Expected Status | Actual Status | Pass/Fail | Notes |
|---|---|---|---|---|---|---|
| 1.1 | /auth/firebase/ | POST | 201 | | | |
| 1.2 | /auth/token/refresh/ | POST | 200 | | | |
| 1.3 | /users/me/ (no auth) | GET | 401 | | | |
| 2.1 | /users/me/ | GET | 200 | | | |
| 2.2 | /users/me/ | PATCH | 200 | | | |
| 2.3 | /users/me/avatar/ | POST | 200 | | | |
| 2.4 | /users/me/student-profile/ | PUT | 200 | | | |
| 2.5 | /users/me/parental-consent/ | POST | 200 | | | |
| 2.6 | /users/me/ | DELETE | 204 | | | |
| 3.1 | /profiler/questions/ | GET | 200 | | | |
| 3.2 | /profiler/sessions/ | POST | 201 | | | |
| 3.3 | /profiler/sessions/{id}/ | GET | 200 | | | |
| 3.4 | /profiler/sessions/{id}/responses/ | POST | 200 | | | |
| 3.5 | /profiler/sessions/{id}/complete/ | POST | 200 | | | |
| 3.6 | /profiler/profile/ | GET | 200 | | | |
| 4.1 | /careers/ | GET | 200 | | | |
| 4.2 | /careers/?search=designer | GET | 200 | | | |
| 4.3 | /careers/?domain_slug=... | GET | 200 | | | |
| 4.4 | /careers/?future_score_min=8 | GET | 200 | | | |
| 4.5 | /careers/?is_emerging=true | GET | 200 | | | |
| 4.6 | /careers/ux-designer/ | GET | 200 | | | |
| 4.7 | /careers/domains/ | GET | 200 | | | |
| 4.8 | /careers/domains/technology-software/ | GET | 200 | | | |
| 4.9 | /careers/clusters/ | GET | 200 | | | |
| 4.10 | /careers/compare/?slugs=... | GET | 200 | | | |
| 5.1 | /recommendations/ | GET | 200 | | | |
| 5.2 | /recommendations/?tier=full_match | GET | 200 | | | |
| 5.3 | /recommendations/ (no profiler) | GET | 422 | | | |
| 5.4 | /recommendations/regenerate/ | POST | 200 | | | |
| 6.1 | /careers/{slug}/save/ | POST | 201 | | | |
| 6.2 | /recommendations/saved/ | GET | 200 | | | |
| 6.3 | /careers/{slug}/save/ | PATCH | 200 | | | |
| 6.4 | /careers/{slug}/save/ | DELETE | 204 | | | |
| 6.5 | /careers/{slug}/view/ | POST | 200 | | | |
| 7.1 | /roadmaps/ | POST | 201 | | | |
| 7.2 | /roadmaps/ (duplicate) | POST | 200/201 | | | |
| 7.3 | /roadmaps/{id}/ | GET | 200 | | | |
| 7.4 | /roadmaps/{id}/steps/{id}/progress/ | PATCH | 200 | | | |
| 7.5 | /roadmaps/progress-summary/ | GET | 200 | | | |
| 8.1 | /ai/conversations/ (career) | POST | 201 | | | |
| 8.2 | /ai/conversations/ (general) | POST | 201 | | | |
| 8.3 | /ai/conversations/{id}/messages/ | POST | 201 | | | |
| 8.4 | /ai/conversations/{id}/ | GET | 200 | | | |
| 8.5 | /ai/conversations/ | GET | 200 | | | |
| 8.6 | /ai/conversations/{id}/messages/ (limit) | POST | 403 | | | |
| 8.7 | /ai/conversations/{id}/ | DELETE | 204 | | | |
| 9.1 | /careers/{slug}/stories/ (free) | GET | 200 | | | |
| 9.2 | /careers/{slug}/stories/ (premium) | GET | 200 | | | |
| 9.3 | /careers/{slug}/resources/ | GET | 200 | | | |
| 10.1 | /subscriptions/plans/ (no auth) | GET | 200 | | | |
| 10.2 | /subscriptions/create-order/ | POST | 201 | | | |
| 10.3 | /subscriptions/verify-payment/ (valid) | POST | 200 | | | |
| 10.4 | /subscriptions/verify-payment/ (invalid sig) | POST | 400 | | | |
| 10.5 | /subscriptions/me/ | GET | 200 | | | |
| 11.1 | /notifications/ | GET | 200 | | | |
| 11.2 | /notifications/?is_read=false | GET | 200 | | | |
| 11.3 | /notifications/{id}/read/ | PATCH | 200 | | | |
| 11.4 | /notifications/mark-all-read/ | POST | 200 | | | |
| 11.5 | /check-ins/ | GET | 200 | | | |
| 11.6 | /check-ins/{id}/respond/ | POST | 200 | | | |
| 12.1 | /analytics/events/ | POST | 201 | | | |
| 12.2 | /analytics/events/ (multi-type) | POST | 201 | | | |
| 12.3 | /analytics/events/ (no auth) | POST | 201/401 | | | |
| 13.1 | /counsellor/dashboard/ (counsellor) | GET | 200 | | | |
| 13.2 | /counsellor/dashboard/ (student) | GET | 403 | | | |
| 13.3 | /counsellor/students/ | GET | 200 | | | |
| 13.4 | /counsellor/students/?profiler_completed=true | GET | 200 | | | |
| 14.1 | /users/me/share-token/ (premium) | POST | 201 | | | |
| 14.2 | /share/profile/{token}/ (no auth) | GET | 200 | | | |
| 14.3 | /share/profile/invalid_token/ | GET | 404 | | | |
| G.1 | Any endpoint (expired token) | ANY | 401 | | | |
| G.2 | Any endpoint (malformed token) | ANY | 401 | | | |
| G.3 | Any endpoint (rapid requests) | ANY | 429 | | | |
| G.4 | Envelope check (all responses) | ANY | — | | | |
| G.5 | CORS header check | OPTIONS | — | | | |

---

## Summary Report Section

After completing all tests, fill in this summary:

**Tested by:**
**Test date:**
**Environment:** `[ ] Development` `[ ] Staging` `[ ] Production`
**Base URL used:**

| Category | Total Tests | Passed | Failed | Skipped |
|---|---|---|---|---|
| Auth | 3 | | | |
| Users | 6 | | | |
| Profiler | 6 | | | |
| Career Universe | 10 | | | |
| Recommendations | 4 | | | |
| Career Actions | 5 | | | |
| Roadmaps | 5 | | | |
| AI Conversations | 7 | | | |
| Content | 3 | | | |
| Subscriptions | 5 | | | |
| Notifications & Check-ins | 6 | | | |
| Analytics | 3 | | | |
| Counsellor Dashboard | 4 | | | |
| Parent Share | 3 | | | |
| Global / Cross-cutting | 5 | | | |
| **TOTAL** | **75** | | | |

**Critical Bugs (blocking):**

**Non-critical Bugs (minor):**

**Observations & Recommendations:**

---

*NextStep API Testing Guide v1.0 — aligned with API Contract v1.0*