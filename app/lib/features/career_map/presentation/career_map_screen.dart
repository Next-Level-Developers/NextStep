// lib/features/career_map/presentation/career_map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import '../../home/presentation/recommendation_provider.dart';
import '../../home/domain/recommendation_entity.dart';

class CareerMapScreen extends ConsumerWidget {
  const CareerMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recsAsync = ref.watch(recommendationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Career Matches'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(RouteNames.notifications),
          ),
        ],
      ),
      body: recsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => NSErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(recommendationsProvider),
        ),
        data: (data) {
          if (data.recommendations.isEmpty) {
            return _buildEmptyState(theme);
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(recommendationsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: data.recommendations.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildHeader(theme, data);
                }
                final rec = data.recommendations[index - 1];
                return _RecommendationCard(rec: rec);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, RecommendationsResponse data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${data.totalMatches} careers matched',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Based on your interest profile',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars_rounded, size: 72, color: AppColors.primary),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Recommendations Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Complete the profiler to get personalized career matches.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final RecommendationItem rec;

  const _RecommendationCard({required this.rec});

  Color _tierColor(String? tier) {
    switch (tier) {
      case 'full_match':
        return AppColors.success;
      case 'partial_match':
        return AppColors.secondary;
      case 'discovery_match':
        return AppColors.primary;
      default:
        return AppColors.muted;
    }
  }

  String _tierLabel(String? tier) {
    switch (tier) {
      case 'full_match':
        return 'Full Match';
      case 'partial_match':
        return 'Partial Match';
      case 'discovery_match':
        return 'Discovery';
      default:
        return 'Match';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final career = rec.career;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(RouteNames.careerPath(career.slug)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Rank badge
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#${rec.rank}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          career.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (career.oneLiner != null)
                          Text(
                            career.oneLiner!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  // Match score
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: _tierColor(rec.matchTier).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${rec.matchScore}%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: _tierColor(rec.matchTier),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  if (career.domainShortName != null) ...[
                    _InfoChip(
                      icon: Icons.category_outlined,
                      label: career.domainShortName!,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  _InfoChip(
                    icon: Icons.trending_up_rounded,
                    label: 'Future: ${career.futureScore}/10',
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  if (career.salaryEntryLpa != null)
                    _InfoChip(
                      icon: Icons.currency_rupee_rounded,
                      label: '${career.salaryEntryLpa} LPA',
                    ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _tierColor(rec.matchTier).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _tierLabel(rec.matchTier),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _tierColor(rec.matchTier),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.muted),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
