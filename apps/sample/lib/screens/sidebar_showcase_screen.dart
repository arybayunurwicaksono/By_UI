import 'dart:math' as math;
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

/// Interactive showcase screen for [BySidebar].
class SidebarShowcaseScreen extends StatefulWidget {
  const SidebarShowcaseScreen({super.key});

  @override
  State<SidebarShowcaseScreen> createState() => _SidebarShowcaseScreenState();
}

class _SidebarShowcaseScreenState extends State<SidebarShowcaseScreen> {
  int _selectedIndex = 1;
  bool _isCollapsed = false;
  BySidebarPosition _sidebarPosition = BySidebarPosition.left;
  bool _enableSpotlight = true;
  bool _enableBorderTrack = true;
  BySidebarTogglePlacement _togglePlacement = BySidebarTogglePlacement.bottom;
  bool _enableSwipeGesture = true;
  bool _enableHoverExpand = false;
  bool _isHoverExpanded = false;
  BySidebarIndicatorStyle _indicatorStyle = BySidebarIndicatorStyle.fill;

  // Geometry
  double _expandedWidth = 240.0;
  double _collapsedWidth = 72.0;
  double _itemRadius = 10.0;
  double _itemSpacing = 6.0;
  double _borderWidth = 1.0;

  // Spatial lighting
  double _spotlightRadius = 120.0;
  double _cursorGlowHeight = 100.0;

  int _selectedActiveColorIndex = 0;
  int _selectedBgColorIndex = 0;
  int _selectedBorderColorIndex = 0;
  int _activePresetIndex = 0;
  bool _isMaximized = false;

  static const List<ShowcaseColorOption> _activeColorOptions = [
    ShowcaseColorOption('Primary Indigo', AppColors.primary),
    ShowcaseColorOption('Violet Neon', AppColors.primaryAccent),
    ShowcaseColorOption('Sky Cyan', AppColors.cyanAccent),
    ShowcaseColorOption('Emerald Mint', AppColors.success),
    ShowcaseColorOption('Amber Sunset', AppColors.warning),
    ShowcaseColorOption('Crimson Passion', AppColors.error),
    ShowcaseColorOption('Electric Blue', Color(0xFF2563EB)),
    ShowcaseColorOption('Rose Pink', Color(0xFFF43F5E)),
    ShowcaseColorOption('Neon Lime', Color(0xFF84CC16)),
    ShowcaseColorOption('Coral Orange', Color(0xFFFB923C)),
    ShowcaseColorOption('Fuchsia Neon', Color(0xFFD946EF)),
    ShowcaseColorOption('Gold Sun', Color(0xFFFACC15)),
  ];

