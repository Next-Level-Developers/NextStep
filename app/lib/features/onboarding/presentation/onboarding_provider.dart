// lib/features/onboarding/presentation/onboarding_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../auth/data/auth_repository_impl.dart';
import '../../auth/domain/user_entity.dart';
import '../data/profiler_repository_impl.dart';
import '../domain/question_entity.dart';
import '../domain/profiler_session_entity.dart';
import '../domain/interest_profile_entity.dart';

part 'onboarding_provider.g.dart';

enum OnboardingStatus { idle, loading, active, transitioning, submitting, done, error }

class OnboardingState {
  final OnboardingStatus status;
  final List<QuestionEntity> questions;
  final int currentIndex;
  final ProfilerSessionEntity? session;
  final Map<String, List<int>> answers; // questionCode -> selectedOptionIndexes
  final InterestProfileEntity? interestProfile;
  final String? errorMessage;
  final String? transitioningSectionLabel;

  OnboardingState({
    this.status = OnboardingStatus.idle,
    this.questions = const [],
    this.currentIndex = 0,
    this.session,
    this.answers = const {},
    this.interestProfile,
    this.errorMessage,
    this.transitioningSectionLabel,
  });

  QuestionEntity? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  double get progress {
    if (questions.isEmpty) return 0.0;
    return currentIndex / questions.length;
  }

