// lib/core/api/api_endpoints.dart

/// All API endpoint URL paths. Never hardcode these in repository files.
/// Base URL is set on the Dio instance in api_client.dart.
class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String firebaseExchange  = 'auth/firebase/';
  static const String tokenRefresh      = 'auth/token/refresh/';

  // ── Users ─────────────────────────────────────────────────────────────────
  static const String me                = 'users/me/';
  static const String meAvatar          = 'users/me/avatar/';
  static const String meStudentProfile  = 'users/me/student-profile/';
  static const String meParentalConsent = 'users/me/parental-consent/';
  static const String meShareToken      = 'users/me/share-token/';
  static const String meDeviceToken     = 'users/me/device-token/';

  // ── Profiler ──────────────────────────────────────────────────────────────
  static const String profilerQuestions = 'profiler/questions/';
  static const String profilerSessions  = 'profiler/sessions/';
  static const String profilerProfile   = 'profiler/profile/';

  static String profilerSession(String sessionId) =>
      'profiler/sessions/$sessionId/';
  static String profilerResponses(String sessionId) =>
      'profiler/sessions/$sessionId/responses/';
  static String profilerComplete(String sessionId) =>
      'profiler/sessions/$sessionId/complete/';

  // ── Careers ───────────────────────────────────────────────────────────────
  static const String careers       = 'careers/';
  static const String careerDomains = 'careers/domains/';

  static String career(String slug)         => 'careers/$slug/';
  static String careerSearch(String q)      => 'careers/?search=$q';
  static String careersByDomain(String slug) => 'careers/?domain_slug=$slug';

  // ── Recommendations ───────────────────────────────────────────────────────
  static const String recommendations = 'recommendations/';
  static const String saveCareer      = 'recommendations/save/';
  static const String savedCareers    = 'recommendations/saved/';
  static const String viewCareer      = 'recommendations/view/';

  // ── Roadmaps ──────────────────────────────────────────────────────────────
  static const String roadmaps         = 'roadmaps/';
  static const String generateRoadmap  = 'roadmaps/generate/';

  static String roadmap(String roadmapId)       => 'roadmaps/$roadmapId/';
  static String roadmapStep(String roadmapId, String stepId) =>
      'roadmaps/$roadmapId/steps/$stepId/progress/';

  // ── AI Chat ───────────────────────────────────────────────────────────────
  static const String aiConversations = 'ai/conversations/';
  static const String aiMessages      = 'ai/messages/';

  static String aiConversation(String id)  => 'ai/conversations/$id/';
  static String aiConversationMessages(String id) =>
      'ai/conversations/$id/messages/';

  // ── Content ───────────────────────────────────────────────────────────────
  static String careerStories(String careerSlug) =>
      'content/stories/?career=$careerSlug';

  // ── Subscriptions ─────────────────────────────────────────────────────────
  static const String subscriptionPlans  = 'subscriptions/plans/';
  static const String subscriptionOrders = 'subscriptions/orders/';
  static const String subscriptionVerify = 'subscriptions/verify/';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notifications   = 'notifications/';
  static const String checkIns        = 'check-ins/';

  static String notification(String id)   => 'notifications/$id/read/';
  static String checkInRespond(String id) => 'check-ins/$id/respond/';

  // ── Analytics ─────────────────────────────────────────────────────────────
  static const String analyticsEvents = 'analytics/events/';

  // ── Parent Share View ─────────────────────────────────────────────────────
  static String parentView(String shareToken) => 'parent-view/$shareToken/';
}
