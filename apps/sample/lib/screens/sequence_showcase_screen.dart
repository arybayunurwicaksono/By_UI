import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_drawer.dart';
import '../widgets/by_showcase_header.dart';
import '../widgets/by_showcase_choice_chip.dart';
import '../widgets/widget_params_dialog.dart';
import 'app_bar_showcase_screen.dart';
import 'card_showcase_screen.dart';
import 'dialog_showcase_screen.dart';
import 'toast_showcase_screen.dart';

/// Interactive showcase screen for the [BySequence] sequential scroll animation component.
class SequenceShowcaseScreen extends StatefulWidget {
  const SequenceShowcaseScreen({super.key});

  @override
  State<SequenceShowcaseScreen> createState() => _SequenceShowcaseScreenState();
}

class _SequenceShowcaseScreenState extends State<SequenceShowcaseScreen> {
  // GSAP Pillar 1: Scroller Frame & Viewport
  // 0 = Compact (360px), 1 = 50% Screen (Half Viewport), 2 = 100% Screen (Full Height/Width)
  int _containerMode = 1;
  double _trigger = 0.85; // GSAP start: 'top 85%'
  double _spacing = 16.0;
  double? _itemExtent;

  // GSAP Pillar 2: Motion Transform (Travel & Origin)
  bool _enableOpacity = true;
  // 'bottom' (Slide from bottom), 'left' (Slide from left), 'right' (Slide from right), 'custom' (Manual slider)
  String _entryDirection = 'bottom';
  // 0 = Standard (40px), 1 = Extended (80px), 2 = Custom Slider
  int _motionPreset = 0;
  double _translateY = 40.0;
  double _translateX = 0.0;
  double _scaleStart = 1.0;
  double _rotationStart = 0.0;

  // GSAP Pillar 3: Sequential Batching & Dynamics (ScrollTrigger.batch)
  // 0 = Auto (Fit Viewport Capacity), 1 = 1-by-1, 2 = Pairs, 3 = Batch of 3, 5 = Batch of 5
  int _groupSize = 0;
  bool _scrub = false; // Default false for GSAP Stagger Wave
  int _staggerMs = 70; // GSAP stagger: 0.07s
  bool _reverse = true;
  bool _replay = false;
  int _durationMs = 600;
  Curve _selectedCurve = Curves.easeOutCubic;

  // GSAP Pillar 4: Layout Direction
  Axis _scrollDirection = Axis.vertical;

  // Preset Tracking (-1 for custom)
  int _activePresetIndex = 0;

  // Fullscreen interactive preview state
  bool _isMaximized = false;

  // Key to force re-render preview container when parameters change
  int _previewKeyNonce = 0;

  // Form controllers for interactive preview cards
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;
  late final TextEditingController _newsletterController;
  late final TextEditingController _promoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Alex Rivera');
    _emailController = TextEditingController(text: 'alex.rivera@byui.dev');
    _messageController = TextEditingController();
    _newsletterController = TextEditingController(text: 'newsletter@byui.dev');
    _promoController = TextEditingController(text: 'BYUI-2026');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _newsletterController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _resetToDefaults() {
    setState(() {
      _isMaximized = false;
      _containerMode = 1; // 50% Screen default
      _trigger = 0.85;
      _spacing = 16.0;
      _itemExtent = null;
      _enableOpacity = true;
      _entryDirection = 'bottom';
      _motionPreset = 0; // Standard 40px
      _translateY = 40.0;
      _translateX = 0.0;
      _scaleStart = 1.0;
      _rotationStart = 0.0;
      _groupSize = 0; // Auto (Fit 50% Viewport)
      _scrub = false; // GSAP Stagger Wave default
      _staggerMs = 70;
      _reverse = true;
      _replay = false;
      _durationMs = 600;
      _selectedCurve = Curves.easeOutCubic;
      _scrollDirection = Axis.vertical;
      _activePresetIndex = 0;
      _previewKeyNonce++;
      _nameController.text = 'Alex Rivera';
      _emailController.text = 'alex.rivera@byui.dev';
      _messageController.clear();
      _newsletterController.text = 'newsletter@byui.dev';
      _promoController.text = 'BYUI-2026';
    });
  }

  void _applyPreset(int index) {
    setState(() {
      _activePresetIndex = index;
      _previewKeyNonce++;
      switch (index) {
        case 0: // GSAP 50% Viewport Batch (Recommended)
          _containerMode = 1;
          _motionPreset = 0;
          _entryDirection = 'bottom';
          _translateY = 40.0;
          _translateX = 0.0;
          _enableOpacity = true;
          _scaleStart = 1.0;
          _rotationStart = 0.0;
          _groupSize = 0; // Auto (fit 50% viewport)
          _scrub = false;
          _staggerMs = 70;
          _trigger = 0.85;
          _durationMs = 600;
          _reverse = true;
          _scrollDirection = Axis.vertical;
          _selectedCurve = Curves.easeOutCubic;
          break;
        case 1: // Full-Screen Wave (100% Viewport)
          _containerMode = 2;
          _motionPreset = 1;
          _entryDirection = 'bottom';
          _translateY = 80.0;
          _translateX = 0.0;
          _enableOpacity = true;
          _scaleStart = 1.0;
          _rotationStart = 0.0;
          _groupSize = 0; // Auto (fit full screen)
          _scrub = false;
          _staggerMs = 80;
          _trigger = 0.90;
          _durationMs = 700;
          _reverse = true;
          _scrollDirection = Axis.vertical;
          _selectedCurve = Curves.easeOutCubic;
          break;
        case 2: // 1:1 Scroll Scrub (Continuous)
          _containerMode = 0;
          _motionPreset = 0;
          _entryDirection = 'bottom';
          _translateY = 40.0;
          _translateX = 0.0;
          _enableOpacity = true;
          _scaleStart = 1.0;
          _rotationStart = 0.0;
          _groupSize = 1;
          _scrub = true;
          _trigger = 0.75;
          _reverse = true;
          _scrollDirection = Axis.vertical;
          _selectedCurve = Curves.easeOutCubic;
          break;
        case 3: // Cascading Pairs (2x2)
          _containerMode = 1;
          _motionPreset = 0;
          _entryDirection = 'bottom';
          _translateY = 40.0;
          _translateX = 0.0;
          _enableOpacity = true;
          _scaleStart = 1.0;
          _rotationStart = 0.0;
          _groupSize = 2;
          _scrub = false;
          _staggerMs = 90;
          _trigger = 0.85;
          _durationMs = 650;
          _reverse = true;
          _scrollDirection = Axis.vertical;
          _selectedCurve = Curves.easeOutCubic;
          break;
        case 4: // Parallax Stagger
          _containerMode = 1;
          _motionPreset = 1;
          _entryDirection = 'bottom';
          _translateY = 80.0;
          _translateX = 0.0;
          _enableOpacity = true;
          _scaleStart = 0.85;
          _rotationStart = -0.04;
          _groupSize = 3;
          _scrub = false;
          _staggerMs = 80;
          _trigger = 0.85;
          _durationMs = 700;
          _reverse = true;
          _scrollDirection = Axis.vertical;
          _selectedCurve = Curves.easeOutBack;
          break;
        case 5: // Horizontal Flow
          _containerMode = 0;
          _motionPreset = 1;
          _entryDirection = 'right';
          _translateY = 0.0;
          _translateX = 80.0;
          _enableOpacity = true;
          _scaleStart = 0.90;
          _rotationStart = 0.0;
          _groupSize = 0;
          _scrub = false;
          _staggerMs = 70;
          _trigger = 0.85;
          _durationMs = 600;
          _reverse = true;
          _scrollDirection = Axis.horizontal;
          _selectedCurve = Curves.easeOutCubic;
          break;
      }
    });
  }

