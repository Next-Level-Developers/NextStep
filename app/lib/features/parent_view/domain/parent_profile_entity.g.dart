// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_profile_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SharedCareerImpl _$$SharedCareerImplFromJson(Map<String, dynamic> json) =>
    _$SharedCareerImpl(
      slug: json['slug'] as String,
      name: json['name'] as String,
      oneLiner: json['one_liner'] as String?,
      futureScore: (json['future_score'] as num?)?.toInt() ?? 0,
      indiaViability: json['india_viability'] as String?,
      userMatchScore: (json['user_match_score'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SharedCareerImplToJson(_$SharedCareerImpl instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'one_liner': instance.oneLiner,
      'future_score': instance.futureScore,
      'india_viability': instance.indiaViability,
      'user_match_score': instance.userMatchScore,
    };

_$ParentProfileEntityImpl _$$ParentProfileEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$ParentProfileEntityImpl(
      studentName: json['studentName'] as String,
      academicStage: json['academic_stage'] as String?,
      interestProfile: json['interest_profile'] as Map<String, dynamic>?,
      topCareers: (json['top_careers'] as List<dynamic>?)
              ?.map((e) => SharedCareer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      savedCareers: (json['saved_careers'] as List<dynamic>?)
              ?.map((e) => SharedCareer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activeRoadmapCount: (json['active_roadmap_count'] as num?)?.toInt() ?? 0,
      profilerCompletedAt: json['profiler_completed_at'] as String?,
      lastUpdatedAt: json['last_updated_at'] as String?,
    );

Map<String, dynamic> _$$ParentProfileEntityImplToJson(
        _$ParentProfileEntityImpl instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'academic_stage': instance.academicStage,
      'interest_profile': instance.interestProfile,
      'top_careers': instance.topCareers,
      'saved_careers': instance.savedCareers,
      'active_roadmap_count': instance.activeRoadmapCount,
      'profiler_completed_at': instance.profilerCompletedAt,
      'last_updated_at': instance.lastUpdatedAt,
    };
