// lib/features/auth/domain/user_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class StudentProfileEntity with _$StudentProfileEntity {
  const factory StudentProfileEntity({
    @JsonKey(name: 'academic_stage') required String academicStage,
    @JsonKey(name: 'grade_or_year') String? gradeOrYear,
    @JsonKey(name: 'school_name') String? schoolName,
    String? city,
    String? state,
    @JsonKey(name: 'career_clarity') String? careerClarity,
    @JsonKey(name: 'pressure_level') String? pressureLevel,
    @JsonKey(name: 'career_awareness_level') String? careerAwarenessLevel,
    @JsonKey(name: 'profiler_completed') @Default(false) bool profilerCompleted,
    @JsonKey(name: 'profiler_completed_at') String? profilerCompletedAt,
  }) = _StudentProfileEntity;

  factory StudentProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileEntityFromJson(json);
}

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'user_type') required String userType,
    @JsonKey(name: 'subscription_tier') required String subscriptionTier,
    @JsonKey(name: 'parental_consent_given') @Default(false) bool parentalConsentGiven,
    @JsonKey(name: 'student_profile') StudentProfileEntity? studentProfile,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
