// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendedCareerBrief _$RecommendedCareerBriefFromJson(
    Map<String, dynamic> json) {
  return _RecommendedCareerBrief.fromJson(json);
}

/// @nodoc
mixin _$RecommendedCareerBrief {
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'one_liner')
  String? get oneLiner => throw _privateConstructorUsedError;
  @JsonKey(name: 'dimension_tags')
  List<String> get dimensionTags => throw _privateConstructorUsedError;
  @JsonKey(name: 'domain_short_name')
  String? get domainShortName => throw _privateConstructorUsedError;
  @JsonKey(name: 'future_score')
  int get futureScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'india_viability')
  String? get indiaViability => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_entry_lpa')
  String? get salaryEntryLpa => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_emerging')
  bool get isEmerging => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecommendedCareerBriefCopyWith<RecommendedCareerBrief> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendedCareerBriefCopyWith<$Res> {
  factory $RecommendedCareerBriefCopyWith(RecommendedCareerBrief value,
          $Res Function(RecommendedCareerBrief) then) =
      _$RecommendedCareerBriefCopyWithImpl<$Res, RecommendedCareerBrief>;
  @useResult
  $Res call(
      {String slug,
      String name,
      @JsonKey(name: 'one_liner') String? oneLiner,
      @JsonKey(name: 'dimension_tags') List<String> dimensionTags,
      @JsonKey(name: 'domain_short_name') String? domainShortName,
      @JsonKey(name: 'future_score') int futureScore,
      @JsonKey(name: 'india_viability') String? indiaViability,
      @JsonKey(name: 'salary_entry_lpa') String? salaryEntryLpa,
      @JsonKey(name: 'is_emerging') bool isEmerging});
}

/// @nodoc
class _$RecommendedCareerBriefCopyWithImpl<$Res,
        $Val extends RecommendedCareerBrief>
    implements $RecommendedCareerBriefCopyWith<$Res> {
  _$RecommendedCareerBriefCopyWithImpl(this._value, this._then);

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
    Object? dimensionTags = null,
    Object? domainShortName = freezed,
    Object? futureScore = null,
    Object? indiaViability = freezed,
    Object? salaryEntryLpa = freezed,
    Object? isEmerging = null,
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
      dimensionTags: null == dimensionTags
          ? _value.dimensionTags
          : dimensionTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      domainShortName: freezed == domainShortName
          ? _value.domainShortName
          : domainShortName // ignore: cast_nullable_to_non_nullable
              as String?,
      futureScore: null == futureScore
          ? _value.futureScore
          : futureScore // ignore: cast_nullable_to_non_nullable
              as int,
      indiaViability: freezed == indiaViability
          ? _value.indiaViability
          : indiaViability // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryEntryLpa: freezed == salaryEntryLpa
          ? _value.salaryEntryLpa
          : salaryEntryLpa // ignore: cast_nullable_to_non_nullable
              as String?,
      isEmerging: null == isEmerging
          ? _value.isEmerging
          : isEmerging // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendedCareerBriefImplCopyWith<$Res>
    implements $RecommendedCareerBriefCopyWith<$Res> {
  factory _$$RecommendedCareerBriefImplCopyWith(
          _$RecommendedCareerBriefImpl value,
          $Res Function(_$RecommendedCareerBriefImpl) then) =
      __$$RecommendedCareerBriefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String slug,
      String name,
      @JsonKey(name: 'one_liner') String? oneLiner,
      @JsonKey(name: 'dimension_tags') List<String> dimensionTags,
      @JsonKey(name: 'domain_short_name') String? domainShortName,
      @JsonKey(name: 'future_score') int futureScore,
      @JsonKey(name: 'india_viability') String? indiaViability,
      @JsonKey(name: 'salary_entry_lpa') String? salaryEntryLpa,
      @JsonKey(name: 'is_emerging') bool isEmerging});
}

