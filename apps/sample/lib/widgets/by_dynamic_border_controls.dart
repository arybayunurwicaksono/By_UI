import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../theme/app_theme.dart';
import 'by_color_palette.dart';
import 'by_showcase_choice_chip.dart';
import 'by_showcase_control_card.dart';
import 'by_showcase_slider_tile.dart';

/// Configuration state for Pulse Dynamic Border animations.
class ByPulseBorderConfig {
  bool enabled;
  ByBorderOrigin origin;
  int durationMs;
  double beamLength;
  double width;
  double shadowLength;
  double shadowWidth;
  double shadowBlur;
  int colorAIndex;
  int colorBIndex;
  int shadowColorIndex;

  ByPulseBorderConfig({
    this.enabled = false,
    this.origin = ByBorderOrigin.topCenter,
    this.durationMs = 1400,
    this.beamLength = 0.28,
    this.width = 2.0,
    this.shadowLength = 0.28,
    this.shadowWidth = 2.0,
    this.shadowBlur = 3.0,
    this.colorAIndex = 0,
    this.colorBIndex = 2,
    this.shadowColorIndex = 0,
  });

  void reset() {
    enabled = false;
    origin = ByBorderOrigin.topCenter;
    durationMs = 1400;
    beamLength = 0.28;
    width = 2.0;
    shadowLength = 0.28;
    shadowWidth = 2.0;
    shadowBlur = 3.0;
    colorAIndex = 0;
    colorBIndex = 2;
    shadowColorIndex = 0;
  }

  Color get colorA {
    final idx = colorAIndex.clamp(0, AppColors.gradientColorOptions.length - 1);
    return AppColors.gradientColorOptions[idx]['color'] as Color;
  }

  Color get colorB {
    final idx = colorBIndex.clamp(0, AppColors.gradientColorOptions.length - 1);
    return AppColors.gradientColorOptions[idx]['color'] as Color;
  }

  Color get shadowColor {
    final idx = shadowColorIndex.clamp(
      0,
      AppColors.gradientColorOptions.length - 1,
    );
    return AppColors.gradientColorOptions[idx]['color'] as Color;
  }

  ByDynamicBorder? buildDynamicBorder({
    bool autoStart = true,
    ByDynamicBorderController? controller,
    Duration? sensorResumeDelay,
    Duration? sensorEntranceDuration,
  }) {
    if (!enabled) return null;
    return ByDynamicBorder(
      controller: controller,
      autoStart: autoStart,
      origin: origin,
      duration: Duration(milliseconds: durationMs),
      beamLength: beamLength,
      width: width,
      shadowColor: shadowColor,
      shadowBlur: shadowBlur,
      shadowWidth: shadowWidth,
      shadowLength: shadowLength,
      colors: [colorA, colorB],
      sensorResumeDelay:
          sensorResumeDelay ?? const Duration(milliseconds: 300),
      sensorEntranceDuration:
          sensorEntranceDuration ?? const Duration(milliseconds: 400),
    );
  }
}

/// Standardized control card for configuring Pulse Dynamic Border.
class ByDynamicBorderControls extends StatelessWidget {
  final String title;
  final ByPulseBorderConfig config;
  final VoidCallback onChanged;
  final Widget? actionButton;
  final List<Widget>? extraControls;

  const ByDynamicBorderControls({
    super.key,
    this.title = 'PULSE DYNAMIC BORDER (ONE-SHOT TRAVELING BEAM)',
    required this.config,
    required this.onChanged,
    this.actionButton,
    this.extraControls,
  });

