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

/// Interactive showcase screen for [ByTabBar].
class TabBarShowcaseScreen extends StatefulWidget {
  const TabBarShowcaseScreen({super.key});

  @override
  State<TabBarShowcaseScreen> createState() => _TabBarShowcaseScreenState();
}

class _TabBarShowcaseScreenState extends State<TabBarShowcaseScreen> {
  int _selectedIndex = 0;
  bool _enableLiquid = true;
  bool _enableDynamicBorder = false;
  bool _enableOuterDynamicBorder = false;
  bool _enableSelectionPulse = true;
  bool _showTabIcons = false;
  bool _autoContentColor = true;
  bool _enableHaptics = true;
  bool _isScrollable = false;
  ByTabIndicatorStyle _indicatorStyle = ByTabIndicatorStyle.pill;
  double _underlineHeight = 3.0;
  bool _hasDisabledTab = false;
  double _tabBarHeight = 46.0;
  double _containerRadius = 24.0;
  double _indicatorRadius = 20.0;
  double _outerBorderWidth = 1.0;
  double _containerPadding = 4.0;
  double _liquidStretch = 1.25;
  double _indicatorShadowBlur = 10.0;
  double _dynamicBorderGlowBlur = 6.0;
  double _animationDurationMs = 320.0;
  bool _isMaximized = false;

  int _selectedIndicatorColorIndex = 0;
  int _selectedIndicatorGradientIndex = 0;
  int _selectedBgColorIndex = 0;
  int _selectedLaserGradientIndex = 0;
  int _activePresetIndex = 0;

  static const List<ShowcaseColorOption> _indicatorColorOptions = [
    ShowcaseColorOption('Sky Cyan', AppColors.cyanAccent),
    ShowcaseColorOption('Primary Indigo', AppColors.primary),
    ShowcaseColorOption('Violet Neon', AppColors.primaryAccent),
    ShowcaseColorOption('Electric Blue', Color(0xFF2563EB)),
    ShowcaseColorOption('Emerald Mint', AppColors.success),
    ShowcaseColorOption('Teal Aqua', Color(0xFF14B8A6)),
    ShowcaseColorOption('Amber Sunset', AppColors.warning),
    ShowcaseColorOption('Coral Orange', Color(0xFFFB923C)),
    ShowcaseColorOption('Crimson Passion', AppColors.error),
    ShowcaseColorOption('Rose Pink', Color(0xFFF43F5E)),
    ShowcaseColorOption('Fuchsia Neon', Color(0xFFD946EF)),
    ShowcaseColorOption('Neon Lime', Color(0xFF84CC16)),
    ShowcaseColorOption('Sun Gold', Color(0xFFFACC15)),
    ShowcaseColorOption('Pure White', Colors.white),
  ];

