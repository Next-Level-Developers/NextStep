// lib/features/onboarding/presentation/widgets/progress_bar.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const ProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROFILER PROGRESS',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Stack(
          children: [
            // Track
            Container(
              height: 6.0,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            // Progress Bar
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              widthFactor: progress,
              child: Container(
                height: 6.0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.matchScoreGradient,
                  ),
                  borderRadius: BorderRadius.circular(3.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
