// lib/features/roadmap/presentation/roadmap_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import '../../../../core/widgets/ns_snackbar.dart';
import '../domain/roadmap_entity.dart';
import 'roadmap_provider.dart';

class RoadmapDetailScreen extends ConsumerWidget {
  final String roadmapId;

  const RoadmapDetailScreen({super.key, required this.roadmapId});

  String _categoryLabel(String category) {
    switch (category) {
      case 'first_30_days':
        return '🚀 First 30 Days';
      case 'skill_to_learn':
        return '🛠️ Skills to Learn';
      case 'long_term':
        return '🎯 Long Term Goals';
      case 'resource':
        return '📚 Resources';
      default:
        return '📋 ${category.replaceAll('_', ' ')}';
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'in_progress':
        return Icons.timelapse_rounded;
      default:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'in_progress':
        return AppColors.secondary;
      default:
        return AppColors.muted;
    }
  }

  String _nextStatus(String current) {
    switch (current) {
      case 'not_started':
        return 'in_progress';
      case 'in_progress':
        return 'completed';
      case 'completed':
        return 'not_started';
      default:
        return 'in_progress';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final detailAsync = ref.watch(roadmapDetailProvider(roadmapId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Roadmap'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => NSErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(roadmapDetailProvider(roadmapId)),
        ),
        data: (roadmap) {
          // Group steps by category
          final grouped = <String, List<RoadmapStep>>{};
          for (final step in roadmap.steps) {
            grouped.putIfAbsent(step.category, () => []).add(step);
          }

          final completedCount =
              roadmap.steps.where((s) => s.status == 'completed').length;
          final progressPercent = roadmap.steps.isEmpty
              ? 0.0
              : completedCount / roadmap.steps.length;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Career header
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                      color: AppColors.primaryLight, width: 1.5),
                ),
                color: AppColors.primary.withOpacity(0.04),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roadmap.career.name,
                        style: theme.textTheme.titleMedium?.copyWith(
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
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progressPercent,
                                minHeight: 10,
                                backgroundColor: AppColors.outline,
                                valueColor: const AlwaysStoppedAnimation(
                                    AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '${(progressPercent * 100).round()}%',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '$completedCount/${roadmap.steps.length} steps completed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Steps by category
              ...grouped.entries.map((entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _categoryLabel(entry.key),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ...entry.value.map((step) => Card(
                            margin: const EdgeInsets.only(
                                bottom: AppSpacing.xs),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: _statusColor(step.status)
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xxs,
                              ),
                              leading: IconButton(
                                icon: Icon(
                                  _statusIcon(step.status),
                                  color: _statusColor(step.status),
                                  size: 28,
                                ),
                                onPressed: () async {
                                  final newStatus =
                                      _nextStatus(step.status);
                                  await ref
                                      .read(stepProgressNotifierProvider
                                          .notifier)
                                      .updateStep(
                                        roadmapId: roadmapId,
                                        stepId: step.id,
                                        status: newStatus,
                                      );
                                  if (context.mounted) {
                                    NSSnackbar.showSuccess(
                                      context,
                                      'Step updated to ${newStatus.replaceAll('_', ' ')}',
                                    );
                                  }
                                },
                              ),
                              title: Text(
                                step.title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  decoration: step.status == 'completed'
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: step.status == 'completed'
                                      ? AppColors.muted
                                      : null,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  if (step.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: AppSpacing.xxs),
                                      child: Text(
                                        step.description,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppColors.muted,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  if (step.timeframe != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: AppSpacing.xxs),
                                      child: Text(
                                        '⏱ ${step.timeframe}',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color:
                                              AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              isThreeLine:
                                  step.description.isNotEmpty,
                            ),
                          )),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }
}
