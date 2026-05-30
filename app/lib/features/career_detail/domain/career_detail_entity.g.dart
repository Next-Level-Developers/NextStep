// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career_detail_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RelatedCareerImpl _$$RelatedCareerImplFromJson(Map<String, dynamic> json) =>
    _$RelatedCareerImpl(
      slug: json['slug'] as String,
      name: json['name'] as String,
      oneLiner: json['one_liner'] as String?,
      futureScore: (json['future_score'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RelatedCareerImplToJson(_$RelatedCareerImpl instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'one_liner': instance.oneLiner,
      'future_score': instance.futureScore,
    };

_$CareerDetailEntityImpl _$$CareerDetailEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$CareerDetailEntityImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      oneLiner: json['one_liner'] as String?,
      domain: json['domain'] == null
          ? null
          : CareerDomainBrief.fromJson(json['domain'] as Map<String, dynamic>),
      dimensionTags: (json['dimension_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      indiaViability: json['india_viability'] as String?,
      futureScore: (json['future_score'] as num?)?.toInt() ?? 0,
      futureScoreReasoning: json['future_score_reasoning'] as String?,
      typicalDay: json['typical_day'] as String?,
      skillsNeeded: (json['skills_needed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      entryPaths: (json['entry_paths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      salaryEntryLpa: json['salary_entry_lpa'] as String?,
      salaryMidLpa: json['salary_mid_lpa'] as String?,
      salarySeniorLpa: json['salary_senior_lpa'] as String?,
      isEmerging: json['is_emerging'] as bool? ?? false,
      lastReviewedAt: json['last_reviewed_at'] as String?,
      relatedCareers: (json['related_careers'] as List<dynamic>?)
              ?.map((e) => RelatedCareer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isSaved: json['is_saved'] as bool? ?? false,
      userMatchScore: (json['user_match_score'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CareerDetailEntityImplToJson(
        _$CareerDetailEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'one_liner': instance.oneLiner,
      'domain': instance.domain,
      'dimension_tags': instance.dimensionTags,
      'india_viability': instance.indiaViability,
      'future_score': instance.futureScore,
      'future_score_reasoning': instance.futureScoreReasoning,
      'typical_day': instance.typicalDay,
      'skills_needed': instance.skillsNeeded,
      'entry_paths': instance.entryPaths,
      'salary_entry_lpa': instance.salaryEntryLpa,
      'salary_mid_lpa': instance.salaryMidLpa,
      'salary_senior_lpa': instance.salarySeniorLpa,
      'is_emerging': instance.isEmerging,
      'last_reviewed_at': instance.lastReviewedAt,
      'related_careers': instance.relatedCareers,
      'is_saved': instance.isSaved,
      'user_match_score': instance.userMatchScore,
    };