/// @nodoc
class __$$RecommendedCareerBriefImplCopyWithImpl<$Res>
    extends _$RecommendedCareerBriefCopyWithImpl<$Res,
        _$RecommendedCareerBriefImpl>
    implements _$$RecommendedCareerBriefImplCopyWith<$Res> {
  __$$RecommendedCareerBriefImplCopyWithImpl(
      _$RecommendedCareerBriefImpl _value,
      $Res Function(_$RecommendedCareerBriefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? oneLiner = freezed,
    Object? dimensionTags = null,
    Object? domainShortName = freezed,
    Object? futureScore = null,
    Object? indiaViability = freezed,
    Object? salaryEntryLpa = freezed,
    Object? isEmerging = null,
  }) {
    return _then(_$RecommendedCareerBriefImpl(
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
      dimensionTags: null == dimensionTags
          ? _value._dimensionTags
          : dimensionTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      domainShortName: freezed == domainShortName
          ? _value.domainShortName
          : domainShortName // ignore: cast_nullable_to_non_nullable
              as String?,
      futureScore: null == futureScore
          ? _value.futureScore
          : futureScore // ignore: cast_nullable_to_non_nullable
              as int,
      indiaViability: freezed == indiaViability
          ? _value.indiaViability
          : indiaViability // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryEntryLpa: freezed == salaryEntryLpa
          ? _value.salaryEntryLpa
          : salaryEntryLpa // ignore: cast_nullable_to_non_nullable
              as String?,
      isEmerging: null == isEmerging
          ? _value.isEmerging
          : isEmerging // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendedCareerBriefImpl implements _RecommendedCareerBrief {
  const _$RecommendedCareerBriefImpl(
      {required this.slug,
      required this.name,
      @JsonKey(name: 'one_liner') this.oneLiner,
      @JsonKey(name: 'dimension_tags')
      final List<String> dimensionTags = const [],
      @JsonKey(name: 'domain_short_name') this.domainShortName,
      @JsonKey(name: 'future_score') this.futureScore = 0,
      @JsonKey(name: 'india_viability') this.indiaViability,
      @JsonKey(name: 'salary_entry_lpa') this.salaryEntryLpa,
      @JsonKey(name: 'is_emerging') this.isEmerging = false})
      : _dimensionTags = dimensionTags;

  factory _$RecommendedCareerBriefImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendedCareerBriefImplFromJson(json);

  @override
  final String slug;
  @override
  final String name;
  @override
  @JsonKey(name: 'one_liner')
  final String? oneLiner;
  final List<String> _dimensionTags;
  @override
  @JsonKey(name: 'dimension_tags')
  List<String> get dimensionTags {
    if (_dimensionTags is EqualUnmodifiableListView) return _dimensionTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dimensionTags);
  }

  @override
  @JsonKey(name: 'domain_short_name')
  final String? domainShortName;
  @override
  @JsonKey(name: 'future_score')
  final int futureScore;
  @override
  @JsonKey(name: 'india_viability')
  final String? indiaViability;
  @override
  @JsonKey(name: 'salary_entry_lpa')
  final String? salaryEntryLpa;
  @override
  @JsonKey(name: 'is_emerging')
  final bool isEmerging;

  @override
  String toString() {
    return 'RecommendedCareerBrief(slug: $slug, name: $name, oneLiner: $oneLiner, dimensionTags: $dimensionTags, domainShortName: $domainShortName, futureScore: $futureScore, indiaViability: $indiaViability, salaryEntryLpa: $salaryEntryLpa, isEmerging: $isEmerging)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendedCareerBriefImpl &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.oneLiner, oneLiner) ||
                other.oneLiner == oneLiner) &&
            const DeepCollectionEquality()
                .equals(other._dimensionTags, _dimensionTags) &&
            (identical(other.domainShortName, domainShortName) ||
                other.domainShortName == domainShortName) &&
            (identical(other.futureScore, futureScore) ||
                other.futureScore == futureScore) &&
            (identical(other.indiaViability, indiaViability) ||
                other.indiaViability == indiaViability) &&
            (identical(other.salaryEntryLpa, salaryEntryLpa) ||
                other.salaryEntryLpa == salaryEntryLpa) &&
            (identical(other.isEmerging, isEmerging) ||
                other.isEmerging == isEmerging));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      slug,
      name,
      oneLiner,
      const DeepCollectionEquality().hash(_dimensionTags),
      domainShortName,
      futureScore,
      indiaViability,
      salaryEntryLpa,
      isEmerging);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendedCareerBriefImplCopyWith<_$RecommendedCareerBriefImpl>
      get copyWith => __$$RecommendedCareerBriefImplCopyWithImpl<
          _$RecommendedCareerBriefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendedCareerBriefImplToJson(
      this,
    );
  }
}

