// lib/features/profile/presentation/interest_profile_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class InterestProfileScreen extends StatelessWidget {
  const InterestProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Interest Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Computed dimension scores and details.'),
      ),
    );
  }
}
