// lib/features/notifications/domain/notification_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';
part 'notification_entity.g.dart';

@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required String type,
    required String title,
    @Default('') String body,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'sent_at') String? sentAt,
    @JsonKey(name: 'read_at') String? readAt,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}

@freezed
class NotificationsResponse with _$NotificationsResponse {
  const factory NotificationsResponse({
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    @Default([]) List<NotificationItem> results,
  }) = _NotificationsResponse;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
}
