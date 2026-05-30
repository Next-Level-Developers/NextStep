// lib/features/ai_chat/presentation/chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_remote_source.dart';
import '../domain/conversation_entity.dart';

/// Provider for conversations list.
final conversationsProvider =
    FutureProvider<List<ConversationListItem>>((ref) async {
  final source = ref.watch(chatRemoteSourceProvider);
  return source.listConversations();
});

/// Family provider for conversation detail.
final conversationDetailProvider =
    FutureProvider.family<ConversationDetail, String>(
        (ref, conversationId) async {
  final source = ref.watch(chatRemoteSourceProvider);
  return source.getConversation(conversationId);
});

/// Notifier for starting a new conversation.
class StartConversationNotifier
    extends StateNotifier<AsyncValue<ConversationDetail?>> {
  final ChatRemoteSource _source;
  final Ref _ref;

  StartConversationNotifier(this._source, this._ref)
      : super(const AsyncValue.data(null));

  Future<ConversationDetail?> start({
    required String conversationType,
    String? careerSlug,
    required String firstMessage,
  }) async {
    state = const AsyncValue.loading();
    try {
      final conversation = await _source.startConversation(
        conversationType: conversationType,
        careerSlug: careerSlug,
        firstMessage: firstMessage,
      );
      _ref.invalidate(conversationsProvider);
      state = AsyncValue.data(conversation);
      return conversation;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final startConversationNotifierProvider = StateNotifierProvider<
    StartConversationNotifier, AsyncValue<ConversationDetail?>>((ref) {
  final source = ref.watch(chatRemoteSourceProvider);
  return StartConversationNotifier(source, ref);
});

/// Notifier for sending messages within a conversation.
class SendMessageNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRemoteSource _source;
  final Ref _ref;

  SendMessageNotifier(this._source, this._ref)
      : super(const AsyncValue.data(null));

  Future<Map<String, dynamic>?> send({
    required String conversationId,
    required String content,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _source.sendMessage(
        conversationId: conversationId,
        content: content,
      );
      _ref.invalidate(conversationDetailProvider(conversationId));
      _ref.invalidate(conversationsProvider);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final sendMessageNotifierProvider =
    StateNotifierProvider<SendMessageNotifier, AsyncValue<void>>((ref) {
  final source = ref.watch(chatRemoteSourceProvider);
  return SendMessageNotifier(source, ref);
});

/// Notifier for deleting a conversation.
class DeleteConversationNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRemoteSource _source;
  final Ref _ref;

  DeleteConversationNotifier(this._source, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> delete(String conversationId) async {
    state = const AsyncValue.loading();
    try {
      await _source.deleteConversation(conversationId);
      _ref.invalidate(conversationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final deleteConversationNotifierProvider =
    StateNotifierProvider<DeleteConversationNotifier, AsyncValue<void>>((ref) {
  final source = ref.watch(chatRemoteSourceProvider);
  return DeleteConversationNotifier(source, ref);
});
