// lib/features/career_detail/presentation/career_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import '../../../../core/widgets/ns_snackbar.dart';
import '../domain/career_detail_entity.dart';
import '../../roadmap/presentation/roadmap_provider.dart';
import 'career_detail_provider.dart';
import 'widgets/real_story_card.dart';
import 'widgets/learning_resource_card.dart';

class CareerDetailScreen extends ConsumerWidget {
  final String slug;

  const CareerDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(careerDetailProvider(slug));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: NSErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(careerDetailProvider(slug)),
          ),
        ),
        data: (career) => CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  career.name,
                  style: const TextStyle(fontSize: 16),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        if (career.domain?.shortName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              career.domain!.shortName!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // One liner
                    if (career.oneLiner != null)
                      Text(
                        career.oneLiner!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),

                    // Stats row
                    _StatsRow(career: career),
                    const SizedBox(height: AppSpacing.lg),

                    // Salary section
                    _SectionTitle(title: '💰 Salary Ranges (LPA)'),
                    const SizedBox(height: AppSpacing.sm),
                    _SalaryCard(career: career),
                    const SizedBox(height: AppSpacing.lg),

                    // Skills needed
                    if (career.skillsNeeded.isNotEmpty) ...[
                      _SectionTitle(title: '🛠️ Skills Needed'),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: career.skillsNeeded
                            .map((s) => Chip(
                                  label: Text(s),
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.08),
                                  labelStyle:
                                      theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Entry paths
                    if (career.entryPaths.isNotEmpty) ...[
                      _SectionTitle(title: '🎓 Entry Paths'),
                      const SizedBox(height: AppSpacing.sm),
                      ...career.entryPaths.map((path) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.xs),
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_right_rounded,
                                    color: AppColors.primary),
                                Expanded(
                                  child: Text(path,
                                      style: theme.textTheme.bodyMedium),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Typical day
                    if (career.typicalDay != null) ...[
                      _SectionTitle(title: '📅 A Typical Day'),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        career.typicalDay!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Future score reasoning
                    if (career.futureScoreReasoning != null) ...[
                      _SectionTitle(title: '🔮 Future Outlook'),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        career.futureScoreReasoning!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Real people stories
                    if (career.realPeopleStories.isNotEmpty) ...[
                      _SectionTitle(title: '👥 Real People Stories'),
                      const SizedBox(height: AppSpacing.sm),
                      ...career.realPeopleStories
                          .map((story) => RealStoryCard(story: story)),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Learning resources
                    if (career.learningResources.isNotEmpty) ...[
                      _SectionTitle(title: '📚 Learning Resources'),
                      const SizedBox(height: AppSpacing.sm),
                      ...career.learningResources
                          .map((resource) =>
                              LearningResourceCard(resource: resource)),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Related careers
                    if (career.relatedCareers.isNotEmpty) ...[
                      _SectionTitle(title: '🔗 Related Careers'),
                      const SizedBox(height: AppSpacing.sm),
                      ...career.relatedCareers.map((rc) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(rc.name),
                            subtitle: rc.oneLiner != null
                                ? Text(rc.oneLiner!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)
                                : null,
                            trailing: Text(
                              '${rc.futureScore}/10',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () => context
                                .push(RouteNames.careerPath(rc.slug)),
                          )),
                    ],

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: detailAsync.whenOrNull(
        data: (career) => Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final notifier =
                        ref.read(createRoadmapNotifierProvider.notifier);
                    final roadmap = await notifier.create(career.slug);
                    if (roadmap != null && context.mounted) {
                      NSSnackbar.showSuccess(context, 'Roadmap created!');
                      context.push(RouteNames.roadmapPath(roadmap.id));
                    }
                  },
                  icon: const Icon(Icons.map_rounded),
                  label: const Text('Start Roadmap'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () {
                  // Navigate to AI chat about this career
                  context.push(RouteNames.homeAi);
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final CareerDetailEntity career;
  const _StatsRow({required this.career});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _StatBadge(
          label: 'Future Score',
          value: '${career.futureScore}/10',
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        if (career.indiaViability != null)
          _StatBadge(
            label: 'India Viability',
            value: career.indiaViability!.toUpperCase(),
            color: career.indiaViability == 'high'
                ? AppColors.success
                : AppColors.secondary,
          ),
        if (career.isEmerging) ...[
          const SizedBox(width: AppSpacing.sm),
          _StatBadge(
            label: 'Status',
            value: '🚀 Emerging',
            color: AppColors.secondary,
          ),
        ],
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withOpacity(0.7),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalaryCard extends StatelessWidget {
  final CareerDetailEntity career;
  const _SalaryCard({required this.career});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.outlineMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SalaryItem(
              label: 'Entry',
              value: career.salaryEntryLpa ?? '-',
              theme: theme,
            ),
            Container(width: 1, height: 40, color: AppColors.outlineMedium),
            _SalaryItem(
              label: 'Mid',
              value: career.salaryMidLpa ?? '-',
              theme: theme,
            ),
            Container(width: 1, height: 40, color: AppColors.outlineMedium),
            _SalaryItem(
              label: 'Senior',
              value: career.salarySeniorLpa ?? '-',
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _SalaryItem extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _SalaryItem({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '₹$value',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
