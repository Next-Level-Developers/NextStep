// lib/core/router/route_names.dart

class RouteNames {
  RouteNames._();

  // Root / Core
  static const String root = '/';
  
  // Auth
  static const String login = '/login';
  static const String signup = '/signup';

  // Onboarding
  static const String onboardingWelcome = '/onboarding/welcome';
  static const String onboardingProfiler = '/onboarding/profiler';
  static const String onboardingBuilding = '/onboarding/building';

  // Home (Shell / Tabs)
  static const String home = '/home';
  static const String homeCareers = '/home/careers';
  static const String homeExplore = '/home/explore';
  static const String homeRoadmaps = '/home/roadmaps';
  static const String homeAi = '/home/ai';
  static const String homeProfile = '/home/profile';

  // Features Detail
  static const String careerDetail = '/career/:slug';
  static const String roadmapDetail = '/roadmap/:roadmapId';
  static const String chatDetail = '/chat/:conversationId';

  // Profile Section Sub-routes
  static const String profileInterests = '/profile/interests';
  static const String profileSaved = '/profile/saved';
  static const String profileEdit = '/profile/edit';
  static const String profileSubscription = '/profile/subscription';

  // Other Global routes
  static const String notifications = '/notifications';
  static const String parentView = '/share/:shareToken';

  // Helpers to resolve paths with parameters
  static String careerPath(String slug) => '/career/$slug';
  static String roadmapPath(String id) => '/roadmap/$id';
  static String chatPath(String conversationId) => '/chat/$conversationId';
  static String parentViewPath(String shareToken) => '/share/$shareToken';
}
