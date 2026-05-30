// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home/explore')) {
      return 1;
    }
    if (location.startsWith('/home/roadmaps')) {
      return 2;
    }
    if (location.startsWith('/home/ai')) {
      return 3;
    }
    if (location.startsWith('/home/profile')) {
      return 4;
    }
    return 0; // Default to Careers
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home/careers');
        break;
      case 1:
        context.go('/home/explore');
        break;
      case 2:
        context.go('/home/roadmaps');
        break;
      case 3:
        context.go('/home/ai');
        break;
      case 4:
        context.go('/home/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(index, context),
        indicatorColor: AppColors.primaryLight,
        backgroundColor: Colors.white,
        elevation: 8.0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined, color: AppColors.muted),
            selectedIcon: Icon(Icons.explore_rounded, color: AppColors.primary),
            label: 'Careers',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined, color: AppColors.muted),
            selectedIcon: Icon(Icons.search_rounded, color: AppColors.primary),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined, color: AppColors.muted),
            selectedIcon: Icon(Icons.map_rounded, color: AppColors.primary),
            label: 'Roadmaps',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded, color: AppColors.muted),
            selectedIcon: Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
            label: 'AI Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded, color: AppColors.muted),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
