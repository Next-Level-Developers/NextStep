// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profiler_session_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfilerSessionEntityImpl _$$ProfilerSessionEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfilerSessionEntityImpl(
      sessionId: json['session_id'] as String,
      sessionNumber: (json['session_number'] as num).toInt(),
      status: json['status'] as String,
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 27,
      questionsAnswered: (json['questions_answered'] as num?)?.toInt() ?? 0,
      questionsSkipped: (json['questions_skipped'] as num?)?.toInt() ?? 0,
      lastAnsweredCode: json['last_answered_code'] as String?,
      startedAt: json['started_at'] as String,
      completedAt: json['completed_at'] as String?,
      timeTakenSeconds: (json['time_taken_seconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProfilerSessionEntityImplToJson(
        _$ProfilerSessionEntityImpl instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'session_number': instance.sessionNumber,
      'status': instance.status,
      'total_questions': instance.totalQuestions,
      'questions_answered': instance.questionsAnswered,
      'questions_skipped': instance.questionsSkipped,
      'last_answered_code': instance.lastAnsweredCode,
      'started_at': instance.startedAt,
      'completed_at': instance.completedAt,
      'time_taken_seconds': instance.timeTakenSeconds,
    };
