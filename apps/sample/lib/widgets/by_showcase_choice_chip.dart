import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';

/// Standardized choice chip for ByUI showcase control cards.
///
/// Adheres strictly to the showcase design specification:
/// - Selected Border: [AppColors.primary]
/// - Selected Background: [colors.chipSelectedBg] (semi-transparent primary)
/// - Selected Text: [Colors.black] in Light Mode, [Colors.white] in Dark Mode (never purple/primary)
/// - Unselected Text: [colors.textMuted]
/// - Unselected Border: [colors.borderSubtle]
class ByShowcaseChoiceChip extends StatelessWidget {
  /// The text label displayed inside the chip.
  final String label;

  /// Whether this chip is currently active/selected.
  final bool isSelected;

  /// Callback executed when tapping the chip.
  final VoidCallback onTap;

  /// Optional leading icon or widget.
  final Widget? icon;

  const ByShowcaseChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeStore.instance.isDarkMode(context);
    final colors = AppColors.of(context);

    return BySelectOption(
      label: Text(label),
      isSelected: isSelected,
      icon: icon,
      selectedBorderColor: AppColors.primary,
      unselectedBorderColor: colors.borderSubtle,
      selectedBackgroundColor: colors.chipSelectedBg,
      unselectedBackgroundColor: colors.chipBg,
      selectedTextColor: isDark ? Colors.white : Colors.black,
      unselectedTextColor: colors.textMuted,
      onTap: onTap,
    );
  }
}

/// Standardized metric badge used inside "Active Configuration Preview" cards.
class ByMetricBadge extends StatelessWidget {
  final String label;
  final String value;

  const ByMetricBadge({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyle.caption.copyWith(color: colors.textMuted),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: AppTextStyle.captionBold.copyWith(
              color: AppColors.cyanAccent,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Standardized switch / toggle tile used across all showcase control cards.
///
/// Design Specification:
/// - Sliding circle (thumb) MUST BE WHITE ([Colors.white]) in all states (active & inactive)
///   and in all themes (Dark & Light).
/// - Active track: [AppColors.primary]
/// - Inactive track: Subtle border / surface variant
class ByShowcaseSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ByShowcaseSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = AppThemeStore.instance.isDarkMode(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.fieldLabel.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: AppTextStyle.caption.copyWith(color: colors.textMuted),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary,
          inactiveTrackColor:
              isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          trackOutlineColor:
              const WidgetStatePropertyAll<Color>(Colors.transparent),
          thumbColor: const WidgetStatePropertyAll<Color>(Colors.white),
        ),
      ],
    );
  }
}
