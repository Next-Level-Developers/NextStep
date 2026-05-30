import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_snackbar.dart';
import '../../domain/career_detail_entity.dart';

class LearningResourceCard extends StatelessWidget {
  final LearningResource resource;

  const LearningResourceCard({super.key, required this.resource});

  String _getResourceIcon() {
    switch (resource.resourceType?.toLowerCase()) {
      case 'course':
        return '📚';
      case 'article':
        return '📄';
      case 'video':
        return '🎥';
      case 'book':
        return '📖';
      default:
        return '🔗';
    }
  }

  Future<void> _launchUrl(BuildContext context) async {
    if (resource.url == null || resource.url!.isEmpty) return;

    try {
      final uri = Uri.parse(resource.url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (context.mounted) {
          NSSnackbar.showSuccess(context, 'Opening resource...');
        }
      }
    } catch (e) {
      if (context.mounted) {
        NSSnackbar.showError(context, 'Could not open resource');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canOpen = resource.url != null && resource.url!.isNotEmpty;

    return GestureDetector(
      onTap: canOpen ? () => _launchUrl(context) : null,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: canOpen ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: canOpen ? Colors.grey.shade200 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Text(
              _getResourceIcon(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (resource.provider != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        resource.provider!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  if (resource.resourceType != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        resource.resourceType!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (canOpen)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.md),
                child: Icon(
                  Icons.arrow_outward,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
