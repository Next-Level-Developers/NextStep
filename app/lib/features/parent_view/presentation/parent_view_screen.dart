// lib/features/parent_view/presentation/parent_view_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ParentViewScreen extends StatelessWidget {
  final String shareToken;

  const ParentViewScreen({
    super.key,
    required this.shareToken,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('NextStep Share View'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text('Parent Read-only view for share token: $shareToken'),
      ),
    );
  }
}
