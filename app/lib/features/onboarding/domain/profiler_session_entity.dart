// lib/features/onboarding/domain/profiler_session_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profiler_session_entity.freezed.dart';
part 'profiler_session_entity.g.dart';

@freezed
class ProfilerSessionEntity with _$ProfilerSessionEntity {
  const factory ProfilerSessionEntity({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'session_number') required int sessionNumber,
    required String status,
    @JsonKey(name: 'total_questions') @Default(27) int totalQuestions,
    @JsonKey(name: 'questions_answered') @Default(0) int questionsAnswered,
    @JsonKey(name: 'questions_skipped') @Default(0) int questionsSkipped,
    @JsonKey(name: 'last_answered_code') String? lastAnsweredCode,
    @JsonKey(name: 'started_at') required String startedAt,
    @JsonKey(name: 'completed_at') String? completedAt,
    @JsonKey(name: 'time_taken_seconds') int? timeTakenSeconds,
  }) = _ProfilerSessionEntity;

  factory ProfilerSessionEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfilerSessionEntityFromJson(json);
}
