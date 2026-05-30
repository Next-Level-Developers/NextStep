// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionOption _$QuestionOptionFromJson(Map<String, dynamic> json) {
  return _QuestionOption.fromJson(json);
}

/// @nodoc
mixin _$QuestionOption {
  int get index => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  @JsonKey(name: 'dimension_weights')
  Map<String, double> get dimensionWeights =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionOptionCopyWith<QuestionOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionOptionCopyWith<$Res> {
  factory $QuestionOptionCopyWith(
          QuestionOption value, $Res Function(QuestionOption) then) =
      _$QuestionOptionCopyWithImpl<$Res, QuestionOption>;
  @useResult
  $Res call(
      {int index,
      String text,
      String emoji,
      @JsonKey(name: 'dimension_weights')
      Map<String, double> dimensionWeights});
}

/// @nodoc
class _$QuestionOptionCopyWithImpl<$Res, $Val extends QuestionOption>
    implements $QuestionOptionCopyWith<$Res> {
  _$QuestionOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? text = null,
    Object? emoji = null,
    Object? dimensionWeights = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      dimensionWeights: null == dimensionWeights
          ? _value.dimensionWeights
          : dimensionWeights // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionOptionImplCopyWith<$Res>
    implements $QuestionOptionCopyWith<$Res> {
  factory _$$QuestionOptionImplCopyWith(_$QuestionOptionImpl value,
          $Res Function(_$QuestionOptionImpl) then) =
      __$$QuestionOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int index,
      String text,
      String emoji,
      @JsonKey(name: 'dimension_weights')
      Map<String, double> dimensionWeights});
}

/// @nodoc
class __$$QuestionOptionImplCopyWithImpl<$Res>
    extends _$QuestionOptionCopyWithImpl<$Res, _$QuestionOptionImpl>
    implements _$$QuestionOptionImplCopyWith<$Res> {
  __$$QuestionOptionImplCopyWithImpl(
      _$QuestionOptionImpl _value, $Res Function(_$QuestionOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? text = null,
    Object? emoji = null,
    Object? dimensionWeights = null,
  }) {
    return _then(_$QuestionOptionImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      dimensionWeights: null == dimensionWeights
          ? _value._dimensionWeights
          : dimensionWeights // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionOptionImpl implements _QuestionOption {
  const _$QuestionOptionImpl(
      {required this.index,
      required this.text,
      required this.emoji,
      @JsonKey(name: 'dimension_weights')
      final Map<String, double> dimensionWeights = const {}})
      : _dimensionWeights = dimensionWeights;

  factory _$QuestionOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionOptionImplFromJson(json);

  @override
  final int index;
  @override
  final String text;
  @override
  final String emoji;
  final Map<String, double> _dimensionWeights;
  @override
  @JsonKey(name: 'dimension_weights')
  Map<String, double> get dimensionWeights {
    if (_dimensionWeights is EqualUnmodifiableMapView) return _dimensionWeights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dimensionWeights);
  }

  @override
  String toString() {
    return 'QuestionOption(index: $index, text: $text, emoji: $emoji, dimensionWeights: $dimensionWeights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionOptionImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            const DeepCollectionEquality()
                .equals(other._dimensionWeights, _dimensionWeights));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, index, text, emoji,
      const DeepCollectionEquality().hash(_dimensionWeights));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionOptionImplCopyWith<_$QuestionOptionImpl> get copyWith =>
      __$$QuestionOptionImplCopyWithImpl<_$QuestionOptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionOptionImplToJson(
      this,
    );
  }
}

abstract class _QuestionOption implements QuestionOption {
  const factory _QuestionOption(
      {required final int index,
      required final String text,
      required final String emoji,
      @JsonKey(name: 'dimension_weights')
      final Map<String, double> dimensionWeights}) = _$QuestionOptionImpl;

  factory _QuestionOption.fromJson(Map<String, dynamic> json) =
      _$QuestionOptionImpl.fromJson;

