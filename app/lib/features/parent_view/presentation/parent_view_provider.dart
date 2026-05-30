import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/parent_view_repository_impl.dart';
import '../domain/parent_view_repository.dart';
import '../domain/parent_profile_entity.dart';

/// Family provider for fetching parent view by share token.
final parentViewProvider =
    FutureProvider.family<ParentProfileEntity, String>((ref, shareToken) async {
  final repository = ref.watch(parentViewRepositoryProvider);
  return repository.getSharedProfile(shareToken);
});

/// Notifier for generating share tokens.
class GenerateShareTokenNotifier extends StateNotifier<AsyncValue<String>> {
  final ParentViewRepository _repository;

  GenerateShareTokenNotifier(this._repository)
      : super(const AsyncValue.data(''));

  Future<void> generate() async {
    state = const AsyncValue.loading();
    try {
      final token = await _repository.generateShareToken();
      state = AsyncValue.data(token);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final generateShareTokenProvider =
    StateNotifierProvider<GenerateShareTokenNotifier, AsyncValue<String>>((ref) {
  final repository = ref.watch(parentViewRepositoryProvider);
  return GenerateShareTokenNotifier(repository);
});
