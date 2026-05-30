// lib/features/profile/presentation/subscription_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import '../domain/subscription_entity.dart';
import 'subscription_provider.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final plansAsync = ref.watch(subscriptionPlansProvider);
    final currentAsync = ref.watch(currentSubscriptionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Subscription'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current status card
            currentAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
              data: (current) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: current.subscriptionTier != 'free'
                        ? AppColors.secondary
                        : AppColors.outlineMedium,
                    width: 1.5,
                  ),
                ),
                color: current.subscriptionTier != 'free'
                    ? AppColors.secondary.withOpacity(0.04)
                    : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Icon(
                        current.subscriptionTier != 'free'
                            ? Icons.diamond_rounded
                            : Icons.account_circle_outlined,
                        size: 48,
                        color: current.subscriptionTier != 'free'
                            ? AppColors.secondary
                            : AppColors.muted,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        current.subscriptionTier != 'free'
                            ? '💎 Premium Active'
                            : 'Free Plan',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: current.subscriptionTier != 'free'
                              ? AppColors.secondary
                              : AppColors.onSurface,
                        ),
                      ),
                      if (current.daysRemaining > 0)
                        Text(
                          '${current.daysRemaining} days remaining',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              'Available Plans',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Plans list
            plansAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => NSErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(subscriptionPlansProvider),
              ),
              data: (plans) => Column(
                children: plans
                    .map((plan) => _PlanCard(plan: plan))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.displayName ?? plan.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '₹${plan.priceInr}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Text(
              '${plan.durationDays} days',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (plan.features != null) ...[
              _FeatureRow(
                icon: Icons.stars_rounded,
                text: '${plan.features!.careerMatches} career matches',
              ),
              _FeatureRow(
                icon: Icons.chat_bubble_rounded,
                text: '${plan.features!.aiMessagesPerDay} AI messages/day',
              ),
              _FeatureRow(
                icon: Icons.map_rounded,
                text: '${plan.features!.roadmapStepsVisible} roadmap steps',
              ),
              if (plan.features!.careerComparison)
                const _FeatureRow(
                  icon: Icons.compare_arrows_rounded,
                  text: 'Career comparison',
                ),
              if (plan.features!.parentShare)
                const _FeatureRow(
                  icon: Icons.share_rounded,
                  text: 'Share with parents',
                ),
            ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Integrate Razorpay payment flow
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment integration coming soon!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Subscribe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.success),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
