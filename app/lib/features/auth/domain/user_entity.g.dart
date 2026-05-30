// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentProfileEntityImpl _$$StudentProfileEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$StudentProfileEntityImpl(
      academicStage: json['academic_stage'] as String,
      gradeOrYear: json['grade_or_year'] as String?,
      schoolName: json['school_name'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      careerClarity: json['career_clarity'] as String?,
      pressureLevel: json['pressure_level'] as String?,
      careerAwarenessLevel: json['career_awareness_level'] as String?,
      profilerCompleted: json['profiler_completed'] as bool? ?? false,
      profilerCompletedAt: json['profiler_completed_at'] as String?,
    );

Map<String, dynamic> _$$StudentProfileEntityImplToJson(
        _$StudentProfileEntityImpl instance) =>
    <String, dynamic>{
      'academic_stage': instance.academicStage,
      'grade_or_year': instance.gradeOrYear,
      'school_name': instance.schoolName,
      'city': instance.city,
      'state': instance.state,
      'career_clarity': instance.careerClarity,
      'pressure_level': instance.pressureLevel,
      'career_awareness_level': instance.careerAwarenessLevel,
      'profiler_completed': instance.profilerCompleted,
      'profiler_completed_at': instance.profilerCompletedAt,
    };

_$UserEntityImpl _$$UserEntityImplFromJson(Map<String, dynamic> json) =>
    _$UserEntityImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      userType: json['user_type'] as String,
      subscriptionTier: json['subscription_tier'] as String,
      parentalConsentGiven: json['parental_consent_given'] as bool? ?? false,
      studentProfile: json['student_profile'] == null
          ? null
          : StudentProfileEntity.fromJson(
              json['student_profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserEntityImplToJson(_$UserEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'user_type': instance.userType,
      'subscription_tier': instance.subscriptionTier,
      'parental_consent_given': instance.parentalConsentGiven,
      'student_profile': instance.studentProfile,
    };
