// lib/features/ai_chat/domain/conversation_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_entity.freezed.dart';
part 'conversation_entity.g.dart';

@freezed
class ConversationCareerBrief with _$ConversationCareerBrief {
  const factory ConversationCareerBrief({
    required String slug,
    required String name,
  }) = _ConversationCareerBrief;

  factory ConversationCareerBrief.fromJson(Map<String, dynamic> json) =>
      _$ConversationCareerBriefFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String role,
    required String content,
    @JsonKey(name: 'tokens_used') int? tokensUsed,
    @JsonKey(name: 'model_version') String? modelVersion,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
class ConversationListItem with _$ConversationListItem {
  const factory ConversationListItem({
    required String id,
    @JsonKey(name: 'conversation_type') String? conversationType,
    ConversationCareerBrief? career,
    String? title,
    @JsonKey(name: 'message_count') @Default(0) int messageCount,
    @JsonKey(name: 'last_message_at') String? lastMessageAt,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ConversationListItem;

  factory ConversationListItem.fromJson(Map<String, dynamic> json) =>
      _$ConversationListItemFromJson(json);
}

@freezed
class ConversationDetail with _$ConversationDetail {
  const factory ConversationDetail({
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'conversation_type') String? conversationType,
    ConversationCareerBrief? career,
    String? title,
    @JsonKey(name: 'message_count') @Default(0) int messageCount,
    @JsonKey(name: 'started_at') String? startedAt,
    @JsonKey(name: 'last_message_at') String? lastMessageAt,
    @Default([]) List<ChatMessage> messages,
  }) = _ConversationDetail;

  factory ConversationDetail.fromJson(Map<String, dynamic> json) =>
      _$ConversationDetailFromJson(json);
}