  static const List<ShowcaseColorOption> _bgColorOptions = [
    ShowcaseColorOption('Auto (Theme Default)', null),
    ShowcaseColorOption('Dark Slate', AppColors.darkCard),
    ShowcaseColorOption('Obsidian', AppColors.obsidianDarkest),
    ShowcaseColorOption('Deep Navy', AppColors.deepRoyal),
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

  static const List<ShowcaseColorOption> _borderColorOptions = [
    ShowcaseColorOption('Auto (Theme Border)', null),
    ShowcaseColorOption('Subtle Slate', AppColors.darkBorderSubtle),
    ShowcaseColorOption('Primary Indigo', AppColors.primary),
    ShowcaseColorOption('Sky Cyan', AppColors.cyanAccent),
    ShowcaseColorOption('Transparent', Colors.transparent),
  ];

  final List<BySidebarItem> _sidebarItems = const [
    BySidebarItem.section('MAIN MENU'),
    BySidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    BySidebarItem(
      icon: Icons.analytics_rounded,
      label: 'Analytics',
      badge: 'PRO',
    ),
    BySidebarItem(icon: Icons.folder_rounded, label: 'Projects'),
    BySidebarItem.section('PREFERENCES'),
    BySidebarItem(
      icon: Icons.chat_bubble_outline_rounded,
      label: 'Messages',
      badge: '3',
    ),
    BySidebarItem(
      icon: Icons.settings_rounded,
      label: 'Settings',
      trailing: Text('⌘S', style: TextStyle(fontSize: 10, color: Colors.grey)),
    ),
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
            AppColors.primary;
        final selectedBgCol = _bgColorOptions[_selectedBgColorIndex].color;
        final selectedBorderCol =
            _borderColorOptions[_selectedBorderColorIndex].color;

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
                  componentName: 'BySidebar',
                  titleSuffix: _isMaximized ? 'Live Preview' : 'Showcase',
                  extraActions: _isMaximized
                      ? [
                          if (!_enableHoverExpand)
                            IconButton(
                              icon: Icon(
                                _isCollapsed
                                    ? Icons.chevron_right_rounded
                                    : Icons.chevron_left_rounded,
                              ),
                              tooltip: _isCollapsed
                                  ? 'Expand Sidebar'
                                  : 'Collapse Sidebar',
                              onPressed: () =>
                                  setState(() => _isCollapsed = !_isCollapsed),
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
              drawer: const ByDrawer(activeComponent: 'BySidebar'),
              body: _isMaximized
                  ? _buildMaximizedSidebarBody(
                      context: context,
                      colors: colors,
                      isDark: isDark,
                      activeColor: selectedActiveCol,
                      bgColor: selectedBgCol,
                      borderColor: selectedBorderCol,
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
                          icon: Icons.view_sidebar_rounded,
                          subtitle:
                              'Live metrics for BySidebar configuration state',
                          metrics: [
                            ByMetricBadge(
                              label: 'Layout',
                              value:
                                  (_enableHoverExpand
                                      ? _isHoverExpanded
                                      : !_isCollapsed)
                                  ? 'EXPANDED'
                                  : 'COLLAPSED',
                            ),
                            ByMetricBadge(
                              label: 'Width',
                              value:
                                  '${((_enableHoverExpand ? _isHoverExpanded : !_isCollapsed) ? _expandedWidth : _collapsedWidth).toInt()}px',
                            ),
                            ByMetricBadge(
                              label: 'Item Radius',
                              value: '${_itemRadius.toInt()}px',
                            ),
                            ByMetricBadge(
                              label: 'Spotlight',
                              value: _enableSpotlight
                                  ? '${_spotlightRadius.toInt()}px'
                                  : 'OFF',
                            ),
                            ByMetricBadge(
                              label: 'Toggle UI',
                              value: _togglePlacement.name.toUpperCase(),
                            ),
                            ByMetricBadge(
                              label: 'Route',
                              value: _sidebarItems[_selectedIndex].label
                                  .toUpperCase(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── LAYER 2: Preset Example Card ──────────────────────────
                        ByShowcasePresetCard(
                          presets: [
                            ByShowcasePresetItem(
                              label: 'Expanded Desktop',
                              themeColor: AppColors.primary,
                              isSelected: _activePresetIndex == 0,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 0;
                                  _isCollapsed = false;
                                  _indicatorStyle =
                                      BySidebarIndicatorStyle.fill;
                                  _enableSpotlight = true;
                                  _enableBorderTrack = true;
                                  _expandedWidth = 240.0;
                                  _collapsedWidth = 72.0;
                                  _itemRadius = 10.0;
                                  _itemSpacing = 6.0;
                                  _spotlightRadius = 120.0;
                                  _cursorGlowHeight = 100.0;
                                  _selectedActiveColorIndex = 0;
                                  _selectedBgColorIndex = 0;
                                  _selectedBorderColorIndex = 0;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Compact Tablet',
                              themeColor: AppColors.primaryAccent,
                              isSelected: _activePresetIndex == 1,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 1;
                                  _isCollapsed = true;
                                  _indicatorStyle =
                                      BySidebarIndicatorStyle.leadingBar;
                                  _enableSpotlight = true;
                                  _enableBorderTrack = true;
                                  _expandedWidth = 240.0;
                                  _collapsedWidth = 72.0;
                                  _itemRadius = 12.0;
                                  _itemSpacing = 8.0;
                                  _spotlightRadius = 90.0;
                                  _cursorGlowHeight = 80.0;
                                  _selectedActiveColorIndex = 1;
                                  _selectedBgColorIndex = 0;
                                  _selectedBorderColorIndex = 0;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Emerald Modern',
                              themeColor: AppColors.success,
                              isSelected: _activePresetIndex == 2,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 2;
                                  _isCollapsed = false;
                                  _indicatorStyle =
                                      BySidebarIndicatorStyle.outline;
                                  _enableSpotlight = true;
                                  _enableBorderTrack = true;
                                  _expandedWidth = 260.0;
                                  _itemRadius = 14.0;
                                  _itemSpacing = 6.0;
                                  _spotlightRadius = 140.0;
                                  _cursorGlowHeight = 120.0;
                                  _selectedActiveColorIndex = 3;
                                  _selectedBgColorIndex = 0;
                                  _selectedBorderColorIndex = 0;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Static Clean',
                              themeColor: AppColors.textMuted(isDark),
                              isSelected: _activePresetIndex == 3,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 3;
                                  _isCollapsed = false;
                                  _indicatorStyle =
                                      BySidebarIndicatorStyle.fill;
                                  _enableSpotlight = false;
                                  _enableBorderTrack = false;
                                  _expandedWidth = 220.0;
                                  _itemRadius = 8.0;
                                  _itemSpacing = 4.0;
                                  _selectedActiveColorIndex = 0;
                                  _selectedBgColorIndex = 0;
                                  _selectedBorderColorIndex = 0;
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
                              'BySidebar features real-time cursor proximity illuminated borders and spotlight ambient backlight spill.',
                        ),
                        const SizedBox(height: 14),

                        // ── LAYER 4: Standalone Widget Display (Hero Live Preview) ─
                        _buildHeroPreview(
                          colors: colors,
                          activeColor: selectedActiveCol,
                          bgColor: selectedBgCol,
                          borderColor: selectedBorderCol,
                        ),
                        const SizedBox(height: 14),

                        // ── LAYER 5: Numbered Control Cards ───────────────────────
                        ByShowcaseControlCard(
                          title: '1. EXPAND / COLLAPSE & INTERACTION UX',
                          icon: Icons.unfold_more_rounded,
                          children: [
                            ByShowcaseSwitchTile(
                              title: 'Collapsed (Icon-Only) Mode',
                              subtitle:
                                  'Toggles between expanded label navigation and compact icon bar',
                              value: _isCollapsed,
                              onChanged: (val) =>
                                  setState(() => _isCollapsed = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Hover Auto-Expand Preview',
                              subtitle:
                                  'Defaults to collapsed and expands when cursor hovers over rail',
                              value: _enableHoverExpand,
                              onChanged: (val) {
                                setState(() {
                                  _enableHoverExpand = val;
                                  if (val) {
                                    _isCollapsed = true;
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Horizontal Drag / Swipe Gesture',
                              subtitle:
                                  'Swipe outward to expand or inward to collapse seamlessly',
                              value: _enableSwipeGesture,
                              onChanged: (val) =>
                                  setState(() => _enableSwipeGesture = val),
                            ),
                            if (!_enableHoverExpand) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Toggle Control Placement:',
                                style: AppTextStyle.fieldLabel.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ByShowcaseChoiceChip(
                                    label: 'Bottom Action Tile',
                                    isSelected:
                                        _togglePlacement ==
                                        BySidebarTogglePlacement.bottom,
                                    onTap: () => setState(
                                      () => _togglePlacement =
                                          BySidebarTogglePlacement.bottom,
                                    ),
                                  ),
                                  ByShowcaseChoiceChip(
                                    label: 'Header Slot',
                                    isSelected:
                                        _togglePlacement ==
                                        BySidebarTogglePlacement.header,
                                    onTap: () => setState(
                                      () => _togglePlacement =
                                          BySidebarTogglePlacement.header,
                                    ),
                                  ),
                                  ByShowcaseChoiceChip(
                                    label: 'None (External)',
                                    isSelected:
                                        _togglePlacement ==
                                        BySidebarTogglePlacement.none,
                                    onTap: () => setState(
                                      () => _togglePlacement =
                                          BySidebarTogglePlacement.none,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
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
                                    label: 'Full Fill (Default)',
                                    isSelected:
                                        _indicatorStyle ==
                                        BySidebarIndicatorStyle.fill,
                                    onTap: () => setState(
                                      () => _indicatorStyle =
                                          BySidebarIndicatorStyle.fill,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Leading Accent Bar',
                                    isSelected:
                                        _indicatorStyle ==
                                        BySidebarIndicatorStyle.leadingBar,
                                    onTap: () => setState(
                                      () => _indicatorStyle =
                                          BySidebarIndicatorStyle.leadingBar,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Subtle Outline',
                                    isSelected:
                                        _indicatorStyle ==
                                        BySidebarIndicatorStyle.outline,
                                    onTap: () => setState(
                                      () => _indicatorStyle =
                                          BySidebarIndicatorStyle.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '2. SPATIAL LIGHTING & TRACKING',
                          icon: Icons.lightbulb_rounded,
                          children: [
                            ByShowcaseSwitchTile(
                              title: 'Spotlight Ambient Backlight Spill',
                              subtitle:
                                  'Casts a soft radial gradient glow behind hovered and active items',
                              value: _enableSpotlight,
                              onChanged: (val) =>
                                  setState(() => _enableSpotlight = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Cursor Proximity Trailing Border',
                              subtitle:
                                  'Illuminates the vertical dividing line dynamically near cursor coordinates',
                              value: _enableBorderTrack,
                              onChanged: (val) =>
                                  setState(() => _enableBorderTrack = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '3. SIDEBAR & ITEM GEOMETRY',
                          icon: Icons.straighten_rounded,
                          children: [
                            Text(
                              'Sidebar Dock Placement:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _sidebarPosition =
                                          BySidebarPosition.left,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            _sidebarPosition ==
                                                BySidebarPosition.left
                                            ? selectedActiveCol.withValues(
                                                alpha: 0.18,
                                              )
                                            : colors.cardBg,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:
                                              _sidebarPosition ==
                                                  BySidebarPosition.left
                                              ? selectedActiveCol
                                              : colors.border,
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.dock_rounded,
                                              size: 16,
                                              color:
                                                  _sidebarPosition ==
                                                      BySidebarPosition.left
                                                  ? selectedActiveCol
                                                  : colors.textSecondary,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Left Edge',
                                              style: AppTextStyle.captionBold
                                                  .copyWith(
                                                    color:
                                                        _sidebarPosition ==
                                                            BySidebarPosition
                                                                .left
                                                        ? selectedActiveCol
                                                        : colors.textPrimary,
                                                    fontWeight:
                                                        _sidebarPosition ==
                                                            BySidebarPosition
                                                                .left
                                                        ? FontWeight.w700
                                                        : FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _sidebarPosition =
                                          BySidebarPosition.right,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            _sidebarPosition ==
                                                BySidebarPosition.right
                                            ? selectedActiveCol.withValues(
                                                alpha: 0.18,
                                              )
                                            : colors.cardBg,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:
                                              _sidebarPosition ==
                                                  BySidebarPosition.right
                                              ? selectedActiveCol
                                              : colors.border,
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.dock_rounded,
                                              size: 16,
                                              color:
                                                  _sidebarPosition ==
                                                      BySidebarPosition.right
                                                  ? selectedActiveCol
                                                  : colors.textSecondary,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Right Edge',
                                              style: AppTextStyle.captionBold
                                                  .copyWith(
                                                    color:
                                                        _sidebarPosition ==
                                                            BySidebarPosition
                                                                .right
                                                        ? selectedActiveCol
                                                        : colors.textPrimary,
                                                    fontWeight:
                                                        _sidebarPosition ==
                                                            BySidebarPosition
                                                                .right
                                                        ? FontWeight.w700
                                                        : FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ByShowcaseSliderTile(
                              label: 'Expanded Width:',
                              valueText: '${_expandedWidth.toInt()}px',
                              value: _expandedWidth,
                              min: 180.0,
                              max: 300.0,
                              divisions: 24,
                              onChanged: (val) =>
                                  setState(() => _expandedWidth = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Collapsed Width:',
                              valueText: '${_collapsedWidth.toInt()}px',
                              value: _collapsedWidth,
                              min: 56.0,
                              max: 88.0,
                              divisions: 16,
                              onChanged: (val) =>
                                  setState(() => _collapsedWidth = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Item Corner Radius:',
                              valueText: '${_itemRadius.toInt()}px',
                              value: _itemRadius,
                              min: 0.0,
                              max: 20.0,
                              divisions: 20,
                              onChanged: (val) =>
                                  setState(() => _itemRadius = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Item Vertical Spacing:',
                              valueText: '${_itemSpacing.toInt()}px',
                              value: _itemSpacing,
                              min: 2.0,
                              max: 14.0,
                              divisions: 12,
                              onChanged: (val) =>
                                  setState(() => _itemSpacing = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Trailing Border Width:',
                              valueText: '${_borderWidth.toStringAsFixed(1)}px',
                              value: _borderWidth,
                              min: 0.5,
                              max: 3.0,
                              divisions: 5,
                              onChanged: (val) =>
                                  setState(() => _borderWidth = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '4. COLOR PALETTES & SURFACES',
                          icon: Icons.palette_rounded,
                          children: [
                            Text(
                              'Active Route Accent Color:',
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
                              'Sidebar Surface Background Color:',
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
                              'Trailing Dividing Border Color:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromOptions(
                              options: _borderColorOptions,
                              selectedIndex: _selectedBorderColorIndex,
                              onSelected: (idx) => setState(
                                () => _selectedBorderColorIndex = idx,
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '5. SPATIAL LIGHTING ADJUSTMENTS',
                          icon: Icons.blur_on_rounded,
                          children: [
                            ByShowcaseSliderTile(
                              label: 'Spotlight Spill Radius:',
                              valueText: '${_spotlightRadius.toInt()}px',
                              value: _spotlightRadius,
                              min: 60.0,
                              max: 220.0,
                              divisions: 16,
                              onChanged: (val) =>
                                  setState(() => _spotlightRadius = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Cursor Border Glow Height:',
                              valueText: '${_cursorGlowHeight.toInt()}px',
                              value: _cursorGlowHeight,
                              min: 40.0,
                              max: 200.0,
                              divisions: 16,
                              onChanged: (val) =>
                                  setState(() => _cursorGlowHeight = val),
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
      _selectedIndex = 1;
      _isCollapsed = false;
      _indicatorStyle = BySidebarIndicatorStyle.fill;
      _enableSpotlight = true;
      _enableBorderTrack = true;
      _expandedWidth = 240.0;
      _collapsedWidth = 72.0;
      _itemRadius = 10.0;
      _itemSpacing = 6.0;
      _borderWidth = 1.0;
      _spotlightRadius = 120.0;
      _cursorGlowHeight = 100.0;
      _selectedActiveColorIndex = 0;
      _selectedBgColorIndex = 0;
      _selectedBorderColorIndex = 0;
      _activePresetIndex = 0;
      _sidebarPosition = BySidebarPosition.left;
      _togglePlacement = BySidebarTogglePlacement.bottom;
      _enableSwipeGesture = true;
      _enableHoverExpand = false;
      _isHoverExpanded = false;
    });
  }

  // ── CODE SNIPPET GENERATOR ──────────────────────────────────────────────
  String _generateCodeSnippet() {
    final buffer = StringBuffer();
    buffer.writeln('BySidebar(');
    buffer.writeln('  selectedIndex: _selectedIndex,');
    buffer.writeln(
      '  onItemSelected: (index) => setState(() => _selectedIndex = index),',
    );
    buffer.writeln('  isExpanded: !_isCollapsed,');
    buffer.writeln(
      '  onToggleExpand: (val) => setState(() => _isCollapsed = !val),',
    );
    buffer.writeln('  items: const [');
    buffer.writeln(
      "    BySidebarItem(label: 'Dashboard', icon: Icons.dashboard_rounded),",
    );
    buffer.writeln(
      "    BySidebarItem(label: 'Analytics', icon: Icons.analytics_rounded, badge: 'HOT'),",
    );
    buffer.writeln("    BySidebarItem.section(title: 'PREFERENCES'),");
    buffer.writeln(
      "    BySidebarItem(label: 'Settings', icon: Icons.settings_rounded),",
    );
    buffer.writeln('  ],');
    buffer.writeln('  indicatorStyle: $_indicatorStyle,');
    buffer.writeln('  togglePlacement: $_togglePlacement,');
    if (_enableHoverExpand) {
      buffer.writeln('  enableHoverExpand: true,');
    }
    buffer.writeln('  expandedWidth: ${_expandedWidth.toStringAsFixed(1)},');
    buffer.writeln('  collapsedWidth: ${_collapsedWidth.toStringAsFixed(1)},');
    buffer.writeln('  activeColor: const Color(0xFF00F5FF),');
    buffer.write(')');
    return buffer.toString();
  }

  void _showCodeDialog(BuildContext context) {
    showByCodeDialog(
      context,
      componentName: 'BySidebar',
      code: _generateCodeSnippet(),
    );
  }

  void _showParamsDialog(BuildContext context) {
    showWidgetParametersDialog(
      context,
      howToTry:
          'Interact with BySidebar via the bottom tactile action tile, or by swiping horizontally across the rail. Toggle Hover Auto-Expand Preview to test seamless cursor hover expansion where the sidebar remains compact by default and expands on hover.',
      howToTryIcon: AppIcons.touch,
      parameters: const [
        WidgetParamInfo(
          name: 'indicatorStyle',
          type: 'BySidebarIndicatorStyle',
          description:
              'Active selection highlight style (fill, leadingBar, outline).',
          defaultValue: 'BySidebarIndicatorStyle.fill',
        ),
        WidgetParamInfo(
          name: 'leadingBarWidth',
          type: 'double',
          description:
              'Thickness of the leading indicator bar when using leadingBar style.',
          defaultValue: '3.5',
        ),
        WidgetParamInfo(
          name: 'togglePlacement',
          type: 'BySidebarTogglePlacement',
          description:
              'Placement position for collapse/expand toggles (bottom, header, none).',
          defaultValue: 'BySidebarTogglePlacement.bottom',
        ),
        WidgetParamInfo(
          name: 'enableSwipeGesture',
          type: 'bool',
          description:
              'Whether to allow horizontal swipe/drag gestures to expand or collapse.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'enableHoverExpand',
          type: 'bool',
          description:
              'Whether hovering over the collapsed sidebar expands it temporarily as a preview overlay.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'items',
          type: 'List<BySidebarItem>',
          description:
              'The collection of navigation items and dividers in the sidebar.',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'selectedIndex',
          type: 'int',
          description: 'The currently active route index.',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'isCollapsed',
          type: 'bool',
          description:
              'Whether the sidebar is rendered in compact icon-only mode.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'expandedWidth',
          type: 'double',
          description:
              'Width in pixels when sidebar is in full expanded layout mode.',
          defaultValue: '240.0',
        ),
        WidgetParamInfo(
          name: 'collapsedWidth',
          type: 'double',
          description:
              'Width in pixels when sidebar is in compact icon-only mode.',
          defaultValue: '72.0',
        ),
        WidgetParamInfo(
          name: 'itemBorderRadius',
          type: 'BorderRadius',
          description: 'Corner radius for individual sidebar destination rows.',
          defaultValue: 'BorderRadius.circular(10.0)',
        ),
        WidgetParamInfo(
          name: 'itemSpacing',
          type: 'double',
          description: 'Vertical spacing between item rows.',
          defaultValue: '6.0',
        ),
        WidgetParamInfo(
          name: 'spotlightRadius',
          type: 'double',
          description:
              'Radial radius for the cursor proximity backlight spill.',
          defaultValue: '120.0',
        ),
        WidgetParamInfo(
          name: 'cursorBorderGlowHeight',
          type: 'double',
          description:
              'Height of the illuminated trailing border glow segment.',
          defaultValue: '100.0',
        ),
      ],
    );
  }

  Widget _buildHeroPreview({
    required AppColorPalette colors,
    required Color activeColor,
    required Color? bgColor,
    required Color? borderColor,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Container(
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: Row(
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
                            _sidebarItems[_selectedIndex].label.toUpperCase(),
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
              ),
              Divider(height: 1, thickness: 1, color: colors.border),
              SizedBox(
                height: 340,
                child: Row(
                  children: [
                    if (_sidebarPosition == BySidebarPosition.left)
                      BySidebar(
                        items: _sidebarItems,
                        selectedIndex: _selectedIndex,
                        position: _sidebarPosition,
                        isCollapsed: _isCollapsed,
                        expandedWidth: _expandedWidth,
                        collapsedWidth: _collapsedWidth,
                        itemBorderRadius: BorderRadius.circular(_itemRadius),
                        itemSpacing: _itemSpacing,
                        borderWidth: _borderWidth,
                        activeColor: activeColor,
                        backgroundColor: bgColor,
                        borderColor: borderColor,
                        enableSpotlightSpill: _enableSpotlight,
                        spotlightRadius: _spotlightRadius,
                        enableCursorBorderTracking: _enableBorderTrack,
                        cursorBorderGlowHeight: _cursorGlowHeight,
                        togglePlacement: _togglePlacement,
                        enableSwipeGesture: _enableSwipeGesture,
                        enableHoverExpand: _enableHoverExpand,
                        indicatorStyle: _indicatorStyle,
                        onHoverExpandChanged: (hovered) {
                          if (_isHoverExpanded != hovered) {
                            setState(() => _isHoverExpanded = hovered);
                          }
                        },
                        onToggleCollapse: () {
                          setState(() => _isCollapsed = !_isCollapsed);
                        },
                        onItemSelected: (index) {
                          setState(() => _selectedIndex = index);
                        },
                      ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _sidebarItems[_selectedIndex].icon,
                                  size: 44,
                                  color: activeColor,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _sidebarItems[_selectedIndex].label,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextStyle.sectionHeader.copyWith(
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Route Index: $_selectedIndex',
                                  style: AppTextStyle.caption.copyWith(
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_sidebarPosition == BySidebarPosition.right)
                      BySidebar(
                        items: _sidebarItems,
                        selectedIndex: _selectedIndex,
                        position: _sidebarPosition,
                        isCollapsed: _isCollapsed,
                        expandedWidth: _expandedWidth,
                        collapsedWidth: _collapsedWidth,
                        itemBorderRadius: BorderRadius.circular(_itemRadius),
                        itemSpacing: _itemSpacing,
                        borderWidth: _borderWidth,
                        activeColor: activeColor,
                        backgroundColor: bgColor,
                        borderColor: borderColor,
                        enableSpotlightSpill: _enableSpotlight,
                        spotlightRadius: _spotlightRadius,
                        enableCursorBorderTracking: _enableBorderTrack,
                        cursorBorderGlowHeight: _cursorGlowHeight,
                        togglePlacement: _togglePlacement,
                        enableSwipeGesture: _enableSwipeGesture,
                        enableHoverExpand: _enableHoverExpand,
                        indicatorStyle: _indicatorStyle,
                        onHoverExpandChanged: (hovered) {
                          if (_isHoverExpanded != hovered) {
                            setState(() => _isHoverExpanded = hovered);
                          }
                        },
                        onToggleCollapse: () {
                          setState(() => _isCollapsed = !_isCollapsed);
                        },
                        onItemSelected: (index) {
                          setState(() => _selectedIndex = index);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaximizedSidebarBody({
    required BuildContext context,
    required AppColorPalette colors,
    required bool isDark,
    required Color activeColor,
    required Color? bgColor,
    required Color? borderColor,
  }) {
    final topPadding = ByAppBar.getContentTopPadding(context, extra: 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // Rigidly fix content width to (totalWidth - _collapsedWidth) so expanding sidebar NEVER squeezes or overflows content
        final contentWidth = math.max(320.0, totalWidth - _collapsedWidth);
        final isExpanded = _enableHoverExpand
            ? _isHoverExpanded
            : !_isCollapsed;
        final currentSidebarWidth = isExpanded
            ? _expandedWidth
            : _collapsedWidth;
        final isDockLeft = _sidebarPosition == BySidebarPosition.left;

        Widget buildSidebarWidget() {
          return BySidebar(
            items: _sidebarItems,
            selectedIndex: _selectedIndex,
            position: _sidebarPosition,
            isCollapsed: _isCollapsed,
            expandedWidth: _expandedWidth,
            collapsedWidth: _collapsedWidth,
            itemBorderRadius: BorderRadius.circular(_itemRadius),
            itemSpacing: _itemSpacing,
            borderWidth: _borderWidth,
            activeColor: activeColor,
            backgroundColor: bgColor,
            borderColor: borderColor,
            enableSpotlightSpill: _enableSpotlight,
            spotlightRadius: _spotlightRadius,
            enableCursorBorderTracking: _enableBorderTrack,
            cursorBorderGlowHeight: _cursorGlowHeight,
            togglePlacement: _togglePlacement,
            enableSwipeGesture: _enableSwipeGesture,
            enableHoverExpand: _enableHoverExpand,
            indicatorStyle: _indicatorStyle,
            onHoverExpandChanged: (hovered) {
              if (_isHoverExpanded != hovered) {
                setState(() => _isHoverExpanded = hovered);
              }
            },
            onToggleCollapse: () {
              setState(() => _isCollapsed = !_isCollapsed);
            },
            onItemSelected: (index) {
              setState(() => _selectedIndex = index);
            },
          );
        }

        Widget buildConsoleViewport() {
          return Padding(
            padding: EdgeInsets.fromLTRB(16, topPadding + 10, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Cluster Header Status Toolbar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_queue_rounded,
                        size: 20,
                        color: activeColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'CLOUD CONSOLE // prod-cluster-us-east',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.badge.copyWith(
                            color: colors.textSecondary,
                            letterSpacing: 1.1,
                          ),
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
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: activeColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '99.99% HEALTHY',
                              style: AppTextStyle.badge.copyWith(
                                color: activeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Responsive dynamic workspace view
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: KeyedSubtree(
                      key: ValueKey<int>(_selectedIndex),
                      child: _buildSidebarWorkspaceView(
                        colors: colors,
                        activeColor: activeColor,
                        index: _selectedIndex,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // 1. Fixed-Width Slid Content Layer (DIGESER, NEVER SQUEEZED OR RESIZED)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              left: isDockLeft ? currentSidebarWidth : null,
              right: !isDockLeft ? currentSidebarWidth : null,
              width: contentWidth,
              top: 0,
              bottom: 0,
              child: ClipRect(
                child: OverflowBox(
                  alignment: isDockLeft
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  minWidth: contentWidth,
                  maxWidth: contentWidth,
                  child: buildConsoleViewport(),
                ),
              ),
            ),

            // 2. Semi-transparent tap-to-dismiss scrim on compact screens when expanded
            if (!_enableHoverExpand && !_isCollapsed && totalWidth < 680)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _isCollapsed = true),
                  child: Container(color: Colors.black.withValues(alpha: 0.35)),
                ),
              ),

            // 3. Anchored Vertical Sidebar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              top: topPadding,
              bottom: 0,
              left: isDockLeft ? 0 : null,
              right: !isDockLeft ? 0 : null,
              width: currentSidebarWidth,
              child: buildSidebarWidget(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSidebarWorkspaceView({
    required AppColorPalette colors,
    required Color activeColor,
    required int index,
  }) {
    switch (index) {
      case 1:
        return _buildConsoleDashboard(colors: colors, activeColor: activeColor);
      case 2:
        return _buildConsoleAnalytics(colors: colors, activeColor: activeColor);
      case 3:
        return _buildConsoleProjects(colors: colors, activeColor: activeColor);
      case 5:
        return _buildConsoleMessages(colors: colors, activeColor: activeColor);
      case 6:
      default:
        return _buildConsoleSettings(colors: colors, activeColor: activeColor);
    }
  }

  Widget _buildConsoleDashboard({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
    final cards = [
      _buildMetricCard(
        title: 'TOTAL INGRESS',
        value: '18.4k req/s',
        trend: '+12.5%',
        trendPositive: true,
        icon: Icons.speed_rounded,
        colors: colors,
        accent: activeColor,
      ),
      _buildMetricCard(
        title: 'MEDIAN LATENCY',
        value: '24.1 ms',
        trend: '-2.4ms',
        trendPositive: true,
        icon: Icons.timer_rounded,
        colors: colors,
        accent: activeColor,
      ),
      _buildMetricCard(
        title: 'ERROR RATE',
        value: '0.012%',
        trend: 'Optimal',
        trendPositive: true,
        icon: Icons.shield_rounded,
        colors: colors,
        accent: activeColor,
      ),
      _buildMetricCard(
        title: 'HEALTHY PODS',
        value: '48 / 48',
        trend: '100% Up',
        trendPositive: true,
        icon: Icons.dns_rounded,
        colors: colors,
        accent: activeColor,
      ),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        LayoutBuilder(
          builder: (context, box) {
            if (box.maxWidth >= 580) {
              return Row(
                children: [
                  for (int i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    Expanded(child: cards[i]),
                  ],
                ],
              );
            } else if (box.maxWidth >= 300) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 10),
                      Expanded(child: cards[1]),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: cards[2]),
                      const SizedBox(width: 10),
                      Expanded(child: cards[3]),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  for (int i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    cards[i],
                  ],
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
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
                'Cluster Node Topologies',
                style: AppTextStyle.sectionHeader.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'All Kubernetes worker nodes are synchronized across multi-region availability zones.',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: activeColor.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: activeColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
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

  Widget _buildConsoleAnalytics({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
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
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 8,
                children: [
                  Text(
                    'Throughput & Network Telemetry',
                    style: AppTextStyle.sectionHeader.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: activeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'REALTIME STREAM',
                      style: AppTextStyle.badge.copyWith(color: activeColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...[
                ('Ingress Traffic', '8.4 GB/s', 0.85, activeColor),
                (
                  'Egress Traffic',
                  '4.2 GB/s',
                  0.52,
                  activeColor.withValues(alpha: 0.7),
                ),
                (
                  'Inter-cluster RPC',
                  '12.8 GB/s',
                  0.94,
                  activeColor.withValues(alpha: 0.45),
                ),
              ].map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.$1,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: colors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.$2,
                            style: AppTextStyle.specHighlight.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: item.$3,
                        backgroundColor: colors.scaffoldBg,
                        valueColor: AlwaysStoppedAnimation<Color>(item.$4),
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 6,
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

  Widget _buildConsoleProjects({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
    final services = [
      ('auth-gateway-service', 'v3.1.2', 'Healthy', activeColor),
      ('payment-broker-mesh', 'v2.8.0', 'Healthy', activeColor),
      ('notification-pubsub', 'v1.14.4', 'Healthy', activeColor),
      (
        'search-indexer-daemon',
        'v4.0.1',
        'Syncing',
        activeColor.withValues(alpha: 0.7),
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
                'Microservices Registry',
                style: AppTextStyle.sectionHeader.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              ...services.map(
                (s) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.scaffoldBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_rounded,
                        size: 20,
                        color: activeColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.$1,
                              style: AppTextStyle.code.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Release ${s.$2}',
                              style: AppTextStyle.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: s.$4.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          s.$3.toUpperCase(),
                          style: AppTextStyle.badge.copyWith(color: s.$4),
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

  Widget _buildConsoleMessages({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
    final auditLogs = [
      ('Autoscaler scaled replica count from 32 to 48', '3m ago', activeColor),
      (
        'Mutual TLS certificate rotated for auth-gateway',
        '18m ago',
        activeColor,
      ),
      ('Canary traffic split reached 100% on us-east', '45m ago', activeColor),
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
                'Cluster Audit Events',
                style: AppTextStyle.sectionHeader.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              ...auditLogs.map(
                (log) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.scaffoldBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: log.$3,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          log.$1,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        log.$2,
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

  Widget _buildConsoleSettings({
    required AppColorPalette colors,
    required Color activeColor,
  }) {
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
                'Environment Policies',
                style: AppTextStyle.sectionHeader.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                title: 'Automated Zero-Downtime Rolling Update',
                subtitle:
                    'Gradually replace pods ensuring minimum 85% availability',
                value: true,
                activeColor: activeColor,
                colors: colors,
                onChanged: (_) {},
              ),
              Divider(color: colors.border, height: 24),
              _buildSettingRow(
                title: 'Strict Mutual TLS (mTLS) Encryption',
                subtitle: 'Enforce cryptographic service-to-service handshake',
                value: true,
                activeColor: activeColor,
                colors: colors,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required String title,
    required String subtitle,
    required bool value,
    required Color activeColor,
    required AppColorPalette colors,
    required ValueChanged<bool>? onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.bodyMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyle.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          activeTrackColor: activeColor,
          thumbColor: const WidgetStatePropertyAll<Color>(Colors.white),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required bool trendPositive,
    required IconData icon,
    required AppColorPalette colors,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: accent),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (trendPositive ? accent : colors.textMuted).withValues(
                    alpha: 0.15,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  trend,
                  style: AppTextStyle.badgeSmall.copyWith(
                    color: trendPositive ? accent : colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyle.specHighlight.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTextStyle.caption.copyWith(
              color: colors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
