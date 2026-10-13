import 'dart:async';

import 'package:by_ui/by_ui.dart';
import 'package:flutter/material.dart';

import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_color_palette.dart';
import '../widgets/by_drawer.dart';
import '../widgets/by_showcase_choice_chip.dart';
import '../widgets/by_showcase_header.dart';
import '../widgets/widget_params_dialog.dart';
import 'app_bar_showcase_screen.dart';
import 'card_showcase_screen.dart';
import 'dialog_showcase_screen.dart';
import 'sequence_showcase_screen.dart';
import 'toast_showcase_screen.dart';

/// Interactive showcase screen for the [ByButton] flagship button component.
class ButtonShowcaseScreen extends StatefulWidget {
  const ButtonShowcaseScreen({super.key});

  @override
  State<ButtonShowcaseScreen> createState() => _ButtonShowcaseScreenState();
}

class _ButtonShowcaseScreenState extends State<ButtonShowcaseScreen> {
  // 1. Transactional & State Controls
  bool _isEnabled = true;
  bool _isLoading = false;
  bool _useAutoAsync = true;
  ByButtonState _manualState = ByButtonState.idle;

  // 2. Content & Elements
  String _buttonLabel = 'Get Started';
  bool _showPrefix = true;
  bool _showSuffix = true;
  bool _showBadge = false;

  // 3. Variant, Sizing & Geometry
  ByButtonVariant _variant = ByButtonVariant.filled;
  ByButtonSize _size = ByButtonSize.medium;
  bool _isFullWidth = false;
  double _customRadius = 28.0;
  double _customBorderWidth = 0.0;
  double? _customLoadingBorderWidth;

  double get _effectiveLoadingBorderWidth {
    if (_customLoadingBorderWidth != null) {
      return _customLoadingBorderWidth!;
    }
    return _customBorderWidth > 0.0 ? _customBorderWidth : 2.5;
  }

  // 4. Surface & Border Coloring
  int _selectedBgColorIndex = 0;
  int _selectedFgColorIndex = 0;
  int _selectedBorderColorIndex = 0;
  int _selectedSuccessIconColorIndex = 0;
  int _selectedErrorIconColorIndex = 0;
  bool _enableResultIconGradient = false;

  // 5. Pulse Dynamic Border (Periodic & Customization)
  late ByDynamicBorderController _dynamicBorderController;
  bool _enableDynamicBorder = true;
  double _periodicIntervalSeconds = 4.0;
  int _pulseDurationMs = 1400;
  double _pulseBeamLength = 0.28;
  double _pulseShadowBlur = 10.0;
  double _pulseShadowWidth = 3.0;
  ByBorderOrigin _pulseOrigin = ByBorderOrigin.topLeft;
  int _selectedPulseColorPaletteIndex = 0;
  bool _enablePulseGradient = false;
  int _selectedPulseGradientStyleIndex = 0;

  // 6. Micro-Interactions & Ambient Feedback
  bool _enablePressScale = true;
  bool _enableStateTransitionPulse = true;
  bool _enableShimmer = false;
  bool _enableAmbientPulse = false;

  // Active preset tracker (-1 if custom)
  int _activePresetIndex = 0;

  @override
  void initState() {
    super.initState();
    _dynamicBorderController = ByDynamicBorderController();
  }

