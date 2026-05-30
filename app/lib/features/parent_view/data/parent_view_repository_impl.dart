import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/parent_profile_entity.dart';
import '../domain/parent_view_repository.dart';
import 'parent_view_remote_source.dart';

class ParentViewRepositoryImpl implements ParentViewRepository {
  final ParentViewRemoteSource _remoteSource;

  ParentViewRepositoryImpl(this._remoteSource);

  @override
  Future<ParentProfileEntity> getSharedProfile(String shareToken) async {
    final json = await _remoteSource.getSharedProfile(shareToken);
    return ParentProfileEntity.fromJson(json);
  }

  @override
  Future<String> generateShareToken() async {
    return await _remoteSource.generateShareToken();
  }
}

final parentViewRepositoryProvider = Provider<ParentViewRepository>((ref) {
  final remoteSource = ref.watch(parentViewRemoteSourceProvider);
  return ParentViewRepositoryImpl(remoteSource);
});
