// lib/features/onboarding/domain/profiler_repository.dart
import 'question_entity.dart';
import 'profiler_session_entity.dart';
import 'interest_profile_entity.dart';

abstract class ProfilerRepository {
  /// Fetches the set of questionnaire questions.
  Future<List<QuestionEntity>> getQuestions();

  /// Starts a new profiler session on the server.
  Future<ProfilerSessionEntity> startSession();

  /// Fetches an in-progress profiler session by ID to resume progress.
  Future<ProfilerSessionEntity> getSession(String sessionId);

  /// Submits one or more responses to the profiler session.
  /// Each response maps to a question answer.
  Future<Map<String, dynamic>> submitResponses({
    required String sessionId,
    required List<Map<String, dynamic>> responses,
  });

  /// Completes the session, running backend matching engines and scoring.
  /// Returns a map containing the computed interest profile.
  Future<Map<String, dynamic>> completeSession(String sessionId);

  /// Gets the currently active interest profile for the student.
  Future<InterestProfileEntity> getInterestProfile();
}
