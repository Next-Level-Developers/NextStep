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

_$RealPeopleStoryImpl _$$RealPeopleStoryImplFromJson(
        Map<String, dynamic> json) =>
    _$RealPeopleStoryImpl(
      id: json['id'] as String,
      personName: json['personName'] as String,
      personRole: json['personRole'] as String?,
      personImage: json['personImage'] as String?,
      storyText: json['story_text'] as String?,
      careerSlug: json['career_slug'] as String?,
    );

Map<String, dynamic> _$$RealPeopleStoryImplToJson(
        _$RealPeopleStoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personName': instance.personName,
      'personRole': instance.personRole,
      'personImage': instance.personImage,
      'story_text': instance.storyText,
      'career_slug': instance.careerSlug,
    };

_$LearningResourceImpl _$$LearningResourceImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningResourceImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      resourceType: json['resourceType'] as String?,
      url: json['url'] as String?,
      provider: json['provider'] as String?,
    );

Map<String, dynamic> _$$LearningResourceImplToJson(
        _$LearningResourceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'resourceType': instance.resourceType,
      'url': instance.url,
      'provider': instance.provider,
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
      realPeopleStories: (json['real_people_stories'] as List<dynamic>?)
              ?.map((e) => RealPeopleStory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      learningResources: (json['learning_resources'] as List<dynamic>?)
              ?.map((e) => LearningResource.fromJson(e as Map<String, dynamic>))
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
      'real_people_stories': instance.realPeopleStories,
      'learning_resources': instance.learningResources,
      'is_saved': instance.isSaved,
      'user_match_score': instance.userMatchScore,
    };
