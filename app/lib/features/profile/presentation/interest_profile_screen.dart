// lib/features/profile/presentation/interest_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import '../../../../core/utils/dimension_label.dart';
import '../../onboarding/data/profiler_remote_source.dart';
import '../../onboarding/domain/interest_profile_entity.dart';

/// Provider for the active interest profile.
final interestProfileProvider =
    FutureProvider.autoDispose<InterestProfileEntity>((ref) async {
  final source = ref.watch(profilerRemoteSourceProvider);
  return source.getInterestProfile();
});

class InterestProfileScreen extends ConsumerWidget {
  const InterestProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(interestProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Interest Dimensions'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => NSErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(interestProfileProvider),
        ),
        data: (profile) {
          final scores = profile.dimensionScores;
          if (scores.isEmpty) {
            return const Center(
              child: Text('No dimension scores available.'),
            );
          }

          // Sort by score descending
          final sortedEntries = scores.entries.toList()
            ..sort((a, b) => (b.value as num).compareTo(a.value as num));

          final maxScore = sortedEntries.isNotEmpty
              ? (sortedEntries.first.value as num).toDouble()
              : 10.0;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Top dimensions card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: AppColors.primaryLight,
                    width: 1.5,
                  ),
                ),
                color: AppColors.primary.withOpacity(0.04),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🌟 Your Top Dimensions',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: profile.topDimensions
                            .map((dim) => Chip(
                                  label: Text(
                                    DimensionLabel.getLabel(dim),
                                  ),
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.12),
                                  labelStyle:
                                      theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'All Dimension Scores',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Score bars
              ...sortedEntries.map((entry) {
                final code = entry.key;
                final score = (entry.value as num).toDouble();
                final isTop = profile.topDimensions.contains(code);
                final normalizedWidth =
                    maxScore > 0 ? score / maxScore : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DimensionLabel.getLabel(code),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: isTop
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isTop
                                    ? AppColors.primary
                                    : AppColors.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            score.toStringAsFixed(1),
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isTop
                                  ? AppColors.primary
                                  : AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: normalizedWidth.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: AppColors.outline,
                          valueColor: AlwaysStoppedAnimation(
                            isTop ? AppColors.primary : AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
