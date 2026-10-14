import 'package:flutter/material.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';

/// Item specification for a 1-click quick preset pill.
class ByShowcasePresetItem {
  final String label;
  final Color themeColor;
  final VoidCallback onTap;
  final bool isSelected;

  const ByShowcasePresetItem({
    required this.label,
    required this.themeColor,
    required this.onTap,
    this.isSelected = false,
  });
}

/// Standardized Preset Example card (Layer 2) matching ByUI Showcase rules.
///
/// Rules:
/// - Title: Strictly 'Preset Example' (no leading icon)
/// - Container: Rounded 14, standard border and card background
/// - Presets: Text-only semantic pills with horizontal scroll
class ByShowcasePresetCard extends StatelessWidget {
  final List<ByShowcasePresetItem> presets;

  const ByShowcasePresetCard({
    super.key,
    required this.presets,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = AppThemeStore.instance.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preset Example',
            style: AppTextStyle.sectionHeader.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < presets.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  ByShowcasePresetPill(item: presets[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Semantic text-only pill button for showcase preset lists.
class ByShowcasePresetPill extends StatelessWidget {
  final ByShowcasePresetItem item;

  const ByShowcasePresetPill({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: item.themeColor.withValues(
              alpha: item.isSelected ? 0.25 : 0.14,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: item.isSelected
                  ? item.themeColor
                  : item.themeColor.withValues(alpha: 0.35),
              width: item.isSelected ? 1.4 : 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            item.label,
            style: AppTextStyle.pillButton.copyWith(
              color: item.themeColor,
              fontWeight: item.isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
