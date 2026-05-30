// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CareerDomainEntityImpl _$$CareerDomainEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$CareerDomainEntityImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      shortName: json['short_name'] as String?,
      indiaRelevance: json['india_relevance'] as String?,
      growthForecast2035: json['growth_forecast_2035'] as String?,
      entryPathSummary: json['entry_path_summary'] as String?,
      careerCount: (json['career_count'] as num?)?.toInt() ?? 0,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CareerDomainEntityImplToJson(
        _$CareerDomainEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'short_name': instance.shortName,
      'india_relevance': instance.indiaRelevance,
      'growth_forecast_2035': instance.growthForecast2035,
      'entry_path_summary': instance.entryPathSummary,
      'career_count': instance.careerCount,
      'display_order': instance.displayOrder,
    };

_$CareerDomainBriefImpl _$$CareerDomainBriefImplFromJson(
        Map<String, dynamic> json) =>
    _$CareerDomainBriefImpl(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String,
      name: json['name'] as String,
      shortName: json['short_name'] as String?,
    );

Map<String, dynamic> _$$CareerDomainBriefImplToJson(
        _$CareerDomainBriefImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'short_name': instance.shortName,
    };

_$CareerListItemImpl _$$CareerListItemImplFromJson(Map<String, dynamic> json) =>
    _$CareerListItemImpl(
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
      isEmerging: json['is_emerging'] as bool? ?? false,
      salaryEntryLpa: json['salary_entry_lpa'] as String?,
      salaryMidLpa: json['salary_mid_lpa'] as String?,
      salarySeniorLpa: json['salary_senior_lpa'] as String?,
    );

Map<String, dynamic> _$$CareerListItemImplToJson(
        _$CareerListItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'one_liner': instance.oneLiner,
      'domain': instance.domain,
      'dimension_tags': instance.dimensionTags,
      'india_viability': instance.indiaViability,
      'future_score': instance.futureScore,
      'is_emerging': instance.isEmerging,
      'salary_entry_lpa': instance.salaryEntryLpa,
      'salary_mid_lpa': instance.salaryMidLpa,
      'salary_senior_lpa': instance.salarySeniorLpa,
    };

_$CareerListResponseImpl _$$CareerListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CareerListResponseImpl(
      count: (json['count'] as num?)?.toInt() ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => CareerListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CareerListResponseImplToJson(
        _$CareerListResponseImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
