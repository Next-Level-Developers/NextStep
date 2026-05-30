// lib/features/roadmap/domain/roadmap_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'roadmap_entity.freezed.dart';
part 'roadmap_entity.g.dart';

@freezed
class RoadmapCareerBrief with _$RoadmapCareerBrief {
  const factory RoadmapCareerBrief({
    required String slug,
    required String name,
    @JsonKey(name: 'domain_short_name') String? domainShortName,
  }) = _RoadmapCareerBrief;

  factory RoadmapCareerBrief.fromJson(Map<String, dynamic> json) =>
      _$RoadmapCareerBriefFromJson(json);
}

@freezed
class RoadmapStep with _$RoadmapStep {
  const factory RoadmapStep({
    required String id,
    @JsonKey(name: 'step_order') @Default(0) int stepOrder,
    @Default('') String category,
    @Default('') String title,
    @Default('') String description,
    String? timeframe,
    @JsonKey(name: 'resource_url') String? resourceUrl,
    @JsonKey(name: 'resource_label') String? resourceLabel,
    @JsonKey(name: 'is_premium') @Default(false) bool isPremium,
    @Default('not_started') String status,
    @JsonKey(name: 'completed_at') String? completedAt,
  }) = _RoadmapStep;

  factory RoadmapStep.fromJson(Map<String, dynamic> json) =>
      _$RoadmapStepFromJson(json);
}

@freezed
class RoadmapListItem with _$RoadmapListItem {
  const factory RoadmapListItem({
    required String id,
    required RoadmapCareerBrief career,
    @JsonKey(name: 'academic_stage') String? academicStage,
    @JsonKey(name: 'generation_method') String? generationMethod,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'total_steps') @Default(0) int totalSteps,
    @JsonKey(name: 'completed_steps') @Default(0) int completedSteps,
    @JsonKey(name: 'completion_percent') @Default(0) int completionPercent,
    @JsonKey(name: 'generated_at') String? generatedAt,
  }) = _RoadmapListItem;

  factory RoadmapListItem.fromJson(Map<String, dynamic> json) =>
      _$RoadmapListItemFromJson(json);
}

@freezed
class RoadmapDetail with _$RoadmapDetail {
  const factory RoadmapDetail({
    required String id,
    required RoadmapCareerBrief career,
    @JsonKey(name: 'academic_stage') String? academicStage,
    @JsonKey(name: 'generation_method') String? generationMethod,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'generated_at') String? generatedAt,
    @Default([]) List<RoadmapStep> steps,
  }) = _RoadmapDetail;

  factory RoadmapDetail.fromJson(Map<String, dynamic> json) =>
      _$RoadmapDetailFromJson(json);
}

@freezed
class NextStepBrief with _$NextStepBrief {
  const factory NextStepBrief({
    required String id,
    required String title,
    required String category,
    String? timeframe,
  }) = _NextStepBrief;

  factory NextStepBrief.fromJson(Map<String, dynamic> json) =>
      _$NextStepBriefFromJson(json);
}

@freezed
class ProgressRoadmapSummaryItem with _$ProgressRoadmapSummaryItem {
  const factory ProgressRoadmapSummaryItem({
    required String id,
    @JsonKey(name: 'career_name') String? careerName,
    @JsonKey(name: 'total_steps') @Default(0) int totalSteps,
    @JsonKey(name: 'completed_steps') @Default(0) int completedSteps,
    @JsonKey(name: 'completion_percent') @Default(0) int completionPercent,
    @JsonKey(name: 'next_step') NextStepBrief? nextStep,
  }) = _ProgressRoadmapSummaryItem;

  factory ProgressRoadmapSummaryItem.fromJson(Map<String, dynamic> json) =>
      _$ProgressRoadmapSummaryItemFromJson(json);
}

@freezed
class ProgressSummary with _$ProgressSummary {
  const factory ProgressSummary({
    @JsonKey(name: 'active_roadmaps') @Default(0) int activeRoadmaps,
    @JsonKey(name: 'total_steps_across_all') @Default(0) int totalStepsAcrossAll,
    @JsonKey(name: 'completed_steps') @Default(0) int completedSteps,
    @JsonKey(name: 'overall_completion_percent') @Default(0) int overallCompletionPercent,
    @Default([]) List<ProgressRoadmapSummaryItem> roadmaps,
  }) = _ProgressSummary;

  factory ProgressSummary.fromJson(Map<String, dynamic> json) =>
      _$ProgressSummaryFromJson(json);
}
