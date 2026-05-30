// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'career_detail_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RelatedCareer _$RelatedCareerFromJson(Map<String, dynamic> json) {
  return _RelatedCareer.fromJson(json);
}

/// @nodoc
mixin _$RelatedCareer {
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'one_liner')
  String? get oneLiner => throw _privateConstructorUsedError;
  @JsonKey(name: 'future_score')
  int get futureScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RelatedCareerCopyWith<RelatedCareer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelatedCareerCopyWith<$Res> {
  factory $RelatedCareerCopyWith(
          RelatedCareer value, $Res Function(RelatedCareer) then) =
      _$RelatedCareerCopyWithImpl<$Res, RelatedCareer>;
  @useResult
  $Res call(
      {String slug,
      String name,
      @JsonKey(name: 'one_liner') String? oneLiner,
      @JsonKey(name: 'future_score') int futureScore});
}

/// @nodoc
class _$RelatedCareerCopyWithImpl<$Res, $Val extends RelatedCareer>
    implements $RelatedCareerCopyWith<$Res> {
  _$RelatedCareerCopyWithImpl(this._value, this._then);

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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RelatedCareerImplCopyWith<$Res>
    implements $RelatedCareerCopyWith<$Res> {
  factory _$$RelatedCareerImplCopyWith(
          _$RelatedCareerImpl value, $Res Function(_$RelatedCareerImpl) then) =
      __$$RelatedCareerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String slug,
      String name,
      @JsonKey(name: 'one_liner') String? oneLiner,
      @JsonKey(name: 'future_score') int futureScore});
}

