// lib/features/onboarding/presentation/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_button.dart';
import '../../auth/presentation/auth_provider.dart';
import 'onboarding_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userState = ref.watch(currentUserProvider).value;
    final onboardingAsync = ref.watch(onboardingNotifierProvider);
    final name = userState?.fullName ?? 'Future Leader';
    final isStarting = onboardingAsync.isLoading ||
        onboardingAsync.value?.status == OnboardingStatus.loading;

    // Handler to launch profiler
    void launchProfiler({bool isResume = false}) async {
      final notifier = ref.read(onboardingNotifierProvider.notifier);
      final ok = await notifier.startOrResumeSession();
      if (ok && context.mounted) {
        context.go(RouteNames.onboardingProfiler);
        return;
      }

      if (context.mounted) {
        final error = ref.read(onboardingNotifierProvider).error;
        final message = error != null
            ? 'Could not start profiler: $error'
            : 'Could not start profiler. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryLight.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                
                // Illustration container - gradient circle with glow
                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2D8EFF), Color(0xFF1A6FD4)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2D8EFF).withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.explore_rounded,
                      size: 72.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Welcome texts
                Text(
                  'Hey $name! 👋',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Discover Careers You\'ve\nNever Heard Of',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text(
                    'Answer quick, scenario-based questions to match your interests to a 300+ career universe in India.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ),
                const Spacer(),

                // Time estimate pill
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FF),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16.0,
                          color: Color(0xFF2D8EFF),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Takes only 5 minutes',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF2D8EFF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // CTAs
                NSButton.primary(
                  label: 'Start Discovering',
                  isLoading: isStarting,
                  onPressed: isStarting ? null : () => launchProfiler(),
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Conditional resume stub (we can trigger the same since notifier handles resuming auto)
                NSButton.text(
                  label: 'Continue where you left off',
                  onPressed: isStarting ? null : () => launchProfiler(isResume: true),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
