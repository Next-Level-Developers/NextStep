// lib/features/home/presentation/recommendation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/recommendation_remote_source.dart';
import '../domain/recommendation_entity.dart';

/// Provider for fetching personalized recommendations.
final recommendationsProvider =
    FutureProvider<RecommendationsResponse>((ref) async {
  // Ensure we refetch if the user changes or if their profile is updated.
  ref.watch(currentUserProvider);
  final source = ref.watch(recommendationRemoteSourceProvider);
  return source.getRecommendations();
});

/// Provider for saved careers list.
final savedCareersProvider =
    FutureProvider<List<SavedCareerItem>>((ref) async {
  ref.watch(currentUserProvider);
  final source = ref.watch(recommendationRemoteSourceProvider);
  return source.listSavedCareers();
});

/// Notifier for regenerating recommendations.
class RegenerateNotifier extends StateNotifier<AsyncValue<void>> {
  final RecommendationRemoteSource _source;
  final Ref _ref;

  RegenerateNotifier(this._source, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> regenerate() async {
    state = const AsyncValue.loading();
    try {
      await _source.regenerateRecommendations();
      // Wait a bit then refresh recommendations
      await Future.delayed(const Duration(seconds: 3));
      _ref.invalidate(recommendationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final regenerateNotifierProvider =
    StateNotifierProvider<RegenerateNotifier, AsyncValue<void>>((ref) {
  final source = ref.watch(recommendationRemoteSourceProvider);
  return RegenerateNotifier(source, ref);
});
