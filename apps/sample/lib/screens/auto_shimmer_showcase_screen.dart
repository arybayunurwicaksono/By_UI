import 'dart:async';
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

/// Interactive showcase screen for [ByAutoShimmer], [ByBone], and [ByShimmerScope].
class AutoShimmerShowcaseScreen extends StatefulWidget {
  const AutoShimmerShowcaseScreen({super.key});

  @override
  State<AutoShimmerShowcaseScreen> createState() =>
      _AutoShimmerShowcaseScreenState();
}

class _AutoShimmerShowcaseScreenState extends State<AutoShimmerShowcaseScreen> {
  bool _isLoading = true;
  bool _enablePulse = true;
  bool _enableLaserReveal = true;
  ByShimmerDirection _direction = ByShimmerDirection.ltr;
  double _shimmerWaveWidth = 1.5;
  int _selectedVariantIndex = 0; // 0: Solid, 1: Cyber Glass
  int _activePresetIndex = 0;

  // Fullscreen live preview & 2-second preload shimmer cycle
  bool _isMaximized = false;
  bool _isPreloading = true;
  Timer? _preloadTimer;

  void _startPreloadCycle() {
    _preloadTimer?.cancel();
    setState(() => _isPreloading = true);
    _preloadTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isPreloading = false);
      }
    });
  }

  @override
  void dispose() {
    _preloadTimer?.cancel();
    super.dispose();
  }

  // Geometry
  double _containerRadius = 16.0;
  double _boneRadius = 8.0;
  double _containerPadding = 16.0;
  double _containerBorderWidth = 1.0;

  // Optics & Timing
  double _shimmerDurationMs = 1500.0;
  double _dynamicBorderWidth = 2.0;
  double _dynamicBorderGlowBlur = 10.0;

  // Color Swatch Selection
  int _selectedBaseColorIndex = 0;
  int _selectedHighlightColorIndex = 0;
  int _selectedWaveGradientIndex = 0;
  int _selectedLaserGradientIndex = 0;

  static const List<ShowcaseColorOption> _baseColorOptions = [
    ShowcaseColorOption('Auto (Theme Default)', null),
    ShowcaseColorOption('Dark Slate', AppColors.darkCard),
    ShowcaseColorOption('Deep Navy', AppColors.deepRoyal),
    ShowcaseColorOption('Obsidian', AppColors.obsidianDarkest),
    ShowcaseColorOption('Emerald Slate', AppColors.emeraldDeep),
    ShowcaseColorOption('Midnight Blue', Color(0xFF0D1B2A)),
    ShowcaseColorOption('Deep Sapphire', Color(0xFF0F172A)),
    ShowcaseColorOption('Dark Amethyst', Color(0xFF1B102E)),
    ShowcaseColorOption('Dark Burgundy', Color(0xFF280B16)),
    ShowcaseColorOption('Cloud Gray', Color(0xFFE2E8F0)),
    ShowcaseColorOption('Pure White', Colors.white),
    ShowcaseColorOption('Pure Black', Colors.black),
  ];

  static const List<ShowcaseColorOption> _highlightColorOptions = [
    ShowcaseColorOption('Auto (Theme Default)', null),
    ShowcaseColorOption('Sky Cyan', AppColors.cyanAccent),
    ShowcaseColorOption('Violet Neon', AppColors.primaryAccent),
    ShowcaseColorOption('Electric Blue', Color(0xFF2563EB)),
    ShowcaseColorOption('Rose Pink', Color(0xFFF43F5E)),
    ShowcaseColorOption('Neon Lime', Color(0xFF10B981)),
    ShowcaseColorOption('Sun Gold', Color(0xFFF59E0B)),
    ShowcaseColorOption('Pure White', Colors.white),
    ShowcaseColorOption('Emerald Mint', AppColors.success),
    ShowcaseColorOption('Amber Sunset', AppColors.warning),
  ];

  static const List<ShowcaseThemePreset> _waveGradientOptions = [
    ShowcaseThemePreset(
      name: 'Single Highlight (Default)',
      color: AppColors.cyanAccent,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Cyan & Violet Neon Sweep',
      color: AppColors.cyanAccent,
      gradient: LinearGradient(
        colors: [AppColors.cyanAccent, AppColors.primaryAccent],
      ),
    ),
    ShowcaseThemePreset(
      name: 'Sunset Glow Wave',
      color: AppColors.warning,
      gradient: LinearGradient(colors: [AppColors.warning, Colors.pinkAccent]),
    ),
    ShowcaseThemePreset(
      name: 'Emerald Matrix Wave',
      color: AppColors.success,
      gradient: LinearGradient(
        colors: [AppColors.emeraldDeep, Color(0xFF10B981), AppColors.success],
      ),
    ),
    ShowcaseThemePreset(
      name: 'Prismatic Aurora Wave',
      color: Colors.purpleAccent,
      gradient: LinearGradient(
        colors: [AppColors.cyanAccent, Colors.purpleAccent, Colors.amberAccent],
      ),
    ),
    ShowcaseThemePreset(
      name: 'Pure White Flare Wave',
      color: Colors.white,
      gradient: LinearGradient(
        colors: [Colors.white70, Colors.white, Colors.white70],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        final colors = AppColors.of(context);
        final isDark = AppThemeStore.instance.isDarkMode(context);

        final baseResolved = _selectedVariantIndex == 1
            ? BySkeletonStyle.cyberGlass
            : (isDark ? BySkeletonStyle.darkSlate : BySkeletonStyle.lightSlate);

        final customBaseColor =
            _baseColorOptions[_selectedBaseColorIndex].color;
        final customHighlightColor =
            _highlightColorOptions[_selectedHighlightColorIndex].color;
        final laserGradientPreset =
            AppColors.appBarSensorGradients[_selectedLaserGradientIndex];

        final selectedWaveGradientPreset =
            _waveGradientOptions[_selectedWaveGradientIndex];
        LinearGradient? effectiveShimmerGradient;
        if (selectedWaveGradientPreset.gradient != null &&
            selectedWaveGradientPreset.gradient is LinearGradient) {
          final lg = selectedWaveGradientPreset.gradient as LinearGradient;
          final effectiveBase = customBaseColor ?? baseResolved.baseColor;
          effectiveShimmerGradient = LinearGradient(
            colors: [effectiveBase, ...lg.colors, effectiveBase],
          );
        }

        final skeletonStyle = baseResolved.copyWith(
          baseColor: customBaseColor,
          highlightColor: customHighlightColor,
          shimmerGradient: effectiveShimmerGradient,
          borderRadius: BorderRadius.circular(_boneRadius),
          shimmerDuration: Duration(milliseconds: _shimmerDurationMs.toInt()),
        );

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
                  componentName: 'ByAutoShimmer',
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
                            tooltip: 'Reload Skeleton Shimmer',
                            icon: const Icon(
                              Icons.replay_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                            onPressed: _startPreloadCycle,
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
              drawer: const ByDrawer(activeComponent: 'ByAutoShimmer'),
              body: _isMaximized
                  ? _buildMaximizedSkeletonBody(
                      colors: colors,
                      isDark: isDark,
                      style: skeletonStyle,
                      laserColors:
                          laserGradientPreset.colors ??
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
                          icon: Icons.auto_awesome_rounded,
                          subtitle:
                              'Live metrics for ByAutoShimmer configuration state',
                          metrics: [
                            ByMetricBadge(
                              label: 'State',
                              value: _isLoading ? 'LOADING' : 'READY',
                            ),
                            ByMetricBadge(
                              label: 'Variant',
                              value: _selectedVariantIndex == 1
                                  ? 'CYBER GLASS'
                                  : 'SOLID SLATE',
                            ),
                            ByMetricBadge(
                              label: 'Radius',
                              value: '${_containerRadius.toInt()}px',
                            ),
                            ByMetricBadge(
                              label: 'Shimmer',
                              value: '${_shimmerDurationMs.toInt()}ms',
                            ),
                            ByMetricBadge(
                              label: 'Laser Glow',
                              value: '${_dynamicBorderGlowBlur.toInt()}px',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── LAYER 2: Preset Example Card ──────────────────────────
                        ByShowcasePresetCard(
                          presets: [
                            ByShowcasePresetItem(
                              label: 'Standard Slate',
                              themeColor: AppColors.primary,
                              isSelected: _activePresetIndex == 0,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 0;
                                  _isLoading = true;
                                  _direction = ByShimmerDirection.ltr;
                                  _shimmerWaveWidth = 1.5;
                                  _selectedVariantIndex = 0;
                                  _enablePulse = true;
                                  _enableLaserReveal = true;
                                  _containerRadius = 16.0;
                                  _boneRadius = 6.0;
                                  _selectedBaseColorIndex = 0;
                                  _selectedHighlightColorIndex = 0;
                                  _selectedWaveGradientIndex = 0;
                                  _selectedLaserGradientIndex = 0;
                                  _shimmerDurationMs = 1500.0;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Cyber Blueprint',
                              themeColor: AppColors.primaryAccent,
                              isSelected: _activePresetIndex == 1,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 1;
                                  _isLoading = true;
                                  _direction = ByShimmerDirection.diagonal;
                                  _shimmerWaveWidth = 1.6;
                                  _selectedVariantIndex = 1;
                                  _enablePulse = true;
                                  _enableLaserReveal = true;
                                  _containerRadius = 18.0;
                                  _boneRadius = 8.0;
                                  _selectedBaseColorIndex = 2;
                                  _selectedHighlightColorIndex = 1;
                                  _selectedWaveGradientIndex = 1;
                                  _selectedLaserGradientIndex = 1;
                                  _shimmerDurationMs = 1200.0;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Emerald Matrix',
                              themeColor: AppColors.success,
                              isSelected: _activePresetIndex == 2,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 2;
                                  _isLoading = true;
                                  _direction = ByShimmerDirection.ttb;
                                  _shimmerWaveWidth = 1.4;
                                  _selectedVariantIndex = 0;
                                  _enablePulse = true;
                                  _enableLaserReveal = true;
                                  _containerRadius = 14.0;
                                  _boneRadius = 6.0;
                                  _selectedBaseColorIndex = 4;
                                  _selectedHighlightColorIndex = 4;
                                  _selectedWaveGradientIndex = 3;
                                  _selectedLaserGradientIndex = 2;
                                  _shimmerDurationMs = 1000.0;
                                });
                              },
                            ),
                            ByShowcasePresetItem(
                              label: 'Instant Content',
                              themeColor: AppColors.info,
                              isSelected: _activePresetIndex == 3,
                              onTap: () {
                                setState(() {
                                  _activePresetIndex = 3;
                                  _isLoading = false;
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
                              'ByAutoShimmer seamlessly orchestrates ByDynamicBorder for active perimeter pulses and laser reveal transitions.',
                        ),
                        const SizedBox(height: 14),

                        // ── LAYER 4: Standalone Widget Display (Hero Live Preview) ─
                        _buildHeroPreview(
                          colors: colors,
                          isDark: isDark,
                          style: skeletonStyle,
                          laserColors:
                              laserGradientPreset.colors ??
                              const [AppColors.cyanAccent, AppColors.primary],
                        ),
                        const SizedBox(height: 14),

                        // ── LAYER 5: Numbered Control Cards ───────────────────────
                        ByShowcaseControlCard(
                          title: '1. STATE & ANIMATION TRIGGERS',
                          icon: Icons.bolt_rounded,
                          children: [
                            ByShowcaseSwitchTile(
                              title: 'Data Fetching State (isLoading)',
                              subtitle:
                                  'Toggle between the active skeleton placeholder and live content',
                              value: _isLoading,
                              onChanged: (val) =>
                                  setState(() => _isLoading = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Perimeter Dynamic Border Pulse',
                              subtitle:
                                  'Pulses a traveling laser beam along the outer perimeter while loading',
                              value: _enablePulse,
                              onChanged: (val) =>
                                  setState(() => _enablePulse = val),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Laser Beam Materialize Reveal',
                              subtitle:
                                  'Executes a fast perimeter laser sweep when morphing into live content',
                              value: _enableLaserReveal,
                              onChanged: (val) =>
                                  setState(() => _enableLaserReveal = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '2. GEOMETRY & CORNERS',
                          icon: Icons.rounded_corner_rounded,
                          children: [
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
                              label: 'Bone Corner Radius:',
                              valueText: '${_boneRadius.toInt()}px',
                              value: _boneRadius,
                              min: 0.0,
                              max: 20.0,
                              divisions: 20,
                              onChanged: (val) =>
                                  setState(() => _boneRadius = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Container Padding:',
                              valueText: '${_containerPadding.toInt()}px',
                              value: _containerPadding,
                              min: 8.0,
                              max: 28.0,
                              divisions: 20,
                              onChanged: (val) =>
                                  setState(() => _containerPadding = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Border Stroke Width:',
                              valueText:
                                  '${_containerBorderWidth.toStringAsFixed(1)}px',
                              value: _containerBorderWidth,
                              min: 0.0,
                              max: 3.0,
                              divisions: 6,
                              onChanged: (val) =>
                                  setState(() => _containerBorderWidth = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '3. COLOR PALETTES & THEMES',
                          icon: Icons.palette_rounded,
                          children: [
                            Text(
                              'Skeleton Bone Variant:',
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
                                    label: 'Solid Slate',
                                    isSelected: _selectedVariantIndex == 0,
                                    onTap: () => setState(
                                      () => _selectedVariantIndex = 0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Cyber Glassmorphic',
                                    isSelected: _selectedVariantIndex == 1,
                                    onTap: () => setState(
                                      () => _selectedVariantIndex = 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Bone Base Surface Color:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromOptions(
                              options: _baseColorOptions,
                              selectedIndex: _selectedBaseColorIndex,
                              onSelected: (idx) =>
                                  setState(() => _selectedBaseColorIndex = idx),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Shimmer Traveling Highlight Color:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromOptions(
                              options: _highlightColorOptions,
                              selectedIndex: _selectedHighlightColorIndex,
                              onSelected: (idx) => setState(
                                () => _selectedHighlightColorIndex = idx,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Shimmer Multi-Tone Wave Gradient (Optional):',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByColorPalette.fromPresets(
                              presets: _waveGradientOptions,
                              selectedIndex: _selectedWaveGradientIndex,
                              onSelected: (idx) => setState(
                                () => _selectedWaveGradientIndex = idx,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Perimeter Dynamic Laser Colors:',
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
                            const SizedBox(height: 6),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '4. SHIMMER OPTICS & TIMING',
                          icon: Icons.speed_rounded,
                          children: [
                            Text(
                              'Shimmer Wave Direction:',
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
                                    label: 'Left to Right (LTR)',
                                    isSelected:
                                        _direction == ByShimmerDirection.ltr,
                                    onTap: () => setState(
                                      () => _direction = ByShimmerDirection.ltr,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Right to Left (RTL)',
                                    isSelected:
                                        _direction == ByShimmerDirection.rtl,
                                    onTap: () => setState(
                                      () => _direction = ByShimmerDirection.rtl,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Top to Bottom (TTB)',
                                    isSelected:
                                        _direction == ByShimmerDirection.ttb,
                                    onTap: () => setState(
                                      () => _direction = ByShimmerDirection.ttb,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ByShowcaseChoiceChip(
                                    label: 'Diagonal',
                                    isSelected:
                                        _direction ==
                                        ByShimmerDirection.diagonal,
                                    onTap: () => setState(
                                      () => _direction =
                                          ByShimmerDirection.diagonal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ByShowcaseSliderTile(
                              label: 'Shimmer Wave Width:',
                              valueText:
                                  '${_shimmerWaveWidth.toStringAsFixed(2)}x',
                              value: _shimmerWaveWidth,
                              min: 0.5,
                              max: 2.5,
                              divisions: 20,
                              onChanged: (val) =>
                                  setState(() => _shimmerWaveWidth = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Shimmer Sweep Duration:',
                              valueText: '${_shimmerDurationMs.toInt()}ms',
                              value: _shimmerDurationMs,
                              min: 600.0,
                              max: 3000.0,
                              divisions: 24,
                              onChanged: (val) =>
                                  setState(() => _shimmerDurationMs = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Laser Dynamic Border Width:',
                              valueText:
                                  '${_dynamicBorderWidth.toStringAsFixed(1)}px',
                              value: _dynamicBorderWidth,
                              min: 1.0,
                              max: 4.0,
                              divisions: 6,
                              onChanged: (val) =>
                                  setState(() => _dynamicBorderWidth = val),
                            ),
                            const SizedBox(height: 10),
                            ByShowcaseSliderTile(
                              label: 'Laser Glow Blur:',
                              valueText: '${_dynamicBorderGlowBlur.toInt()}px',
                              value: _dynamicBorderGlowBlur,
                              min: 4.0,
                              max: 20.0,
                              divisions: 16,
                              onChanged: (val) =>
                                  setState(() => _dynamicBorderGlowBlur = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '5. SYNCHRONIZED MULTI-CARD SHIMMER SCOPE',
                          icon: Icons.sync_rounded,
                          children: [
                            Text(
                              'Ancestor ByShimmerScope synchronizing 3 cards in uniform clock phase:',
                              style: AppTextStyle.caption.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ByShimmerScope(
                              duration: Duration(
                                milliseconds: _shimmerDurationMs.toInt(),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildMiniSkeletonCard(colors),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildMiniSkeletonCard(colors),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildMiniSkeletonCard(colors),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ByShowcaseControlCard(
                          title: '6. CONVENIENCE PRESET FACTORIES',
                          icon: Icons.auto_awesome_rounded,
                          children: [
                            Text(
                              'Ready-to-use factory constructors without manual skeleton boilerplate:',
                              style: AppTextStyle.caption.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'ByAutoShimmer.card:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByAutoShimmer.card(
                              isLoading: _isLoading,
                              direction: _direction,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colors.cardBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: colors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.credit_card_rounded,
                                      color: AppColors.primary,
                                      size: 36,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Platinum Rewards Card',
                                            style: AppTextStyle.body.copyWith(
                                              color: colors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '•••• 4242 — Active',
                                            style: AppTextStyle.caption
                                                .copyWith(
                                                  color: colors.textMuted,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'ByAutoShimmer.listTile:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ByAutoShimmer.listTile(
                              isLoading: _isLoading,
                              direction: _direction,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.cardBg,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: colors.border),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.cyanAccent
                                          .withValues(alpha: 0.2),
                                      child: const Icon(
                                        Icons.person_rounded,
                                        color: AppColors.cyanAccent,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Jane Doe (Lead Architect)',
                                            style: AppTextStyle.body.copyWith(
                                              color: colors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Online 5m ago',
                                            style: AppTextStyle.caption
                                                .copyWith(
                                                  color: colors.textMuted,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
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
      _isLoading = true;
      _enablePulse = true;
      _enableLaserReveal = true;
      _direction = ByShimmerDirection.ltr;
      _shimmerWaveWidth = 1.5;
      _selectedVariantIndex = 0;
      _activePresetIndex = 0;
      _containerRadius = 16.0;
      _boneRadius = 8.0;
      _containerPadding = 16.0;
      _containerBorderWidth = 1.0;
      _shimmerDurationMs = 1500.0;
      _dynamicBorderWidth = 2.0;
      _dynamicBorderGlowBlur = 10.0;
      _selectedBaseColorIndex = 0;
      _selectedHighlightColorIndex = 0;
      _selectedWaveGradientIndex = 0;
      _selectedLaserGradientIndex = 0;
    });
  }

  // ── CODE SNIPPET GENERATOR ──────────────────────────────────────────────
  String _generateCodeSnippet() {
    final buffer = StringBuffer();
    buffer.writeln('ByAutoShimmer(');
    buffer.writeln('  isLoading: _isLoading,');
    buffer.writeln('  direction: $_direction,');
    buffer.writeln(
      '  shimmerDuration: const Duration(milliseconds: ${_shimmerDurationMs.toInt()}),',
    );
    buffer.writeln(
      '  shimmerWaveWidth: ${_shimmerWaveWidth.toStringAsFixed(2)},',
    );
    if (_enablePulse) {
      buffer.writeln('  enableDynamicBorderPulse: true,');
    }
    if (!_enableLaserReveal) {
      buffer.writeln('  enableLaserReveal: false,');
    }
    buffer.writeln('  style: const BySkeletonStyle(');
    buffer.writeln('    shimmerGradient: LinearGradient(');
    buffer.writeln(
      '      colors: [Color(0xFF1E293B), Color(0xFF38BDF8), Color(0xFF1E293B)],',
    );
    buffer.writeln('    ),');
    buffer.writeln('  ),');
    buffer.writeln('  child: YourCardWidget(),');
    buffer.write(')');
    return buffer.toString();
  }

  void _showCodeDialog(BuildContext context) {
    showByCodeDialog(
      context,
      componentName: 'ByAutoShimmer',
      code: _generateCodeSnippet(),
    );
  }

  void _showParamsDialog(BuildContext context) {
    showWidgetParametersDialog(
      context,
      howToTry:
          'Toggle the isLoading switch in Section 1 to observe the dynamic traveling laser border during loading, and the Laser Beam Materialize Reveal transition when content is ready.',
      howToTryIcon: AppIcons.touch,
      parameters: const [
        WidgetParamInfo(
          name: 'isLoading',
          type: 'bool',
          description:
              'Whether the widget is in the active skeleton fetching state.',
          defaultValue: 'true',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'direction',
          type: 'ByShimmerDirection',
          description:
              'Direction of traveling shimmer gradient (ltr, rtl, ttb, btt, diagonal).',
          defaultValue: 'ByShimmerDirection.ltr',
        ),
        WidgetParamInfo(
          name: 'shimmerWaveWidth',
          type: 'double',
          description:
              'Relative thickness fraction of the traveling shimmer wave (0.0 to 1.0).',
          defaultValue: '0.3',
        ),
        WidgetParamInfo(
          name: 'shimmerDuration',
          type: 'Duration',
          description: 'Duration for a single traveling shimmer wave cycle.',
          defaultValue: '1500ms',
        ),
        WidgetParamInfo(
          name: 'transitionCurve',
          type: 'Curve',
          description:
              'Animation easing curve used when cross-fading skeleton and live content.',
          defaultValue: 'Curves.easeInOut',
        ),
        WidgetParamInfo(
          name: 'enableDynamicBorderPulse',
          type: 'bool',
          description:
              'Renders a traveling laser beam along the outer perimeter edge while loading.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'enableLaserReveal',
          type: 'bool',
          description:
              'Triggers an animated laser perimeter circuit when morphing from skeleton to live content.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'style',
          type: 'BySkeletonStyle?',
          description:
              'Styling tokens for bone colors, highlight colors, and glassmorphic scanlines.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'skeletonBuilder',
          type: 'WidgetBuilder?',
          description:
              'Optional custom skeleton tree for explicit bones when models might be null.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'borderRadius',
          type: 'BorderRadius',
          description:
              'Curvature geometry for the skeleton container perimeter.',
          defaultValue: 'BorderRadius.circular(12.0)',
        ),
        WidgetParamInfo(
          name: 'dynamicBorderWidth',
          type: 'double',
          description:
              'Stroke width of the perimeter traveling dynamic laser border.',
          defaultValue: '2.0',
        ),
        WidgetParamInfo(
          name: 'dynamicBorderGlowBlur',
          type: 'double',
          description: 'Ambient glow blur radius of the perimeter laser beam.',
          defaultValue: '10.0',
        ),
        WidgetParamInfo(
          name: 'dynamicBorderDuration',
          type: 'Duration',
          description:
              'Animation duration for one full cycle of the dynamic border.',
          defaultValue: 'Duration(milliseconds: 1400)',
        ),
      ],
    );
  }

  Widget _buildHeroPreview({
    required AppColorPalette colors,
    required bool isDark,
    required BySkeletonStyle style,
    required List<Color> laserColors,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    onPressed: () {
                      setState(() => _isMaximized = true);
                      _startPreloadCycle();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ByAutoShimmer(
                isLoading: _isLoading,
                direction: _direction,
                shimmerWaveWidth: _shimmerWaveWidth,
                enableDynamicBorderPulse: _enablePulse,
                enableLaserReveal: _enableLaserReveal,
                laserColors: laserColors,
                dynamicBorderWidth: _dynamicBorderWidth,
                dynamicBorderGlowBlur: _dynamicBorderGlowBlur,
                dynamicBorderDuration: Duration(
                  milliseconds: _shimmerDurationMs.toInt(),
                ),
                style: style,
                borderRadius: BorderRadius.circular(_containerRadius),
                skeletonBuilder: (context) {
                  return Container(
                    padding: EdgeInsets.all(_containerPadding),
                    decoration: BoxDecoration(
                      color: colors.cardBg,
                      borderRadius: BorderRadius.circular(_containerRadius),
                      border: Border.all(
                        color: colors.border,
                        width: _containerBorderWidth,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            ByBone.circular(size: 48, style: style),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ByBone.text(
                                    width: 140,
                                    height: 16,
                                    style: style,
                                  ),
                                  const SizedBox(height: 6),
                                  ByBone.text(
                                    width: 90,
                                    height: 12,
                                    style: style,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ByBone.rect(
                          width: double.infinity,
                          height: 110,
                          borderRadius: BorderRadius.circular(_boneRadius),
                          style: style,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ByBone.text(width: 70, height: 14, style: style),
                            ByBone.rect(
                              width: 90,
                              height: 32,
                              borderRadius: BorderRadius.circular(_boneRadius),
                              style: style,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(_containerPadding),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(_containerRadius),
                    border: Border.all(
                      color: colors.border,
                      width: _containerBorderWidth,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.cyanAccent,
                                  AppColors.primary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.rocket_launch_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quantum Processor v4',
                                  style: AppTextStyle.body.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Spatial Hardware Edition',
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
                      Container(
                        width: double.infinity,
                        height: 110,
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.memory_rounded,
                            size: 48,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$499.00',
                            style: AppTextStyle.body.copyWith(
                              color: AppColors.cyanAccent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Order Now'),
                          ),
                        ],
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

  // ── Full-Screen Live Preview with 2-Second Shimmer Preload Lifecycle ─────────
  Widget _buildMaximizedSkeletonBody({
    required AppColorPalette colors,
    required bool isDark,
    required BySkeletonStyle style,
    required List<Color> laserColors,
  }) {
    final topPadding = ByAppBar.getContentTopPadding(context, extra: 10);

    return ListView(
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 40),
      children: [
        // ── Preload Lifecycle Status Banner ──────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _isPreloading
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.success.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isPreloading
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.success.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _isPreloading
                    ? Icons.hourglass_top_rounded
                    : Icons.check_circle_outline_rounded,
                size: 18,
                color: _isPreloading ? AppColors.primary : AppColors.success,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _isPreloading
                      ? 'Simulating 2s Shimmer Preload Cycle...'
                      : 'Preload Complete • 4 Skeletons Rendered Real Data',
                  style: AppTextStyle.caption.copyWith(
                    color: _isPreloading
                        ? AppColors.primary
                        : AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: _startPreloadCycle,
                icon: const Icon(Icons.replay_rounded, size: 14),
                label: const Text('Reload (2s)'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 1. User Profile & Mission Command Banner ─────────────────────
        ByAutoShimmer(
          isLoading: _isPreloading,
          direction: _direction,
          shimmerWaveWidth: _shimmerWaveWidth,
          enableDynamicBorderPulse: _enablePulse,
          enableLaserReveal: _enableLaserReveal,
          laserColors: laserColors,
          dynamicBorderWidth: _dynamicBorderWidth,
          dynamicBorderGlowBlur: _dynamicBorderGlowBlur,
          dynamicBorderDuration: Duration(
            milliseconds: _shimmerDurationMs.toInt(),
          ),
          style: style,
          borderRadius: BorderRadius.circular(16),
          skeletonBuilder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  ByBone.circular(size: 56, style: style),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ByBone.text(width: 160, height: 18, style: style),
                        const SizedBox(height: 8),
                        ByBone.text(width: 100, height: 12, style: style),
                      ],
                    ),
                  ),
                  ByBone.rect(
                    width: 76,
                    height: 32,
                    borderRadius: BorderRadius.circular(8),
                    style: style,
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.cyanAccent, AppColors.primary],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'EV',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.cardBg, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cmdr. Elena Vance',
                        style: AppTextStyle.body.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@elena.vance // Chief Spatial Architect',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Connect'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── 2. Real-Time Telemetry & Metric Grid (3 Cards) ───────────────
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;
            return isNarrow
                ? Column(
                    children: [
                      _buildMetricSkeletonCard(
                        style: style,
                        laserColors: laserColors,
                        colors: colors,
                        label: 'Network Throughput',
                        value: '48.2 Gbps',
                        trend: '+14.2%',
                        isPositive: true,
                        icon: Icons.speed_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildMetricSkeletonCard(
                        style: style,
                        laserColors: laserColors,
                        colors: colors,
                        label: 'Cluster Nodes',
                        value: '1,280 Online',
                        trend: '99.98% SLA',
                        isPositive: true,
                        icon: Icons.hub_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildMetricSkeletonCard(
                        style: style,
                        laserColors: laserColors,
                        colors: colors,
                        label: 'Storage Vault',
                        value: '4.82 TB / 10 TB',
                        trend: '48% Used',
                        isPositive: false,
                        icon: Icons.cloud_queue_rounded,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildMetricSkeletonCard(
                          style: style,
                          laserColors: laserColors,
                          colors: colors,
                          label: 'Network Throughput',
                          value: '48.2 Gbps',
                          trend: '+14.2%',
                          isPositive: true,
                          icon: Icons.speed_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricSkeletonCard(
                          style: style,
                          laserColors: laserColors,
                          colors: colors,
                          label: 'Cluster Nodes',
                          value: '1,280 Online',
                          trend: '99.98% SLA',
                          isPositive: true,
                          icon: Icons.hub_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricSkeletonCard(
                          style: style,
                          laserColors: laserColors,
                          colors: colors,
                          label: 'Storage Vault',
                          value: '4.82 TB / 10 TB',
                          trend: '48% Used',
                          isPositive: false,
                          icon: Icons.cloud_queue_rounded,
                        ),
                      ),
                    ],
                  );
          },
        ),
        const SizedBox(height: 16),

        // ── 3. High-Tech Article / Product Feed Card ─────────────────────
        ByAutoShimmer(
          isLoading: _isPreloading,
          direction: _direction,
          shimmerWaveWidth: _shimmerWaveWidth,
          enableDynamicBorderPulse: _enablePulse,
          enableLaserReveal: _enableLaserReveal,
          laserColors: laserColors,
          dynamicBorderWidth: _dynamicBorderWidth,
          dynamicBorderGlowBlur: _dynamicBorderGlowBlur,
          dynamicBorderDuration: Duration(
            milliseconds: _shimmerDurationMs.toInt(),
          ),
          style: style,
          borderRadius: BorderRadius.circular(16),
          skeletonBuilder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ByBone.rect(
                    width: double.infinity,
                    height: 140,
                    borderRadius: BorderRadius.circular(10),
                    style: style,
                  ),
                  const SizedBox(height: 14),
                  ByBone.text(width: 90, height: 12, style: style),
                  const SizedBox(height: 8),
                  ByBone.text(width: 220, height: 18, style: style),
                  const SizedBox(height: 8),
                  ByBone.text(width: double.infinity, height: 12, style: style),
                  const SizedBox(height: 4),
                  ByBone.text(width: 180, height: 12, style: style),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ByBone.text(width: 80, height: 16, style: style),
                      ByBone.rect(
                        width: 110,
                        height: 36,
                        borderRadius: BorderRadius.circular(8),
                        style: style,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.darkCard, AppColors.deepRoyal],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.blur_linear_rounded,
                      size: 64,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'SPATIAL HARDWARE',
                    style: AppTextStyle.caption.copyWith(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quantum Neural Accelerator Engine v4',
                  style: AppTextStyle.body.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Hardware-accelerated tensor matrix operations with ultra-low latency optical bus interconnects.',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$1,299.00',
                      style: AppTextStyle.body.copyWith(
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.rocket_launch_rounded, size: 16),
                      label: const Text('Deploy Unit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── 4. Live Event Log / Activity Feed ────────────────────────────
        ByAutoShimmer(
          isLoading: _isPreloading,
          direction: _direction,
          shimmerWaveWidth: _shimmerWaveWidth,
          enableDynamicBorderPulse: _enablePulse,
          enableLaserReveal: _enableLaserReveal,
          laserColors: laserColors,
          dynamicBorderWidth: _dynamicBorderWidth,
          dynamicBorderGlowBlur: _dynamicBorderGlowBlur,
          dynamicBorderDuration: Duration(
            milliseconds: _shimmerDurationMs.toInt(),
          ),
          style: style,
          borderRadius: BorderRadius.circular(16),
          skeletonBuilder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: List.generate(3, (i) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: i < 2 ? 12 : 0),
                    child: Row(
                      children: [
                        ByBone.circular(size: 32, style: style),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ByBone.text(width: 140, height: 12, style: style),
                              const SizedBox(height: 4),
                              ByBone.text(width: 90, height: 10, style: style),
                            ],
                          ),
                        ),
                        ByBone.text(width: 50, height: 10, style: style),
                      ],
                    ),
                  );
                }),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                _buildActivityRow(
                  colors: colors,
                  icon: Icons.cloud_done_rounded,
                  iconColor: AppColors.primary,
                  title: 'Core Neural Shards Synchronized',
                  subtitle: 'Cluster deployment #4829 successfully converged',
                  time: '12s ago',
                ),
                Divider(color: colors.borderSubtle, height: 16),
                _buildActivityRow(
                  colors: colors,
                  icon: Icons.shield_rounded,
                  iconColor: AppColors.primary,
                  title: 'mTLS Security Handshake Renewed',
                  subtitle: 'Zero-trust authentication verified for gateway-02',
                  time: '2m ago',
                ),
                Divider(color: colors.borderSubtle, height: 16),
                _buildActivityRow(
                  colors: colors,
                  icon: Icons.tune_rounded,
                  iconColor: AppColors.primary,
                  title: 'Optical Bus Re-balanced',
                  subtitle: 'Automated telemetry load shedding completed',
                  time: '6m ago',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricSkeletonCard({
    required BySkeletonStyle style,
    required List<Color> laserColors,
    required AppColorPalette colors,
    required String label,
    required String value,
    required String trend,
    required bool isPositive,
    required IconData icon,
  }) {
    return ByAutoShimmer(
      isLoading: _isPreloading,
      direction: _direction,
      shimmerWaveWidth: _shimmerWaveWidth,
      enableDynamicBorderPulse: _enablePulse,
      enableLaserReveal: _enableLaserReveal,
      laserColors: laserColors,
      dynamicBorderWidth: _dynamicBorderWidth,
      dynamicBorderGlowBlur: _dynamicBorderGlowBlur,
      dynamicBorderDuration: Duration(milliseconds: _shimmerDurationMs.toInt()),
      style: style,
      borderRadius: BorderRadius.circular(14),
      skeletonBuilder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ByBone.circular(size: 20, style: style),
                  ByBone.rect(
                    width: 56,
                    height: 18,
                    borderRadius: BorderRadius.circular(6),
                    style: style,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ByBone.rect(
                width: double.infinity,
                height: 12,
                borderRadius: BorderRadius.circular(4),
                style: style,
              ),
              const SizedBox(height: 6),
              ByBone.rect(
                width: double.infinity,
                height: 18,
                borderRadius: BorderRadius.circular(4),
                style: style,
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
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
                Icon(icon, size: 20, color: AppColors.primary),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.success : AppColors.warning)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      color: isPositive ? AppColors.success : AppColors.warning,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyle.caption.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyle.body.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRow({
    required AppColorPalette colors,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
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
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: AppTextStyle.caption.copyWith(
            color: colors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniSkeletonCard(AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: const Column(
        children: [
          ByBone.circular(size: 28),
          SizedBox(height: 8),
          ByBone.text(width: 50, height: 10),
          SizedBox(height: 4),
          ByBone.text(width: 35, height: 8),
        ],
      ),
    );
  }
}
