// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_provider.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/onboarding/presentation/profiler_screen.dart';
import '../../features/onboarding/presentation/profile_building_screen.dart';
import '../../features/onboarding/presentation/onboarding_provider.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/career_map/presentation/career_map_screen.dart';
import '../../features/explore/presentation/explore_screen.dart';
import '../../features/roadmap/presentation/roadmaps_list_screen.dart';
import '../../features/ai_chat/presentation/conversations_list_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/career_detail/presentation/career_detail_screen.dart';
import '../../features/roadmap/presentation/roadmap_detail_screen.dart';
import '../../features/ai_chat/presentation/chat_screen.dart';
import '../../features/profile/presentation/interest_profile_screen.dart';
import '../../features/profile/presentation/saved_careers_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/subscription_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/parent_view/presentation/parent_view_screen.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Listenable that triggers GoRouter redirects whenever authentication state changes.
class RouterListenable extends ChangeNotifier {
  final Ref _ref;

  RouterListenable(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
    _ref.listen(currentUserProvider, (_, __) => notifyListeners());
  }
}

final routerListenableProvider = Provider<RouterListenable>((ref) {
  return RouterListenable(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = ref.watch(routerListenableProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.login,
    refreshListenable: listenable,
    redirect: (context, state) {
      final path = state.uri.toString();

      // 1. Parental share bypass
      if (path.startsWith('/share/')) {
        return null; // Let it through
      }

      // Read current auth state
      final firebaseUser = ref.read(authStateProvider).value;
      final isFirebaseAuthed = firebaseUser != null;

      // 2. Auth checks
      if (!isFirebaseAuthed) {
        if (path == RouteNames.login || path == RouteNames.signup) {
          return null; // Allowed
        }
        return RouteNames.login;
      }

      // Check current user profile from Django backend
      final userAsync = ref.read(currentUserProvider);
      if (userAsync.isLoading) {
        return null; // Stay where we are while profile loads
      }

      final user = userAsync.value;
      if (user == null) {
        // Django exchange might be in progress, wait
        return null;
      }

      final isProfilerCompleted = user.studentProfile?.profilerCompleted ?? false;
      final onboardingState = ref.read(onboardingNotifierProvider).valueOrNull;
      final hasLocalCompletion = onboardingState?.status == OnboardingStatus.done;

      // 3. Profiler onboarding check
      if (!isProfilerCompleted && !hasLocalCompletion) {
        if (path.startsWith('/onboarding')) {
          return null; // Allowed
        }
        return RouteNames.onboardingWelcome;
      }

      // 4. Authenticated & Completed redirect
      if (path == RouteNames.login ||
          path == RouteNames.signup ||
          path.startsWith('/onboarding')) {
        return RouteNames.homeCareers;
      }

      return null;
    },
    routes: [
      // Auth
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // Onboarding Flow
      GoRoute(
        path: RouteNames.onboardingWelcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.onboardingProfiler,
        builder: (context, state) => const ProfilerScreen(),
      ),
      GoRoute(
        path: RouteNames.onboardingBuilding,
        builder: (context, state) => const ProfileBuildingScreen(),
      ),

      // Main Navigation Shell (Tabs)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: RouteNames.homeCareers,
            builder: (context, state) => const CareerMapScreen(),
          ),
          GoRoute(
            path: RouteNames.homeExplore,
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: RouteNames.homeRoadmaps,
            builder: (context, state) => const RoadmapsListScreen(),
          ),
          GoRoute(
            path: RouteNames.homeAi,
            builder: (context, state) => const ConversationsListScreen(),
          ),
          GoRoute(
            path: RouteNames.homeProfile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Global Detail Screens (Pushed over the Bottom Nav shell)
      GoRoute(
        path: RouteNames.careerDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return CareerDetailScreen(slug: slug);
        },
      ),
      GoRoute(
        path: RouteNames.roadmapDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final roadmapId = state.pathParameters['roadmapId'] ?? '';
          return RoadmapDetailScreen(roadmapId: roadmapId);
        },
      ),
      GoRoute(
        path: RouteNames.chatDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId'] ?? '';
          return ChatScreen(conversationId: conversationId);
        },
      ),

      // Profile Sub-Pages
      GoRoute(
        path: RouteNames.profileInterests,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InterestProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.profileSaved,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SavedCareersScreen(),
      ),
      GoRoute(
        path: RouteNames.profileEdit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.profileSubscription,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Parent View Shared route
      GoRoute(
        path: RouteNames.parentView,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final shareToken = state.pathParameters['shareToken'] ?? '';
          return ParentViewScreen(shareToken: shareToken);
        },
      ),
    ],
  );
});
