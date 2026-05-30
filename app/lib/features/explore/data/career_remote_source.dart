// lib/features/explore/data/career_remote_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/dio_error_handler.dart';
import '../domain/career_entity.dart';

class CareerRemoteSource {
  final ApiClient _apiClient;

  CareerRemoteSource(this._apiClient);

  /// List careers with optional search/filter/pagination.
  Future<CareerListResponse> listCareers({
    String? search,
    String? domainSlug,
    String? dimensionTags,
    String? indiaViability,
    int? futureScoreMin,
    bool? isEmerging,
    String ordering = '-future_score',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
        'ordering': ordering,
      };
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (domainSlug != null) queryParams['domain_slug'] = domainSlug;
      if (dimensionTags != null) queryParams['dimension_tags'] = dimensionTags;
      if (indiaViability != null) queryParams['india_viability'] = indiaViability;
      if (futureScoreMin != null) queryParams['future_score_min'] = futureScoreMin;
      if (isEmerging != null) queryParams['is_emerging'] = isEmerging;

      final response = await _apiClient.get(
        ApiEndpoints.careers,
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from careers endpoint');
      }

      final apiResponse = ApiResponse<CareerListResponse>.fromJson(
        data,
        (json) => CareerListResponse.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get full career details by slug.
  Future<Map<String, dynamic>> getCareerDetail(String slug) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.career(slug));
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from career detail');
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

  /// List all career domains.
  Future<List<CareerDomainEntity>> listDomains() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.careerDomains);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from domains');
      }

      final apiResponse = ApiResponse<List<CareerDomainEntity>>.fromJson(
        data,
        (json) => (json as List)
            .map((e) => CareerDomainEntity.fromJson(e as Map<String, dynamic>))
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

  /// Compare 2-3 careers.
  Future<Map<String, dynamic>> compareCareers(List<String> slugs) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.careerCompare,
        queryParameters: {'slugs': slugs.join(',')},
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from career compare');
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
}

final careerRemoteSourceProvider = Provider<CareerRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CareerRemoteSource(apiClient);
});
