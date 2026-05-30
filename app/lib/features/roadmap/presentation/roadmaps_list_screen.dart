// lib/features/roadmap/presentation/roadmaps_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import '../domain/roadmap_entity.dart';
import 'roadmap_provider.dart';

class RoadmapsListScreen extends ConsumerWidget {
  const RoadmapsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final roadmapsAsync = ref.watch(roadmapListProvider);
    final summaryAsync = ref.watch(progressSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Roadmaps'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: roadmapsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => NSErrorView(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(roadmapListProvider);
            ref.invalidate(progressSummaryProvider);
          },
        ),
        data: (roadmaps) {
          if (roadmaps.isEmpty) {
            return _buildEmptyState(theme);
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(roadmapListProvider);
              ref.invalidate(progressSummaryProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: roadmaps.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return summaryAsync.when(
                    data: (summary) => _ProgressSummaryCard(summary: summary),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                }
                final roadmap = roadmaps[index - 1];
                return _RoadmapCard(roadmap: roadmap);
              },
            ),
          );
        },
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
            const Icon(Icons.map_outlined, size: 72, color: AppColors.muted),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Roadmaps Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Explore careers and start a roadmap to track your journey.',
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

class _ProgressSummaryCard extends StatelessWidget {
  final ProgressSummary summary;
  const _ProgressSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
      ),
      color: AppColors.primary.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Progress',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: summary.overallCompletionPercent / 100,
                      minHeight: 10,
                      backgroundColor: AppColors.outline,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${summary.overallCompletionPercent}%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${summary.completedSteps}/${summary.totalStepsAcrossAll} steps completed across ${summary.activeRoadmaps} roadmaps',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoadmapCard extends StatelessWidget {
  final RoadmapListItem roadmap;
  const _RoadmapCard({required this.roadmap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(RouteNames.roadmapPath(roadmap.id)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.map_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roadmap.career.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (roadmap.career.domainShortName != null)
                          Text(
                            roadmap.career.domainShortName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${roadmap.completionPercent}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: roadmap.completionPercent / 100,
                  minHeight: 6,
                  backgroundColor: AppColors.outline,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${roadmap.completedSteps}/${roadmap.totalSteps} steps completed',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
