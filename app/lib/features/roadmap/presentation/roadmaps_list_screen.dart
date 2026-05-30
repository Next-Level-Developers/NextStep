// lib/features/roadmap/presentation/roadmaps_list_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RoadmapsListScreen extends StatelessWidget {
  const RoadmapsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Roadmaps'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Your active learning and preparation roadmaps.'),
      ),
    );
  }
}
