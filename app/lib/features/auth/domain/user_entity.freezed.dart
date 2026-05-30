// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StudentProfileEntity _$StudentProfileEntityFromJson(Map<String, dynamic> json) {
  return _StudentProfileEntity.fromJson(json);
}

/// @nodoc
mixin _$StudentProfileEntity {
  @JsonKey(name: 'academic_stage')
  String get academicStage => throw _privateConstructorUsedError;
  @JsonKey(name: 'grade_or_year')
  String? get gradeOrYear => throw _privateConstructorUsedError;
  @JsonKey(name: 'school_name')
  String? get schoolName => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'career_clarity')
  String? get careerClarity => throw _privateConstructorUsedError;
  @JsonKey(name: 'pressure_level')
  String? get pressureLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'career_awareness_level')
  String? get careerAwarenessLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'profiler_completed')
  bool get profilerCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'profiler_completed_at')
  String? get profilerCompletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StudentProfileEntityCopyWith<StudentProfileEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProfileEntityCopyWith<$Res> {
  factory $StudentProfileEntityCopyWith(StudentProfileEntity value,
          $Res Function(StudentProfileEntity) then) =
      _$StudentProfileEntityCopyWithImpl<$Res, StudentProfileEntity>;
  @useResult
  $Res call(
      {@JsonKey(name: 'academic_stage') String academicStage,
      @JsonKey(name: 'grade_or_year') String? gradeOrYear,
      @JsonKey(name: 'school_name') String? schoolName,
      String? city,
      String? state,
      @JsonKey(name: 'career_clarity') String? careerClarity,
      @JsonKey(name: 'pressure_level') String? pressureLevel,
      @JsonKey(name: 'career_awareness_level') String? careerAwarenessLevel,
      @JsonKey(name: 'profiler_completed') bool profilerCompleted,
      @JsonKey(name: 'profiler_completed_at') String? profilerCompletedAt});
}

/// @nodoc
class _$StudentProfileEntityCopyWithImpl<$Res,
        $Val extends StudentProfileEntity>
    implements $StudentProfileEntityCopyWith<$Res> {
  _$StudentProfileEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? academicStage = null,
    Object? gradeOrYear = freezed,
    Object? schoolName = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? careerClarity = freezed,
    Object? pressureLevel = freezed,
    Object? careerAwarenessLevel = freezed,
    Object? profilerCompleted = null,
    Object? profilerCompletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      academicStage: null == academicStage
          ? _value.academicStage
          : academicStage // ignore: cast_nullable_to_non_nullable
              as String,
      gradeOrYear: freezed == gradeOrYear
          ? _value.gradeOrYear
          : gradeOrYear // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolName: freezed == schoolName
          ? _value.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      careerClarity: freezed == careerClarity
          ? _value.careerClarity
          : careerClarity // ignore: cast_nullable_to_non_nullable
              as String?,
      pressureLevel: freezed == pressureLevel
          ? _value.pressureLevel
          : pressureLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      careerAwarenessLevel: freezed == careerAwarenessLevel
          ? _value.careerAwarenessLevel
          : careerAwarenessLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      profilerCompleted: null == profilerCompleted
          ? _value.profilerCompleted
          : profilerCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      profilerCompletedAt: freezed == profilerCompletedAt
          ? _value.profilerCompletedAt
          : profilerCompletedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudentProfileEntityImplCopyWith<$Res>
    implements $StudentProfileEntityCopyWith<$Res> {
  factory _$$StudentProfileEntityImplCopyWith(_$StudentProfileEntityImpl value,
          $Res Function(_$StudentProfileEntityImpl) then) =
      __$$StudentProfileEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'academic_stage') String academicStage,
      @JsonKey(name: 'grade_or_year') String? gradeOrYear,
      @JsonKey(name: 'school_name') String? schoolName,
      String? city,
      String? state,
      @JsonKey(name: 'career_clarity') String? careerClarity,
      @JsonKey(name: 'pressure_level') String? pressureLevel,
      @JsonKey(name: 'career_awareness_level') String? careerAwarenessLevel,
      @JsonKey(name: 'profiler_completed') bool profilerCompleted,
      @JsonKey(name: 'profiler_completed_at') String? profilerCompletedAt});
}

