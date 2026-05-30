// lib/features/ai_chat/presentation/conversations_list_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ConversationsListScreen extends StatelessWidget {
  const ConversationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Career Coach'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Have conversations with our AI Career Advisor.'),
      ),
    );
  }
}
