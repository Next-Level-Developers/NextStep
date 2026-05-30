// lib/core/api/interceptors/refresh_interceptor.dart
import 'package:dio/dio.dart';
import '../../auth/token_storage.dart';
import '../api_endpoints.dart';

/// Handles 401 responses by attempting to refresh the Django JWT.
/// If successful, retries the failed request; otherwise, clears tokens.
class RefreshInterceptor extends QueuedInterceptor {
  final Dio _dio;

  RefreshInterceptor(this._dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only intercept 401 Unauthorized errors
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    // Avoid infinite loop if refresh or login fails with 401
    if (requestOptions.path.contains(ApiEndpoints.tokenRefresh) ||
        requestOptions.path.contains(ApiEndpoints.firebaseExchange)) {
      return handler.next(err);
    }

    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await TokenStorage.clearAll();
      return handler.next(err);
    }

    try {
      // Perform token refresh request using a clean Dio instance
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final response = await refreshDio.post(
        ApiEndpoints.tokenRefresh,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          final access = data['data']['access'];
          if (access != null) {
            // Save the new access token
            await TokenStorage.saveAccessToken(access);

            // Update the Authorization header and retry the original request
            requestOptions.headers['Authorization'] = 'Bearer $access';

            final retryResponse = await _dio.fetch(requestOptions);
            return handler.resolve(retryResponse);
          }
        }
      }
    } catch (e) {
      // If refresh fails, clear all tokens and let routing redirect
      await TokenStorage.clearAll();
    }

    return handler.next(err);
  }
}