  void _showParamsDialog(BuildContext context) {
    showWidgetParametersDialog(
      context,
      parameters: const [
        WidgetParamInfo(
          name: 'children',
          type: 'List<Widget>',
          description:
              'Sequential list of widgets to reveal and animate as the viewport scrolls.',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'animation',
          type: 'BySequenceAnimation',
          description:
              'Global animation transform specification (opacity, translations, scale, rotation).',
          defaultValue: 'BySequenceAnimation.defaultAnimation',
        ),
        WidgetParamInfo(
          name: 'trigger',
          type: 'double',
          description:
              'Relative viewport trigger position (0.0 = top, 0.5 = middle, 1.0 = bottom).',
          defaultValue: '0.75',
        ),
        WidgetParamInfo(
          name: 'scrub',
          type: 'bool',
          description:
              'When true, animation progress tracks scroll position 1:1. When false, acts as trigger.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'reverse',
          type: 'bool',
          description:
              'When true, scrolling backwards reverses the sequence animation.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'replay',
          type: 'bool',
          description:
              'When true, re-entering the trigger zone replays transition in non-scrub mode.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'duration',
          type: 'Duration',
          description:
              'Transition duration for non-scrub triggered animations.',
          defaultValue: 'Duration(milliseconds: 600)',
        ),
        WidgetParamInfo(
          name: 'curve',
          type: 'Curve',
          description:
              'Easing curve applied to animation progress interpolation.',
          defaultValue: 'Curves.easeOutCubic',
        ),
        WidgetParamInfo(
          name: 'spacing',
          type: 'double',
          description: 'Pixel separation distance between consecutive items.',
          defaultValue: '0.0',
        ),
        WidgetParamInfo(
          name: 'itemExtent',
          type: 'double?',
          description:
              'Optional fixed extent (height for vertical, width for horizontal) per item.',
        ),
        WidgetParamInfo(
          name: 'scrollDirection',
          type: 'Axis',
          description: 'Scroll orientation of the sequence layout.',
          defaultValue: 'Axis.vertical',
        ),
        WidgetParamInfo(
          name: 'shrinkWrap',
          type: 'bool',
          description:
              'When true, sizes to children without an internal scrollable for nested setups.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'initialVisibleFraction',
          type: 'double?',
          description:
              'Optional initial viewport fraction (e.g. 1.0 for 100% screen, 0.5 for 50%). Items fitting inside are revealed at start; items beyond start completely transparent until scrolled.',
        ),
        WidgetParamInfo(
          name: 'initialVisibleCount',
          type: 'int?',
          description:
              'Optional discrete number of items initially revealed at start (e.g. 1 for Standard, 3 for Extended, 5 for 50%). Subsequent items reveal strictly one-by-one as user scrolls.',
        ),
        WidgetParamInfo(
          name: 'groupSize',
          type: 'int',
          description:
              'Batch size for GSAP ScrollTrigger.batch(). Default 0 automatically adapts to match the active animation range limit. When N > 1 (e.g. 5), triggers a cascading stagger wave as each batch crosses the viewport trigger line.',
          defaultValue: '0',
        ),
        WidgetParamInfo(
          name: 'groupStaggerDelay',
          type: 'Duration',
          description:
              'Stagger delay between items within a group during non-scrub triggered animations.',
          defaultValue: 'Duration(milliseconds: 70)',
        ),
        WidgetParamInfo(
          name: 'groupStagger',
          type: 'double',
          description:
              'Normalized stagger ratio (0.0 to 1.0) between items within a group in scrub mode.',
          defaultValue: '0.05',
        ),
        WidgetParamInfo(
          name: 'onProgress',
          type: 'ValueChanged<double>?',
          description:
              'Callback fired when overall sequence progress changes (0.0 to 1.0).',
        ),
        WidgetParamInfo(
          name: 'onItemProgress',
          type: 'void Function(int, double)?',
          description:
              'Callback fired when an individual child item progress updates.',
        ),
        WidgetParamInfo(
          name: 'onItemEnter',
          type: 'ValueChanged<int>?',
          description:
              'Callback fired when an item crosses into the viewport trigger zone.',
        ),
        WidgetParamInfo(
          name: 'onSequenceComplete',
          type: 'VoidCallback?',
          description:
              'Callback fired when all items in the sequence have completed reveal.',
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
        final mediaQuery = MediaQuery.of(context);

        final isVertical = _scrollDirection == Axis.vertical;

        // GSAP Pillar 1: Scroller Frame Height (50% Screen or 100% Screen or 360px Compact)
        final double previewHeight;
        if (_containerMode == 2) {
          previewHeight = mediaQuery.size.height;
        } else if (_containerMode == 1) {
          previewHeight =
              mediaQuery.size.height * 0.50; // EXACT 50% screen height!
        } else {
          previewHeight = isVertical ? 360.0 : 210.0;
        }

        // Viewport bounds & range distance for GSAP batch gating
        // Viewport bounds & range distance for GSAP batch gating.
        // When effectiveInitialFraction = 1.0, Batch 0 completely fills the active container viewport
        // (whether 50% screen, 100% screen, or 360px compact) without leaving blank space at the bottom.
        // Dynamic batch pacing calculates sequential triggers automatically from physical batch dimensions.
        const double effectiveInitialFraction = 1.0;
        const int? effectiveInitialCount = null;
        const double? effectiveRangeDistance = null;

        // GSAP Pillar 2: Motion Transform Distance
        double effectiveMotionDistance;
        if (_motionPreset == 0) {
          effectiveMotionDistance = 40.0;
        } else if (_motionPreset == 1) {
          effectiveMotionDistance = 80.0;
        } else {
          effectiveMotionDistance = isVertical
              ? _translateY.abs()
              : _translateX.abs();
          if (effectiveMotionDistance == 0.0) effectiveMotionDistance = 40.0;
        }

        double calcTranslateY = 0.0;
        double calcTranslateX = 0.0;

        if (_entryDirection == 'bottom') {
          calcTranslateY = effectiveMotionDistance;
          calcTranslateX = 0.0;
        } else if (_entryDirection == 'left') {
          calcTranslateY = 0.0;
          calcTranslateX = -effectiveMotionDistance;
        } else if (_entryDirection == 'right') {
          calcTranslateY = 0.0;
          calcTranslateX = effectiveMotionDistance;
        } else {
          // 'custom'
          calcTranslateY = _translateY;
          calcTranslateX = _translateX;
        }

        final activeAnimation = BySequenceAnimation(
          opacity: _enableOpacity ? const BySequenceRange(0.0, 1.0) : null,
          translateY: calcTranslateY != 0.0
              ? BySequenceRange(calcTranslateY, 0.0)
              : null,
          translateX: calcTranslateX != 0.0
              ? BySequenceRange(calcTranslateX, 0.0)
              : null,
          scale: _scaleStart != 1.0 ? BySequenceRange(_scaleStart, 1.0) : null,
          rotation: _rotationStart != 0.0
              ? BySequenceRange(_rotationStart, 0.0)
              : null,
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
                isFloatingEnabled: true,
                child: ByShowcaseHeader(
                  componentName: 'BySequence',
                  titleSuffix: _isMaximized ? 'Live Preview' : 'Showcase',
                  onReset: _isMaximized ? null : _resetToDefaults,
                  onOpenParams: _isMaximized
                      ? null
                      : () => _showParamsDialog(context),
                  extraActions: _isMaximized
                      ? [
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
              drawer: ByDrawer(
                activeComponent: 'BySequence',
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
                  }
                },
              ),
              body: _isMaximized
                  ? _buildMaximizedSequenceBody(
                      colors: colors,
                      isDark: isDark,
                      animation: activeAnimation,
                      initialVisibleFraction: effectiveInitialFraction,
                      initialVisibleCount: effectiveInitialCount,
                      rangeDistance: effectiveRangeDistance,
                      previewHeight: previewHeight,
                    )
                  : ListView(
                      padding: EdgeInsets.fromLTRB(
                        12,
                        ByAppBar.getContentTopPadding(context, extra: 10),
                        12,
                        mediaQuery.padding.bottom + 48,
                      ),
                      children: [
                        // 1. Active Configuration Preview Card
                        _buildActiveConfigPreviewCard(
                          colors: colors,
                          isDark: isDark,
                          effectiveDistance: effectiveMotionDistance,
                        ),
                        const SizedBox(height: 12),

                        // 2. Preset Example Card
                        _buildPresetCard(colors, isDark),
                        const SizedBox(height: 12),

                        // 4. Standalone Widget Display (Hero Interactive Live Preview)
                        _buildHeroPreviewCard(
                          colors: colors,
                          isDark: isDark,
                          animation: activeAnimation,
                          initialVisibleFraction: effectiveInitialFraction,
                          initialVisibleCount: effectiveInitialCount,
                          rangeDistance: effectiveRangeDistance,
                          previewHeight: previewHeight,
                        ),
                        const SizedBox(height: 12),

                        // 5. Control Card 1: Container Viewport & Scroller (GSAP Scroller Frame)
                        _buildControlCard(
                          colors: colors,
                          title: '1. CONTAINER VIEWPORT & SCROLLER',
                          icon: Icons.aspect_ratio_rounded,
                          children: [
                            Text(
                              'Scroller Frame Height (Container Size):',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  BySelectOption(
                                    label: const Text(
                                      '50% Screen (Half Viewport)',
                                    ),
                                    icon: const Icon(
                                      Icons.splitscreen_rounded,
                                      size: 16,
                                    ),
                                    isSelected: _containerMode == 1,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _containerMode = 1;
                                      _trigger = 0.85;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text(
                                      '100% Screen (Full Viewport)',
                                    ),
                                    icon: const Icon(
                                      Icons.fullscreen_rounded,
                                      size: 16,
                                    ),
                                    isSelected: _containerMode == 2,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _containerMode = 2;
                                      _trigger = 0.90;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('Compact (360px)'),
                                    icon: const Icon(
                                      Icons.crop_16_9_rounded,
                                      size: 16,
                                    ),
                                    isSelected: _containerMode == 0,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _containerMode = 0;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildSliderField(
                              label: 'Trigger Line (GSAP Start Line):',
                              valueText:
                                  '${(_trigger * 100).toInt()}% Viewport',
                              value: _trigger,
                              min: 0.20,
                              max: 1.0,
                              divisions: 16,
                              colors: colors,
                              onChanged: (val) {
                                setState(() {
                                  _trigger = val;
                                  _activePresetIndex = -1;
                                  _previewKeyNonce++;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            _buildSliderField(
                              label: 'Item Spacing (Gap):',
                              valueText: '${_spacing.toInt()} px',
                              value: _spacing,
                              min: 0.0,
                              max: 36.0,
                              divisions: 12,
                              colors: colors,
                              onChanged: (val) {
                                setState(() {
                                  _spacing = val;
                                  _activePresetIndex = -1;
                                  _previewKeyNonce++;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Control Card 2: Motion Transforms & Travel
                        _buildControlCard(
                          colors: colors,
                          title: '2. MOTION TRANSFORMS & TRAVEL',
                          icon: Icons.animation_rounded,
                          children: [
                            ByShowcaseSwitchTile(
                              title: 'Opacity Fade Transition',
                              subtitle: 'Interpolates opacity from 0.0 to 1.0',
                              value: _enableOpacity,
                              onChanged: (val) => setState(() {
                                _enableOpacity = val;
                                _activePresetIndex = -1;
                                _previewKeyNonce++;
                              }),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Motion Origin (Entry Direction):',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  BySelectOption(
                                    label: const Text('From Bottom ↓'),
                                    icon: const Icon(
                                      Icons.arrow_upward_rounded,
                                      size: 16,
                                    ),
                                    isSelected: _entryDirection == 'bottom',
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _entryDirection = 'bottom';
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('From Left ←'),
                                    icon: const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 16,
                                    ),
                                    isSelected: _entryDirection == 'left',
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _entryDirection = 'left';
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('From Right →'),
                                    icon: const Icon(
                                      Icons.arrow_back_rounded,
                                      size: 16,
                                    ),
                                    isSelected: _entryDirection == 'right',
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _entryDirection = 'right';
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('Custom Slider'),
                                    icon: const Icon(
                                      Icons.tune_rounded,
                                      size: 16,
                                    ),
                                    isSelected: _entryDirection == 'custom',
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _entryDirection = 'custom';
                                      _motionPreset = 2;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Motion Distance (Travel Offset):',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  BySelectOption(
                                    label: const Text('Standard (40px)'),
                                    isSelected: _motionPreset == 0,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _motionPreset = 0;
                                      if (_entryDirection == 'custom') {
                                        _entryDirection = 'bottom';
                                      }
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('Extended (80px)'),
                                    isSelected: _motionPreset == 1,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _motionPreset = 1;
                                      if (_entryDirection == 'custom') {
                                        _entryDirection = 'bottom';
                                      }
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('Custom Slider (px)'),
                                    isSelected: _motionPreset == 2,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _motionPreset = 2;
                                      _entryDirection = 'custom';
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            if (_motionPreset == 2 ||
                                _entryDirection == 'custom') ...[
                              const SizedBox(height: 10),
                              _buildSliderField(
                                label: 'Vertical Translation (Y Offset):',
                                valueText: '${_translateY.toInt()} px',
                                value: _translateY,
                                min: -150.0,
                                max: 150.0,
                                divisions: 20,
                                colors: colors,
                                onChanged: (val) => setState(() {
                                  _translateY = val;
                                  _activePresetIndex = -1;
                                  _previewKeyNonce++;
                                }),
                              ),
                              const SizedBox(height: 8),
                              _buildSliderField(
                                label: 'Horizontal Translation (X Offset):',
                                valueText: '${_translateX.toInt()} px',
                                value: _translateX,
                                min: -150.0,
                                max: 150.0,
                                divisions: 20,
                                colors: colors,
                                onChanged: (val) => setState(() {
                                  _translateX = val;
                                  _activePresetIndex = -1;
                                  _previewKeyNonce++;
                                }),
                              ),
                            ],
                            const SizedBox(height: 8),
                            _buildSliderField(
                              label: 'Scale Start Factor:',
                              valueText: '${_scaleStart.toStringAsFixed(2)}x',
                              value: _scaleStart,
                              min: 0.60,
                              max: 1.20,
                              divisions: 12,
                              colors: colors,
                              onChanged: (val) => setState(() {
                                _scaleStart = val;
                                _activePresetIndex = -1;
                                _previewKeyNonce++;
                              }),
                            ),
                            const SizedBox(height: 8),
                            _buildSliderField(
                              label: 'Initial Rotation:',
                              valueText:
                                  '${(_rotationStart * 57.3).toInt()} deg',
                              value: _rotationStart,
                              min: -0.15,
                              max: 0.15,
                              divisions: 10,
                              colors: colors,
                              onChanged: (val) => setState(() {
                                _rotationStart = val;
                                _activePresetIndex = -1;
                                _previewKeyNonce++;
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Control Card 3: Sequential Batching & Dynamics (GSAP)
                        _buildControlCard(
                          colors: colors,
                          title: '3. SEQUENTIAL BATCHING & DYNAMICS (GSAP)',
                          icon: Icons.dynamic_feed_rounded,
                          children: [
                            ByShowcaseSwitchTile(
                              title: '1:1 Scroll Scrubbing',
                              subtitle:
                                  'Ties animation progress directly to scroll motion',
                              value: _scrub,
                              onChanged: (val) => setState(() {
                                _scrub = val;
                                _activePresetIndex = -1;
                                _previewKeyNonce++;
                              }),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Reverse on Scroll Up',
                              subtitle:
                                  'Animates back to hidden state when scrolling backwards',
                              value: _reverse,
                              onChanged: (val) => setState(() {
                                _reverse = val;
                                _activePresetIndex = -1;
                                _previewKeyNonce++;
                              }),
                            ),
                            const SizedBox(height: 8),
                            ByShowcaseSwitchTile(
                              title: 'Replay Animation',
                              subtitle:
                                  'Re-triggers transition when re-entering viewport',
                              value: _replay,
                              onChanged: (val) => setState(() {
                                _replay = val;
                                _activePresetIndex = -1;
                                _previewKeyNonce++;
                              }),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sequential Batch Size (GSAP ScrollTrigger.batch):',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  BySelectOption(
                                    label: const Text('Auto (Fit Viewport)'),
                                    isSelected: _groupSize == 0,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _groupSize = 0;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('1 by 1 (Individual)'),
                                    isSelected: _groupSize == 1,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _groupSize = 1;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('Pairs (2 Items)'),
                                    isSelected: _groupSize == 2,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _groupSize = 2;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('Batch of 3'),
                                    isSelected: _groupSize == 3,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _groupSize = 3;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('Batch of 5 (Cascading)'),
                                    isSelected: _groupSize == 5,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _groupSize = 5;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildSliderField(
                              label: 'Stagger Wave Cascade Delay:',
                              valueText: '$_staggerMs ms',
                              value: _staggerMs.toDouble(),
                              min: 0,
                              max: 200,
                              divisions: 20,
                              colors: colors,
                              onChanged: (val) => setState(() {
                                _staggerMs = val.toInt();
                                _activePresetIndex = -1;
                                _previewKeyNonce++;
                              }),
                            ),
                            if (!_scrub) ...[
                              const SizedBox(height: 8),
                              _buildSliderField(
                                label: 'Transition Duration:',
                                valueText: '$_durationMs ms',
                                value: _durationMs.toDouble(),
                                min: 200,
                                max: 1500,
                                divisions: 13,
                                colors: colors,
                                onChanged: (val) => setState(() {
                                  _durationMs = val.toInt();
                                  _activePresetIndex = -1;
                                }),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(
                              'Easing Curve Preset:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildCurveChip(
                                    'easeOutCubic',
                                    Curves.easeOutCubic,
                                    colors,
                                    isDark,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCurveChip(
                                    'easeInOut',
                                    Curves.easeInOut,
                                    colors,
                                    isDark,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCurveChip(
                                    'easeOutBack',
                                    Curves.easeOutBack,
                                    colors,
                                    isDark,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCurveChip(
                                    'linear',
                                    Curves.linear,
                                    colors,
                                    isDark,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Control Card 4: Layout Direction
                        _buildControlCard(
                          colors: colors,
                          title: '4. SCROLL ORIENTATION',
                          icon: Icons.open_in_full_rounded,
                          children: [
                            Text(
                              'Sequence Axis Direction:',
                              style: AppTextStyle.fieldLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  BySelectOption(
                                    label: const Text('Vertical Sequence'),
                                    icon: const Icon(
                                      Icons.arrow_downward_rounded,
                                      size: 16,
                                    ),
                                    isSelected:
                                        _scrollDirection == Axis.vertical,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _scrollDirection = Axis.vertical;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  BySelectOption(
                                    label: const Text('Horizontal Sequence'),
                                    icon: const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 16,
                                    ),
                                    isSelected:
                                        _scrollDirection == Axis.horizontal,
                                    selectedBorderColor: AppColors.primary,
                                    unselectedBorderColor: colors.borderSubtle,
                                    selectedBackgroundColor:
                                        colors.chipSelectedBg,
                                    unselectedBackgroundColor: colors.chipBg,
                                    selectedTextColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedTextColor: colors.textMuted,
                                    onTap: () => setState(() {
                                      _scrollDirection = Axis.horizontal;
                                      _activePresetIndex = -1;
                                      _previewKeyNonce++;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliderField({
    required String label,
    required String valueText,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required AppColorPalette colors,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
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
            Text(
              valueText,
              style: AppTextStyle.badge.copyWith(color: AppColors.cyanAccent),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppColors.primary,
          inactiveColor: colors.borderSubtle,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCurveChip(
    String label,
    Curve curve,
    AppColorPalette colors,
    bool isDark,
  ) {
    return BySelectOption(
      label: Text(label),
      isSelected: _selectedCurve == curve,
      selectedBorderColor: AppColors.primary,
      unselectedBorderColor: colors.borderSubtle,
      selectedBackgroundColor: colors.chipSelectedBg,
      unselectedBackgroundColor: colors.chipBg,
      selectedTextColor: isDark ? Colors.white : Colors.black,
      unselectedTextColor: colors.textMuted,
      onTap: () => setState(() {
        _selectedCurve = curve;
        _activePresetIndex = -1;
        _previewKeyNonce++;
      }),
    );
  }

  // 1. Active Configuration Preview Card
  Widget _buildActiveConfigPreviewCard({
    required AppColorPalette colors,
    required bool isDark,
    required double effectiveDistance,
  }) {
    final String containerText = _containerMode == 1
        ? '50% Screen (Half)'
        : (_containerMode == 2 ? '100% Screen (Full)' : 'Compact (360px)');

    final String motionText = _motionPreset == 0
        ? 'Standard (40px)'
        : (_motionPreset == 1
              ? 'Extended (80px)'
              : '${effectiveDistance.toInt()} px');

    final String groupText = _groupSize == 0
        ? 'Auto (Fit Viewport)'
        : (_groupSize == 1 ? 'Individual (1-by-1)' : '$_groupSize Items');

    final String dynamicsText = _scrub
        ? '1:1 Continuous Scrub'
        : 'GSAP Wave (${_staggerMs}ms)';

    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: colors.cardBg,
      borderColor: colors.border,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome_motion_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
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
                    const SizedBox(height: 2),
                    Text(
                      'GSAP ScrollTrigger sequential batch matrix',
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
          Text(
            _containerMode == 1
                ? 'Container & scrollbar span exactly 50% of the screen. '
                      'Items fitting in the 50% viewport reveal initially; subsequent batches trigger '
                      'a cascading stagger wave as preceding items exit.'
                : (_containerMode == 2
                      ? 'Full-screen 100% viewport container. Items cascade dynamically with GSAP stagger.'
                      : 'Compact 360px container with scroll-linked sequence reveal.'),
            style: AppTextStyle.body.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ByMetricBadge(label: 'Container', value: containerText),
              ByMetricBadge(label: 'Motion', value: motionText),
              ByMetricBadge(label: 'Grouping', value: groupText),
              ByMetricBadge(label: 'Dynamics', value: dynamicsText),
              ByMetricBadge(
                label: 'Trigger',
                value: '${(_trigger * 100).toInt()}% Viewport',
              ),
              ByMetricBadge(
                label: 'Origin',
                value: _entryDirection == 'bottom'
                    ? 'From Bottom'
                    : (_entryDirection == 'left'
                          ? 'From Left'
                          : (_entryDirection == 'right'
                                ? 'From Right'
                                : 'Custom')),
              ),
              ByMetricBadge(
                label: 'Direction',
                value: _scrollDirection == Axis.vertical
                    ? 'Vertical'
                    : 'Horizontal',
              ),
              ByMetricBadge(
                label: 'Reverse',
                value: _reverse ? 'Enabled' : 'Disabled',
              ),
              ByMetricBadge(label: 'Spacing', value: '${_spacing.toInt()} px'),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Preset Example Card
  Widget _buildPresetCard(AppColorPalette colors, bool isDark) {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: colors.cardBg,
      borderColor: colors.border,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Preset Example',
                style: AppTextStyle.sectionHeader.copyWith(
                  color: colors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPresetChip(
                  index: 0,
                  label: 'GSAP 50% Viewport Batch',
                  accentColor: AppColors.cyanAccent,
                  colors: colors,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildPresetChip(
                  index: 1,
                  label: 'Full-Screen Wave (100%)',
                  accentColor: AppColors.primaryAccent,
                  colors: colors,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildPresetChip(
                  index: 2,
                  label: '1:1 Scroll Scrub',
                  accentColor: AppColors.warning,
                  colors: colors,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildPresetChip(
                  index: 3,
                  label: 'Cascading Pairs (2x2)',
                  accentColor: AppColors.primaryAccent,
                  colors: colors,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildPresetChip(
                  index: 4,
                  label: 'Parallax Stagger',
                  accentColor: AppColors.roseAccent,
                  colors: colors,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildPresetChip(
                  index: 5,
                  label: 'Horizontal Flow',
                  accentColor: AppColors.success,
                  colors: colors,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip({
    required int index,
    required String label,
    required Color accentColor,
    required AppColorPalette colors,
    required bool isDark,
  }) {
    final isSelected = _activePresetIndex == index;
    return GestureDetector(
      onTap: () => _applyPreset(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.15)
              : colors.chipBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? accentColor : colors.borderSubtle,
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyle.chipSelected.copyWith(
                color: isSelected
                    ? (isDark ? Colors.white : Colors.black)
                    : colors.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Hero Standalone Widget Display
  Widget _buildHeroPreviewCard({
    required AppColorPalette colors,
    required bool isDark,
    required BySequenceAnimation animation,
    double? initialVisibleFraction,
    int? initialVisibleCount,
    double? rangeDistance,
    required double previewHeight,
  }) {
    final isVertical = _scrollDirection == Axis.vertical;
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: colors.cardBg,
      borderColor: colors.border,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'INTERACTIVE PREVIEW',
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.sectionHeader.copyWith(
                          color: colors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
          Container(
            height: previewHeight,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkScaffoldBg
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BySequence(
                key: ValueKey(_previewKeyNonce),
                trigger: _trigger,
                spacing: _spacing,
                itemExtent: _itemExtent,
                scrub: _scrub,
                reverse: _reverse,
                replay: _replay,
                duration: Duration(milliseconds: _durationMs),
                curve: _selectedCurve,
                scrollDirection: _scrollDirection,
                initialVisibleFraction: initialVisibleFraction,
                initialVisibleCount: initialVisibleCount,
                groupSize: _groupSize,
                groupStaggerDelay: Duration(milliseconds: _staggerMs),
                rangeDistance: rangeDistance,
                animation: animation,
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 64),
                children: _buildSequenceCards(
                  colors: colors,
                  isDark: isDark,
                  isVertical: isVertical,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fullscreen / Mode-aware live preview sequence body
  Widget _buildMaximizedSequenceBody({
    required AppColorPalette colors,
    required bool isDark,
    required BySequenceAnimation animation,
    double? initialVisibleFraction,
    int? initialVisibleCount,
    double? rangeDistance,
    required double previewHeight,
  }) {
    final isVertical = _scrollDirection == Axis.vertical;
    final topPadding = ByAppBar.getContentTopPadding(context, extra: 10);

    if (isVertical) {
      // 100% Screen: Edge-to-edge full viewport
      if (_containerMode == 2) {
        return Container(
          color: colors.scaffoldBg,
          child: BySequence(
            key: ValueKey('maximized_v_$_previewKeyNonce'),
            trigger: _trigger,
            spacing: _spacing,
            itemExtent: _itemExtent,
            scrub: _scrub,
            reverse: _reverse,
            replay: _replay,
            duration: Duration(milliseconds: _durationMs),
            curve: _selectedCurve,
            scrollDirection: Axis.vertical,
            initialVisibleFraction: initialVisibleFraction,
            initialVisibleCount: initialVisibleCount,
            groupSize: _groupSize,
            groupStaggerDelay: Duration(milliseconds: _staggerMs),
            rangeDistance: rangeDistance,
            animation: animation,
            padding: EdgeInsets.fromLTRB(
              16,
              topPadding,
              16,
              MediaQuery.of(context).padding.bottom + 64,
            ),
            children: _buildSequenceCards(
              colors: colors,
              isDark: isDark,
              isVertical: true,
            ),
          ),
        );
      }

      // 50% Screen (Half Viewport) or Compact (360px):
      // The scroller height and scroll indicator are strictly constrained to previewHeight.
      return Container(
        color: colors.scaffoldBg,
        padding: EdgeInsets.only(
          top: topPadding,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: previewHeight,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkScaffoldBg
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderSubtle, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BySequence(
                key: ValueKey('maximized_v_$_previewKeyNonce'),
                trigger: _trigger,
                spacing: _spacing,
                itemExtent: _itemExtent,
                scrub: _scrub,
                reverse: _reverse,
                replay: _replay,
                duration: Duration(milliseconds: _durationMs),
                curve: _selectedCurve,
                scrollDirection: Axis.vertical,
                initialVisibleFraction: initialVisibleFraction,
                initialVisibleCount: initialVisibleCount,
                groupSize: _groupSize,
                groupStaggerDelay: Duration(milliseconds: _staggerMs),
                rangeDistance: rangeDistance,
                animation: animation,
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 64),
                children: _buildSequenceCards(
                  colors: colors,
                  isDark: isDark,
                  isVertical: true,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: colors.scaffoldBg,
        padding: EdgeInsets.only(top: topPadding),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: previewHeight.clamp(200.0, 420.0),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkScaffoldBg
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderSubtle, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BySequence(
                key: ValueKey('maximized_h_$_previewKeyNonce'),
                trigger: _trigger,
                spacing: _spacing,
                itemExtent: _itemExtent,
                scrub: _scrub,
                reverse: _reverse,
                replay: _replay,
                duration: Duration(milliseconds: _durationMs),
                curve: _selectedCurve,
                scrollDirection: Axis.horizontal,
                initialVisibleFraction: initialVisibleFraction,
                initialVisibleCount: initialVisibleCount,
                groupSize: _groupSize,
                groupStaggerDelay: Duration(milliseconds: _staggerMs),
                rangeDistance: rangeDistance,
                animation: animation,
                padding: const EdgeInsets.fromLTRB(16, 12, 64, 12),
                children: _buildSequenceCards(
                  colors: colors,
                  isDark: isDark,
                  isVertical: false,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  // Reusable sequence card widgets
  List<Widget> _buildSequenceCards({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return [
      _buildProfileCard(colors: colors, isDark: isDark, isVertical: isVertical),
      _buildFeatureStepCard(
        step: '02',
        title: 'Scroll Interpolator',
        subtitle: 'Item progress computes dynamically from viewport metrics.',
        icon: Icons.auto_graph_rounded,
        color: AppColors.primaryAccent,
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildFormCard(colors: colors, isDark: isDark, isVertical: isVertical),
      _buildPhotoGalleryCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildNewsletterCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildFeatureStepCard(
        step: '06',
        title: 'Spatial Layout Matrix',
        subtitle: 'Executes rotation, scale, and multi-axis translation.',
        icon: Icons.transform_rounded,
        color: AppColors.info,
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildMessageFormCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildMilestonesCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildPricingPlanCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildAnalyticsCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildMediaCard(colors: colors, isDark: isDark, isVertical: isVertical),
      _buildTestimonialCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildWeatherStatusCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildPromoCard(colors: colors, isDark: isDark, isVertical: isVertical),
      _buildSecurityCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildCompletionCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildKpiRevenueCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildGitCommitCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildAudioPlayerCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildStorageGaugeCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildQuickActionGridCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildSmartHomeSensorCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildTaskChecklistCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildBatteryEfficiencyCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildCryptoTickerCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildFileDownloadCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildTeamAvatarStackCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildOrderReceiptCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildNotificationAlertCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildCustomerRatingCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildGpsNavigationCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildGrandCompletionCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
    ];
  }

  // 1. Profile / Photo Avatar Card
  Widget _buildProfileCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Alex Rivera',
                            style: AppTextStyle.captionBold.copyWith(
                              color: colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: AppColors.info,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Staff Systems Architect',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                '01',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Active Member',
                style: AppTextStyle.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  'San Francisco, CA',
                  style: AppTextStyle.caption.copyWith(color: colors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2 & 6. Classic Feature Step Card
  Widget _buildFeatureStepCard({
    required String step,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      step,
                      style: AppTextStyle.badge.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Form Card with Full Name & Email
  Widget _buildFormCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 285,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyanAccent.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 16,
                color: AppColors.cyanAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Profile Registration Form',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '03',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.cyanAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Form inputs retain data during scroll (maintainState: true)',
            style: AppTextStyle.caption.copyWith(
              color: colors.textMuted,
              fontSize: 9.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          _buildCompactTextField(
            controller: _nameController,
            hint: 'Full Name (e.g. Alex Rivera)',
            icon: Icons.person_outline_rounded,
            colors: colors,
            isDark: isDark,
          ),
          const SizedBox(height: 6),
          _buildCompactTextField(
            controller: _emailController,
            hint: 'Email Address',
            icon: Icons.alternate_email_rounded,
            colors: colors,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // 4. Photo Gallery Card with Styled Scenery Banner
  Widget _buildPhotoGalleryCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Spatial Photography Feed',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '04',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.emeraldDeep,
                  AppColors.skyDeep,
                  AppColors.primaryDeep,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.landscape_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Lofoten Aurora • 4K',
                            style: AppTextStyle.captionBold.copyWith(
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'HDR 60 FPS',
                      style: AppTextStyle.caption.copyWith(
                        color: Colors.white,
                        fontSize: 8.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                size: 14,
                color: AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                '2.4k Likes',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  'Norway • Nature',
                  style: AppTextStyle.caption.copyWith(color: colors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. Newsletter Subscription Card
  Widget _buildNewsletterCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.mark_email_read_rounded,
                size: 16,
                color: AppColors.primaryAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Developer Digest Newsletter',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '05',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Join 10k+ developers receiving spatial Flutter updates.',
            style: AppTextStyle.caption.copyWith(color: colors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCompactTextField(
                  controller: _newsletterController,
                  hint: 'Your email address',
                  icon: Icons.mail_outline_rounded,
                  colors: colors,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Join',
                  style: AppTextStyle.captionBold.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 7. Direct Message Inquiry Card
  Widget _buildMessageFormCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 16,
                color: AppColors.warning,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Direct Inquiry Message',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '07',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Need custom animation tuning? Send our team a note.',
            style: AppTextStyle.caption.copyWith(color: colors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCompactTextField(
                  controller: _messageController,
                  hint: 'Write your message here...',
                  icon: Icons.edit_outlined,
                  colors: colors,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.warning, AppColors.amberDeep],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.send_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Send',
                      style: AppTextStyle.captionBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 8. Milestones & Task Progress Card
  Widget _buildMilestonesCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.checklist_rtl_rounded,
                size: 16,
                color: AppColors.primaryAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Sprint Delivery Milestones',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '08',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Core sequence engine deployed',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '1:1 scrub interpolation verified',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 9. Pricing & Subscription Plan Card
  Widget _buildPricingPlanCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.diamond_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Enterprise Spatial Tier',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '09',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '\$49',
                style: AppTextStyle.screenHeader.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/ month',
                style: AppTextStyle.caption.copyWith(color: colors.textMuted),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PRO ACCESS',
                  style: AppTextStyle.captionBold.copyWith(
                    color: AppColors.primary,
                    fontSize: 8.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 10. Viewport Realtime Analytics Card
  Widget _buildAnalyticsCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyanAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights_rounded,
                size: 16,
                color: AppColors.cyanAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Realtime Viewport Telemetry',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '10',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.cyanAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '60.0 FPS',
                        style: AppTextStyle.captionBold.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Render Pacing',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '0.4 ms',
                        style: AppTextStyle.captionBold.copyWith(
                          color: AppColors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Frame Latency',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 11. Spatial Ambient Soundscape Media Card
  Widget _buildMediaCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.graphic_eq_rounded,
                size: 16,
                color: AppColors.primaryAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Spatial Soundscape Audio',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '11',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primaryAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nordic Horizon Ambient • 24-bit',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '03:45 / 05:20 • Hi-Res Audio',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                        fontSize: 9,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 12. Verified Developer Testimonial Card
  Widget _buildTestimonialCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.format_quote_rounded,
                size: 16,
                color: AppColors.warning,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Developer Feedback',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '12',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
              (index) => const Icon(
                Icons.star_rounded,
                size: 13,
                color: AppColors.warning,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '"BySequence delivered silky 60fps scroll scrubbing right out of the box!"',
            style: AppTextStyle.caption.copyWith(
              color: colors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 13. Edge Node Cluster Environment Card
  Widget _buildWeatherStatusCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.cloudy_snowing, size: 16, color: AppColors.info),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Edge Cluster Atmosphere',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '13',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '21°C',
                style: AppTextStyle.captionBold.copyWith(
                  color: colors.textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'US-East Node • 99.99% Uptime',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 14. Promo Voucher Application Card
  Widget _buildPromoCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_offer_outlined,
                size: 16,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Apply Promo Voucher',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '14',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCompactTextField(
                  controller: _promoController,
                  hint: 'Promo Code (BYUI-2026)',
                  icon: Icons.confirmation_number_outlined,
                  colors: colors,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.success, AppColors.emeraldDeep],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Apply',
                  style: AppTextStyle.captionBold.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 15. Hardware Security Enclave Card
  Widget _buildSecurityCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Hardware Security Enclave',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '15',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.fingerprint_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biometric Auth Verified',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'AES-256 GCM Keychain Active',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                        fontSize: 9,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 16. Completion Trophy Card
  Widget _buildCompletionCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyanAccent.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.warning,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Midway Checkpoint',
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '16',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '16 items revealed. 16 more diverse cards ahead!',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 17. KPI Revenue Card
  Widget _buildKpiRevenueCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      size: 16,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Net ARR Growth',
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '17',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$48,250.00',
                    style: AppTextStyle.sectionHeader.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        size: 12,
                        color: AppColors.success,
                      ),
                      Text(
                        '+18.4% vs last mo.',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [12, 18, 14, 24, 28, 36].map((h) {
                  return Container(
                    width: 5,
                    height: h.toDouble(),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(
                        alpha: h > 20 ? 0.9 : 0.35,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 18. Git Commit Activity Card
  Widget _buildGitCommitCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.commit_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Repository Activity',
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '18',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'feat(sequence): 32-item dynamic scroll viewport',
            style: AppTextStyle.captionBold.copyWith(color: colors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'main #8f2a1b',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '4 mins ago',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 19. Audio Player Card
  Widget _buildAudioPlayerCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryAccent],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Midnight Synthwave',
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '19',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 4,
                    backgroundColor: colors.borderSubtle,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'ByUI Audio Engine',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textMuted,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '02:45 / 04:12',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 20. Cloud Storage Gauge Card
  Widget _buildStorageGaugeCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.cloud_done_rounded,
                    size: 16,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'High-Speed NVMe Storage',
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '20',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.76,
              minHeight: 8,
              backgroundColor: colors.borderSubtle,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '194.5 GB of 256.0 GB used',
                style: AppTextStyle.caption.copyWith(color: colors.textPrimary),
              ),
              Text(
                '76%',
                style: AppTextStyle.captionBold.copyWith(color: AppColors.info),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 21. Quick Action Grid Card
  Widget _buildQuickActionGridCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    final actions = [
      {'icon': Icons.send_rounded, 'label': 'Transfer'},
      {'icon': Icons.download_rounded, 'label': 'Receive'},
      {'icon': Icons.swap_horiz_rounded, 'label': 'Swap'},
      {'icon': Icons.history_rounded, 'label': 'History'},
    ];
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Actions Hub',
                style: AppTextStyle.captionBold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '21',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.map((act) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Icon(
                      act['icon'] as IconData,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    act['label'] as String,
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 22. Smart Home Climate Sensor Card
  Widget _buildSmartHomeSensorCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyanAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cyanAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.thermostat_rounded,
              color: AppColors.cyanAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Living Room AC',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '22',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '22.5°C',
                      style: AppTextStyle.sectionHeader.copyWith(
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Eco Cool',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '48% RH',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 23. Task Checklist Card
  Widget _buildTaskChecklistCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.checklist_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Release Sprint Tasks',
                    style: AppTextStyle.captionBold.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '23',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Optimize BySequence scrub listener',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textMuted,
                    decoration: TextDecoration.lineThrough,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.radio_button_unchecked_rounded,
                size: 14,
                color: AppColors.warning,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Verify responsive landscape orientation',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 24. Battery & Power Efficiency Card
  Widget _buildBatteryEfficiencyCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SuperVOOC 65W Flash',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '24',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '94% Charged • 8 mins to full capacity',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 25. Crypto / Market Ticker Card
  Widget _buildCryptoTickerCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.currency_bitcoin_rounded,
              color: AppColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BTC / USD Index',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '25',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$68,490.50',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '+3.85%',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 26. File Download Progress Card
  Widget _buildFileDownloadCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.folder_zip_rounded,
                    size: 16,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'by_ui_design_tokens_v2.zip',
                    style: AppTextStyle.captionBold.copyWith(
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                '26',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: 0.82,
              minHeight: 5,
              backgroundColor: colors.borderSubtle,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '52.4 MB / 64.0 MB',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                  fontSize: 10,
                ),
              ),
              Text(
                '3.8 MB/s',
                style: AppTextStyle.captionBold.copyWith(
                  color: AppColors.info,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 27. Team Avatar Stack Card
  Widget _buildTeamAvatarStackCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    final avatarColors = [
      AppColors.primary,
      AppColors.cyanAccent,
      AppColors.warning,
      AppColors.primaryAccent,
    ];
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 32,
            child: Stack(
              children: List.generate(avatarColors.length, (i) {
                return Positioned(
                  left: i * 14.0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: avatarColors[i],
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.cardBg, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        i == 3 ? '+4' : '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Core Design Team',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '27',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  '7 engineers live on branch',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 28. Order Receipt Card
  Widget _buildOrderReceiptCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Order #BY-9402',
                    style: AppTextStyle.captionBold.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '28',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ByUI Enterprise License (3 Seats)',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '\$149.00',
                style: AppTextStyle.captionBold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PAID & FULFILLED',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Instant Access',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 29. Notification Alert Card
  Widget _buildNotificationAlertCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'System Notification',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '29',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Cloud cluster upgrade complete with 99.99% uptime guarantee.',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 30. Customer Rating Card
  Widget _buildCustomerRatingCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '4.9',
                style: AppTextStyle.sectionHeader.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              Row(
                children: List.generate(5, (_) {
                  return const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: 14,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Developer Reviews',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '30',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Rated outstanding by 1,480+ mobile engineers worldwide.',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 31. GPS Speedometer & Navigation Card
  Widget _buildGpsNavigationCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.navigation_rounded,
              color: AppColors.info,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Route Guidance HUD',
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '31',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'In 400m, keep right toward Silicon Valley Blvd',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '64 km/h',
            style: AppTextStyle.badge.copyWith(
              color: AppColors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 32. Grand Finale Milestone Card
  Widget _buildGrandCompletionCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.45),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryAccent,
                  AppColors.cyanAccent,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.35),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.military_tech_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Grand Finale Complete!',
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '32',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'All 32 sequence items dynamically calculated & rendered in viewport.',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required AppColorPalette colors,
    required bool isDark,
    int maxLines = 1,
  }) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: colors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              textAlignVertical: TextAlignVertical.center,
              style: AppTextStyle.caption.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Numbered Control Card Helper
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
      padding: const EdgeInsets.all(12),
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
}
