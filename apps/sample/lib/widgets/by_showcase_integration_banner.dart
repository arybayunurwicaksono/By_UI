import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Standardized cross-component integration banner (Layer 3).
///
/// Rules:
/// - Title: Strictly 'Integrated with `ComponentName`'
/// - Icon: AppIcons.sparkle with AppColors.primary
/// - Description: One concise English sentence
/// - Container: Rounded 12, colors.bannerBg, colors.bannerBorder
class ByShowcaseIntegrationBanner extends StatelessWidget {
  final String componentName;
  final String description;

  const ByShowcaseIntegrationBanner({
    super.key,
    required this.componentName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: colors.bannerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.bannerBorder),
      ),
      child: Row(
        children: [
          const Icon(
            AppIcons.sparkle,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Integrated with $componentName',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: colors.bannerText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
