// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interest_profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InterestProfileEntity _$InterestProfileEntityFromJson(
    Map<String, dynamic> json) {
  return _InterestProfileEntity.fromJson(json);
}

/// @nodoc
mixin _$InterestProfileEntity {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'dimension_scores')
  Map<String, int> get dimensionScores => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_dimensions')
  List<String> get topDimensions => throw _privateConstructorUsedError;
  @JsonKey(name: 'computed_at')
  String get computedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InterestProfileEntityCopyWith<InterestProfileEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterestProfileEntityCopyWith<$Res> {
  factory $InterestProfileEntityCopyWith(InterestProfileEntity value,
          $Res Function(InterestProfileEntity) then) =
      _$InterestProfileEntityCopyWithImpl<$Res, InterestProfileEntity>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'dimension_scores') Map<String, int> dimensionScores,
      @JsonKey(name: 'top_dimensions') List<String> topDimensions,
      @JsonKey(name: 'computed_at') String computedAt});
}

/// @nodoc
class _$InterestProfileEntityCopyWithImpl<$Res,
        $Val extends InterestProfileEntity>
    implements $InterestProfileEntityCopyWith<$Res> {
  _$InterestProfileEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dimensionScores = null,
    Object? topDimensions = null,
    Object? computedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dimensionScores: null == dimensionScores
          ? _value.dimensionScores
          : dimensionScores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topDimensions: null == topDimensions
          ? _value.topDimensions
          : topDimensions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      computedAt: null == computedAt
          ? _value.computedAt
          : computedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InterestProfileEntityImplCopyWith<$Res>
    implements $InterestProfileEntityCopyWith<$Res> {
  factory _$$InterestProfileEntityImplCopyWith(
          _$InterestProfileEntityImpl value,
          $Res Function(_$InterestProfileEntityImpl) then) =
      __$$InterestProfileEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'dimension_scores') Map<String, int> dimensionScores,
      @JsonKey(name: 'top_dimensions') List<String> topDimensions,
      @JsonKey(name: 'computed_at') String computedAt});
}

/// @nodoc
class __$$InterestProfileEntityImplCopyWithImpl<$Res>
    extends _$InterestProfileEntityCopyWithImpl<$Res,
        _$InterestProfileEntityImpl>
    implements _$$InterestProfileEntityImplCopyWith<$Res> {
  __$$InterestProfileEntityImplCopyWithImpl(_$InterestProfileEntityImpl _value,
      $Res Function(_$InterestProfileEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dimensionScores = null,
    Object? topDimensions = null,
    Object? computedAt = null,
  }) {
    return _then(_$InterestProfileEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dimensionScores: null == dimensionScores
          ? _value._dimensionScores
          : dimensionScores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topDimensions: null == topDimensions
          ? _value._topDimensions
          : topDimensions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      computedAt: null == computedAt
          ? _value.computedAt
          : computedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InterestProfileEntityImpl implements _InterestProfileEntity {
  const _$InterestProfileEntityImpl(
      {required this.id,
      @JsonKey(name: 'dimension_scores')
      required final Map<String, int> dimensionScores,
      @JsonKey(name: 'top_dimensions')
      required final List<String> topDimensions,
      @JsonKey(name: 'computed_at') required this.computedAt})
      : _dimensionScores = dimensionScores,
        _topDimensions = topDimensions;

  factory _$InterestProfileEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$InterestProfileEntityImplFromJson(json);

  @override
  final String id;
  final Map<String, int> _dimensionScores;
  @override
  @JsonKey(name: 'dimension_scores')
  Map<String, int> get dimensionScores {
    if (_dimensionScores is EqualUnmodifiableMapView) return _dimensionScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dimensionScores);
  }

  final List<String> _topDimensions;
  @override
  @JsonKey(name: 'top_dimensions')
  List<String> get topDimensions {
    if (_topDimensions is EqualUnmodifiableListView) return _topDimensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topDimensions);
  }

  @override
  @JsonKey(name: 'computed_at')
  final String computedAt;

  @override
  String toString() {
    return 'InterestProfileEntity(id: $id, dimensionScores: $dimensionScores, topDimensions: $topDimensions, computedAt: $computedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterestProfileEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._dimensionScores, _dimensionScores) &&
            const DeepCollectionEquality()
                .equals(other._topDimensions, _topDimensions) &&
            (identical(other.computedAt, computedAt) ||
                other.computedAt == computedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_dimensionScores),
      const DeepCollectionEquality().hash(_topDimensions),
      computedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InterestProfileEntityImplCopyWith<_$InterestProfileEntityImpl>
      get copyWith => __$$InterestProfileEntityImplCopyWithImpl<
          _$InterestProfileEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InterestProfileEntityImplToJson(
      this,
    );
  }
}

abstract class _InterestProfileEntity implements InterestProfileEntity {
  const factory _InterestProfileEntity(
          {required final String id,
          @JsonKey(name: 'dimension_scores')
          required final Map<String, int> dimensionScores,
          @JsonKey(name: 'top_dimensions')
          required final List<String> topDimensions,
          @JsonKey(name: 'computed_at') required final String computedAt}) =
      _$InterestProfileEntityImpl;

  factory _InterestProfileEntity.fromJson(Map<String, dynamic> json) =
      _$InterestProfileEntityImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'dimension_scores')
  Map<String, int> get dimensionScores;
  @override
  @JsonKey(name: 'top_dimensions')
  List<String> get topDimensions;
  @override
  @JsonKey(name: 'computed_at')
  String get computedAt;
  @override
  @JsonKey(ignore: true)
  _$$InterestProfileEntityImplCopyWith<_$InterestProfileEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