/// @nodoc
class __$$StudentProfileEntityImplCopyWithImpl<$Res>
    extends _$StudentProfileEntityCopyWithImpl<$Res, _$StudentProfileEntityImpl>
    implements _$$StudentProfileEntityImplCopyWith<$Res> {
  __$$StudentProfileEntityImplCopyWithImpl(_$StudentProfileEntityImpl _value,
      $Res Function(_$StudentProfileEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? academicStage = null,
    Object? gradeOrYear = freezed,
    Object? schoolName = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? careerClarity = freezed,
    Object? pressureLevel = freezed,
    Object? careerAwarenessLevel = freezed,
    Object? profilerCompleted = null,
    Object? profilerCompletedAt = freezed,
  }) {
    return _then(_$StudentProfileEntityImpl(
      academicStage: null == academicStage
          ? _value.academicStage
          : academicStage // ignore: cast_nullable_to_non_nullable
              as String,
      gradeOrYear: freezed == gradeOrYear
          ? _value.gradeOrYear
          : gradeOrYear // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolName: freezed == schoolName
          ? _value.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      careerClarity: freezed == careerClarity
          ? _value.careerClarity
          : careerClarity // ignore: cast_nullable_to_non_nullable
              as String?,
      pressureLevel: freezed == pressureLevel
          ? _value.pressureLevel
          : pressureLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      careerAwarenessLevel: freezed == careerAwarenessLevel
          ? _value.careerAwarenessLevel
          : careerAwarenessLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      profilerCompleted: null == profilerCompleted
          ? _value.profilerCompleted
          : profilerCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      profilerCompletedAt: freezed == profilerCompletedAt
          ? _value.profilerCompletedAt
          : profilerCompletedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentProfileEntityImpl implements _StudentProfileEntity {
  const _$StudentProfileEntityImpl(
      {@JsonKey(name: 'academic_stage') required this.academicStage,
      @JsonKey(name: 'grade_or_year') this.gradeOrYear,
      @JsonKey(name: 'school_name') this.schoolName,
      this.city,
      this.state,
      @JsonKey(name: 'career_clarity') this.careerClarity,
      @JsonKey(name: 'pressure_level') this.pressureLevel,
      @JsonKey(name: 'career_awareness_level') this.careerAwarenessLevel,
      @JsonKey(name: 'profiler_completed') this.profilerCompleted = false,
      @JsonKey(name: 'profiler_completed_at') this.profilerCompletedAt});

  factory _$StudentProfileEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentProfileEntityImplFromJson(json);

  @override
  @JsonKey(name: 'academic_stage')
  final String academicStage;
  @override
  @JsonKey(name: 'grade_or_year')
  final String? gradeOrYear;
  @override
  @JsonKey(name: 'school_name')
  final String? schoolName;
  @override
  final String? city;
  @override
  final String? state;
  @override
  @JsonKey(name: 'career_clarity')
  final String? careerClarity;
  @override
  @JsonKey(name: 'pressure_level')
  final String? pressureLevel;
  @override
  @JsonKey(name: 'career_awareness_level')
  final String? careerAwarenessLevel;
  @override
  @JsonKey(name: 'profiler_completed')
  final bool profilerCompleted;
  @override
  @JsonKey(name: 'profiler_completed_at')
  final String? profilerCompletedAt;

  @override
  String toString() {
    return 'StudentProfileEntity(academicStage: $academicStage, gradeOrYear: $gradeOrYear, schoolName: $schoolName, city: $city, state: $state, careerClarity: $careerClarity, pressureLevel: $pressureLevel, careerAwarenessLevel: $careerAwarenessLevel, profilerCompleted: $profilerCompleted, profilerCompletedAt: $profilerCompletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProfileEntityImpl &&
            (identical(other.academicStage, academicStage) ||
                other.academicStage == academicStage) &&
            (identical(other.gradeOrYear, gradeOrYear) ||
                other.gradeOrYear == gradeOrYear) &&
            (identical(other.schoolName, schoolName) ||
                other.schoolName == schoolName) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.careerClarity, careerClarity) ||
                other.careerClarity == careerClarity) &&
            (identical(other.pressureLevel, pressureLevel) ||
                other.pressureLevel == pressureLevel) &&
            (identical(other.careerAwarenessLevel, careerAwarenessLevel) ||
                other.careerAwarenessLevel == careerAwarenessLevel) &&
            (identical(other.profilerCompleted, profilerCompleted) ||
                other.profilerCompleted == profilerCompleted) &&
            (identical(other.profilerCompletedAt, profilerCompletedAt) ||
                other.profilerCompletedAt == profilerCompletedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      academicStage,
      gradeOrYear,
      schoolName,
      city,
      state,
      careerClarity,
      pressureLevel,
      careerAwarenessLevel,
      profilerCompleted,
      profilerCompletedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProfileEntityImplCopyWith<_$StudentProfileEntityImpl>
      get copyWith =>
          __$$StudentProfileEntityImplCopyWithImpl<_$StudentProfileEntityImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentProfileEntityImplToJson(
      this,
    );
  }
}

abstract class _StudentProfileEntity implements StudentProfileEntity {
  const factory _StudentProfileEntity(
      {@JsonKey(name: 'academic_stage') required final String academicStage,
      @JsonKey(name: 'grade_or_year') final String? gradeOrYear,
      @JsonKey(name: 'school_name') final String? schoolName,
      final String? city,
      final String? state,
      @JsonKey(name: 'career_clarity') final String? careerClarity,
      @JsonKey(name: 'pressure_level') final String? pressureLevel,
      @JsonKey(name: 'career_awareness_level')
      final String? careerAwarenessLevel,
      @JsonKey(name: 'profiler_completed') final bool profilerCompleted,
      @JsonKey(name: 'profiler_completed_at')
      final String? profilerCompletedAt}) = _$StudentProfileEntityImpl;

  factory _StudentProfileEntity.fromJson(Map<String, dynamic> json) =
      _$StudentProfileEntityImpl.fromJson;

  @override
  @JsonKey(name: 'academic_stage')
  String get academicStage;
  @override
  @JsonKey(name: 'grade_or_year')
  String? get gradeOrYear;
  @override
  @JsonKey(name: 'school_name')
  String? get schoolName;
  @override
  String? get city;
  @override
  String? get state;
  @override
  @JsonKey(name: 'career_clarity')
  String? get careerClarity;
  @override
  @JsonKey(name: 'pressure_level')
  String? get pressureLevel;
  @override
  @JsonKey(name: 'career_awareness_level')
  String? get careerAwarenessLevel;
  @override
  @JsonKey(name: 'profiler_completed')
  bool get profilerCompleted;
  @override
  @JsonKey(name: 'profiler_completed_at')
  String? get profilerCompletedAt;
  @override
  @JsonKey(ignore: true)
  _$$StudentProfileEntityImplCopyWith<_$StudentProfileEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return _UserEntity.fromJson(json);
}

/// @nodoc
mixin _$UserEntity {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_type')
  String get userType => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_tier')
  String get subscriptionTier => throw _privateConstructorUsedError;
  @JsonKey(name: 'parental_consent_given')
  bool get parentalConsentGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_profile')
  StudentProfileEntity? get studentProfile =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserEntityCopyWith<UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
          UserEntity value, $Res Function(UserEntity) then) =
      _$UserEntityCopyWithImpl<$Res, UserEntity>;
  @useResult
  $Res call(
      {String id,
      String email,
      @JsonKey(name: 'full_name') String? fullName,
      String? phone,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'user_type') String userType,
      @JsonKey(name: 'subscription_tier') String subscriptionTier,
      @JsonKey(name: 'parental_consent_given') bool parentalConsentGiven,
      @JsonKey(name: 'student_profile') StudentProfileEntity? studentProfile});

  $StudentProfileEntityCopyWith<$Res>? get studentProfile;
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res, $Val extends UserEntity>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? userType = null,
    Object? subscriptionTier = null,
    Object? parentalConsentGiven = null,
    Object? studentProfile = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionTier: null == subscriptionTier
          ? _value.subscriptionTier
          : subscriptionTier // ignore: cast_nullable_to_non_nullable
              as String,
      parentalConsentGiven: null == parentalConsentGiven
          ? _value.parentalConsentGiven
          : parentalConsentGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      studentProfile: freezed == studentProfile
          ? _value.studentProfile
          : studentProfile // ignore: cast_nullable_to_non_nullable
              as StudentProfileEntity?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StudentProfileEntityCopyWith<$Res>? get studentProfile {
    if (_value.studentProfile == null) {
      return null;
    }

    return $StudentProfileEntityCopyWith<$Res>(_value.studentProfile!, (value) {
      return _then(_value.copyWith(studentProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserEntityImplCopyWith<$Res>
    implements $UserEntityCopyWith<$Res> {
  factory _$$UserEntityImplCopyWith(
          _$UserEntityImpl value, $Res Function(_$UserEntityImpl) then) =
      __$$UserEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      @JsonKey(name: 'full_name') String? fullName,
      String? phone,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'user_type') String userType,
      @JsonKey(name: 'subscription_tier') String subscriptionTier,
      @JsonKey(name: 'parental_consent_given') bool parentalConsentGiven,
      @JsonKey(name: 'student_profile') StudentProfileEntity? studentProfile});

  @override
  $StudentProfileEntityCopyWith<$Res>? get studentProfile;
}

/// @nodoc
class __$$UserEntityImplCopyWithImpl<$Res>
    extends _$UserEntityCopyWithImpl<$Res, _$UserEntityImpl>
    implements _$$UserEntityImplCopyWith<$Res> {
  __$$UserEntityImplCopyWithImpl(
      _$UserEntityImpl _value, $Res Function(_$UserEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? userType = null,
    Object? subscriptionTier = null,
    Object? parentalConsentGiven = null,
    Object? studentProfile = freezed,
  }) {
    return _then(_$UserEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionTier: null == subscriptionTier
          ? _value.subscriptionTier
          : subscriptionTier // ignore: cast_nullable_to_non_nullable
              as String,
      parentalConsentGiven: null == parentalConsentGiven
          ? _value.parentalConsentGiven
          : parentalConsentGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      studentProfile: freezed == studentProfile
          ? _value.studentProfile
          : studentProfile // ignore: cast_nullable_to_non_nullable
              as StudentProfileEntity?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserEntityImpl implements _UserEntity {
  const _$UserEntityImpl(
      {required this.id,
      required this.email,
      @JsonKey(name: 'full_name') this.fullName,
      this.phone,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'user_type') required this.userType,
      @JsonKey(name: 'subscription_tier') required this.subscriptionTier,
      @JsonKey(name: 'parental_consent_given')
      this.parentalConsentGiven = false,
      @JsonKey(name: 'student_profile') this.studentProfile});

  factory _$UserEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'user_type')
  final String userType;
  @override
  @JsonKey(name: 'subscription_tier')
  final String subscriptionTier;
  @override
  @JsonKey(name: 'parental_consent_given')
  final bool parentalConsentGiven;
  @override
  @JsonKey(name: 'student_profile')
  final StudentProfileEntity? studentProfile;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, fullName: $fullName, phone: $phone, avatarUrl: $avatarUrl, userType: $userType, subscriptionTier: $subscriptionTier, parentalConsentGiven: $parentalConsentGiven, studentProfile: $studentProfile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.subscriptionTier, subscriptionTier) ||
                other.subscriptionTier == subscriptionTier) &&
            (identical(other.parentalConsentGiven, parentalConsentGiven) ||
                other.parentalConsentGiven == parentalConsentGiven) &&
            (identical(other.studentProfile, studentProfile) ||
                other.studentProfile == studentProfile));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      fullName,
      phone,
      avatarUrl,
      userType,
      subscriptionTier,
      parentalConsentGiven,
      studentProfile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      __$$UserEntityImplCopyWithImpl<_$UserEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserEntityImplToJson(
      this,
    );
  }
}

abstract class _UserEntity implements UserEntity {
  const factory _UserEntity(
      {required final String id,
      required final String email,
      @JsonKey(name: 'full_name') final String? fullName,
      final String? phone,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'user_type') required final String userType,
      @JsonKey(name: 'subscription_tier')
      required final String subscriptionTier,
      @JsonKey(name: 'parental_consent_given') final bool parentalConsentGiven,
      @JsonKey(name: 'student_profile')
      final StudentProfileEntity? studentProfile}) = _$UserEntityImpl;

  factory _UserEntity.fromJson(Map<String, dynamic> json) =
      _$UserEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'user_type')
  String get userType;
  @override
  @JsonKey(name: 'subscription_tier')
  String get subscriptionTier;
  @override
  @JsonKey(name: 'parental_consent_given')
  bool get parentalConsentGiven;
  @override
  @JsonKey(name: 'student_profile')
  StudentProfileEntity? get studentProfile;
  @override
  @JsonKey(ignore: true)
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
