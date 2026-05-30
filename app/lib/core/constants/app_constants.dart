// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // API
  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://3.109.206.125:8000/api/v1/');

  // Razorpay
  static const String razorpayKeyId =
      String.fromEnvironment('RAZORPAY_KEY_ID', defaultValue: 'rzp_test_placeholder');

  // Hive box names
  static const String profilerQuestionsBox = 'profilerQuestionsBox';
  static const String interestProfileBox = 'interestProfileBox';
  static const String careerCacheBox = 'careerCacheBox';
  static const String pendingAnswersBox = 'pendingAnswersBox';

  // SharedPreferences keys
  static const String keyOnboardingWelcomeSeen = 'onboarding_welcome_seen';
  static const String keyProfilerSessionId = 'profiler_in_progress_session_id';
  static const String keyLastQuestionIndex = 'last_question_index';
  static const String keyNotificationPermissionRequested = 'notification_permission_requested';
  static const String keyAppVersion = 'app_version';

  // flutter_secure_storage keys
  static const String keyDjangoAccessToken = 'django_access_token';
  static const String keyDjangoRefreshToken = 'django_refresh_token';

  // Profiler
  static const int totalProfilerQuestions = 27;

  // Free tier limits
  static const int freeCareerMatchLimit = 5;
  static const int freeAiMessagesPerDay = 5;

  // Cache TTL
  static const int careerCacheTtlDays = 7;

  // Animation durations
  static const Duration optionSelectDelay = Duration(milliseconds: 300);
  static const Duration sectionTransitionAutoAdvance = Duration(milliseconds: 1500);
  static const Duration profileBuildingDuration = Duration(seconds: 3);
}
