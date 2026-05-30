// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roadmap_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoadmapCareerBrief _$RoadmapCareerBriefFromJson(Map<String, dynamic> json) {
  return _RoadmapCareerBrief.fromJson(json);
}

/// @nodoc
mixin _$RoadmapCareerBrief {
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'domain_short_name')
  String? get domainShortName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoadmapCareerBriefCopyWith<RoadmapCareerBrief> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoadmapCareerBriefCopyWith<$Res> {
  factory $RoadmapCareerBriefCopyWith(
          RoadmapCareerBrief value, $Res Function(RoadmapCareerBrief) then) =
      _$RoadmapCareerBriefCopyWithImpl<$Res, RoadmapCareerBrief>;
  @useResult
  $Res call(
      {String slug,
      String name,
      @JsonKey(name: 'domain_short_name') String? domainShortName});
}

/// @nodoc
class _$RoadmapCareerBriefCopyWithImpl<$Res, $Val extends RoadmapCareerBrief>
    implements $RoadmapCareerBriefCopyWith<$Res> {
  _$RoadmapCareerBriefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? domainShortName = freezed,
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
      domainShortName: freezed == domainShortName
          ? _value.domainShortName
          : domainShortName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoadmapCareerBriefImplCopyWith<$Res>
    implements $RoadmapCareerBriefCopyWith<$Res> {
  factory _$$RoadmapCareerBriefImplCopyWith(_$RoadmapCareerBriefImpl value,
          $Res Function(_$RoadmapCareerBriefImpl) then) =
      __$$RoadmapCareerBriefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String slug,
      String name,
      @JsonKey(name: 'domain_short_name') String? domainShortName});
}

/// @nodoc
class __$$RoadmapCareerBriefImplCopyWithImpl<$Res>
    extends _$RoadmapCareerBriefCopyWithImpl<$Res, _$RoadmapCareerBriefImpl>
    implements _$$RoadmapCareerBriefImplCopyWith<$Res> {
  __$$RoadmapCareerBriefImplCopyWithImpl(_$RoadmapCareerBriefImpl _value,
      $Res Function(_$RoadmapCareerBriefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? domainShortName = freezed,
  }) {
    return _then(_$RoadmapCareerBriefImpl(
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      domainShortName: freezed == domainShortName
          ? _value.domainShortName
          : domainShortName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoadmapCareerBriefImpl implements _RoadmapCareerBrief {
  const _$RoadmapCareerBriefImpl(
      {required this.slug,
      required this.name,
      @JsonKey(name: 'domain_short_name') this.domainShortName});

  factory _$RoadmapCareerBriefImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoadmapCareerBriefImplFromJson(json);

  @override
  final String slug;
  @override
  final String name;
  @override
  @JsonKey(name: 'domain_short_name')
  final String? domainShortName;

  @override
  String toString() {
    return 'RoadmapCareerBrief(slug: $slug, name: $name, domainShortName: $domainShortName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoadmapCareerBriefImpl &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.domainShortName, domainShortName) ||
                other.domainShortName == domainShortName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, slug, name, domainShortName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoadmapCareerBriefImplCopyWith<_$RoadmapCareerBriefImpl> get copyWith =>
      __$$RoadmapCareerBriefImplCopyWithImpl<_$RoadmapCareerBriefImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoadmapCareerBriefImplToJson(
      this,
    );
  }
}

abstract class _RoadmapCareerBrief implements RoadmapCareerBrief {
  const factory _RoadmapCareerBrief(
          {required final String slug,
          required final String name,
          @JsonKey(name: 'domain_short_name') final String? domainShortName}) =
      _$RoadmapCareerBriefImpl;

  factory _RoadmapCareerBrief.fromJson(Map<String, dynamic> json) =
      _$RoadmapCareerBriefImpl.fromJson;

  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(name: 'domain_short_name')
  String? get domainShortName;
  @override
  @JsonKey(ignore: true)
  _$$RoadmapCareerBriefImplCopyWith<_$RoadmapCareerBriefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoadmapStep _$RoadmapStepFromJson(Map<String, dynamic> json) {
  return _RoadmapStep.fromJson(json);
}

/// @nodoc
mixin _$RoadmapStep {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'step_order')
  int get stepOrder => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get timeframe => throw _privateConstructorUsedError;
  @JsonKey(name: 'resource_url')
  String? get resourceUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'resource_label')
  String? get resourceLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_premium')
  bool get isPremium => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  String? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoadmapStepCopyWith<RoadmapStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoadmapStepCopyWith<$Res> {
  factory $RoadmapStepCopyWith(
          RoadmapStep value, $Res Function(RoadmapStep) then) =
      _$RoadmapStepCopyWithImpl<$Res, RoadmapStep>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'step_order') int stepOrder,
      String category,
      String title,
      String description,
      String? timeframe,
      @JsonKey(name: 'resource_url') String? resourceUrl,
      @JsonKey(name: 'resource_label') String? resourceLabel,
      @JsonKey(name: 'is_premium') bool isPremium,
      String status,
      @JsonKey(name: 'completed_at') String? completedAt});
}

/// @nodoc
class _$RoadmapStepCopyWithImpl<$Res, $Val extends RoadmapStep>
    implements $RoadmapStepCopyWith<$Res> {
  _$RoadmapStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stepOrder = null,
    Object? category = null,
    Object? title = null,
    Object? description = null,
    Object? timeframe = freezed,
    Object? resourceUrl = freezed,
    Object? resourceLabel = freezed,
    Object? isPremium = null,
    Object? status = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      stepOrder: null == stepOrder
          ? _value.stepOrder
          : stepOrder // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timeframe: freezed == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceUrl: freezed == resourceUrl
          ? _value.resourceUrl
          : resourceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceLabel: freezed == resourceLabel
          ? _value.resourceLabel
          : resourceLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoadmapStepImplCopyWith<$Res>
    implements $RoadmapStepCopyWith<$Res> {
  factory _$$RoadmapStepImplCopyWith(
          _$RoadmapStepImpl value, $Res Function(_$RoadmapStepImpl) then) =
      __$$RoadmapStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'step_order') int stepOrder,
      String category,
      String title,
      String description,
      String? timeframe,
      @JsonKey(name: 'resource_url') String? resourceUrl,
      @JsonKey(name: 'resource_label') String? resourceLabel,
      @JsonKey(name: 'is_premium') bool isPremium,
      String status,
      @JsonKey(name: 'completed_at') String? completedAt});
}