  @override
  int get index;
  @override
  String get text;
  @override
  String get emoji;
  @override
  @JsonKey(name: 'dimension_weights')
  Map<String, double> get dimensionWeights;
  @override
  @JsonKey(ignore: true)
  _$$QuestionOptionImplCopyWith<_$QuestionOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionEntity _$QuestionEntityFromJson(Map<String, dynamic> json) {
  return _QuestionEntity.fromJson(json);
}

/// @nodoc
mixin _$QuestionEntity {
  String get code => throw _privateConstructorUsedError;
  String get section => throw _privateConstructorUsedError;
  @JsonKey(name: 'section_label')
  String get sectionLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_text')
  String get questionText => throw _privateConstructorUsedError;
  String? get instruction => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_type')
  String get questionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_scored')
  bool get isScored => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_selections')
  int get maxSelections => throw _privateConstructorUsedError;
  List<QuestionOption> get options => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionEntityCopyWith<QuestionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionEntityCopyWith<$Res> {
  factory $QuestionEntityCopyWith(
          QuestionEntity value, $Res Function(QuestionEntity) then) =
      _$QuestionEntityCopyWithImpl<$Res, QuestionEntity>;
  @useResult
  $Res call(
      {String code,
      String section,
      @JsonKey(name: 'section_label') String sectionLabel,
      @JsonKey(name: 'question_text') String questionText,
      String? instruction,
      @JsonKey(name: 'question_type') String questionType,
      @JsonKey(name: 'is_scored') bool isScored,
      @JsonKey(name: 'max_selections') int maxSelections,
      List<QuestionOption> options});
}

/// @nodoc
class _$QuestionEntityCopyWithImpl<$Res, $Val extends QuestionEntity>
    implements $QuestionEntityCopyWith<$Res> {
  _$QuestionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? section = null,
    Object? sectionLabel = null,
    Object? questionText = null,
    Object? instruction = freezed,
    Object? questionType = null,
    Object? isScored = null,
    Object? maxSelections = null,
    Object? options = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      section: null == section
          ? _value.section
          : section // ignore: cast_nullable_to_non_nullable
              as String,
      sectionLabel: null == sectionLabel
          ? _value.sectionLabel
          : sectionLabel // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      instruction: freezed == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String?,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      isScored: null == isScored
          ? _value.isScored
          : isScored // ignore: cast_nullable_to_non_nullable
              as bool,
      maxSelections: null == maxSelections
          ? _value.maxSelections
          : maxSelections // ignore: cast_nullable_to_non_nullable
              as int,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionOption>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionEntityImplCopyWith<$Res>
    implements $QuestionEntityCopyWith<$Res> {
  factory _$$QuestionEntityImplCopyWith(_$QuestionEntityImpl value,
          $Res Function(_$QuestionEntityImpl) then) =
      __$$QuestionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String section,
      @JsonKey(name: 'section_label') String sectionLabel,
      @JsonKey(name: 'question_text') String questionText,
      String? instruction,
      @JsonKey(name: 'question_type') String questionType,
      @JsonKey(name: 'is_scored') bool isScored,
      @JsonKey(name: 'max_selections') int maxSelections,
      List<QuestionOption> options});
}

/// @nodoc
class __$$QuestionEntityImplCopyWithImpl<$Res>
    extends _$QuestionEntityCopyWithImpl<$Res, _$QuestionEntityImpl>
    implements _$$QuestionEntityImplCopyWith<$Res> {
  __$$QuestionEntityImplCopyWithImpl(
      _$QuestionEntityImpl _value, $Res Function(_$QuestionEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? section = null,
    Object? sectionLabel = null,
    Object? questionText = null,
    Object? instruction = freezed,
    Object? questionType = null,
    Object? isScored = null,
    Object? maxSelections = null,
    Object? options = null,
  }) {
    return _then(_$QuestionEntityImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      section: null == section
          ? _value.section
          : section // ignore: cast_nullable_to_non_nullable
              as String,
      sectionLabel: null == sectionLabel
          ? _value.sectionLabel
          : sectionLabel // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      instruction: freezed == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String?,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      isScored: null == isScored
          ? _value.isScored
          : isScored // ignore: cast_nullable_to_non_nullable
              as bool,
      maxSelections: null == maxSelections
          ? _value.maxSelections
          : maxSelections // ignore: cast_nullable_to_non_nullable
              as int,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionOption>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionEntityImpl implements _QuestionEntity {
  const _$QuestionEntityImpl(
      {required this.code,
      required this.section,
      @JsonKey(name: 'section_label') required this.sectionLabel,
      @JsonKey(name: 'question_text') required this.questionText,
      this.instruction,
      @JsonKey(name: 'question_type') required this.questionType,
      @JsonKey(name: 'is_scored') this.isScored = true,
      @JsonKey(name: 'max_selections') this.maxSelections = 1,
      required final List<QuestionOption> options})
      : _options = options;

  factory _$QuestionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionEntityImplFromJson(json);

  @override
  final String code;
  @override
  final String section;
  @override
  @JsonKey(name: 'section_label')
  final String sectionLabel;
  @override
  @JsonKey(name: 'question_text')
  final String questionText;
  @override
  final String? instruction;
  @override
  @JsonKey(name: 'question_type')
  final String questionType;
  @override
  @JsonKey(name: 'is_scored')
  final bool isScored;
  @override
  @JsonKey(name: 'max_selections')
  final int maxSelections;
  final List<QuestionOption> _options;
  @override
  List<QuestionOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'QuestionEntity(code: $code, section: $section, sectionLabel: $sectionLabel, questionText: $questionText, instruction: $instruction, questionType: $questionType, isScored: $isScored, maxSelections: $maxSelections, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionEntityImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.section, section) || other.section == section) &&
            (identical(other.sectionLabel, sectionLabel) ||
                other.sectionLabel == sectionLabel) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.instruction, instruction) ||
                other.instruction == instruction) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.isScored, isScored) ||
                other.isScored == isScored) &&
            (identical(other.maxSelections, maxSelections) ||
                other.maxSelections == maxSelections) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      code,
      section,
      sectionLabel,
      questionText,
      instruction,
      questionType,
      isScored,
      maxSelections,
      const DeepCollectionEquality().hash(_options));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionEntityImplCopyWith<_$QuestionEntityImpl> get copyWith =>
      __$$QuestionEntityImplCopyWithImpl<_$QuestionEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionEntityImplToJson(
      this,
    );
  }
}

