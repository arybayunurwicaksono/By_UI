import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_bar_config_store.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_drawer.dart';
import '../widgets/by_showcase_header.dart';
import '../widgets/by_color_palette.dart';
import '../widgets/by_showcase_choice_chip.dart';
import '../widgets/widget_params_dialog.dart';
import 'card_showcase_screen.dart';
import 'dialog_showcase_screen.dart';
import 'toast_showcase_screen.dart';

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

  // Static Background Palette for Section 2 (Rule 5.1 & Rule 5.6)
  static final List<Map<String, dynamic>> _colorThemes = [
    {
      'name': 'Default Theme Card',
      'color': null, // Uses dynamic theme cardBg
    },
    {
      'name': 'Dark Slate',
      'color': AppColors.darkCard,
    },
    {
      'name': 'Pure White',
      'color': Colors.white,
    },
    {
      'name': 'Pure Black',
      'color': Colors.black,
    },
    {
      'name': 'Primary Indigo',
      'color': AppColors.primary,
    },
    {
      'name': 'Violet Neon',
      'color': AppColors.primaryAccent,
    },
    {
      'name': 'Sky Cyan',
      'color': AppColors.cyanAccent,
    },
    {
      'name': 'Emerald Mint',
      'color': AppColors.success,
    },
    {
      'name': 'Amber Sunset',
      'color': AppColors.warning,
    },
    {
      'name': 'Crimson Passion',
      'color': AppColors.error,
    },
    {
      'name': 'Royal Ocean',
      'color': AppColors.info,
    },
  ];

  // Floating Background Palette for Section 2 (Rule 5.1 & Rule 5.6)
  static final List<Map<String, dynamic>> _floatingColorThemes = [
    {
      'name': 'Auto (Follows Static Background)',
      'color': null, // Automatically follows static background with floatingOpacity
    },
    {
      'name': 'Dark Slate',
      'color': AppColors.darkCard,
    },
    {
      'name': 'Pure White',
      'color': Colors.white,
    },
    {
      'name': 'Pure Black',
      'color': Colors.black,
    },
    {
      'name': 'Primary Indigo',
      'color': AppColors.primary,
    },
    {
      'name': 'Violet Neon',
      'color': AppColors.primaryAccent,
    },
    {
      'name': 'Sky Cyan',
      'color': AppColors.cyanAccent,
    },
    {
      'name': 'Emerald Mint',
      'color': AppColors.success,
    },
    {
      'name': 'Amber Sunset',
      'color': AppColors.warning,
    },
    {
      'name': 'Crimson Passion',
      'color': AppColors.error,
    },
    {
      'name': 'Royal Ocean',
      'color': AppColors.info,
    },
  ];

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
              backgroundColor: store.customColor ??
                  (isDark ? AppColors.darkCard : Colors.white),
              floatingBackgroundColor: store.customFloatingColor
                  ?.withValues(alpha: store.floatingOpacity), // If null, ByAppBar automatically inherits backgroundColor with floatingOpacity
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
              floatingBorderWidth: (store.enableBorder || store.enableDynamicBorder)
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
            drawer: ByDrawer(
              activeComponent: 'ByAppBar',
              onSelectComponent: (comp) {
                if (comp == 'ByToast') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ToastShowcaseScreen(),
                    ),
                  );
                } else if (comp == 'ByDialog') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DialogShowcaseScreen(),
                    ),
                  );
                } else if (comp == 'ByCard') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CardShowcaseScreen(),
                    ),
                  );
                }
              },
            ),
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
                _buildHeroPreviewCard(colors, isDark, store),
                const SizedBox(height: 14),

                // 2. Preset Example Card
                _buildPresetCard(colors, isDark, store),
                const SizedBox(height: 14),

                // Section 1: Floating Dynamics & Scroll Behavior
                _buildControlCard(
                  colors: colors,
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
                            onTap: () =>
                                store.update(isFloatingEnabled: true),
                          ),
                          const SizedBox(width: 8),
                          ByShowcaseChoiceChip(
                            label: 'Disabled (Static Bar)',
                            isSelected: !store.isFloatingEnabled,
                            onTap: () =>
                                store.update(isFloatingEnabled: false),
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
                _buildControlCard(
                  colors: colors,
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
                        final Color displayColor = rawColor ??
                            (store.customColor ?? colors.cardBg)
                                .withValues(alpha: store.floatingOpacity);
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
                _buildControlCard(
                  colors: colors,
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
                          final isSelected = store.floatingElevation == elevation;
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
                _buildControlCard(
                  colors: colors,
                  title: '4. DYNAMIC CURSOR LIGHTING & BORDER',
                  icon: Icons.mouse_rounded,
                  children: [
                    _buildSwitchTile(
                      title: 'Dynamic Gradient Border',
                      subtitle:
                          'Activates interactive gradient border reacting to sensor/cursor direction',
                      value: store.enableDynamicBorder,
                      colors: colors,
                      onChanged: (val) =>
                          store.update(enableDynamicBorder: val),
                    ),
                    const SizedBox(height: 8),
                    _buildSwitchTile(
                      title: 'Physical Gyroscope & Accelerometer',
                      subtitle:
                          'Streams live hardware gravity vector on mobile',
                      value: store.enableSensor,
                      colors: colors,
                      onChanged: (val) => store.update(enableSensor: val),
                    ),
                    const SizedBox(height: 8),
                    _buildSwitchTile(
                      title: 'Desktop/Web Mouse Hover Parallax',
                      subtitle:
                          'Tilts and rotates border lighting based on mouse cursor position',
                      value: store.enableHoverTilt,
                      colors: colors,
                      onChanged: (val) => store.update(enableHoverTilt: val),
                    ),
                    const SizedBox(height: 8),
                    _buildSwitchTile(
                      title: 'Directional Inner Shadow (Glow)',
                      subtitle:
                          'Enables smooth directional ambient glow inside the floating app bar',
                      value: store.enableInnerShadow,
                      colors: colors,
                      onChanged: (val) => store.update(enableInnerShadow: val),
                    ),
                    if (store.enableInnerShadow) ...[
                      const SizedBox(height: 8),
                      _buildSliderRow(
                        title: 'Inner Shadow Opacity',
                        value: store.innerShadowOpacity,
                        min: 0.1,
                        max: 1.0,
                        suffix: 'x',
                        colors: colors,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Horizontal Tilt (Roll X)',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 48,
                            child: Text(
                              _tiltX.toStringAsFixed(2),
                              style: AppTextStyle.badge.copyWith(
                                color: colors.textPrimary,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _tiltX.clamp(-1.0, 1.0),
                        min: -1.0,
                        max: 1.0,
                        activeColor: AppColors.primary,
                        inactiveColor: colors.borderSubtle,
                        onChanged: (val) {
                          store.update(enableSensor: false);
                          setState(() {
                            _tiltX = val;
                          });
                        },
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Vertical Tilt (Pitch Y)',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 48,
                            child: Text(
                              _tiltY.toStringAsFixed(2),
                              style: AppTextStyle.badge.copyWith(
                                color: colors.textPrimary,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _tiltY.clamp(-1.0, 1.0),
                        min: -1.0,
                        max: 1.0,
                        activeColor: AppColors.primary,
                        inactiveColor: colors.borderSubtle,
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
                    // Standard Rule 5.6: 36x36 Circular Swatches for Gradients
                    ByColorPalette(
                      items: store.sensorGradientPresets.map((preset) => ByColorPaletteItem(
                        label: preset['name'] as String?,
                        gradient: preset['gradient'] as Gradient?,
                      )).toList(),
                      selectedIndex: store.selectedSensorGradientIndex,
                      onSelected: (index) => store.update(
                        selectedSensorGradientIndex: index,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildSwitchTile(
                      title: 'Outer Outline Border Stroke',
                      subtitle:
                          'Applies outline border geometry to the app bar',
                      value: store.enableBorder,
                      colors: colors,
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
                _buildControlCard(
                  colors: colors,
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
                      items: store.componentPresets.map((preset) => ByColorPaletteItem(
                        label: preset.name,
                        gradient: preset.gradient,
                      )).toList(),
                      selectedIndex: store.selectedComponentPresetIndex,
                      onSelected: (index) => store.update(
                        selectedComponentPresetIndex: index,
                      ),
                    ),
                  ],
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
          description:
              'Callback triggered whenever tilt coordinates update.',
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
      ],
    );
  }

  // Preset Example Card
  Widget _buildPresetCard(
    AppColorPalette colors,
    bool isDark,
    AppBarConfigStore store,
  ) {
    final presets = [
      (
        name: 'Frosted Glass',
        color: AppColors.primary,
        icon: Icons.blur_on_rounded,
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
      (
        name: 'Dynamic Aurora',
        color: AppColors.cyanAccent,
        icon: Icons.auto_awesome_rounded,
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
      (
        name: 'Minimal Static',
        color: const Color(0xFF64748B),
        icon: Icons.crop_square_rounded,
        onTap: () {
          store.update(
            isFloatingEnabled: false,
            enableBorder: false,
            enableDynamicBorder: false,
          );
        },
      ),
      (
        name: 'Accent Neon',
        color: AppColors.primaryAccent,
        icon: Icons.bolt_rounded,
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
    ];

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
              children: List.generate(presets.length, (index) {
                final preset = presets[index];
                final color = preset.color;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: preset.onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: color.withValues(alpha: 0.35),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(preset.icon, size: 14, color: color),
                            const SizedBox(width: 6),
                            Text(
                              preset.name,
                              style: AppTextStyle.pillButton.copyWith(
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Hero Preview Card (Rule 6.5)
  Widget _buildHeroPreviewCard(
    AppColorPalette colors,
    bool isDark,
    AppBarConfigStore store,
  ) {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: colors.cardBg,
      borderColor: colors.border,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.web_asset_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
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
                      'Scroll down to watch this bar transition live',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'The top navigation bar above will automatically float, detach from screen edges, and activate frosted glass blur when you scroll down this showcase.',
            style: AppTextStyle.body.copyWith(
              color: colors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildMetricBadge(
                label: 'Mode',
                value: store.isFloatingEnabled ? 'Floating' : 'Static',
                colors: colors,
              ),
              _buildMetricBadge(
                label: 'Top Color',
                value: _colorThemes[store.selectedColorIndex]['name'] as String,
                colors: colors,
              ),
              _buildMetricBadge(
                label: 'Float Color',
                value: store.customFloatingColor == null
                    ? 'Auto (Inherited)'
                    : _floatingColorThemes[store.selectedFloatingColorIndex]
                        ['name'] as String,
                colors: colors,
              ),
              _buildMetricBadge(
                label: 'Radius',
                value: '${store.borderRadius.toInt()}px',
                colors: colors,
              ),
              _buildMetricBadge(
                label: 'Blur',
                value: '${store.blurSigma.toInt()}px',
                colors: colors,
              ),
              _buildMetricBadge(
                label: 'Opacity',
                value: '${(store.floatingOpacity * 100).toInt()}%',
                colors: colors,
              ),
              _buildMetricBadge(
                label: 'Dynamic Border',
                value: store.enableDynamicBorder ? 'Active' : 'Off',
                colors: colors,
              ),
              _buildMetricBadge(
                label: 'Border',
                value: store.enableBorder
                    ? '${store.borderWidth.toStringAsFixed(1)}px'
                    : 'Off',
                colors: colors,
              ),
              _buildMetricBadge(
                label: 'Preset',
                value: store.activeComponentPreset.name,
                colors: colors,
              ),
              if (store.enableDynamicBorder)
                _buildMetricBadge(
                  label: 'Tilt Vector',
                  value:
                      'X: ${_tiltX.toStringAsFixed(2)}, Y: ${_tiltY.toStringAsFixed(2)}',
                  colors: colors,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBadge({
    required String label,
    required String value,
    required AppColorPalette colors,
  }) {
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
            '$label: ',
            style: AppTextStyle.caption.copyWith(
              color: colors.textMuted,
              fontSize: 11,
            ),
          ),
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

  // Section Control Card (Dogfooding ByCard, Rule 6.5)
  Widget _buildControlCard({
    required AppColorPalette colors,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: colors.cardBg,
      borderColor: colors.border,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.sectionHeader.copyWith(
                    color: colors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required AppColorPalette colors,
    required ValueChanged<bool> onChanged,
  }) {
    return ByShowcaseSwitchTile(
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSliderRow({
    required String title,
    required double value,
    required double min,
    required double max,
    required String suffix,
    required AppColorPalette colors,
    required ValueChanged<double> onChanged,
  }) {
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
                  title,
                  style: AppTextStyle.fieldLabel.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              Text(
                '${value.toStringAsFixed(1)} $suffix',
                style: AppTextStyle.badge.copyWith(color: colors.textPrimary),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: AppColors.primary,
            inactiveColor: colors.borderSubtle,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
