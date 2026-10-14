import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../theme/app_theme.dart';
import 'by_showcase_choice_chip.dart';

/// Standardized configuration preview summary card (Layer 1).
///
/// Features:
/// - Gradient icon badge container
/// - Title: Strictly 'Active Configuration Preview'
/// - Subtitle and behavioral description
/// - Horizontal wrap of [ByMetricBadge] items with Cyan accent values
class ByShowcasePreviewCard extends StatelessWidget {
  final IconData icon;
  final String subtitle;
  final String? description;
  final List<ByMetricBadge> metrics;

  const ByShowcasePreviewCard({
    super.key,
    this.icon = AppIcons.shield,
    required this.subtitle,
    this.description,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: colors.cardBg,
      borderColor: colors.border,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Configuration Preview',
                      style: AppTextStyle.screenSubtitle.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (description != null && description!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              description!,
              style: AppTextStyle.body.copyWith(
                color: colors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: metrics,
          ),
        ],
      ),
    );
  }
}
