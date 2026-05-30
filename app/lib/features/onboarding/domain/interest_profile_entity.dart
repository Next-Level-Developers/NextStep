// lib/features/onboarding/domain/interest_profile_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'interest_profile_entity.freezed.dart';
part 'interest_profile_entity.g.dart';

@freezed
class InterestProfileEntity with _$InterestProfileEntity {
  const factory InterestProfileEntity({
    required String id,
    @JsonKey(name: 'dimension_scores') required Map<String, int> dimensionScores,
    @JsonKey(name: 'top_dimensions') required List<String> topDimensions,
    @JsonKey(name: 'computed_at') required String computedAt,
  }) = _InterestProfileEntity;

  factory InterestProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$InterestProfileEntityFromJson(json);
}
