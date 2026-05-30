import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/parent_profile_entity.dart';

class ParentCareerCard extends StatelessWidget {
  final SharedCareer career;
  final bool isSaved;

  const ParentCareerCard({
    super.key,
    required this.career,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and saved badge
          Row(
            children: [
              Expanded(
                child: Text(
                  career.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isSaved)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '★ Saved',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (career.oneLiner != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              career.oneLiner!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          // Stats row
          Row(
            children: [
              if (career.userMatchScore != null)
                Expanded(
                  child: _StatItem(
                    label: 'Match Score',
                    value: '${career.userMatchScore}%',
                    color: AppColors.primary,
                  ),
                ),
              if (career.futureScore > 0)
                Expanded(
                  child: _StatItem(
                    label: 'Future Score',
                    value: '${career.futureScore}/10',
                    color: AppColors.secondary,
                  ),
                ),
              if (career.indiaViability != null)
                Expanded(
                  child: _StatItem(
                    label: 'India Viability',
                    value: career.indiaViability!.toUpperCase().replaceFirst(
                        career.indiaViability![0],
                        career.indiaViability![0].toUpperCase()),
                    color: _getViabilityColor(career.indiaViability),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getViabilityColor(String? viability) {
    switch (viability?.toLowerCase()) {
      case 'very_high':
      case 'high':
        return AppColors.success;
      case 'medium':
        return Colors.orange;
      case 'low':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.grey.shade600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
