// lib/features/roadmap/data/roadmap_remote_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/dio_error_handler.dart';
import '../domain/roadmap_entity.dart';

class RoadmapRemoteSource {
  final ApiClient _apiClient;

  RoadmapRemoteSource(this._apiClient);

  /// List user's roadmaps.
  Future<List<RoadmapListItem>> listRoadmaps() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.roadmaps);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from roadmaps');
      }

      final apiResponse = ApiResponse<List<RoadmapListItem>>.fromJson(
        data,
        (json) => (json as List)
            .map((e) => RoadmapListItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Create a roadmap for a career.
  Future<RoadmapDetail> createRoadmap(String careerSlug) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.roadmaps,
        data: {'career_slug': careerSlug},
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from create roadmap');
      }

      final apiResponse = ApiResponse<RoadmapDetail>.fromJson(
        data,
        (json) => RoadmapDetail.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get roadmap details.
  Future<RoadmapDetail> getRoadmapDetail(String roadmapId) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.roadmap(roadmapId));
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from roadmap detail');
      }

      final apiResponse = ApiResponse<RoadmapDetail>.fromJson(
        data,
        (json) => RoadmapDetail.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Update step progress.
  Future<Map<String, dynamic>> updateStepProgress({
    required String roadmapId,
    required String stepId,
    required String status,
    String? notes,
  }) async {
    try {
      final body = <String, dynamic>{'status': status};
      if (notes != null) body['notes'] = notes;

      final response = await _apiClient.patch(
        ApiEndpoints.roadmapStep(roadmapId, stepId),
        data: body,
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from step update');
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

  /// Get progress summary across all roadmaps.
  Future<ProgressSummary> getProgressSummary() async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.roadmapProgressSummary);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from progress summary');
      }

      final apiResponse = ApiResponse<ProgressSummary>.fromJson(
        data,
        (json) => ProgressSummary.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}

final roadmapRemoteSourceProvider = Provider<RoadmapRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RoadmapRemoteSource(apiClient);
});