/// @nodoc
class __$$RelatedCareerImplCopyWithImpl<$Res>
    extends _$RelatedCareerCopyWithImpl<$Res, _$RelatedCareerImpl>
    implements _$$RelatedCareerImplCopyWith<$Res> {
  __$$RelatedCareerImplCopyWithImpl(
      _$RelatedCareerImpl _value, $Res Function(_$RelatedCareerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? oneLiner = freezed,
    Object? futureScore = null,
  }) {
    return _then(_$RelatedCareerImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RelatedCareerImpl implements _RelatedCareer {
  const _$RelatedCareerImpl(
      {required this.slug,
      required this.name,
      @JsonKey(name: 'one_liner') this.oneLiner,
      @JsonKey(name: 'future_score') this.futureScore = 0});

  factory _$RelatedCareerImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelatedCareerImplFromJson(json);

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
  String toString() {
    return 'RelatedCareer(slug: $slug, name: $name, oneLiner: $oneLiner, futureScore: $futureScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelatedCareerImpl &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.oneLiner, oneLiner) ||
                other.oneLiner == oneLiner) &&
            (identical(other.futureScore, futureScore) ||
                other.futureScore == futureScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, slug, name, oneLiner, futureScore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RelatedCareerImplCopyWith<_$RelatedCareerImpl> get copyWith =>
      __$$RelatedCareerImplCopyWithImpl<_$RelatedCareerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RelatedCareerImplToJson(
      this,
    );
  }
}

abstract class _RelatedCareer implements RelatedCareer {
  const factory _RelatedCareer(
          {required final String slug,
          required final String name,
          @JsonKey(name: 'one_liner') final String? oneLiner,
          @JsonKey(name: 'future_score') final int futureScore}) =
      _$RelatedCareerImpl;

  factory _RelatedCareer.fromJson(Map<String, dynamic> json) =
      _$RelatedCareerImpl.fromJson;

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
  @JsonKey(ignore: true)
  _$$RelatedCareerImplCopyWith<_$RelatedCareerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RealPeopleStory _$RealPeopleStoryFromJson(Map<String, dynamic> json) {
  return _RealPeopleStory.fromJson(json);
}

/// @nodoc
mixin _$RealPeopleStory {
  String get id => throw _privateConstructorUsedError;
  String get personName => throw _privateConstructorUsedError;
  String? get personRole => throw _privateConstructorUsedError;
  String? get personImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'story_text')
  String? get storyText => throw _privateConstructorUsedError;
  @JsonKey(name: 'career_slug')
  String? get careerSlug => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RealPeopleStoryCopyWith<RealPeopleStory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RealPeopleStoryCopyWith<$Res> {
  factory $RealPeopleStoryCopyWith(
          RealPeopleStory value, $Res Function(RealPeopleStory) then) =
      _$RealPeopleStoryCopyWithImpl<$Res, RealPeopleStory>;
  @useResult
  $Res call(
      {String id,
      String personName,
      String? personRole,
      String? personImage,
      @JsonKey(name: 'story_text') String? storyText,
      @JsonKey(name: 'career_slug') String? careerSlug});
}

/// @nodoc
class _$RealPeopleStoryCopyWithImpl<$Res, $Val extends RealPeopleStory>
    implements $RealPeopleStoryCopyWith<$Res> {
  _$RealPeopleStoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? personName = null,
    Object? personRole = freezed,
    Object? personImage = freezed,
    Object? storyText = freezed,
    Object? careerSlug = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      personName: null == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String,
      personRole: freezed == personRole
          ? _value.personRole
          : personRole // ignore: cast_nullable_to_non_nullable
              as String?,
      personImage: freezed == personImage
          ? _value.personImage
          : personImage // ignore: cast_nullable_to_non_nullable
              as String?,
      storyText: freezed == storyText
          ? _value.storyText
          : storyText // ignore: cast_nullable_to_non_nullable
              as String?,
      careerSlug: freezed == careerSlug
          ? _value.careerSlug
          : careerSlug // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RealPeopleStoryImplCopyWith<$Res>
    implements $RealPeopleStoryCopyWith<$Res> {
  factory _$$RealPeopleStoryImplCopyWith(_$RealPeopleStoryImpl value,
          $Res Function(_$RealPeopleStoryImpl) then) =
      __$$RealPeopleStoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String personName,
      String? personRole,
      String? personImage,
      @JsonKey(name: 'story_text') String? storyText,
      @JsonKey(name: 'career_slug') String? careerSlug});
}

/// @nodoc
class __$$RealPeopleStoryImplCopyWithImpl<$Res>
    extends _$RealPeopleStoryCopyWithImpl<$Res, _$RealPeopleStoryImpl>
    implements _$$RealPeopleStoryImplCopyWith<$Res> {
  __$$RealPeopleStoryImplCopyWithImpl(
      _$RealPeopleStoryImpl _value, $Res Function(_$RealPeopleStoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? personName = null,
    Object? personRole = freezed,
    Object? personImage = freezed,
    Object? storyText = freezed,
    Object? careerSlug = freezed,
  }) {
    return _then(_$RealPeopleStoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      personName: null == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String,
      personRole: freezed == personRole
          ? _value.personRole
          : personRole // ignore: cast_nullable_to_non_nullable
              as String?,
      personImage: freezed == personImage
          ? _value.personImage
          : personImage // ignore: cast_nullable_to_non_nullable
              as String?,
      storyText: freezed == storyText
          ? _value.storyText
          : storyText // ignore: cast_nullable_to_non_nullable
              as String?,
      careerSlug: freezed == careerSlug
          ? _value.careerSlug
          : careerSlug // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RealPeopleStoryImpl implements _RealPeopleStory {
  const _$RealPeopleStoryImpl(
      {required this.id,
      required this.personName,
      this.personRole,
      this.personImage,
      @JsonKey(name: 'story_text') this.storyText,
      @JsonKey(name: 'career_slug') this.careerSlug});

  factory _$RealPeopleStoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RealPeopleStoryImplFromJson(json);

  @override
  final String id;
  @override
  final String personName;
  @override
  final String? personRole;
  @override
  final String? personImage;
  @override
  @JsonKey(name: 'story_text')
  final String? storyText;
  @override
  @JsonKey(name: 'career_slug')
  final String? careerSlug;

  @override
  String toString() {
    return 'RealPeopleStory(id: $id, personName: $personName, personRole: $personRole, personImage: $personImage, storyText: $storyText, careerSlug: $careerSlug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealPeopleStoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.personName, personName) ||
                other.personName == personName) &&
            (identical(other.personRole, personRole) ||
                other.personRole == personRole) &&
            (identical(other.personImage, personImage) ||
                other.personImage == personImage) &&
            (identical(other.storyText, storyText) ||
                other.storyText == storyText) &&
            (identical(other.careerSlug, careerSlug) ||
                other.careerSlug == careerSlug));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, personName, personRole,
      personImage, storyText, careerSlug);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RealPeopleStoryImplCopyWith<_$RealPeopleStoryImpl> get copyWith =>
      __$$RealPeopleStoryImplCopyWithImpl<_$RealPeopleStoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RealPeopleStoryImplToJson(
      this,
    );
  }
}

abstract class _RealPeopleStory implements RealPeopleStory {
  const factory _RealPeopleStory(
          {required final String id,
          required final String personName,
          final String? personRole,
          final String? personImage,
          @JsonKey(name: 'story_text') final String? storyText,
          @JsonKey(name: 'career_slug') final String? careerSlug}) =
      _$RealPeopleStoryImpl;

  factory _RealPeopleStory.fromJson(Map<String, dynamic> json) =
      _$RealPeopleStoryImpl.fromJson;

  @override
  String get id;
  @override
  String get personName;
  @override
  String? get personRole;
  @override
  String? get personImage;
  @override
  @JsonKey(name: 'story_text')
  String? get storyText;
  @override
  @JsonKey(name: 'career_slug')
  String? get careerSlug;
  @override
  @JsonKey(ignore: true)
  _$$RealPeopleStoryImplCopyWith<_$RealPeopleStoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningResource _$LearningResourceFromJson(Map<String, dynamic> json) {
  return _LearningResource.fromJson(json);
}

/// @nodoc
mixin _$LearningResource {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get resourceType =>
      throw _privateConstructorUsedError; // 'course', 'article', 'video', 'book'
  String? get url => throw _privateConstructorUsedError;
  String? get provider => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LearningResourceCopyWith<LearningResource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningResourceCopyWith<$Res> {
  factory $LearningResourceCopyWith(
          LearningResource value, $Res Function(LearningResource) then) =
      _$LearningResourceCopyWithImpl<$Res, LearningResource>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? resourceType,
      String? url,
      String? provider});
}

/// @nodoc
class _$LearningResourceCopyWithImpl<$Res, $Val extends LearningResource>
    implements $LearningResourceCopyWith<$Res> {
  _$LearningResourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? resourceType = freezed,
    Object? url = freezed,
    Object? provider = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: freezed == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningResourceImplCopyWith<$Res>
    implements $LearningResourceCopyWith<$Res> {
  factory _$$LearningResourceImplCopyWith(_$LearningResourceImpl value,
          $Res Function(_$LearningResourceImpl) then) =
      __$$LearningResourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? resourceType,
      String? url,
      String? provider});
}

/// @nodoc
class __$$LearningResourceImplCopyWithImpl<$Res>
    extends _$LearningResourceCopyWithImpl<$Res, _$LearningResourceImpl>
    implements _$$LearningResourceImplCopyWith<$Res> {
  __$$LearningResourceImplCopyWithImpl(_$LearningResourceImpl _value,
      $Res Function(_$LearningResourceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? resourceType = freezed,
    Object? url = freezed,
    Object? provider = freezed,
  }) {
    return _then(_$LearningResourceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: freezed == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningResourceImpl implements _LearningResource {
  const _$LearningResourceImpl(
      {required this.id,
      required this.title,
      this.description,
      this.resourceType,
      this.url,
      this.provider});

  factory _$LearningResourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningResourceImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? resourceType;
// 'course', 'article', 'video', 'book'
  @override
  final String? url;
  @override
  final String? provider;

  @override
  String toString() {
    return 'LearningResource(id: $id, title: $title, description: $description, resourceType: $resourceType, url: $url, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningResourceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, description, resourceType, url, provider);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningResourceImplCopyWith<_$LearningResourceImpl> get copyWith =>
      __$$LearningResourceImplCopyWithImpl<_$LearningResourceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningResourceImplToJson(
      this,
    );
  }
}

abstract class _LearningResource implements LearningResource {
  const factory _LearningResource(
      {required final String id,
      required final String title,
      final String? description,
      final String? resourceType,
      final String? url,
      final String? provider}) = _$LearningResourceImpl;

  factory _LearningResource.fromJson(Map<String, dynamic> json) =
      _$LearningResourceImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get resourceType;
  @override // 'course', 'article', 'video', 'book'
  String? get url;
  @override
  String? get provider;
  @override
  @JsonKey(ignore: true)
  _$$LearningResourceImplCopyWith<_$LearningResourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CareerDetailEntity _$CareerDetailEntityFromJson(Map<String, dynamic> json) {
  return _CareerDetailEntity.fromJson(json);
}

/// @nodoc
mixin _$CareerDetailEntity {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'one_liner')
  String? get oneLiner => throw _privateConstructorUsedError;
  CareerDomainBrief? get domain => throw _privateConstructorUsedError;
  @JsonKey(name: 'dimension_tags')
  List<String> get dimensionTags => throw _privateConstructorUsedError;
  @JsonKey(name: 'india_viability')
  String? get indiaViability => throw _privateConstructorUsedError;
  @JsonKey(name: 'future_score')
  int get futureScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'future_score_reasoning')
  String? get futureScoreReasoning => throw _privateConstructorUsedError;
  @JsonKey(name: 'typical_day')
  String? get typicalDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'skills_needed')
  List<String> get skillsNeeded => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_paths')
  List<String> get entryPaths => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_entry_lpa')
  String? get salaryEntryLpa => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_mid_lpa')
  String? get salaryMidLpa => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_senior_lpa')
  String? get salarySeniorLpa => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_emerging')
  bool get isEmerging => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_reviewed_at')
  String? get lastReviewedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_careers')
  List<RelatedCareer> get relatedCareers => throw _privateConstructorUsedError;
  @JsonKey(name: 'real_people_stories')
  List<RealPeopleStory> get realPeopleStories =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'learning_resources')
  List<LearningResource> get learningResources =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'is_saved')
  bool get isSaved => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_match_score')
  int? get userMatchScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CareerDetailEntityCopyWith<CareerDetailEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CareerDetailEntityCopyWith<$Res> {
  factory $CareerDetailEntityCopyWith(
          CareerDetailEntity value, $Res Function(CareerDetailEntity) then) =
      _$CareerDetailEntityCopyWithImpl<$Res, CareerDetailEntity>;
  @useResult
  $Res call(
      {String id,
      String slug,
      String name,
      @JsonKey(name: 'one_liner') String? oneLiner,
      CareerDomainBrief? domain,
      @JsonKey(name: 'dimension_tags') List<String> dimensionTags,
      @JsonKey(name: 'india_viability') String? indiaViability,
      @JsonKey(name: 'future_score') int futureScore,
      @JsonKey(name: 'future_score_reasoning') String? futureScoreReasoning,
      @JsonKey(name: 'typical_day') String? typicalDay,
      @JsonKey(name: 'skills_needed') List<String> skillsNeeded,
      @JsonKey(name: 'entry_paths') List<String> entryPaths,
      @JsonKey(name: 'salary_entry_lpa') String? salaryEntryLpa,
      @JsonKey(name: 'salary_mid_lpa') String? salaryMidLpa,
      @JsonKey(name: 'salary_senior_lpa') String? salarySeniorLpa,
      @JsonKey(name: 'is_emerging') bool isEmerging,
      @JsonKey(name: 'last_reviewed_at') String? lastReviewedAt,
      @JsonKey(name: 'related_careers') List<RelatedCareer> relatedCareers,
      @JsonKey(name: 'real_people_stories')
      List<RealPeopleStory> realPeopleStories,
      @JsonKey(name: 'learning_resources')
      List<LearningResource> learningResources,
      @JsonKey(name: 'is_saved') bool isSaved,
      @JsonKey(name: 'user_match_score') int? userMatchScore});

  $CareerDomainBriefCopyWith<$Res>? get domain;
}

/// @nodoc
class _$CareerDetailEntityCopyWithImpl<$Res, $Val extends CareerDetailEntity>
    implements $CareerDetailEntityCopyWith<$Res> {
  _$CareerDetailEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? oneLiner = freezed,
    Object? domain = freezed,
    Object? dimensionTags = null,
    Object? indiaViability = freezed,
    Object? futureScore = null,
    Object? futureScoreReasoning = freezed,
    Object? typicalDay = freezed,
    Object? skillsNeeded = null,
    Object? entryPaths = null,
    Object? salaryEntryLpa = freezed,
    Object? salaryMidLpa = freezed,
    Object? salarySeniorLpa = freezed,
    Object? isEmerging = null,
    Object? lastReviewedAt = freezed,
    Object? relatedCareers = null,
    Object? realPeopleStories = null,
    Object? learningResources = null,
    Object? isSaved = null,
    Object? userMatchScore = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      domain: freezed == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as CareerDomainBrief?,
      dimensionTags: null == dimensionTags
          ? _value.dimensionTags
          : dimensionTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      indiaViability: freezed == indiaViability
          ? _value.indiaViability
          : indiaViability // ignore: cast_nullable_to_non_nullable
              as String?,
      futureScore: null == futureScore
          ? _value.futureScore
          : futureScore // ignore: cast_nullable_to_non_nullable
              as int,
      futureScoreReasoning: freezed == futureScoreReasoning
          ? _value.futureScoreReasoning
          : futureScoreReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      typicalDay: freezed == typicalDay
          ? _value.typicalDay
          : typicalDay // ignore: cast_nullable_to_non_nullable
              as String?,
      skillsNeeded: null == skillsNeeded
          ? _value.skillsNeeded
          : skillsNeeded // ignore: cast_nullable_to_non_nullable
              as List<String>,
      entryPaths: null == entryPaths
          ? _value.entryPaths
          : entryPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      salaryEntryLpa: freezed == salaryEntryLpa
          ? _value.salaryEntryLpa
          : salaryEntryLpa // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryMidLpa: freezed == salaryMidLpa
          ? _value.salaryMidLpa
          : salaryMidLpa // ignore: cast_nullable_to_non_nullable
              as String?,
      salarySeniorLpa: freezed == salarySeniorLpa
          ? _value.salarySeniorLpa
          : salarySeniorLpa // ignore: cast_nullable_to_non_nullable
              as String?,
      isEmerging: null == isEmerging
          ? _value.isEmerging
          : isEmerging // ignore: cast_nullable_to_non_nullable
              as bool,
      lastReviewedAt: freezed == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCareers: null == relatedCareers
          ? _value.relatedCareers
          : relatedCareers // ignore: cast_nullable_to_non_nullable
              as List<RelatedCareer>,
      realPeopleStories: null == realPeopleStories
          ? _value.realPeopleStories
          : realPeopleStories // ignore: cast_nullable_to_non_nullable
              as List<RealPeopleStory>,
      learningResources: null == learningResources
          ? _value.learningResources
          : learningResources // ignore: cast_nullable_to_non_nullable
              as List<LearningResource>,
      isSaved: null == isSaved
          ? _value.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      userMatchScore: freezed == userMatchScore
          ? _value.userMatchScore
          : userMatchScore // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CareerDomainBriefCopyWith<$Res>? get domain {
    if (_value.domain == null) {
      return null;
    }

    return $CareerDomainBriefCopyWith<$Res>(_value.domain!, (value) {
      return _then(_value.copyWith(domain: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CareerDetailEntityImplCopyWith<$Res>
    implements $CareerDetailEntityCopyWith<$Res> {
  factory _$$CareerDetailEntityImplCopyWith(_$CareerDetailEntityImpl value,
          $Res Function(_$CareerDetailEntityImpl) then) =
      __$$CareerDetailEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String slug,
      String name,
      @JsonKey(name: 'one_liner') String? oneLiner,
      CareerDomainBrief? domain,
      @JsonKey(name: 'dimension_tags') List<String> dimensionTags,
      @JsonKey(name: 'india_viability') String? indiaViability,
      @JsonKey(name: 'future_score') int futureScore,
      @JsonKey(name: 'future_score_reasoning') String? futureScoreReasoning,
      @JsonKey(name: 'typical_day') String? typicalDay,
      @JsonKey(name: 'skills_needed') List<String> skillsNeeded,
      @JsonKey(name: 'entry_paths') List<String> entryPaths,
      @JsonKey(name: 'salary_entry_lpa') String? salaryEntryLpa,
      @JsonKey(name: 'salary_mid_lpa') String? salaryMidLpa,
      @JsonKey(name: 'salary_senior_lpa') String? salarySeniorLpa,
      @JsonKey(name: 'is_emerging') bool isEmerging,
      @JsonKey(name: 'last_reviewed_at') String? lastReviewedAt,
      @JsonKey(name: 'related_careers') List<RelatedCareer> relatedCareers,
      @JsonKey(name: 'real_people_stories')
      List<RealPeopleStory> realPeopleStories,
      @JsonKey(name: 'learning_resources')
      List<LearningResource> learningResources,
      @JsonKey(name: 'is_saved') bool isSaved,
      @JsonKey(name: 'user_match_score') int? userMatchScore});

  @override
  $CareerDomainBriefCopyWith<$Res>? get domain;
}

/// @nodoc
class __$$CareerDetailEntityImplCopyWithImpl<$Res>
    extends _$CareerDetailEntityCopyWithImpl<$Res, _$CareerDetailEntityImpl>
    implements _$$CareerDetailEntityImplCopyWith<$Res> {
  __$$CareerDetailEntityImplCopyWithImpl(_$CareerDetailEntityImpl _value,
      $Res Function(_$CareerDetailEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? oneLiner = freezed,
    Object? domain = freezed,
    Object? dimensionTags = null,
    Object? indiaViability = freezed,
    Object? futureScore = null,
    Object? futureScoreReasoning = freezed,
    Object? typicalDay = freezed,
    Object? skillsNeeded = null,
    Object? entryPaths = null,
    Object? salaryEntryLpa = freezed,
    Object? salaryMidLpa = freezed,
    Object? salarySeniorLpa = freezed,
    Object? isEmerging = null,
    Object? lastReviewedAt = freezed,
    Object? relatedCareers = null,
    Object? realPeopleStories = null,
    Object? learningResources = null,
    Object? isSaved = null,
    Object? userMatchScore = freezed,
  }) {
    return _then(_$CareerDetailEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      domain: freezed == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as CareerDomainBrief?,
      dimensionTags: null == dimensionTags
          ? _value._dimensionTags
          : dimensionTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      indiaViability: freezed == indiaViability
          ? _value.indiaViability
          : indiaViability // ignore: cast_nullable_to_non_nullable
              as String?,
      futureScore: null == futureScore
          ? _value.futureScore
          : futureScore // ignore: cast_nullable_to_non_nullable
              as int,
      futureScoreReasoning: freezed == futureScoreReasoning
          ? _value.futureScoreReasoning
          : futureScoreReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      typicalDay: freezed == typicalDay
          ? _value.typicalDay
          : typicalDay // ignore: cast_nullable_to_non_nullable
              as String?,
      skillsNeeded: null == skillsNeeded
          ? _value._skillsNeeded
          : skillsNeeded // ignore: cast_nullable_to_non_nullable
              as List<String>,
      entryPaths: null == entryPaths
          ? _value._entryPaths
          : entryPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      salaryEntryLpa: freezed == salaryEntryLpa
          ? _value.salaryEntryLpa
          : salaryEntryLpa // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryMidLpa: freezed == salaryMidLpa
          ? _value.salaryMidLpa
          : salaryMidLpa // ignore: cast_nullable_to_non_nullable
              as String?,
      salarySeniorLpa: freezed == salarySeniorLpa
          ? _value.salarySeniorLpa
          : salarySeniorLpa // ignore: cast_nullable_to_non_nullable
              as String?,
      isEmerging: null == isEmerging
          ? _value.isEmerging
          : isEmerging // ignore: cast_nullable_to_non_nullable
              as bool,
      lastReviewedAt: freezed == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCareers: null == relatedCareers
          ? _value._relatedCareers
          : relatedCareers // ignore: cast_nullable_to_non_nullable
              as List<RelatedCareer>,
      realPeopleStories: null == realPeopleStories
          ? _value._realPeopleStories
          : realPeopleStories // ignore: cast_nullable_to_non_nullable
              as List<RealPeopleStory>,
      learningResources: null == learningResources
          ? _value._learningResources
          : learningResources // ignore: cast_nullable_to_non_nullable
              as List<LearningResource>,
      isSaved: null == isSaved
          ? _value.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      userMatchScore: freezed == userMatchScore
          ? _value.userMatchScore
          : userMatchScore // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CareerDetailEntityImpl implements _CareerDetailEntity {
  const _$CareerDetailEntityImpl(
      {required this.id,
      required this.slug,
      required this.name,
      @JsonKey(name: 'one_liner') this.oneLiner,
      this.domain,
      @JsonKey(name: 'dimension_tags')
      final List<String> dimensionTags = const [],
      @JsonKey(name: 'india_viability') this.indiaViability,
      @JsonKey(name: 'future_score') this.futureScore = 0,
      @JsonKey(name: 'future_score_reasoning') this.futureScoreReasoning,
      @JsonKey(name: 'typical_day') this.typicalDay,
      @JsonKey(name: 'skills_needed')
      final List<String> skillsNeeded = const [],
      @JsonKey(name: 'entry_paths') final List<String> entryPaths = const [],
      @JsonKey(name: 'salary_entry_lpa') this.salaryEntryLpa,
      @JsonKey(name: 'salary_mid_lpa') this.salaryMidLpa,
      @JsonKey(name: 'salary_senior_lpa') this.salarySeniorLpa,
      @JsonKey(name: 'is_emerging') this.isEmerging = false,
      @JsonKey(name: 'last_reviewed_at') this.lastReviewedAt,
      @JsonKey(name: 'related_careers')
      final List<RelatedCareer> relatedCareers = const [],
      @JsonKey(name: 'real_people_stories')
      final List<RealPeopleStory> realPeopleStories = const [],
      @JsonKey(name: 'learning_resources')
      final List<LearningResource> learningResources = const [],
      @JsonKey(name: 'is_saved') this.isSaved = false,
      @JsonKey(name: 'user_match_score') this.userMatchScore})
      : _dimensionTags = dimensionTags,
        _skillsNeeded = skillsNeeded,
        _entryPaths = entryPaths,
        _relatedCareers = relatedCareers,
        _realPeopleStories = realPeopleStories,
        _learningResources = learningResources;

  factory _$CareerDetailEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$CareerDetailEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;
  @override
  @JsonKey(name: 'one_liner')
  final String? oneLiner;
  @override
  final CareerDomainBrief? domain;
  final List<String> _dimensionTags;
  @override
  @JsonKey(name: 'dimension_tags')
  List<String> get dimensionTags {
    if (_dimensionTags is EqualUnmodifiableListView) return _dimensionTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dimensionTags);
  }

  @override
  @JsonKey(name: 'india_viability')
  final String? indiaViability;
  @override
  @JsonKey(name: 'future_score')
  final int futureScore;
  @override
  @JsonKey(name: 'future_score_reasoning')
  final String? futureScoreReasoning;
  @override
  @JsonKey(name: 'typical_day')
  final String? typicalDay;
  final List<String> _skillsNeeded;
  @override
  @JsonKey(name: 'skills_needed')
  List<String> get skillsNeeded {
    if (_skillsNeeded is EqualUnmodifiableListView) return _skillsNeeded;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsNeeded);
  }

  final List<String> _entryPaths;
  @override
  @JsonKey(name: 'entry_paths')
  List<String> get entryPaths {
    if (_entryPaths is EqualUnmodifiableListView) return _entryPaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entryPaths);
  }

  @override
  @JsonKey(name: 'salary_entry_lpa')
  final String? salaryEntryLpa;
  @override
  @JsonKey(name: 'salary_mid_lpa')
  final String? salaryMidLpa;
  @override
  @JsonKey(name: 'salary_senior_lpa')
  final String? salarySeniorLpa;
  @override
  @JsonKey(name: 'is_emerging')
  final bool isEmerging;
  @override
  @JsonKey(name: 'last_reviewed_at')
  final String? lastReviewedAt;
  final List<RelatedCareer> _relatedCareers;
  @override
  @JsonKey(name: 'related_careers')
  List<RelatedCareer> get relatedCareers {
    if (_relatedCareers is EqualUnmodifiableListView) return _relatedCareers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedCareers);
  }

  final List<RealPeopleStory> _realPeopleStories;
  @override
  @JsonKey(name: 'real_people_stories')
  List<RealPeopleStory> get realPeopleStories {
    if (_realPeopleStories is EqualUnmodifiableListView)
      return _realPeopleStories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_realPeopleStories);
  }

  final List<LearningResource> _learningResources;
  @override
  @JsonKey(name: 'learning_resources')
  List<LearningResource> get learningResources {
    if (_learningResources is EqualUnmodifiableListView)
      return _learningResources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_learningResources);
  }

  @override
  @JsonKey(name: 'is_saved')
  final bool isSaved;
  @override
  @JsonKey(name: 'user_match_score')
  final int? userMatchScore;

  @override
  String toString() {
    return 'CareerDetailEntity(id: $id, slug: $slug, name: $name, oneLiner: $oneLiner, domain: $domain, dimensionTags: $dimensionTags, indiaViability: $indiaViability, futureScore: $futureScore, futureScoreReasoning: $futureScoreReasoning, typicalDay: $typicalDay, skillsNeeded: $skillsNeeded, entryPaths: $entryPaths, salaryEntryLpa: $salaryEntryLpa, salaryMidLpa: $salaryMidLpa, salarySeniorLpa: $salarySeniorLpa, isEmerging: $isEmerging, lastReviewedAt: $lastReviewedAt, relatedCareers: $relatedCareers, realPeopleStories: $realPeopleStories, learningResources: $learningResources, isSaved: $isSaved, userMatchScore: $userMatchScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CareerDetailEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.oneLiner, oneLiner) ||
                other.oneLiner == oneLiner) &&
            (identical(other.domain, domain) || other.domain == domain) &&
            const DeepCollectionEquality()
                .equals(other._dimensionTags, _dimensionTags) &&
            (identical(other.indiaViability, indiaViability) ||
                other.indiaViability == indiaViability) &&
            (identical(other.futureScore, futureScore) ||
                other.futureScore == futureScore) &&
            (identical(other.futureScoreReasoning, futureScoreReasoning) ||
                other.futureScoreReasoning == futureScoreReasoning) &&
            (identical(other.typicalDay, typicalDay) ||
                other.typicalDay == typicalDay) &&
            const DeepCollectionEquality()
                .equals(other._skillsNeeded, _skillsNeeded) &&
            const DeepCollectionEquality()
                .equals(other._entryPaths, _entryPaths) &&
            (identical(other.salaryEntryLpa, salaryEntryLpa) ||
                other.salaryEntryLpa == salaryEntryLpa) &&
            (identical(other.salaryMidLpa, salaryMidLpa) ||
                other.salaryMidLpa == salaryMidLpa) &&
            (identical(other.salarySeniorLpa, salarySeniorLpa) ||
                other.salarySeniorLpa == salarySeniorLpa) &&
            (identical(other.isEmerging, isEmerging) ||
                other.isEmerging == isEmerging) &&
            (identical(other.lastReviewedAt, lastReviewedAt) ||
                other.lastReviewedAt == lastReviewedAt) &&
            const DeepCollectionEquality()
                .equals(other._relatedCareers, _relatedCareers) &&
            const DeepCollectionEquality()
                .equals(other._realPeopleStories, _realPeopleStories) &&
            const DeepCollectionEquality()
                .equals(other._learningResources, _learningResources) &&
            (identical(other.isSaved, isSaved) || other.isSaved == isSaved) &&
            (identical(other.userMatchScore, userMatchScore) ||
                other.userMatchScore == userMatchScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        slug,
        name,
        oneLiner,
        domain,
        const DeepCollectionEquality().hash(_dimensionTags),
        indiaViability,
        futureScore,
        futureScoreReasoning,
        typicalDay,
        const DeepCollectionEquality().hash(_skillsNeeded),
        const DeepCollectionEquality().hash(_entryPaths),
        salaryEntryLpa,
        salaryMidLpa,
        salarySeniorLpa,
        isEmerging,
        lastReviewedAt,
        const DeepCollectionEquality().hash(_relatedCareers),
        const DeepCollectionEquality().hash(_realPeopleStories),
        const DeepCollectionEquality().hash(_learningResources),
        isSaved,
        userMatchScore
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CareerDetailEntityImplCopyWith<_$CareerDetailEntityImpl> get copyWith =>
      __$$CareerDetailEntityImplCopyWithImpl<_$CareerDetailEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CareerDetailEntityImplToJson(
      this,
    );
  }
}

