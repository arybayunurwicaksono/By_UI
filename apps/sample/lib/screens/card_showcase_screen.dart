import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_drawer.dart';
import '../widgets/by_showcase_header.dart';
import '../widgets/by_color_palette.dart';
import '../widgets/by_showcase_choice_chip.dart';
import '../widgets/widget_params_dialog.dart';
import 'app_bar_showcase_screen.dart';
import 'dialog_showcase_screen.dart';
import 'toast_showcase_screen.dart';

/// Interactive showcase screen for the [ByCard] spatial and normal component.
class CardShowcaseScreen extends StatefulWidget {
  const CardShowcaseScreen({super.key});

  @override
  State<CardShowcaseScreen> createState() => _CardShowcaseScreenState();
}

class _CardShowcaseScreenState extends State<CardShowcaseScreen> {
  // Mode configuration
  ByCardVariant _variant = ByCardVariant.dynamicSensor;
  bool _enableSensor = true;
  bool _enableHoverTilt = true;
  bool _enableInnerGlow = false;
  double _innerGlowOpacity = 1.0;

  // Manual tilt coordinates (for simulation on Web/Desktop/Simulator)
  double _tiltX = 0.0;
  double _tiltY = 1.0; // 1.0 = Upright portrait

  // Geometry & Styling configurations
  double _borderWidth = 1.4;
  double _borderRadius = 18.0;
  double _shadowBlur = 20.0;
  double _maxShadowOffset = 12.0;

  // Color & Theme transition testing
  int _selectedBgIndex = 0;
  int _selectedGradientColorAIndex = 0; // Border Gradient Start (Color A)
  int _selectedGradientColorBIndex = 2; // Border Gradient End (Color B)

  // Active preset tracking (-1 if custom)
  int _activePresetIndex = 0;

  // Throttling timestamp to prevent 60 Hz setState CPU contention
  int _lastTiltUpdateTime = 0;

  void _resetToDefaults() {
    setState(() {
      _variant = ByCardVariant.dynamicSensor;
      _enableSensor = true;
      _enableHoverTilt = true;
      _enableInnerGlow = false;
      _innerGlowOpacity = 1.0;
      _tiltX = 0.0;
      _tiltY = 1.0;
      _borderWidth = 1.4;
      _borderRadius = 18.0;
      _shadowBlur = 20.0;
      _maxShadowOffset = 12.0;
      _selectedBgIndex = 0;
      _selectedGradientColorAIndex = 0;
      _selectedGradientColorBIndex = 2;
      _activePresetIndex = 0;
    });
  }

