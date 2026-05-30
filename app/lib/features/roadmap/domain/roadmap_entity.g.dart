// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoadmapCareerBriefImpl _$$RoadmapCareerBriefImplFromJson(
        Map<String, dynamic> json) =>
    _$RoadmapCareerBriefImpl(
      slug: json['slug'] as String,
      name: json['name'] as String,
      domainShortName: json['domain_short_name'] as String?,
    );

Map<String, dynamic> _$$RoadmapCareerBriefImplToJson(
        _$RoadmapCareerBriefImpl instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'domain_short_name': instance.domainShortName,
    };

_$RoadmapStepImpl _$$RoadmapStepImplFromJson(Map<String, dynamic> json) =>
    _$RoadmapStepImpl(
      id: json['id'] as String,
      stepOrder: (json['step_order'] as num?)?.toInt() ?? 0,
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timeframe: json['timeframe'] as String?,
      resourceUrl: json['resource_url'] as String?,
      resourceLabel: json['resource_label'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      status: json['status'] as String? ?? 'not_started',
      completedAt: json['completed_at'] as String?,
    );

Map<String, dynamic> _$$RoadmapStepImplToJson(_$RoadmapStepImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'step_order': instance.stepOrder,
      'category': instance.category,
      'title': instance.title,
      'description': instance.description,
      'timeframe': instance.timeframe,
      'resource_url': instance.resourceUrl,
      'resource_label': instance.resourceLabel,
      'is_premium': instance.isPremium,
      'status': instance.status,
      'completed_at': instance.completedAt,
    };

_$RoadmapListItemImpl _$$RoadmapListItemImplFromJson(
        Map<String, dynamic> json) =>
    _$RoadmapListItemImpl(
      id: json['id'] as String,
      career:
          RoadmapCareerBrief.fromJson(json['career'] as Map<String, dynamic>),
      academicStage: json['academic_stage'] as String?,
      generationMethod: json['generation_method'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      totalSteps: (json['total_steps'] as num?)?.toInt() ?? 0,
      completedSteps: (json['completed_steps'] as num?)?.toInt() ?? 0,
      completionPercent: (json['completion_percent'] as num?)?.toInt() ?? 0,
      generatedAt: json['generated_at'] as String?,
    );

Map<String, dynamic> _$$RoadmapListItemImplToJson(
        _$RoadmapListItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'career': instance.career,
      'academic_stage': instance.academicStage,
      'generation_method': instance.generationMethod,
      'is_active': instance.isActive,
      'total_steps': instance.totalSteps,
      'completed_steps': instance.completedSteps,
      'completion_percent': instance.completionPercent,
      'generated_at': instance.generatedAt,
    };

_$RoadmapDetailImpl _$$RoadmapDetailImplFromJson(Map<String, dynamic> json) =>
    _$RoadmapDetailImpl(
      id: json['id'] as String,
      career:
          RoadmapCareerBrief.fromJson(json['career'] as Map<String, dynamic>),
      academicStage: json['academic_stage'] as String?,
      generationMethod: json['generation_method'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      generatedAt: json['generated_at'] as String?,
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => RoadmapStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RoadmapDetailImplToJson(_$RoadmapDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'career': instance.career,
      'academic_stage': instance.academicStage,
      'generation_method': instance.generationMethod,
      'is_active': instance.isActive,
      'generated_at': instance.generatedAt,
      'steps': instance.steps,
    };

_$NextStepBriefImpl _$$NextStepBriefImplFromJson(Map<String, dynamic> json) =>
    _$NextStepBriefImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      timeframe: json['timeframe'] as String?,
    );

Map<String, dynamic> _$$NextStepBriefImplToJson(_$NextStepBriefImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'timeframe': instance.timeframe,
    };

_$ProgressRoadmapSummaryItemImpl _$$ProgressRoadmapSummaryItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ProgressRoadmapSummaryItemImpl(
      id: json['id'] as String,
      careerName: json['career_name'] as String?,
      totalSteps: (json['total_steps'] as num?)?.toInt() ?? 0,
      completedSteps: (json['completed_steps'] as num?)?.toInt() ?? 0,
      completionPercent: (json['completion_percent'] as num?)?.toInt() ?? 0,
      nextStep: json['next_step'] == null
          ? null
          : NextStepBrief.fromJson(json['next_step'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProgressRoadmapSummaryItemImplToJson(
        _$ProgressRoadmapSummaryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'career_name': instance.careerName,
      'total_steps': instance.totalSteps,
      'completed_steps': instance.completedSteps,
      'completion_percent': instance.completionPercent,
      'next_step': instance.nextStep,
    };

_$ProgressSummaryImpl _$$ProgressSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProgressSummaryImpl(
      activeRoadmaps: (json['active_roadmaps'] as num?)?.toInt() ?? 0,
      totalStepsAcrossAll:
          (json['total_steps_across_all'] as num?)?.toInt() ?? 0,
      completedSteps: (json['completed_steps'] as num?)?.toInt() ?? 0,
      overallCompletionPercent:
          (json['overall_completion_percent'] as num?)?.toInt() ?? 0,
      roadmaps: (json['roadmaps'] as List<dynamic>?)
              ?.map((e) => ProgressRoadmapSummaryItem.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProgressSummaryImplToJson(
        _$ProgressSummaryImpl instance) =>
    <String, dynamic>{
      'active_roadmaps': instance.activeRoadmaps,
      'total_steps_across_all': instance.totalStepsAcrossAll,
      'completed_steps': instance.completedSteps,
      'overall_completion_percent': instance.overallCompletionPercent,
      'roadmaps': instance.roadmaps,
    };
