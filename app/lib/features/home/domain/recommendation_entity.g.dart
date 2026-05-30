// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendedCareerBriefImpl _$$RecommendedCareerBriefImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendedCareerBriefImpl(
      slug: json['slug'] as String,
      name: json['name'] as String,
      oneLiner: json['one_liner'] as String?,
      dimensionTags: (json['dimension_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      domainShortName: json['domain_short_name'] as String?,
      futureScore: (json['future_score'] as num?)?.toInt() ?? 0,
      indiaViability: json['india_viability'] as String?,
      salaryEntryLpa: json['salary_entry_lpa'] as String?,
      isEmerging: json['is_emerging'] as bool? ?? false,
    );

Map<String, dynamic> _$$RecommendedCareerBriefImplToJson(
        _$RecommendedCareerBriefImpl instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'one_liner': instance.oneLiner,
      'dimension_tags': instance.dimensionTags,
      'domain_short_name': instance.domainShortName,
      'future_score': instance.futureScore,
      'india_viability': instance.indiaViability,
      'salary_entry_lpa': instance.salaryEntryLpa,
      'is_emerging': instance.isEmerging,
    };

_$RecommendationItemImpl _$$RecommendationItemImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationItemImpl(
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      matchScore: (json['match_score'] as num?)?.toInt() ?? 0,
      matchTier: json['match_tier'] as String?,
      tagOverlapCount: (json['tag_overlap_count'] as num?)?.toInt() ?? 0,
      isNovel: json['is_novel'] as bool? ?? false,
      career: RecommendedCareerBrief.fromJson(
          json['career'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RecommendationItemImplToJson(
        _$RecommendationItemImpl instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'match_score': instance.matchScore,
      'match_tier': instance.matchTier,
      'tag_overlap_count': instance.tagOverlapCount,
      'is_novel': instance.isNovel,
      'career': instance.career,
    };

_$RecommendationsResponseImpl _$$RecommendationsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationsResponseImpl(
      interestProfileId: json['interest_profile_id'] as String?,
      generatedAt: json['generated_at'] as String?,
      totalMatches: (json['total_matches'] as num?)?.toInt() ?? 0,
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map(
                  (e) => RecommendationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RecommendationsResponseImplToJson(
        _$RecommendationsResponseImpl instance) =>
    <String, dynamic>{
      'interest_profile_id': instance.interestProfileId,
      'generated_at': instance.generatedAt,
      'total_matches': instance.totalMatches,
      'recommendations': instance.recommendations,
    };

_$SavedCareerItemImpl _$$SavedCareerItemImplFromJson(
        Map<String, dynamic> json) =>
    _$SavedCareerItemImpl(
      saveId: json['save_id'] as String,
      savedAt: json['saved_at'] as String?,
      notes: json['notes'] as String?,
      career: RecommendedCareerBrief.fromJson(
          json['career'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SavedCareerItemImplToJson(
        _$SavedCareerItemImpl instance) =>
    <String, dynamic>{
      'save_id': instance.saveId,
      'saved_at': instance.savedAt,
      'notes': instance.notes,
      'career': instance.career,
    };
