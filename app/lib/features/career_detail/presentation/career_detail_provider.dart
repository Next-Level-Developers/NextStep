// lib/features/career_detail/presentation/career_detail_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../explore/data/career_remote_source.dart';
import '../../home/data/recommendation_remote_source.dart';
import '../domain/career_detail_entity.dart';

/// Family provider for career detail by slug.
final careerDetailProvider =
    FutureProvider.family<CareerDetailEntity, String>((ref, slug) async {
  final source = ref.watch(careerRemoteSourceProvider);
  final data = await source.getCareerDetail(slug);
  return CareerDetailEntity.fromJson(data);
});

/// Notifier for save/unsave career toggle.
class SaveCareerNotifier extends StateNotifier<AsyncValue<bool>> {
  final RecommendationRemoteSource _source;
  final String slug;

  SaveCareerNotifier(this._source, this.slug, bool initialSaved)
      : super(AsyncValue.data(initialSaved));

  Future<void> toggle() async {
    final currentSaved = state.value ?? false;
    // Optimistic update
    state = AsyncValue.data(!currentSaved);
    try {
      if (currentSaved) {
        await _source.unsaveCareer(slug);
      } else {
        await _source.saveCareer(slug);
      }
    } catch (e, st) {
      // Revert on error
      state = AsyncValue.data(currentSaved);
      state = AsyncValue.error(e, st);
    }
  }
}

final saveCareerNotifierProvider = StateNotifierProvider.family<
    SaveCareerNotifier, AsyncValue<bool>, ({String slug, bool initialSaved})>(
  (ref, params) {
    final source = ref.watch(recommendationRemoteSourceProvider);
    return SaveCareerNotifier(source, params.slug, params.initialSaved);
  },
);