abstract class _CareerDetailEntity implements CareerDetailEntity {
  const factory _CareerDetailEntity(
          {required final String id,
          required final String slug,
          required final String name,
          @JsonKey(name: 'one_liner') final String? oneLiner,
          final CareerDomainBrief? domain,
          @JsonKey(name: 'dimension_tags') final List<String> dimensionTags,
          @JsonKey(name: 'india_viability') final String? indiaViability,
          @JsonKey(name: 'future_score') final int futureScore,
          @JsonKey(name: 'future_score_reasoning')
          final String? futureScoreReasoning,
          @JsonKey(name: 'typical_day') final String? typicalDay,
          @JsonKey(name: 'skills_needed') final List<String> skillsNeeded,
          @JsonKey(name: 'entry_paths') final List<String> entryPaths,
          @JsonKey(name: 'salary_entry_lpa') final String? salaryEntryLpa,
          @JsonKey(name: 'salary_mid_lpa') final String? salaryMidLpa,
          @JsonKey(name: 'salary_senior_lpa') final String? salarySeniorLpa,
          @JsonKey(name: 'is_emerging') final bool isEmerging,
          @JsonKey(name: 'last_reviewed_at') final String? lastReviewedAt,
          @JsonKey(name: 'related_careers')
          final List<RelatedCareer> relatedCareers,
          @JsonKey(name: 'real_people_stories')
          final List<RealPeopleStory> realPeopleStories,
          @JsonKey(name: 'learning_resources')
          final List<LearningResource> learningResources,
          @JsonKey(name: 'is_saved') final bool isSaved,
          @JsonKey(name: 'user_match_score') final int? userMatchScore}) =
      _$CareerDetailEntityImpl;

