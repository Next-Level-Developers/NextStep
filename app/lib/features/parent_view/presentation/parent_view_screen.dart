import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import './parent_view_provider.dart';
import './widgets/parent_career_card.dart';

class ParentViewScreen extends ConsumerWidget {
  final String shareToken;

  const ParentViewScreen({super.key, required this.shareToken});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(parentViewProvider(shareToken));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Child\'s Career Path'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.onSurface,
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => NSErrorView(
          message: 'Failed to load profile: $error',
          onRetry: () => ref.invalidate(parentViewProvider(shareToken)),
        ),
        data: (profile) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student info card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.studentName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (profile.academicStage != null)
                        Text(
                          'Academic Stage: ${profile.academicStage}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      if (profile.profilerCompletedAt != null)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            'Profile Updated: ${profile.lastUpdatedAt}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Top careers section
                if (profile.topCareers.isNotEmpty) ...[
                  Text(
                    '🎯 Top Career Matches',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...profile.topCareers
                      .map((career) => ParentCareerCard(
                            career: career,
                            isSaved:
                                profile.savedCareers.any((s) => s.slug == career.slug),
                          ))
                      .toList(),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Saved careers section
                if (profile.savedCareers.isNotEmpty) ...[
                  Text(
                    '⭐ Saved Careers',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...profile.savedCareers
                      .map((career) => ParentCareerCard(
                            career: career,
                            isSaved: true,
                          ))
                      .toList(),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Roadmap status
                if (profile.activeRoadmapCount > 0)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.map_outlined,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📍 Active Roadmaps',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '${profile.activeRoadmapCount} career path${profile.activeRoadmapCount > 1 ? 's' : ''} in progress',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: AppSpacing.xl),

                // Footer
                Center(
                  child: Column(
                    children: [
                      Text(
                        'This is a read-only view shared by your child',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Download NextStep to explore your own career path',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
