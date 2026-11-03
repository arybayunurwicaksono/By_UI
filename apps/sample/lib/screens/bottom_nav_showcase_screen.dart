import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';

import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_drawer.dart';
import '../widgets/by_showcase_header.dart';
import '../widgets/by_showcase_preview_card.dart';
import '../widgets/by_showcase_preset_card.dart';
import '../widgets/by_showcase_integration_banner.dart';
import '../widgets/by_showcase_control_card.dart';
import '../widgets/by_showcase_choice_chip.dart';
import '../widgets/by_showcase_slider_tile.dart';
import '../widgets/by_color_palette.dart';
import '../widgets/widget_params_dialog.dart';
import '../widgets/by_code_dialog.dart';

/// Interactive showcase screen for [ByBottomNav].
class BottomNavShowcaseScreen extends StatefulWidget {
  const BottomNavShowcaseScreen({super.key});

  @override
  State<BottomNavShowcaseScreen> createState() =>
      _BottomNavShowcaseScreenState();
}

class _BottomNavShowcaseScreenState extends State<BottomNavShowcaseScreen> {
  int _selectedIndex = 0;
  bool _enableProximity = true;
  bool _enableSensor = true;
  bool _enableDynamicBorder = true;
  bool _enableSelectionPulse = true;
  bool _showActiveDot = true;
  ByBottomNavLabelBehavior _labelBehavior =
      ByBottomNavLabelBehavior.tooltipOnly;
  ByBottomNavIndicatorStyle _indicatorStyle = ByBottomNavIndicatorStyle.dot;
  bool _isFloating = true;

  double _maxMagnification = 1.35;
  double _proximityRange = 90.0;
  double _blurSigma = 16.0;
  bool _autoContentColor = true;

  // Geometry
  double _dockRadius = 28.0;
  double _itemRadius = 14.0;
  double _itemSize = 44.0;
  double _iconSize = 22.0;
  double _borderWidth = 1.2;
  double _glowBlur = 18.0;

  int _selectedActiveColorIndex = 0;
  int _selectedBgColorIndex = 0;
  int _selectedLaserGradientIndex = 0;
  int _activePresetIndex = 0;
  bool _isMaximized = false;

  static const List<ShowcaseColorOption> _activeColorOptions = [
    ShowcaseColorOption('Sky Cyan', AppColors.cyanAccent),
    ShowcaseColorOption('Primary Indigo', AppColors.primary),
    ShowcaseColorOption('Violet Neon', AppColors.primaryAccent),
    ShowcaseColorOption('Electric Blue', Color(0xFF2563EB)),
    ShowcaseColorOption('Rose Pink', Color(0xFFF43F5E)),
    ShowcaseColorOption('Neon Lime', Color(0xFF10B981)),
    ShowcaseColorOption('Coral Orange', Color(0xFFFF6B6B)),
    ShowcaseColorOption('Fuchsia Neon', Color(0xFFD946EF)),
    ShowcaseColorOption('Sun Gold', Color(0xFFF59E0B)),
    ShowcaseColorOption('Emerald Mint', AppColors.success),
    ShowcaseColorOption('Amber Sunset', AppColors.warning),
    ShowcaseColorOption('Crimson Passion', AppColors.error),
    ShowcaseColorOption('Pure White', Colors.white),
  ];

  static final List<ShowcaseColorOption> _bgColorOptions = [
    const ShowcaseColorOption('Auto (Theme Glass)', null),
    ShowcaseColorOption(
      'Dark Slate Glass',
      AppColors.darkCard.withValues(alpha: 0.75),
    ),
    ShowcaseColorOption(
      'Obsidian Glass',
      AppColors.obsidianDarkest.withValues(alpha: 0.85),
    ),
    ShowcaseColorOption(
      'Midnight Blue Glass',
      const Color(0xFF0D1B2A).withValues(alpha: 0.85),
    ),
    ShowcaseColorOption(
      'Deep Sapphire Glass',
      const Color(0xFF0F172A).withValues(alpha: 0.85),
    ),
    ShowcaseColorOption(
      'Dark Emerald Glass',
      const Color(0xFF062319).withValues(alpha: 0.85),
    ),
    ShowcaseColorOption(
      'Deep Amethyst Glass',
      const Color(0xFF1B102E).withValues(alpha: 0.85),
    ),
    ShowcaseColorOption(
      'Dark Burgundy Glass',
      const Color(0xFF280B16).withValues(alpha: 0.85),
    ),
    ShowcaseColorOption(
      'Deep Navy Glass',
      AppColors.deepRoyal.withValues(alpha: 0.75),
    ),
    ShowcaseColorOption(
      'Espresso Charcoal Glass',
      const Color(0xFF1E2229).withValues(alpha: 0.85),
    ),
    ShowcaseColorOption(
      'Translucent Ice Glass',
      const Color(0xFFE2E8F0).withValues(alpha: 0.85),
    ),
    ShowcaseColorOption('Frosted White', Colors.white.withValues(alpha: 0.85)),
  ];

