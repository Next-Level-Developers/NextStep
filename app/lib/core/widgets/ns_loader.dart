// lib/core/widgets/ns_loader.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class NSLoader extends StatelessWidget {
  final String? message;
  final bool isFullScreen;

  const NSLoader({
    super.key,
    this.message,
    this.isFullScreen = false,
  });

  const NSLoader.fullScreen({
    super.key,
    this.message,
  }) : isFullScreen = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicator = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 48.0,
          height: 48.0,
          child: CircularProgressIndicator(
            strokeWidth: 4.0,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );

    if (isFullScreen) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: indicator,
          ),
        ),
      );
    }

    return Center(
      child: indicator,
    );
  }
}
