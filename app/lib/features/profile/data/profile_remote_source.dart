// lib/features/profile/data/profile_remote_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/dio_error_handler.dart';
import '../domain/subscription_entity.dart';

class ProfileRemoteSource {
  final ApiClient _apiClient;

  ProfileRemoteSource(this._apiClient);

  /// List subscription plans.
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.subscriptionPlans);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from plans');
      }

      final apiResponse = ApiResponse<List<SubscriptionPlan>>.fromJson(
        data,
        (json) => (json as List)
            .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
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

  /// Get current subscription.
  Future<CurrentSubscription> getCurrentSubscription() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.subscriptionMe);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from subscription me');
      }

      final apiResponse = ApiResponse<CurrentSubscription>.fromJson(
        data,
        (json) => CurrentSubscription.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Upload avatar.
  Future<String> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.post(
        ApiEndpoints.meAvatar,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from avatar upload');
      }

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!['avatar_url'] as String? ?? '';
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Generate share token for parents.
  Future<Map<String, dynamic>> generateShareToken() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.meShareToken);
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from share token');
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

  /// Update user profile (name, phone).
  Future<Map<String, dynamic>> updateUserProfile({
    String? fullName,
    String? phone,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (phone != null) body['phone'] = phone;

      final response = await _apiClient.patch(
        ApiEndpoints.me,
        data: body,
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from profile update');
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

final profileRemoteSourceProvider = Provider<ProfileRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRemoteSource(apiClient);
});
