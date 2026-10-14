import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_drawer.dart';
import '../widgets/by_showcase_header.dart';
import '../widgets/by_showcase_choice_chip.dart';
import '../widgets/by_showcase_control_card.dart';
import '../widgets/by_showcase_slider_tile.dart';
import '../widgets/by_showcase_preset_card.dart';
import '../widgets/by_showcase_integration_banner.dart';
import '../widgets/by_showcase_preview_card.dart';
import '../widgets/widget_params_dialog.dart';
import 'sequence/sequence_sample_cards.dart';

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
  late final SequenceSampleCards _sampleCards;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Alex Rivera');
    _emailController = TextEditingController(text: 'alex.rivera@byui.dev');
    _messageController = TextEditingController();
    _newsletterController = TextEditingController(text: 'newsletter@byui.dev');
    _promoController = TextEditingController(text: 'BYUI-2026');
    _sampleCards = SequenceSampleCards(
      nameController: _nameController,
      emailController: _emailController,
      messageController: _messageController,
      newsletterController: _newsletterController,
      promoController: _promoController,
    );
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
      howToTry:
          'ðŸ’¡ How to try: Scroll down and up smoothly to observe choreographed sequential cascade entrances and exits!',
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
              drawer: const ByDrawer(
                activeComponent: 'BySequence',
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

                        // 3. Integrated Feature Hint (Integrated with ByCard)
                        _buildIntegrationCard(colors),
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
                                    label: const Text('From Bottom â†“'),
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
                                    label: const Text('From Left â†'),
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
                                    label: const Text('From Right â†’'),
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
    return ByShowcaseSliderTile(
      label: label,
      valueText: valueText,
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
    );
  }

  Widget _buildCurveChip(
    String label,
    Curve curve,
    AppColorPalette colors,
    bool isDark,
  ) {
    return ByShowcaseChoiceChip(
      label: label,
      isSelected: _selectedCurve == curve,
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

    return ByShowcasePreviewCard(
      icon: Icons.auto_awesome_motion_rounded,
      subtitle: 'Sequential scroll-driven spatial stagger dynamics',
      description:
          'BySequence orchestrates GSAP ScrollTrigger-style staggered entrance cascades, scrubbed progress animations, and viewport batch reveals for child widgets.',
      metrics: [
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
    );
  }

  // 2. Preset Example Card
  Widget _buildPresetCard(AppColorPalette colors, bool isDark) {
    return ByShowcasePresetCard(
      presets: [
        ByShowcasePresetItem(
          label: 'GSAP 50% Viewport Batch',
          themeColor: AppColors.cyanAccent,
          isSelected: _activePresetIndex == 0,
          onTap: () => _applyPreset(0),
        ),
        ByShowcasePresetItem(
          label: 'Full-Screen Wave (100%)',
          themeColor: AppColors.primaryAccent,
          isSelected: _activePresetIndex == 1,
          onTap: () => _applyPreset(1),
        ),
        ByShowcasePresetItem(
          label: '1:1 Scroll Scrub',
          themeColor: AppColors.warning,
          isSelected: _activePresetIndex == 2,
          onTap: () => _applyPreset(2),
        ),
        ByShowcasePresetItem(
          label: 'Cascading Pairs (2x2)',
          themeColor: AppColors.primaryAccent,
          isSelected: _activePresetIndex == 3,
          onTap: () => _applyPreset(3),
        ),
        ByShowcasePresetItem(
          label: 'Parallax Stagger',
          themeColor: AppColors.roseAccent,
          isSelected: _activePresetIndex == 4,
          onTap: () => _applyPreset(4),
        ),
        ByShowcasePresetItem(
          label: 'Horizontal Flow',
          themeColor: AppColors.success,
          isSelected: _activePresetIndex == 5,
          onTap: () => _applyPreset(5),
        ),
      ],
    );
  }

  // 3. Integrated Feature Hint
  Widget _buildIntegrationCard(AppColorPalette colors) {
    return const ByShowcaseIntegrationBanner(
      componentName: 'ByCard',
      description:
          'BySequence smoothly orchestrates staggered entrance cascades and scroll-scrubbed pacing for ByCard collections.',
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

  // Reusable sequence card widgets delegated to SequenceSampleCards
  List<Widget> _buildSequenceCards({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return _sampleCards.buildCards(
      colors: colors,
      isDark: isDark,
      isVertical: isVertical,
    );
  }

  // Numbered Control Card Helper delegating to ByShowcaseControlCard
  Widget _buildControlCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    AppColorPalette? colors,
  }) {
    return ByShowcaseControlCard(
      title: title,
      icon: icon,
      children: children,
    );
  }
}