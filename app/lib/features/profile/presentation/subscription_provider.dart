// lib/features/profile/presentation/subscription_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/profile_remote_source.dart';
import '../domain/subscription_entity.dart';

/// Provider for subscription plans.
final subscriptionPlansProvider =
    FutureProvider<List<SubscriptionPlan>>((ref) async {
  final source = ref.watch(profileRemoteSourceProvider);
  return source.getSubscriptionPlans();
});

/// Provider for current subscription status.
final currentSubscriptionProvider =
    FutureProvider<CurrentSubscription>((ref) async {
  final source = ref.watch(profileRemoteSourceProvider);
  return source.getCurrentSubscription();
});
