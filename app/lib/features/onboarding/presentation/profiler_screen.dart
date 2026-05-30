// lib/features/onboarding/presentation/profiler_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/ns_button.dart';
import '../../../core/widgets/ns_loader.dart';
import 'onboarding_provider.dart';
import 'widgets/option_tile.dart';
import 'widgets/progress_bar.dart';
import 'widgets/question_card.dart';
import 'widgets/section_transition.dart';

class ProfilerScreen extends ConsumerWidget {
  const ProfilerScreen({super.key});

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Profiler?'),
        content: const Text(
          'Your progress will be saved. You can continue where you left off from the welcome screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(onboardingNotifierProvider);
    final theme = Theme.of(context);

    // Watch for done state to route to ProfileBuildingScreen
    ref.listen(onboardingNotifierProvider, (prev, next) {
      if (next.value?.status == OnboardingStatus.done) {
        context.go(RouteNames.onboardingBuilding);
      }
    });

    return stateAsync.when(
      loading: () => const NSLoader.fullScreen(message: 'Scaffolding profiler session...'),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 50, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text('Error starting profiler: $err'),
              const SizedBox(height: AppSpacing.lg),
              NSButton.secondary(
                width: 150,
                label: 'Retry',
                onPressed: () => ref
                    .read(onboardingNotifierProvider.notifier)
                    .startOrResumeSession(),
              )
            ],
          ),
        ),
      ),
      data: (state) {
        if (state.status == OnboardingStatus.loading) {
          return const NSLoader.fullScreen(message: 'Preparing your questionnaire...');
        }

        if (state.status == OnboardingStatus.submitting) {
          return const NSLoader.fullScreen(message: 'Computing your profile weights...');
        }

        if (state.status == OnboardingStatus.transitioning) {
          return SectionTransitionWidget(
            nextSectionLabel: state.transitioningSectionLabel ?? '',
            onDismiss: () =>
                ref.read(onboardingNotifierProvider.notifier).dismissTransition(),
          );
        }

        final currentQuestion = state.currentQuestion;
        if (currentQuestion == null) {
          return const NSLoader.fullScreen(message: 'Completing session...');
        }

        final currentCode = currentQuestion.code;
        final selectedAnswers = state.answers[currentCode] ?? [];
        final isSelectionRequired = currentQuestion.isScored;
        final isNextEnabled = !isSelectionRequired || selectedAnswers.isNotEmpty;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final shouldExit = await _showExitConfirmation(context);
            if (shouldExit && context.mounted) {
              context.go(RouteNames.login);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.onSurface),
                onPressed: () async {
                  if (state.currentIndex > 0) {
                    ref.read(onboardingNotifierProvider.notifier).previousQuestion();
                  } else {
                    final shouldExit = await _showExitConfirmation(context);
                    if (shouldExit && context.mounted) {
                      context.go(RouteNames.login);
                    }
                  }
                },
              ),
              title: Text(
                currentQuestion.sectionLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: ProgressBar(
                      current: state.currentIndex,
                      total: state.questions.length,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Question Area (Animated switcher for smooth fade transition)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: QuestionCard(
                              key: ValueKey<String>(currentQuestion.code),
                              questionText: currentQuestion.questionText,
                              instructionText: currentQuestion.instruction,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Options list
                          ...currentQuestion.options.map((option) {
                            final isSelected = selectedAnswers.contains(option.index);
                            return OptionTile(
                              key: ValueKey<String>('${currentQuestion.code}_${option.index}'),
                              text: option.text,
                              emoji: option.emoji,
                              isSelected: isSelected,
                              onTap: () => ref
                                  .read(onboardingNotifierProvider.notifier)
                                  .selectOption(option.index),
                            );
                          }),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Bar
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: AppColors.outlineMedium,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Skip option (only if skipping is allowed)
                        if (!isSelectionRequired)
                          Expanded(
                            child: NSButton.text(
                              label: 'Skip',
                              onPressed: () => ref
                                  .read(onboardingNotifierProvider.notifier)
                                  .skipQuestion(),
                            ),
                          )
                        else
                          const Spacer(),
                        const SizedBox(width: AppSpacing.md),
                        // Next button
                        Expanded(
                          child: NSButton.primary(
                            label: state.currentIndex == state.questions.length - 1
                                ? 'Complete'
                                : 'Next',
                            onPressed: isNextEnabled
                                ? () => ref
                                    .read(onboardingNotifierProvider.notifier)
                                    .nextQuestion()
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
