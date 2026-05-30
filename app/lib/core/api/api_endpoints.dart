// lib/core/api/api_endpoints.dart

/// All API endpoint URL paths aligned with the NextStep backend documentation.
/// Base URL is set on the Dio instance in api_client.dart.
class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String firebaseExchange = 'auth/firebase/';
  static const String tokenRefresh = 'auth/token/refresh/';

  // ── Users ─────────────────────────────────────────────────────────────────
  static const String me = 'users/me/';
  static const String meAvatar = 'users/me/avatar/';
  static const String meStudentProfile = 'users/me/student-profile/';
  static const String meParentalConsent = 'users/me/parental-consent/';
  static const String meShareToken = 'users/me/share-token/';
  static const String meDeviceToken = 'users/me/device-token/';

  // ── Profiler ──────────────────────────────────────────────────────────────
  static const String profilerQuestions = 'profiler/questions/';
  static const String profilerSessions = 'profiler/sessions/';
  static const String profilerProfile = 'profiler/profile/';

  static String profilerSession(String sessionId) =>
      'profiler/sessions/$sessionId/';
  static String profilerResponses(String sessionId) =>
      'profiler/sessions/$sessionId/responses/';
  static String profilerComplete(String sessionId) =>
      'profiler/sessions/$sessionId/complete/';

  // ── Careers ───────────────────────────────────────────────────────────────
  static const String careers = 'careers/';
  static const String careerDomains = 'careers/domains/';
  static const String careerClusters = 'careers/clusters/';
  static const String careerCompare = 'careers/compare/';

  static String career(String slug) => 'careers/$slug/';
  static String careerDomainDetail(String slug) => 'careers/domains/$slug/';

  // ── Recommendations ───────────────────────────────────────────────────────
  static const String recommendations = 'recommendations/';
  static const String recommendationsRegenerate = 'recommendations/regenerate/';
  static const String savedCareers = 'recommendations/saved/';

  static String savedCareer(String slug) => 'recommendations/saved/$slug/';

  // ── Roadmaps ──────────────────────────────────────────────────────────────
  static const String roadmaps = 'roadmaps/';
  static const String roadmapProgressSummary = 'roadmaps/progress-summary/';

  static String roadmap(String roadmapId) => 'roadmaps/$roadmapId/';
  static String roadmapStep(String roadmapId, String stepId) =>
      'roadmaps/$roadmapId/steps/$stepId/progress/';

  // ── AI Chat ───────────────────────────────────────────────────────────────
  static const String aiConversations = 'ai/conversations/';

  static String aiConversation(String id) => 'ai/conversations/$id/';
  static String aiConversationMessages(String id) =>
      'ai/conversations/$id/messages/';

  // ── Content ───────────────────────────────────────────────────────────────
  static String careerStories(String slug) => 'content/careers/$slug/stories/';
  static String careerResources(String slug) =>
      'content/careers/$slug/resources/';

  // ── Subscriptions ─────────────────────────────────────────────────────────
  static const String subscriptionPlans = 'subscriptions/plans/';
  static const String subscriptionCreateOrder = 'subscriptions/create-order/';
  static const String subscriptionVerifyPayment =
      'subscriptions/verify-payment/';
  static const String subscriptionMe = 'subscriptions/me/';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notifications = 'notifications/';
  static const String notificationsMarkAllRead = 'notifications/mark-all-read/';

  static String notificationRead(String id) => 'notifications/$id/read/';

  // ── Check-Ins ─────────────────────────────────────────────────────────────
  static const String checkIns = 'check-ins/';

  static String checkInRespond(String id) => 'check-ins/$id/respond/';

  // ── Analytics ─────────────────────────────────────────────────────────────
  static const String analyticsEvents = 'analytics/events/';

  // ── Counsellor ────────────────────────────────────────────────────────────
  static const String counsellorDashboard = 'counsellor/dashboard/';
  static const String counsellorStudents = 'counsellor/students/';

  // ── Share View ────────────────────────────────────────────────────────────
  static const String generateParentShareToken = 'share/generate-token/';
  
  static String parentShare(String shareToken) =>
      'share/profile/$shareToken/';

  // ── Health ────────────────────────────────────────────────────────────────
  static const String health = 'health';
}
