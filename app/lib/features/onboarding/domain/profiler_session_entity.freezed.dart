// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profiler_session_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfilerSessionEntity _$ProfilerSessionEntityFromJson(
    Map<String, dynamic> json) {
  return _ProfilerSessionEntity.fromJson(json);
}

/// @nodoc
mixin _$ProfilerSessionEntity {
  @JsonKey(name: 'session_id')
  String get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_number')
  int get sessionNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_questions')
  int get totalQuestions => throw _privateConstructorUsedError;
  @JsonKey(name: 'questions_answered')
  int get questionsAnswered => throw _privateConstructorUsedError;
  @JsonKey(name: 'questions_skipped')
  int get questionsSkipped => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_answered_code')
  String? get lastAnsweredCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  String get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  String? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_taken_seconds')
  int? get timeTakenSeconds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfilerSessionEntityCopyWith<ProfilerSessionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfilerSessionEntityCopyWith<$Res> {
  factory $ProfilerSessionEntityCopyWith(ProfilerSessionEntity value,
          $Res Function(ProfilerSessionEntity) then) =
      _$ProfilerSessionEntityCopyWithImpl<$Res, ProfilerSessionEntity>;
  @useResult
  $Res call(
      {@JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'session_number') int sessionNumber,
      String status,
      @JsonKey(name: 'total_questions') int totalQuestions,
      @JsonKey(name: 'questions_answered') int questionsAnswered,
      @JsonKey(name: 'questions_skipped') int questionsSkipped,
      @JsonKey(name: 'last_answered_code') String? lastAnsweredCode,
      @JsonKey(name: 'started_at') String startedAt,
      @JsonKey(name: 'completed_at') String? completedAt,
      @JsonKey(name: 'time_taken_seconds') int? timeTakenSeconds});
}

/// @nodoc
class _$ProfilerSessionEntityCopyWithImpl<$Res,
        $Val extends ProfilerSessionEntity>
    implements $ProfilerSessionEntityCopyWith<$Res> {
  _$ProfilerSessionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionNumber = null,
    Object? status = null,
    Object? totalQuestions = null,
    Object? questionsAnswered = null,
    Object? questionsSkipped = null,
    Object? lastAnsweredCode = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? timeTakenSeconds = freezed,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionNumber: null == sessionNumber
          ? _value.sessionNumber
          : sessionNumber // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      questionsAnswered: null == questionsAnswered
          ? _value.questionsAnswered
          : questionsAnswered // ignore: cast_nullable_to_non_nullable
              as int,
      questionsSkipped: null == questionsSkipped
          ? _value.questionsSkipped
          : questionsSkipped // ignore: cast_nullable_to_non_nullable
              as int,
      lastAnsweredCode: freezed == lastAnsweredCode
          ? _value.lastAnsweredCode
          : lastAnsweredCode // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      timeTakenSeconds: freezed == timeTakenSeconds
          ? _value.timeTakenSeconds
          : timeTakenSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfilerSessionEntityImplCopyWith<$Res>
    implements $ProfilerSessionEntityCopyWith<$Res> {
  factory _$$ProfilerSessionEntityImplCopyWith(
          _$ProfilerSessionEntityImpl value,
          $Res Function(_$ProfilerSessionEntityImpl) then) =
      __$$ProfilerSessionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'session_number') int sessionNumber,
      String status,
      @JsonKey(name: 'total_questions') int totalQuestions,
      @JsonKey(name: 'questions_answered') int questionsAnswered,
      @JsonKey(name: 'questions_skipped') int questionsSkipped,
      @JsonKey(name: 'last_answered_code') String? lastAnsweredCode,
      @JsonKey(name: 'started_at') String startedAt,
      @JsonKey(name: 'completed_at') String? completedAt,
      @JsonKey(name: 'time_taken_seconds') int? timeTakenSeconds});
}

