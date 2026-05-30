// lib/features/onboarding/presentation/widgets/question_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class QuestionCard extends StatelessWidget {
  final String questionText;
  final String? instructionText;

  const QuestionCard({
    super.key,
    required this.questionText,
    this.instructionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          questionText,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
            height: 1.3,
          ),
        ),
        if (instructionText != null && instructionText!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            instructionText!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.muted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
