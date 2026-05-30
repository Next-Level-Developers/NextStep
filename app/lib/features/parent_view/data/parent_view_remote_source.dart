import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/dio_error_handler.dart';
import '../domain/parent_profile_entity.dart';

class ParentViewRemoteSource {
  final ApiClient _apiClient;

  ParentViewRemoteSource(this._apiClient);

  /// Fetch parent view data by share token (no auth required).
  /// This endpoint must be called without JWT token.
  Future<Map<String, dynamic>> getSharedProfile(String shareToken) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.parentShare(shareToken),
        // Note: This endpoint requires no authentication
        // The ApiClient interceptor should skip auth for this endpoint
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from parent share endpoint');
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
      throw handleDioError(e);
    }
  }

  /// Generate a share token for the current student's profile.
  /// Requires authentication.
  Future<String> generateShareToken() async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.generateParentShareToken,
        data: {},
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException(
            'Empty response from generate share token endpoint');
      }

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      final token = apiResponse.data?['share_token'] as String?;
      if (token == null) {
        throw const ValidationException('No share token in response');
      }

      return token;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}

final parentViewRemoteSourceProvider = Provider<ParentViewRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ParentViewRemoteSource(apiClient);
});
