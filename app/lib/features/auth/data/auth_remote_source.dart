// lib/features/auth/data/auth_remote_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_response.dart';
import '../domain/user_entity.dart';

class AuthRemoteSource {
  final ApiClient _apiClient;

  AuthRemoteSource(this._apiClient);

  /// Exchanges a Firebase ID token for a Django JWT pair (access + refresh) and returns the User profile.
  Future<Map<String, dynamic>> exchangeFirebaseToken(String firebaseToken) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.firebaseExchange,
        data: {'firebase_token': firebaseToken},
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from auth exchange');
      }

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetches the user profile details from `/users/me/`.
  Future<UserEntity> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.me);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from users/me');
      }

      final apiResponse = ApiResponse<UserEntity>.fromJson(
        data,
        (json) => UserEntity.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Updates the extended student profile on `/users/me/student-profile/`.
  Future<StudentProfileEntity> updateStudentProfile(StudentProfileEntity profile) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.meStudentProfile,
        data: profile.toJson(),
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from student profile update');
      }

      final apiResponse = ApiResponse<StudentProfileEntity>.fromJson(
        data,
        (json) => StudentProfileEntity.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkException('Connection timed out. Please check your internet connection.');
    }

    final response = error.response;
    if (response != null && response.data != null) {
      try {
        final errJson = response.data;
        if (errJson is Map<String, dynamic> && errJson.containsKey('error')) {
          final apiError = ApiError.fromJson(errJson['error'] as Map<String, dynamic>);
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
}

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteSource(apiClient);
});
