import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Standardized slider control tile for showcase setup parameters.
///
/// Features:
/// - Label with responsive layout
/// - Badge displaying the formatted current value
/// - Modern unified SliderTheme matching ByUI design language
class ByShowcaseSliderTile extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? suffix;
  final String? valueText;
  final ValueChanged<double> onChanged;

  const ByShowcaseSliderTile({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.suffix,
    this.valueText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final displayValue = valueText ??
        (suffix != null
            ? (suffix == 'ms' || suffix == 'px'
                ? '${value.toInt()} $suffix'
                : '${value.toStringAsFixed(1)} $suffix')
            : value.toStringAsFixed(1));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyle.fieldLabel.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.badgeBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colors.badgeBorder),
                ),
                child: Text(
                  displayValue,
                  style: AppTextStyle.badge.copyWith(
                    color: AppColors.cyanAccent,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: colors.borderSubtle,
              thumbColor: AppColors.primaryLight,
              overlayColor: AppColors.primary.withValues(alpha: 0.18),
              trackHeight: 3.5,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6.5,
              ),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
