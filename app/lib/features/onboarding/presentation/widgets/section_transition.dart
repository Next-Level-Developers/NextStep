// lib/features/onboarding/presentation/widgets/section_transition.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class SectionTransitionWidget extends StatefulWidget {
  final String nextSectionLabel;
  final VoidCallback onDismiss;

  const SectionTransitionWidget({
    super.key,
    required this.nextSectionLabel,
    required this.onDismiss,
  });

  @override
  State<SectionTransitionWidget> createState() => _SectionTransitionWidgetState();
}

class _SectionTransitionWidgetState extends State<SectionTransitionWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Auto-advance after 2 seconds
    _timer = Timer(const Duration(milliseconds: 2200), () {
      _dismiss();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _timer?.cancel();
    widget.onDismiss();
  }

  String _getSectionTeaser(String sectionLabel) {
    switch (sectionLabel.toLowerCase()) {
      case 'what you do with free time':
        return 'Let\'s start by looking at what makes you tick when you\'re free.';
      case 'problem solving':
      case 'how you solve problems':
        return 'Great! Now let\'s see how you think and tackle challenges.';
      case 'work style':
        return 'Awesome. Let\'s see how you work with teams and projects.';
      case 'values':
        return 'Now, let\'s explore what truly matters to you in a career.';
      case 'subjects':
        return 'Perfect! Let\'s link it to the school subjects you enjoy.';
      case 'skills':
        return 'Almost there! Let\'s look at the skills you excel at.';
      case 'awareness':
        return 'Let\'s see which paths you\'re already familiar with.';
      case 'final signal':
        return 'One last question to capture your ultimate preferences!';
      default:
        return 'Moving on to the next interesting section!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: InkWell(
        onTap: _dismiss,
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        size: 64.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Next Section:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      widget.nextSectionLabel,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        _getSectionTeaser(widget.nextSectionLabel),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Tap anywhere to skip',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withOpacity(0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