  OnboardingState copyWith({
    OnboardingStatus? status,
    List<QuestionEntity>? questions,
    int? currentIndex,
    ProfilerSessionEntity? session,
    Map<String, List<int>>? answers,
    InterestProfileEntity? interestProfile,
    String? errorMessage,
    String? transitioningSectionLabel,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      session: session ?? this.session,
      answers: answers ?? this.answers,
      interestProfile: interestProfile ?? this.interestProfile,
      errorMessage: errorMessage ?? this.errorMessage,
      transitioningSectionLabel: transitioningSectionLabel ?? this.transitioningSectionLabel,
    );
  }
}

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  FutureOr<OnboardingState> build() async {
    return OnboardingState();
  }

  /// Initialise or resume a profiler session.
  Future<void> startOrResumeSession({bool isRetake = false}) async {
    state = AsyncValue.data(state.value!.copyWith(status: OnboardingStatus.loading));
    try {
      final repo = ref.read(profilerRepositoryProvider);
      
      // Fetch questions
      final questions = await repo.getQuestions();
      
      // Start or resume session
      ProfilerSessionEntity session;
      if (isRetake) {
        session = await repo.startSession();
      } else {
        // Try starting new or resuming if session_id is found, otherwise start new
        // For security, if it fails to resume, we default to starting a new session
        try {
          session = await repo.startSession();
        } catch (_) {
          session = await repo.startSession();
        }
      }

      // Resume index calculations
      int resumeIndex = 0;
      if (session.lastAnsweredCode != null) {
        final lastIndex = questions.indexWhere((q) => q.code == session.lastAnsweredCode);
        if (lastIndex != -1 && lastIndex + 1 < questions.length) {
          resumeIndex = lastIndex + 1;
        }
      }

      state = AsyncValue.data(
        OnboardingState(
          status: OnboardingStatus.active,
          questions: questions,
          session: session,
          currentIndex: resumeIndex,
          answers: {},
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Selects an option index for the current question
  void selectOption(int optionIndex) {
    final currentState = state.value!;
    final currentQuestion = currentState.currentQuestion;
    if (currentQuestion == null) return;

    final currentCode = currentQuestion.code;
    final maxSelections = currentQuestion.maxSelections;
    final currentAnswers = List<int>.from(currentState.answers[currentCode] ?? []);

    if (currentQuestion.questionType == 'single_select') {
      // Single select replacement
      state = AsyncValue.data(
        currentState.copyWith(
          answers: {
            ...currentState.answers,
            currentCode: [optionIndex],
          },
        ),
      );
      // Auto-advance single-select questions with a short delay for smooth animation
      Future.delayed(const Duration(milliseconds: 300), () {
        nextQuestion();
      });
    } else {
      // Multi-select toggle
      if (currentAnswers.contains(optionIndex)) {
        currentAnswers.remove(optionIndex);
      } else {
        if (currentAnswers.length < maxSelections) {
          currentAnswers.add(optionIndex);
        }
      }

      state = AsyncValue.data(
        currentState.copyWith(
          answers: {
            ...currentState.answers,
            currentCode: currentAnswers,
          },
        ),
      );
    }
  }

  /// Submits the current question answer and advances
  Future<void> nextQuestion() async {
    final currentState = state.value!;
    final currentQuestion = currentState.currentQuestion;
    if (currentQuestion == null) return;

    final currentCode = currentQuestion.code;
    final currentAnswers = currentState.answers[currentCode] ?? [];

    // Verify selection is present unless question can be skipped
    if (currentAnswers.isEmpty && currentQuestion.isScored) {
      // Prevent advancing without selecting if it's required
      return;
    }

    // Submit answer in background
    _submitAnswerInBackground(
      currentState.session!.sessionId,
      currentQuestion,
      currentAnswers,
      false,
    );

    // Check if we need to show a Section Transition
    final isLastOfSection = _isLastOfSection(currentState.currentIndex, currentState.questions);
    final isLastQuestion = currentState.currentIndex == currentState.questions.length - 1;

    if (isLastQuestion) {
      // Finished all questions! Move to completing state
      await completeSession();
    } else if (isLastOfSection) {
      final nextQ = currentState.questions[currentState.currentIndex + 1];
      state = AsyncValue.data(
        currentState.copyWith(
          status: OnboardingStatus.transitioning,
          transitioningSectionLabel: nextQ.sectionLabel,
        ),
      );
    } else {
      state = AsyncValue.data(
        currentState.copyWith(
          currentIndex: currentState.currentIndex + 1,
        ),
      );
    }
  }

  /// Skips the current question
  Future<void> skipQuestion() async {
    final currentState = state.value!;
    final currentQuestion = currentState.currentQuestion;
    if (currentQuestion == null) return;

    final currentCode = currentQuestion.code;

    // Submit skipped answer in background
    _submitAnswerInBackground(
      currentState.session!.sessionId,
      currentQuestion,
      [],
      true,
    );

    final isLastOfSection = _isLastOfSection(currentState.currentIndex, currentState.questions);
    final isLastQuestion = currentState.currentIndex == currentState.questions.length - 1;

    if (isLastQuestion) {
      await completeSession();
    } else if (isLastOfSection) {
      final nextQ = currentState.questions[currentState.currentIndex + 1];
      state = AsyncValue.data(
        currentState.copyWith(
          status: OnboardingStatus.transitioning,
          transitioningSectionLabel: nextQ.sectionLabel,
        ),
      );
    } else {
      state = AsyncValue.data(
        currentState.copyWith(
          currentIndex: currentState.currentIndex + 1,
        ),
      );
    }
  }

  /// Go back to previous question
  void previousQuestion() {
    final currentState = state.value!;
    if (currentState.currentIndex > 0) {
      state = AsyncValue.data(
        currentState.copyWith(
          currentIndex: currentState.currentIndex - 1,
        ),
      );
    }
  }

  /// Dismisses section transition and activates next question
  void dismissTransition() {
    final currentState = state.value!;
    state = AsyncValue.data(
      currentState.copyWith(
        status: OnboardingStatus.active,
        currentIndex: currentState.currentIndex + 1,
      ),
    );
  }

  /// Completes the session on backend and computes interest profile.
  Future<void> completeSession() async {
    final currentState = state.value!;
    state = AsyncValue.data(currentState.copyWith(status: OnboardingStatus.submitting));

    try {
      final repo = ref.read(profilerRepositoryProvider);
      final response = await repo.completeSession(currentState.session!.sessionId);

      final profileJson = response['interest_profile'] as Map<String, dynamic>;
      final profile = InterestProfileEntity.fromJson(profileJson);

      // Invalidate current user to refresh `profiler_completed = true` status
      ref.invalidate(currentUserProvider);

      state = AsyncValue.data(
        currentState.copyWith(
          status: OnboardingStatus.done,
          interestProfile: profile,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  bool _isLastOfSection(int index, List<QuestionEntity> questions) {
    if (index >= questions.length - 1) return false;
    final currentQ = questions[index];
    final nextQ = questions[index + 1];
    return currentQ.section != nextQ.section;
  }

  Future<void> _submitAnswerInBackground(
    String sessionId,
    QuestionEntity question,
    List<int> selections,
    bool skipped,
  ) async {
    final repo = ref.read(profilerRepositoryProvider);
    
    // For Student Context questions (SC-1 to SC-3), submit student-profile update after SC-3
    if (question.section == 'context') {
      if (question.code == 'SC-3' && selections.isNotEmpty) {
        // Collect choices and save student profile
        final sc1Answers = state.value!.answers['SC-1'] ?? [0];
        final sc2Answers = state.value!.answers['SC-2'] ?? [0];
        final sc3Answers = selections;

        final authRepo = ref.read(authRepositoryProvider);
        authRepo.updateStudentProfile(
          StudentProfileEntity(
            academicStage: _mapSc1ToStage(sc1Answers.first),
            careerClarity: _mapSc2ToClarity(sc2Answers.first),
            pressureLevel: _mapSc3ToPressure(sc3Answers.first),
          ),
        );
      }
    }

    try {
      await repo.submitResponses(
        sessionId: sessionId,
        responses: [
          {
            'question_code': question.code,
            'question_section': question.section,
            'selected_option_index': selections,
            'skipped': skipped,
          }
        ],
      );
    } catch (_) {
      // Repository handles queueing offline and retry internally.
    }
  }

  String _mapSc1ToStage(int index) {
    switch (index) {
      case 0: return 'grade_8_9';
      case 1: return 'grade_10';
      case 2: return 'grade_11_12_science';
      case 3: return 'grade_11_12_commerce';
      case 4: return 'grade_11_12_arts';
      default: return 'college_year_1_2';
    }
  }

  String _mapSc2ToClarity(int index) {
    switch (index) {
      case 0: return 'clear';
      case 1: return 'few_options';
      case 2: return 'none';
      default: return 'wants_to_explore';
    }
  }

  String _mapSc3ToPressure(int index) {
    switch (index) {
      case 0: return 'high';
      case 1: return 'some';
      case 2: return 'low';
      default: return 'very_high';
    }
  }
}