/// @nodoc
class __$$ProfilerSessionEntityImplCopyWithImpl<$Res>
    extends _$ProfilerSessionEntityCopyWithImpl<$Res,
        _$ProfilerSessionEntityImpl>
    implements _$$ProfilerSessionEntityImplCopyWith<$Res> {
  __$$ProfilerSessionEntityImplCopyWithImpl(_$ProfilerSessionEntityImpl _value,
      $Res Function(_$ProfilerSessionEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionNumber = null,
    Object? status = null,
    Object? totalQuestions = null,
    Object? questionsAnswered = null,
    Object? questionsSkipped = null,
    Object? lastAnsweredCode = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? timeTakenSeconds = freezed,
  }) {
    return _then(_$ProfilerSessionEntityImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionNumber: null == sessionNumber
          ? _value.sessionNumber
          : sessionNumber // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      questionsAnswered: null == questionsAnswered
          ? _value.questionsAnswered
          : questionsAnswered // ignore: cast_nullable_to_non_nullable
              as int,
      questionsSkipped: null == questionsSkipped
          ? _value.questionsSkipped
          : questionsSkipped // ignore: cast_nullable_to_non_nullable
              as int,
      lastAnsweredCode: freezed == lastAnsweredCode
          ? _value.lastAnsweredCode
          : lastAnsweredCode // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      timeTakenSeconds: freezed == timeTakenSeconds
          ? _value.timeTakenSeconds
          : timeTakenSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfilerSessionEntityImpl implements _ProfilerSessionEntity {
  const _$ProfilerSessionEntityImpl(
      {@JsonKey(name: 'session_id') required this.sessionId,
      @JsonKey(name: 'session_number') required this.sessionNumber,
      required this.status,
      @JsonKey(name: 'total_questions') this.totalQuestions = 27,
      @JsonKey(name: 'questions_answered') this.questionsAnswered = 0,
      @JsonKey(name: 'questions_skipped') this.questionsSkipped = 0,
      @JsonKey(name: 'last_answered_code') this.lastAnsweredCode,
      @JsonKey(name: 'started_at') required this.startedAt,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'time_taken_seconds') this.timeTakenSeconds});

  factory _$ProfilerSessionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfilerSessionEntityImplFromJson(json);

  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  @JsonKey(name: 'session_number')
  final int sessionNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'total_questions')
  final int totalQuestions;
  @override
  @JsonKey(name: 'questions_answered')
  final int questionsAnswered;
  @override
  @JsonKey(name: 'questions_skipped')
  final int questionsSkipped;
  @override
  @JsonKey(name: 'last_answered_code')
  final String? lastAnsweredCode;
  @override
  @JsonKey(name: 'started_at')
  final String startedAt;
  @override
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @override
  @JsonKey(name: 'time_taken_seconds')
  final int? timeTakenSeconds;

  @override
  String toString() {
    return 'ProfilerSessionEntity(sessionId: $sessionId, sessionNumber: $sessionNumber, status: $status, totalQuestions: $totalQuestions, questionsAnswered: $questionsAnswered, questionsSkipped: $questionsSkipped, lastAnsweredCode: $lastAnsweredCode, startedAt: $startedAt, completedAt: $completedAt, timeTakenSeconds: $timeTakenSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfilerSessionEntityImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionNumber, sessionNumber) ||
                other.sessionNumber == sessionNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.questionsAnswered, questionsAnswered) ||
                other.questionsAnswered == questionsAnswered) &&
            (identical(other.questionsSkipped, questionsSkipped) ||
                other.questionsSkipped == questionsSkipped) &&
            (identical(other.lastAnsweredCode, lastAnsweredCode) ||
                other.lastAnsweredCode == lastAnsweredCode) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.timeTakenSeconds, timeTakenSeconds) ||
                other.timeTakenSeconds == timeTakenSeconds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      sessionNumber,
      status,
      totalQuestions,
      questionsAnswered,
      questionsSkipped,
      lastAnsweredCode,
      startedAt,
      completedAt,
      timeTakenSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfilerSessionEntityImplCopyWith<_$ProfilerSessionEntityImpl>
      get copyWith => __$$ProfilerSessionEntityImplCopyWithImpl<
          _$ProfilerSessionEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfilerSessionEntityImplToJson(
      this,
    );
  }
}

abstract class _ProfilerSessionEntity implements ProfilerSessionEntity {
  const factory _ProfilerSessionEntity(
          {@JsonKey(name: 'session_id') required final String sessionId,
          @JsonKey(name: 'session_number') required final int sessionNumber,
          required final String status,
          @JsonKey(name: 'total_questions') final int totalQuestions,
          @JsonKey(name: 'questions_answered') final int questionsAnswered,
          @JsonKey(name: 'questions_skipped') final int questionsSkipped,
          @JsonKey(name: 'last_answered_code') final String? lastAnsweredCode,
          @JsonKey(name: 'started_at') required final String startedAt,
          @JsonKey(name: 'completed_at') final String? completedAt,
          @JsonKey(name: 'time_taken_seconds') final int? timeTakenSeconds}) =
      _$ProfilerSessionEntityImpl;

  factory _ProfilerSessionEntity.fromJson(Map<String, dynamic> json) =
      _$ProfilerSessionEntityImpl.fromJson;

  @override
  @JsonKey(name: 'session_id')
  String get sessionId;
  @override
  @JsonKey(name: 'session_number')
  int get sessionNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'total_questions')
  int get totalQuestions;
  @override
  @JsonKey(name: 'questions_answered')
  int get questionsAnswered;
  @override
  @JsonKey(name: 'questions_skipped')
  int get questionsSkipped;
  @override
  @JsonKey(name: 'last_answered_code')
  String? get lastAnsweredCode;
  @override
  @JsonKey(name: 'started_at')
  String get startedAt;
  @override
  @JsonKey(name: 'completed_at')
  String? get completedAt;
  @override
  @JsonKey(name: 'time_taken_seconds')
  int? get timeTakenSeconds;
  @override
  @JsonKey(ignore: true)
  _$$ProfilerSessionEntityImplCopyWith<_$ProfilerSessionEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
