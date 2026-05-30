// lib/features/onboarding/presentation/profile_building_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/dimension_label.dart';

class ProfileBuildingScreen extends StatefulWidget {
  const ProfileBuildingScreen({super.key});

  @override
  State<ProfileBuildingScreen> createState() => _ProfileBuildingScreenState();
}

class _ProfileBuildingScreenState extends State<ProfileBuildingScreen> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  final List<String> _dimensions = ['C', 'A', 'S', 'T', 'E', 'P'];
  final List<String> _revealedDimensions = [];
  String _statusText = 'Initializing career alignment engine...';
  int _dimensionIndex = 0;
  Timer? _revealTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _startRevealSequence();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _revealTimer?.cancel();
    super.dispose();
  }

  void _startRevealSequence() {
    const intervals = [800, 1400, 2000, 2600, 3200, 3800];
    
    // Step-by-step reveal of interest dimensions
    for (int i = 0; i < _dimensions.length; i++) {
      Timer(Duration(milliseconds: intervals[i]), () {
        if (mounted) {
          setState(() {
            _revealedDimensions.add(_dimensions[i]);
            _statusText = 'Calibrating ${_getDimensionName(_dimensions[i])} index...';
          });
        }
      });
    }

    // Completion status
    Timer(const Duration(milliseconds: 4400), () {
      if (mounted) {
        setState(() {
          _statusText = 'Interest profile generated! Finding career matches...';
        });
      }
    });

    // Auto-advance navigation
    Timer(const Duration(milliseconds: 5500), () {
      if (mounted) {
        context.go(RouteNames.homeCareers);
      }
    });
  }

  String _getDimensionName(String code) {
    return DimensionLabel.getLabel(code);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.onSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              // Pulsing Core Node
              Center(
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.05).animate(
                    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                  ),
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.15),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.4),
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: AppColors.matchScoreGradient,
                          ),
                        ),
                        child: const Icon(
                          Icons.psychology_rounded,
                          size: 48.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Title status
              Text(
                _statusText,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Dimensions reveal grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  alignment: WrapAlignment.center,
                  children: _dimensions.map((code) {
                    final isRevealed = _revealedDimensions.contains(code);
                    final color = AppColors.forDimension(code);
                    final emoji = DimensionLabel.getEmoji(code);
                    final label = DimensionLabel.getLabel(code);

                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: isRevealed ? 1.0 : 0.15,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 450),
                        scale: isRevealed ? 1.0 : 0.8,
                        curve: Curves.elasticOut,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isRevealed
                                ? color.withOpacity(0.15)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: isRevealed ? color : Colors.white.withOpacity(0.1),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(emoji, style: const TextStyle(fontSize: 16.0)),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                label,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isRevealed ? Colors.white : Colors.white.withOpacity(0.4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Spacer(),
              
              // Loading bar
              Center(
                child: SizedBox(
                  width: 120.0,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
