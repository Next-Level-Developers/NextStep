// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parent_profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SharedCareer _$SharedCareerFromJson(Map<String, dynamic> json) {
  return _SharedCareer.fromJson(json);
}

/// @nodoc
mixin _$SharedCareer {
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'one_liner')
  String? get oneLiner => throw _privateConstructorUsedError;
  @JsonKey(name: 'future_score')
  int get futureScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'india_viability')
  String? get indiaViability => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_match_score')
  int? get userMatchScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SharedCareerCopyWith<SharedCareer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedCareerCopyWith<$Res> {
  factory $SharedCareerCopyWith(
          SharedCareer value, $Res Function(SharedCareer) then) =
      _$SharedCareerCopyWithImpl<$Res, SharedCareer>;
  @useResult
  $Res call(
      {String slug,
      String name,
      @JsonKey(name: 'one_liner') String? oneLiner,
      @JsonKey(name: 'future_score') int futureScore,
      @JsonKey(name: 'india_viability') String? indiaViability,
      @JsonKey(name: 'user_match_score') int? userMatchScore});
}

/// @nodoc
class _$SharedCareerCopyWithImpl<$Res, $Val extends SharedCareer>
    implements $SharedCareerCopyWith<$Res> {
  _$SharedCareerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? oneLiner = freezed,
    Object? futureScore = null,
    Object? indiaViability = freezed,
    Object? userMatchScore = freezed,
  }) {
    return _then(_value.copyWith(
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      oneLiner: freezed == oneLiner
          ? _value.oneLiner
          : oneLiner // ignore: cast_nullable_to_non_nullable
              as String?,
      futureScore: null == futureScore
          ? _value.futureScore
          : futureScore // ignore: cast_nullable_to_non_nullable
              as int,
      indiaViability: freezed == indiaViability
          ? _value.indiaViability
          : indiaViability // ignore: cast_nullable_to_non_nullable
              as String?,
      userMatchScore: freezed == userMatchScore
          ? _value.userMatchScore
          : userMatchScore // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedCareerImplCopyWith<$Res>
    implements $SharedCareerCopyWith<$Res> {
  factory _$$SharedCareerImplCopyWith(
          _$SharedCareerImpl value, $Res Function(_$SharedCareerImpl) then) =
      __$$SharedCareerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String slug,
      String name,
      @JsonKey(name: 'one_liner') String? oneLiner,
      @JsonKey(name: 'future_score') int futureScore,
      @JsonKey(name: 'india_viability') String? indiaViability,
      @JsonKey(name: 'user_match_score') int? userMatchScore});
}

/// @nodoc
class __$$SharedCareerImplCopyWithImpl<$Res>
    extends _$SharedCareerCopyWithImpl<$Res, _$SharedCareerImpl>
    implements _$$SharedCareerImplCopyWith<$Res> {
  __$$SharedCareerImplCopyWithImpl(
      _$SharedCareerImpl _value, $Res Function(_$SharedCareerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? oneLiner = freezed,
    Object? futureScore = null,
    Object? indiaViability = freezed,
    Object? userMatchScore = freezed,
  }) {
    return _then(_$SharedCareerImpl(
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      oneLiner: freezed == oneLiner
          ? _value.oneLiner
          : oneLiner // ignore: cast_nullable_to_non_nullable
              as String?,
      futureScore: null == futureScore
          ? _value.futureScore
          : futureScore // ignore: cast_nullable_to_non_nullable
              as int,
      indiaViability: freezed == indiaViability
          ? _value.indiaViability
          : indiaViability // ignore: cast_nullable_to_non_nullable
              as String?,
      userMatchScore: freezed == userMatchScore
          ? _value.userMatchScore
          : userMatchScore // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharedCareerImpl implements _SharedCareer {
  const _$SharedCareerImpl(
      {required this.slug,
      required this.name,
      @JsonKey(name: 'one_liner') this.oneLiner,
      @JsonKey(name: 'future_score') this.futureScore = 0,
      @JsonKey(name: 'india_viability') this.indiaViability,
      @JsonKey(name: 'user_match_score') this.userMatchScore});

  factory _$SharedCareerImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharedCareerImplFromJson(json);

  @override
  final String slug;
  @override
  final String name;
  @override
  @JsonKey(name: 'one_liner')
  final String? oneLiner;
  @override
  @JsonKey(name: 'future_score')
  final int futureScore;
  @override
  @JsonKey(name: 'india_viability')
  final String? indiaViability;
  @override
  @JsonKey(name: 'user_match_score')
  final int? userMatchScore;

  @override
  String toString() {
    return 'SharedCareer(slug: $slug, name: $name, oneLiner: $oneLiner, futureScore: $futureScore, indiaViability: $indiaViability, userMatchScore: $userMatchScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedCareerImpl &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.oneLiner, oneLiner) ||
                other.oneLiner == oneLiner) &&
            (identical(other.futureScore, futureScore) ||
                other.futureScore == futureScore) &&
            (identical(other.indiaViability, indiaViability) ||
                other.indiaViability == indiaViability) &&
            (identical(other.userMatchScore, userMatchScore) ||
                other.userMatchScore == userMatchScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, slug, name, oneLiner,
      futureScore, indiaViability, userMatchScore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedCareerImplCopyWith<_$SharedCareerImpl> get copyWith =>
      __$$SharedCareerImplCopyWithImpl<_$SharedCareerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharedCareerImplToJson(
      this,
    );
  }
}

abstract class _SharedCareer implements SharedCareer {
  const factory _SharedCareer(
          {required final String slug,
          required final String name,
          @JsonKey(name: 'one_liner') final String? oneLiner,
          @JsonKey(name: 'future_score') final int futureScore,
          @JsonKey(name: 'india_viability') final String? indiaViability,
          @JsonKey(name: 'user_match_score') final int? userMatchScore}) =
      _$SharedCareerImpl;

  factory _SharedCareer.fromJson(Map<String, dynamic> json) =
      _$SharedCareerImpl.fromJson;

  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(name: 'one_liner')
  String? get oneLiner;
  @override
  @JsonKey(name: 'future_score')
  int get futureScore;
  @override
  @JsonKey(name: 'india_viability')
  String? get indiaViability;
  @override
  @JsonKey(name: 'user_match_score')
  int? get userMatchScore;
  @override
  @JsonKey(ignore: true)
  _$$SharedCareerImplCopyWith<_$SharedCareerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ParentProfileEntity _$ParentProfileEntityFromJson(Map<String, dynamic> json) {
  return _ParentProfileEntity.fromJson(json);
}

/// @nodoc
mixin _$ParentProfileEntity {
  String get studentName => throw _privateConstructorUsedError;
  @JsonKey(name: 'academic_stage')
  String? get academicStage => throw _privateConstructorUsedError;
  @JsonKey(name: 'interest_profile')
  Map<String, dynamic>? get interestProfile =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'top_careers')
  List<SharedCareer> get topCareers => throw _privateConstructorUsedError;
  @JsonKey(name: 'saved_careers')
  List<SharedCareer> get savedCareers => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_roadmap_count')
  int get activeRoadmapCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'profiler_completed_at')
  String? get profilerCompletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated_at')
  String? get lastUpdatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParentProfileEntityCopyWith<ParentProfileEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParentProfileEntityCopyWith<$Res> {
  factory $ParentProfileEntityCopyWith(
          ParentProfileEntity value, $Res Function(ParentProfileEntity) then) =
      _$ParentProfileEntityCopyWithImpl<$Res, ParentProfileEntity>;
  @useResult
  $Res call(
      {String studentName,
      @JsonKey(name: 'academic_stage') String? academicStage,
      @JsonKey(name: 'interest_profile') Map<String, dynamic>? interestProfile,
      @JsonKey(name: 'top_careers') List<SharedCareer> topCareers,
      @JsonKey(name: 'saved_careers') List<SharedCareer> savedCareers,
      @JsonKey(name: 'active_roadmap_count') int activeRoadmapCount,
      @JsonKey(name: 'profiler_completed_at') String? profilerCompletedAt,
      @JsonKey(name: 'last_updated_at') String? lastUpdatedAt});
}

/// @nodoc
class _$ParentProfileEntityCopyWithImpl<$Res, $Val extends ParentProfileEntity>
    implements $ParentProfileEntityCopyWith<$Res> {
  _$ParentProfileEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentName = null,
    Object? academicStage = freezed,
    Object? interestProfile = freezed,
    Object? topCareers = null,
    Object? savedCareers = null,
    Object? activeRoadmapCount = null,
    Object? profilerCompletedAt = freezed,
    Object? lastUpdatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      studentName: null == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      academicStage: freezed == academicStage
          ? _value.academicStage
          : academicStage // ignore: cast_nullable_to_non_nullable
              as String?,
      interestProfile: freezed == interestProfile
          ? _value.interestProfile
          : interestProfile // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      topCareers: null == topCareers
          ? _value.topCareers
          : topCareers // ignore: cast_nullable_to_non_nullable
              as List<SharedCareer>,
      savedCareers: null == savedCareers
          ? _value.savedCareers
          : savedCareers // ignore: cast_nullable_to_non_nullable
              as List<SharedCareer>,
      activeRoadmapCount: null == activeRoadmapCount
          ? _value.activeRoadmapCount
          : activeRoadmapCount // ignore: cast_nullable_to_non_nullable
              as int,
      profilerCompletedAt: freezed == profilerCompletedAt
          ? _value.profilerCompletedAt
          : profilerCompletedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdatedAt: freezed == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParentProfileEntityImplCopyWith<$Res>
    implements $ParentProfileEntityCopyWith<$Res> {
  factory _$$ParentProfileEntityImplCopyWith(_$ParentProfileEntityImpl value,
          $Res Function(_$ParentProfileEntityImpl) then) =
      __$$ParentProfileEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String studentName,
      @JsonKey(name: 'academic_stage') String? academicStage,
      @JsonKey(name: 'interest_profile') Map<String, dynamic>? interestProfile,
      @JsonKey(name: 'top_careers') List<SharedCareer> topCareers,
      @JsonKey(name: 'saved_careers') List<SharedCareer> savedCareers,
      @JsonKey(name: 'active_roadmap_count') int activeRoadmapCount,
      @JsonKey(name: 'profiler_completed_at') String? profilerCompletedAt,
      @JsonKey(name: 'last_updated_at') String? lastUpdatedAt});
}

/// @nodoc
class __$$ParentProfileEntityImplCopyWithImpl<$Res>
    extends _$ParentProfileEntityCopyWithImpl<$Res, _$ParentProfileEntityImpl>
    implements _$$ParentProfileEntityImplCopyWith<$Res> {
  __$$ParentProfileEntityImplCopyWithImpl(_$ParentProfileEntityImpl _value,
      $Res Function(_$ParentProfileEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentName = null,
    Object? academicStage = freezed,
    Object? interestProfile = freezed,
    Object? topCareers = null,
    Object? savedCareers = null,
    Object? activeRoadmapCount = null,
    Object? profilerCompletedAt = freezed,
    Object? lastUpdatedAt = freezed,
  }) {
    return _then(_$ParentProfileEntityImpl(
      studentName: null == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      academicStage: freezed == academicStage
          ? _value.academicStage
          : academicStage // ignore: cast_nullable_to_non_nullable
              as String?,
      interestProfile: freezed == interestProfile
          ? _value._interestProfile
          : interestProfile // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      topCareers: null == topCareers
          ? _value._topCareers
          : topCareers // ignore: cast_nullable_to_non_nullable
              as List<SharedCareer>,
      savedCareers: null == savedCareers
          ? _value._savedCareers
          : savedCareers // ignore: cast_nullable_to_non_nullable
              as List<SharedCareer>,
      activeRoadmapCount: null == activeRoadmapCount
          ? _value.activeRoadmapCount
          : activeRoadmapCount // ignore: cast_nullable_to_non_nullable
              as int,
      profilerCompletedAt: freezed == profilerCompletedAt
          ? _value.profilerCompletedAt
          : profilerCompletedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdatedAt: freezed == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParentProfileEntityImpl implements _ParentProfileEntity {
  const _$ParentProfileEntityImpl(
      {required this.studentName,
      @JsonKey(name: 'academic_stage') this.academicStage,
      @JsonKey(name: 'interest_profile')
      final Map<String, dynamic>? interestProfile,
      @JsonKey(name: 'top_careers')
      final List<SharedCareer> topCareers = const [],
      @JsonKey(name: 'saved_careers')
      final List<SharedCareer> savedCareers = const [],
      @JsonKey(name: 'active_roadmap_count') this.activeRoadmapCount = 0,
      @JsonKey(name: 'profiler_completed_at') this.profilerCompletedAt,
      @JsonKey(name: 'last_updated_at') this.lastUpdatedAt})
      : _interestProfile = interestProfile,
        _topCareers = topCareers,
        _savedCareers = savedCareers;

  factory _$ParentProfileEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParentProfileEntityImplFromJson(json);

  @override
  final String studentName;
  @override
  @JsonKey(name: 'academic_stage')
  final String? academicStage;
  final Map<String, dynamic>? _interestProfile;
  @override
  @JsonKey(name: 'interest_profile')
  Map<String, dynamic>? get interestProfile {
    final value = _interestProfile;
    if (value == null) return null;
    if (_interestProfile is EqualUnmodifiableMapView) return _interestProfile;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<SharedCareer> _topCareers;
  @override
  @JsonKey(name: 'top_careers')
  List<SharedCareer> get topCareers {
    if (_topCareers is EqualUnmodifiableListView) return _topCareers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topCareers);
  }

  final List<SharedCareer> _savedCareers;
  @override
  @JsonKey(name: 'saved_careers')
  List<SharedCareer> get savedCareers {
    if (_savedCareers is EqualUnmodifiableListView) return _savedCareers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_savedCareers);
  }

  @override
  @JsonKey(name: 'active_roadmap_count')
  final int activeRoadmapCount;
  @override
  @JsonKey(name: 'profiler_completed_at')
  final String? profilerCompletedAt;
  @override
  @JsonKey(name: 'last_updated_at')
  final String? lastUpdatedAt;

  @override
  String toString() {
    return 'ParentProfileEntity(studentName: $studentName, academicStage: $academicStage, interestProfile: $interestProfile, topCareers: $topCareers, savedCareers: $savedCareers, activeRoadmapCount: $activeRoadmapCount, profilerCompletedAt: $profilerCompletedAt, lastUpdatedAt: $lastUpdatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParentProfileEntityImpl &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.academicStage, academicStage) ||
                other.academicStage == academicStage) &&
            const DeepCollectionEquality()
                .equals(other._interestProfile, _interestProfile) &&
            const DeepCollectionEquality()
                .equals(other._topCareers, _topCareers) &&
            const DeepCollectionEquality()
                .equals(other._savedCareers, _savedCareers) &&
            (identical(other.activeRoadmapCount, activeRoadmapCount) ||
                other.activeRoadmapCount == activeRoadmapCount) &&
            (identical(other.profilerCompletedAt, profilerCompletedAt) ||
                other.profilerCompletedAt == profilerCompletedAt) &&
            (identical(other.lastUpdatedAt, lastUpdatedAt) ||
                other.lastUpdatedAt == lastUpdatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      studentName,
      academicStage,
      const DeepCollectionEquality().hash(_interestProfile),
      const DeepCollectionEquality().hash(_topCareers),
      const DeepCollectionEquality().hash(_savedCareers),
      activeRoadmapCount,
      profilerCompletedAt,
      lastUpdatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParentProfileEntityImplCopyWith<_$ParentProfileEntityImpl> get copyWith =>
      __$$ParentProfileEntityImplCopyWithImpl<_$ParentProfileEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParentProfileEntityImplToJson(
      this,
    );
  }
}

abstract class _ParentProfileEntity implements ParentProfileEntity {
  const factory _ParentProfileEntity(
      {required final String studentName,
      @JsonKey(name: 'academic_stage') final String? academicStage,
      @JsonKey(name: 'interest_profile')
      final Map<String, dynamic>? interestProfile,
      @JsonKey(name: 'top_careers') final List<SharedCareer> topCareers,
      @JsonKey(name: 'saved_careers') final List<SharedCareer> savedCareers,
      @JsonKey(name: 'active_roadmap_count') final int activeRoadmapCount,
      @JsonKey(name: 'profiler_completed_at') final String? profilerCompletedAt,
      @JsonKey(name: 'last_updated_at')
      final String? lastUpdatedAt}) = _$ParentProfileEntityImpl;

  factory _ParentProfileEntity.fromJson(Map<String, dynamic> json) =
      _$ParentProfileEntityImpl.fromJson;

  @override
  String get studentName;
  @override
  @JsonKey(name: 'academic_stage')
  String? get academicStage;
  @override
  @JsonKey(name: 'interest_profile')
  Map<String, dynamic>? get interestProfile;
  @override
  @JsonKey(name: 'top_careers')
  List<SharedCareer> get topCareers;
  @override
  @JsonKey(name: 'saved_careers')
  List<SharedCareer> get savedCareers;
  @override
  @JsonKey(name: 'active_roadmap_count')
  int get activeRoadmapCount;
  @override
  @JsonKey(name: 'profiler_completed_at')
  String? get profilerCompletedAt;
  @override
  @JsonKey(name: 'last_updated_at')
  String? get lastUpdatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ParentProfileEntityImplCopyWith<_$ParentProfileEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
