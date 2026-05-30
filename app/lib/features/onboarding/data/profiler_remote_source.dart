// lib/features/onboarding/data/profiler_remote_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_response.dart';
import '../domain/question_entity.dart';
import '../domain/profiler_session_entity.dart';
import '../domain/interest_profile_entity.dart';

class ProfilerRemoteSource {
  final ApiClient _apiClient;

  ProfilerRemoteSource(this._apiClient);

  /// Fetches questions from `/profiler/questions/`
  Future<List<QuestionEntity>> getQuestions() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profilerQuestions);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from questions endpoint');
      }

      final apiResponse = ApiResponse<List<QuestionEntity>>.fromJson(
        data,
        (json) => (json as List)
            .map((item) => QuestionEntity.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Starts a session by calling `POST /profiler/sessions/`
  Future<ProfilerSessionEntity> startSession() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.profilerSessions);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from start session');
      }

      final apiResponse = ApiResponse<ProfilerSessionEntity>.fromJson(
        data,
        (json) => ProfilerSessionEntity.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Resumes a session from `GET /profiler/sessions/{sessionId}/`
  Future<ProfilerSessionEntity> getSession(String sessionId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profilerSession(sessionId));
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from get session');
      }

      final apiResponse = ApiResponse<ProfilerSessionEntity>.fromJson(
        data,
        (json) => ProfilerSessionEntity.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Submits responses: `POST /profiler/sessions/{sessionId}/responses/`
  Future<Map<String, dynamic>> submitResponses({
    required String sessionId,
    required List<Map<String, dynamic>> responses,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.profilerResponses(sessionId),
        data: {'responses': responses},
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from submit responses');
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

  /// Completes session: `POST /profiler/sessions/{sessionId}/complete/`
  Future<Map<String, dynamic>> completeSession(String sessionId) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.profilerComplete(sessionId));
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from complete session');
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

  /// Gets active interest profile: `GET /profiler/profile/`
  Future<InterestProfileEntity> getInterestProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profilerProfile);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from profile get');
      }

      final apiResponse = ApiResponse<InterestProfileEntity>.fromJson(
        data,
        (json) => InterestProfileEntity.fromJson(json as Map<String, dynamic>),
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
        // Fallback
      }
    }

    return ServerException(
      error.message ?? 'An unexpected server error occurred.',
      code: 'SERVER_ERROR',
    );
  }
}

final profilerRemoteSourceProvider = Provider<ProfilerRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfilerRemoteSource(apiClient);
});
