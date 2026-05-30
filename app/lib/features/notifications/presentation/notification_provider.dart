// lib/features/notifications/presentation/notification_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notification_remote_source.dart';
import '../domain/notification_entity.dart';

/// Provider for notifications list.
final notificationsProvider =
    FutureProvider<NotificationsResponse>((ref) async {
  final source = ref.watch(notificationRemoteSourceProvider);
  return source.listNotifications();
});

/// Derived provider for unread count.
final unreadCountProvider = Provider<int>((ref) {
  final notifs = ref.watch(notificationsProvider);
  return notifs.when(
    data: (data) => data.unreadCount,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Notifier for marking notifications read.
class MarkReadNotifier extends StateNotifier<AsyncValue<void>> {
  final NotificationRemoteSource _source;
  final Ref _ref;

  MarkReadNotifier(this._source, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> markAsRead(String notificationId) async {
    try {
      await _source.markAsRead(notificationId);
      _ref.invalidate(notificationsProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();
    try {
      await _source.markAllAsRead();
      _ref.invalidate(notificationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final markReadNotifierProvider =
    StateNotifierProvider<MarkReadNotifier, AsyncValue<void>>((ref) {
  final source = ref.watch(notificationRemoteSourceProvider);
  return MarkReadNotifier(source, ref);
});

/// Notifier for managing foreground notifications from FCM.
class NotificationsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  NotificationsNotifier() : super([]);

  void addNotification(Map<String, dynamic> notification) {
    state = [notification, ...state];
  }

  void removeNotification(String id) {
    state = state.where((n) => n['id'] != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

final notificationsNotifierProvider =
    StateNotifierProvider<NotificationsNotifier, List<Map<String, dynamic>>>(
        (ref) {
  return NotificationsNotifier();
});
