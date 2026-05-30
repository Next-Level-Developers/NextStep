// lib/features/roadmap/presentation/roadmap_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/roadmap_remote_source.dart';
import '../domain/roadmap_entity.dart';

/// Provider for user's roadmaps list.
final roadmapListProvider =
    FutureProvider<List<RoadmapListItem>>((ref) async {
  final source = ref.watch(roadmapRemoteSourceProvider);
  return source.listRoadmaps();
});

/// Family provider for roadmap detail.
final roadmapDetailProvider =
    FutureProvider.family<RoadmapDetail, String>((ref, roadmapId) async {
  final source = ref.watch(roadmapRemoteSourceProvider);
  return source.getRoadmapDetail(roadmapId);
});

/// Provider for progress summary.
final progressSummaryProvider =
    FutureProvider<ProgressSummary>((ref) async {
  final source = ref.watch(roadmapRemoteSourceProvider);
  return source.getProgressSummary();
});

/// Notifier for creating a roadmap.
class CreateRoadmapNotifier extends StateNotifier<AsyncValue<RoadmapDetail?>> {
  final RoadmapRemoteSource _source;
  final Ref _ref;

  CreateRoadmapNotifier(this._source, this._ref)
      : super(const AsyncValue.data(null));

  Future<RoadmapDetail?> create(String careerSlug) async {
    state = const AsyncValue.loading();
    try {
      final roadmap = await _source.createRoadmap(careerSlug);
      _ref.invalidate(roadmapListProvider);
      state = AsyncValue.data(roadmap);
      return roadmap;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final createRoadmapNotifierProvider =
    StateNotifierProvider<CreateRoadmapNotifier, AsyncValue<RoadmapDetail?>>(
        (ref) {
  final source = ref.watch(roadmapRemoteSourceProvider);
  return CreateRoadmapNotifier(source, ref);
});

/// Notifier for updating step progress.
class StepProgressNotifier extends StateNotifier<AsyncValue<void>> {
  final RoadmapRemoteSource _source;
  final Ref _ref;

  StepProgressNotifier(this._source, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> updateStep({
    required String roadmapId,
    required String stepId,
    required String status,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _source.updateStepProgress(
        roadmapId: roadmapId,
        stepId: stepId,
        status: status,
      );
      _ref.invalidate(roadmapDetailProvider(roadmapId));
      _ref.invalidate(roadmapListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final stepProgressNotifierProvider =
    StateNotifierProvider<StepProgressNotifier, AsyncValue<void>>((ref) {
  final source = ref.watch(roadmapRemoteSourceProvider);
  return StepProgressNotifier(source, ref);
});
