# NextStep — Flutter App Development Guide

> **Platform:** Flutter (Dart) | **Auth:** Firebase Auth | **API:** Django REST (JWT) | **Target:** Android-first, iOS-secondary
> **Version:** 1.0 | Aligned with: Product Document v1.0, API Contract v1.0, Database Schema v1.0

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Flutter Project Architecture](#2-flutter-project-architecture)
3. [Folder Structure](#3-folder-structure)
4. [Tech Stack & Dependencies](#4-tech-stack--dependencies)
5. [Firebase Setup & Authentication](#5-firebase-setup--authentication)
6. [API Layer & Networking](#6-api-layer--networking)
7. [State Management](#7-state-management)
8. [Navigation & Routing](#8-navigation--routing)
9. [Onboarding Flow](#9-onboarding-flow)
10. [Screen-by-Screen Specification](#10-screen-by-screen-specification)
11. [Reusable Widgets & Components](#11-reusable-widgets--components)
12. [Local Storage & Caching](#12-local-storage--caching)
13. [Push Notifications](#13-push-notifications)
14. [Theming & Design System](#14-theming--design-system)
15. [Error Handling Strategy](#15-error-handling-strategy)
16. [Analytics Integration](#16-analytics-integration)
17. [Subscription & Paywall Flow](#17-subscription--paywall-flow)
18. [Deep Links & Share](#18-deep-links--share)
19. [App Configuration & Environment](#19-app-configuration--environment)
20. [Build & Release Checklist](#20-build--release-checklist)

---

## 1. Project Overview

NextStep is a career discovery app for Indian school and college students (Grade 8–12, College Year 1–2). It helps students discover careers they have never heard of by mapping their interests to a 300+ career universe via a scenario-based profiler.

### User Types

The app serves four user types, each with different views:

- **Student** — primary user; takes profiler, explores careers, builds roadmaps
- **Parent** — read-only share view, accessed via share token link
- **Counsellor** — dashboard to see anonymised student data within their school
- **School Admin** — organisation management (post-MVP; scaffold routes but do not build screens)

### App Entry Logic

On cold start, the app must determine which screen to show:

1. No Firebase session → **Auth Gate (Login/Signup)**
2. Firebase session exists, no Django JWT → **Auth Exchange** (call `/auth/firebase/`, store JWT)
3. JWT valid, `profiler_completed = false` → **Onboarding Flow**
4. JWT valid, `profiler_completed = true` → **Home (Career Map)**

---

## 2. Flutter Project Architecture

Use **Feature-First Clean Architecture** with three layers:

### Layers

**Presentation Layer** — Flutter Widgets, Screens, and UI-specific state. Each screen has its own folder. No business logic here; only UI rendering and user interaction.

**Domain Layer** — Pure Dart. Contains entities (data models the app thinks in), repository interfaces (abstract contracts), and use cases (single business actions). No Flutter imports here.

**Data Layer** — Implements repository interfaces. Contains remote data sources (API calls), local data sources (SharedPreferences/Hive), and data models (JSON serialisation).

### State Management

Use **Riverpod (v2)** with code generation (`riverpod_generator`). Each feature manages its own providers. Avoid global god-providers.

### Key Principles

- Features are self-contained. The `profiler` feature does not import from the `careers` feature directly; it goes through shared domain models.
- All API calls go through a single `ApiClient` that handles JWT injection, token refresh, and error normalisation.
- Firebase is isolated behind an `AuthRepository` interface. The rest of the app never imports `firebase_auth` directly.
- Navigation uses `GoRouter` with route guards based on auth and profiler state.

---

## 3. Folder Structure

```
nextstep_flutter/
├── android/
├── ios/
├── lib/
│   ├── main.dart                        # App entry, ProviderScope, GoRouter init
│   ├── app.dart                         # MaterialApp.router, ThemeData, locale
│   │
│   ├── core/
│   │   ├── api/
│   │   │   ├── api_client.dart          # Dio client with interceptors
│   │   │   ├── api_endpoints.dart       # All URL constants
│   │   │   ├── api_response.dart        # Envelope <T> model
│   │   │   └── interceptors/
│   │   │       ├── auth_interceptor.dart      # Attaches Bearer token
│   │   │       └── refresh_interceptor.dart   # Handles 401 → refresh → retry
│   │   │
│   │   ├── auth/
│   │   │   ├── firebase_auth_service.dart     # Firebase sign in/out/stream
│   │   │   └── token_storage.dart             # Secure storage for JWT pair
│   │   │
│   │   ├── router/
│   │   │   ├── app_router.dart          # GoRouter configuration
│   │   │   └── route_names.dart         # Route name constants
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart           # Light ThemeData
│   │   │   ├── app_colors.dart          # Color palette constants
│   │   │   ├── app_typography.dart      # TextStyle definitions
│   │   │   └── app_spacing.dart         # Spacing constants
│   │   │
│   │   ├── widgets/
│   │   │   ├── ns_button.dart           # Primary / Secondary / Text buttons
│   │   │   ├── ns_card.dart             # Base card widget
│   │   │   ├── ns_loader.dart           # Fullscreen and inline loaders
│   │   │   ├── ns_error_view.dart       # Error state with retry
│   │   │   ├── ns_empty_state.dart      # Empty state illustration
│   │   │   ├── ns_bottom_sheet.dart     # Styled modal bottom sheet
│   │   │   ├── ns_snackbar.dart         # Success/error toast
│   │   │   └── ns_avatar.dart           # User avatar with fallback initials
│   │   │
│   │   ├── utils/
│   │   │   ├── salary_formatter.dart    # Paise → ₹ LPA display
│   │   │   ├── dimension_label.dart     # C/A/T etc → label + color
│   │   │   ├── date_formatter.dart
│   │   │   └── validators.dart          # Form field validators
│   │   │
│   │   └── constants/
│   │       ├── app_constants.dart
│   │       └── asset_paths.dart
│   │
│   ├── features/
│   │   │
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── auth_remote_source.dart
│   │   │   │   └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── auth_repository.dart       # Abstract interface
│   │   │   │   └── user_entity.dart
│   │   │   └── presentation/
│   │   │       ├── auth_provider.dart         # Riverpod auth state
│   │   │       ├── login_screen.dart
│   │   │       ├── signup_screen.dart
│   │   │       └── widgets/
│   │   │           ├── google_sign_in_button.dart
│   │   │           └── phone_otp_sheet.dart
│   │   │
│   │   ├── onboarding/
│   │   │   ├── data/
│   │   │   │   ├── profiler_remote_source.dart
│   │   │   │   └── profiler_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── profiler_repository.dart
│   │   │   │   ├── question_entity.dart
│   │   │   │   ├── profiler_session_entity.dart
│   │   │   │   └── interest_profile_entity.dart
│   │   │   └── presentation/
│   │   │       ├── onboarding_provider.dart
│   │   │       ├── welcome_screen.dart
│   │   │       ├── profiler_screen.dart
│   │   │       ├── profile_building_screen.dart   # Animated "building profile"
│   │   │       └── widgets/
│   │   │           ├── question_card.dart
│   │   │           ├── option_tile.dart
│   │   │           ├── section_transition.dart
│   │   │           ├── progress_bar.dart
│   │   │           └── profiler_complete_animation.dart
│   │   │
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       ├── home_screen.dart             # Bottom nav shell
│   │   │       └── home_provider.dart
│   │   │
│   │   ├── career_map/
│   │   │   ├── data/
│   │   │   │   ├── recommendations_remote_source.dart
│   │   │   │   └── recommendations_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── recommendations_repository.dart
│   │   │   │   └── career_recommendation_entity.dart
│   │   │   └── presentation/
│   │   │       ├── career_map_provider.dart
│   │   │       ├── career_map_screen.dart
│   │   │       └── widgets/
│   │   │           ├── career_card.dart
│   │   │           ├── match_score_badge.dart
│   │   │           ├── future_score_chip.dart
│   │   │           └── domain_filter_chips.dart
│   │   │
│   │   ├── career_detail/
│   │   │   ├── data/
│   │   │   │   ├── career_remote_source.dart
│   │   │   │   └── career_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── career_repository.dart
│   │   │   │   └── career_detail_entity.dart
│   │   │   └── presentation/
│   │   │       ├── career_detail_provider.dart
│   │   │       ├── career_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── typical_day_section.dart
│   │   │           ├── salary_range_widget.dart
│   │   │           ├── skills_needed_section.dart
│   │   │           ├── real_story_card.dart
│   │   │           ├── related_careers_row.dart
│   │   │           └── premium_lock_overlay.dart
│   │   │
│   │   ├── roadmap/
│   │   │   ├── data/
│   │   │   │   ├── roadmap_remote_source.dart
│   │   │   │   └── roadmap_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── roadmap_repository.dart
│   │   │   │   ├── roadmap_entity.dart
│   │   │   │   └── roadmap_step_entity.dart
│   │   │   └── presentation/
│   │   │       ├── roadmap_provider.dart
│   │   │       ├── roadmaps_list_screen.dart
│   │   │       ├── roadmap_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── roadmap_step_tile.dart
│   │   │           ├── progress_timeline.dart
│   │   │           └── step_resource_link.dart
│   │   │
│   │   ├── ai_chat/
│   │   │   ├── data/
│   │   │   │   ├── ai_chat_remote_source.dart
│   │   │   │   └── ai_chat_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── ai_chat_repository.dart
│   │   │   │   ├── conversation_entity.dart
│   │   │   │   └── message_entity.dart
│   │   │   └── presentation/
│   │   │       ├── ai_chat_provider.dart
│   │   │       ├── conversations_list_screen.dart
│   │   │       ├── chat_screen.dart
│   │   │       └── widgets/
│   │   │           ├── chat_bubble.dart
│   │   │           ├── message_input_bar.dart
│   │   │           ├── free_limit_banner.dart
│   │   │           └── typing_indicator.dart
│   │   │
│   │   ├── explore/
│   │   │   └── presentation/
│   │   │       ├── explore_screen.dart
│   │   │       └── widgets/
│   │   │           └── career_search_bar.dart
│   │   │
│   │   ├── profile/
│   │   │   ├── data/
│   │   │   │   └── profile_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   └── profile_repository.dart
│   │   │   └── presentation/
│   │   │       ├── profile_provider.dart
│   │   │       ├── profile_screen.dart
│   │   │       ├── edit_profile_screen.dart
│   │   │       ├── interest_profile_screen.dart   # Radar chart of dimensions
│   │   │       ├── saved_careers_screen.dart
│   │   │       ├── notifications_screen.dart
│   │   │       ├── subscription_screen.dart
│   │   │       └── widgets/
│   │   │           ├── dimension_radar_chart.dart
│   │   │           ├── subscription_plan_card.dart
│   │   │           └── share_profile_tile.dart
│   │   │
│   │   ├── notifications/
│   │   │   └── presentation/
│   │   │       ├── notifications_provider.dart
│   │   │       └── check_in_sheet.dart
│   │   │
│   │   └── parent_view/
│   │       └── presentation/
│   │           ├── parent_view_screen.dart       # Read-only; opened via deep link
│   │           └── widgets/
│   │               └── parent_career_card.dart
│   │
└── pubspec.yaml
```

---

## 4. Tech Stack & Dependencies

Add the following to `pubspec.yaml`:

### Core

- `flutter_riverpod: ^2.x` — state management
- `riverpod_annotation: ^2.x` — code generation for providers
- `riverpod_generator: ^2.x` — build_runner target
- `go_router: ^13.x` — declarative routing with redirects

### Firebase

- `firebase_core: ^2.x`
- `firebase_auth: ^4.x`
- `google_sign_in: ^6.x`

### Networking

- `dio: ^5.x` — HTTP client
- `pretty_dio_logger: ^1.x` — dev logging

### Local Storage

- `flutter_secure_storage: ^9.x` — JWT token storage
- `hive_flutter: ^1.x` — local caching (questions, career list)
- `shared_preferences: ^2.x` — simple flags (onboarding seen, etc.)

### UI & Rendering

- `cached_network_image: ^3.x` — profile images, career thumbnails
- `fl_chart: ^0.x` — radar chart for interest dimensions
- `lottie: ^3.x` — profile-building animation
- `shimmer: ^3.x` — skeleton loading states
- `gap: ^3.x` — spacing utility

### Utilities

- `intl: ^0.x` — date and number formatting
- `url_launcher: ^6.x` — open roadmap resource links
- `share_plus: ^7.x` — share parent view URL
- `image_picker: ^1.x` — avatar upload
- `package_info_plus: ^5.x` — app version header
- `connectivity_plus: ^5.x` — offline detection

### Dev Dependencies

- `build_runner: ^2.x`
- `freezed: ^2.x` — immutable data classes with pattern matching
- `json_serializable: ^6.x` — JSON model generation
- `flutter_lints: ^3.x`

---

## 5. Firebase Setup & Authentication

### Project Setup

1. Create a Firebase project for NextStep.
2. Register an Android app (`com.nextstep.app`) and iOS app (`com.nextstep.app`).
3. Download and place `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/`.
4. Enable **Email/Password**, **Google Sign-In**, and **Phone (OTP)** in Firebase Console → Authentication.

### Auth Flow (Two-Step)

The app uses Firebase Auth only for identity, and Django JWT for all API access. The Flutter side must implement this two-step exchange.

**Step 1 — Firebase Auth (Flutter → Firebase directly)**

Handle the following sign-in methods using the `firebase_auth` SDK:

- Email + Password: `FirebaseAuth.instance.signInWithEmailAndPassword()`
- Google Sign-In: `GoogleSignIn().signIn()` → `signInWithCredential()`
- Phone OTP: `FirebaseAuth.instance.verifyPhoneNumber()` → SMS code → credential

After any successful Firebase sign-in, call `user.getIdToken()` to get the Firebase ID token.

**Step 2 — Exchange for Django JWT (Flutter → Django API)**

Immediately after Firebase sign-in, call:

```
POST /api/v1/auth/firebase/
Body: { "firebase_token": "<firebase_id_token>" }
```

The response returns `access` (1 hour) and `refresh` (30 days) Django JWT tokens and the user object. Store both tokens securely using `flutter_secure_storage`.

**Step 3 — Token Refresh**

The `AuthInterceptor` should intercept all 401 responses, call `/api/v1/auth/token/refresh/` with the refresh token, update stored tokens, and retry the original request. If the refresh also fails (refresh token expired), clear all tokens and redirect the user to the login screen.

### Auth State Provider

Create a `StreamProvider` that listens to `FirebaseAuth.instance.authStateChanges()`. Combine this with a check for the stored Django JWT to determine which route to redirect to. This provider drives `GoRouter`'s redirect logic.

### Sign Out

On sign out:
1. Call `FirebaseAuth.instance.signOut()`.
2. Delete stored Django JWT from `flutter_secure_storage`.
3. Clear Hive caches.
4. Redirect to the login screen.

---

## 6. API Layer & Networking

### ApiClient

Create a singleton `Dio` instance with the base URL `https://api.nextstep.app/api/v1/` and the following interceptors applied in order:

1. **AuthInterceptor** — reads the access JWT from secure storage and adds `Authorization: Bearer <token>` to every request. Also adds `X-App-Version` from `package_info_plus`.
2. **RefreshInterceptor** — handles 401 responses: pauses the queue, refreshes the token, retries.
3. **PrettyDioLogger** — debug mode only; logs requests and responses.

### ApiResponse Envelope

All API responses are wrapped in an envelope. Create a generic Dart class:

```dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final ApiError? error;
}
```

Parse this envelope in a single `parseResponse<T>()` helper function that all repository implementations call.

### API Endpoints File

Define all endpoints as constants in `api_endpoints.dart`. Never hardcode URL strings in repository files. Group by feature module matching the API contract modules.

### Error Normalisation

Map API error codes to strongly-typed Dart exceptions. Create a sealed class `AppException` with subtypes for each error category:

- `AuthException` — covers `INVALID_FIREBASE_TOKEN`, `TOKEN_EXPIRED`
- `SubscriptionException` — covers `SUBSCRIPTION_REQUIRED`
- `ProfilerException` — covers `PROFILER_NOT_COMPLETED`, `PROFILER_SESSION_NOT_FOUND`
- `NetworkException` — covers connection failures, timeouts
- `ServerException` — covers 500 errors
- `ValidationException` — covers 400 errors with field details

---

## 7. State Management

### Riverpod Provider Structure

Every feature follows the same provider pattern:

**Repository Provider** — provides the repository implementation (registered at the feature level; overridable for testing).

**Notifier/AsyncNotifier** — contains business logic for screens that have actions (e.g., `ProfilerNotifier` that manages session state, submits answers, and calls completion).

**FutureProvider / StreamProvider** — for read-only async data (e.g., career list, notifications).

### Key Providers

**`authStateProvider`** — `StreamProvider<User?>` wrapping Firebase auth stream. Root of all auth-gated routing.

**`currentUserProvider`** — `FutureProvider<UserEntity>` that calls `GET /users/me/`. Auto-invalidated after profile update.

**`profilerSessionProvider`** — `AsyncNotifier<ProfilerSessionState>` that manages the full profiler session lifecycle: start, answer, skip, complete.

**`careerRecommendationsProvider`** — `FutureProvider<List<CareerRecommendation>>` that calls the recommendations endpoint. Cached in Hive; refreshes when interest profile version changes.

**`roadmapListProvider`** — `FutureProvider<List<RoadmapEntity>>` that lists all active roadmaps.

**`aiChatProvider(String conversationId)`** — `AsyncNotifier` for a single conversation's messages.

**`notificationsProvider`** — `FutureProvider<List<NotificationEntity>>`.

### State Refresh Strategy

Invalidate providers explicitly after mutations. For example, after completing the profiler, invalidate both `profilerSessionProvider` and `careerRecommendationsProvider`. After marking a roadmap step complete, invalidate `roadmapListProvider`.

---

## 8. Navigation & Routing

Use `GoRouter` with a top-level redirect function that enforces auth and onboarding gates.

### Route Tree

```
/                           → redirect logic (AuthGate)
/login                      → LoginScreen
/signup                     → SignupScreen
/onboarding                 → shell for onboarding steps
  /onboarding/welcome       → WelcomeScreen
  /onboarding/profiler      → ProfilerScreen
  /onboarding/building      → ProfileBuildingScreen (animated)
/home                       → HomeScreen (bottom nav shell)
  /home/careers             → CareerMapScreen          (tab 1)
  /home/explore             → ExploreScreen             (tab 2)
  /home/roadmaps            → RoadmapsListScreen        (tab 3)
  /home/ai                  → ConversationsListScreen   (tab 4)
  /home/profile             → ProfileScreen             (tab 5)
/career/:slug               → CareerDetailScreen
/roadmap/:roadmapId         → RoadmapDetailScreen
/chat/:conversationId       → ChatScreen
/profile/interests          → InterestProfileScreen
/profile/saved              → SavedCareersScreen
/profile/edit               → EditProfileScreen
/profile/subscription       → SubscriptionScreen
/notifications              → NotificationsScreen
/share/:shareToken          → ParentViewScreen         (no auth required)
```

### Redirect Logic

In the `GoRouter` `redirect` callback:

1. If the path starts with `/share/`, allow it through without checking auth — parent view is token-based and requires no login.
2. If `authStateProvider` is loading, return null (stay on current route).
3. If no Firebase user is authenticated and route is not `/login` or `/signup`, redirect to `/login`.
4. If authenticated but `profiler_completed = false` and route is not under `/onboarding`, redirect to `/onboarding/welcome`.
5. If authenticated and `profiler_completed = true` and route is `/login`, `/signup`, or `/onboarding`, redirect to `/home/careers`.

---

## 9. Onboarding Flow

The onboarding flow is the most complex part of the app. It must feel like a conversation, not an exam. The entire flow is governed by the `ProfilerNotifier`.

### Onboarding Screens in Order

**1. WelcomeScreen**

Show the NextStep brand illustration and value proposition. Include "Let's find your path" as the primary CTA. If the user previously started a profiler session (`status = in_progress`), show a "Continue where you left off" option that resumes the session.

**2. ProfilerScreen**

This is a single screen that renders all 24+ questions one at a time. It does not navigate to a new route per question — it swaps the question content with an animated transition (`PageView` or `AnimatedSwitcher`).

Structure:
- **Top bar:** Section label (e.g., "What You Do With Free Time") + progress bar showing X of 24 questions answered.
- **Question area:** Question text + optional instruction sub-text.
- **Options area:** Scrollable list of `OptionTile` widgets. Each shows an emoji + label.
- **Bottom bar:** "Skip this question" text button (left) + "Next" primary button (right, enabled only when required answer is selected for single-select; always enabled for awareness section).

Question Types to render:
- `single_select` — tap one option; auto-advance after selection with 300ms delay.
- `multi_select` — tap multiple (up to `max_selections`); "Next" button required to advance.
- `multi_select_unlimited` — used for Q21 (career awareness check); show all as checkboxes with "Continue" button.

Section Transitions:
Between each section (after the last question of a section), show a full-screen `SectionTransitionWidget` that displays a warm transitional message (e.g., "Great! Now let's see how you think and solve problems."). It auto-advances after 1.5 seconds or on tap.

**3. ProfileBuildingScreen**

After Q24, before showing the career map:
- Show a Lottie animation (e.g., dots connecting, nodes lighting up).
- Display the text "Finding your career matches..." followed by the six dimensions appearing one by one with their labels.
- After the animation completes (2–3 seconds), navigate to `/home/careers`.

### Profiler Session Management

On `ProfilerScreen` mount:
1. Check if an active session exists in local state.
2. If not, call `POST /api/v1/profiler/sessions/` to start a new session. Cache the `session_id`.
3. Questions are fetched once from `GET /api/v1/profiler/questions/` and cached in Hive. Use cached version on subsequent app opens.

On each answer:
- Call `POST /api/v1/profiler/sessions/{sessionId}/answers/` with `question_code`, `selected_option_indexes`, and `skipped` flag.
- Do this in the background — do not block the UI. If the call fails, queue it for retry.
- Update the local `questions_answered` count for the progress bar.

On completion (after Q24):
- Call `POST /api/v1/profiler/sessions/{sessionId}/complete/`.
- Response includes the computed `interest_profile` with dimension scores.
- Cache the `interest_profile` locally.
- Navigate to `ProfileBuildingScreen`.

### Student Context Questions (SC-1 to SC-3)

These three questions collect `academic_stage`, `career_clarity`, and `pressure_level`. They appear before Q1 and are not scored.

After SC-3 is answered, immediately call `PUT /api/v1/users/me/student-profile/` to save this context. This call is non-blocking.

### Retake Flow

From the Profile screen, a student can retake the profiler. Tapping "Redo your profile" navigates to `/onboarding/profiler` and calls `POST /api/v1/profiler/sessions/` to start a new session. The existing interest profile is still shown until the new session completes.

---

## 10. Screen-by-Screen Specification

### 10.1 Login Screen (`/login`)

Purpose: Firebase authentication entry point.

UI Elements:
- NextStep logo and tagline at top.
- Email and Password `TextField` widgets with proper keyboard types and obscure text for password.
- "Login" primary button. On tap: sign in with Firebase email/password → exchange for Django JWT → navigate based on `profiler_completed`.
- "Sign in with Google" button (`GoogleSignInButton` widget). Same exchange flow after Firebase sign-in.
- "Sign in with Phone" text button → triggers `PhoneOtpSheet` bottom sheet.
- "Don't have an account? Sign up" text link → `/signup`.
- "Forgot Password?" text link → calls `FirebaseAuth.instance.sendPasswordResetEmail()` and shows a snackbar.

Error handling: Show Firebase error messages mapped to user-friendly strings (e.g., `user-not-found` → "No account found with this email"). Display inline below the relevant field or as a snackbar.

### 10.2 Signup Screen (`/signup`)

UI Elements:
- Full Name, Email, Password, Confirm Password fields.
- "Create Account" button: creates Firebase account → exchange for Django JWT (`is_new_user = true`) → navigate to `/onboarding/welcome`.
- "Sign up with Google" button.
- Age confirmation checkbox: "I confirm I am 16 or older." If unchecked and age < 16 is indicated, show parental consent flow via a `ParentalConsentSheet`.

### 10.3 Welcome Screen (`/onboarding/welcome`)

Purpose: Set context and emotional tone before the profiler.

UI Elements:
- Full-bleed illustration (career universe / constellation graphic).
- Headline: "Let's figure out what's right for you."
- Sub-text: "We'll ask you some questions about what you enjoy. There are no right answers — just go with your gut."
- Estimated time: "Takes 5–8 minutes."
- "Start Discovering" primary button.
- If an in-progress session exists, show "Continue where you left off" as a secondary button.

### 10.4 Profiler Screen (`/onboarding/profiler`)

See Section 9 above for full specification. Key UX requirements:

- Progress bar must always be visible and accurate.
- Multi-select questions must show a visible "selected" state on each option tile (checkmark + highlighted background).
- "Skip" must be accessible but not prominent — it is a text button, not a full button.
- Show section labels clearly so students know what domain they're in.
- Do not show back navigation between questions — the profiler is a forward-only flow. If back is pressed (Android), show a confirmation dialog: "Quit the profiler? Your progress will be saved."

### 10.5 Career Map Screen (`/home/careers`)

This is the home screen after profiler completion — the heart of the app.

UI Elements:
- **Header** — personalised greeting ("Hi Riya 👋") + subtitle showing top 2 dimensions ("Based on your Creative + Analytical interests").
- **Filter chips row** — domain filter chips (e.g., "All", "Design", "Technology", "Healthcare"). Horizontally scrollable.
- **Career grid** — a `GridView` or `ListView` of `CareerCard` widgets. Show 10–15 recommended careers sorted by match score.
- **"Explore all careers" banner** at the bottom — links to ExploreScreen.

Career Card widget must show:
- Career name (bold).
- One-liner description.
- Match score badge ("87% match") in primary colour.
- Future score chip ("⭐ 9/10" or "🔮 Emerging").
- Domain tag (subtle chip).
- Save/bookmark icon button (calls `POST /api/v1/recommendations/save/`).

Shimmer loading state while the recommendations API call is in progress.

Empty state: if no recommendations yet (profiler not completed somehow), show `NSEmptyState` with "Complete your profile to see matches" and a CTA.

### 10.6 Career Detail Screen (`/career/:slug`)

This is the deepest and richest screen in the app. Opened when a student taps any career card.

Layout: Use `CustomScrollView` with `SliverAppBar` for a collapsing header effect.

**Header section:**
- Career name + domain tag.
- One-liner description.
- Match score (if coming from recommendations) + future score.
- Save button (top right) — toggles bookmark.
- "Get Roadmap" primary button — calls `POST /api/v1/roadmaps/generate/`.
- "Ask AI about this career" secondary button — opens ChatScreen with career context.

**Sections (scroll down):**

"What you actually do" — `TypicalDaySection`: shows the `typical_day` narrative paragraph.

"Skills needed" — `SkillsNeededSection`: horizontal wrap of skill chips.

"Salary in India" — `SalaryRangeWidget`: shows entry/mid/senior range as a bar chart or labelled tiers. Format paise → ₹ LPA using `SalaryFormatter`.

"Future relevance" — Future score (1–10) with reasoning text. Show an upward-trending mini icon for scores ≥ 8.

"How to get here" — Entry paths as a simple bullet list (degree options, self-taught).

"Real people stories" — `RealStoryCard` list. If `is_premium = true` and user is free tier, show a blurred/locked card with a "Unlock with Premium" CTA.

"Related careers" — `RelatedCareersRow`: a horizontal scroll of small career chips. Tap navigates to that career's detail screen.

**Premium lock overlay:** For premium-gated sections visible to free users, show the first ~40% of the content blurred, with a lock icon and "Unlock with NextStep Premium" button overlaid.

### 10.7 Explore Screen (`/home/explore`)

Purpose: Allow browsing the full 300+ career database independently of recommendations.

UI Elements:
- Search bar at top (calls `GET /careers/search/?q=` with debounce of 400ms).
- Domain category grid below search (shows all career domains as visual cards with domain name and icon).
- Tapping a domain shows careers filtered by that domain.
- Search results replace the grid view.

### 10.8 Roadmaps List Screen (`/home/roadmaps`)

Shows all active roadmaps the student has generated.

UI Elements:
- List of `RoadmapCard` widgets. Each shows: career name, progress (e.g., "3 of 10 steps done"), and a progress bar.
- "Generate a roadmap" empty state CTA if no roadmaps yet — links to career map.
- Tap → `RoadmapDetailScreen`.

### 10.9 Roadmap Detail Screen (`/roadmap/:roadmapId`)

Shows the full step-by-step roadmap for a career.

UI Elements:
- Header: career name + overall progress percentage + circular progress indicator.
- Phase labels (e.g., "Phase 1: Foundation", "Phase 2: Build Skills") as sticky section headers.
- `RoadmapStepTile` for each step:
  - Step title (e.g., "Learn Figma basics").
  - Description text.
  - Step category chip (e.g., "🎓 Learn Skill").
  - Resource links — tap to open in browser via `url_launcher`.
  - Checkbox to mark complete. On tap, call `PATCH /api/v1/roadmaps/{id}/steps/{stepId}/progress/` with `status = completed`.
  - Completed steps show a strikethrough and green checkmark.
- Student notes field (optional) on each step — calls the notes PATCH endpoint.

### 10.10 AI Chat — Conversations List Screen (`/home/ai`)

Shows all past AI conversations.

UI Elements:
- List of conversation tiles: title (auto-generated from first message), last message preview, timestamp.
- "General AI" pinned card at top for open-ended career questions.
- "+ New conversation" FAB.
- Free tier banner: "You have X of 5 free messages today" — shown as a subtle info bar.
- Tap a conversation → `ChatScreen`.

### 10.11 Chat Screen (`/chat/:conversationId`)

Real-time chat with the AI. The AI is context-aware (knows the student's interest profile and the specific career if opened from a career page).

UI Elements:
- Messages list (`ListView.builder` reversed, most recent at bottom).
- `ChatBubble` for user messages (right-aligned, primary colour background) and AI messages (left-aligned, surface colour).
- `TypingIndicator` while AI response is streaming (three animated dots).
- `MessageInputBar` at the bottom: text field + send button. Disable send button while a response is loading.
- `FreeLimitBanner` shown inline when the user hits the daily message limit (`AI_MESSAGE_LIMIT_REACHED` error): "You've used your 5 free messages today. Upgrade to continue."

Context handling: When navigating to chat from a career detail page, pass the `career_id` to the chat provider. The API endpoint will inject career context automatically.

Streaming: The AI API returns streaming responses. Use `Dio`'s `ResponseType.stream` to show tokens as they arrive. Update the last message in real time using a `StreamController`.

### 10.12 Profile Screen (`/home/profile`)

Central hub for account settings and personalised data.

UI Elements:
- User avatar (tappable → avatar upload) + name + academic stage.
- **Your Interests section:** "View your interest profile" tile → `InterestProfileScreen`.
- **Saved Careers section:** Tile with count → `SavedCareersScreen`.
- **Retake Profiler tile:** "Your interests changed? Redo your profile."
- **Share with Parents tile:** Calls `POST /users/me/share-token/` and opens share sheet with the URL.
- **Subscription tile:** Shows current plan + "Upgrade to Premium" CTA.
- **Settings section:** Notification preferences, account management, privacy, help.
- **Sign Out** (bottom of list, destructive red text).

### 10.13 Interest Profile Screen (`/profile/interests`)

Visualises the student's dimension scores.

UI Elements:
- **Radar chart** using `fl_chart`'s `RadarChart`. Six axes: Creative, Analytical, Social, Technical, Entrepreneurial, Physical. Each axis 0–100.
- Top dimensions listed below the chart with labels and percentages.
- Short explanation: "Your top strength is Creative (82%) — you lean toward design, expression, and storytelling."
- Career clusters suggested based on top dimensions.

### 10.14 Saved Careers Screen (`/profile/saved`)

Shows bookmarked careers.

UI Elements:
- Grid of `CareerCard` widgets (same component as CareerMapScreen).
- Empty state: "No saved careers yet. Explore the career map to save ones you like."

### 10.15 Subscription Screen (`/profile/subscription`)

Shows plan options and initiates Razorpay payment.

UI Elements:
- Current plan indicator.
- Two plan cards: Monthly (₹299/mo) and Yearly (₹1,499/yr — highlight "Save 58%").
- List of premium features: full career matches, detailed roadmaps, real people stories, career comparison, progress tracker.
- "Start Premium" button → calls `POST /api/v1/subscriptions/orders/` → opens Razorpay SDK → on success calls `POST /api/v1/subscriptions/verify/`.
- Restore purchase option (for iOS App Store compliance).

### 10.16 Notifications Screen (`/notifications`)

List of in-app notifications and pending check-ins.

UI Elements:
- Notification tiles with icon, title, body, and timestamp.
- Unread notifications have a subtle highlight. Tap marks as read.
- **Check-in prompts** shown prominently at top if any are pending: "Are you still interested in UX Design?" with Yes / Not sure / Moved on buttons.

### 10.17 Parent View Screen (`/share/:shareToken`)

Read-only screen. No login required — the share token is the credential. Opened via deep link.

UI Elements:
- "Viewing [First Name]'s career profile" header.
- Top matched careers list — each shows career name, one-liner, salary range, and future score.
- Roadmap summary — immediate action items for the top career.
- "Want to discuss this with a counsellor?" CTA.
- NextStep branding + "Download NextStep" CTA at the bottom.

This screen must handle gracefully if the token is invalid or expired (show an error state: "This link has expired. Ask your child to generate a new share link.").

---

## 11. Reusable Widgets & Components

### NSButton

Three variants: `primary`, `secondary`, `text`. Props: `label`, `onPressed`, `isLoading` (shows a `CircularProgressIndicator`), `icon`. Use consistent `BorderRadius` of 12 and height of 52.

### CareerCard

Used on CareerMapScreen, SavedCareersScreen, and search results. Props: `career`, `matchScore` (optional), `onTap`, `onSave`. Shows: name, one-liner, match badge, future score chip, domain tag, save icon.

### OptionTile

Used in the profiler. Props: `emoji`, `label`, `isSelected`, `onTap`. Shows selected state with a filled checkmark circle + highlighted container background. Height 64, corner radius 12.

### SalaryRangeWidget

Props: `entryMin`, `entryMax`, `midMin`, `midMax`, `seniorMin`, `seniorMax` (all in paise). Formats to `₹X–Y LPA` using `SalaryFormatter`. Renders as three columns: Entry / Mid / Senior with a subtle horizontal scale bar.

### DimensionRadarChart

Wraps `fl_chart` RadarChart. Props: `scores` (Map of dimension code → int 0–100). Use the app's primary colour palette for the filled polygon. Show axis labels at each vertex.

### PremiumLockOverlay

A `Stack`-based widget that blurs the child content and overlays a lock icon + "Upgrade to Premium" button. Props: `child`, `isLocked`, `onUnlockTap`. When `isLocked = false`, renders `child` transparently.

### FreeLimitBanner

An informational banner shown when the free AI message limit is reached. Background: amber/warning colour. Shows remaining count when > 0. Props: `used`, `total`, `onUpgradeTap`.

---

## 12. Local Storage & Caching

### Hive Boxes

**`profilerQuestionsBox`** — stores the `List<QuestionEntity>` fetched from `GET /api/v1/profiler/questions/`. Refresh only if the app version changes or the user manually retakes.

**`interestProfileBox`** — stores the latest `InterestProfileEntity` after profiler completion. Updated when profiler is retaken.

**`careerCacheBox`** — stores career detail pages by slug so they load instantly on revisit. Invalidate after 7 days using a `cachedAt` timestamp.

**`pendingAnswersBox`** — queue of profiler answer submissions that failed due to network errors. A background job retries these on app foreground.

### SharedPreferences Keys

- `onboarding_welcome_seen` (bool) — whether to show the welcome screen.
- `profiler_in_progress_session_id` (String?) — saves session ID for resume.
- `last_question_index` (int) — saves progress within the profiler for resume.
- `notification_permission_requested` (bool) — track if push permission was requested.
- `app_version` (String) — detect version changes to invalidate caches.

### flutter_secure_storage Keys

- `django_access_token` — the active JWT access token.
- `django_refresh_token` — the JWT refresh token (30-day expiry).

---

## 13. Push Notifications

Use Firebase Cloud Messaging (FCM) for push notifications delivered by the Django backend via Celery.

### Setup

1. Add `firebase_messaging: ^14.x` to `pubspec.yaml`.
2. Add required `AndroidManifest.xml` permissions and service entries.
3. On iOS, request notification permission using `messaging.requestPermission()`.

### Token Registration

After the user logs in and the Django JWT is obtained, call `FirebaseMessaging.instance.getToken()` to get the FCM device token. Send it to the backend via `PATCH /api/v1/users/me/device-token/` so the Django backend can send targeted notifications.

### Notification Types (from the `notifications` table)

Handle the following notification types:

- `roadmap_reminder` — "You haven't checked your [Career] roadmap in a while."
- `check_in` — "Quick check: still interested in [Career]?" Opens the check-in bottom sheet.
- `new_career_match` — "New careers match your profile." Navigates to CareerMapScreen.
- `subscription_expiry` — "Your Premium plan expires in 3 days." Navigates to SubscriptionScreen.

### Foreground Handling

Use `FirebaseMessaging.onMessage` to listen for foreground notifications. Show them using `flutter_local_notifications` as an in-app banner instead of a system notification.

### Background & Tap Handling

Use `FirebaseMessaging.onMessageOpenedApp` and `FirebaseMessaging.onBackgroundMessage` to handle notification taps. Use GoRouter to navigate to the correct screen based on the notification's `data.type` and `data.target_id`.

---

## 14. Theming & Design System

### Colour Palette (`app_colors.dart`)

- **Primary:** `#6C63FF` — indigo-purple (brand identity; use for CTAs, active states)
- **PrimaryLight:** `#EDE9FF` — backgrounds for selected states
- **Secondary:** `#FF6584` — accent for highlights, achievement badges
- **Success:** `#22C55E`
- **Warning:** `#F59E0B`
- **Error:** `#EF4444`
- **Surface:** `#FFFFFF`
- **Background:** `#F9F9FB`
- **OnSurface:** `#1A1A2E`
- **Muted:** `#6B7280`

### Dimension Colours

Each of the six interest dimensions has a distinct colour for chips and radar chart segments:

- Creative (C): `#F472B6` — pink
- Analytical (A): `#60A5FA` — blue
- Social (S): `#34D399` — green
- Technical (T): `#FBBF24` — amber
- Entrepreneurial (E): `#A78BFA` — violet
- Physical (P): `#FB923C` — orange

### Typography (`app_typography.dart`)

Use `Nunito` or `Poppins` (import via Google Fonts). Define a complete `TextTheme`:

- `displayLarge`: 32sp, bold — splash/hero screens
- `headlineMedium`: 22sp, semibold — screen titles
- `titleLarge`: 18sp, semibold — card titles
- `bodyLarge`: 16sp, regular — body content
- `bodyMedium`: 14sp, regular — secondary content
- `labelMedium`: 12sp, medium — chips, badges

### Spacing (`app_spacing.dart`)

Use a consistent 4-point grid: 4, 8, 12, 16, 20, 24, 32, 48.

### Card Style

All cards use: background `#FFFFFF`, border radius 16, box shadow `(0, 2, 12, 0, black 6%)`. Use `Material` with `elevation: 0` + a `BoxDecoration` border `1px #F1F1F5` for subtle separation.

### Bottom Navigation

Five tabs: Careers (home icon), Explore (compass), Roadmap (map icon), AI (chat bubble), Profile (person). Active tab uses primary colour; inactive uses muted grey.

---

## 15. Error Handling Strategy

### Principles

Every async operation that touches the network must handle three states: loading, success, and error. Use Riverpod's `AsyncValue` to represent these states and render appropriate UI for each.

### Network Error States

- **No internet connection:** Show a full-screen `NSErrorView` with "No internet connection. Check your network and try again." + Retry button. Use `connectivity_plus` to detect offline state before making API calls.
- **Server error (500):** Show `NSErrorView` with "Something went wrong on our end. Please try again in a moment." + Retry button.
- **Rate limiting (429):** Show a snackbar: "Too many requests. Please wait a moment."
- **Session expired (401, refresh failed):** Show a snackbar "Session expired. Please log in again." and navigate to `/login`.

### Form Validation Errors (400)

The API returns field-level validation errors in the `error.details` field. Map these to the corresponding Flutter `FormField` validators and show errors inline under the relevant fields.

### Profiler-Specific Error Handling

If an answer submission fails during the profiler, do not block the user. Queue the failed request in the `pendingAnswersBox` (Hive) and show no visible error. Retry the queued requests silently on the next app foreground event. If the session completion call fails, show a snackbar with a retry button — do not navigate away.

### Global Error Boundary

Wrap `MaterialApp.router` in a `ProviderScope` with an `ErrorBoundary`-like widget that catches unhandled `AsyncError` states and routes them to a generic error screen with a "Go back to home" option.

---

## 16. Analytics Integration

The API contract defines a `POST /api/v1/analytics/events/` endpoint for event ingestion. Track events from the Flutter app for product analytics and school dashboards.

### Event Tracking Service

Create a singleton `AnalyticsService` with a `track(String eventName, {Map<String, dynamic>? properties})` method. Internally, this calls the API endpoint. Batch events with a 500ms debounce to avoid excessive API calls.

### Key Events to Track

| Event Name | When to Fire | Properties |
|---|---|---|
| `profiler_started` | Session created | `session_number` |
| `question_answered` | Each answer submitted | `question_code`, `section`, `skipped` |
| `profiler_completed` | Session completion | `time_taken_seconds`, `top_dimensions` |
| `career_viewed` | Career detail screen opened | `career_slug`, `source` (map/explore/search) |
| `career_saved` | Bookmark tapped | `career_slug` |
| `roadmap_generated` | Roadmap creation | `career_slug` |
| `roadmap_step_completed` | Step checked off | `career_slug`, `step_category` |
| `ai_message_sent` | User sends message | `conversation_type`, `is_career_specific` |
| `subscription_screen_viewed` | User opens subscription | |
| `subscription_purchase_started` | Razorpay order initiated | `plan_name` |
| `subscription_purchase_completed` | Payment verified | `plan_name` |

---

## 17. Subscription & Paywall Flow

### Paywall Triggers

Show the `SubscriptionScreen` or an inline upgrade prompt when the user attempts to:

- View more than 5 career matches (free tier sees top 5 only).
- Open a premium-locked real people story.
- Start more than 1 AI conversation (premium limit is unlimited; free is 5 messages/day).
- Access detailed roadmaps beyond the basic structure.

### Razorpay Integration

1. Add `razorpay_flutter: ^1.x` to `pubspec.yaml`.
2. On "Start Premium" tap: call `POST /api/v1/subscriptions/orders/` → get `razorpay_order_id` and `amount_paise`.
3. Initialise `Razorpay` SDK with key ID and the order ID.
4. Handle `onPaymentSuccess`: call `POST /api/v1/subscriptions/verify/` with the Razorpay payment ID, order ID, and signature. On success, refresh `currentUserProvider` to update `subscription_tier`.
5. Handle `onPaymentError`: show an error snackbar with the error description.
6. Handle `onExternalWallet`: show informational snackbar.

---

## 18. Deep Links & Share

### App Deep Links

Configure deep links for the following URL patterns (set up in Android `AndroidManifest.xml` and iOS `Info.plist` for `nextstep.app`):

- `https://app.nextstep.app/parent-view/{shareToken}` → `/share/:shareToken`
- `https://app.nextstep.app/career/{slug}` → `/career/:slug`

### Parent Share Flow

1. Student taps "Share with Parents" on Profile screen.
2. App calls `POST /api/v1/users/me/share-token/` → gets `share_url`.
3. Open the system share sheet using `share_plus` with the `share_url` and a pre-written message: "Here's my career profile on NextStep — take a look at the careers I'm exploring!"
4. Parents who tap the link open the app (if installed) or the web (fallback) and see the `ParentViewScreen`.

---

## 19. App Configuration & Environment

### Flavours

Configure three Flutter flavours using `flutter_flavorizr` or manual Dart defines:

- **development** — points to local Django server or staging API. Firebase emulator. Debug banner visible.
- **staging** — staging API. Real Firebase. For QA testing.
- **production** — `https://api.nextstep.app/api/v1/`. Release mode. No debug banner.

### App Constants

Store environment-specific values using `--dart-define` flags at build time, not hardcoded in source:

- `API_BASE_URL`
- `RAZORPAY_KEY_ID` (use test key for dev/staging, live key for production)

### App Version Header

Use `package_info_plus` to read the app version and build number. Add this as `X-App-Version: {version}+{buildNumber}` to every API request via the `AuthInterceptor`.

---

## 20. Build & Release Checklist

### Android

- Set `applicationId = "com.nextstep.app"` in `build.gradle`.
- Configure signing with a release keystore. Store credentials in environment variables, not in source control.
- Set `minSdkVersion 21` (Android 5.0+) for broad coverage.
- Enable ProGuard/R8 for release builds.
- Place `google-services.json` in `android/app/` (do not commit to public repositories).

### iOS

- Set bundle ID `com.nextstep.app`.
- Configure signing team and provisioning profile in Xcode.
- Place `GoogleService-Info.plist` in `ios/Runner/` (do not commit).
- Add required `Info.plist` entries for camera (avatar upload), notifications, and deep link URL scheme.

### Pre-Release Checks

- All API endpoints use the production base URL in the production flavour.
- Razorpay key is the live key in production build.
- Firebase project is the production project (not the dev project).
- Logging and `PrettyDioLogger` are disabled in release builds.
- `kDebugMode` checks wrap any debug-only UI elements.
- Run `flutter analyze` and resolve all warnings.
- Run the full onboarding flow end-to-end on a physical Android device (Android-first priority).
- Test the parent share deep link on both Android and iOS.
- Test Razorpay payment with a test card before switching to live key.
- Verify push notification delivery on a physical device (FCM does not work on emulators).

---

*NextStep Flutter Development Guide v1.0*
*Aligned with: Product Document v1.0 | API Contract v1.0 | Database Schema v1.0 | Onboarding Questionnaire v1.0*
*Stack: Flutter (Dart) | Firebase Auth | Django REST API | Riverpod | GoRouter | Hive | Dio | Razorpay*