/// @nodoc
class __$$RoadmapStepImplCopyWithImpl<$Res>
    extends _$RoadmapStepCopyWithImpl<$Res, _$RoadmapStepImpl>
    implements _$$RoadmapStepImplCopyWith<$Res> {
  __$$RoadmapStepImplCopyWithImpl(
      _$RoadmapStepImpl _value, $Res Function(_$RoadmapStepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stepOrder = null,
    Object? category = null,
    Object? title = null,
    Object? description = null,
    Object? timeframe = freezed,
    Object? resourceUrl = freezed,
    Object? resourceLabel = freezed,
    Object? isPremium = null,
    Object? status = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$RoadmapStepImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      stepOrder: null == stepOrder
          ? _value.stepOrder
          : stepOrder // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timeframe: freezed == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceUrl: freezed == resourceUrl
          ? _value.resourceUrl
          : resourceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceLabel: freezed == resourceLabel
          ? _value.resourceLabel
          : resourceLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoadmapStepImpl implements _RoadmapStep {
  const _$RoadmapStepImpl(
      {required this.id,
      @JsonKey(name: 'step_order') this.stepOrder = 0,
      this.category = '',
      this.title = '',
      this.description = '',
      this.timeframe,
      @JsonKey(name: 'resource_url') this.resourceUrl,
      @JsonKey(name: 'resource_label') this.resourceLabel,
      @JsonKey(name: 'is_premium') this.isPremium = false,
      this.status = 'not_started',
      @JsonKey(name: 'completed_at') this.completedAt});

  factory _$RoadmapStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoadmapStepImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'step_order')
  final int stepOrder;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  final String? timeframe;
  @override
  @JsonKey(name: 'resource_url')
  final String? resourceUrl;
  @override
  @JsonKey(name: 'resource_label')
  final String? resourceLabel;
  @override
  @JsonKey(name: 'is_premium')
  final bool isPremium;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'completed_at')
  final String? completedAt;

  @override
  String toString() {
    return 'RoadmapStep(id: $id, stepOrder: $stepOrder, category: $category, title: $title, description: $description, timeframe: $timeframe, resourceUrl: $resourceUrl, resourceLabel: $resourceLabel, isPremium: $isPremium, status: $status, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoadmapStepImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stepOrder, stepOrder) ||
                other.stepOrder == stepOrder) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe) &&
            (identical(other.resourceUrl, resourceUrl) ||
                other.resourceUrl == resourceUrl) &&
            (identical(other.resourceLabel, resourceLabel) ||
                other.resourceLabel == resourceLabel) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      stepOrder,
      category,
      title,
      description,
      timeframe,
      resourceUrl,
      resourceLabel,
      isPremium,
      status,
      completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoadmapStepImplCopyWith<_$RoadmapStepImpl> get copyWith =>
      __$$RoadmapStepImplCopyWithImpl<_$RoadmapStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoadmapStepImplToJson(
      this,
    );
  }
}

abstract class _RoadmapStep implements RoadmapStep {
  const factory _RoadmapStep(
          {required final String id,
          @JsonKey(name: 'step_order') final int stepOrder,
          final String category,
          final String title,
          final String description,
          final String? timeframe,
          @JsonKey(name: 'resource_url') final String? resourceUrl,
          @JsonKey(name: 'resource_label') final String? resourceLabel,
          @JsonKey(name: 'is_premium') final bool isPremium,
          final String status,
          @JsonKey(name: 'completed_at') final String? completedAt}) =
      _$RoadmapStepImpl;

  factory _RoadmapStep.fromJson(Map<String, dynamic> json) =
      _$RoadmapStepImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'step_order')
  int get stepOrder;
  @override
  String get category;
  @override
  String get title;
  @override
  String get description;
  @override
  String? get timeframe;
  @override
  @JsonKey(name: 'resource_url')
  String? get resourceUrl;
  @override
  @JsonKey(name: 'resource_label')
  String? get resourceLabel;
  @override
  @JsonKey(name: 'is_premium')
  bool get isPremium;
  @override
  String get status;
  @override
  @JsonKey(name: 'completed_at')
  String? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$RoadmapStepImplCopyWith<_$RoadmapStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoadmapListItem _$RoadmapListItemFromJson(Map<String, dynamic> json) {
  return _RoadmapListItem.fromJson(json);
}