  @override
  void dispose() {
    _dynamicBorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        final colors = AppColors.of(context);
        final isDark = AppThemeStore.instance.isDarkMode(context);

        // Color palettes - Vibrant Cyan is first & default
        final bgColorOptions = <Map<String, dynamic>>[
          {'name': 'Vibrant Cyan (Default)', 'color': const Color(0xFF06B6D4)},
          {'name': 'Sky Cyan', 'color': AppColors.cyanAccent},
          {'name': 'Primary Indigo', 'color': AppColors.primary},
          {'name': 'Violet Neon', 'color': AppColors.primaryAccent},
          {'name': 'Emerald Mint', 'color': AppColors.success},
          {'name': 'Amber Sunset', 'color': AppColors.warning},
          {'name': 'Crimson Passion', 'color': AppColors.error},
          {'name': 'Card Slate', 'color': colors.cardBg},
          {'name': 'Pure White', 'color': Colors.white},
          {'name': 'Pure Black', 'color': Colors.black},
        ];

        // Foreground color options - Contrast dynamic is first & default
        final fgColorOptions = <Map<String, dynamic>>[
          {
            'name': 'Theme Contrast (${isDark ? "White" : "Black"})',
            'color': isDark ? Colors.white : Colors.black,
          },
          {'name': 'Pure White', 'color': Colors.white},
          {'name': 'Pure Black', 'color': Colors.black},
          {'name': 'Dark Slate', 'color': const Color(0xFF0F172A)},
          {'name': 'Primary Indigo', 'color': AppColors.primary},
          {'name': 'Emerald Mint', 'color': AppColors.success},
          {'name': 'Amber Sunset', 'color': AppColors.warning},
          {'name': 'Sky Cyan', 'color': AppColors.cyanAccent},
        ];

        // Border color options - Contrast dynamic is first & default (White on dark, Black on light)
        final borderColorOptions = <Map<String, dynamic>>[
          {
            'name': 'Theme Contrast (${isDark ? "White" : "Black"})',
            'color': isDark ? Colors.white : Colors.black,
          },
          {'name': 'Pure White', 'color': Colors.white},
          {'name': 'Pure Black', 'color': Colors.black},
          {'name': 'Sky Cyan', 'color': AppColors.cyanAccent},
          {'name': 'Primary Indigo', 'color': AppColors.primary},
          {'name': 'Emerald Mint', 'color': AppColors.success},
          {'name': 'Amber Sunset', 'color': AppColors.warning},
          {'name': 'Crimson Passion', 'color': AppColors.error},
          {'name': 'Transparent', 'color': Colors.transparent},
        ];

        // Success checkmark color options
        final successIconOptions = <Map<String, dynamic>>[
          {
            'name': 'Match Foreground (${isDark ? "White" : "Black"})',
            'color': isDark ? Colors.white : Colors.black,
          },
          {'name': 'Emerald Mint (Default)', 'color': AppColors.success},
          {'name': 'Neon Lime Green', 'color': const Color(0xFF84CC16)},
          {'name': 'Sky Cyan', 'color': AppColors.cyanAccent},
          {'name': 'Vibrant Cyan Accent', 'color': const Color(0xFF06B6D4)},
          {'name': 'Electric Violet', 'color': AppColors.primaryAccent},
          {'name': 'Pure White', 'color': Colors.white},
          {'name': 'Pure Black', 'color': Colors.black},
          {'name': 'Solar Amber', 'color': AppColors.warning},
          {'name': 'Coral Rose', 'color': const Color(0xFFFB7185)},
          {'name': 'Golden Champagne', 'color': const Color(0xFFF59E0B)},
          {'name': 'Silver Slate', 'color': const Color(0xFF94A3B8)},
        ];

        // Error cross (X) color options
        final errorIconOptions = <Map<String, dynamic>>[
          {
            'name': 'Match Foreground (${isDark ? "White" : "Black"})',
            'color': isDark ? Colors.white : Colors.black,
          },
          {'name': 'Crimson Flare (Default)', 'color': AppColors.error},
          {'name': 'Neon Ruby Red', 'color': const Color(0xFFDC2626)},
          {'name': 'Solar Amber', 'color': AppColors.warning},
          {'name': 'Electric Violet', 'color': AppColors.primaryAccent},
          {'name': 'Sky Cyan', 'color': AppColors.cyanAccent},
          {'name': 'Pure White', 'color': Colors.white},
          {'name': 'Pure Black', 'color': Colors.black},
          {'name': 'Sunset Orange', 'color': const Color(0xFFEA580C)},
          {'name': 'Hot Magenta', 'color': const Color(0xFFD946EF)},
          {'name': 'Golden Bronze', 'color': const Color(0xFFD97706)},
          {'name': 'Silver Slate', 'color': const Color(0xFF94A3B8)},
        ];

        final pulsePaletteOptions = <Map<String, dynamic>>[
          {
            'name': 'Theme onSurface (${isDark ? "White" : "Black"}) (Default)',
            'color': isDark ? Colors.white : Colors.black,
            'colors': isDark
                ? const [Colors.white, Color(0xFFE2E8F0)]
                : const [Colors.black, Color(0xFF334155)],
            'gradient': isDark
                ? const LinearGradient(
                    colors: [Colors.white, Color(0xFF94A3B8)],
                  )
                : const LinearGradient(
                    colors: [Colors.black, Color(0xFF475569)],
                  ),
          },
          {
            'name': 'Cyan-Indigo-Purple Gradient',
            'color': AppColors.cyanAccent,
            'colors': const [
              Color(0xFF38BDF8),
              Color(0xFF6366F1),
              Color(0xFFA855F7),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFF38BDF8), Color(0xFF6366F1), Color(0xFFA855F7)],
            ),
          },
          {
            'name': 'Neon Sky Cyan',
            'color': const Color(0xFF38BDF8),
            'colors': const [Color(0xFF38BDF8)],
            'gradient': const LinearGradient(
              colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
            ),
          },
          {
            'name': 'Electric Violet & Magenta',
            'color': AppColors.primaryAccent,
            'colors': const [
              Color(0xFF8B5CF6),
              Color(0xFFA855F7),
              Color(0xFFD946EF),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFA855F7), Color(0xFFD946EF)],
            ),
          },
          {
            'name': 'Emerald & Mint Cyber',
            'color': AppColors.success,
            'colors': const [
              Color(0xFF10B981),
              Color(0xFF34D399),
              Color(0xFF059669),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF059669)],
            ),
          },
          {
            'name': 'Solar Sunset Amber',
            'color': AppColors.warning,
            'colors': const [
              Color(0xFFF59E0B),
              Color(0xFFFBBF24),
              Color(0xFFD97706),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFFBBF24), Color(0xFFD97706)],
            ),
          },
          {
            'name': 'Crimson Flare & Ruby',
            'color': AppColors.error,
            'colors': const [
              Color(0xFFEF4444),
              Color(0xFFF87171),
              Color(0xFFDC2626),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFF87171), Color(0xFFDC2626)],
            ),
          },
          {
            'name': 'Cyberpunk Neon (Yellow-Pink-Cyan)',
            'color': const Color(0xFFFF007F),
            'colors': const [
              Color(0xFFFF007F),
              Color(0xFFFEE440),
              Color(0xFF00F0FF),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFFFF007F), Color(0xFFFEE440), Color(0xFF00F0FF)],
            ),
          },
          {
            'name': 'Aurora Borealis (Teal & Violet)',
            'color': const Color(0xFF00F5D4),
            'colors': const [
              Color(0xFF00F5D4),
              Color(0xFF7B2CBF),
              Color(0xFF00BBF9),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFF00F5D4), Color(0xFF7B2CBF), Color(0xFF00BBF9)],
            ),
          },
          {
            'name': 'Sunset Blaze (Coral & Orange)',
            'color': const Color(0xFFFF6B6B),
            'colors': const [
              Color(0xFFFF6B6B),
              Color(0xFFFFA07A),
              Color(0xFFFF4500),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFFA07A), Color(0xFFFF4500)],
            ),
          },
          {
            'name': 'Deep Ocean & Sapphire',
            'color': const Color(0xFF2563EB),
            'colors': const [
              Color(0xFF1D4ED8),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6), Color(0xFF60A5FA)],
            ),
          },
          {
            'name': 'Golden Luxury & Champagne',
            'color': const Color(0xFFD97706),
            'colors': const [
              Color(0xFFB45309),
              Color(0xFFF59E0B),
              Color(0xFFFDE68A),
            ],
            'gradient': const LinearGradient(
              colors: [Color(0xFFB45309), Color(0xFFF59E0B), Color(0xFFFDE68A)],
            ),
          },
          {
            'name': 'Pure White Neon',
            'color': Colors.white,
            'colors': const [Colors.white],
            'gradient': const LinearGradient(
              colors: [Colors.white, Color(0xFFCBD5E1)],
            ),
          },
          {
            'name': 'Pure Black Laser',
            'color': Colors.black,
            'colors': const [Colors.black],
            'gradient': const LinearGradient(
              colors: [Colors.black, Color(0xFF475569)],
            ),
          },
        ];

        final selectedBeamColors =
            (pulsePaletteOptions[_selectedPulseColorPaletteIndex.clamp(
                      0,
                      pulsePaletteOptions.length - 1,
                    )]['colors']
                    as List)
                .cast<Color>();

        Gradient? pulseGradient;
        if (_enablePulseGradient) {
          final currentPalette =
              pulsePaletteOptions[_selectedPulseColorPaletteIndex.clamp(
                0,
                pulsePaletteOptions.length - 1,
              )];
          final baseGradient = currentPalette['gradient'] as Gradient?;
          final gradientColors = selectedBeamColors.length > 1
              ? selectedBeamColors
              : (baseGradient?.colors ??
                    [
                      selectedBeamColors.first,
                      selectedBeamColors.first.withValues(alpha: 0.25),
                    ]);

          pulseGradient = switch (_selectedPulseGradientStyleIndex) {
            1 => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradientColors,
            ),
            2 => SweepGradient(
              colors: [...gradientColors, gradientColors.first],
            ),
            3 => RadialGradient(colors: gradientColors),
            _ => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          };
        }

        final dynamicBorderConfig = _enableDynamicBorder
            ? ByDynamicBorder(
                controller: _dynamicBorderController,
                periodicInterval: Duration(
                  milliseconds: (_periodicIntervalSeconds * 1000).toInt(),
                ),
                duration: Duration(milliseconds: _pulseDurationMs),
                beamLength: _pulseBeamLength,
                width: _customBorderWidth > 0 ? _customBorderWidth : 2.5,
                shadowBlur: _pulseShadowBlur,
                shadowWidth: _pulseShadowWidth,
                origin: _pulseOrigin,
                colors: selectedBeamColors,
                gradient: pulseGradient,
                repeatCount: null,
                autoStart: true,
              )
            : null;

        final currentBgColor =
            bgColorOptions[_selectedBgColorIndex.clamp(
                  0,
                  bgColorOptions.length - 1,
                )]['color']
                as Color;

        final currentFgColor =
            fgColorOptions[_selectedFgColorIndex.clamp(
                  0,
                  fgColorOptions.length - 1,
                )]['color']
                as Color;

        final currentBorderColor =
            borderColorOptions[_selectedBorderColorIndex.clamp(
                  0,
                  borderColorOptions.length - 1,
                )]['color']
                as Color;

        final currentSuccessIconColor = _selectedSuccessIconColorIndex == 0
            ? null
            : successIconOptions[_selectedSuccessIconColorIndex.clamp(
                    0,
                    successIconOptions.length - 1,
                  )]['color']
                  as Color;

        final currentErrorIconColor = _selectedErrorIconColorIndex == 0
            ? null
            : errorIconOptions[_selectedErrorIconColorIndex.clamp(
                    0,
                    errorIconOptions.length - 1,
                  )]['color']
                  as Color;

        return ByScrollScope(
          child: Scaffold(
            backgroundColor: colors.scaffoldBg,
            extendBodyBehindAppBar: true,
            // 1. UNIFORM APPBAR SPECIFICATION
            appBar: ByAppBar(
              child: ByShowcaseHeader(
                componentName: 'ByButton',
                onReset: _resetToDefaults,
                onOpenParams: () => _showParamsDialog(context),
              ),
            ),

            // 2. UNIFORM DRAWER NAVIGATION
            drawer: ByDrawer(
              activeComponent: 'ByButton',
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
                } else if (comp == 'ByAppBar') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppBarShowcaseScreen(),
                    ),
                  );
                } else if (comp == 'BySequence') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SequenceShowcaseScreen(),
                    ),
                  );
                }
              },
            ),

            // 3. COMPACT 5-LAYER LISTVIEW HIERARCHY
            body: ListView(
              padding: EdgeInsets.fromLTRB(
                12,
                ByAppBar.getContentTopPadding(context, extra: 10),
                12,
                24,
              ),
              children: [
                // ── LAYER 1: Active Configuration Preview ───────────────────
                _buildConfigurationPreview(colors),
                const SizedBox(height: 12),

                // ── LAYER 2: Preset Example Card ────────────────────────────
                _buildPresetCard(colors),
                const SizedBox(height: 12),

                // ── LAYER 3: Integrated with ByDynamicBorder ────────────────
                _buildDynamicBorderIntegrationCard(colors),
                const SizedBox(height: 14),

                // ── LAYER 4: Standalone Widget Display: Hero Live Button ───
                _buildHeroButton(
                  colors: colors,
                  activeBgColor: currentBgColor,
                  activeFgColor: currentFgColor,
                  activeBorderColor: currentBorderColor,
                  customBorderWidth: _customBorderWidth,
                  successIconColor: currentSuccessIconColor,
                  errorIconColor: currentErrorIconColor,
                  dynamicBorderConfig: dynamicBorderConfig,
                  selectedBeamColors: selectedBeamColors,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                // ── LAYER 5: Numbered Setup Sections ────────────────────────
                // Section 1: Button States, Async & Morphing
                _buildControlCard(
                  colors: colors,
                  title: '1. BUTTON STATES, ASYNC & MORPHING',
                  icon: Icons.sync_rounded,
                  children: [
                    ByShowcaseSwitchTile(
                      title: 'Enabled State',
                      subtitle:
                          'Toggle to watch the radiant topLeft transition pulse sweep the border',
                      value: _isEnabled,
                      onChanged: (val) {
                        setState(() {
                          _isEnabled = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Auto-Async Handler (2s Future)',
                      subtitle:
                          'Awaits simulated API call, shrinks into a circle, and shows success icon',
                      value: _useAutoAsync,
                      onChanged: (val) {
                        setState(() {
                          _useAutoAsync = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Loading Override (Circle Morph)',
                      subtitle:
                          'Force button into circular 3-phase pulse spinner without tap',
                      value: _isLoading,
                      onChanged: (val) {
                        setState(() {
                          _isLoading = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Manual Transactional State:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ByButtonState.values.map((state) {
                          final isSelected = _manualState == state;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: BySelectOption(
                              label: Text(state.name.toUpperCase()),
                              isSelected: isSelected,
                              selectedBorderColor: AppColors.primary,
                              unselectedBorderColor: colors.borderSubtle,
                              selectedBackgroundColor: colors.chipSelectedBg,
                              unselectedBackgroundColor: colors.chipBg,
                              selectedTextColor: isDark
                                  ? Colors.white
                                  : Colors.black,
                              unselectedTextColor: colors.textMuted,
                              onTap: () {
                                setState(() {
                                  _manualState = state;
                                  _activePresetIndex = -1;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Success Checkmark Icon Color:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ByColorPalette(
                      items: successIconOptions
                          .map(
                            (opt) => ByColorPaletteItem.fromColor(
                              opt['color'] as Color,
                              opt['name'] as String,
                            ),
                          )
                          .toList(),
                      selectedIndex: _selectedSuccessIconColorIndex,
                      onSelected: (index) {
                        setState(() {
                          _selectedSuccessIconColorIndex = index;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error Cross (X) Icon Color:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ByColorPalette(
                      items: errorIconOptions
                          .map(
                            (opt) => ByColorPaletteItem.fromColor(
                              opt['color'] as Color,
                              opt['name'] as String,
                            ),
                          )
                          .toList(),
                      selectedIndex: _selectedErrorIconColorIndex,
                      onSelected: (index) {
                        setState(() {
                          _selectedErrorIconColorIndex = index;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    ByShowcaseSwitchTile(
                      title: 'Enable Result Icon Gradient',
                      subtitle:
                          'Renders checkmark and cross icons with radiant multi-stop gradient shader',
                      value: _enableResultIconGradient,
                      onChanged: (val) {
                        setState(() {
                          _enableResultIconGradient = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 2: Content, Prefix, Suffix & Badge
                _buildControlCard(
                  colors: colors,
                  title: '2. CONTENT, PREFIX, SUFFIX & BADGE',
                  icon: Icons.widgets_rounded,
                  children: [
                    ByShowcaseSwitchTile(
                      title: 'Show Leading Icon (Prefix)',
                      subtitle:
                          'Widget prefix displayed before the main child label',
                      value: _showPrefix,
                      onChanged: (val) {
                        setState(() {
                          _showPrefix = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Show Trailing Icon (Suffix)',
                      subtitle:
                          'Widget suffix displayed after the main child label',
                      value: _showSuffix,
                      onChanged: (val) {
                        setState(() {
                          _showSuffix = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Show Corner Badge',
                      subtitle:
                          'Floating notification counter pinned at button corner',
                      value: _showBadge,
                      onChanged: (val) {
                        setState(() {
                          _showBadge = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Button Label Preset:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                              'Get Started',
                              'Checkout Order',
                              'Download Asset',
                              'Submit Feedback',
                            ].map((label) {
                              final isSelected = _buttonLabel == label;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: BySelectOption(
                                  label: Text(label),
                                  isSelected: isSelected,
                                  selectedBorderColor: AppColors.primary,
                                  unselectedBorderColor: colors.borderSubtle,
                                  selectedBackgroundColor:
                                      colors.chipSelectedBg,
                                  unselectedBackgroundColor: colors.chipBg,
                                  selectedTextColor: isDark
                                      ? Colors.white
                                      : Colors.black,
                                  unselectedTextColor: colors.textMuted,
                                  onTap: () {
                                    setState(() {
                                      _buttonLabel = label;
                                      _activePresetIndex = -1;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 3: Dimensions, Sizing & Corner Radius
                _buildControlCard(
                  colors: colors,
                  title: '3. DIMENSIONS, SIZING & CORNER RADIUS',
                  icon: Icons.straighten_rounded,
                  children: [
                    Text(
                      'Button Sizing Preset:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ByButtonSize.values.map((size) {
                          final isSelected = _size == size;
                          final label = switch (size) {
                            ByButtonSize.small => 'Small (36px)',
                            ByButtonSize.medium => 'Medium (48px)',
                            ByButtonSize.large => 'Large (56px)',
                          };
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: BySelectOption(
                              label: Text(label),
                              isSelected: isSelected,
                              selectedBorderColor: AppColors.primary,
                              unselectedBorderColor: colors.borderSubtle,
                              selectedBackgroundColor: colors.chipSelectedBg,
                              unselectedBackgroundColor: colors.chipBg,
                              selectedTextColor: isDark
                                  ? Colors.white
                                  : Colors.black,
                              unselectedTextColor: colors.textMuted,
                              onTap: () {
                                setState(() {
                                  _size = size;
                                  _activePresetIndex = -1;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Corner Radius Customization:',
                          style: AppTextStyle.fieldLabel.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        Text(
                          '${_customRadius.toInt()}px',
                          style: AppTextStyle.captionBold.copyWith(
                            color: AppColors.cyanAccent,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        thumbColor: Colors.white,
                        inactiveTrackColor: colors.borderSubtle,
                        trackHeight: 3.0,
                      ),
                      child: Slider(
                        value: _customRadius,
                        min: 0.0,
                        max: 28.0,
                        divisions: 28,
                        onChanged: (val) {
                          setState(() {
                            _customRadius = val;
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                              {
                                'label': 'Full Pill (28px) (Default)',
                                'radius': 28.0,
                              },
                              {'label': 'Standard (12px)', 'radius': 12.0},
                              {'label': 'Subtle (6px)', 'radius': 6.0},
                              {'label': 'Sharp (0px)', 'radius': 0.0},
                            ].map((item) {
                              final double r = item['radius'] as double;
                              final isSelected =
                                  (_customRadius - r).abs() < 0.5;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: BySelectOption(
                                  label: Text(item['label'] as String),
                                  isSelected: isSelected,
                                  selectedBorderColor: AppColors.primary,
                                  unselectedBorderColor: colors.borderSubtle,
                                  selectedBackgroundColor:
                                      colors.chipSelectedBg,
                                  unselectedBackgroundColor: colors.chipBg,
                                  selectedTextColor: isDark
                                      ? Colors.white
                                      : Colors.black,
                                  unselectedTextColor: colors.textMuted,
                                  onTap: () {
                                    setState(() {
                                      _customRadius = r;
                                      _activePresetIndex = -1;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Idle Border Stroke Width:',
                                style: AppTextStyle.fieldLabel.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              Text(
                                'Stroke width of the perimeter border during standby',
                                style: AppTextStyle.caption.copyWith(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_customBorderWidth.toStringAsFixed(1)}px',
                          style: AppTextStyle.captionBold.copyWith(
                            color: AppColors.cyanAccent,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        thumbColor: Colors.white,
                        inactiveTrackColor: colors.borderSubtle,
                        trackHeight: 3.0,
                      ),
                      child: Slider(
                        value: _customBorderWidth,
                        min: 0.0,
                        max: 5.0,
                        divisions: 10,
                        onChanged: (val) {
                          setState(() {
                            _customBorderWidth = val;
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                              {'label': 'None (0px)', 'width': 0.0},
                              {'label': 'Thin (1.0px)', 'width': 1.0},
                              {'label': 'Standard (1.5px)', 'width': 1.5},
                              {'label': 'Medium (2.5px)', 'width': 2.5},
                              {'label': 'Bold (4.0px)', 'width': 4.0},
                            ].map((item) {
                              final double w = item['width'] as double;
                              final isSelected =
                                  (_customBorderWidth - w).abs() < 0.2;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: BySelectOption(
                                  label: Text(item['label'] as String),
                                  isSelected: isSelected,
                                  selectedBorderColor: AppColors.primary,
                                  unselectedBorderColor: colors.borderSubtle,
                                  selectedBackgroundColor:
                                      colors.chipSelectedBg,
                                  unselectedBackgroundColor: colors.chipBg,
                                  selectedTextColor: isDark
                                      ? Colors.white
                                      : Colors.black,
                                  unselectedTextColor: colors.textMuted,
                                  onTap: () {
                                    setState(() {
                                      _customBorderWidth = w;
                                      _activePresetIndex = -1;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Loading Border Stroke Width:',
                                style: AppTextStyle.fieldLabel.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              Text(
                                'Auto inherits idle border when > 0, or defaults to 2.5px',
                                style: AppTextStyle.caption.copyWith(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _customLoadingBorderWidth != null
                              ? '${_customLoadingBorderWidth!.toStringAsFixed(1)}px'
                              : 'Auto (${_effectiveLoadingBorderWidth.toStringAsFixed(1)}px)',
                          style: AppTextStyle.captionBold.copyWith(
                            color: AppColors.cyanAccent,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        thumbColor: Colors.white,
                        inactiveTrackColor: colors.borderSubtle,
                        trackHeight: 3.0,
                      ),
                      child: Slider(
                        value:
                            (_customLoadingBorderWidth ??
                                    _effectiveLoadingBorderWidth)
                                .clamp(0.5, 6.0),
                        min: 0.5,
                        max: 6.0,
                        divisions: 11,
                        onChanged: (val) {
                          setState(() {
                            _customLoadingBorderWidth = val;
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: BySelectOption(
                              label: Text(
                                'Auto (${_effectiveLoadingBorderWidth.toStringAsFixed(1)}px)',
                              ),
                              isSelected: _customLoadingBorderWidth == null,
                              selectedBorderColor: AppColors.primary,
                              unselectedBorderColor: colors.borderSubtle,
                              selectedBackgroundColor: colors.chipSelectedBg,
                              unselectedBackgroundColor: colors.chipBg,
                              selectedTextColor: isDark
                                  ? Colors.white
                                  : Colors.black,
                              unselectedTextColor: colors.textMuted,
                              onTap: () {
                                setState(() {
                                  _customLoadingBorderWidth = null;
                                  _activePresetIndex = -1;
                                });
                              },
                            ),
                          ),
                          ...[
                            {'label': 'Thin (1.0px)', 'width': 1.0},
                            {'label': 'Standard (1.5px)', 'width': 1.5},
                            {'label': 'Bold (2.5px)', 'width': 2.5},
                            {'label': 'Heavy (3.5px)', 'width': 3.5},
                            {'label': 'Ultra (5.0px)', 'width': 5.0},
                          ].map((item) {
                            final double w = item['width'] as double;
                            final isSelected =
                                _customLoadingBorderWidth != null &&
                                (_customLoadingBorderWidth! - w).abs() < 0.2;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: BySelectOption(
                                label: Text(item['label'] as String),
                                isSelected: isSelected,
                                selectedBorderColor: AppColors.primary,
                                unselectedBorderColor: colors.borderSubtle,
                                selectedBackgroundColor: colors.chipSelectedBg,
                                unselectedBackgroundColor: colors.chipBg,
                                selectedTextColor: isDark
                                    ? Colors.white
                                    : Colors.black,
                                unselectedTextColor: colors.textMuted,
                                onTap: () {
                                  setState(() {
                                    _customLoadingBorderWidth = w;
                                    _activePresetIndex = -1;
                                  });
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ByShowcaseSwitchTile(
                      title: 'Expand to Full Width (280px)',
                      subtitle:
                          'Force fixed width constraint instead of intrinsic content wrap',
                      value: _isFullWidth,
                      onChanged: (val) {
                        setState(() {
                          _isFullWidth = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 4: Color Theme & Surface Styling
                _buildControlCard(
                  colors: colors,
                  title: '4. COLOR THEME & SURFACE STYLING',
                  icon: Icons.palette_rounded,
                  children: [
                    Text(
                      'Visual Variant Preset:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ByButtonVariant.values.map((variant) {
                          final isSelected = _variant == variant;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: BySelectOption(
                              label: Text(variant.name.toUpperCase()),
                              isSelected: isSelected,
                              selectedBorderColor: AppColors.primary,
                              unselectedBorderColor: colors.borderSubtle,
                              selectedBackgroundColor: colors.chipSelectedBg,
                              unselectedBackgroundColor: colors.chipBg,
                              selectedTextColor: isDark
                                  ? Colors.white
                                  : Colors.black,
                              unselectedTextColor: colors.textMuted,
                              onTap: () {
                                setState(() {
                                  _variant = variant;
                                  _activePresetIndex = -1;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Button Background Color:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ByColorPalette(
                      items: bgColorOptions
                          .map(
                            (opt) => ByColorPaletteItem.fromColor(
                              opt['color'] as Color,
                              opt['name'] as String,
                            ),
                          )
                          .toList(),
                      selectedIndex: _selectedBgColorIndex,
                      onSelected: (index) {
                        setState(() {
                          _selectedBgColorIndex = index;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Button Text / Foreground Color:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ByColorPalette(
                      items: fgColorOptions
                          .map(
                            (opt) => ByColorPaletteItem.fromColor(
                              opt['color'] as Color,
                              opt['name'] as String,
                            ),
                          )
                          .toList(),
                      selectedIndex: _selectedFgColorIndex,
                      onSelected: (index) {
                        setState(() {
                          _selectedFgColorIndex = index;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Button Border Stroke Color:',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ByColorPalette(
                      items: borderColorOptions
                          .map(
                            (opt) => ByColorPaletteItem.fromColor(
                              opt['color'] as Color,
                              opt['name'] as String,
                            ),
                          )
                          .toList(),
                      selectedIndex: _selectedBorderColorIndex,
                      onSelected: (index) {
                        setState(() {
                          _selectedBorderColorIndex = index;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 5: Pulse Dynamic Border (Periodic & Customization)
                _buildControlCard(
                  colors: colors,
                  title: '5. PULSE DYNAMIC BORDER (PERIODIC & CUSTOMIZATION)',
                  icon: Icons.blur_circular_rounded,
                  children: [
                    ByShowcaseSwitchTile(
                      title: 'Enable Periodic Pulse Dynamic Border',
                      subtitle:
                          'Sweeps luminous laser beam around perimeter periodically and during loading',
                      value: _enableDynamicBorder,
                      onChanged: (val) {
                        setState(() {
                          _enableDynamicBorder = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    if (_enableDynamicBorder) ...[
                      const SizedBox(height: 12),
                      _buildSliderRow(
                        title: 'Periodic Rest Interval',
                        value: _periodicIntervalSeconds,
                        min: 1.0,
                        max: 10.0,
                        suffix: 's',
                        colors: colors,
                        onChanged: (val) {
                          setState(() {
                            _periodicIntervalSeconds = val;
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                      _buildSliderRow(
                        title: 'Circuit Duration',
                        value: _pulseDurationMs.toDouble(),
                        min: 800.0,
                        max: 3000.0,
                        suffix: 'ms',
                        colors: colors,
                        onChanged: (val) {
                          setState(() {
                            _pulseDurationMs = val.toInt();
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                      _buildSliderRow(
                        title: 'Beam Length (% Perimeter)',
                        value: _pulseBeamLength,
                        min: 0.15,
                        max: 0.50,
                        suffix: 'x',
                        colors: colors,
                        onChanged: (val) {
                          setState(() {
                            _pulseBeamLength = val;
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                      _buildSliderRow(
                        title: 'Outer Shadow Blur Radius',
                        value: _pulseShadowBlur,
                        min: 0.0,
                        max: 16.0,
                        suffix: 'px',
                        colors: colors,
                        onChanged: (val) {
                          setState(() {
                            _pulseShadowBlur = val;
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                      _buildSliderRow(
                        title: 'Outer Shadow Thickness',
                        value: _pulseShadowWidth,
                        min: 1.0,
                        max: 8.0,
                        suffix: 'px',
                        colors: colors,
                        onChanged: (val) {
                          setState(() {
                            _pulseShadowWidth = val;
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Pulse Origin Point (Point A):',
                        style: AppTextStyle.fieldLabel.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              [
                                ByBorderOrigin.topLeft,
                                ByBorderOrigin.topCenter,
                                ByBorderOrigin.topRight,
                                ByBorderOrigin.bottomCenter,
                              ].map((origin) {
                                final isSelected = _pulseOrigin == origin;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: BySelectOption(
                                    label: Text(origin.name),
                                    isSelected: isSelected,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () {
                                      setState(() {
                                        _pulseOrigin = origin;
                                        _activePresetIndex = -1;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Traveling Beam Color Palette:',
                        style: AppTextStyle.fieldLabel.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ByColorPalette(
                        items: pulsePaletteOptions
                            .map(
                              (opt) => ByColorPaletteItem.fromColor(
                                opt['color'] as Color,
                                opt['name'] as String,
                              ),
                            )
                            .toList(),
                        selectedIndex: _selectedPulseColorPaletteIndex,
                        onSelected: (index) {
                          setState(() {
                            _selectedPulseColorPaletteIndex = index;
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      ByShowcaseSwitchTile(
                        title: 'Enable Pulse Beam Gradient',
                        subtitle:
                            'Applies dynamic multi-color shader gradient across the traveling pulse beam',
                        value: _enablePulseGradient,
                        onChanged: (val) {
                          setState(() {
                            _enablePulseGradient = val;
                            _activePresetIndex = -1;
                          });
                        },
                      ),
                      if (_enablePulseGradient) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Pulse Gradient Shader Style:',
                          style: AppTextStyle.fieldLabel.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                [
                                  'Linear (Diagonal)',
                                  'Linear (Horizontal)',
                                  'Sweep (360°)',
                                  'Radial Bloom',
                                ].asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final label = entry.value;
                                  final isSelected =
                                      _selectedPulseGradientStyleIndex == idx;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: BySelectOption(
                                      label: Text(label),
                                      isSelected: isSelected,
                                      selectedBorderColor: AppColors.primary,
                                      unselectedBorderColor:
                                          colors.borderSubtle,
                                      selectedBackgroundColor:
                                          colors.chipSelectedBg,
                                      unselectedBackgroundColor: colors.chipBg,
                                      selectedTextColor: isDark
                                          ? Colors.white
                                          : Colors.black,
                                      unselectedTextColor: colors.textMuted,
                                      onTap: () {
                                        setState(() {
                                          _selectedPulseGradientStyleIndex =
                                              idx;
                                          _activePresetIndex = -1;
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _enableDynamicBorder
                              ? () => _dynamicBorderController.pulse()
                              : null,
                          icon: const Icon(Icons.bolt_rounded, size: 20),
                          label: const Text('Trigger Instant Pulse Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: colors.borderSubtle,
                            disabledForegroundColor: colors.textMuted,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // Section 6: Tactile Scale & Micro-Interactions
                _buildControlCard(
                  colors: colors,
                  title: '6. TACTILE SCALE & MICRO-INTERACTIONS',
                  icon: Icons.touch_app_rounded,
                  children: [
                    ByShowcaseSwitchTile(
                      title: 'Tactile Spring Press Scale (0.96x)',
                      subtitle:
                          'Scales down smoothly on press and snaps back with elastic bounce',
                      value: _enablePressScale,
                      onChanged: (val) {
                        setState(() {
                          _enablePressScale = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Enable State Transition Pulse',
                      subtitle:
                          'Sweeps contrast border on enable/disable (defaults to Theme onSurface)',
                      value: _enableStateTransitionPulse,
                      onChanged: (val) {
                        setState(() {
                          _enableStateTransitionPulse = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'Surface Shimmer Sheen Pass',
                      subtitle:
                          'Diagonal specular highlight sweeping across the button surface',
                      value: _enableShimmer,
                      onChanged: (val) {
                        setState(() {
                          _enableShimmer = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ByShowcaseSwitchTile(
                      title: 'CTA Ambient Border Pulse',
                      subtitle:
                          'Periodic subtle neon pulse to draw user attention to high-value actions',
                      value: _enableAmbientPulse,
                      onChanged: (val) {
                        setState(() {
                          _enableAmbientPulse = val;
                          _activePresetIndex = -1;
                        });
                      },
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

  // ── LAYER 1: Active Configuration Preview ──────────────────────────────
  Widget _buildConfigurationPreview(AppColorPalette colors) {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: colors.cardBg,
      borderColor: colors.border,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Configuration Preview',
                      style: AppTextStyle.sectionHeader.copyWith(
                        color: colors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Live metrics for ByButton morphing & interaction state',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ByMetricBadge(
                label: 'Status',
                value: _isEnabled ? 'Enabled' : 'Disabled',
              ),
              ByMetricBadge(
                label: 'State',
                value: _manualState != ByButtonState.idle
                    ? _manualState.name.toUpperCase()
                    : (_isLoading ? 'LOADING' : 'IDLE'),
              ),
              ByMetricBadge(
                label: 'Variant',
                value: _variant.name.toUpperCase(),
              ),
              ByMetricBadge(
                label: 'Radius',
                value: _customRadius >= 24.0
                    ? 'Full Pill (${_customRadius.toInt()}px)'
                    : '${_customRadius.toInt()}px',
              ),
              ByMetricBadge(
                label: 'Size',
                value: switch (_size) {
                  ByButtonSize.small => 'Small (36px)',
                  ByButtonSize.medium => 'Medium (48px)',
                  ByButtonSize.large => 'Large (56px)',
                },
              ),
              ByMetricBadge(
                label: 'Async',
                value: _useAutoAsync ? 'Active' : 'Sync',
              ),
              ByMetricBadge(
                label: 'Idle Border',
                value: '${_customBorderWidth.toStringAsFixed(1)}px',
              ),
              ByMetricBadge(
                label: 'Loading Border',
                value: _customLoadingBorderWidth != null
                    ? '${_customLoadingBorderWidth!.toStringAsFixed(1)}px'
                    : 'Auto (${_effectiveLoadingBorderWidth.toStringAsFixed(1)}px)',
              ),
              ByMetricBadge(
                label: 'Pulse Beam',
                value: _enableDynamicBorder
                    ? (_enablePulseGradient ? 'Gradient' : 'Active')
                    : 'Off',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── LAYER 2: Preset Example Card ───────────────────────────────────────
  Widget _buildPresetCard(AppColorPalette colors) {
    final presets = [
      {
        'title': 'Primary Filled',
        'color': AppColors.primary,
        'action': () {
          setState(() {
            _activePresetIndex = 0;
            _variant = ByButtonVariant.filled;
            _isEnabled = true;
            _isLoading = false;
            _useAutoAsync = true;
            _buttonLabel = 'Primary Action';
            _selectedBgColorIndex = 0;
            _selectedFgColorIndex = 0;
            _selectedBorderColorIndex = 0;
            _customBorderWidth = 0.0;
            _selectedSuccessIconColorIndex = 0;
            _selectedErrorIconColorIndex = 0;
            _customRadius = 28.0;
            _selectedPulseColorPaletteIndex = 0;
            _enablePulseGradient = false;
            _enableResultIconGradient = false;
            _showPrefix = true;
            _showSuffix = true;
            _showBadge = false;
          });
        },
      },
      {
        'title': 'Futuristic Gradient',
        'color': AppColors.primaryAccent,
        'action': () {
          setState(() {
            _activePresetIndex = 1;
            _variant = ByButtonVariant.gradient;
            _isEnabled = true;
            _isLoading = false;
            _useAutoAsync = true;
            _buttonLabel = 'Launch Rocket';
            _customBorderWidth = 0.0;
            _customRadius = 14.0;
            _enableShimmer = true;
            _showPrefix = true;
            _showSuffix = true;
            _showBadge = false;
          });
        },
      },
      {
        'title': 'Auto-Async Flow',
        'color': AppColors.cyanAccent,
        'action': () {
          setState(() {
            _activePresetIndex = 2;
            _variant = ByButtonVariant.filled;
            _isEnabled = true;
            _isLoading = false;
            _useAutoAsync = true;
            _buttonLabel = 'Click to Load';
            _selectedBgColorIndex = 2;
            _selectedFgColorIndex = 1;
            _customBorderWidth = 0.0;
            _showPrefix = true;
            _showSuffix = false;
          });
        },
      },
      {
        'title': 'Success Morph',
        'color': AppColors.success,
        'action': () {
          setState(() {
            _activePresetIndex = 3;
            _variant = ByButtonVariant.filled;
            _isEnabled = true;
            _manualState = ByButtonState.success;
            _buttonLabel = 'Completed';
            _selectedBgColorIndex = 3;
            _selectedFgColorIndex = 0;
            _customBorderWidth = 0.0;
          });
        },
      },
      {
        'title': 'Error Morph',
        'color': AppColors.error,
        'action': () {
          setState(() {
            _activePresetIndex = 4;
            _variant = ByButtonVariant.filled;
            _isEnabled = true;
            _manualState = ByButtonState.error;
            _buttonLabel = 'Failed';
            _selectedBgColorIndex = 5;
            _selectedFgColorIndex = 0;
            _customBorderWidth = 0.0;
          });
        },
      },
      {
        'title': 'Sleek Outline',
        'color': const Color(0xFF38BDF8),
        'action': () {
          setState(() {
            _activePresetIndex = 5;
            _variant = ByButtonVariant.outline;
            _isEnabled = true;
            _isLoading = false;
            _customBorderWidth = 1.5;
            _buttonLabel = 'Secondary Action';
            _showPrefix = false;
            _showSuffix = true;
          });
        },
      },
      {
        'title': 'Ghost Minimal',
        'color': const Color(0xFF8B5CF6),
        'action': () {
          setState(() {
            _activePresetIndex = 6;
            _variant = ByButtonVariant.ghost;
            _isEnabled = true;
            _isLoading = false;
            _customBorderWidth = 0.0;
            _buttonLabel = 'Cancel / Skip';
            _showPrefix = false;
            _showSuffix = false;
          });
        },
      },
      {
        'title': 'Disabled State',
        'color': AppColors.warning,
        'action': () {
          setState(() {
            _activePresetIndex = 7;
            _isEnabled = false;
            _customBorderWidth = 0.0;
            _buttonLabel = 'Action Disabled';
          });
        },
      },
    ];

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
                final isSelected = _activePresetIndex == index;
                final Color themeColor = preset['color'] as Color;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: preset['action'] as VoidCallback,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? themeColor.withValues(alpha: 0.25)
                              : themeColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? themeColor
                                : themeColor.withValues(alpha: 0.35),
                            width: isSelected ? 1.4 : 1.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          preset['title'] as String,
                          style: AppTextStyle.pillButton.copyWith(
                            color: themeColor,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
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

  // ── LAYER 3: Integrated with ByDynamicBorder ────────────────────────────
  Widget _buildDynamicBorderIntegrationCard(AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: colors.bannerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.bannerBorder),
      ),
      child: Row(
        children: [
          const Icon(AppIcons.sparkle, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Integrated with ByDynamicBorder',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: colors.bannerText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ByButton seamlessly integrates ByDynamicBorder for periodic standby sweeps and continuous circular loading pulses.',
                  style: AppTextStyle.caption.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── LAYER 4: Standalone Hero Live Button Preview ────────────────────────
  Widget _buildHeroButton({
    required AppColorPalette colors,
    required Color activeBgColor,
    required Color activeFgColor,
    required Color activeBorderColor,
    required double customBorderWidth,
    Color? successIconColor,
    Color? errorIconColor,
    required ByDynamicBorder? dynamicBorderConfig,
    required List<Color> selectedBeamColors,
    required bool isDark,
  }) {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: colors.cardBg,
      borderColor: colors.border,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
      child: Center(
        child: ByButton(
          variant: _variant,
          size: _size,
          width: _isFullWidth ? 280.0 : null,
          borderRadius: BorderRadius.circular(_customRadius),
          borderWidth: customBorderWidth,
          loadingBorderWidth: _customLoadingBorderWidth,
          borderColor: activeBorderColor,
          backgroundColor: _variant == ByButtonVariant.filled
              ? activeBgColor
              : null,
          foregroundColor: activeFgColor,
          successIconColor: successIconColor,
          errorIconColor: errorIconColor,
          successIconGradient: _enableResultIconGradient
              ? const LinearGradient(
                  colors: [Color(0xFF34D399), Color(0xFF06B6D4)],
                )
              : null,
          errorIconGradient: _enableResultIconGradient
              ? const LinearGradient(
                  colors: [Color(0xFFF87171), Color(0xFFFBBF24)],
                )
              : null,
          isEnabled: _isEnabled,
          isLoading: _isLoading ? true : null,
          state: _manualState,
          enablePressScale: _enablePressScale,
          enableStateTransitionPulse: _enableStateTransitionPulse,
          enableTransitionPulseColors: selectedBeamColors,
          disableTransitionPulseColors:
              ByButtonDefaults.disableTransitionPulseColors,
          enableShimmer: _enableShimmer,
          enableAmbientPulse: _enableAmbientPulse,
          dynamicBorder: dynamicBorderConfig,
          onPressed: _isEnabled
              ? () async {
                  if (_useAutoAsync) {
                    // Simulate asynchronous server or processing action
                    await Future.delayed(const Duration(seconds: 2));
                  }
                }
              : null,
          prefix: _showPrefix ? const Icon(Icons.rocket_launch_rounded) : null,
          suffix: _showSuffix ? const Icon(Icons.arrow_forward_rounded) : null,
          badge: _showBadge
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.0),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : null,
          child: Text(_buttonLabel),
        ),
      ),
    );
  }

  // ── LAYER 5: Helper Control Card Wrapper ────────────────────────────────
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
                '${value.toStringAsFixed(suffix == 'ms' || suffix == 'px' ? 0 : 1)} $suffix',
                style: AppTextStyle.badge.copyWith(color: colors.textPrimary),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              thumbColor: Colors.white,
              inactiveTrackColor: colors.borderSubtle,
              trackHeight: 3.0,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // ── RESET CONFIGURATION TO DEFAULTS ─────────────────────────────────────
  void _resetToDefaults() {
    setState(() {
      _isEnabled = true;
      _isLoading = false;
      _useAutoAsync = true;
      _manualState = ByButtonState.idle;
      _buttonLabel = 'Get Started';
      _showPrefix = true;
      _showSuffix = true;
      _showBadge = false;
      _variant = ByButtonVariant.filled;
      _size = ByButtonSize.medium;
      _isFullWidth = false;
      _customRadius = 28.0;
      _selectedBgColorIndex = 0;
      _selectedFgColorIndex = 0;
      _selectedBorderColorIndex = 0;
      _customBorderWidth = 0.0;
      _customLoadingBorderWidth = null;
      _selectedSuccessIconColorIndex = 0;
      _selectedErrorIconColorIndex = 0;
      _enableResultIconGradient = false;
      _enableDynamicBorder = true;
      _periodicIntervalSeconds = 4.0;
      _pulseDurationMs = 1400;
      _pulseBeamLength = 0.28;
      _pulseShadowBlur = 10.0;
      _pulseShadowWidth = 3.0;
      _pulseOrigin = ByBorderOrigin.topLeft;
      _selectedPulseColorPaletteIndex = 0;
      _enablePulseGradient = false;
      _selectedPulseGradientStyleIndex = 0;
      _enablePressScale = true;
      _enableStateTransitionPulse = true;
      _enableShimmer = false;
      _enableAmbientPulse = false;
      _activePresetIndex = 0;
    });
  }

  // ── WIDGET PARAMETERS REFERENCE DIALOG ──────────────────────────────────
  void _showParamsDialog(BuildContext context) {
    showWidgetParametersDialog(
      context,
      howToTry:
          '💡 How to try: Tap the button to trigger auto-async loading & success morph, toggle the Enabled switch to watch the radiant topLeft pulse sweep the perimeter, or test custom prefix/suffix and color customizations!',
      parameters: const [
        WidgetParamInfo(
          name: 'child',
          type: 'Widget',
          description:
              'The primary widget content (label, text, badge, or custom composition). Strictly NOT constrained to String.',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'onPressed',
          type: 'FutureOr<void> Function()?',
          description:
              'Callback when tapped. When returning a Future, ByButton automatically enters loading state and restores upon completion.',
        ),
        WidgetParamInfo(
          name: 'isEnabled',
          type: 'bool?',
          description:
              'Explicit enabled override. If null, automatically derived from (onPressed != null).',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'isLoading',
          type: 'bool?',
          description:
              'Explicit loading override. When true, morphs width into a perfect 1:1 circle and loops the 3-phase pulse spinner.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'state',
          type: 'ByButtonState',
          description:
              'Transactional state of the button (idle, loading, success, error).',
          defaultValue: 'ByButtonState.idle',
        ),
        WidgetParamInfo(
          name: 'borderRadius',
          type: 'BorderRadius?',
          description:
              'Direct corner radius override. When omitted, resolves from size presets.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'borderWidth',
          type: 'double?',
          description:
              'Perimeter border stroke width during idle / standby state in logical pixels.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'loadingBorderWidth',
          type: 'double?',
          description:
              'Explicit border stroke width override during circular loading state. If omitted (null), automatically inherits idle borderWidth when > 0, or defaults to 2.5px.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'borderColor',
          type: 'Color?',
          description:
              'Direct border color override (defaults to high contrast White for dark mode, Black for light mode).',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'backgroundColor',
          type: 'Color?',
          description:
              'Direct surface background color override with priority over theme defaults (defaults to Cyan #06B6D4).',
          defaultValue: 'Color(0xFF06B6D4)',
        ),
        WidgetParamInfo(
          name: 'foregroundColor',
          type: 'Color?',
          description: 'Direct text and icon color override for high contrast.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'successIconColor',
          type: 'Color?',
          description:
              'Custom color override for the checkmark icon when entering ByButtonState.success.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'successIconGradient',
          type: 'Gradient?',
          description:
              'Custom gradient shader for the checkmark icon when entering ByButtonState.success.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'errorIconColor',
          type: 'Color?',
          description:
              'Custom color override for the cross (X) icon when entering ByButtonState.error.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'errorIconGradient',
          type: 'Gradient?',
          description:
              'Custom gradient shader for the cross (X) icon when entering ByButtonState.error.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'dynamicBorder',
          type: 'ByDynamicBorder?',
          description:
              'Primary dynamic pulse border configuration matching ByCard and ByToast. Governs periodic rest pulses in standby, manual controller triggers, and continuous circular progress indicator loops during loading.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'loadingPulseColors',
          type: 'List<Color>?',
          description:
              'Custom gradient colors for the circular 3-phase loading pulse spinner (used when dynamicBorder is null).',
          defaultValue: '[Sky Cyan, Indigo, Purple]',
        ),
        WidgetParamInfo(
          name: 'loadingPulseGradient',
          type: 'Gradient?',
          description:
              'Custom gradient shader override for the circular loading pulse spinner.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'transitionPulseColors',
          type: 'List<Color>?',
          description:
              'Custom colors for the state transition pulse border when enabled or disabled.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'transitionPulseGradient',
          type: 'Gradient?',
          description:
              'Custom gradient shader for the state transition pulse border when enabled or disabled.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'prefix',
          type: 'Widget?',
          description:
              'Optional widget displayed before the child (e.g. leading icon).',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'suffix',
          type: 'Widget?',
          description:
              'Optional widget displayed after the child (e.g. trailing arrow).',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'spacing',
          type: 'double',
          description:
              'Horizontal spacing between prefix, child, and suffix in logical pixels.',
          defaultValue: '8.0',
        ),
        WidgetParamInfo(
          name: 'badge',
          type: 'Widget?',
          description:
              'Optional floating badge pinned at the corner of the button.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'variant',
          type: 'ByButtonVariant',
          description:
              'Predefined visual variant preset (filled, gradient, outline, ghost).',
          defaultValue: 'ByButtonVariant.filled',
        ),
        WidgetParamInfo(
          name: 'size',
          type: 'ByButtonSize',
          description:
              'Predefined sizing preset (small: 36px, medium: 48px, large: 56px).',
          defaultValue: 'ByButtonSize.medium',
        ),
        WidgetParamInfo(
          name: 'style',
          type: 'ByButtonStyle?',
          description:
              'Comprehensive visual styling specification for background, border, shadows, and cursors.',
          defaultValue: 'null',
        ),
        WidgetParamInfo(
          name: 'enablePressScale',
          type: 'bool',
          description:
              'Whether to scale down slightly on press (tactile spring bounce feedback).',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'enableStateTransitionPulse',
          type: 'bool',
          description:
              'Whether to play a border pulse when isEnabled transitions.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'enableShimmer',
          type: 'bool',
          description:
              'Whether to display a continuous diagonal surface shimmer sheen pass.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'enableAmbientPulse',
          type: 'bool',
          description:
              'Whether to play periodic ambient CTA border pulses on hero buttons.',
          defaultValue: 'false',
        ),
      ],
    );
  }
}