  static const List<ShowcaseThemePreset> _indicatorGradientOptions = [
    ShowcaseThemePreset(
      name: 'None (Solid Color)',
      color: AppColors.cyanAccent,
      colors: null,
    ),
    ShowcaseThemePreset(
      name: 'Cyan to Indigo',
      color: Color(0xFF00F5FF),
      colors: [Color(0xFF00F5FF), Color(0xFF4F46E5)],
      gradient: LinearGradient(colors: [Color(0xFF00F5FF), Color(0xFF4F46E5)]),
    ),
    ShowcaseThemePreset(
      name: 'Neon Violet to Fuchsia',
      color: Color(0xFFA855F7),
      colors: [Color(0xFFA855F7), Color(0xFFEC4899)],
      gradient: LinearGradient(colors: [Color(0xFFA855F7), Color(0xFFEC4899)]),
    ),
    ShowcaseThemePreset(
      name: 'Emerald to Mint',
      color: Color(0xFF10B981),
      colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
      gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF06B6D4)]),
    ),
    ShowcaseThemePreset(
      name: 'Sunset Amber to Coral',
      color: Color(0xFFF59E0B),
      colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      gradient: LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
    ),
    ShowcaseThemePreset(
      name: 'Aurora Borealis',
      color: Color(0xFF38BDF8),
      colors: [Color(0xFF38BDF8), Color(0xFF818CF8), Color(0xFFA855F7)],
      gradient: LinearGradient(
        colors: [Color(0xFF38BDF8), Color(0xFF818CF8), Color(0xFFA855F7)],
      ),
    ),
    ShowcaseThemePreset(
      name: 'Electric Aqua',
      color: Color(0xFF06B6D4),
      colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
      gradient: LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)]),
    ),
    ShowcaseThemePreset(
      name: 'Cosmic Nebula',
      color: Color(0xFFD946EF),
      colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
      gradient: LinearGradient(colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)]),
    ),
  ];

  static const List<ShowcaseThemePreset> _laserColorOptions = [
    ShowcaseThemePreset(
      name: 'Pure White (Default)',
      color: Colors.white,
      accent: Color(0xFFE2E8F0),
      colors: [Colors.white, Color(0xFFE2E8F0)],
      gradient: LinearGradient(
        colors: [Colors.white, Color(0xFFE2E8F0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Cyan & Indigo',
      color: AppColors.cyanAccent,
      accent: AppColors.primary,
      colors: [AppColors.cyanAccent, AppColors.primary],
      gradient: LinearGradient(
        colors: [AppColors.cyanAccent, AppColors.primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Blue & Cyan',
      color: Color(0xFF2563EB),
      accent: Color(0xFF06B6D4),
      colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
      gradient: LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Violet & Pink',
      color: AppColors.primaryAccent,
      accent: Color(0xFFEC4899),
      colors: [AppColors.primaryAccent, Color(0xFFEC4899)],
      gradient: LinearGradient(
        colors: [AppColors.primaryAccent, Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Emerald & Mint',
      color: AppColors.success,
      accent: Color(0xFF14B8A6),
      colors: [AppColors.success, Color(0xFF14B8A6)],
      gradient: LinearGradient(
        colors: [AppColors.success, Color(0xFF14B8A6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Amber & Coral',
      color: AppColors.warning,
      accent: Color(0xFFEF4444),
      colors: [AppColors.warning, Color(0xFFEF4444)],
      gradient: LinearGradient(
        colors: [AppColors.warning, Color(0xFFEF4444)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Aurora Borealis',
      color: Color(0xFF38BDF8),
      accent: Color(0xFFA855F7),
      colors: [Color(0xFF38BDF8), Color(0xFFA855F7)],
      gradient: LinearGradient(
        colors: [Color(0xFF38BDF8), Color(0xFFA855F7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Cyberpunk Neon',
      color: Color(0xFF06B6D4),
      accent: Color(0xFFF43F5E),
      colors: [Color(0xFF06B6D4), Color(0xFFF43F5E)],
      gradient: LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFFF43F5E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  static const List<ShowcaseColorOption> _bgColorOptions = [
    ShowcaseColorOption('Auto (Theme Default)', null),
    ShowcaseColorOption('Dark Slate', AppColors.darkCard),
    ShowcaseColorOption('Deep Navy', AppColors.deepRoyal),
    ShowcaseColorOption('Obsidian', AppColors.obsidianDarkest),
    ShowcaseColorOption('Midnight Blue', Color(0xFF0F172A)),
    ShowcaseColorOption('Deep Sapphire', Color(0xFF172554)),
    ShowcaseColorOption('Dark Emerald', Color(0xFF064E3B)),
    ShowcaseColorOption('Deep Amethyst', Color(0xFF2E1065)),
    ShowcaseColorOption('Dark Burgundy', Color(0xFF4C0519)),
    ShowcaseColorOption('Espresso Charcoal', Color(0xFF1C1917)),
    ShowcaseColorOption('Cloud Gray', Color(0xFFF1F5F9)),
    ShowcaseColorOption('Pure White', Colors.white),
    ShowcaseColorOption('Pure Black', Colors.black),
  ];

  static const List<String> _tabLabels = ['Overview', 'Analytics', 'Settings'];

  static const List<IconData> _tabIcons = [
    Icons.dashboard_rounded,
    Icons.insights_rounded,
    Icons.tune_rounded,
  ];

  static const List<String> _scrollableTabLabels = [
    'Overview',
    'Analytics',
    'Reports',
    'Settings',
    'Activity',
    'Billing',
    'Integrations',
    'Audit Log',
  ];

  static const List<IconData> _scrollableTabIcons = [
    Icons.dashboard_rounded,
    Icons.insights_rounded,
    Icons.insert_chart_outlined_rounded,
    Icons.tune_rounded,
    Icons.notifications_active_rounded,
    Icons.credit_card_rounded,
    Icons.hub_rounded,
    Icons.history_rounded,
  ];

  List<ByTabItem> get _tabs {
    final labels = _isScrollable ? _scrollableTabLabels : _tabLabels;
    final icons = _isScrollable ? _scrollableTabIcons : _tabIcons;
    final disabledIndex = _isScrollable ? 2 : 1;
    return List.generate(
      labels.length,
      (index) => ByTabItem(
        label: labels[index],
        icon: _showTabIcons ? icons[index] : null,
        isDisabled: _hasDisabledTab && index == disabledIndex,
        tooltip: _hasDisabledTab && index == disabledIndex
            ? '${labels[disabledIndex]} tab is disabled'
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        final colors = AppColors.of(context);
        final isDark = AppThemeStore.instance.isDarkMode(context);

        final selectedIndColor =
            _indicatorColorOptions[_selectedIndicatorColorIndex].color ??
            AppColors.cyanAccent;
        final selectedIndicatorGradient =
            _selectedIndicatorGradientIndex > 0 &&
                _selectedIndicatorGradientIndex <
                    _indicatorGradientOptions.length
            ? LinearGradient(
                colors:
                    _indicatorGradientOptions[_selectedIndicatorGradientIndex]
                        .colors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null;
        final selectedBgColor = _bgColorOptions[_selectedBgColorIndex].color;
        final selectedLaserPreset =
            _laserColorOptions[_selectedLaserGradientIndex];

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
                  componentName: 'ByTabBar',
                  titleSuffix: _isMaximized ? 'Live Preview' : 'Showcase',
                  onReset: _isMaximized ? null : _resetToDefaults,
                  onOpenParams: _isMaximized
                      ? null
                      : () => _showParamsDialog(context),
                  onViewCode: () => _showCodeDialog(context),
                  extraActions: _isMaximized
                      ? [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Reset Tab Selection',
                            icon: const Icon(
                              Icons.replay_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                            onPressed: () => setState(() => _selectedIndex = 0),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Minimize Preview',
                            icon: Icon(
                              Icons.fullscreen_exit_rounded,
                              color: colors.textPrimary,
                              size: 22,
                            ),
                            onPressed: () =>
                                setState(() => _isMaximized = false),
                          ),
                        ]
                      : null,
                ),
              ),
              drawer: const ByDrawer(activeComponent: 'ByTabBar'),
              body: _isMaximized
                  ? _buildMaximizedTabBarBody(
                      colors: colors,
                      indicatorColor: selectedIndColor,
                      indicatorGradient: selectedIndicatorGradient,
                      bgColor: selectedBgColor,
                      laserColors:
                          selectedLaserPreset.colors ??
                          const [Colors.white, Color(0xFFE2E8F0)],
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
                          icon: Icons.tab_rounded,
                          subtitle:
                              'Live metrics for ByTabBar configuration state',
                          metrics: [
                            ByMetricBadge(
                              label: 'Tab',
                              value: '${_selectedIndex + 1} OF ${_tabs.length}',
                            ),
                            ByMetricBadge(
                              label: 'Items',
                              value: _showTabIcons ? 'ICONS' : 'TEXT ONLY',
                            ),
                            ByMetricBadge(
                              label: 'Liquid Morph',
                              value: _enableLiquid ? 'ACTIVE' : 'OFF',
                            ),
                            ByMetricBadge(
                              label: 'Stretch',
                              value: '${_liquidStretch.toStringAsFixed(2)}x',
                            ),
                            ByMetricBadge(
                              label: 'Pulse',
                              value: _enableSelectionPulse ? '1x SHOT' : 'OFF',
                            ),
                            ByMetricBadge(
                              label: 'Height',
                              value: '${_tabBarHeight.toInt()}px',
                            ),
                            ByMetricBadge(
                              label: 'Radius',
                              value: '${_containerRadius.toInt()}px',
                            ),
                            ByMetricBadge(
                              label: 'Speed',
                              value: '${_animationDurationMs.toInt()}ms',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── LAYER 2: Preset Example Card ──────────────────────────
                        ByShowcasePresetCard(
                          presets: [
                            ByShowcasePresetItem(
                              label: 'Cyan Glow',
                              themeColor: AppColors.cyanAccent,
                              isSelected: _activePresetIndex == 0,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 0;
                                  _indicatorStyle = ByTabIndicatorStyle.pill;
                                  _isScrollable = false;
                                  _enableLiquid = true;
                                  _enableDynamicBorder = false;
                                  _enableSelectionPulse = true;
                                  _showTabIcons = false;
                                  _tabBarHeight = 46.0;
                                  _containerRadius = 24.0;
                                  _indicatorRadius = 20.0;
                                  _outerBorderWidth = 1.0;
                                  _containerPadding = 4.0;
                                  _liquidStretch = 1.25;
                                  _indicatorShadowBlur = 10.0;
                                  _selectedIndicatorColorIndex = 0;
                                  _selectedIndicatorGradientIndex = 0;
                                  _selectedBgColorIndex = 0;
                                  _selectedLaserGradientIndex = 0;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Gradient Flow',
                              themeColor: const Color(0xFF00F5FF),
                              isSelected: _activePresetIndex == 1,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 1;
                                  _indicatorStyle = ByTabIndicatorStyle.pill;
                                  _isScrollable = false;
                                  _enableLiquid = true;
                                  _enableDynamicBorder = false;
                                  _enableSelectionPulse = true;
                                  _tabBarHeight = 52.0;
                                  _containerRadius = 28.0;
                                  _indicatorRadius = 24.0;
                                  _outerBorderWidth = 1.5;
                                  _containerPadding = 5.0;
                                  _liquidStretch = 1.45;
                                  _indicatorShadowBlur = 16.0;
                                  _selectedIndicatorColorIndex = 0;
                                  _selectedIndicatorGradientIndex = 1;
                                  _selectedBgColorIndex = 0;
                                  _selectedLaserGradientIndex = 1;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Emerald Mint',
                              themeColor: AppColors.success,
                              isSelected: _activePresetIndex == 2,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 2;
                                  _indicatorStyle = ByTabIndicatorStyle.pill;
                                  _isScrollable = false;
                                  _enableLiquid = true;
                                  _enableDynamicBorder = false;
                                  _enableSelectionPulse = true;
                                  _tabBarHeight = 46.0;
                                  _containerRadius = 16.0;
                                  _indicatorRadius = 12.0;
                                  _outerBorderWidth = 1.0;
                                  _containerPadding = 4.0;
                                  _liquidStretch = 1.20;
                                  _indicatorShadowBlur = 10.0;
                                  _selectedIndicatorColorIndex = 3;
                                  _selectedBgColorIndex = 0;
                                  _selectedLaserGradientIndex = 4;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Minimal Clean',
                              themeColor: AppColors.textMuted(isDark),
                              isSelected: _activePresetIndex == 3,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 3;
                                  _indicatorStyle =
                                      ByTabIndicatorStyle.underline;
                                  _isScrollable = false;
                                  _enableLiquid = false;
                                  _enableDynamicBorder = false;
                                  _enableSelectionPulse = false;
                                  _showTabIcons = false;
                                  _tabBarHeight = 42.0;
                                  _containerRadius = 10.0;
                                  _indicatorRadius = 8.0;
                                  _outerBorderWidth = 1.0;
                                  _containerPadding = 3.0;
                                  _liquidStretch = 1.0;
                                  _indicatorShadowBlur = 0.0;
                                  _selectedIndicatorColorIndex = 0;
                                  _selectedBgColorIndex = 0;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── LAYER 3: Cross-Component Integration Banner ───────────
                        const ByShowcaseIntegrationBanner(
                          componentName: 'ByDynamicBorder',
                          description:
                              'ByTabBar integrates ByDynamicBorder for running-light laser borders around the active sliding indicator.',
                        ),
                        const SizedBox(height: 14),

                        // ── LAYER 4: Standalone Widget Display (Hero Live Preview) ─
                        _buildHeroPreview(
                          colors: colors,
                          indicatorColor: selectedIndColor,
                          indicatorGradient: selectedIndicatorGradient,
                          bgColor: selectedBgColor,
                          laserColors:
                              selectedLaserPreset.colors ??
                              const [Colors.white, Color(0xFFE2E8F0)],
                        ),
                        const SizedBox(height: 14),

                        // ── LAYER 5: Numbered Control Cards ───────────────────────
                        ByShowcaseControlCard(
                          title: '1. INDICATOR & MORPHING PHYSICS',
                          icon: Icons.animation_rounded,
                          children: [
                            Text(
                              'Tab Indicator Style:',
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
                                    label: 'Sliding Pill Capsule',
                                    isSelected:
                                        _indicatorStyle ==
                                        ByTabIndicatorStyle.pill,
                                    onTap: () => setState(
                                      () => _indicatorStyle =
                                          ByTabIndicatorStyle.pill,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Bottom Underline Bar',
                                    isSelected:
                                        _indicatorStyle ==
                                        ByTabIndicatorStyle.underline,
                                    onTap: () => setState(
                                      () => _indicatorStyle =
                                          ByTabIndicatorStyle.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ByShowcaseSwitchTile(
                              title: 'Scrollable Tabs Rail (8 Tabs)',
                              subtitle:
                                  'Enables horizontal scrolling physics with auto-centering on selection',
                              value: _isScrollable,
                              onChanged: (val) => setState(() {
                                _isScrollable = val;
                                if (!val && _selectedIndex > 2) {
                                  _selectedIndex = 2;
                                }
                              }),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Simulate Disabled Tab ("Analytics")',
                              subtitle:
                                  'Dims tab opacity and rejects taps with informative tooltip hint',
                              value: _hasDisabledTab,
                              onChanged: (val) => setState(() {
                                _hasDisabledTab = val;
                                final disabledIndex = _isScrollable ? 2 : 1;
                                if (val && _selectedIndex == disabledIndex) {
                                  _selectedIndex = 0;
                                }
                              }),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Show Tab Icons (Mobile-First Text Only)',
                              subtitle:
                                  'Hides leading icons in tab pills for a clean, compact, mobile-friendly layout',
                              value: _showTabIcons,
                              onChanged: (val) =>
                                  setState(() => _showTabIcons = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Selection Dynamic Border Pulse',
                              subtitle:
                                  'Pulses a 3-phase laser border around the selected tab before fading in the static border',
                              value: _enableSelectionPulse,
                              onChanged: (val) =>
                                  setState(() => _enableSelectionPulse = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Liquid Elastic Morphing',
                              subtitle:
                                  'Stretches the sliding indicator pill dynamically between distant tabs',
                              value: _enableLiquid,
                              onChanged: (val) =>
                                  setState(() => _enableLiquid = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Continuous Active Glowing Border',
                              subtitle:
                                  'Constantly loops a neon laser beam along the perimeter of the active pill',
                              value: _enableDynamicBorder,
                              onChanged: (val) =>
                                  setState(() => _enableDynamicBorder = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Outer Capsule Dynamic Border Pulse',
                              subtitle:
                                  'Pulses a running laser beam along the perimeter of the outer tab bar capsule',
                              value: _enableOuterDynamicBorder,
                              onChanged: (val) => setState(
                                () => _enableOuterDynamicBorder = val,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Tactile Haptic Feedback',
                              subtitle:
                                  'Triggers haptic vibration when changing selected tab',
                              value: _enableHaptics,
                              onChanged: (val) =>
                                  setState(() => _enableHaptics = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Liquid Stretch Factor:',
                              valueText:
                                  '${_liquidStretch.toStringAsFixed(2)}x',
                              value: _liquidStretch,
                              min: 1.0,
                              max: 1.5,
                              divisions: 10,
                              onChanged: (val) =>
                                  setState(() => _liquidStretch = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Transition Speed:',
                              valueText: '${_animationDurationMs.toInt()}ms',
                              value: _animationDurationMs,
                              min: 150.0,
                              max: 600.0,
                              divisions: 9,
                              onChanged: (val) =>
                                  setState(() => _animationDurationMs = val),
                            ),
                            if (_indicatorStyle ==
                                ByTabIndicatorStyle.underline) ...[
                              const SizedBox(height: 10),
                              ByShowcaseSliderTile(
                                label: 'Underline Indicator Height:',
                                valueText:
                                    '${_underlineHeight.toStringAsFixed(1)}px',
                                value: _underlineHeight,
                                min: 1.0,
                                max: 6.0,
                                divisions: 10,
                                onChanged: (val) =>
                                    setState(() => _underlineHeight = val),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '2. GEOMETRY & SIZING',
                          icon: Icons.straighten_rounded,
                          children: [
                            ByShowcaseSliderTile(
                              label: 'Bar Height:',
                              valueText: '${_tabBarHeight.toInt()}px',
                              value: _tabBarHeight,
                              min: 38.0,
                              max: 60.0,
                              divisions: 22,
                              onChanged: (val) =>
                                  setState(() => _tabBarHeight = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Container Corner Radius:',
                              valueText: '${_containerRadius.toInt()}px',
                              value: _containerRadius,
                              min: 0.0,
                              max: 32.0,
                              divisions: 32,
                              onChanged: (val) =>
                                  setState(() => _containerRadius = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Indicator Corner Radius:',
                              valueText: '${_indicatorRadius.toInt()}px',
                              value: _indicatorRadius,
                              min: 0.0,
                              max: 32.0,
                              divisions: 32,
                              onChanged: (val) =>
                                  setState(() => _indicatorRadius = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Container Padding:',
                              valueText: '${_containerPadding.toInt()}px',
                              value: _containerPadding,
                              min: 2.0,
                              max: 10.0,
                              divisions: 8,
                              onChanged: (val) =>
                                  setState(() => _containerPadding = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Outer Border Width:',
                              valueText:
                                  '${_outerBorderWidth.toStringAsFixed(1)}px',
                              value: _outerBorderWidth,
                              min: 0.0,
                              max: 3.0,
                              divisions: 6,
                              onChanged: (val) =>
                                  setState(() => _outerBorderWidth = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '3. COLOR PALETTES & SURFACES',
                          icon: Icons.palette_rounded,
                          children: [
                            Text(
                              'Sliding Indicator Color:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromOptions(
                              options: _indicatorColorOptions,
                              selectedIndex: _selectedIndicatorColorIndex,
                              onSelected: (idx) => setState(
                                () => _selectedIndicatorColorIndex = idx,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Sliding Indicator Gradient (Optional):',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromPresets(
                              presets: _indicatorGradientOptions,
                              selectedIndex: _selectedIndicatorGradientIndex,
                              onSelected: (idx) => setState(
                                () => _selectedIndicatorGradientIndex = idx,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Outer Container Surface Color:',
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
                              'Active Dynamic Laser Beam Colors:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromPresets(
                              presets: _laserColorOptions,
                              selectedIndex: _selectedLaserGradientIndex,
                              onSelected: (idx) => setState(
                                () => _selectedLaserGradientIndex = idx,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ByShowcaseSwitchTile(
                              title: 'Intelligent Auto-Contrast Content',
                              subtitle:
                                  'Adapts tab label & icon contrast automatically when using bright/white indicator pills',
                              value: _autoContentColor,
                              onChanged: (val) =>
                                  setState(() => _autoContentColor = val),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '4. INDICATOR SHADOW & GLOW',
                          icon: Icons.blur_on_rounded,
                          children: [
                            ByShowcaseSliderTile(
                              label: 'Indicator Shadow Blur:',
                              valueText: '${_indicatorShadowBlur.toInt()}px',
                              value: _indicatorShadowBlur,
                              min: 0.0,
                              max: 25.0,
                              divisions: 25,
                              onChanged: (val) =>
                                  setState(() => _indicatorShadowBlur = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Dynamic Border Glow Blur:',
                              valueText: '${_dynamicBorderGlowBlur.toInt()}px',
                              value: _dynamicBorderGlowBlur,
                              min: 2.0,
                              max: 16.0,
                              divisions: 14,
                              onChanged: (val) =>
                                  setState(() => _dynamicBorderGlowBlur = val),
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
      _isScrollable = false;
      _indicatorStyle = ByTabIndicatorStyle.pill;
      _underlineHeight = 3.0;
      _hasDisabledTab = false;
      _enableLiquid = true;
      _enableDynamicBorder = false;
      _enableOuterDynamicBorder = false;
      _enableSelectionPulse = true;
      _showTabIcons = false;
      _enableHaptics = true;
      _tabBarHeight = 46.0;
      _containerRadius = 24.0;
      _indicatorRadius = 20.0;
      _outerBorderWidth = 1.0;
      _containerPadding = 4.0;
      _liquidStretch = 1.25;
      _indicatorShadowBlur = 10.0;
      _dynamicBorderGlowBlur = 6.0;
      _selectedIndicatorColorIndex = 0;
      _selectedIndicatorGradientIndex = 0;
      _selectedBgColorIndex = 0;
      _selectedLaserGradientIndex = 0;
      _activePresetIndex = 0;
      _autoContentColor = true;
    });
  }

  // ── CODE SNIPPET GENERATOR ──────────────────────────────────────────────
  String _generateCodeSnippet() {
    final buffer = StringBuffer();
    buffer.writeln('ByTabBar(');
    buffer.writeln('  selectedIndex: _selectedIndex,');
    buffer.writeln(
      '  onTabChanged: (index) => setState(() => _selectedIndex = index),',
    );
    buffer.writeln('  tabs: const [');
    buffer.writeln(
      "    ByTabItem(label: 'Overview', icon: Icons.dashboard_rounded),",
    );
    buffer.writeln(
      "    ByTabItem(label: 'Analytics', icon: Icons.analytics_rounded, badge: 'HOT'),",
    );
    buffer.writeln(
      "    ByTabItem(label: 'Settings', icon: Icons.settings_rounded),",
    );
    buffer.writeln('  ],');
    buffer.writeln('  indicatorStyle: $_indicatorStyle,');
    if (_isScrollable) {
      buffer.writeln('  isScrollable: true,');
    }
    buffer.writeln('  height: ${_tabBarHeight.toStringAsFixed(1)},');
    buffer.writeln(
      '  borderRadius: BorderRadius.circular(${_containerRadius.toInt()}),',
    );
    buffer.writeln(
      '  indicatorBorderRadius: BorderRadius.circular(${_indicatorRadius.toInt()}),',
    );
    buffer.writeln(
      '  padding: const EdgeInsets.all(${_containerPadding.toStringAsFixed(1)}),',
    );
    buffer.writeln('  borderWidth: ${_outerBorderWidth.toStringAsFixed(1)},');
    if (_enableLiquid) {
      buffer.writeln('  enableLiquidMorphing: true,');
      buffer.writeln(
        '  liquidStretchFactor: ${_liquidStretch.toStringAsFixed(2)},',
      );
    }
    if (_enableSelectionPulse) {
      buffer.writeln('  enableSelectionPulse: true,');
    }
    if (_enableDynamicBorder) {
      buffer.writeln('  enableDynamicBorder: true,');
    }
    if (_enableOuterDynamicBorder) {
      buffer.writeln('  enableOuterDynamicBorder: true,');
    }
    buffer.writeln('  indicatorColor: const Color(0xFF00F5FF),');
    buffer.writeln(
      '  animationDuration: const Duration(milliseconds: ${_animationDurationMs.toInt()}),',
    );
    buffer.write(')');
    return buffer.toString();
  }

  void _showCodeDialog(BuildContext context) {
    showByCodeDialog(
      context,
      componentName: 'ByTabBar',
      code: _generateCodeSnippet(),
    );
  }

  void _showParamsDialog(BuildContext context) {
    showWidgetParametersDialog(
      context,
      howToTry:
          'Tap any tab in the hero preview to observe the liquid mercury stretching and flowing glowing border animation.',
      howToTryIcon: AppIcons.touch,
      parameters: const [
        WidgetParamInfo(
          name: 'isScrollable',
          type: 'bool',
          description:
              'Enables horizontal scroll physics with auto-scroll centering and edge fade gradients.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'indicatorStyle',
          type: 'ByTabIndicatorStyle',
          description:
              'Indicator highlight mode (pill sliding capsule or underline bar).',
          defaultValue: 'ByTabIndicatorStyle.pill',
        ),
        WidgetParamInfo(
          name: 'underlineHeight',
          type: 'double',
          description:
              'Thickness of the underline indicator bar when using underline style.',
          defaultValue: '3.0',
        ),
        WidgetParamInfo(
          name: 'showScrollGradients',
          type: 'bool',
          description:
              'Whether edge overflow fade gradients are shown when isScrollable is true.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'tabs',
          type: 'List<ByTabItem>',
          description:
              'The collection of tabs with labels, icons, and optional badges.',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'selectedIndex',
          type: 'int',
          description: 'The currently active tab index (0-indexed).',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'enableLiquidMorphing',
          type: 'bool',
          description:
              'Enables elastic stretching physics on the sliding indicator.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'liquidStretchFactor',
          type: 'double',
          description:
              'Maximum width multiplier reached during elastic morphing.',
          defaultValue: '1.25',
        ),
        WidgetParamInfo(
          name: 'enableDynamicBorder',
          type: 'bool',
          description:
              'Renders a traveling dynamic laser border around the active pill.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'height',
          type: 'double',
          description: 'Total vertical height of the segmented bar.',
          defaultValue: '46.0',
        ),
        WidgetParamInfo(
          name: 'borderWidth',
          type: 'double',
          description: 'Outer stroke width of the segmented bar capsule.',
          defaultValue: '1.0',
        ),
        WidgetParamInfo(
          name: 'indicatorBorderRadius',
          type: 'BorderRadius?',
          description:
              'Independent curvature geometry for the sliding indicator pill.',
          defaultValue: 'null (matches container)',
        ),
        WidgetParamInfo(
          name: 'indicatorShadowBlur',
          type: 'double?',
          description: 'Blur radius for the ambient indicator glow shadow.',
          defaultValue: '10.0',
        ),
        WidgetParamInfo(
          name: 'animationDuration',
          type: 'Duration',
          description: 'Transition duration when moving between tabs.',
          defaultValue: '320ms',
        ),
        WidgetParamInfo(
          name: 'animationCurve',
          type: 'Curve',
          description:
              'Kinematic easing curve for fluid indicator transitions.',
          defaultValue: 'Curves.easeOutCubic',
        ),
        WidgetParamInfo(
          name: 'enableColorTransition',
          type: 'bool',
          description:
              'Interpolates tab label and icon colors in sync with indicator overlap.',
          defaultValue: 'true',
        ),
      ],
    );
  }

  Widget _buildHeroPreview({
    required AppColorPalette colors,
    required Color indicatorColor,
    Gradient? indicatorGradient,
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.touch_app_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'INTERACTIVE PREVIEW',
                        style: AppTextStyle.sectionHeader.copyWith(
                          color: colors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Maximize Preview',
                    icon: const Icon(
                      Icons.fullscreen_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    onPressed: () => setState(() => _isMaximized = true),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ByTabBar(
                tabs: _tabs,
                selectedIndex: _selectedIndex,
                height: _tabBarHeight,
                backgroundColor: bgColor,
                indicatorColor: indicatorColor,
                indicatorGradient: indicatorGradient,
                borderRadius: BorderRadius.circular(_containerRadius),
                indicatorBorderRadius: BorderRadius.circular(_indicatorRadius),
                borderWidth: _outerBorderWidth,
                padding: EdgeInsets.all(_containerPadding),
                enableLiquidMorphing: _enableLiquid,
                liquidStretchFactor: _liquidStretch,
                enableDynamicBorder: _enableDynamicBorder,
                enableOuterDynamicBorder: _enableOuterDynamicBorder,
                dynamicBorderColors: laserColors,
                dynamicBorderGlowBlur: _dynamicBorderGlowBlur,
                enableSelectionPulse: _enableSelectionPulse,
                selectionPulseColors: laserColors,
                autoContentColor: _autoContentColor,
                indicatorShadowBlur: _indicatorShadowBlur,
                enableHapticFeedback: _enableHaptics,
                isScrollable: _isScrollable,
                indicatorStyle: _indicatorStyle,
                underlineHeight: _underlineHeight,
                animationDuration: Duration(
                  milliseconds: _animationDurationMs.toInt(),
                ),
                onTabChanged: (index) {
                  setState(() => _selectedIndex = index);
                },
              ),
              const SizedBox(height: 18),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          final activeLabels = _isScrollable
                              ? _scrollableTabLabels
                              : _tabLabels;
                          final activeIcons = _isScrollable
                              ? _scrollableTabIcons
                              : _tabIcons;
                          final safeIndex = _selectedIndex.clamp(
                            0,
                            activeLabels.length - 1,
                          );
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                activeIcons[safeIndex],
                                color: indicatorColor,
                                size: 28,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Active Tab: ${activeLabels[safeIndex]}',
                                style: AppTextStyle.body.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Full-Screen Live Preview Workspace Body ────────────────────────────────
  Widget _buildMaximizedTabBarBody({
    required AppColorPalette colors,
    required Color indicatorColor,
    Gradient? indicatorGradient,
    required Color? bgColor,
    required List<Color> laserColors,
  }) {
    final topPadding = ByAppBar.getContentTopPadding(context, extra: 10);

    return Column(
      children: [
        SizedBox(height: topPadding),
        // ── Sticky Centered Segmented Tab Bar ──────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: ByTabBar(
                tabs: _tabs,
                selectedIndex: _selectedIndex,
                height: _tabBarHeight,
                backgroundColor: bgColor,
                indicatorColor: indicatorColor,
                indicatorGradient: indicatorGradient,
                borderRadius: BorderRadius.circular(_containerRadius),
                indicatorBorderRadius: BorderRadius.circular(_indicatorRadius),
                borderWidth: _outerBorderWidth,
                padding: EdgeInsets.all(_containerPadding),
                enableLiquidMorphing: _enableLiquid,
                liquidStretchFactor: _liquidStretch,
                enableDynamicBorder: _enableDynamicBorder,
                enableOuterDynamicBorder: _enableOuterDynamicBorder,
                dynamicBorderColors: laserColors,
                dynamicBorderGlowBlur: _dynamicBorderGlowBlur,
                enableSelectionPulse: _enableSelectionPulse,
                selectionPulseColors: laserColors,
                autoContentColor: _autoContentColor,
                indicatorShadowBlur: _indicatorShadowBlur,
                enableHapticFeedback: _enableHaptics,
                isScrollable: _isScrollable,
                indicatorStyle: _indicatorStyle,
                underlineHeight: _underlineHeight,
                animationDuration: Duration(
                  milliseconds: _animationDurationMs.toInt(),
                ),
                onTabChanged: (index) {
                  setState(() => _selectedIndex = index);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ── Animated Tab Content Viewport ───────────────────────────────
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey<int>(_selectedIndex),
              child: _buildTabContent(colors, indicatorColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(AppColorPalette colors, Color indicatorColor) {
    if (_isScrollable) {
      switch (_selectedIndex) {
        case 0:
          return _buildOverviewTab(colors, indicatorColor);
        case 1:
          return _buildAnalyticsTab(colors, indicatorColor);
        case 2:
          return _buildReportsTab(colors, indicatorColor);
        case 3:
        default:
          return _buildSettingsTab(colors, indicatorColor);
      }
    } else {
      switch (_selectedIndex) {
        case 0:
          return _buildOverviewTab(colors, indicatorColor);
        case 1:
          return _buildAnalyticsTab(colors, indicatorColor);
        case 2:
        default:
          return _buildSettingsTab(colors, indicatorColor);
      }
    }
  }

  Widget _buildOverviewTab(AppColorPalette colors, Color indicatorColor) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
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
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: indicatorColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.dashboard_rounded, color: indicatorColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nexus Command Overview',
                          style: AppTextStyle.body.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Real-time core node telemetry and active stream status',
                          style: AppTextStyle.caption.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewTile(
                      colors: colors,
                      label: 'Node Health',
                      value: '99.98%',
                      badge: 'NOMINAL',
                      badgeColor: indicatorColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildOverviewTile(
                      colors: colors,
                      label: 'Bandwidth',
                      value: '42.8 GB/s',
                      badge: '+8.4%',
                      badgeColor: indicatorColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTile({
    required AppColorPalette colors,
    required String label,
    required String value,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyle.caption.copyWith(color: colors.textMuted),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyle.body.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(AppColorPalette colors, Color indicatorColor) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
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
                'Throughput Telemetry Breakdown',
                style: AppTextStyle.body.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final heights = [40.0, 75.0, 50.0, 95.0, 60.0, 85.0, 110.0];
                  final isLast = i == 6;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          Container(
                            height: heights[i],
                            decoration: BoxDecoration(
                              color: isLast
                                  ? indicatorColor
                                  : indicatorColor.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'T-${7 - i}d',
                            style: AppTextStyle.caption.copyWith(
                              color: colors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportsTab(AppColorPalette colors, Color indicatorColor) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
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
                'Audit & Compliance Archives',
                style: AppTextStyle.body.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 14),
              _buildReportRow(
                colors,
                'Q4 Spatial Security Ledger',
                'PDF • 4.2 MB',
                indicatorColor,
              ),
              Divider(color: colors.borderSubtle, height: 16),
              _buildReportRow(
                colors,
                'Cluster Load & Resource Audit',
                'CSV • 1.8 MB',
                indicatorColor,
              ),
              Divider(color: colors.borderSubtle, height: 16),
              _buildReportRow(
                colors,
                'SLA Performance Certificate',
                'PDF • 840 KB',
                indicatorColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportRow(
    AppColorPalette colors,
    String title,
    String meta,
    Color accentColor,
  ) {
    return Row(
      children: [
        Icon(Icons.description_rounded, color: accentColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.body.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                meta,
                style: AppTextStyle.caption.copyWith(color: colors.textMuted),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.download_rounded, color: accentColor, size: 18),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSettingsTab(AppColorPalette colors, Color indicatorColor) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
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
                'Cluster Node Preferences',
                style: AppTextStyle.body.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Continuous Sensor Polling',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Allows real-time hardware telemetry updates',
                          style: AppTextStyle.caption.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: true,
                    activeTrackColor: indicatorColor,
                    thumbColor: const WidgetStatePropertyAll<Color>(
                      Colors.white,
                    ),
                    onChanged: (_) {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
