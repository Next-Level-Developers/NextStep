// lib/features/home/data/recommendation_remote_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/dio_error_handler.dart';
import '../domain/recommendation_entity.dart';

class RecommendationRemoteSource {
  final ApiClient _apiClient;

  RecommendationRemoteSource(this._apiClient);

  /// Get personalized recommendations.
  Future<RecommendationsResponse> getRecommendations({
    String? tier,
    int limit = 15,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (tier != null) queryParams['tier'] = tier;

      final response = await _apiClient.get(
        ApiEndpoints.recommendations,
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from recommendations');
      }

      final apiResponse = ApiResponse<RecommendationsResponse>.fromJson(
        data,
        (json) =>
            RecommendationsResponse.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Regenerate recommendations.
  Future<void> regenerateRecommendations() async {
    try {
      final response =
          await _apiClient.post(ApiEndpoints.recommendationsRegenerate);
      final data = response.data;
      if (data != null) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          data,
          (json) => json as Map<String, dynamic>,
        );
        if (!apiResponse.isSuccess && apiResponse.error != null) {
          throw apiErrorToException(apiResponse.error!);
        }
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// List saved careers.
  Future<List<SavedCareerItem>> listSavedCareers() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.savedCareers);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from saved careers');
      }

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      final results = apiResponse.data!['results'] as List? ?? [];
      return results
          .map((e) => SavedCareerItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Save a career.
  Future<void> saveCareer(String slug) async {
    try {
      await _apiClient.post(
        ApiEndpoints.savedCareers,
        data: {'career_slug': slug},
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Unsave a career.
  Future<void> unsaveCareer(String slug) async {
    try {
      await _apiClient.delete(ApiEndpoints.savedCareer(slug));
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}

final recommendationRemoteSourceProvider =
    Provider<RecommendationRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RecommendationRemoteSource(apiClient);
});
