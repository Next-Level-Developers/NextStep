// lib/core/api/dio_error_handler.dart
import 'package:dio/dio.dart';
import 'api_response.dart';

/// Shared DioException → AppException mapper used by all remote data sources.
AppException handleDioError(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.connectionError) {
    return const NetworkException(
      'Connection timed out. Please check your internet connection.',
    );
  }

  final response = error.response;
  if (response != null && response.data != null) {
    try {
      final errJson = response.data;
      if (errJson is Map<String, dynamic> && errJson.containsKey('error')) {
        final apiError =
            ApiError.fromJson(errJson['error'] as Map<String, dynamic>);
        return apiErrorToException(apiError);
      }
    } catch (_) {
      // Fallback if parsing fails
    }
  }

  return ServerException(
    error.message ?? 'An unexpected server error occurred.',
    code: 'SERVER_ERROR',
  );
}
