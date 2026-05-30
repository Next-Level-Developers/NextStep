// lib/features/home/domain/recommendation_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_entity.freezed.dart';
part 'recommendation_entity.g.dart';

@freezed
class RecommendedCareerBrief with _$RecommendedCareerBrief {
  const factory RecommendedCareerBrief({
    required String slug,
    required String name,
    @JsonKey(name: 'one_liner') String? oneLiner,
    @JsonKey(name: 'dimension_tags') @Default([]) List<String> dimensionTags,
    @JsonKey(name: 'domain_short_name') String? domainShortName,
    @JsonKey(name: 'future_score') @Default(0) int futureScore,
    @JsonKey(name: 'india_viability') String? indiaViability,
    @JsonKey(name: 'salary_entry_lpa') String? salaryEntryLpa,
    @JsonKey(name: 'is_emerging') @Default(false) bool isEmerging,
  }) = _RecommendedCareerBrief;

  factory RecommendedCareerBrief.fromJson(Map<String, dynamic> json) =>
      _$RecommendedCareerBriefFromJson(json);
}

@freezed
class RecommendationItem with _$RecommendationItem {
  const factory RecommendationItem({
    @Default(0) int rank,
    @JsonKey(name: 'match_score') @Default(0) int matchScore,
    @JsonKey(name: 'match_tier') String? matchTier,
    @JsonKey(name: 'tag_overlap_count') @Default(0) int tagOverlapCount,
    @JsonKey(name: 'is_novel') @Default(false) bool isNovel,
    required RecommendedCareerBrief career,
  }) = _RecommendationItem;

  factory RecommendationItem.fromJson(Map<String, dynamic> json) =>
      _$RecommendationItemFromJson(json);
}

@freezed
class RecommendationsResponse with _$RecommendationsResponse {
  const factory RecommendationsResponse({
    @JsonKey(name: 'interest_profile_id') String? interestProfileId,
    @JsonKey(name: 'generated_at') String? generatedAt,
    @JsonKey(name: 'total_matches') @Default(0) int totalMatches,
    @Default([]) List<RecommendationItem> recommendations,
  }) = _RecommendationsResponse;

  factory RecommendationsResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsResponseFromJson(json);
}

@freezed
class SavedCareerItem with _$SavedCareerItem {
  const factory SavedCareerItem({
    @JsonKey(name: 'save_id') required String saveId,
    @JsonKey(name: 'saved_at') String? savedAt,
    String? notes,
    required RecommendedCareerBrief career,
  }) = _SavedCareerItem;

  factory SavedCareerItem.fromJson(Map<String, dynamic> json) =>
      _$SavedCareerItemFromJson(json);
}
