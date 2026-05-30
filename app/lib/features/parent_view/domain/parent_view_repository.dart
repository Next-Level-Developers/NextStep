import 'parent_profile_entity.dart';

abstract class ParentViewRepository {
  /// Fetch parent view data using a share token (no auth required).
  Future<ParentProfileEntity> getSharedProfile(String shareToken);

  /// Generate a share token for the current student's profile.
  /// Returns the share token to be used in deep links.
  Future<String> generateShareToken();
}
