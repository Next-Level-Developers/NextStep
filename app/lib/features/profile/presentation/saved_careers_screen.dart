// lib/features/profile/presentation/saved_careers_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SavedCareersScreen extends StatelessWidget {
  const SavedCareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Careers'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Careers you have bookmarked.'),
      ),
    );
  }
}
