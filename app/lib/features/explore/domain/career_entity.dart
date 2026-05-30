// lib/features/explore/domain/career_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'career_entity.freezed.dart';
part 'career_entity.g.dart';

@freezed
class CareerDomainEntity with _$CareerDomainEntity {
  const factory CareerDomainEntity({
    required String id,
    required String slug,
    required String name,
    @JsonKey(name: 'short_name') String? shortName,
    @JsonKey(name: 'india_relevance') String? indiaRelevance,
    @JsonKey(name: 'growth_forecast_2035') String? growthForecast2035,
    @JsonKey(name: 'entry_path_summary') String? entryPathSummary,
    @JsonKey(name: 'career_count') @Default(0) int careerCount,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
  }) = _CareerDomainEntity;

  factory CareerDomainEntity.fromJson(Map<String, dynamic> json) =>
      _$CareerDomainEntityFromJson(json);
}

@freezed
class CareerDomainBrief with _$CareerDomainBrief {
  const factory CareerDomainBrief({
    @Default('') String id,
    required String slug,
    required String name,
    @JsonKey(name: 'short_name') String? shortName,
  }) = _CareerDomainBrief;

  factory CareerDomainBrief.fromJson(Map<String, dynamic> json) =>
      _$CareerDomainBriefFromJson(json);
}

@freezed
class CareerListItem with _$CareerListItem {
  const factory CareerListItem({
    required String id,
    required String slug,
    required String name,
    @JsonKey(name: 'one_liner') String? oneLiner,
    CareerDomainBrief? domain,
    @JsonKey(name: 'dimension_tags') @Default([]) List<String> dimensionTags,
    @JsonKey(name: 'india_viability') String? indiaViability,
    @JsonKey(name: 'future_score') @Default(0) int futureScore,
    @JsonKey(name: 'is_emerging') @Default(false) bool isEmerging,
    @JsonKey(name: 'salary_entry_lpa') String? salaryEntryLpa,
    @JsonKey(name: 'salary_mid_lpa') String? salaryMidLpa,
    @JsonKey(name: 'salary_senior_lpa') String? salarySeniorLpa,
  }) = _CareerListItem;

  factory CareerListItem.fromJson(Map<String, dynamic> json) =>
      _$CareerListItemFromJson(json);
}

@freezed
class CareerListResponse with _$CareerListResponse {
  const factory CareerListResponse({
    @Default(0) int count,
    String? next,
    String? previous,
    @Default([]) List<CareerListItem> results,
  }) = _CareerListResponse;

  factory CareerListResponse.fromJson(Map<String, dynamic> json) =>
      _$CareerListResponseFromJson(json);
}
