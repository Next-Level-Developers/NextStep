// lib/features/explore/presentation/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import '../domain/career_entity.dart';
import 'explore_provider.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  String? _selectedDomain;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(careerListProvider.notifier).search(query);
  }

  void _onDomainSelected(String? slug) {
    setState(() => _selectedDomain = slug);
    ref.read(careerListProvider.notifier).filterByDomain(slug);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final careersAsync = ref.watch(careerListProvider);
    final domainsAsync = ref.watch(careerDomainsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explore Careers'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search careers...',
                prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),

          // Domain filter chips
          domainsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (domains) => SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: domains.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: _selectedDomain == null,
                        onSelected: (_) => _onDomainSelected(null),
                        selectedColor: AppColors.primaryLight,
                        checkmarkColor: AppColors.primary,
                      ),
                    );
                  }
                  final domain = domains[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: FilterChip(
                      label: Text(domain.shortName ?? domain.name),
                      selected: _selectedDomain == domain.slug,
                      onSelected: (_) => _onDomainSelected(
                        _selectedDomain == domain.slug ? null : domain.slug,
                      ),
                      selectedColor: AppColors.primaryLight,
                      checkmarkColor: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Career list
          Expanded(
            child: careersAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => NSErrorView(
                message: error.toString(),
                onRetry: () =>
                    ref.read(careerListProvider.notifier).refresh(),
              ),
              data: (response) {
                if (response.results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 56,
                          color: AppColors.muted,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No careers found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.read(careerListProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    itemCount: response.results.length,
                    itemBuilder: (context, index) {
                      final career = response.results[index];
                      return _CareerCard(career: career);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerCard extends StatelessWidget {
  final CareerListItem career;

  const _CareerCard({required this.career});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  Expanded(
                    child: Text(
                      career.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (career.isEmerging)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '🚀 Emerging',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                ],
              ),
              if (career.oneLiner != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  career.oneLiner!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  if (career.domain?.shortName != null) ...[
                    Icon(Icons.category_outlined,
                        size: 14, color: AppColors.muted),
                    const SizedBox(width: 3),
                    Text(
                      career.domain!.shortName!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Icon(Icons.trending_up_rounded,
                      size: 14, color: AppColors.muted),
                  const SizedBox(width: 3),
                  Text(
                    '${career.futureScore}/10',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (career.salaryEntryLpa != null) ...[
                    Icon(Icons.currency_rupee_rounded,
                        size: 14, color: AppColors.muted),
                    const SizedBox(width: 3),
                    Text(
                      '${career.salaryEntryLpa} LPA',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
