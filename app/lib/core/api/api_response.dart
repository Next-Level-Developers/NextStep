// lib/core/api/api_response.dart

/// Standard API error detail object.
class ApiError {
  final String code;
  final String message;
  final Map<String, dynamic> details;

  const ApiError({
    required this.code,
    required this.message,
    this.details = const {},
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        code: json['code'] as String? ?? 'UNKNOWN_ERROR',
        message: json['message'] as String? ?? 'An unexpected error occurred.',
        details: (json['details'] as Map<String, dynamic>?) ?? {},
      );

  @override
  String toString() => 'ApiError(code: $code, message: $message)';
}

/// Generic response envelope matching the server contract:
/// { "success": bool, "data": T?, "message": String?, "error": ApiError? }
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final ApiError? error;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  bool get isSuccess => success && error == null;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromData,
  ) {
    final bool success = json['success'] as bool? ?? false;
    return ApiResponse(
      success: success,
      message: json['message'] as String?,
      data: json['data'] != null ? fromData(json['data']) : null,
      error: json['error'] != null
          ? ApiError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
    );
  }

  factory ApiResponse.error(ApiError error) => ApiResponse(
        success: false,
        error: error,
      );

  factory ApiResponse.success(T data, {String? message}) => ApiResponse(
        success: true,
        data: data,
        message: message,
      );
}

// ── Strongly-typed App Exceptions ─────────────────────────────────────────────

sealed class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

final class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

final class SubscriptionException extends AppException {
  const SubscriptionException(super.message, {super.code});
}

final class ProfilerException extends AppException {
  const ProfilerException(super.message, {super.code});
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

final class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

final class ValidationException extends AppException {
  final Map<String, dynamic> fieldErrors;
  const ValidationException(super.message, {super.code, this.fieldErrors = const {}});
}

final class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code});
}

/// Converts an [ApiError] code to a typed [AppException].
AppException apiErrorToException(ApiError error) {
  switch (error.code) {
    case 'INVALID_FIREBASE_TOKEN':
    case 'TOKEN_EXPIRED':
    case 'AUTHENTICATION_REQUIRED':
      return AuthException(error.message, code: error.code);
    case 'SUBSCRIPTION_REQUIRED':
    case 'SUBSCRIPTION_EXPIRED':
      return SubscriptionException(error.message, code: error.code);
    case 'PROFILER_NOT_COMPLETED':
    case 'PROFILER_SESSION_NOT_FOUND':
      return ProfilerException(error.message, code: error.code);
    case 'NOT_FOUND':
      return NotFoundException(error.message, code: error.code);
    default:
      return ServerException(error.message, code: error.code);
  }
}
