// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationCareerBriefImpl _$$ConversationCareerBriefImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationCareerBriefImpl(
      slug: json['slug'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$ConversationCareerBriefImplToJson(
        _$ConversationCareerBriefImpl instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
    };

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      tokensUsed: (json['tokens_used'] as num?)?.toInt(),
      modelVersion: json['model_version'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'tokens_used': instance.tokensUsed,
      'model_version': instance.modelVersion,
      'created_at': instance.createdAt,
    };

_$ConversationListItemImpl _$$ConversationListItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationListItemImpl(
      id: json['id'] as String,
      conversationType: json['conversation_type'] as String?,
      career: json['career'] == null
          ? null
          : ConversationCareerBrief.fromJson(
              json['career'] as Map<String, dynamic>),
      title: json['title'] as String?,
      messageCount: (json['message_count'] as num?)?.toInt() ?? 0,
      lastMessageAt: json['last_message_at'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ConversationListItemImplToJson(
        _$ConversationListItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_type': instance.conversationType,
      'career': instance.career,
      'title': instance.title,
      'message_count': instance.messageCount,
      'last_message_at': instance.lastMessageAt,
      'is_active': instance.isActive,
    };

_$ConversationDetailImpl _$$ConversationDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationDetailImpl(
      conversationId: json['conversation_id'] as String,
      conversationType: json['conversation_type'] as String?,
      career: json['career'] == null
          ? null
          : ConversationCareerBrief.fromJson(
              json['career'] as Map<String, dynamic>),
      title: json['title'] as String?,
      messageCount: (json['message_count'] as num?)?.toInt() ?? 0,
      startedAt: json['started_at'] as String?,
      lastMessageAt: json['last_message_at'] as String?,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ConversationDetailImplToJson(
        _$ConversationDetailImpl instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'conversation_type': instance.conversationType,
      'career': instance.career,
      'title': instance.title,
      'message_count': instance.messageCount,
      'started_at': instance.startedAt,
      'last_message_at': instance.lastMessageAt,
      'messages': instance.messages,
    };
