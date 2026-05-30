// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_button.dart';
import '../../../../core/widgets/ns_snackbar.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../parent_view/presentation/parent_view_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _handleSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out?'),
        content: const Text('Are you sure you want to sign out of NextStep?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
      if (context.mounted) {
        NSSnackbar.showSuccess(context, 'Signed out successfully.');
        context.go(RouteNames.login);
      }
    }
  }

  void _handleShareWithParents(BuildContext context, WidgetRef ref) async {
    // Show loading dialog
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: SizedBox(
          height: 60,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    try {
      // Generate share token
      await ref
          .read(generateShareTokenProvider.notifier)
          .generate();

      if (!context.mounted) return;
      Navigator.pop(context); // Close loading dialog

      final tokenAsync = ref.read(generateShareTokenProvider);
      final token = tokenAsync.value;

      if (token != null && token.isNotEmpty) {
        // Create deep link
        const String appLink = 'https://nextstep.app';
        final deepLink =
            '$appLink/share/$token';

        // Share the link
        await Share.share(
          'Check out my career discoveries on NextStep! 🚀\n\n$deepLink\n\nDownload NextStep to explore your own career path.',
          subject: 'NextStep Career Share',
        );
      } else {
        if (context.mounted) {
          NSSnackbar.showError(
              context, 'Failed to generate share link. Please try again.');
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        NSSnackbar.showError(context, 'Error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider).value;
    final email = user?.email ?? '';
    final name = user?.fullName ?? 'Student User';
    final isPremium = user?.subscriptionTier == 'premium';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar & Name Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: const BorderSide(color: AppColors.outlineMedium),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'S',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isPremium ? AppColors.secondaryLight : AppColors.outline,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        isPremium ? '💎 Premium Account' : 'Free Account',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isPremium ? AppColors.secondary : AppColors.muted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Profile Options Menu
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: const BorderSide(color: AppColors.outlineMedium),
              ),
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette_outlined, color: AppColors.primary),
                    title: const Text('My Interest Dimensions'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16.0),
                    onTap: () => context.push(RouteNames.profileInterests),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.bookmark_outline_rounded, color: AppColors.primary),
                    title: const Text('Saved Careers'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16.0),
                    onTap: () => context.push(RouteNames.profileSaved),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined, color: AppColors.primary),
                    title: const Text('Edit Student Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16.0),
                    onTap: () => context.push(RouteNames.profileEdit),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.credit_card_outlined, color: AppColors.primary),
                    title: const Text('Subscription Plans'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16.0),
                    onTap: () => context.push(RouteNames.profileSubscription),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.share_outlined, color: AppColors.primary),
                    title: const Text('Share with Parents'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16.0),
                    onTap: () => _handleShareWithParents(context, ref),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
                    title: const Text('Notifications'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16.0),
                    onTap: () => context.push(RouteNames.notifications),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            NSButton.secondary(
              label: 'Sign Out',
              onPressed: () => _handleSignOut(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
