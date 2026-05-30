// lib/features/ai_chat/data/chat_remote_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/dio_error_handler.dart';
import '../domain/conversation_entity.dart';

class ChatRemoteSource {
  final ApiClient _apiClient;

  ChatRemoteSource(this._apiClient);

  /// List conversations.
  Future<List<ConversationListItem>> listConversations({
    String? conversationType,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (conversationType != null) {
        queryParams['conversation_type'] = conversationType;
      }

      final response = await _apiClient.get(
        ApiEndpoints.aiConversations,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from conversations');
      }

      final apiResponse = ApiResponse<List<ConversationListItem>>.fromJson(
        data,
        (json) => (json as List)
            .map((e) =>
                ConversationListItem.fromJson(e as Map<String, dynamic>))
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

  /// Start a new conversation.
  Future<ConversationDetail> startConversation({
    required String conversationType,
    String? careerSlug,
    required String firstMessage,
  }) async {
    try {
      final body = <String, dynamic>{
        'conversation_type': conversationType,
        'first_message': firstMessage,
      };
      if (careerSlug != null) body['career_slug'] = careerSlug;

      final response = await _apiClient.post(
        ApiEndpoints.aiConversations,
        data: body,
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from start conversation');
      }

      final apiResponse = ApiResponse<ConversationDetail>.fromJson(
        data,
        (json) =>
            ConversationDetail.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get conversation history.
  Future<ConversationDetail> getConversation(String conversationId) async {
    try {
      final response = await _apiClient
          .get(ApiEndpoints.aiConversation(conversationId));

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from get conversation');
      }

      final apiResponse = ApiResponse<ConversationDetail>.fromJson(
        data,
        (json) =>
            ConversationDetail.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.isSuccess) {
        throw apiErrorToException(apiResponse.error!);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Send a message to a conversation.
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.aiConversationMessages(conversationId),
        data: {'content': content},
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty response from send message');
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

  /// Delete a conversation.
  Future<void> deleteConversation(String conversationId) async {
    try {
      await _apiClient.delete(ApiEndpoints.aiConversation(conversationId));
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}

final chatRemoteSourceProvider = Provider<ChatRemoteSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatRemoteSource(apiClient);
});
