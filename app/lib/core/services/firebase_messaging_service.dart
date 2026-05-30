import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/notifications/presentation/notification_provider.dart';
import '../auth/token_storage.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import 'package:dio/dio.dart';

/// Service for handling Firebase Cloud Messaging (FCM).
/// Manages device token registration and notification handling.
class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Ref _ref;

  FirebaseMessagingService(this._ref);

  /// Initialize Firebase Messaging and set up notification handlers.
  Future<void> initialize() async {
    try {
      // Request notification permissions (iOS)
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Get and register device token
      await _registerDeviceToken();

      // Set up foreground notification handlers
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Set up background notification handler (called when app is in background)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Handle token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('🔔 FCM Token refreshed: $newToken');
        _uploadDeviceToken(newToken);
      });

      debugPrint('✅ Firebase Messaging initialized successfully');
    } catch (e) {
      debugPrint('❌ Firebase Messaging initialization failed: $e');
    }
  }

  /// Fetch and register device token with backend.
  Future<void> _registerDeviceToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null && token.isNotEmpty) {
        debugPrint('🔔 Device FCM Token: $token');
        await _uploadDeviceToken(token);
      } else {
        debugPrint('⚠️ Failed to get FCM token');
      }
    } catch (e) {
      debugPrint('❌ Error registering device token: $e');
    }
  }

  /// Upload device token to backend.
  Future<void> _uploadDeviceToken(String token) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.post(
        ApiEndpoints.meDeviceToken,
        data: {'device_token': token, 'platform': 'android'},
      );
      debugPrint('✅ Device token registered with backend');
    } catch (e) {
      debugPrint('⚠️ Error uploading device token: $e');
      // Non-fatal - don't crash if token upload fails
    }
  }

  /// Handle notification when app is in foreground.
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📬 Foreground notification received');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    // Update local notifications provider
    final notificationData = {
      'id': message.messageId ?? '',
      'title': message.notification?.title ?? 'Notification',
      'body': message.notification?.body ?? '',
      'timestamp': DateTime.now().toIso8601String(),
      'data': message.data,
      'read': false,
    };

    _ref.read(notificationsNotifierProvider.notifier).addNotification(
          notificationData,
        );

    // Show local notification (optional - Firebase usually handles this)
    // You can use flutter_local_notifications for custom UI
  }

  /// Handle notification when app is opened from background.
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('🔔 App opened from notification');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');

    // Handle deep links based on notification data
    final data = message.data;
    final deepLink = data['deep_link'] as String?;
    final type = data['type'] as String?;

    if (deepLink != null && deepLink.isNotEmpty) {
      // Navigate to the deep link
      // This is handled by GoRouter's deeplink mechanism
      debugPrint('🔗 Deep link: $deepLink');
    }

    // Handle specific notification types
    switch (type) {
      case 'career_update':
        debugPrint('Career update notification');
        break;
      case 'roadmap_milestone':
        debugPrint('Roadmap milestone notification');
        break;
      case 'message':
        debugPrint('Message notification');
        break;
      default:
        break;
    }
  }
}

/// Provider for Firebase Messaging Service.
final firebaseMessagingServiceProvider =
    Provider<FirebaseMessagingService>((ref) {
  return FirebaseMessagingService(ref);
});
