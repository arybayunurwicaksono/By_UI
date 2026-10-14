import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_bar_config_store.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_drawer.dart';
import '../widgets/by_showcase_header.dart';
import '../widgets/by_color_palette.dart';
import '../widgets/by_showcase_choice_chip.dart';
import '../widgets/by_showcase_control_card.dart';
import '../widgets/by_showcase_slider_tile.dart';
import '../widgets/by_showcase_preview_card.dart';
import '../widgets/by_showcase_preset_card.dart';
import '../widgets/by_showcase_integration_banner.dart';
import '../widgets/by_dynamic_border_controls.dart';
import '../widgets/widget_params_dialog.dart';

/// Interactive showcase screen for the [ByAppBar] dynamic floating component.
class AppBarShowcaseScreen extends StatefulWidget {
  const AppBarShowcaseScreen({super.key});

  @override
  State<AppBarShowcaseScreen> createState() => _AppBarShowcaseScreenState();
}

class _AppBarShowcaseScreenState extends State<AppBarShowcaseScreen> {
  // Manual tilt coordinates for sensor simulation (matching ByCard showcase)
  double _tiltX = 0.0;
  double _tiltY = 1.0; // 1.0 = Upright portrait
  int _lastTiltUpdateTime = 0;

  final ByDynamicBorderController _pulseController =
      ByDynamicBorderController();

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Static & Floating Background Palettes from AppColors (Rule 5.1 & Rule 5.6)
  static const List<ShowcaseColorOption> _colorThemes =
      AppColors.appBarColorThemes;
  static const List<ShowcaseColorOption> _floatingColorThemes =
      AppColors.appBarFloatingColorThemes;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        AppThemeStore.instance,
        AppBarConfigStore.instance,
      ]),
      builder: (context, _) {
        final colors = AppColors.of(context);
        final isDark = AppThemeStore.instance.isDarkMode(context);
        final store = AppBarConfigStore.instance;

        return ByScrollScope(
          child: Scaffold(
            backgroundColor: colors.scaffoldBg,
            extendBodyBehindAppBar: true,
            // 1. Uniform AppBar configured dynamically from store
            appBar: ByAppBar(
              isFloatingEnabled: store.isFloatingEnabled,
              scrollThreshold: store.scrollThreshold,
              floatingMargin: EdgeInsets.fromLTRB(
                store.horizontalMargin,
                8,
                store.horizontalMargin,
                0,
              ),
              floatingBorderRadius: BorderRadius.circular(store.borderRadius),
              floatingBlurSigma: store.blurSigma,
              floatingOpacity: store.floatingOpacity,
              backgroundColor:
                  store.customColor ??
                  (isDark ? AppColors.darkCard : Colors.white),
              floatingBackgroundColor: store.customFloatingColor?.withValues(
                alpha: store.floatingOpacity,
              ),
              elevation: 0.0,
              floatingElevation: store.floatingElevation,
              border: store.enableBorder && !store.enableDynamicBorder
                  ? Border.all(color: colors.border, width: store.borderWidth)
                  : null,
              floatingBorder: store.enableBorder && !store.enableDynamicBorder
                  ? Border.all(color: colors.border, width: store.borderWidth)
                  : null,
              borderWidth: (store.enableBorder || store.enableDynamicBorder)
                  ? store.borderWidth
                  : 0.0,
              floatingBorderWidth:
                  (store.enableBorder || store.enableDynamicBorder)
                  ? store.borderWidth
                  : 0.0,
              borderGradient: store.enableDynamicBorder
                  ? store.activeSensorGradient
                  : null,
              shadowGradient: store.enableDynamicBorder
                  ? store.activeSensorGradient
                  : null,
              shadowBlur: store.enableDynamicBorder ? 20.0 : 16.0,
              maxShadowOffset: 12.0,
              enableSensor: store.enableDynamicBorder && store.enableSensor,
              enableHoverTilt: store.enableHoverTilt,
              enableInnerShadow: store.enableInnerShadow,
              innerShadowOpacity: store.innerShadowOpacity,
              dynamicBorder: store.pulseConfig.buildDynamicBorder(
                controller: _pulseController,
                autoStart: store.pulseAutoStart,
                sensorResumeDelay: Duration(
                  milliseconds: store.sensorResumeDelayMs,
                ),
                sensorEntranceDuration: Duration(
                  milliseconds: store.sensorEntranceDurationMs,
                ),
              ),
              manualTilt: (store.enableDynamicBorder && store.enableSensor)
                  ? null
                  : Offset(_tiltX, _tiltY),
              onTiltChanged: (tilt) {
                if (store.enableDynamicBorder &&
                    store.enableSensor &&
                    mounted) {
                  final now = DateTime.now().millisecondsSinceEpoch;
                  // Throttle UI text and slider updates to ~15 FPS (66ms) to prevent CPU frame drops
                  if (now - _lastTiltUpdateTime > 66) {
                    if ((tilt.dx - _tiltX).abs() > 0.015 ||
                        (tilt.dy - _tiltY).abs() > 0.015) {
                      _lastTiltUpdateTime = now;
                      setState(() {
                        _tiltX = tilt.dx;
                        _tiltY = tilt.dy;
                      });
                    }
                  }
                }
              },
              child: ByShowcaseHeader(
                componentName: 'ByAppBar',
                pillGradient: store.activeComponentPreset.gradient,
                actionColor: store.activeComponentPreset.accent,
                centerTitle: store.centerTitle,
                onReset: _resetToDefaults,
                onOpenParams: () => _showByAppBarParams(context),
              ),
            ),
            // 2. Uniform Drawer Navigation
            drawer: const ByDrawer(activeComponent: 'ByAppBar'),
            // 3. Main ListView
            body: ListView(
              padding: EdgeInsets.fromLTRB(
                12,
                ByAppBar.getContentTopPadding(context),
                12,
                28,
              ),
              children: [
                // 1. Active Configuration Preview Card
                ByShowcasePreviewCard(
                  icon: Icons.web_asset_rounded,
                  subtitle: 'Scroll down to watch this bar transition live',
                  description:
                      'The top navigation bar above will automatically float, detach from screen edges, and activate frosted glass blur when you scroll down this showcase.',
                  metrics: [
                    ByMetricBadge(
                      label: 'Mode',
                      value: store.isFloatingEnabled ? 'Floating' : 'Static',
                    ),
                    ByMetricBadge(
                      label: 'Top Color',
                      value:
                          _colorThemes[store.selectedColorIndex]['name']
                              as String,
                    ),
                    ByMetricBadge(
                      label: 'Float Color',
                      value: store.customFloatingColor == null
                          ? 'Auto (Inherited)'
                          : _floatingColorThemes[store
                                    .selectedFloatingColorIndex]['name']
                                as String,
                    ),
                    ByMetricBadge(
                      label: 'Radius',
                      value: '${store.borderRadius.toInt()}px',
                    ),
                    ByMetricBadge(
                      label: 'Blur',
                      value: '${store.blurSigma.toInt()}px',
                    ),
                    ByMetricBadge(
                      label: 'Opacity',
                      value: '${(store.floatingOpacity * 100).toInt()}%',
                    ),
                    ByMetricBadge(
                      label: 'Dynamic Border',
                      value: store.enableDynamicBorder ? 'Active' : 'Off',
                    ),
                    ByMetricBadge(
                      label: 'Border',
                      value: store.enableBorder
                          ? '${store.borderWidth.toStringAsFixed(1)}px'
                          : 'Off',
                    ),
                    ByMetricBadge(
                      label: 'Preset',
                      value: store.activeComponentPreset.name,
                    ),
                    ByMetricBadge(
                      label: 'Pulse Border',
                      value: store.enablePulseBorder
                          ? '${(store.pulseDurationMs / 1000).toStringAsFixed(1)}s'
                          : 'Off',
                    ),
                    if (store.enableDynamicBorder)
                      ByMetricBadge(
                        label: 'Tilt Vector',
                        value:
                            'X: ${_tiltX.toStringAsFixed(2)}, Y: ${_tiltY.toStringAsFixed(2)}',
                      ),
                  ],
                ),
                const SizedBox(height: 14),

                // 2. Preset Example Card
                ByShowcasePresetCard(
                  presets: [
                    ByShowcasePresetItem(
                      label: 'Frosted Glass',
                      themeColor: AppColors.primary,
                      onTap: () {
                        store.update(
                          isFloatingEnabled: true,
                          blurSigma: 16.0,
                          borderRadius: 16.0,
                          floatingOpacity: 0.84,
                          enableDynamicBorder: false,
                          enableBorder: true,
                          borderWidth: 1.0,
                        );
                      },
                    ),
                    ByShowcasePresetItem(
                      label: 'Dynamic Aurora',
                      themeColor: AppColors.cyanAccent,
                      onTap: () {
                        store.update(
                          isFloatingEnabled: true,
                          enableDynamicBorder: true,
                          enableSensor: true,
                          enableHoverTilt: true,
                          selectedSensorGradientIndex: 0,
                          borderWidth: 1.5,
                        );
                      },
                    ),
                    ByShowcasePresetItem(
                      label: 'Minimal Static',
                      themeColor: const Color(0xFF64748B),
                      onTap: () {
                        store.update(
                          isFloatingEnabled: false,
                          enableBorder: false,
                          enableDynamicBorder: false,
                        );
                      },
                    ),
                    ByShowcasePresetItem(
                      label: 'Accent Neon',
                      themeColor: AppColors.primaryAccent,
                      onTap: () {
                        store.update(
                          isFloatingEnabled: true,
                          enableDynamicBorder: true,
                          selectedSensorGradientIndex: 1,
                          borderRadius: 24.0,
                          floatingOpacity: 0.92,
                        );
                      },
                    ),
                    ByShowcasePresetItem(
                      label: 'Laser Pulse',
                      themeColor: AppColors.cyanAccent,
                      onTap: () {
                        store.update(
                          isFloatingEnabled: true,
                          enablePulseBorder: true,
                          pulseAutoStart: true,
                          pulseOriginIndex: 0,
                          pulseDurationMs: 1200,
                          pulseBeamLength: 0.30,
                          pulseWidth: 2.5,
                          pulseGlowBlur: 8.0,
                          selectedPulseColorAIndex: 0,
                          selectedPulseColorBIndex: 2,
                        );
                        _pulseController.pulse();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 3. Integrated Feature Hint (Integrated with ByDynamicBorder)
                const ByShowcaseIntegrationBanner(
                  componentName: 'ByDynamicBorder',
                  description:
                      'ByAppBar integrates ByDynamicBorder to project glowing laser perimeter sweeps across its floating glassmorphic container.',
                ),
                const SizedBox(height: 14),

                // Section 1: Floating Dynamics & Scroll Behavior
                ByShowcaseControlCard(
                  title: '1. FLOATING DYNAMICS & SCROLL BEHAVIOR',
                  icon: Icons.animation_rounded,
                  children: [
                    Text(
                      'Floating Animation State:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ByShowcaseChoiceChip(
                            label: 'Enabled (Auto Floating)',
                            isSelected: store.isFloatingEnabled,
                            onTap: () => store.update(isFloatingEnabled: true),
                          ),
                          const SizedBox(width: 8),
                          ByShowcaseChoiceChip(
                            label: 'Disabled (Static Bar)',
                            isSelected: !store.isFloatingEnabled,
                            onTap: () => store.update(isFloatingEnabled: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Scroll Distance Threshold:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [8.0, 12.0, 20.0, 35.0].map((threshold) {
                          final isSelected = store.scrollThreshold == threshold;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ByShowcaseChoiceChip(
                              label: '${threshold.toInt()}px',
                              isSelected: isSelected,
                              onTap: () =>
                                  store.update(scrollThreshold: threshold),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Floating Corner Radius:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [8.0, 12.0, 16.0, 24.0, 32.0].map((radius) {
                          final isSelected = store.borderRadius == radius;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ByShowcaseChoiceChip(
                              label: '${radius.toInt()}px',
                              isSelected: isSelected,
                              onTap: () => store.update(borderRadius: radius),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Frosted Glass Blur Sigma:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [0.0, 8.0, 16.0, 24.0].map((sigma) {
                          final isSelected = store.blurSigma == sigma;
                          final label = sigma == 0.0
                              ? 'Off (0.0)'
                              : '${sigma.toInt()}.0 px';
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ByShowcaseChoiceChip(
                              label: label,
                              isSelected: isSelected,
                              onTap: () => store.update(blurSigma: sigma),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Section 2: Color Theme & Glassmorphic Opacity (Rule 5.6)
                ByShowcaseControlCard(
                  title: '2. COLOR THEME & GLASSMORPHIC OPACITY',
                  icon: Icons.palette_rounded,
                  children: [
                    // Palette 1: Static AppBar Background Color
                    Text(
                      'Static AppBar Background Color:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ByColorPalette(
                      items: _colorThemes.map((theme) {
                        return ByColorPaletteItem(
                          label: theme['name'] as String?,
                          color: (theme['color'] as Color?) ?? colors.cardBg,
                          value: theme,
                        );
                      }).toList(),
                      selectedIndex: store.selectedColorIndex,
                      onSelected: (index) {
                        final theme = _colorThemes[index];
                        store.update(
                          selectedColorIndex: index,
                          customColor: theme['color'] as Color?,
                          clearCustomColor: theme['color'] == null,
                        );
                      },
                    ),
                    const SizedBox(height: 14),

                    // Palette 2: Floating State Background Color (Separate palette, inherits if null)
                    Text(
                      'Floating State Background Color:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ByColorPalette(
                      items: _floatingColorThemes.map((theme) {
                        final Color? rawColor = theme['color'] as Color?;
                        final Color displayColor =
                            rawColor ??
                            (store.customColor ?? colors.cardBg).withValues(
                              alpha: store.floatingOpacity,
                            );
                        return ByColorPaletteItem(
                          label: theme['name'] as String?,
                          color: displayColor,
                          value: theme,
                        );
                      }).toList(),
                      selectedIndex: store.selectedFloatingColorIndex,
                      onSelected: (index) {
                        final theme = _floatingColorThemes[index];
                        final isAutoOption = theme['color'] == null;
                        store.update(
                          selectedFloatingColorIndex: index,
                          customFloatingColor: theme['color'] as Color?,
                          clearCustomFloatingColor: isAutoOption,
                        );
                      },
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Floating Surface Opacity:',
                          style: AppTextStyle.fieldLabel.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colors.badgeBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colors.badgeBorder),
                          ),
                          child: Text(
                            '${(store.floatingOpacity * 100).round()}%',
                            style: AppTextStyle.badge.copyWith(
                              color: colors.badgeText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: colors.borderSubtle,
                        thumbColor: AppColors.primaryLight,
                        overlayColor: AppColors.primary.withValues(alpha: 0.18),
                        trackHeight: 4.0,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7.0,
                        ),
                      ),
                      child: Slider(
                        value: store.floatingOpacity.clamp(0.0, 1.0),
                        min: 0.0,
                        max: 1.0,
                        divisions: 100,
                        onChanged: (val) {
                          store.update(floatingOpacity: val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Section 3: AppBar Layout & Alignment
                ByShowcaseControlCard(
                  title: '3. APPBAR LAYOUT & ALIGNMENT',
                  icon: Icons.layers_rounded,
                  children: [
                    Text(
                      'Title Alignment:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ByShowcaseChoiceChip(
                            label: 'Start Aligned (Standard)',
                            isSelected: !store.centerTitle,
                            onTap: () => store.update(centerTitle: false),
                          ),
                          const SizedBox(width: 8),
                          ByShowcaseChoiceChip(
                            label: 'Center Title',
                            isSelected: store.centerTitle,
                            onTap: () => store.update(centerTitle: true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Floating Horizontal Margin:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [8.0, 14.0, 20.0, 28.0].map((margin) {
                          final isSelected = store.horizontalMargin == margin;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ByShowcaseChoiceChip(
                              label: '${margin.toInt()}px',
                              isSelected: isSelected,
                              onTap: () =>
                                  store.update(horizontalMargin: margin),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Floating Elevation / Drop Shadow:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [0.0, 2.0, 4.0, 8.0, 12.0].map((elevation) {
                          final isSelected =
                              store.floatingElevation == elevation;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ByShowcaseChoiceChip(
                              label: elevation == 0.0
                                  ? 'Flat (0)'
                                  : '${elevation.toInt()} dp',
                              isSelected: isSelected,
                              onTap: () =>
                                  store.update(floatingElevation: elevation),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Section 4: Dynamic Cursor Lighting & Border (Rule 5.6 compliant)
                ByShowcaseControlCard(
                  title: '4. DYNAMIC CURSOR LIGHTING & BORDER',
                  icon: Icons.mouse_rounded,
                  children: [
                    ByShowcaseSwitchTile(
                      title: 'Dynamic Gradient Border',
                      subtitle:
                          'Activates interactive gradient border reacting to sensor/cursor direction',
                      value: store.enableDynamicBorder,
                      onChanged: (val) =>
                          store.update(enableDynamicBorder: val),
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Physical Gyroscope & Accelerometer',
                      subtitle:
                          'Streams live hardware gravity vector on mobile',
                      value: store.enableSensor,
                      onChanged: (val) => store.update(enableSensor: val),
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Desktop/Web Mouse Hover Parallax',
                      subtitle:
                          'Tilts and rotates border lighting based on mouse cursor position',
                      value: store.enableHoverTilt,
                      onChanged: (val) => store.update(enableHoverTilt: val),
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Directional Inner Shadow (Glow)',
                      subtitle:
                          'Enables smooth directional ambient glow inside the floating app bar',
                      value: store.enableInnerShadow,
                      onChanged: (val) => store.update(enableInnerShadow: val),
                    ),
                    if (store.enableInnerShadow) ...[
                      const SizedBox(height: 8),
                      ByShowcaseSliderTile(
                        label: 'Inner Shadow Opacity:',
                        valueText:
                            '${store.innerShadowOpacity.toStringAsFixed(1)}x',
                        value: store.innerShadowOpacity,
                        min: 0.1,
                        max: 1.0,
                        divisions: 9,
                        onChanged: (val) =>
                            store.update(innerShadowOpacity: val),
                      ),
                    ],
                    if (store.enableDynamicBorder) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Tilt Simulation (Manual / Testing / Desktop):',
                        style: AppTextStyle.fieldLabel.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ByShowcaseSliderTile(
                        label: 'Horizontal Tilt (Roll X):',
                        valueText: _tiltX.toStringAsFixed(2),
                        value: _tiltX.clamp(-1.0, 1.0),
                        min: -1.0,
                        max: 1.0,
                        divisions: 40,
                        onChanged: (val) {
                          store.update(enableSensor: false);
                          setState(() {
                            _tiltX = val;
                          });
                        },
                      ),
                      ByShowcaseSliderTile(
                        label: 'Vertical Tilt (Pitch Y):',
                        valueText: _tiltY.toStringAsFixed(2),
                        value: _tiltY.clamp(-1.0, 1.0),
                        min: -1.0,
                        max: 1.0,
                        divisions: 40,
                        onChanged: (val) {
                          store.update(enableSensor: false);
                          setState(() {
                            _tiltY = val;
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      'Dynamic Border Gradient Preset:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ByColorPalette(
                      items: store.sensorGradientPresets
                          .map(
                            (preset) => ByColorPaletteItem(
                              label: preset['name'] as String?,
                              gradient: preset['gradient'] as Gradient?,
                            ),
                          )
                          .toList(),
                      selectedIndex: store.selectedSensorGradientIndex,
                      onSelected: (index) =>
                          store.update(selectedSensorGradientIndex: index),
                    ),
                    const SizedBox(height: 14),
                    ByShowcaseSwitchTile(
                      title: 'Outer Outline Border Stroke',
                      subtitle:
                          'Applies outline border geometry to the app bar',
                      value: store.enableBorder,
                      onChanged: (val) => store.update(enableBorder: val),
                    ),
                    if (store.enableBorder) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Border Stroke Width:',
                        style: AppTextStyle.fieldLabel.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [1.0, 1.5, 2.0, 3.0].map((width) {
                            final isSelected = store.borderWidth == width;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ByShowcaseChoiceChip(
                                label: '${width.toStringAsFixed(1)}px',
                                isSelected: isSelected,
                                onTap: () => store.update(borderWidth: width),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),

                // Section 5: Toolbar Component Color Presets (Rule 5.6 compliant)
                ByShowcaseControlCard(
                  title: '5. TOOLBAR COMPONENT COLOR PRESETS (EXTERNAL)',
                  icon: Icons.auto_awesome_rounded,
                  children: [
                    Text(
                      'ByAppBar leaves its child widget open for full custom modification. These circular presets configure the ByShowcaseHeader child components (brand badge, actions, and accents) externally without modifying ByAppBar parameters.',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Toolbar Component Coloring Preset:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ByColorPalette(
                      items: store.componentPresets
                          .map(
                            (preset) => ByColorPaletteItem(
                              label: preset.name,
                              gradient: preset.gradient,
                            ),
                          )
                          .toList(),
                      selectedIndex: store.selectedComponentPresetIndex,
                      onSelected: (index) =>
                          store.update(selectedComponentPresetIndex: index),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Section 6: Pulse Dynamic Border (Traveling neon laser beam Point A -> Point A)
                ByDynamicBorderControls(
                  title: '6. PULSE DYNAMIC BORDER (ONE-SHOT TRAVELING BEAM)',
                  config: store.pulseConfig,
                  onChanged: () => store.update(),
                  extraControls: [
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Auto-Start on Entrance',
                      subtitle:
                          'Executes traveling beam automatically when loaded',
                      value: store.pulseAutoStart,
                      onChanged: (val) => store.update(pulseAutoStart: val),
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSliderTile(
                      label: 'Sensor Resume Delay (Rest Buffer):',
                      valueText: '${store.sensorResumeDelayMs}ms',
                      value: store.sensorResumeDelayMs.toDouble(),
                      min: 0.0,
                      max: 1000.0,
                      divisions: 20,
                      onChanged: (val) =>
                          store.update(sensorResumeDelayMs: val.toInt()),
                    ),
                    ByShowcaseSliderTile(
                      label: 'Sensor Border Entrance Duration:',
                      valueText: '${store.sensorEntranceDurationMs}ms',
                      value: store.sensorEntranceDurationMs.toDouble(),
                      min: 100.0,
                      max: 1000.0,
                      divisions: 18,
                      onChanged: (val) =>
                          store.update(sensorEntranceDurationMs: val.toInt()),
                    ),
                  ],
                  actionButton: ByButton(
                    width: double.infinity,
                    variant: ByButtonVariant.filled,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    borderWidth: 0.0,
                    prefix: const Icon(Icons.bolt_rounded, size: 20),
                    onPressed: store.enablePulseBorder
                        ? () => _pulseController.pulse()
                        : null,
                    child: const Text(
                      'Trigger Pulse Now (Point A → Point A)',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Reset to Defaults (Strict Rule 6.5)
  void _resetToDefaults() {
    AppBarConfigStore.instance.resetToDefaults();
    setState(() {
      _tiltX = 0.0;
      _tiltY = 1.0;
    });
  }

  // Help Parameter Dialog (Strict Rule 6.5)
  void _showByAppBarParams(BuildContext context) {
    showWidgetParametersDialog(
      context,
      howToTry:
          '💡 How to try: Scroll the body to inspect surface blur and floating elevation, or toggle pulse border in Section 6!',
      parameters: const [
        WidgetParamInfo(
          name: 'child',
          type: 'Widget?',
          description:
              'Primary custom content widget inside the toolbar area (defaults to empty SizedBox.shrink).',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'bottom',
          type: 'PreferredSizeWidget?',
          description:
              'Optional widget displayed below the toolbar (e.g. TabBar).',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'isFloatingEnabled',
          type: 'bool',
          description:
              'Enables or disables the animated floating transition when scrolling.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'scrollThreshold',
          type: 'double',
          description:
              'Scroll pixel threshold to transition from static to floating.',
          defaultValue: '40.0',
        ),
        WidgetParamInfo(
          name: 'backgroundColor',
          type: 'Color?',
          description: 'Background surface color when at top of page.',
          defaultValue: 'theme canvasColor',
        ),
        WidgetParamInfo(
          name: 'floatingBackgroundColor',
          type: 'Color?',
          description:
              'Surface color when floating. Inherits backgroundColor if null.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'floatingOpacity',
          type: 'double?',
          description:
              'Opacity applied to floating background when floatingBackgroundColor is null, or to scale floating surface alpha.',
          defaultValue: '0.82 / 0.88',
        ),
        WidgetParamInfo(
          name: 'border / floatingBorder',
          type: 'BoxBorder?',
          description: 'Outer border stroke for static and floating states.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'borderGradient',
          type: 'Gradient?',
          description:
              'Dynamic gradient stroke that reacts to device tilt and hover parallax.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'shadowGradient',
          type: 'Gradient?',
          description:
              'Dynamic directional gradient glow/shadow cast from tilt direction.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'enableInnerShadow',
          type: 'bool',
          description:
              'Directional inner ambient shadow / spatial glow inside floating app bar.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'innerShadowOpacity',
          type: 'double?',
          description:
              'Custom opacity multiplier for the inner shadow / spatial glow (0.0 to 1.0).',
          defaultValue: 'null (1.0)',
        ),
        WidgetParamInfo(
          name: 'enableSensor',
          type: 'bool',
          description:
              'Streams live gyroscope and accelerometer hardware vector on mobile.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'enableHoverTilt',
          type: 'bool',
          description:
              'Tracks desktop and web mouse cursor position for reactive lighting.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'manualTilt',
          type: 'Offset?',
          description:
              'Explicit tilt coordinate (-1.0 to 1.0) overriding sensor stream.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'onTiltChanged',
          type: 'ValueChanged<Offset>?',
          description: 'Callback triggered whenever tilt coordinates update.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'floatingMargin',
          type: 'EdgeInsets?',
          description:
              'Margins applied around the app bar when transformed to floating.',
          defaultValue: 'EdgeInsets(14, 8, 14, 0)',
        ),
        WidgetParamInfo(
          name: 'floatingBorderRadius',
          type: 'BorderRadius?',
          description:
              'Corner radius applied to the floating card when scrolled.',
          defaultValue: 'BorderRadius.circular(16)',
        ),
        WidgetParamInfo(
          name: 'floatingBlurSigma',
          type: 'double',
          description:
              'Backdrop filter Gaussian blur strength for frosted glassmorphism.',
          defaultValue: '16.0',
        ),
        WidgetParamInfo(
          name: 'elevation / floatingElevation',
          type: 'double',
          description:
              'Drop shadow elevation depths for static and floating states.',
          defaultValue: '0.0 / 4.0',
        ),
        WidgetParamInfo(
          name: 'dynamicBorder',
          type: 'ByDynamicBorder?',
          description:
              'High-visibility traveling laser neon beam circuit traveling from Point A back to Point A.',
          defaultValue: 'null',
        ),
      ],
    );
  }
}