/// @nodoc
mixin _$RoadmapListItem {
  String get id => throw _privateConstructorUsedError;
  RoadmapCareerBrief get career => throw _privateConstructorUsedError;
  @JsonKey(name: 'academic_stage')
  String? get academicStage => throw _privateConstructorUsedError;
  @JsonKey(name: 'generation_method')
  String? get generationMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_steps')
  int get totalSteps => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_steps')
  int get completedSteps => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_percent')
  int get completionPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  String? get generatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoadmapListItemCopyWith<RoadmapListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoadmapListItemCopyWith<$Res> {
  factory $RoadmapListItemCopyWith(
          RoadmapListItem value, $Res Function(RoadmapListItem) then) =
      _$RoadmapListItemCopyWithImpl<$Res, RoadmapListItem>;
  @useResult
  $Res call(
      {String id,
      RoadmapCareerBrief career,
      @JsonKey(name: 'academic_stage') String? academicStage,
      @JsonKey(name: 'generation_method') String? generationMethod,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'total_steps') int totalSteps,
      @JsonKey(name: 'completed_steps') int completedSteps,
      @JsonKey(name: 'completion_percent') int completionPercent,
      @JsonKey(name: 'generated_at') String? generatedAt});

  $RoadmapCareerBriefCopyWith<$Res> get career;
}