  factory _CareerDetailEntity.fromJson(Map<String, dynamic> json) =
      _$CareerDetailEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(name: 'one_liner')
  String? get oneLiner;
  @override
  CareerDomainBrief? get domain;
  @override
  @JsonKey(name: 'dimension_tags')
  List<String> get dimensionTags;
  @override
  @JsonKey(name: 'india_viability')
  String? get indiaViability;
  @override
  @JsonKey(name: 'future_score')
  int get futureScore;
  @override
  @JsonKey(name: 'future_score_reasoning')
  String? get futureScoreReasoning;
  @override
  @JsonKey(name: 'typical_day')
  String? get typicalDay;
  @override
  @JsonKey(name: 'skills_needed')
  List<String> get skillsNeeded;
  @override
  @JsonKey(name: 'entry_paths')
  List<String> get entryPaths;
  @override
  @JsonKey(name: 'salary_entry_lpa')
  String? get salaryEntryLpa;
  @override
  @JsonKey(name: 'salary_mid_lpa')
  String? get salaryMidLpa;
  @override
  @JsonKey(name: 'salary_senior_lpa')
  String? get salarySeniorLpa;
  @override
  @JsonKey(name: 'is_emerging')
  bool get isEmerging;
  @override
  @JsonKey(name: 'last_reviewed_at')
  String? get lastReviewedAt;
  @override
  @JsonKey(name: 'related_careers')
  List<RelatedCareer> get relatedCareers;
  @override
  @JsonKey(name: 'real_people_stories')
  List<RealPeopleStory> get realPeopleStories;
  @override
  @JsonKey(name: 'learning_resources')
  List<LearningResource> get learningResources;
  @override
  @JsonKey(name: 'is_saved')
  bool get isSaved;
  @override
  @JsonKey(name: 'user_match_score')
  int? get userMatchScore;
  @override
  @JsonKey(ignore: true)
  _$$CareerDetailEntityImplCopyWith<_$CareerDetailEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
