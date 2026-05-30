// lib/core/api/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../auth/token_storage.dart';

/// Attaches the Django JWT access token and app version to every outgoing request.
class AuthInterceptor extends Interceptor {
  /// Endpoints that do not require authentication.
  static const Set<String> noAuthEndpoints = {
    'auth/firebase/',
    'share/profile/', // Parent view endpoint (token in URL, not header)
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check if this endpoint requires auth
    final pathRequiresAuth = !noAuthEndpoints.any((endpoint) {
      return options.path.contains(endpoint);
    });

    // Attach Bearer token only if required
    if (pathRequiresAuth) {
      final token = await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    // Attach app version header
    try {
      final info = await PackageInfo.fromPlatform();
      options.headers['X-App-Version'] =
          '${info.version}+${info.buildNumber}';
    } catch (_) {
      // Non-fatal — version header is informational only
    }

    handler.next(options);
  }
}
