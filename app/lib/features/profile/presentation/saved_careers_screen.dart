// lib/features/profile/presentation/saved_careers_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import '../../home/presentation/recommendation_provider.dart';

class SavedCareersScreen extends ConsumerWidget {
  const SavedCareersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final savedAsync = ref.watch(savedCareersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Careers'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: savedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => NSErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(savedCareersProvider),
        ),
        data: (savedList) {
          if (savedList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_outline_rounded,
                      size: 64, color: AppColors.muted),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No saved careers',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Save careers from detail pages to see them here.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(savedCareersProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final item = savedList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                    title: Text(
                      item.career.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.career.domainShortName != null)
                          Text(
                            item.career.domainShortName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                        if (item.career.salaryEntryLpa != null)
                          Text(
                            '₹${item.career.salaryEntryLpa} LPA entry',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${item.career.futureScore}/10',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Future',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.muted,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => context
                        .push(RouteNames.careerPath(item.career.slug)),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
