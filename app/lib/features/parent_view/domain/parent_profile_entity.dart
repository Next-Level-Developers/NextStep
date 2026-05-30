import 'package:freezed_annotation/freezed_annotation.dart';
import '../../explore/domain/career_entity.dart';

part 'parent_profile_entity.freezed.dart';
part 'parent_profile_entity.g.dart';

@freezed
class SharedCareer with _$SharedCareer {
  const factory SharedCareer({
    required String slug,
    required String name,
    @JsonKey(name: 'one_liner') String? oneLiner,
    @JsonKey(name: 'future_score') @Default(0) int futureScore,
    @JsonKey(name: 'india_viability') String? indiaViability,
    @JsonKey(name: 'user_match_score') int? userMatchScore,
  }) = _SharedCareer;

  factory SharedCareer.fromJson(Map<String, dynamic> json) =>
      _$SharedCareerFromJson(json);
}

@freezed
class ParentProfileEntity with _$ParentProfileEntity {
  const factory ParentProfileEntity({
    required String studentName,
    @JsonKey(name: 'academic_stage') String? academicStage,
    @JsonKey(name: 'interest_profile') Map<String, dynamic>? interestProfile,
    @JsonKey(name: 'top_careers') @Default([]) List<SharedCareer> topCareers,
    @JsonKey(name: 'saved_careers') @Default([]) List<SharedCareer> savedCareers,
    @JsonKey(name: 'active_roadmap_count') @Default(0) int activeRoadmapCount,
    @JsonKey(name: 'profiler_completed_at') String? profilerCompletedAt,
    @JsonKey(name: 'last_updated_at') String? lastUpdatedAt,
  }) = _ParentProfileEntity;

  factory ParentProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$ParentProfileEntityFromJson(json);
}
