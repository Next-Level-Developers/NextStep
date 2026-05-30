// lib/features/onboarding/domain/question_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_entity.freezed.dart';
part 'question_entity.g.dart';

@freezed
class QuestionOption with _$QuestionOption {
  const factory QuestionOption({
    required int index,
    required String text,
    @Default('') String emoji,
    @JsonKey(name: 'dimension_weights') @Default({}) Map<String, double> dimensionWeights,
  }) = _QuestionOption;

  factory QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);
}

@freezed
class QuestionEntity with _$QuestionEntity {
  @JsonSerializable(explicitToJson: true)
  const factory QuestionEntity({
    required String code,
    required String section,
    @JsonKey(name: 'section_label') required String sectionLabel,
    @JsonKey(name: 'question_text') required String questionText,
    String? instruction,
    @JsonKey(name: 'question_type') required String questionType,
    @JsonKey(name: 'is_scored') @Default(true) bool isScored,
    @JsonKey(name: 'max_selections') @Default(1) int maxSelections,
    required List<QuestionOption> options,
  }) = _QuestionEntity;

  factory QuestionEntity.fromJson(Map<String, dynamic> json) =>
      _$QuestionEntityFromJson(json);
}