  void _showByCardParams(BuildContext context) {
    showWidgetParametersDialog(
      context,
      parameters: const [
        WidgetParamInfo(
          name: 'child',
          type: 'Widget',
          description: 'Primary widget displayed inside the card container.',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'variant',
          type: 'ByCardVariant',
          description:
              'Visual rendering mode of the card (normal, gradient, or dynamicSensor).',
          defaultValue: 'ByCardVariant.normal',
        ),
        WidgetParamInfo(
          name: 'enableSensor',
          type: 'bool',
          description:
              'Enables physical accelerometer hardware tilt tracking on mobile devices.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'manualTilt',
          type: 'Offset?',
          description:
              'Manual tilt offset coordinates (-1.0 to 1.0) for testing or simulation overrides.',
        ),
        WidgetParamInfo(
          name: 'onTiltChanged',
          type: 'ValueChanged<Offset>?',
          description:
              'Callback fired when spatial tilt coordinates update from sensors or pointer hover.',
        ),
        WidgetParamInfo(
          name: 'enableHoverTilt',
          type: 'bool',
          description:
              'Enables mouse pointer hover tilt parallax effect on Desktop and Web.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'enableInnerGlow',
          type: 'bool',
          description:
              'Enables dynamic specular inner glow / sheen inside the card layout following tilt.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'innerGlowOpacity',
          type: 'double?',
          description:
              'Custom opacity multiplier (0.0 to 1.0) for the dynamic inner sheen.',
        ),
        WidgetParamInfo(
          name: 'innerGlowBlur',
          type: 'double?',
          description:
              'Custom blur radius for the inner glow. Defaults to shadowBlur if omitted.',
        ),
        WidgetParamInfo(
          name: 'backgroundColor',
          type: 'Color?',
          description:
              'Surface fill color of the card with smooth implicit transition.',
        ),
        WidgetParamInfo(
          name: 'borderRadius',
          type: 'BorderRadiusGeometry',
          description: 'Curvature geometry for the card corners.',
          defaultValue: 'BorderRadius.circular(18.0)',
        ),
        WidgetParamInfo(
          name: 'padding',
          type: 'EdgeInsetsGeometry',
          description:
              'Inner spacing between the card borders and child content.',
          defaultValue: 'EdgeInsets.all(16.0)',
        ),
        WidgetParamInfo(
          name: 'margin',
          type: 'EdgeInsetsGeometry?',
          description: 'Outer spacing around the card container.',
        ),
        WidgetParamInfo(
          name: 'borderWidth',
          type: 'double',
          description: 'Stroke width of the card border outline.',
          defaultValue: '1.0',
        ),
        WidgetParamInfo(
          name: 'borderColor',
          type: 'Color?',
          description: 'Solid border outline color used in normal variant.',
        ),
        WidgetParamInfo(
          name: 'borderGradient',
          type: 'Gradient?',
          description:
              'Gradient stroke shader applied to borders in gradient or dynamicSensor variants.',
        ),
        WidgetParamInfo(
          name: 'shadows',
          type: 'List<BoxShadow>?',
          description:
              'List of standard box shadows applied in normal variant.',
        ),
        WidgetParamInfo(
          name: 'shadowGradient',
          type: 'Gradient?',
          description:
              'Color gradient used for directional ambient spatial glow.',
        ),
        WidgetParamInfo(
          name: 'shadowBlur',
          type: 'double',
          description: 'Blur radius for directional ambient spatial glow.',
          defaultValue: '18.0',
        ),
        WidgetParamInfo(
          name: 'maxShadowOffset',
          type: 'double',
          description:
              'Maximum directional translation distance for shadows when tilted.',
          defaultValue: '10.0',
        ),
        WidgetParamInfo(
          name: 'clipBehavior',
          type: 'Clip',
          description: 'Clipping behavior for overflowing child content.',
          defaultValue: 'Clip.antiAlias',
        ),
        WidgetParamInfo(
          name: 'onTap',
          type: 'VoidCallback?',
          description:
              'Optional click/tap interaction callback triggering an InkWell ripple.',
        ),
        WidgetParamInfo(
          name: 'duration',
          type: 'Duration',
          description:
              'Implicit animation duration for color, size, and corner transitions.',
          defaultValue: 'Duration(milliseconds: 300)',
        ),
        WidgetParamInfo(
          name: 'curve',
          type: 'Curve',
          description: 'Easing curve used for implicit animated transitions.',
          defaultValue: 'Curves.easeOutCubic',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        final colors = AppColors.of(context);
        final isDark = AppThemeStore.instance.isDarkMode(context);

        final bgOptions = AppColors.cardBgOptionsFrom(
          isDark: isDark,
          cardBg: colors.cardBg,
        );
        final gradientColorOptions = AppColors.gradientColorOptions;

        final currentBg =
            bgOptions[_selectedBgIndex.clamp(0, bgOptions.length - 1)]['color']
                as Color;
        final colorA =
            gradientColorOptions[_selectedGradientColorAIndex.clamp(
                  0,
                  gradientColorOptions.length - 1,
                )]['color']
                as Color;
        final colorB =
            gradientColorOptions[_selectedGradientColorBIndex.clamp(
                  0,
                  gradientColorOptions.length - 1,
                )]['color']
                as Color;

        // Dynamic dual-tone gradient based on custom selected Color A & Color B
        final borderGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorA, colorB],
        );

        final shadowGradient = RadialGradient(
          center: Alignment.center,
          radius: 1.1,
          colors: [
            colorA.withValues(alpha: 0.35),
            colorB.withValues(alpha: 0.22),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        );

        return ByScrollScope(
          child: Scaffold(
            backgroundColor: colors.scaffoldBg,
            extendBodyBehindAppBar: true,
            appBar: ByAppBar(
              child: ByShowcaseHeader(
                componentName: 'ByCard',
                onReset: _resetToDefaults,
                onOpenParams: () => _showByCardParams(context),
              ),
            ),
            drawer: ByDrawer(
              activeComponent: 'ByCard',
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
                } else if (comp == 'ByAppBar') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppBarShowcaseScreen(),
                    ),
                  );
                }
              },
            ),
            body: ListView(
              padding: EdgeInsets.fromLTRB(
                12,
                ByAppBar.getContentTopPadding(context, extra: 10),
                12,
                20,
              ),
              children: [
              // 1. Active Configuration Preview Card
              _buildActiveConfigPreviewCard(
                colors,
                isDark,
                bgOptions[_selectedBgIndex.clamp(0, bgOptions.length - 1)]['name'] as String,
              ),
              const SizedBox(height: 12),

              // 2. Preset Example Card
              _buildPresetCard(colors, isDark),
              const SizedBox(height: 12),

              // 3. Standalone Widget Display (ByCard)
              _buildHeroPreviewCard(
                colors: colors,
                isDark: isDark,
                currentBg: currentBg,
                colorA: colorA,
                colorB: colorB,
                borderGradient: borderGradient,
                shadowGradient: shadowGradient,
              ),
              const SizedBox(height: 12),

              // Control Card 1: Mode & Interactivity
              _buildControlCard(
                colors: colors,
                title: '1. CARD MODE & SENSOR ACTIVATION',
                icon: AppIcons.tune,
                children: [
                  _buildVariantSelector(colors, isDark),
                  const SizedBox(height: 10),
                  _buildSwitchTile(
                    title: 'Physical Gyroscope & Accelerometer',
                    subtitle: 'Streams live hardware gravity vector on mobile',
                    value: _enableSensor,
                    colors: colors,
                    onChanged: (val) {
                      setState(() {
                        _enableSensor = val;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildSwitchTile(
                    title: 'Desktop/Web Mouse Hover Parallax',
                    subtitle: 'Tilts border highlight based on cursor position',
                    value: _enableHoverTilt,
                    colors: colors,
                    onChanged: (val) {
                      setState(() {
                        _enableHoverTilt = val;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildSwitchTile(
                    title: 'Specular Inner Glow / Sheen',
                    subtitle:
                        'Projects dynamic reflective light sweep inside the card layout',
                    value: _enableInnerGlow,
                    colors: colors,
                    onChanged: (val) {
                      setState(() {
                        _enableInnerGlow = val;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                  if (_enableInnerGlow) ...[
                    const SizedBox(height: 8),
                    _buildSliderRow(
                      title: 'Inner Sheen Opacity',
                      value: _innerGlowOpacity,
                      min: 0.1,
                      max: 1.0,
                      suffix: 'x',
                      colors: colors,
                      onChanged: (val) {
                        setState(() {
                          _innerGlowOpacity = val;
                          _activePresetIndex = -1;
                        });
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),

              // Control Card 2: Manual Tilt Simulation
              _buildControlCard(
                colors: colors,
                title: '2. TILT SIMULATION (WEB / DESKTOP / TESTING)',
                icon: AppIcons.screenRotation,
                children: [
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
                    value: _tiltX,
                    min: -1.0,
                    max: 1.0,
                    activeColor: AppColors.primary,
                    inactiveColor: colors.borderSubtle,
                    onChanged: (val) {
                      setState(() {
                        _tiltX = val;
                        _enableSensor = false;
                        _activePresetIndex = -1;
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
                    value: _tiltY,
                    min: -1.0,
                    max: 1.0,
                    activeColor: AppColors.primary,
                    inactiveColor: colors.borderSubtle,
                    onChanged: (val) {
                      setState(() {
                        _tiltY = val;
                        _enableSensor = false;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Control Card 3: Smooth Color Transitions
              _buildControlCard(
                colors: colors,
                title: '3. COLOR TRANSITIONS & ACCENT PALETTE',
                icon: AppIcons.palette,
                children: [
                  Text(
                    'Card Background Color (Tap to Animate):',
                    style: AppTextStyle.fieldLabel.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ByColorPalette.fromOptions(
                    options: bgOptions,
                    selectedIndex: _selectedBgIndex,
                    onSelected: (index) {
                      setState(() {
                        _selectedBgIndex = index;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Border Gradient — Color A (Start Tone):',
                    style: AppTextStyle.fieldLabel.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ByColorPalette.fromOptions(
                    options: gradientColorOptions,
                    selectedIndex: _selectedGradientColorAIndex,
                    onSelected: (index) {
                      setState(() {
                        _selectedGradientColorAIndex = index;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Border Gradient — Color B (End Tone):',
                    style: AppTextStyle.fieldLabel.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ByColorPalette.fromOptions(
                    options: gradientColorOptions,
                    selectedIndex: _selectedGradientColorBIndex,
                    onSelected: (index) {
                      setState(() {
                        _selectedGradientColorBIndex = index;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  // Live Gradient Preview Bar
                  Container(
                    height: 28,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(colors: [colorA, colorB]),
                      border: Border.all(color: colors.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Gradient Preview (A → B)',
                      style: AppTextStyle.captionBold.copyWith(
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Control Card 4: Geometry & Lighting
              _buildControlCard(
                colors: colors,
                title: '4. GEOMETRY & LIGHTING ADJUSTMENTS',
                icon: AppIcons.tune,
                children: [
                  _buildSliderRow(
                    title: 'Border Width',
                    value: _borderWidth,
                    min: 0.0,
                    max: 4.0,
                    suffix: 'px',
                    colors: colors,
                    onChanged: (val) {
                      setState(() {
                        _borderWidth = val;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                  _buildSliderRow(
                    title: 'Border Radius',
                    value: _borderRadius,
                    min: 6.0,
                    max: 32.0,
                    suffix: 'px',
                    colors: colors,
                    onChanged: (val) {
                      setState(() {
                        _borderRadius = val;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                  _buildSliderRow(
                    title: 'Shadow / Glow Blur',
                    value: _shadowBlur,
                    min: 0.0,
                    max: 36.0,
                    suffix: 'px',
                    colors: colors,
                    onChanged: (val) {
                      setState(() {
                        _shadowBlur = val;
                        _activePresetIndex = -1;
                      });
                    },
                  ),
                  _buildSliderRow(
                    title: 'Max Shadow Shift',
                    value: _maxShadowOffset,
                    min: 2.0,
                    max: 24.0,
                    suffix: 'px',
                    colors: colors,
                    onChanged: (val) {
                      setState(() {
                        _maxShadowOffset = val;
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

  Widget _buildHeroPreviewCard({
    required AppColorPalette colors,
    required bool isDark,
    required Color currentBg,
    required Color colorA,
    required Color colorB,
    required Gradient borderGradient,
    required Gradient shadowGradient,
  }) {
    return Center(
      child: ByCard(
        variant: _variant,
        enableSensor: _enableSensor,
        enableHoverTilt: _enableHoverTilt,
        enableInnerGlow: _enableInnerGlow,
        innerGlowOpacity: _innerGlowOpacity,
        manualTilt: _enableSensor ? null : Offset(_tiltX, _tiltY),
        onTiltChanged: (tilt) {
          if (_enableSensor && mounted) {
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
        backgroundColor: currentBg,
        borderRadius: BorderRadius.circular(_borderRadius),
        borderWidth: _borderWidth,
        borderColor: colors.border,
        borderGradient: borderGradient,
        shadowGradient: shadowGradient,
        shadowBlur: _shadowBlur,
        maxShadowOffset: _maxShadowOffset,
        shadows: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: _shadowBlur,
                  offset: Offset(
                    _tiltX * _maxShadowOffset,
                    _tiltY * _maxShadowOffset,
                  ),
                ),
              ],
        onTap: () {
          // Tap feedback: smoothly cycle background color
          setState(() {
            _selectedBgIndex = (_selectedBgIndex + 1) % 6;
          });
        },
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorA.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colorA.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _variant == ByCardVariant.dynamicSensor
                          ? 'SPATIAL LIGHTING'
                          : _variant == ByCardVariant.gradient
                          ? 'STATIC GRADIENT'
                          : 'NORMAL CARD',
                      style: AppTextStyle.badge.copyWith(color: colorA),
                    ),
                  ),
                  Icon(
                    _variant == ByCardVariant.dynamicSensor
                        ? AppIcons.motion
                        : AppIcons.layers,
                    size: 20,
                    color: colorA,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'ByCard Interactive Pass',
                style: AppTextStyle.sectionHeader.copyWith(
                  color: _selectedBgIndex == 0
                      ? colors.textPrimary
                      : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Hold phone upright or drag tilt sliders to observe the bottom & side directional gradient border and ambient shadow.',
                style: AppTextStyle.body.copyWith(
                  color: _selectedBgIndex == 0
                      ? colors.textSecondary
                      : Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Tilt Vector: (${_tiltX.toStringAsFixed(2)}, ${_tiltY.toStringAsFixed(2)})',
                      style: AppTextStyle.caption.copyWith(
                        color: _selectedBgIndex == 0
                            ? colors.textMuted
                            : Colors.white.withValues(alpha: 0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tap to switch color',
                    style: AppTextStyle.captionBold.copyWith(color: colorA),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetCard(AppColorPalette colors, bool isDark) {
    final presets = [
      (
        name: 'Spatial Aurora',
        color: AppColors.cyanAccent,
        icon: AppIcons.sparkle,
      ),
      (
        name: 'Neon Cyberpunk',
        color: AppColors.primaryAccent,
        icon: AppIcons.bolt,
      ),
      (
        name: 'Minimal Slate',
        color: const Color(0xFF64748B),
        icon: AppIcons.cardNormal,
      ),
      (
        name: 'Elevated Clean',
        color: AppColors.primary,
        icon: AppIcons.star,
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
                final isSelected = _activePresetIndex == index;
                final color = preset.color;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _applyPreset(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.25)
                              : color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? color
                                : color.withValues(alpha: 0.35),
                            width: isSelected ? 1.4 : 1.0,
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
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
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

  Widget _buildActiveConfigPreviewCard(
    AppColorPalette colors,
    bool isDark,
    String currentBgName,
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
                  AppIcons.palette,
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
                      'Live hardware sensor and geometry metrics',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'The interactive ByCard above smoothly re-renders with hardware sensor parallax, dynamic lighting, and customized borders.',
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
              ByMetricBadge(label: 'Variant', value: _variant.name),
              ByMetricBadge(label: 'Background', value: currentBgName),
              ByMetricBadge(
                label: 'Sensor',
                value: _enableSensor ? 'Active' : 'Off',
              ),
              ByMetricBadge(
                label: 'Hover Tilt',
                value: _enableHoverTilt ? 'Active' : 'Off',
              ),
              ByMetricBadge(
                label: 'Inner Sheen',
                value: _enableInnerGlow
                    ? '${(_innerGlowOpacity * 100).toInt()}%'
                    : 'Off',
              ),
              ByMetricBadge(
                label: 'Border',
                value: '${_borderWidth.toStringAsFixed(1)}px',
              ),
              ByMetricBadge(
                label: 'Radius',
                value: '${_borderRadius.toInt()}px',
              ),
              ByMetricBadge(
                label: 'Blur',
                value: '${_shadowBlur.toInt()}px',
              ),
              ByMetricBadge(
                label: 'Vector',
                value:
                    '(${_tiltX.toStringAsFixed(2)}, ${_tiltY.toStringAsFixed(2)})',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyPreset(int index) {
    setState(() {
      _activePresetIndex = index;
      switch (index) {
        case 0: // Spatial Aurora
          _variant = ByCardVariant.dynamicSensor;
          _enableSensor = true;
          _enableHoverTilt = true;
          _tiltX = 0.0;
          _tiltY = 1.0;
          _borderWidth = 1.4;
          _borderRadius = 18.0;
          _shadowBlur = 22.0;
          _maxShadowOffset = 12.0;
          _selectedBgIndex = 0;
          _selectedGradientColorAIndex = 0; // Sky Cyan
          _selectedGradientColorBIndex = 2; // Violet Neon
          break;
        case 1: // Neon Cyberpunk
          _variant = ByCardVariant.dynamicSensor;
          _enableSensor = true;
          _enableHoverTilt = true;
          _tiltX = 0.0;
          _tiltY = 1.0;
          _borderWidth = 2.0;
          _borderRadius = 22.0;
          _shadowBlur = 26.0;
          _maxShadowOffset = 14.0;
          _selectedBgIndex = 1;
          _selectedGradientColorAIndex = 2; // Violet Neon
          _selectedGradientColorBIndex = 4; // Amber Gold
          break;
        case 2: // Minimal Slate
          _variant = ByCardVariant.normal;
          _enableSensor = false;
          _borderWidth = 1.0;
          _borderRadius = 14.0;
          _shadowBlur = 8.0;
          _maxShadowOffset = 4.0;
          _selectedBgIndex = 0;
          _selectedGradientColorAIndex = 1; // Indigo Blue
          _selectedGradientColorBIndex = 7; // Pure White
          break;
        case 3: // Elevated Clean
          _variant = ByCardVariant.normal;
          _enableSensor = false;
          _borderWidth = 0.0;
          _borderRadius = 16.0;
          _shadowBlur = 14.0;
          _maxShadowOffset = 6.0;
          _selectedBgIndex = 0;
          _selectedGradientColorAIndex = 1; // Indigo Blue
          _selectedGradientColorBIndex = 0; // Sky Cyan
          break;
      }
    });
  }

  Widget _buildVariantSelector(AppColorPalette colors, bool isDark) {
    final variants = [
      (
        variant: ByCardVariant.dynamicSensor,
        label: 'Spatial Sensor',
        icon: AppIcons.explore,
      ),
      (
        variant: ByCardVariant.gradient,
        label: 'Gradient',
        icon: AppIcons.gradient,
      ),
      (
        variant: ByCardVariant.normal,
        label: 'Normal',
        icon: AppIcons.cardNormal,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: variants.map((item) {
          final isSelected = _variant == item.variant;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ByShowcaseChoiceChip(
              label: item.label,
              isSelected: isSelected,
              icon: Icon(item.icon),
              onTap: () {
                setState(() {
                  _variant = item.variant;
                  _activePresetIndex = -1;
                });
              },
            ),
          );
        }).toList(),
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

  Widget _buildControlCard({
    required AppColorPalette colors,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    // Dogfooding: Control cards wrap their content using ByCard in normal mode
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
              Icon(icon, size: 15, color: AppColors.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.sectionHeader.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
