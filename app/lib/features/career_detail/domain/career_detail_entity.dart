// lib/features/career_detail/domain/career_detail_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../explore/domain/career_entity.dart';

part 'career_detail_entity.freezed.dart';
part 'career_detail_entity.g.dart';

@freezed
class RelatedCareer with _$RelatedCareer {
  const factory RelatedCareer({
    required String slug,
    required String name,
    @JsonKey(name: 'one_liner') String? oneLiner,
    @JsonKey(name: 'future_score') @Default(0) int futureScore,
  }) = _RelatedCareer;

  factory RelatedCareer.fromJson(Map<String, dynamic> json) =>
      _$RelatedCareerFromJson(json);
}

@freezed
class RealPeopleStory with _$RealPeopleStory {
  const factory RealPeopleStory({
    required String id,
    required String personName,
    String? personRole,
    String? personImage,
    @JsonKey(name: 'story_text') String? storyText,
    @JsonKey(name: 'career_slug') String? careerSlug,
  }) = _RealPeopleStory;

  factory RealPeopleStory.fromJson(Map<String, dynamic> json) =>
      _$RealPeopleStoryFromJson(json);
}

@freezed
class LearningResource with _$LearningResource {
  const factory LearningResource({
    required String id,
    required String title,
    String? description,
    String? resourceType,  // 'course', 'article', 'video', 'book'
    String? url,
    String? provider,      // 'Coursera', 'YouTube', 'Udemy', etc.
  }) = _LearningResource;

  factory LearningResource.fromJson(Map<String, dynamic> json) =>
      _$LearningResourceFromJson(json);
}

@freezed
class CareerDetailEntity with _$CareerDetailEntity {
  const factory CareerDetailEntity({
    required String id,
    required String slug,
    required String name,
    @JsonKey(name: 'one_liner') String? oneLiner,
    CareerDomainBrief? domain,
    @JsonKey(name: 'dimension_tags') @Default([]) List<String> dimensionTags,
    @JsonKey(name: 'india_viability') String? indiaViability,
    @JsonKey(name: 'future_score') @Default(0) int futureScore,
    @JsonKey(name: 'future_score_reasoning') String? futureScoreReasoning,
    @JsonKey(name: 'typical_day') String? typicalDay,
    @JsonKey(name: 'skills_needed') @Default([]) List<String> skillsNeeded,
    @JsonKey(name: 'entry_paths') @Default([]) List<String> entryPaths,
    @JsonKey(name: 'salary_entry_lpa') String? salaryEntryLpa,
    @JsonKey(name: 'salary_mid_lpa') String? salaryMidLpa,
    @JsonKey(name: 'salary_senior_lpa') String? salarySeniorLpa,
    @JsonKey(name: 'is_emerging') @Default(false) bool isEmerging,
    @JsonKey(name: 'last_reviewed_at') String? lastReviewedAt,
    @JsonKey(name: 'related_careers') @Default([]) List<RelatedCareer> relatedCareers,
    @JsonKey(name: 'real_people_stories') @Default([]) List<RealPeopleStory> realPeopleStories,
    @JsonKey(name: 'learning_resources') @Default([]) List<LearningResource> learningResources,
    @JsonKey(name: 'is_saved') @Default(false) bool isSaved,
    @JsonKey(name: 'user_match_score') int? userMatchScore,
  }) = _CareerDetailEntity;

  factory CareerDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$CareerDetailEntityFromJson(json);
}