abstract class _RecommendedCareerBrief implements RecommendedCareerBrief {
  const factory _RecommendedCareerBrief(
          {required final String slug,
          required final String name,
          @JsonKey(name: 'one_liner') final String? oneLiner,
          @JsonKey(name: 'dimension_tags') final List<String> dimensionTags,
          @JsonKey(name: 'domain_short_name') final String? domainShortName,
          @JsonKey(name: 'future_score') final int futureScore,
          @JsonKey(name: 'india_viability') final String? indiaViability,
          @JsonKey(name: 'salary_entry_lpa') final String? salaryEntryLpa,
          @JsonKey(name: 'is_emerging') final bool isEmerging}) =
      _$RecommendedCareerBriefImpl;

  factory _RecommendedCareerBrief.fromJson(Map<String, dynamic> json) =
      _$RecommendedCareerBriefImpl.fromJson;

  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(name: 'one_liner')
  String? get oneLiner;
  @override
  @JsonKey(name: 'dimension_tags')
  List<String> get dimensionTags;
  @override
  @JsonKey(name: 'domain_short_name')
  String? get domainShortName;
  @override
  @JsonKey(name: 'future_score')
  int get futureScore;
  @override
  @JsonKey(name: 'india_viability')
  String? get indiaViability;
  @override
  @JsonKey(name: 'salary_entry_lpa')
  String? get salaryEntryLpa;
  @override
  @JsonKey(name: 'is_emerging')
  bool get isEmerging;
  @override
  @JsonKey(ignore: true)
  _$$RecommendedCareerBriefImplCopyWith<_$RecommendedCareerBriefImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RecommendationItem _$RecommendationItemFromJson(Map<String, dynamic> json) {
  return _RecommendationItem.fromJson(json);
}

/// @nodoc
mixin _$RecommendationItem {
  int get rank => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_score')
  int get matchScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_tier')
  String? get matchTier => throw _privateConstructorUsedError;
  @JsonKey(name: 'tag_overlap_count')
  int get tagOverlapCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_novel')
  bool get isNovel => throw _privateConstructorUsedError;
  RecommendedCareerBrief get career => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecommendationItemCopyWith<RecommendationItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationItemCopyWith<$Res> {
  factory $RecommendationItemCopyWith(
          RecommendationItem value, $Res Function(RecommendationItem) then) =
      _$RecommendationItemCopyWithImpl<$Res, RecommendationItem>;
  @useResult
  $Res call(
      {int rank,
      @JsonKey(name: 'match_score') int matchScore,
      @JsonKey(name: 'match_tier') String? matchTier,
      @JsonKey(name: 'tag_overlap_count') int tagOverlapCount,
      @JsonKey(name: 'is_novel') bool isNovel,
      RecommendedCareerBrief career});

  $RecommendedCareerBriefCopyWith<$Res> get career;
}

/// @nodoc
class _$RecommendationItemCopyWithImpl<$Res, $Val extends RecommendationItem>
    implements $RecommendationItemCopyWith<$Res> {
  _$RecommendationItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? matchScore = null,
    Object? matchTier = freezed,
    Object? tagOverlapCount = null,
    Object? isNovel = null,
    Object? career = null,
  }) {
    return _then(_value.copyWith(
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchTier: freezed == matchTier
          ? _value.matchTier
          : matchTier // ignore: cast_nullable_to_non_nullable
              as String?,
      tagOverlapCount: null == tagOverlapCount
          ? _value.tagOverlapCount
          : tagOverlapCount // ignore: cast_nullable_to_non_nullable
              as int,
      isNovel: null == isNovel
          ? _value.isNovel
          : isNovel // ignore: cast_nullable_to_non_nullable
              as bool,
      career: null == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as RecommendedCareerBrief,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RecommendedCareerBriefCopyWith<$Res> get career {
    return $RecommendedCareerBriefCopyWith<$Res>(_value.career, (value) {
      return _then(_value.copyWith(career: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendationItemImplCopyWith<$Res>
    implements $RecommendationItemCopyWith<$Res> {
  factory _$$RecommendationItemImplCopyWith(_$RecommendationItemImpl value,
          $Res Function(_$RecommendationItemImpl) then) =
      __$$RecommendationItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int rank,
      @JsonKey(name: 'match_score') int matchScore,
      @JsonKey(name: 'match_tier') String? matchTier,
      @JsonKey(name: 'tag_overlap_count') int tagOverlapCount,
      @JsonKey(name: 'is_novel') bool isNovel,
      RecommendedCareerBrief career});

  @override
  $RecommendedCareerBriefCopyWith<$Res> get career;
}

/// @nodoc
class __$$RecommendationItemImplCopyWithImpl<$Res>
    extends _$RecommendationItemCopyWithImpl<$Res, _$RecommendationItemImpl>
    implements _$$RecommendationItemImplCopyWith<$Res> {
  __$$RecommendationItemImplCopyWithImpl(_$RecommendationItemImpl _value,
      $Res Function(_$RecommendationItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? matchScore = null,
    Object? matchTier = freezed,
    Object? tagOverlapCount = null,
    Object? isNovel = null,
    Object? career = null,
  }) {
    return _then(_$RecommendationItemImpl(
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchTier: freezed == matchTier
          ? _value.matchTier
          : matchTier // ignore: cast_nullable_to_non_nullable
              as String?,
      tagOverlapCount: null == tagOverlapCount
          ? _value.tagOverlapCount
          : tagOverlapCount // ignore: cast_nullable_to_non_nullable
              as int,
      isNovel: null == isNovel
          ? _value.isNovel
          : isNovel // ignore: cast_nullable_to_non_nullable
              as bool,
      career: null == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as RecommendedCareerBrief,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationItemImpl implements _RecommendationItem {
  const _$RecommendationItemImpl(
      {this.rank = 0,
      @JsonKey(name: 'match_score') this.matchScore = 0,
      @JsonKey(name: 'match_tier') this.matchTier,
      @JsonKey(name: 'tag_overlap_count') this.tagOverlapCount = 0,
      @JsonKey(name: 'is_novel') this.isNovel = false,
      required this.career});

  factory _$RecommendationItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationItemImplFromJson(json);

  @override
  @JsonKey()
  final int rank;
  @override
  @JsonKey(name: 'match_score')
  final int matchScore;
  @override
  @JsonKey(name: 'match_tier')
  final String? matchTier;
  @override
  @JsonKey(name: 'tag_overlap_count')
  final int tagOverlapCount;
  @override
  @JsonKey(name: 'is_novel')
  final bool isNovel;
  @override
  final RecommendedCareerBrief career;

  @override
  String toString() {
    return 'RecommendationItem(rank: $rank, matchScore: $matchScore, matchTier: $matchTier, tagOverlapCount: $tagOverlapCount, isNovel: $isNovel, career: $career)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationItemImpl &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore) &&
            (identical(other.matchTier, matchTier) ||
                other.matchTier == matchTier) &&
            (identical(other.tagOverlapCount, tagOverlapCount) ||
                other.tagOverlapCount == tagOverlapCount) &&
            (identical(other.isNovel, isNovel) || other.isNovel == isNovel) &&
            (identical(other.career, career) || other.career == career));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, rank, matchScore, matchTier,
      tagOverlapCount, isNovel, career);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationItemImplCopyWith<_$RecommendationItemImpl> get copyWith =>
      __$$RecommendationItemImplCopyWithImpl<_$RecommendationItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationItemImplToJson(
      this,
    );
  }
}

abstract class _RecommendationItem implements RecommendationItem {
  const factory _RecommendationItem(
      {final int rank,
      @JsonKey(name: 'match_score') final int matchScore,
      @JsonKey(name: 'match_tier') final String? matchTier,
      @JsonKey(name: 'tag_overlap_count') final int tagOverlapCount,
      @JsonKey(name: 'is_novel') final bool isNovel,
      required final RecommendedCareerBrief career}) = _$RecommendationItemImpl;

  factory _RecommendationItem.fromJson(Map<String, dynamic> json) =
      _$RecommendationItemImpl.fromJson;

  @override
  int get rank;
  @override
  @JsonKey(name: 'match_score')
  int get matchScore;
  @override
  @JsonKey(name: 'match_tier')
  String? get matchTier;
  @override
  @JsonKey(name: 'tag_overlap_count')
  int get tagOverlapCount;
  @override
  @JsonKey(name: 'is_novel')
  bool get isNovel;
  @override
  RecommendedCareerBrief get career;
  @override
  @JsonKey(ignore: true)
  _$$RecommendationItemImplCopyWith<_$RecommendationItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecommendationsResponse _$RecommendationsResponseFromJson(
    Map<String, dynamic> json) {
  return _RecommendationsResponse.fromJson(json);
}

/// @nodoc
mixin _$RecommendationsResponse {
  @JsonKey(name: 'interest_profile_id')
  String? get interestProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  String? get generatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_matches')
  int get totalMatches => throw _privateConstructorUsedError;
  List<RecommendationItem> get recommendations =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecommendationsResponseCopyWith<RecommendationsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationsResponseCopyWith<$Res> {
  factory $RecommendationsResponseCopyWith(RecommendationsResponse value,
          $Res Function(RecommendationsResponse) then) =
      _$RecommendationsResponseCopyWithImpl<$Res, RecommendationsResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'interest_profile_id') String? interestProfileId,
      @JsonKey(name: 'generated_at') String? generatedAt,
      @JsonKey(name: 'total_matches') int totalMatches,
      List<RecommendationItem> recommendations});
}

/// @nodoc
class _$RecommendationsResponseCopyWithImpl<$Res,
        $Val extends RecommendationsResponse>
    implements $RecommendationsResponseCopyWith<$Res> {
  _$RecommendationsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interestProfileId = freezed,
    Object? generatedAt = freezed,
    Object? totalMatches = null,
    Object? recommendations = null,
  }) {
    return _then(_value.copyWith(
      interestProfileId: freezed == interestProfileId
          ? _value.interestProfileId
          : interestProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      totalMatches: null == totalMatches
          ? _value.totalMatches
          : totalMatches // ignore: cast_nullable_to_non_nullable
              as int,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<RecommendationItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationsResponseImplCopyWith<$Res>
    implements $RecommendationsResponseCopyWith<$Res> {
  factory _$$RecommendationsResponseImplCopyWith(
          _$RecommendationsResponseImpl value,
          $Res Function(_$RecommendationsResponseImpl) then) =
      __$$RecommendationsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'interest_profile_id') String? interestProfileId,
      @JsonKey(name: 'generated_at') String? generatedAt,
      @JsonKey(name: 'total_matches') int totalMatches,
      List<RecommendationItem> recommendations});
}

/// @nodoc
class __$$RecommendationsResponseImplCopyWithImpl<$Res>
    extends _$RecommendationsResponseCopyWithImpl<$Res,
        _$RecommendationsResponseImpl>
    implements _$$RecommendationsResponseImplCopyWith<$Res> {
  __$$RecommendationsResponseImplCopyWithImpl(
      _$RecommendationsResponseImpl _value,
      $Res Function(_$RecommendationsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interestProfileId = freezed,
    Object? generatedAt = freezed,
    Object? totalMatches = null,
    Object? recommendations = null,
  }) {
    return _then(_$RecommendationsResponseImpl(
      interestProfileId: freezed == interestProfileId
          ? _value.interestProfileId
          : interestProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      totalMatches: null == totalMatches
          ? _value.totalMatches
          : totalMatches // ignore: cast_nullable_to_non_nullable
              as int,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<RecommendationItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationsResponseImpl implements _RecommendationsResponse {
  const _$RecommendationsResponseImpl(
      {@JsonKey(name: 'interest_profile_id') this.interestProfileId,
      @JsonKey(name: 'generated_at') this.generatedAt,
      @JsonKey(name: 'total_matches') this.totalMatches = 0,
      final List<RecommendationItem> recommendations = const []})
      : _recommendations = recommendations;

  factory _$RecommendationsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationsResponseImplFromJson(json);

  @override
  @JsonKey(name: 'interest_profile_id')
  final String? interestProfileId;
  @override
  @JsonKey(name: 'generated_at')
  final String? generatedAt;
  @override
  @JsonKey(name: 'total_matches')
  final int totalMatches;
  final List<RecommendationItem> _recommendations;
  @override
  @JsonKey()
  List<RecommendationItem> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  String toString() {
    return 'RecommendationsResponse(interestProfileId: $interestProfileId, generatedAt: $generatedAt, totalMatches: $totalMatches, recommendations: $recommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationsResponseImpl &&
            (identical(other.interestProfileId, interestProfileId) ||
                other.interestProfileId == interestProfileId) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.totalMatches, totalMatches) ||
                other.totalMatches == totalMatches) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, interestProfileId, generatedAt,
      totalMatches, const DeepCollectionEquality().hash(_recommendations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationsResponseImplCopyWith<_$RecommendationsResponseImpl>
      get copyWith => __$$RecommendationsResponseImplCopyWithImpl<
          _$RecommendationsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationsResponseImplToJson(
      this,
    );
  }
}

abstract class _RecommendationsResponse implements RecommendationsResponse {
  const factory _RecommendationsResponse(
      {@JsonKey(name: 'interest_profile_id') final String? interestProfileId,
      @JsonKey(name: 'generated_at') final String? generatedAt,
      @JsonKey(name: 'total_matches') final int totalMatches,
      final List<RecommendationItem>
          recommendations}) = _$RecommendationsResponseImpl;

  factory _RecommendationsResponse.fromJson(Map<String, dynamic> json) =
      _$RecommendationsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'interest_profile_id')
  String? get interestProfileId;
  @override
  @JsonKey(name: 'generated_at')
  String? get generatedAt;
  @override
  @JsonKey(name: 'total_matches')
  int get totalMatches;
  @override
  List<RecommendationItem> get recommendations;
  @override
  @JsonKey(ignore: true)
  _$$RecommendationsResponseImplCopyWith<_$RecommendationsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SavedCareerItem _$SavedCareerItemFromJson(Map<String, dynamic> json) {
  return _SavedCareerItem.fromJson(json);
}

/// @nodoc
mixin _$SavedCareerItem {
  @JsonKey(name: 'save_id')
  String get saveId => throw _privateConstructorUsedError;
  @JsonKey(name: 'saved_at')
  String? get savedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  RecommendedCareerBrief get career => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SavedCareerItemCopyWith<SavedCareerItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedCareerItemCopyWith<$Res> {
  factory $SavedCareerItemCopyWith(
          SavedCareerItem value, $Res Function(SavedCareerItem) then) =
      _$SavedCareerItemCopyWithImpl<$Res, SavedCareerItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'save_id') String saveId,
      @JsonKey(name: 'saved_at') String? savedAt,
      String? notes,
      RecommendedCareerBrief career});

  $RecommendedCareerBriefCopyWith<$Res> get career;
}

/// @nodoc
class _$SavedCareerItemCopyWithImpl<$Res, $Val extends SavedCareerItem>
    implements $SavedCareerItemCopyWith<$Res> {
  _$SavedCareerItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? saveId = null,
    Object? savedAt = freezed,
    Object? notes = freezed,
    Object? career = null,
  }) {
    return _then(_value.copyWith(
      saveId: null == saveId
          ? _value.saveId
          : saveId // ignore: cast_nullable_to_non_nullable
              as String,
      savedAt: freezed == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      career: null == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as RecommendedCareerBrief,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RecommendedCareerBriefCopyWith<$Res> get career {
    return $RecommendedCareerBriefCopyWith<$Res>(_value.career, (value) {
      return _then(_value.copyWith(career: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SavedCareerItemImplCopyWith<$Res>
    implements $SavedCareerItemCopyWith<$Res> {
  factory _$$SavedCareerItemImplCopyWith(_$SavedCareerItemImpl value,
          $Res Function(_$SavedCareerItemImpl) then) =
      __$$SavedCareerItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'save_id') String saveId,
      @JsonKey(name: 'saved_at') String? savedAt,
      String? notes,
      RecommendedCareerBrief career});

  @override
  $RecommendedCareerBriefCopyWith<$Res> get career;
}

/// @nodoc
class __$$SavedCareerItemImplCopyWithImpl<$Res>
    extends _$SavedCareerItemCopyWithImpl<$Res, _$SavedCareerItemImpl>
    implements _$$SavedCareerItemImplCopyWith<$Res> {
  __$$SavedCareerItemImplCopyWithImpl(
      _$SavedCareerItemImpl _value, $Res Function(_$SavedCareerItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? saveId = null,
    Object? savedAt = freezed,
    Object? notes = freezed,
    Object? career = null,
  }) {
    return _then(_$SavedCareerItemImpl(
      saveId: null == saveId
          ? _value.saveId
          : saveId // ignore: cast_nullable_to_non_nullable
              as String,
      savedAt: freezed == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      career: null == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as RecommendedCareerBrief,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedCareerItemImpl implements _SavedCareerItem {
  const _$SavedCareerItemImpl(
      {@JsonKey(name: 'save_id') required this.saveId,
      @JsonKey(name: 'saved_at') this.savedAt,
      this.notes,
      required this.career});

  factory _$SavedCareerItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedCareerItemImplFromJson(json);

  @override
  @JsonKey(name: 'save_id')
  final String saveId;
  @override
  @JsonKey(name: 'saved_at')
  final String? savedAt;
  @override
  final String? notes;
  @override
  final RecommendedCareerBrief career;

  @override
  String toString() {
    return 'SavedCareerItem(saveId: $saveId, savedAt: $savedAt, notes: $notes, career: $career)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedCareerItemImpl &&
            (identical(other.saveId, saveId) || other.saveId == saveId) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.career, career) || other.career == career));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, saveId, savedAt, notes, career);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedCareerItemImplCopyWith<_$SavedCareerItemImpl> get copyWith =>
      __$$SavedCareerItemImplCopyWithImpl<_$SavedCareerItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedCareerItemImplToJson(
      this,
    );
  }
}

abstract class _SavedCareerItem implements SavedCareerItem {
  const factory _SavedCareerItem(
      {@JsonKey(name: 'save_id') required final String saveId,
      @JsonKey(name: 'saved_at') final String? savedAt,
      final String? notes,
      required final RecommendedCareerBrief career}) = _$SavedCareerItemImpl;

  factory _SavedCareerItem.fromJson(Map<String, dynamic> json) =
      _$SavedCareerItemImpl.fromJson;

  @override
  @JsonKey(name: 'save_id')
  String get saveId;
  @override
  @JsonKey(name: 'saved_at')
  String? get savedAt;
  @override
  String? get notes;
  @override
  RecommendedCareerBrief get career;
  @override
  @JsonKey(ignore: true)
  _$$SavedCareerItemImplCopyWith<_$SavedCareerItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
