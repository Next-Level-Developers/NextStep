// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest_profile_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InterestProfileEntityImpl _$$InterestProfileEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$InterestProfileEntityImpl(
      id: json['id'] as String,
      dimensionScores: Map<String, int>.from(json['dimension_scores'] as Map),
      topDimensions: (json['top_dimensions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      computedAt: json['computed_at'] as String,
    );

Map<String, dynamic> _$$InterestProfileEntityImplToJson(
        _$InterestProfileEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dimension_scores': instance.dimensionScores,
      'top_dimensions': instance.topDimensions,
      'computed_at': instance.computedAt,
    };
