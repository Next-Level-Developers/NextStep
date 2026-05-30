import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/api/api_response.dart';
import '../domain/profiler_repository.dart';
import '../domain/question_entity.dart';
import '../domain/profiler_session_entity.dart';
import '../domain/interest_profile_entity.dart';
import 'profiler_remote_source.dart';

class ProfilerRepositoryImpl implements ProfilerRepository {
  final ProfilerRemoteSource _remoteSource;

  ProfilerRepositoryImpl(this._remoteSource);

  // Hive Box names
  static const String _questionsBoxName = 'profiler_questions_box';
  static const String _pendingAnswersBoxName = 'pending_answers_box';

  @override
  Future<List<QuestionEntity>> getQuestions() async {
    final box = await Hive.openBox(_questionsBoxName);
    
    // Check if we have cached questions
    if (box.isNotEmpty) {
      try {
        final cachedList = box.get('questions') as List<dynamic>;
        final questions = cachedList
            .map((item) => QuestionEntity.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        
        // Fetch background update to keep cache fresh
        _updateQuestionsCacheInBackground(box);

        return questions;
      } catch (_) {
        // Fallback to network if cache parsing fails
      }
    }

    // No cache or failed to parse, fetch from network
    final questions = await _remoteSource.getQuestions();
    await box.put('questions', questions.map((q) => q.toJson()).toList());
    return questions;
  }

  Future<void> _updateQuestionsCacheInBackground(Box box) async {
    try {
      final questions = await _remoteSource.getQuestions();
      await box.put('questions', questions.map((q) => q.toJson()).toList());
    } catch (_) {
      // Fail silently in background
    }
  }

  @override
  Future<ProfilerSessionEntity> startSession() async {
    return _remoteSource.startSession();
  }

  @override
  Future<ProfilerSessionEntity> getSession(String sessionId) async {
    return _remoteSource.getSession(sessionId);
  }

  @override
  Future<Map<String, dynamic>> submitResponses({
    required String sessionId,
    required List<Map<String, dynamic>> responses,
  }) async {
    try {
      // Attempt remote submission
      final result = await _remoteSource.submitResponses(
        sessionId: sessionId,
        responses: responses,
      );

      // Attempt to clear any pending queue since connection is working
      await _processPendingAnswers(sessionId);

      return result;
    } on NetworkException {
      // Queue offline responses in Hive
      final box = await Hive.openBox(_pendingAnswersBoxName);
      final list = box.get(sessionId, defaultValue: []) as List<dynamic>;
      final updatedList = List<Map<String, dynamic>>.from(list.map((e) => Map<String, dynamic>.from(e as Map)));
      updatedList.addAll(responses);
      await box.put(sessionId, updatedList);

      // Mock progress response for local UI continuation
      return {
        'session_id': sessionId,
        'questions_answered': -1, // Flag offline mode
        'offline_queued': true,
      };
    }
  }

  /// Processes queued offline responses.
  Future<void> _processPendingAnswers(String sessionId) async {
    final box = await Hive.openBox(_pendingAnswersBoxName);
    if (!box.containsKey(sessionId)) return;

    final queued = box.get(sessionId) as List<dynamic>;
    if (queued.isEmpty) return;

    final responses = List<Map<String, dynamic>>.from(queued.map((e) => Map<String, dynamic>.from(e as Map)));

    try {
      await _remoteSource.submitResponses(
        sessionId: sessionId,
        responses: responses,
      );
      await box.delete(sessionId);
    } catch (_) {
      // If retry fails, keep them in queue
    }
  }

  @override
  Future<Map<String, dynamic>> completeSession(String sessionId) async {
    // Process remaining pending answers first
    await _processPendingAnswers(sessionId);
    return _remoteSource.completeSession(sessionId);
  }

  @override
  Future<InterestProfileEntity> getInterestProfile() async {
    return _remoteSource.getInterestProfile();
  }
}

final profilerRepositoryProvider = Provider<ProfilerRepository>((ref) {
  final remoteSource = ref.watch(profilerRemoteSourceProvider);
  return ProfilerRepositoryImpl(remoteSource);
});
