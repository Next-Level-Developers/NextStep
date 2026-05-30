// lib/core/widgets/ns_button.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum NSButtonVariant { primary, secondary, text }

class NSButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final NSButtonVariant variant;
  final double? width;
  final double height;

  const NSButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = NSButtonVariant.primary,
    this.width,
    this.height = 52.0,
  });

  const NSButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52.0,
  }) : variant = NSButtonVariant.primary;

  const NSButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52.0,
  }) : variant = NSButtonVariant.secondary;

  const NSButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52.0,
  }) : variant = NSButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    Color getBackgroundColor() {
      if (!isEnabled) {
        return variant == NSButtonVariant.text
            ? Colors.transparent
            : AppColors.outlineMedium;
      }
      switch (variant) {
        case NSButtonVariant.primary:
          return AppColors.primary;
        case NSButtonVariant.secondary:
          return AppColors.primaryLight;
        case NSButtonVariant.text:
          return Colors.transparent;
      }
    }

    Color getForegroundColor() {
      if (!isEnabled) {
        return AppColors.muted;
      }
      switch (variant) {
        case NSButtonVariant.primary:
          return AppColors.onPrimary;
        case NSButtonVariant.secondary:
          return AppColors.primary;
        case NSButtonVariant.text:
          return AppColors.primary;
      }
    }

    BorderSide getBorderSide() {
      // In case we want a bordered secondary button, we can configure it here.
      // Currently using a light purple background for secondary.
      return BorderSide.none;
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: getBackgroundColor(),
      foregroundColor: getForegroundColor(),
      shadowColor: variant == NSButtonVariant.primary && isEnabled
          ? AppColors.primary.withOpacity(0.3)
          : Colors.transparent,
      elevation: variant == NSButtonVariant.primary && isEnabled ? 4.0 : 0.0,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: getBorderSide(),
      ),
    );

    Widget buildContent(Color foregroundColor) {
      if (isLoading) {
        return SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
          ),
        );
      }

      final textWidget = Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      );

      if (icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            const SizedBox(width: AppSpacing.sm),
            textWidget,
          ],
        );
      }

      return textWidget;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: isEnabled ? onPressed : null,
          child: buildContent(getForegroundColor()),
        ),
      ),
    );
  }
}