  final List<ByBottomNavItem> _dockItems = const [
    ByBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
    ByBottomNavItem(icon: Icons.explore_rounded, label: 'Explore'),
    ByBottomNavItem(
      icon: Icons.favorite_rounded,
      label: 'Favorites',
      showBadgeDot: true,
    ),
    ByBottomNavItem(
      icon: Icons.notifications_rounded,
      label: 'Inbox',
      badgeText: '99+',
    ),
    ByBottomNavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        final colors = AppColors.of(context);
        final isDark = AppThemeStore.instance.isDarkMode(context);

        final selectedActiveCol =
            _activeColorOptions[_selectedActiveColorIndex].color ??
            AppColors.cyanAccent;
        final selectedBgCol = _bgColorOptions[_selectedBgColorIndex].color;
        final selectedLaserPreset =
            AppColors.appBarSensorGradients[_selectedLaserGradientIndex];

        return PopScope(
          canPop: !_isMaximized,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && _isMaximized) {
              setState(() => _isMaximized = false);
            }
          },
          child: ByScrollScope(
            child: Scaffold(
              backgroundColor: colors.scaffoldBg,
              extendBodyBehindAppBar: true,
              appBar: ByAppBar(
                child: ByShowcaseHeader(
                  componentName: 'ByBottomNav',
                  titleSuffix: _isMaximized ? 'Live Preview' : 'Showcase',
                  extraActions: _isMaximized
                      ? [
                          IconButton(
                            icon: const Icon(Icons.replay_rounded),
                            tooltip: 'Reset to Home',
                            onPressed: () => setState(() => _selectedIndex = 0),
                          ),
                          IconButton(
                            icon: const Icon(Icons.fullscreen_exit_rounded),
                            tooltip: 'Minimize Preview',
                            onPressed: () =>
                                setState(() => _isMaximized = false),
                          ),
                        ]
                      : null,
                  onReset: _isMaximized ? null : _resetToDefaults,
                  onOpenParams: _isMaximized
                      ? null
                      : () => _showParamsDialog(context),
                  onViewCode: () => _showCodeDialog(context),
                ),
              ),
              drawer: const ByDrawer(activeComponent: 'ByBottomNav'),
              body: _isMaximized
                  ? _buildMaximizedDockBody(
                      context: context,
                      colors: colors,
                      isDark: isDark,
                      activeColor: selectedActiveCol,
                      bgColor: selectedBgCol,
                      laserColors:
                          selectedLaserPreset.colors ??
                          const [AppColors.cyanAccent, AppColors.primary],
                    )
                  : ListView(
                      padding: EdgeInsets.fromLTRB(
                        12,
                        ByAppBar.getContentTopPadding(context, extra: 10),
                        12,
                        24,
                      ),
                      children: [
                        // ── LAYER 1: Active Configuration Preview Card ────────────
                        ByShowcasePreviewCard(
                          icon: Icons.dock_rounded,
                          subtitle:
                              'Live metrics for ByBottomNav configuration state',
                          metrics: [
                            ByMetricBadge(
                              label: 'Active',
                              value: _dockItems[_selectedIndex].label
                                  .toUpperCase(),
                            ),
                            ByMetricBadge(
                              label: 'Proximity',
                              value: _enableProximity ? 'ACTIVE' : 'OFF',
                            ),
                            ByMetricBadge(
                              label: 'Max Scale',
                              value: '${_maxMagnification.toStringAsFixed(2)}x',
                            ),
                            ByMetricBadge(
                              label: 'Radius',
                              value: '${_dockRadius.toInt()}px',
                            ),
                            ByMetricBadge(
                              label: 'Item Box',
                              value: '${_itemSize.toInt()}px',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── LAYER 2: Preset Example Card ──────────────────────────
                        ByShowcasePresetCard(
                          presets: [
                            ByShowcasePresetItem(
                              label: 'macOS Glass',
                              themeColor: AppColors.primary,
                              isSelected: _activePresetIndex == 0,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 0;
                                  _enableProximity = true;
                                  _enableSensor = true;
                                  _enableDynamicBorder = true;
                                  _showActiveDot = true;
                                  _maxMagnification = 1.35;
                                  _proximityRange = 90.0;
                                  _blurSigma = 16.0;
                                  _dockRadius = 28.0;
                                  _itemRadius = 14.0;
                                  _itemSize = 44.0;
                                  _iconSize = 22.0;
                                  _borderWidth = 1.2;
                                  _glowBlur = 18.0;
                                  _selectedActiveColorIndex = 0;
                                  _selectedBgColorIndex = 0;
                                  _selectedLaserGradientIndex = 0;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Cyber Parabolic',
                              themeColor: AppColors.primaryAccent,
                              isSelected: _activePresetIndex == 1,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 1;
                                  _enableProximity = true;
                                  _enableSensor = true;
                                  _enableDynamicBorder = true;
                                  _enableSelectionPulse = true;
                                  _showActiveDot = true;
                                  _maxMagnification = 1.50;
                                  _proximityRange = 120.0;
                                  _blurSigma = 24.0;
                                  _dockRadius = 32.0;
                                  _itemRadius = 16.0;
                                  _itemSize = 48.0;
                                  _iconSize = 24.0;
                                  _borderWidth = 1.5;
                                  _glowBlur = 24.0;
                                  _selectedActiveColorIndex = 2;
                                  _selectedBgColorIndex = 1;
                                  _selectedLaserGradientIndex = 1;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Emerald Dock',
                              themeColor: AppColors.success,
                              isSelected: _activePresetIndex == 2,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 2;
                                  _enableProximity = true;
                                  _enableSensor = true;
                                  _enableDynamicBorder = true;
                                  _enableSelectionPulse = true;
                                  _showActiveDot = true;
                                  _maxMagnification = 1.30;
                                  _proximityRange = 80.0;
                                  _blurSigma = 14.0;
                                  _dockRadius = 24.0;
                                  _itemRadius = 12.0;
                                  _itemSize = 42.0;
                                  _iconSize = 20.0;
                                  _borderWidth = 1.0;
                                  _glowBlur = 14.0;
                                  _selectedActiveColorIndex = 3;
                                  _selectedBgColorIndex = 0;
                                  _selectedLaserGradientIndex = 2;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Static Minimal',
                              themeColor: AppColors.textMuted(isDark),
                              isSelected: _activePresetIndex == 3,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 3;
                                  _enableProximity = false;
                                  _enableSensor = false;
                                  _enableDynamicBorder = false;
                                  _enableSelectionPulse = false;
                                  _showActiveDot = false;
                                  _maxMagnification = 1.0;
                                  _blurSigma = 8.0;
                                  _dockRadius = 20.0;
                                  _itemRadius = 10.0;
                                  _itemSize = 40.0;
                                  _iconSize = 20.0;
                                  _borderWidth = 1.0;
                                  _glowBlur = 0.0;
                                  _selectedActiveColorIndex = 0;
                                  _selectedBgColorIndex = 0;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── LAYER 3: Cross-Component Integration Banner ───────────
                        const ByShowcaseIntegrationBanner(
                          componentName: 'ByCard',
                          description:
                              'ByBottomNav integrates spatial hardware tilt physics from ByTiltController for responsive directional ambient glow.',
                        ),
                        const SizedBox(height: 14),

                        // ── LAYER 4: Standalone Widget Display (Hero Live Preview) ─
                        _buildHeroPreview(
                          colors: colors,
                          activeColor: selectedActiveCol,
                          bgColor: selectedBgCol,
                          laserColors:
                              selectedLaserPreset.colors ??
                              const [AppColors.cyanAccent, AppColors.primary],
                        ),
                        const SizedBox(height: 14),

                        // ── LAYER 5: Numbered Control Cards ───────────────────────
                        ByShowcaseControlCard(
                          title: '1. PROXIMITY & SENSOR INTERACTIVITY',
                          icon: Icons.tune_rounded,
                          children: [
                            ByShowcaseSwitchTile(
                              title: 'Parabolic Magnetic Proximity',
                              subtitle:
                                  'Magnifies icons smoothly as the cursor or finger moves within range',
                              value: _enableProximity,
                              onChanged: (val) =>
                                  setState(() => _enableProximity = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Device Accelerometer Tilt Tracking',
                              subtitle:
                                  'Shifts directional ambient shadow glow with physical device tilt',
                              value: _enableSensor,
                              onChanged: (val) =>
                                  setState(() => _enableSensor = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Traveling Dynamic Neon Border',
                              subtitle:
                                  'Traverses a laser circuit around the dock perimeter',
                              value: _enableDynamicBorder,
                              onChanged: (val) =>
                                  setState(() => _enableDynamicBorder = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Selection Dynamic Border Pulse',
                              subtitle:
                                  'Pulses a 3-phase laser border around the selected item before fading in the static border',
                              value: _enableSelectionPulse,
                              onChanged: (val) =>
                                  setState(() => _enableSelectionPulse = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Active Dot Glow Indicator',
                              subtitle:
                                  'Displays an illuminated dot beneath the currently active item',
                              value: _showActiveDot,
                              onChanged: (val) =>
                                  setState(() => _showActiveDot = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '2. LABELS & ACTIVE INDICATOR STYLES',
                          icon: Icons.label_rounded,
                          children: [
                            Text(
                              'Label Display Behavior:',
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
                                    label: 'Tooltip Only (Clean Dock)',
                                    isSelected:
                                        _labelBehavior ==
                                        ByBottomNavLabelBehavior.tooltipOnly,
                                    onTap: () => setState(
                                      () => _labelBehavior =
                                          ByBottomNavLabelBehavior.tooltipOnly,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Always Show',
                                    isSelected:
                                        _labelBehavior ==
                                        ByBottomNavLabelBehavior.alwaysShow,
                                    onTap: () => setState(
                                      () => _labelBehavior =
                                          ByBottomNavLabelBehavior.alwaysShow,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Only Selected',
                                    isSelected:
                                        _labelBehavior ==
                                        ByBottomNavLabelBehavior.onlySelected,
                                    onTap: () => setState(
                                      () => _labelBehavior =
                                          ByBottomNavLabelBehavior.onlySelected,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Active Indicator Style:',
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
                                    label: 'Glowing Dot',
                                    isSelected:
                                        _indicatorStyle ==
                                        ByBottomNavIndicatorStyle.dot,
                                    onTap: () => setState(
                                      () => _indicatorStyle =
                                          ByBottomNavIndicatorStyle.dot,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Accent Dash Line',
                                    isSelected:
                                        _indicatorStyle ==
                                        ByBottomNavIndicatorStyle.line,
                                    onTap: () => setState(
                                      () => _indicatorStyle =
                                          ByBottomNavIndicatorStyle.line,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Capsule Pill Only',
                                    isSelected:
                                        _indicatorStyle ==
                                        ByBottomNavIndicatorStyle.pill,
                                    onTap: () => setState(
                                      () => _indicatorStyle =
                                          ByBottomNavIndicatorStyle.pill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ByShowcaseSwitchTile(
                              title: 'Floating Capsule Dock Mode',
                              subtitle:
                                  'When disabled, docks full-width at the bottom of the screen with safe area padding',
                              value: _isFloating,
                              onChanged: (val) =>
                                  setState(() => _isFloating = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '3. CAPSULE & ITEM GEOMETRY',
                          icon: Icons.straighten_rounded,
                          children: [
                            ByShowcaseSliderTile(
                              label: 'Dock Capsule Radius:',
                              valueText: '${_dockRadius.toInt()}px',
                              value: _dockRadius,
                              min: 0.0,
                              max: 36.0,
                              divisions: 36,
                              onChanged: (val) =>
                                  setState(() => _dockRadius = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Item Box Radius:',
                              valueText: '${_itemRadius.toInt()}px',
                              value: _itemRadius,
                              min: 0.0,
                              max: 24.0,
                              divisions: 24,
                              onChanged: (val) =>
                                  setState(() => _itemRadius = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Item Slot Size:',
                              valueText: '${_itemSize.toInt()}px',
                              value: _itemSize,
                              min: 36.0,
                              max: 56.0,
                              divisions: 20,
                              onChanged: (val) =>
                                  setState(() => _itemSize = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Icon Glyph Size:',
                              valueText: '${_iconSize.toInt()}px',
                              value: _iconSize,
                              min: 16.0,
                              max: 28.0,
                              divisions: 12,
                              onChanged: (val) =>
                                  setState(() => _iconSize = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Outer Border Width:',
                              valueText: '${_borderWidth.toStringAsFixed(1)}px',
                              value: _borderWidth,
                              min: 0.0,
                              max: 3.0,
                              divisions: 6,
                              onChanged: (val) =>
                                  setState(() => _borderWidth = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '4. COLOR PALETTES & BACKDROP',
                          icon: Icons.palette_rounded,
                          children: [
                            Text(
                              'Active Accent Theme Color:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromOptions(
                              options: _activeColorOptions,
                              selectedIndex: _selectedActiveColorIndex,
                              onSelected: (idx) => setState(
                                () => _selectedActiveColorIndex = idx,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Dock Surface Background Color:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromOptions(
                              options: _bgColorOptions,
                              selectedIndex: _selectedBgColorIndex,
                              onSelected: (idx) =>
                                  setState(() => _selectedBgColorIndex = idx),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Active Dynamic Laser Colors:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromPresets(
                              presets: AppColors.appBarSensorGradients,
                              selectedIndex: _selectedLaserGradientIndex,
                              onSelected: (idx) => setState(
                                () => _selectedLaserGradientIndex = idx,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ByShowcaseSwitchTile(
                              title: 'Intelligent Auto-Contrast Content',
                              subtitle:
                                  'Adapts active icon & text contrast automatically when using bright/white backgrounds',
                              value: _autoContentColor,
                              onChanged: (val) =>
                                  setState(() => _autoContentColor = val),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '5. MAGNIFICATION & GLASS BLUR',
                          icon: Icons.blur_on_rounded,
                          children: [
                            ByShowcaseSliderTile(
                              label: 'Max Scale Multiplier:',
                              valueText:
                                  '${_maxMagnification.toStringAsFixed(2)}x',
                              value: _maxMagnification,
                              min: 1.0,
                              max: 1.6,
                              divisions: 12,
                              onChanged: (val) =>
                                  setState(() => _maxMagnification = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Proximity Detection Range:',
                              valueText: '${_proximityRange.toInt()}px',
                              value: _proximityRange,
                              min: 40.0,
                              max: 140.0,
                              divisions: 20,
                              onChanged: (val) =>
                                  setState(() => _proximityRange = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Frosted Glass Blur Sigma:',
                              valueText: '${_blurSigma.toInt()}px',
                              value: _blurSigma,
                              min: 4.0,
                              max: 30.0,
                              divisions: 26,
                              onChanged: (val) =>
                                  setState(() => _blurSigma = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Spatial Ambient Glow Blur:',
                              valueText: '${_glowBlur.toInt()}px',
                              value: _glowBlur,
                              min: 0.0,
                              max: 30.0,
                              divisions: 30,
                              onChanged: (val) =>
                                  setState(() => _glowBlur = val),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  void _resetToDefaults() {
    setState(() {
      _selectedIndex = 0;
      _enableProximity = true;
      _enableSensor = true;
      _enableDynamicBorder = true;
      _enableSelectionPulse = true;
      _showActiveDot = true;
      _labelBehavior = ByBottomNavLabelBehavior.tooltipOnly;
      _indicatorStyle = ByBottomNavIndicatorStyle.dot;
      _isFloating = true;
      _maxMagnification = 1.35;
      _proximityRange = 90.0;
      _blurSigma = 16.0;
      _dockRadius = 28.0;
      _itemRadius = 14.0;
      _itemSize = 44.0;
      _iconSize = 22.0;
      _borderWidth = 1.2;
      _glowBlur = 18.0;
      _selectedActiveColorIndex = 0;
      _selectedBgColorIndex = 0;
      _selectedLaserGradientIndex = 0;
      _activePresetIndex = 0;
      _autoContentColor = true;
    });
  }

  // ── CODE SNIPPET GENERATOR ──────────────────────────────────────────────
  String _generateCodeSnippet() {
    final buffer = StringBuffer();
    buffer.writeln('ByBottomNav(');
    buffer.writeln('  selectedIndex: _selectedIndex,');
    buffer.writeln(
      '  onItemSelected: (index) => setState(() => _selectedIndex = index),',
    );
    buffer.writeln('  items: const [');
    buffer.writeln(
      "    ByBottomNavItem(label: 'Home', icon: Icons.home_rounded),",
    );
    buffer.writeln(
      "    ByBottomNavItem(label: 'Explore', icon: Icons.explore_rounded, badgeText: 'HOT'),",
    );
    buffer.writeln(
      "    ByBottomNavItem(label: 'Activity', icon: Icons.notifications_rounded, badgeCount: 3),",
    );
    buffer.writeln(
      "    ByBottomNavItem(label: 'Profile', icon: Icons.person_rounded),",
    );
    buffer.writeln('  ],');
    buffer.writeln('  activeColor: const Color(0xFF00F5FF),');
    buffer.writeln('  blurSigma: ${_blurSigma.toStringAsFixed(1)},');
    if (_enableSelectionPulse) {
      buffer.writeln('  enableSelectionPulse: true,');
    }
    buffer.writeln('  maxMagnification: ${_maxMagnification.toStringAsFixed(2)},');
    buffer.writeln('  proximityRange: ${_proximityRange.toStringAsFixed(1)},');
    buffer.writeln('  itemSize: ${_itemSize.toStringAsFixed(1)},');
    buffer.writeln('  borderWidth: ${_borderWidth.toStringAsFixed(1)},');
    buffer.write(')');
    return buffer.toString();
  }

  void _showCodeDialog(BuildContext context) {
    showByCodeDialog(
      context,
      componentName: 'ByBottomNav',
      code: _generateCodeSnippet(),
    );
  }

  void _showParamsDialog(BuildContext context) {
    showWidgetParametersDialog(
      context,
      howToTry:
          'Hover your cursor over the icons or tilt your mobile device to experience parabolic magnetic magnification and spatial ambient glow.',
      howToTryIcon: AppIcons.touch,
      parameters: const [
        WidgetParamInfo(
          name: 'items',
          type: 'List<ByBottomNavItem>',
          description:
              'The collection of dock navigation items with icons, text badges, and status dots.',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'selectedIndex',
          type: 'int',
          description: 'The currently selected dock item index (0-indexed).',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'labelBehavior',
          type: 'ByBottomNavLabelBehavior',
          description:
              'Controls label visibility: tooltipOnly (clean dock), alwaysShow (mobile bar), or onlySelected.',
          defaultValue: 'tooltipOnly',
        ),
        WidgetParamInfo(
          name: 'isFloating',
          type: 'bool',
          description:
              'Whether to render as a floating glass capsule or full-width bottom docked bar.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'activeIndicatorStyle',
          type: 'ByBottomNavIndicatorStyle',
          description:
              'Visual indicator beneath item: dot, line, pill, or none.',
          defaultValue: 'dot',
        ),
        WidgetParamInfo(
          name: 'maxMagnification',
          type: 'double',
          description:
              'Peak scaling factor reached when cursor is directly centered.',
          defaultValue: '1.35',
        ),
        WidgetParamInfo(
          name: 'proximityRange',
          type: 'double',
          description:
              'Distance in logical pixels where proximity magnification takes effect.',
          defaultValue: '90.0',
        ),
        WidgetParamInfo(
          name: 'blurSigma',
          type: 'double',
          description: 'Gaussian backdrop frosted glass blur radius in pixels.',
          defaultValue: '16.0',
        ),
        WidgetParamInfo(
          name: 'itemSize',
          type: 'double',
          description:
              'Width and height dimensions for individual item slot containers.',
          defaultValue: '44.0',
        ),
        WidgetParamInfo(
          name: 'itemBorderRadius',
          type: 'BorderRadius',
          description:
              'Corner radius geometry for individual item slot containers.',
          defaultValue: 'BorderRadius.circular(14.0)',
        ),
        WidgetParamInfo(
          name: 'showActiveDot',
          type: 'bool',
          description:
              'Whether to render the active dot indicator beneath selected item.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'glowBlurRadius',
          type: 'double',
          description: 'Blur radius for directional ambient tilt drop shadow.',
          defaultValue: '18.0',
        ),
      ],
    );
  }

  Widget _buildHeroPreview({
    required AppColorPalette colors,
    required Color activeColor,
    required Color? bgColor,
    required List<Color> laserColors,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'INTERACTIVE PREVIEW',
                        style: AppTextStyle.badge.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: activeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: activeColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          _dockItems[_selectedIndex].label.toUpperCase(),
                          style: AppTextStyle.badge.copyWith(
                            color: activeColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.fullscreen_rounded,
                      color: colors.textPrimary,
                    ),
                    tooltip: 'Maximize Live Preview',
                    onPressed: () => setState(() => _isMaximized = true),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ByBottomNav(
                  items: _dockItems,
                  selectedIndex: _selectedIndex,
                  activeColor: activeColor,
                  backgroundColor: bgColor,
                  autoContentColor: _autoContentColor,
                  borderRadius: BorderRadius.circular(_dockRadius),
                  itemBorderRadius: BorderRadius.circular(_itemRadius),
                  itemSize: _itemSize,
                  iconSize: _iconSize,
                  borderWidth: _borderWidth,
                  glowBlurRadius: _glowBlur,
                  showActiveDot: _showActiveDot,
                  maxMagnification: _maxMagnification,
                  proximityRange: _proximityRange,
                  blurSigma: _blurSigma,
                  enableMagneticProximity: _enableProximity,
                  enableSensor: _enableSensor,
                  enableDynamicBorder: _enableDynamicBorder,
                  enableSelectionPulse: _enableSelectionPulse,
                  selectionPulseColors: laserColors,
                  dynamicBorderColors: laserColors,
                  labelBehavior: _labelBehavior,
                  isFloating: _isFloating,
                  activeIndicatorStyle: _indicatorStyle,
                  onItemSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaximizedDockBody({
    required BuildContext context,
    required AppColorPalette colors,
    required bool isDark,
    required Color activeColor,
    required Color? bgColor,
    required List<Color> laserColors,
  }) {
    final topPadding = ByAppBar.getContentTopPadding(context, extra: 10);

    return Stack(
      children: [
        // Main Workspace Content
        Padding(
          padding: EdgeInsets.fromLTRB(16, topPadding, 16, 110),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: KeyedSubtree(
                  key: ValueKey<int>(_selectedIndex),
                  child: _buildDockPageContent(
                    colors: colors,
                    activeColor: activeColor,
                    index: _selectedIndex,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Floating Nav Dock anchored at bottom
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Center(
            child: ByBottomNav(
              items: _dockItems,
              selectedIndex: _selectedIndex,
              activeColor: activeColor,
              backgroundColor: bgColor,
              autoContentColor: _autoContentColor,
              borderRadius: BorderRadius.circular(_dockRadius),
              itemBorderRadius: BorderRadius.circular(_itemRadius),
              itemSize: _itemSize,
              iconSize: _iconSize,
              borderWidth: _borderWidth,
              glowBlurRadius: _glowBlur,
              showActiveDot: _showActiveDot,
              maxMagnification: _maxMagnification,
              proximityRange: _proximityRange,
              blurSigma: _blurSigma,
              enableMagneticProximity: _enableProximity,
              enableSensor: _enableSensor,
              enableDynamicBorder: _enableDynamicBorder,
              enableSelectionPulse: _enableSelectionPulse,
              selectionPulseColors: laserColors,
              dynamicBorderColors: laserColors,
              labelBehavior: _labelBehavior,
              isFloating: _isFloating,
              activeIndicatorStyle: _indicatorStyle,
              onItemSelected: (index) {
                setState(() => _selectedIndex = index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDockPageContent({
    required AppColorPalette colors,
    required Color activeColor,
    required int index,
  }) {
    switch (index) {
      case 0:
        return _buildHomeDesktopView(colors: colors, activeColor: activeColor);
      case 1:
        return _buildExploreDesktopView(
          colors: colors,
          activeColor: activeColor,
        );
      case 2:
        return _buildFavoritesDesktopView(
          colors: colors,
          activeColor: activeColor,
        );
      case 3:
        return _buildInboxDesktopView(colors: colors, activeColor: activeColor);
      case 4:
      default:
        return _buildProfileDesktopView(
          colors: colors,
          activeColor: activeColor,
        );
    }
  }

  Widget _buildHomeDesktopView({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: activeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.hub_rounded,
                      color: activeColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Spatial Desktop OS',
                          style: AppTextStyle.screenHeader.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'Hover across dock items below to trigger proximity magnification & directional glow.',
                          style: AppTextStyle.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildMetricTile(
                    label: 'CPU LOAD',
                    value: '14.2%',
                    icon: Icons.memory_rounded,
                    colors: colors,
                    accent: activeColor,
                  ),
                  const SizedBox(width: 12),
                  _buildMetricTile(
                    label: 'MEMORY GLASS',
                    value: '3.8 GB',
                    icon: Icons.storage_rounded,
                    colors: colors,
                    accent: activeColor,
                  ),
                  const SizedBox(width: 12),
                  _buildMetricTile(
                    label: 'SENSORS',
                    value: _enableSensor ? '6-AXIS' : 'MUTED',
                    icon: Icons.sensors_rounded,
                    colors: colors,
                    accent: activeColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExploreDesktopView({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
    final apps = [
      (
        'Hologram Viewer',
        Icons.view_in_ar_rounded,
        'Spatial 3D models preview',
      ),
      (
        'Audio Visualizer',
        Icons.graphic_eq_rounded,
        'Realtime FFT frequency glow',
      ),
      (
        'Neural Canvas',
        Icons.draw_rounded,
        'Vector graphics with pointer physics',
      ),
      (
        'Terminal Console',
        Icons.terminal_rounded,
        'Direct kernel diagnostic access',
      ),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Spatial Applications',
                style: AppTextStyle.screenHeader.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Curated spatial runtime utilities optimized for floating navigation.',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ...apps.map(
                (app) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.scaffoldBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: activeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(app.$2, size: 20, color: activeColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.$1,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              app.$3,
                              style: AppTextStyle.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: activeColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesDesktopView({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
    final bookmarks = [
      ('By_UI Design System Core', 'GitHub Repository', Icons.code_rounded),
      (
        'Production Metrics Cluster',
        'Global Telemetry',
        Icons.cloud_done_rounded,
      ),
      ('Design Tokens & Themes', 'Figma Workspace', Icons.palette_rounded),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pinned Favorites',
                style: AppTextStyle.screenHeader.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              ...bookmarks.map(
                (b) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.scaffoldBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(b.$3, size: 22, color: activeColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.$1,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              b.$2,
                              style: AppTextStyle.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.star_rounded, size: 18, color: activeColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInboxDesktopView({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
    final messages = [
      (
        'Deployment Successful',
        'Cluster eu-west-1 updated to v2.4.0',
        '2m ago',
        activeColor,
      ),
      (
        'Dynamic Border Calibration',
        'Traveling circuit synchronized',
        '14m ago',
        activeColor,
      ),
      (
        'Accelerometer Sensor Active',
        'Tilt detection running at 60fps',
        '1h ago',
        activeColor,
      ),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inbox Notifications',
                style: AppTextStyle.screenHeader.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              ...messages.map(
                (m) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.scaffoldBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: m.$4,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.$1,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              m.$2,
                              style: AppTextStyle.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        m.$3,
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDesktopView({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: activeColor.withValues(alpha: 0.2),
                child: Icon(Icons.person_rounded, size: 38, color: activeColor),
              ),
              const SizedBox(height: 12),
              Text(
                'Spatial Architect',
                style: AppTextStyle.screenHeader.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                'lead.architect@by-ui.spatial.os',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.scaffoldBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, size: 16, color: activeColor),
                    const SizedBox(width: 6),
                    Text(
                      'Hardware Sensors Calibrated',
                      style: AppTextStyle.badge.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required AppColorPalette colors,
    required Color accent,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: colors.scaffoldBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: accent),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyle.specHighlight.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: AppTextStyle.caption.copyWith(
                color: colors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
