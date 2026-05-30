// lib/features/career_detail/presentation/career_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CareerDetailScreen extends StatelessWidget {
  final String slug;

  const CareerDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Career Detail'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text('Career Details for: $slug'),
      ),
    );
  }
}
