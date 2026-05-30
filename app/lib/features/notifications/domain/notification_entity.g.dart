// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationItemImpl _$$NotificationItemImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationItemImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      sentAt: json['sent_at'] as String?,
      readAt: json['read_at'] as String?,
    );

Map<String, dynamic> _$$NotificationItemImplToJson(
        _$NotificationItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'is_read': instance.isRead,
      'sent_at': instance.sentAt,
      'read_at': instance.readAt,
    };

_$NotificationsResponseImpl _$$NotificationsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationsResponseImpl(
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NotificationsResponseImplToJson(
        _$NotificationsResponseImpl instance) =>
    <String, dynamic>{
      'unread_count': instance.unreadCount,
      'results': instance.results,
    };
