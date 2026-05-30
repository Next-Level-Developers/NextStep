# NextStep Flutter - Implementation Tracker

## Status: 75% Complete → Target: 100%

### Phase 1: Critical Launch Blockers (Week 1)

#### ✅ Task 1: Career Detail Enhancement (2-3 hours)
- [ ] Extend CareerDetailEntity with `realPeopleStories` and `learningResources` fields
- [ ] Update career_detail_screen.dart to display stories and resources
- [ ] Add story cards and resource links UI components
- **Files to modify:**
  - `features/career_detail/domain/career_detail_entity.dart`
  - `features/career_detail/presentation/career_detail_screen.dart`
  - `features/career_detail/presentation/widgets/` (new story/resource widgets)

**Status:** NOT STARTED

---

#### ⏳ Task 2: Parent View Share Implementation (4-6 hours)
- [ ] Implement parent_view domain/repository layer
- [ ] Implement parent_view data/remote_source layer  
- [ ] Create read-only parent view screen with shared careers
- [ ] Add share token URL generation and deep linking
- **Files to create:**
  - `features/parent_view/domain/parent_profile_entity.dart`
  - `features/parent_view/domain/parent_view_repository.dart`
  - `features/parent_view/data/parent_view_remote_source.dart`
  - `features/parent_view/data/parent_view_repository_impl.dart`
  - `features/parent_view/presentation/widgets/` (read-only career display)
- **Files to modify:**
  - `features/parent_view/presentation/parent_view_screen.dart` (replace stub)
  - `features/profile/presentation/profile_screen.dart` (add share button)

**Status:** NOT STARTED

---

#### ⏳ Task 3: Firebase Messaging Integration (2-3 hours)
- [ ] Initialize Firebase Messaging in main.dart
- [ ] Handle notification permissions + token refresh
- [ ] Integrate with notifications_provider.dart
- [ ] Add notification tap handlers (deep link to career/roadmap)
- **Files to modify:**
  - `main.dart` - Initialize Firebase Messaging
  - `core/services/firebase_messaging_service.dart` (new)
  - `features/notifications/presentation/notifications_provider.dart`
  - `app_router.dart` - Add notification intent handlers

**Status:** NOT STARTED

---

### Phase 2: Feature Completion (Week 2)

#### ⏳ Task 4: Career Map Proper Data Layer (2 hours)
- [ ] Create CareerMapRepository (not just use home recommendations)
- [ ] Move filtering logic to career_map feature
- [ ] Add sorting options (match score, future score, salary)
- **Files to create:**
  - `features/career_map/domain/career_map_repository.dart`
  - `features/career_map/data/career_map_repository_impl.dart`
  - `features/career_map/data/career_map_remote_source.dart`
- **Files to modify:**
  - `features/career_map/presentation/career_map_provider.dart`
  - `features/career_map/presentation/career_map_screen.dart`

**Status:** NOT STARTED

---

#### ⏳ Task 5: Razorpay Payment Integration (6-8 hours)
- [ ] Implement payment order creation endpoint calls
- [ ] Integrate Razorpay checkout flow
- [ ] Add payment verification
- [ ] Update subscription status after successful payment
- **Files to modify:**
  - `features/profile/presentation/subscription_screen.dart`
  - `features/profile/presentation/subscription_provider.dart` (create notifier)
  - Add payment service layer

**Status:** NOT STARTED

---

### Phase 3: Experience Polish (Week 3)

#### ⏳ Task 6: Hive Caching Strategy (2-3 hours)
- [ ] Cache career recommendations locally
- [ ] Cache career list + details
- [ ] Implement offline-first mode with Hive
- [ ] Add cache invalidation logic
- **Files to create:**
  - `core/cache/hive_boxes.dart` (centralized Hive box definitions)
  - `core/cache/cache_service.dart` (abstraction layer)

**Status:** NOT STARTED

---

#### ⏳ Task 7: Analytics Event Tracking (2-3 hours)
- [ ] Wire up analytics_provider to actual events
- [ ] Track screen views, button clicks, profiler completion
- [ ] Track career views and saves
- [ ] Track roadmap progress
- **Files to modify:**
  - All presentation screens (add analytics calls)
  - Create `core/analytics/analytics_service.dart`

**Status:** NOT STARTED

---

#### ⏳ Task 8: Deep Links Configuration (1-2 hours)
- [ ] Update app_router.dart for deep link handling
- [ ] Test /career/:slug, /roadmap/:id, /share/:token URLs
- [ ] Add deep link intent handler in main.dart

**Status:** NOT STARTED

---

### Summary

| Phase | Tasks | Hours | Status |
|-------|-------|-------|--------|
| **Phase 1** | 3 critical | 8-12h | 🔴 NOT STARTED |
| **Phase 2** | 2 features | 8-10h | 🔴 NOT STARTED |
| **Phase 3** | 3 polish | 5-8h | 🔴 NOT STARTED |
| **TOTAL** | **8 tasks** | **~30h** | 🔴 BLOCKED |

---

## Key Decisions Made

1. **Career Detail:** Will extend entity to include stories + resources from API
2. **Parent View:** Will implement full feature with domain/data/presentation layers
3. **Firebase Messaging:** Will add as a core service, not feature-specific
4. **Payment:** Will integrate Razorpay without changes to backend (already ready)
5. **Caching:** Hive for local storage; offline mode as enhancement

---

## API Endpoints Required (from Backend)

All endpoints must be implemented by Django backend:
- `GET /api/v1/careers/{slug}/` - Career detail with stories + resources
- `GET /api/v1/share/{shareToken}/` - Parent view data (no auth required)
- `POST /api/v1/notifications/token/` - Firebase messaging token registration
- `GET /api/v1/recommendations/` - Career recommendations for career map
- `POST /api/v1/subscriptions/orders/` - Create Razorpay order
- `POST /api/v1/subscriptions/verify/` - Verify payment

---

## Testing Strategy

- [ ] Unit tests for providers (Riverpod)
- [ ] Widget tests for major screens
- [ ] Integration tests for auth + onboarding flow
- [ ] Manual QA for payment flow (sandbox)

**Target:** 70% code coverage before launch

---

**Last Updated:** 2026-05-30
**Next Review:** After Phase 1 completion
