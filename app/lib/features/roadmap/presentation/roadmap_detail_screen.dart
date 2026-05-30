// lib/features/roadmap/presentation/roadmap_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RoadmapDetailScreen extends StatelessWidget {
  final String roadmapId;

  const RoadmapDetailScreen({
    super.key,
    required this.roadmapId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Roadmap $roadmapId'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text('Step-by-step roadmap details for ID: $roadmapId'),
      ),
    );
  }
}
