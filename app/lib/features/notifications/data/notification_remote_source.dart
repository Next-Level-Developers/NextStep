// lib/features/notifications/data/notification_remote_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/dio_error_handler.dart';
import '../domain/notification_entity.dart';

class NotificationRemoteSource {
  final ApiClient _apiClient;

  NotificationRemoteSource(this._apiClient);

  /// List notifications.
  Future<NotificationsResponse> listNotifications({bool? isRead}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (isRead != null) queryParams['is_read'] = isRead;

      final response = await _apiClient.get(
        ApiEndpoints.notifications,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from notifications');
      }

      final apiResponse = ApiResponse<NotificationsResponse>.fromJson(
        data,
        (json) =>
            NotificationsResponse.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Mark a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient
          .patch(ApiEndpoints.notificationRead(notificationId));
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Mark all notifications as read.
  Future<int> markAllAsRead() async {
    try {
      final response =
          await _apiClient.post(ApiEndpoints.notificationsMarkAllRead);
      final data = response.data;
      if (data != null) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          data,
          (json) => json as Map<String, dynamic>,
        );
        if (apiResponse.isSuccess) {
          return apiResponse.data?['marked_read_count'] as int? ?? 0;
        }
      }
      return 0;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}

final notificationRemoteSourceProvider =
    Provider<NotificationRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRemoteSource(apiClient);
});