abstract class _QuestionEntity implements QuestionEntity {
  const factory _QuestionEntity(
      {required final String code,
      required final String section,
      @JsonKey(name: 'section_label') required final String sectionLabel,
      @JsonKey(name: 'question_text') required final String questionText,
      final String? instruction,
      @JsonKey(name: 'question_type') required final String questionType,
      @JsonKey(name: 'is_scored') final bool isScored,
      @JsonKey(name: 'max_selections') final int maxSelections,
      required final List<QuestionOption> options}) = _$QuestionEntityImpl;

  factory _QuestionEntity.fromJson(Map<String, dynamic> json) =
      _$QuestionEntityImpl.fromJson;

  @override
  String get code;
  @override
  String get section;
  @override
  @JsonKey(name: 'section_label')
  String get sectionLabel;
  @override
  @JsonKey(name: 'question_text')
  String get questionText;
  @override
  String? get instruction;
  @override
  @JsonKey(name: 'question_type')
  String get questionType;
  @override
  @JsonKey(name: 'is_scored')
  bool get isScored;
  @override
  @JsonKey(name: 'max_selections')
  int get maxSelections;
  @override
  List<QuestionOption> get options;
  @override
  @JsonKey(ignore: true)
  _$$QuestionEntityImplCopyWith<_$QuestionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
