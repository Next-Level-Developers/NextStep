// lib/features/profile/domain/subscription_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_entity.freezed.dart';
part 'subscription_entity.g.dart';

@freezed
class SubscriptionFeatures with _$SubscriptionFeatures {
  const factory SubscriptionFeatures({
    @JsonKey(name: 'career_matches') @Default(0) int careerMatches,
    @JsonKey(name: 'career_detail_full') @Default(false) bool careerDetailFull,
    @JsonKey(name: 'roadmap_steps_visible') @Default(0) int roadmapStepsVisible,
    @JsonKey(name: 'ai_messages_per_day') @Default(0) int aiMessagesPerDay,
    @JsonKey(name: 'stories_per_career') @Default(0) int storiesPerCareer,
    @JsonKey(name: 'career_comparison') @Default(false) bool careerComparison,
    @JsonKey(name: 'parent_share') @Default(false) bool parentShare,
    @JsonKey(name: 'progress_tracker') @Default(false) bool progressTracker,
  }) = _SubscriptionFeatures;

  factory SubscriptionFeatures.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFeaturesFromJson(json);
}

@freezed
class SubscriptionPlan with _$SubscriptionPlan {
  const factory SubscriptionPlan({
    required String id,
    required String name,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'price_paise') @Default(0) int pricePaise,
    @JsonKey(name: 'price_inr') @Default(0) int priceInr,
    @JsonKey(name: 'duration_days') @Default(0) int durationDays,
    SubscriptionFeatures? features,
  }) = _SubscriptionPlan;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanFromJson(json);
}

@freezed
class CurrentSubscription with _$CurrentSubscription {
  const factory CurrentSubscription({
    @JsonKey(name: 'subscription_tier') @Default('free') String subscriptionTier,
    @JsonKey(name: 'subscription_expires_at') String? subscriptionExpiresAt,
    @JsonKey(name: 'days_remaining') @Default(0) int daysRemaining,
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
    SubscriptionPlan? plan,
  }) = _CurrentSubscription;

  factory CurrentSubscription.fromJson(Map<String, dynamic> json) =>
      _$CurrentSubscriptionFromJson(json);
}
