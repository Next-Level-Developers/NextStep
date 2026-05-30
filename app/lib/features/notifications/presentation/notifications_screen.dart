// lib/features/notifications/presentation/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_error_view.dart';
import 'notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _typeIcon(String type) {
    switch (type) {
      case 'recommendation_ready':
        return Icons.stars_rounded;
      case 'roadmap_milestone':
        return Icons.flag_rounded;
      case 'new_story':
        return Icons.auto_stories_rounded;
      case 'system_alert':
        return Icons.info_outline_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'recommendation_ready':
        return AppColors.primary;
      case 'roadmap_milestone':
        return AppColors.success;
      case 'new_story':
        return AppColors.secondary;
      case 'system_alert':
        return Colors.orange;
      default:
        return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              ref.read(markReadNotifierProvider.notifier).markAllAsRead();
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notifsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => NSErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (response) {
          if (response.results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none_rounded,
                      size: 64, color: AppColors.muted),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No notifications yet',
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
                ref.invalidate(notificationsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: response.results.length,
              itemBuilder: (context, index) {
                final notif = response.results[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  elevation: notif.isRead ? 0 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: notif.isRead
                          ? AppColors.outlineMedium
                          : _typeColor(notif.type).withOpacity(0.3),
                    ),
                  ),
                  color: notif.isRead
                      ? Colors.white
                      : _typeColor(notif.type).withOpacity(0.03),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: _typeColor(notif.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _typeIcon(notif.type),
                        color: _typeColor(notif.type),
                        size: 22,
                      ),
                    ),
                    title: Text(
                      notif.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight:
                            notif.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: notif.body.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.only(top: AppSpacing.xxs),
                            child: Text(
                              notif.body,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.muted,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : null,
                    trailing: notif.isRead
                        ? null
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _typeColor(notif.type),
                              shape: BoxShape.circle,
                            ),
                          ),
                    onTap: () {
                      if (!notif.isRead) {
                        ref
                            .read(markReadNotifierProvider.notifier)
                            .markAsRead(notif.id);
                      }
                    },
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