  static const List<({ByBorderOrigin origin, String label})> _origins = [
    (origin: ByBorderOrigin.topCenter, label: 'Top Center'),
    (origin: ByBorderOrigin.topLeft, label: 'Top Left'),
    (origin: ByBorderOrigin.topRight, label: 'Top Right'),
    (origin: ByBorderOrigin.bottomCenter, label: 'Bottom Center'),
    (origin: ByBorderOrigin.bottomLeft, label: 'Bottom Left'),
    (origin: ByBorderOrigin.bottomRight, label: 'Bottom Right'),
    (origin: ByBorderOrigin.centerLeft, label: 'Center Left'),
    (origin: ByBorderOrigin.centerRight, label: 'Center Right'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final labelTextColor = colors.textSecondary;

    return ByShowcaseControlCard(
      title: title,
      icon: AppIcons.tune,
      children: [
        ByShowcaseSwitchTile(
          title: 'Enable Pulse Dynamic Border',
          subtitle:
              'Traces a neon laser circuit from Point A back to Point A around the component',
          value: config.enabled,
          onChanged: (val) {
            config.enabled = val;
            onChanged();
          },
        ),
        ...?extraControls,
        const SizedBox(height: 12),
        Text(
          'Pulse Origin (Point A):',
          style: AppTextStyle.sectionLabel.copyWith(color: labelTextColor),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _origins.map((item) {
              final isSelected = config.origin == item.origin;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ByShowcaseChoiceChip(
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () {
                    config.origin = item.origin;
                    onChanged();
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        ByShowcaseSliderTile(
          label: 'Circuit Duration:',
          valueText: '${config.durationMs}ms',
          value: config.durationMs.toDouble(),
          min: 400.0,
          max: 3000.0,
          divisions: 26,
          onChanged: (val) {
            config.durationMs = val.toInt();
            onChanged();
          },
        ),
        ByShowcaseSliderTile(
          label: 'Beam Length (% Perimeter):',
          valueText: '${(config.beamLength * 100).toInt()}%',
          value: config.beamLength,
          min: 0.10,
          max: 0.50,
          divisions: 20,
          onChanged: (val) {
            config.beamLength = val;
            onChanged();
          },
        ),
        ByShowcaseSliderTile(
          label: 'Beam Stroke Width:',
          valueText: '${config.width.toStringAsFixed(1)}px',
          value: config.width,
          min: 1.0,
          max: 6.0,
          divisions: 25,
          onChanged: (val) {
            config.width = val;
            onChanged();
          },
        ),
        ByShowcaseSliderTile(
          label: 'Outer Shadow Length (% Perimeter):',
          valueText: '${(config.shadowLength * 100).toInt()}%',
          value: config.shadowLength,
          min: 0.05,
          max: 0.80,
          divisions: 15,
          onChanged: (val) {
            config.shadowLength = val;
            onChanged();
          },
        ),
        ByShowcaseSliderTile(
          label: 'Outer Shadow Thickness:',
          valueText: '${config.shadowWidth.toStringAsFixed(1)}px',
          value: config.shadowWidth,
          min: 0.5,
          max: 8.0,
          divisions: 15,
          onChanged: (val) {
            config.shadowWidth = val;
            onChanged();
          },
        ),
        ByShowcaseSliderTile(
          label: 'Outer Shadow Blur Radius:',
          valueText: '${config.shadowBlur.toStringAsFixed(1)}px',
          value: config.shadowBlur,
          min: 0.0,
          max: 16.0,
          divisions: 16,
          onChanged: (val) {
            config.shadowBlur = val;
            onChanged();
          },
        ),
        const SizedBox(height: 6),
        Text(
          'Beam Color — Start Tone (A):',
          style: AppTextStyle.sectionLabel.copyWith(color: labelTextColor),
        ),
        const SizedBox(height: 8),
        ByColorPalette.fromOptions(
          options: AppColors.gradientColorOptions,
          selectedIndex: config.colorAIndex,
          onSelected: (index) {
            config.colorAIndex = index;
            onChanged();
          },
        ),
        const SizedBox(height: 12),
        Text(
          'Beam Color — End Tone (B):',
          style: AppTextStyle.sectionLabel.copyWith(color: labelTextColor),
        ),
        const SizedBox(height: 8),
        ByColorPalette.fromOptions(
          options: AppColors.gradientColorOptions,
          selectedIndex: config.colorBIndex,
          onSelected: (index) {
            config.colorBIndex = index;
            onChanged();
          },
        ),
        const SizedBox(height: 12),
        Text(
          'Outer Shadow Color (Decoupled):',
          style: AppTextStyle.sectionLabel.copyWith(color: labelTextColor),
        ),
        const SizedBox(height: 8),
        ByColorPalette.fromOptions(
          options: AppColors.gradientColorOptions,
          selectedIndex: config.shadowColorIndex,
          onSelected: (index) {
            config.shadowColorIndex = index;
            onChanged();
          },
        ),
        if (actionButton != null) ...[
          const SizedBox(height: 14),
          actionButton!,
        ],
      ],
    );
  }
}
