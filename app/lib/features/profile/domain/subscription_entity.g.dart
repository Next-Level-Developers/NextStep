// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionFeaturesImpl _$$SubscriptionFeaturesImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionFeaturesImpl(
      careerMatches: (json['career_matches'] as num?)?.toInt() ?? 0,
      careerDetailFull: json['career_detail_full'] as bool? ?? false,
      roadmapStepsVisible:
          (json['roadmap_steps_visible'] as num?)?.toInt() ?? 0,
      aiMessagesPerDay: (json['ai_messages_per_day'] as num?)?.toInt() ?? 0,
      storiesPerCareer: (json['stories_per_career'] as num?)?.toInt() ?? 0,
      careerComparison: json['career_comparison'] as bool? ?? false,
      parentShare: json['parent_share'] as bool? ?? false,
      progressTracker: json['progress_tracker'] as bool? ?? false,
    );

Map<String, dynamic> _$$SubscriptionFeaturesImplToJson(
        _$SubscriptionFeaturesImpl instance) =>
    <String, dynamic>{
      'career_matches': instance.careerMatches,
      'career_detail_full': instance.careerDetailFull,
      'roadmap_steps_visible': instance.roadmapStepsVisible,
      'ai_messages_per_day': instance.aiMessagesPerDay,
      'stories_per_career': instance.storiesPerCareer,
      'career_comparison': instance.careerComparison,
      'parent_share': instance.parentShare,
      'progress_tracker': instance.progressTracker,
    };

_$SubscriptionPlanImpl _$$SubscriptionPlanImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionPlanImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String?,
      pricePaise: (json['price_paise'] as num?)?.toInt() ?? 0,
      priceInr: (json['price_inr'] as num?)?.toInt() ?? 0,
      durationDays: (json['duration_days'] as num?)?.toInt() ?? 0,
      features: json['features'] == null
          ? null
          : SubscriptionFeatures.fromJson(
              json['features'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SubscriptionPlanImplToJson(
        _$SubscriptionPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.displayName,
      'price_paise': instance.pricePaise,
      'price_inr': instance.priceInr,
      'duration_days': instance.durationDays,
      'features': instance.features,
    };

_$CurrentSubscriptionImpl _$$CurrentSubscriptionImplFromJson(
        Map<String, dynamic> json) =>
    _$CurrentSubscriptionImpl(
      subscriptionTier: json['subscription_tier'] as String? ?? 'free',
      subscriptionExpiresAt: json['subscription_expires_at'] as String?,
      daysRemaining: (json['days_remaining'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? false,
      plan: json['plan'] == null
          ? null
          : SubscriptionPlan.fromJson(json['plan'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CurrentSubscriptionImplToJson(
        _$CurrentSubscriptionImpl instance) =>
    <String, dynamic>{
      'subscription_tier': instance.subscriptionTier,
      'subscription_expires_at': instance.subscriptionExpiresAt,
      'days_remaining': instance.daysRemaining,
      'is_active': instance.isActive,
      'plan': instance.plan,
    };
