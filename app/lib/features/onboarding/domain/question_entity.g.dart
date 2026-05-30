// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionOptionImpl _$$QuestionOptionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionOptionImpl(
      index: (json['index'] as num).toInt(),
      text: json['text'] as String,
      emoji: json['emoji'] as String,
      dimensionWeights:
          (json['dimension_weights'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
    );

Map<String, dynamic> _$$QuestionOptionImplToJson(
        _$QuestionOptionImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'text': instance.text,
      'emoji': instance.emoji,
      'dimension_weights': instance.dimensionWeights,
    };

_$QuestionEntityImpl _$$QuestionEntityImplFromJson(Map<String, dynamic> json) =>
    _$QuestionEntityImpl(
      code: json['code'] as String,
      section: json['section'] as String,
      sectionLabel: json['section_label'] as String,
      questionText: json['question_text'] as String,
      instruction: json['instruction'] as String?,
      questionType: json['question_type'] as String,
      isScored: json['is_scored'] as bool? ?? true,
      maxSelections: (json['max_selections'] as num?)?.toInt() ?? 1,
      options: (json['options'] as List<dynamic>)
          .map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuestionEntityImplToJson(
        _$QuestionEntityImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'section': instance.section,
      'section_label': instance.sectionLabel,
      'question_text': instance.questionText,
      'instruction': instance.instruction,
      'question_type': instance.questionType,
      'is_scored': instance.isScored,
      'max_selections': instance.maxSelections,
      'options': instance.options,
    };