/// @nodoc
class _$RoadmapListItemCopyWithImpl<$Res, $Val extends RoadmapListItem>
    implements $RoadmapListItemCopyWith<$Res> {
  _$RoadmapListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? career = null,
    Object? academicStage = freezed,
    Object? generationMethod = freezed,
    Object? isActive = null,
    Object? totalSteps = null,
    Object? completedSteps = null,
    Object? completionPercent = null,
    Object? generatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      career: null == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as RoadmapCareerBrief,
      academicStage: freezed == academicStage
          ? _value.academicStage
          : academicStage // ignore: cast_nullable_to_non_nullable
              as String?,
      generationMethod: freezed == generationMethod
          ? _value.generationMethod
          : generationMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      completedSteps: null == completedSteps
          ? _value.completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as int,
      completionPercent: null == completionPercent
          ? _value.completionPercent
          : completionPercent // ignore: cast_nullable_to_non_nullable
              as int,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RoadmapCareerBriefCopyWith<$Res> get career {
    return $RoadmapCareerBriefCopyWith<$Res>(_value.career, (value) {
      return _then(_value.copyWith(career: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoadmapListItemImplCopyWith<$Res>
    implements $RoadmapListItemCopyWith<$Res> {
  factory _$$RoadmapListItemImplCopyWith(_$RoadmapListItemImpl value,
          $Res Function(_$RoadmapListItemImpl) then) =
      __$$RoadmapListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      RoadmapCareerBrief career,
      @JsonKey(name: 'academic_stage') String? academicStage,
      @JsonKey(name: 'generation_method') String? generationMethod,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'total_steps') int totalSteps,
      @JsonKey(name: 'completed_steps') int completedSteps,
      @JsonKey(name: 'completion_percent') int completionPercent,
      @JsonKey(name: 'generated_at') String? generatedAt});

  @override
  $RoadmapCareerBriefCopyWith<$Res> get career;
}

/// @nodoc
class __$$RoadmapListItemImplCopyWithImpl<$Res>
    extends _$RoadmapListItemCopyWithImpl<$Res, _$RoadmapListItemImpl>
    implements _$$RoadmapListItemImplCopyWith<$Res> {
  __$$RoadmapListItemImplCopyWithImpl(
      _$RoadmapListItemImpl _value, $Res Function(_$RoadmapListItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? career = null,
    Object? academicStage = freezed,
    Object? generationMethod = freezed,
    Object? isActive = null,
    Object? totalSteps = null,
    Object? completedSteps = null,
    Object? completionPercent = null,
    Object? generatedAt = freezed,
  }) {
    return _then(_$RoadmapListItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      career: null == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as RoadmapCareerBrief,
      academicStage: freezed == academicStage
          ? _value.academicStage
          : academicStage // ignore: cast_nullable_to_non_nullable
              as String?,
      generationMethod: freezed == generationMethod
          ? _value.generationMethod
          : generationMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      completedSteps: null == completedSteps
          ? _value.completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as int,
      completionPercent: null == completionPercent
          ? _value.completionPercent
          : completionPercent // ignore: cast_nullable_to_non_nullable
              as int,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoadmapListItemImpl implements _RoadmapListItem {
  const _$RoadmapListItemImpl(
      {required this.id,
      required this.career,
      @JsonKey(name: 'academic_stage') this.academicStage,
      @JsonKey(name: 'generation_method') this.generationMethod,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'total_steps') this.totalSteps = 0,
      @JsonKey(name: 'completed_steps') this.completedSteps = 0,
      @JsonKey(name: 'completion_percent') this.completionPercent = 0,
      @JsonKey(name: 'generated_at') this.generatedAt});

  factory _$RoadmapListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoadmapListItemImplFromJson(json);

  @override
  final String id;
  @override
  final RoadmapCareerBrief career;
  @override
  @JsonKey(name: 'academic_stage')
  final String? academicStage;
  @override
  @JsonKey(name: 'generation_method')
  final String? generationMethod;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'total_steps')
  final int totalSteps;
  @override
  @JsonKey(name: 'completed_steps')
  final int completedSteps;
  @override
  @JsonKey(name: 'completion_percent')
  final int completionPercent;
  @override
  @JsonKey(name: 'generated_at')
  final String? generatedAt;

  @override
  String toString() {
    return 'RoadmapListItem(id: $id, career: $career, academicStage: $academicStage, generationMethod: $generationMethod, isActive: $isActive, totalSteps: $totalSteps, completedSteps: $completedSteps, completionPercent: $completionPercent, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoadmapListItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.career, career) || other.career == career) &&
            (identical(other.academicStage, academicStage) ||
                other.academicStage == academicStage) &&
            (identical(other.generationMethod, generationMethod) ||
                other.generationMethod == generationMethod) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps) &&
            (identical(other.completedSteps, completedSteps) ||
                other.completedSteps == completedSteps) &&
            (identical(other.completionPercent, completionPercent) ||
                other.completionPercent == completionPercent) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      career,
      academicStage,
      generationMethod,
      isActive,
      totalSteps,
      completedSteps,
      completionPercent,
      generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoadmapListItemImplCopyWith<_$RoadmapListItemImpl> get copyWith =>
      __$$RoadmapListItemImplCopyWithImpl<_$RoadmapListItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoadmapListItemImplToJson(
      this,
    );
  }
}

abstract class _RoadmapListItem implements RoadmapListItem {
  const factory _RoadmapListItem(
          {required final String id,
          required final RoadmapCareerBrief career,
          @JsonKey(name: 'academic_stage') final String? academicStage,
          @JsonKey(name: 'generation_method') final String? generationMethod,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'total_steps') final int totalSteps,
          @JsonKey(name: 'completed_steps') final int completedSteps,
          @JsonKey(name: 'completion_percent') final int completionPercent,
          @JsonKey(name: 'generated_at') final String? generatedAt}) =
      _$RoadmapListItemImpl;

  factory _RoadmapListItem.fromJson(Map<String, dynamic> json) =
      _$RoadmapListItemImpl.fromJson;

  @override
  String get id;
  @override
  RoadmapCareerBrief get career;
  @override
  @JsonKey(name: 'academic_stage')
  String? get academicStage;
  @override
  @JsonKey(name: 'generation_method')
  String? get generationMethod;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'total_steps')
  int get totalSteps;
  @override
  @JsonKey(name: 'completed_steps')
  int get completedSteps;
  @override
  @JsonKey(name: 'completion_percent')
  int get completionPercent;
  @override
  @JsonKey(name: 'generated_at')
  String? get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$RoadmapListItemImplCopyWith<_$RoadmapListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoadmapDetail _$RoadmapDetailFromJson(Map<String, dynamic> json) {
  return _RoadmapDetail.fromJson(json);
}

/// @nodoc
mixin _$RoadmapDetail {
  String get id => throw _privateConstructorUsedError;
  RoadmapCareerBrief get career => throw _privateConstructorUsedError;
  @JsonKey(name: 'academic_stage')
  String? get academicStage => throw _privateConstructorUsedError;
  @JsonKey(name: 'generation_method')
  String? get generationMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  String? get generatedAt => throw _privateConstructorUsedError;
  List<RoadmapStep> get steps => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoadmapDetailCopyWith<RoadmapDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoadmapDetailCopyWith<$Res> {
  factory $RoadmapDetailCopyWith(
          RoadmapDetail value, $Res Function(RoadmapDetail) then) =
      _$RoadmapDetailCopyWithImpl<$Res, RoadmapDetail>;
  @useResult
  $Res call(
      {String id,
      RoadmapCareerBrief career,
      @JsonKey(name: 'academic_stage') String? academicStage,
      @JsonKey(name: 'generation_method') String? generationMethod,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'generated_at') String? generatedAt,
      List<RoadmapStep> steps});

  $RoadmapCareerBriefCopyWith<$Res> get career;
}

/// @nodoc
class _$RoadmapDetailCopyWithImpl<$Res, $Val extends RoadmapDetail>
    implements $RoadmapDetailCopyWith<$Res> {
  _$RoadmapDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? career = null,
    Object? academicStage = freezed,
    Object? generationMethod = freezed,
    Object? isActive = null,
    Object? generatedAt = freezed,
    Object? steps = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      career: null == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as RoadmapCareerBrief,
      academicStage: freezed == academicStage
          ? _value.academicStage
          : academicStage // ignore: cast_nullable_to_non_nullable
              as String?,
      generationMethod: freezed == generationMethod
          ? _value.generationMethod
          : generationMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RoadmapStep>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RoadmapCareerBriefCopyWith<$Res> get career {
    return $RoadmapCareerBriefCopyWith<$Res>(_value.career, (value) {
      return _then(_value.copyWith(career: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoadmapDetailImplCopyWith<$Res>
    implements $RoadmapDetailCopyWith<$Res> {
  factory _$$RoadmapDetailImplCopyWith(
          _$RoadmapDetailImpl value, $Res Function(_$RoadmapDetailImpl) then) =
      __$$RoadmapDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      RoadmapCareerBrief career,
      @JsonKey(name: 'academic_stage') String? academicStage,
      @JsonKey(name: 'generation_method') String? generationMethod,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'generated_at') String? generatedAt,
      List<RoadmapStep> steps});

  @override
  $RoadmapCareerBriefCopyWith<$Res> get career;
}

/// @nodoc
class __$$RoadmapDetailImplCopyWithImpl<$Res>
    extends _$RoadmapDetailCopyWithImpl<$Res, _$RoadmapDetailImpl>
    implements _$$RoadmapDetailImplCopyWith<$Res> {
  __$$RoadmapDetailImplCopyWithImpl(
      _$RoadmapDetailImpl _value, $Res Function(_$RoadmapDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? career = null,
    Object? academicStage = freezed,
    Object? generationMethod = freezed,
    Object? isActive = null,
    Object? generatedAt = freezed,
    Object? steps = null,
  }) {
    return _then(_$RoadmapDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      career: null == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as RoadmapCareerBrief,
      academicStage: freezed == academicStage
          ? _value.academicStage
          : academicStage // ignore: cast_nullable_to_non_nullable
              as String?,
      generationMethod: freezed == generationMethod
          ? _value.generationMethod
          : generationMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RoadmapStep>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoadmapDetailImpl implements _RoadmapDetail {
  const _$RoadmapDetailImpl(
      {required this.id,
      required this.career,
      @JsonKey(name: 'academic_stage') this.academicStage,
      @JsonKey(name: 'generation_method') this.generationMethod,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'generated_at') this.generatedAt,
      final List<RoadmapStep> steps = const []})
      : _steps = steps;

  factory _$RoadmapDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoadmapDetailImplFromJson(json);

  @override
  final String id;
  @override
  final RoadmapCareerBrief career;
  @override
  @JsonKey(name: 'academic_stage')
  final String? academicStage;
  @override
  @JsonKey(name: 'generation_method')
  final String? generationMethod;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'generated_at')
  final String? generatedAt;
  final List<RoadmapStep> _steps;
  @override
  @JsonKey()
  List<RoadmapStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  String toString() {
    return 'RoadmapDetail(id: $id, career: $career, academicStage: $academicStage, generationMethod: $generationMethod, isActive: $isActive, generatedAt: $generatedAt, steps: $steps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoadmapDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.career, career) || other.career == career) &&
            (identical(other.academicStage, academicStage) ||
                other.academicStage == academicStage) &&
            (identical(other.generationMethod, generationMethod) ||
                other.generationMethod == generationMethod) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            const DeepCollectionEquality().equals(other._steps, _steps));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      career,
      academicStage,
      generationMethod,
      isActive,
      generatedAt,
      const DeepCollectionEquality().hash(_steps));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoadmapDetailImplCopyWith<_$RoadmapDetailImpl> get copyWith =>
      __$$RoadmapDetailImplCopyWithImpl<_$RoadmapDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoadmapDetailImplToJson(
      this,
    );
  }
}

abstract class _RoadmapDetail implements RoadmapDetail {
  const factory _RoadmapDetail(
      {required final String id,
      required final RoadmapCareerBrief career,
      @JsonKey(name: 'academic_stage') final String? academicStage,
      @JsonKey(name: 'generation_method') final String? generationMethod,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'generated_at') final String? generatedAt,
      final List<RoadmapStep> steps}) = _$RoadmapDetailImpl;

  factory _RoadmapDetail.fromJson(Map<String, dynamic> json) =
      _$RoadmapDetailImpl.fromJson;

  @override
  String get id;
  @override
  RoadmapCareerBrief get career;
  @override
  @JsonKey(name: 'academic_stage')
  String? get academicStage;
  @override
  @JsonKey(name: 'generation_method')
  String? get generationMethod;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'generated_at')
  String? get generatedAt;
  @override
  List<RoadmapStep> get steps;
  @override
  @JsonKey(ignore: true)
  _$$RoadmapDetailImplCopyWith<_$RoadmapDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NextStepBrief _$NextStepBriefFromJson(Map<String, dynamic> json) {
  return _NextStepBrief.fromJson(json);
}

/// @nodoc
mixin _$NextStepBrief {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get timeframe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NextStepBriefCopyWith<NextStepBrief> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NextStepBriefCopyWith<$Res> {
  factory $NextStepBriefCopyWith(
          NextStepBrief value, $Res Function(NextStepBrief) then) =
      _$NextStepBriefCopyWithImpl<$Res, NextStepBrief>;
  @useResult
  $Res call({String id, String title, String category, String? timeframe});
}

/// @nodoc
class _$NextStepBriefCopyWithImpl<$Res, $Val extends NextStepBrief>
    implements $NextStepBriefCopyWith<$Res> {
  _$NextStepBriefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? timeframe = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      timeframe: freezed == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NextStepBriefImplCopyWith<$Res>
    implements $NextStepBriefCopyWith<$Res> {
  factory _$$NextStepBriefImplCopyWith(
          _$NextStepBriefImpl value, $Res Function(_$NextStepBriefImpl) then) =
      __$$NextStepBriefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, String category, String? timeframe});
}

/// @nodoc
class __$$NextStepBriefImplCopyWithImpl<$Res>
    extends _$NextStepBriefCopyWithImpl<$Res, _$NextStepBriefImpl>
    implements _$$NextStepBriefImplCopyWith<$Res> {
  __$$NextStepBriefImplCopyWithImpl(
      _$NextStepBriefImpl _value, $Res Function(_$NextStepBriefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? timeframe = freezed,
  }) {
    return _then(_$NextStepBriefImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      timeframe: freezed == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NextStepBriefImpl implements _NextStepBrief {
  const _$NextStepBriefImpl(
      {required this.id,
      required this.title,
      required this.category,
      this.timeframe});

  factory _$NextStepBriefImpl.fromJson(Map<String, dynamic> json) =>
      _$$NextStepBriefImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String category;
  @override
  final String? timeframe;

  @override
  String toString() {
    return 'NextStepBrief(id: $id, title: $title, category: $category, timeframe: $timeframe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NextStepBriefImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, category, timeframe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NextStepBriefImplCopyWith<_$NextStepBriefImpl> get copyWith =>
      __$$NextStepBriefImplCopyWithImpl<_$NextStepBriefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NextStepBriefImplToJson(
      this,
    );
  }
}

abstract class _NextStepBrief implements NextStepBrief {
  const factory _NextStepBrief(
      {required final String id,
      required final String title,
      required final String category,
      final String? timeframe}) = _$NextStepBriefImpl;

  factory _NextStepBrief.fromJson(Map<String, dynamic> json) =
      _$NextStepBriefImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get category;
  @override
  String? get timeframe;
  @override
  @JsonKey(ignore: true)
  _$$NextStepBriefImplCopyWith<_$NextStepBriefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProgressRoadmapSummaryItem _$ProgressRoadmapSummaryItemFromJson(
    Map<String, dynamic> json) {
  return _ProgressRoadmapSummaryItem.fromJson(json);
}

/// @nodoc
mixin _$ProgressRoadmapSummaryItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'career_name')
  String? get careerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_steps')
  int get totalSteps => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_steps')
  int get completedSteps => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_percent')
  int get completionPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_step')
  NextStepBrief? get nextStep => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProgressRoadmapSummaryItemCopyWith<ProgressRoadmapSummaryItem>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressRoadmapSummaryItemCopyWith<$Res> {
  factory $ProgressRoadmapSummaryItemCopyWith(ProgressRoadmapSummaryItem value,
          $Res Function(ProgressRoadmapSummaryItem) then) =
      _$ProgressRoadmapSummaryItemCopyWithImpl<$Res,
          ProgressRoadmapSummaryItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'career_name') String? careerName,
      @JsonKey(name: 'total_steps') int totalSteps,
      @JsonKey(name: 'completed_steps') int completedSteps,
      @JsonKey(name: 'completion_percent') int completionPercent,
      @JsonKey(name: 'next_step') NextStepBrief? nextStep});

  $NextStepBriefCopyWith<$Res>? get nextStep;
}

/// @nodoc
class _$ProgressRoadmapSummaryItemCopyWithImpl<$Res,
        $Val extends ProgressRoadmapSummaryItem>
    implements $ProgressRoadmapSummaryItemCopyWith<$Res> {
  _$ProgressRoadmapSummaryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? careerName = freezed,
    Object? totalSteps = null,
    Object? completedSteps = null,
    Object? completionPercent = null,
    Object? nextStep = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      careerName: freezed == careerName
          ? _value.careerName
          : careerName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      completedSteps: null == completedSteps
          ? _value.completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as int,
      completionPercent: null == completionPercent
          ? _value.completionPercent
          : completionPercent // ignore: cast_nullable_to_non_nullable
              as int,
      nextStep: freezed == nextStep
          ? _value.nextStep
          : nextStep // ignore: cast_nullable_to_non_nullable
              as NextStepBrief?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NextStepBriefCopyWith<$Res>? get nextStep {
    if (_value.nextStep == null) {
      return null;
    }

    return $NextStepBriefCopyWith<$Res>(_value.nextStep!, (value) {
      return _then(_value.copyWith(nextStep: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProgressRoadmapSummaryItemImplCopyWith<$Res>
    implements $ProgressRoadmapSummaryItemCopyWith<$Res> {
  factory _$$ProgressRoadmapSummaryItemImplCopyWith(
          _$ProgressRoadmapSummaryItemImpl value,
          $Res Function(_$ProgressRoadmapSummaryItemImpl) then) =
      __$$ProgressRoadmapSummaryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'career_name') String? careerName,
      @JsonKey(name: 'total_steps') int totalSteps,
      @JsonKey(name: 'completed_steps') int completedSteps,
      @JsonKey(name: 'completion_percent') int completionPercent,
      @JsonKey(name: 'next_step') NextStepBrief? nextStep});

  @override
  $NextStepBriefCopyWith<$Res>? get nextStep;
}

/// @nodoc
class __$$ProgressRoadmapSummaryItemImplCopyWithImpl<$Res>
    extends _$ProgressRoadmapSummaryItemCopyWithImpl<$Res,
        _$ProgressRoadmapSummaryItemImpl>
    implements _$$ProgressRoadmapSummaryItemImplCopyWith<$Res> {
  __$$ProgressRoadmapSummaryItemImplCopyWithImpl(
      _$ProgressRoadmapSummaryItemImpl _value,
      $Res Function(_$ProgressRoadmapSummaryItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? careerName = freezed,
    Object? totalSteps = null,
    Object? completedSteps = null,
    Object? completionPercent = null,
    Object? nextStep = freezed,
  }) {
    return _then(_$ProgressRoadmapSummaryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      careerName: freezed == careerName
          ? _value.careerName
          : careerName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      completedSteps: null == completedSteps
          ? _value.completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as int,
      completionPercent: null == completionPercent
          ? _value.completionPercent
          : completionPercent // ignore: cast_nullable_to_non_nullable
              as int,
      nextStep: freezed == nextStep
          ? _value.nextStep
          : nextStep // ignore: cast_nullable_to_non_nullable
              as NextStepBrief?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressRoadmapSummaryItemImpl implements _ProgressRoadmapSummaryItem {
  const _$ProgressRoadmapSummaryItemImpl(
      {required this.id,
      @JsonKey(name: 'career_name') this.careerName,
      @JsonKey(name: 'total_steps') this.totalSteps = 0,
      @JsonKey(name: 'completed_steps') this.completedSteps = 0,
      @JsonKey(name: 'completion_percent') this.completionPercent = 0,
      @JsonKey(name: 'next_step') this.nextStep});

  factory _$ProgressRoadmapSummaryItemImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ProgressRoadmapSummaryItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'career_name')
  final String? careerName;
  @override
  @JsonKey(name: 'total_steps')
  final int totalSteps;
  @override
  @JsonKey(name: 'completed_steps')
  final int completedSteps;
  @override
  @JsonKey(name: 'completion_percent')
  final int completionPercent;
  @override
  @JsonKey(name: 'next_step')
  final NextStepBrief? nextStep;

  @override
  String toString() {
    return 'ProgressRoadmapSummaryItem(id: $id, careerName: $careerName, totalSteps: $totalSteps, completedSteps: $completedSteps, completionPercent: $completionPercent, nextStep: $nextStep)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressRoadmapSummaryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.careerName, careerName) ||
                other.careerName == careerName) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps) &&
            (identical(other.completedSteps, completedSteps) ||
                other.completedSteps == completedSteps) &&
            (identical(other.completionPercent, completionPercent) ||
                other.completionPercent == completionPercent) &&
            (identical(other.nextStep, nextStep) ||
                other.nextStep == nextStep));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, careerName, totalSteps,
      completedSteps, completionPercent, nextStep);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressRoadmapSummaryItemImplCopyWith<_$ProgressRoadmapSummaryItemImpl>
      get copyWith => __$$ProgressRoadmapSummaryItemImplCopyWithImpl<
          _$ProgressRoadmapSummaryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressRoadmapSummaryItemImplToJson(
      this,
    );
  }
}

abstract class _ProgressRoadmapSummaryItem
    implements ProgressRoadmapSummaryItem {
  const factory _ProgressRoadmapSummaryItem(
          {required final String id,
          @JsonKey(name: 'career_name') final String? careerName,
          @JsonKey(name: 'total_steps') final int totalSteps,
          @JsonKey(name: 'completed_steps') final int completedSteps,
          @JsonKey(name: 'completion_percent') final int completionPercent,
          @JsonKey(name: 'next_step') final NextStepBrief? nextStep}) =
      _$ProgressRoadmapSummaryItemImpl;

  factory _ProgressRoadmapSummaryItem.fromJson(Map<String, dynamic> json) =
      _$ProgressRoadmapSummaryItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'career_name')
  String? get careerName;
  @override
  @JsonKey(name: 'total_steps')
  int get totalSteps;
  @override
  @JsonKey(name: 'completed_steps')
  int get completedSteps;
  @override
  @JsonKey(name: 'completion_percent')
  int get completionPercent;
  @override
  @JsonKey(name: 'next_step')
  NextStepBrief? get nextStep;
  @override
  @JsonKey(ignore: true)
  _$$ProgressRoadmapSummaryItemImplCopyWith<_$ProgressRoadmapSummaryItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProgressSummary _$ProgressSummaryFromJson(Map<String, dynamic> json) {
  return _ProgressSummary.fromJson(json);
}

/// @nodoc
mixin _$ProgressSummary {
  @JsonKey(name: 'active_roadmaps')
  int get activeRoadmaps => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_steps_across_all')
  int get totalStepsAcrossAll => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_steps')
  int get completedSteps => throw _privateConstructorUsedError;
  @JsonKey(name: 'overall_completion_percent')
  int get overallCompletionPercent => throw _privateConstructorUsedError;
  List<ProgressRoadmapSummaryItem> get roadmaps =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProgressSummaryCopyWith<ProgressSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressSummaryCopyWith<$Res> {
  factory $ProgressSummaryCopyWith(
          ProgressSummary value, $Res Function(ProgressSummary) then) =
      _$ProgressSummaryCopyWithImpl<$Res, ProgressSummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'active_roadmaps') int activeRoadmaps,
      @JsonKey(name: 'total_steps_across_all') int totalStepsAcrossAll,
      @JsonKey(name: 'completed_steps') int completedSteps,
      @JsonKey(name: 'overall_completion_percent') int overallCompletionPercent,
      List<ProgressRoadmapSummaryItem> roadmaps});
}

/// @nodoc
class _$ProgressSummaryCopyWithImpl<$Res, $Val extends ProgressSummary>
    implements $ProgressSummaryCopyWith<$Res> {
  _$ProgressSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeRoadmaps = null,
    Object? totalStepsAcrossAll = null,
    Object? completedSteps = null,
    Object? overallCompletionPercent = null,
    Object? roadmaps = null,
  }) {
    return _then(_value.copyWith(
      activeRoadmaps: null == activeRoadmaps
          ? _value.activeRoadmaps
          : activeRoadmaps // ignore: cast_nullable_to_non_nullable
              as int,
      totalStepsAcrossAll: null == totalStepsAcrossAll
          ? _value.totalStepsAcrossAll
          : totalStepsAcrossAll // ignore: cast_nullable_to_non_nullable
              as int,
      completedSteps: null == completedSteps
          ? _value.completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as int,
      overallCompletionPercent: null == overallCompletionPercent
          ? _value.overallCompletionPercent
          : overallCompletionPercent // ignore: cast_nullable_to_non_nullable
              as int,
      roadmaps: null == roadmaps
          ? _value.roadmaps
          : roadmaps // ignore: cast_nullable_to_non_nullable
              as List<ProgressRoadmapSummaryItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressSummaryImplCopyWith<$Res>
    implements $ProgressSummaryCopyWith<$Res> {
  factory _$$ProgressSummaryImplCopyWith(_$ProgressSummaryImpl value,
          $Res Function(_$ProgressSummaryImpl) then) =
      __$$ProgressSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'active_roadmaps') int activeRoadmaps,
      @JsonKey(name: 'total_steps_across_all') int totalStepsAcrossAll,
      @JsonKey(name: 'completed_steps') int completedSteps,
      @JsonKey(name: 'overall_completion_percent') int overallCompletionPercent,
      List<ProgressRoadmapSummaryItem> roadmaps});
}

/// @nodoc
class __$$ProgressSummaryImplCopyWithImpl<$Res>
    extends _$ProgressSummaryCopyWithImpl<$Res, _$ProgressSummaryImpl>
    implements _$$ProgressSummaryImplCopyWith<$Res> {
  __$$ProgressSummaryImplCopyWithImpl(
      _$ProgressSummaryImpl _value, $Res Function(_$ProgressSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeRoadmaps = null,
    Object? totalStepsAcrossAll = null,
    Object? completedSteps = null,
    Object? overallCompletionPercent = null,
    Object? roadmaps = null,
  }) {
    return _then(_$ProgressSummaryImpl(
      activeRoadmaps: null == activeRoadmaps
          ? _value.activeRoadmaps
          : activeRoadmaps // ignore: cast_nullable_to_non_nullable
              as int,
      totalStepsAcrossAll: null == totalStepsAcrossAll
          ? _value.totalStepsAcrossAll
          : totalStepsAcrossAll // ignore: cast_nullable_to_non_nullable
              as int,
      completedSteps: null == completedSteps
          ? _value.completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as int,
      overallCompletionPercent: null == overallCompletionPercent
          ? _value.overallCompletionPercent
          : overallCompletionPercent // ignore: cast_nullable_to_non_nullable
              as int,
      roadmaps: null == roadmaps
          ? _value._roadmaps
          : roadmaps // ignore: cast_nullable_to_non_nullable
              as List<ProgressRoadmapSummaryItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressSummaryImpl implements _ProgressSummary {
  const _$ProgressSummaryImpl(
      {@JsonKey(name: 'active_roadmaps') this.activeRoadmaps = 0,
      @JsonKey(name: 'total_steps_across_all') this.totalStepsAcrossAll = 0,
      @JsonKey(name: 'completed_steps') this.completedSteps = 0,
      @JsonKey(name: 'overall_completion_percent')
      this.overallCompletionPercent = 0,
      final List<ProgressRoadmapSummaryItem> roadmaps = const []})
      : _roadmaps = roadmaps;

  factory _$ProgressSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'active_roadmaps')
  final int activeRoadmaps;
  @override
  @JsonKey(name: 'total_steps_across_all')
  final int totalStepsAcrossAll;
  @override
  @JsonKey(name: 'completed_steps')
  final int completedSteps;
  @override
  @JsonKey(name: 'overall_completion_percent')
  final int overallCompletionPercent;
  final List<ProgressRoadmapSummaryItem> _roadmaps;
  @override
  @JsonKey()
  List<ProgressRoadmapSummaryItem> get roadmaps {
    if (_roadmaps is EqualUnmodifiableListView) return _roadmaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roadmaps);
  }

  @override
  String toString() {
    return 'ProgressSummary(activeRoadmaps: $activeRoadmaps, totalStepsAcrossAll: $totalStepsAcrossAll, completedSteps: $completedSteps, overallCompletionPercent: $overallCompletionPercent, roadmaps: $roadmaps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressSummaryImpl &&
            (identical(other.activeRoadmaps, activeRoadmaps) ||
                other.activeRoadmaps == activeRoadmaps) &&
            (identical(other.totalStepsAcrossAll, totalStepsAcrossAll) ||
                other.totalStepsAcrossAll == totalStepsAcrossAll) &&
            (identical(other.completedSteps, completedSteps) ||
                other.completedSteps == completedSteps) &&
            (identical(
                    other.overallCompletionPercent, overallCompletionPercent) ||
                other.overallCompletionPercent == overallCompletionPercent) &&
            const DeepCollectionEquality().equals(other._roadmaps, _roadmaps));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      activeRoadmaps,
      totalStepsAcrossAll,
      completedSteps,
      overallCompletionPercent,
      const DeepCollectionEquality().hash(_roadmaps));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressSummaryImplCopyWith<_$ProgressSummaryImpl> get copyWith =>
      __$$ProgressSummaryImplCopyWithImpl<_$ProgressSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressSummaryImplToJson(
      this,
    );
  }
}

abstract class _ProgressSummary implements ProgressSummary {
  const factory _ProgressSummary(
      {@JsonKey(name: 'active_roadmaps') final int activeRoadmaps,
      @JsonKey(name: 'total_steps_across_all') final int totalStepsAcrossAll,
      @JsonKey(name: 'completed_steps') final int completedSteps,
      @JsonKey(name: 'overall_completion_percent')
      final int overallCompletionPercent,
      final List<ProgressRoadmapSummaryItem> roadmaps}) = _$ProgressSummaryImpl;

  factory _ProgressSummary.fromJson(Map<String, dynamic> json) =
      _$ProgressSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'active_roadmaps')
  int get activeRoadmaps;
  @override
  @JsonKey(name: 'total_steps_across_all')
  int get totalStepsAcrossAll;
  @override
  @JsonKey(name: 'completed_steps')
  int get completedSteps;
  @override
  @JsonKey(name: 'overall_completion_percent')
  int get overallCompletionPercent;
  @override
  List<ProgressRoadmapSummaryItem> get roadmaps;
  @override
  @JsonKey(ignore: true)
  _$$ProgressSummaryImplCopyWith<_$ProgressSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
