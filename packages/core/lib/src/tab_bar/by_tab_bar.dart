import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dynamic_border/by_dynamic_border.dart';
import '../dynamic_border/by_dynamic_border_layer.dart';
import '../dynamic_border/by_dynamic_border_painter.dart';

/// Visual style for active tab indicator in [ByTabBar].
enum ByTabIndicatorStyle {
  /// Sliding liquid mercury capsule/pill background (default).
  pill,

  /// Classic sliding accent line docked along the bottom border.
  underline,
}

/// Data model representing an individual tab item in [ByTabBar].
class ByTabItem {
  /// Primary text label for the tab.
  final String label;

  /// Optional leading icon glyph.
  final IconData? icon;

  /// Optional leading custom icon widget (takes precedence over [icon]).
  final Widget? iconWidget;

  /// Optional badge text displayed next to the label (e.g. "NEW", "3").
  final String? badge;

  /// Optional custom background color for the badge pill.
  final Color? badgeColor;

  /// Optional custom text color for the badge pill text.
  final Color? badgeTextColor;

  /// Optional semantic color override for this specific tab.
  final Color? color;

  /// Whether this tab is disabled and cannot be selected. Defaults to false.
  final bool isDisabled;

  /// Optional tooltip message displayed on hover or long-press.
  final String? tooltip;

  /// Creates a [ByTabItem].
  const ByTabItem({
    required this.label,
    this.icon,
    this.iconWidget,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    this.color,
    this.isDisabled = false,
    this.tooltip,
  });
}

/// A premium, hardware-accelerated segmented selector tab bar featuring
/// liquid mercury morphing indicator physics and dynamic glowing borders.
class ByTabBar extends StatefulWidget {
  /// The collection of tabs to display.
  final List<ByTabItem> tabs;

  /// Currently selected tab index (0-indexed).
  final int selectedIndex;

  /// Callback fired when a tab is tapped and selected.
  final ValueChanged<int> onTabChanged;

  /// Total container height. Defaults to 46.0.
  final double height;

  /// Background surface color of the outer pill container.
  final Color? backgroundColor;

  /// Border color of the outer pill container.
  final Color? borderColor;

  /// Border stroke width of the outer pill container. Defaults to 1.0.
  final double borderWidth;

  /// Active sliding indicator pill color.
  final Color? indicatorColor;

  /// Optional gradient fill for the active sliding indicator pill.
  final Gradient? indicatorGradient;

  /// Optional independent corner radius for the sliding indicator. Defaults to [borderRadius].
  final BorderRadius? indicatorBorderRadius;

  /// Optional static border stroke color for the sliding indicator pill.
  final Color? indicatorBorderColor;

  /// Optional static border stroke width for the sliding indicator pill.
  final double? indicatorBorderWidth;

  /// Optional custom shadow/glow color for the sliding indicator pill.
  final Color? indicatorShadowColor;

  /// Blur radius for the sliding indicator glow shadow. Defaults to 10.0.
  final double? indicatorShadowBlur;

  /// Maximum stretching factor for liquid elastic morphing. Defaults to 1.25.
  final double liquidStretchFactor;

  /// Active indicator text color.
  final Color? selectedTextColor;

  /// Inactive unselected text color.
  final Color? unselectedTextColor;

  /// Typography font size for tab labels. Defaults to 13.0.
  final double fontSize;

  /// Font weight for the currently selected tab. Defaults to [FontWeight.w700].
  final FontWeight selectedFontWeight;

  /// Font weight for unselected tabs. Defaults to [FontWeight.w500].
  final FontWeight unselectedFontWeight;

  /// Icon size for leading tab icons. Defaults to 16.0.
  final double iconSize;

  /// Horizontal spacing between leading icon and label. Defaults to 6.0.
  final double iconSpacing;

  /// Corner radius of the container and sliding indicator.
  final BorderRadius borderRadius;

  /// Internal padding between container edges and tab pills.
  final EdgeInsets padding;

  /// Whether to enable liquid elastic stretching when transitioning between tabs.
  final bool enableLiquidMorphing;

  /// Whether to render a traveling dynamic neon border along the active indicator.
  final bool enableDynamicBorder;

  /// Whether to render a traveling dynamic neon border along the outer bar container.
  final bool enableOuterDynamicBorder;

  /// Explicit custom dynamic border configuration for the outer bar container.
  final ByDynamicBorder? outerDynamicBorder;

  /// Colors for the traveling dynamic border beam.
  final List<Color>? dynamicBorderColors;

  /// Stroke width for the traveling dynamic border beam. Defaults to 1.5.
  final double dynamicBorderWidth;

  /// Glow blur for the traveling dynamic border beam. Defaults to 6.0.
  final double dynamicBorderGlowBlur;

  /// Duration for one complete dynamic border pulse cycle. Defaults to 1600ms.
  final Duration dynamicBorderDuration;

  /// Whether to trigger subtle tactile haptic vibration when switching tabs.
  final bool enableHapticFeedback;

  /// Transition duration when moving between tabs.
  final Duration animationDuration;

  /// The curve used for the sliding animation between tabs.
  /// Defaults to [Curves.easeOutCubic] for fluid and responsive motion.
  final Curve animationCurve;

  /// Whether to interpolate tab label, icon, and badge colors in direct synchronization
  /// with the indicator pill's physical overlap rather than an abrupt switch.
  /// Defaults to true.
  final bool enableColorTransition;

  /// Whether to trigger a dynamic border pulse beam along the sliding indicator pill
  /// when the selected tab changes, which runs first and then smoothly fades away.
  /// Defaults to true.
  final bool enableSelectionPulse;

  /// Colors for the tab selection dynamic border pulse beam.
  final List<Color>? selectionPulseColors;

  /// Duration for the selection dynamic border pulse cycle. Defaults to 650ms.
  final Duration selectionPulseDuration;

  /// Whether to automatically adapt selected text and icon contrast against the indicator color.
  /// When true, a light indicator automatically switches active text to dark slate / black87.
  /// Defaults to true.
  final bool autoContentColor;

  /// Visual style of the active tab indicator. Defaults to [ByTabIndicatorStyle.pill].
  final ByTabIndicatorStyle indicatorStyle;

  /// Whether tabs can scroll horizontally when they exceed available width. Defaults to false.
  final bool isScrollable;

  /// Height of the sliding accent line when [indicatorStyle] is [ByTabIndicatorStyle.underline].
  /// Defaults to 3.0.
  final double underlineHeight;

  /// Optional custom padding inside each individual tab slot.
  final EdgeInsetsGeometry? tabPadding;

  /// Whether to render subtle horizontal fade gradients when [isScrollable] is true.
  /// Defaults to true.
  final bool showScrollGradients;

  /// Creates a [BySegmentedTabBar].
  const ByTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.height = 46.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.indicatorColor,
    this.indicatorGradient,
    this.indicatorBorderRadius,
    this.indicatorBorderColor,
    this.indicatorBorderWidth,
    this.indicatorShadowColor,
    this.indicatorShadowBlur = 10.0,
    this.liquidStretchFactor = 1.25,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.fontSize = 13.0,
    this.selectedFontWeight = FontWeight.w700,
    this.unselectedFontWeight = FontWeight.w500,
    this.iconSize = 16.0,
    this.iconSpacing = 6.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
    this.padding = const EdgeInsets.all(4.0),
    this.enableLiquidMorphing = true,
    this.enableDynamicBorder = false,
    this.enableOuterDynamicBorder = false,
    this.outerDynamicBorder,
    this.dynamicBorderColors,
    this.dynamicBorderWidth = 1.5,
    this.dynamicBorderGlowBlur = 6.0,
    this.dynamicBorderDuration = const Duration(milliseconds: 1600),
    this.enableSelectionPulse = true,
    this.selectionPulseColors,
    this.selectionPulseDuration = const Duration(milliseconds: 650),
    this.autoContentColor = true,
    this.enableHapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 320),
    this.animationCurve = Curves.easeOutCubic,
    this.enableColorTransition = true,
    this.indicatorStyle = ByTabIndicatorStyle.pill,
    this.isScrollable = false,
    this.underlineHeight = 3.0,
    this.tabPadding,
    this.showScrollGradients = true,
  });

  @override
  State<ByTabBar> createState() => _ByTabBarState();
}

class _ByTabBarState extends State<ByTabBar> with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _selectionPulseController;
  ScrollController? _scrollController;

  // Normalized tab coordinates: Tab k occupies [k.0, (k + 1).0].
  double _startULeft = 0.0;
  double _startURight = 1.0;
  double _targetULeft = 0.0;
  double _targetURight = 1.0;

  // Current instantaneous normalized positions during animation
  double _currentULeft = 0.0;
  double _currentURight = 1.0;

  // Direction tracking: true if moving right, false if moving left
  bool _isMovingRight = true;

  @override
  void initState() {
    super.initState();
    if (widget.isScrollable) {
      _scrollController = ScrollController();
    }
    _startULeft = widget.selectedIndex.toDouble();
    _startURight = _startULeft + 1.0;
    _targetULeft = _startULeft;
    _targetURight = _startURight;
    _currentULeft = _startULeft;
    _currentURight = _startURight;

    _animController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animController.addListener(_onAnimationTick);

    _selectionPulseController = AnimationController(
      vsync: this,
      duration: widget.selectionPulseDuration,
    );
  }

  void _onAnimationTick() {
    final progress = _animController.value;
    _computeNormalizedPositions(progress);
  }

  void _computeNormalizedPositions(double progress) {
    if (_targetULeft == _startULeft && _targetURight == _startURight) {
      _currentULeft = _targetULeft;
      _currentURight = _targetURight;
      return;
    }

    final leadT = widget.animationCurve.transform(progress);
    const lagCurve = Curves.easeInOutCubic;
    final stretchWeight = widget.enableLiquidMorphing
        ? ((widget.liquidStretchFactor - 1.0) * 1.5).clamp(0.0, 0.75)
        : 0.0;
    final lagT = (1.0 - stretchWeight) * leadT +
        stretchWeight * lagCurve.transform(progress);

    if (_isMovingRight) {
      // Right edge leads forward, Left edge lags behind
      _currentURight = lerpDouble(_startURight, _targetURight, leadT)!;
      _currentULeft = lerpDouble(_startULeft, _targetULeft, lagT)!;
    } else {
      // Left edge leads backward, Right edge lags behind
      _currentULeft = lerpDouble(_startULeft, _targetULeft, leadT)!;
      _currentURight = lerpDouble(_startURight, _targetURight, lagT)!;
    }
  }

  @override
  void didUpdateWidget(covariant ByTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScrollable && _scrollController == null) {
      _scrollController = ScrollController();
    }
    if (oldWidget.animationDuration != widget.animationDuration) {
      _animController.duration = widget.animationDuration;
    }
    if (oldWidget.selectionPulseDuration != widget.selectionPulseDuration) {
      _selectionPulseController.duration = widget.selectionPulseDuration;
    }
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _animateTo(widget.selectedIndex);
    }
  }

  void _animateTo(int targetIndex) {
    // Start smoothly from wherever the indicator currently is (interruption resilient)
    _startULeft = _currentULeft;
    _startURight = _currentURight;

    _targetULeft = targetIndex.toDouble();
    _targetURight = _targetULeft + 1.0;

    _isMovingRight = _targetULeft >= _startULeft;

    _computeNormalizedPositions(0.0);
    _animController.forward(from: 0.0);

    if (widget.enableSelectionPulse) {
      _selectionPulseController.forward(from: 0.0);
    }

    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _animController.removeListener(_onAnimationTick);
    _animController.dispose();
    _selectionPulseController.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9));
    final borderCol = widget.borderColor ??
        (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    final indColor = widget.indicatorColor ??
        (isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5));

    final bool isIndicatorLight = indColor.computeLuminance() > 0.55;
    final bool isUnderline =
        widget.indicatorStyle == ByTabIndicatorStyle.underline;
    final bool isBgLight = bgColor.computeLuminance() > 0.55;

    final Color defaultSelTextColor;
    if (isUnderline) {
      // In underline mode, tab labels sit directly on the container/scaffold background.
      if (isBgLight) {
        defaultSelTextColor = (indColor.computeLuminance() > 0.75)
            ? const Color(0xFF0F172A)
            : indColor;
      } else {
        defaultSelTextColor =
            (indColor.computeLuminance() < 0.2) ? Colors.white : indColor;
      }
    } else {
      // In pill mode, tab labels sit on top of the sliding indicator pill.
      defaultSelTextColor =
          isIndicatorLight ? const Color(0xFF0F172A) : Colors.white;
    }

    final selTextColor = widget.selectedTextColor ??
        (widget.autoContentColor
            ? defaultSelTextColor
            : (isUnderline ? defaultSelTextColor : Colors.white));
    final unselTextColor = widget.unselectedTextColor ??
        (widget.autoContentColor
            ? (bgColor.computeLuminance() > 0.55
                ? const Color(0xFF475569)
                : const Color(0xFF94A3B8))
            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)));

    final tabCount = widget.tabs.length;
    if (tabCount == 0) return const SizedBox.shrink();

    final effectiveIndicatorRadius =
        widget.indicatorBorderRadius ?? widget.borderRadius;
    final effectiveShadowColor =
        widget.indicatorShadowColor ?? indColor.withValues(alpha: 0.4);
    final effectiveShadowBlur = widget.indicatorShadowBlur ?? 10.0;

    final borderColors = widget.enableDynamicBorder
        ? (widget.dynamicBorderColors ??
            [
              Colors.white,
              indColor,
              const Color(0xFF38BDF8),
            ])
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final borderInset =
            widget.borderWidth > 0 ? widget.borderWidth * 2 : 0.0;
        final singleBorderWidth =
            widget.borderWidth > 0 ? widget.borderWidth : 0.0;
        final innerWidth =
            math.max(0.0, totalWidth - widget.padding.horizontal - borderInset);
        final innerHeight = math.max(
            0.0, widget.height - widget.padding.vertical - borderInset);
        final baseTabWidth = innerWidth / tabCount;
        final tabWidth =
            widget.isScrollable ? math.max(110.0, baseTabWidth) : baseTabWidth;
        final contentWidth = tabWidth * tabCount;

        final innerClipRadius = BorderRadius.only(
          topLeft: Radius.circular(math.max(
            0.0,
            widget.borderRadius.topLeft.x -
                widget.padding.left -
                singleBorderWidth,
          )),
          topRight: Radius.circular(math.max(
            0.0,
            widget.borderRadius.topRight.x -
                widget.padding.right -
                singleBorderWidth,
          )),
          bottomLeft: Radius.circular(math.max(
            0.0,
            widget.borderRadius.bottomLeft.x -
                widget.padding.left -
                singleBorderWidth,
          )),
          bottomRight: Radius.circular(math.max(
            0.0,
            widget.borderRadius.bottomRight.x -
                widget.padding.right -
                singleBorderWidth,
          )),
        );

        Widget bar = Container(
          width: totalWidth,
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: widget.borderRadius,
            border: widget.borderWidth > 0
                ? Border.all(color: borderCol, width: widget.borderWidth)
                : null,
          ),
          child: AnimatedBuilder(
            animation:
                Listenable.merge([_animController, _selectionPulseController]),
            builder: (context, _) {
              final rawLeft = _currentULeft * tabWidth;
              final rawRight = _currentURight * tabWidth;

              // Ensure physical safety against overshoot curves
              final maxContentW = math.max(innerWidth, contentWidth);
              final leftPx = rawLeft.clamp(0.0, maxContentW - tabWidth * 0.2);
              final rightPx =
                  rawRight.clamp(leftPx + tabWidth * 0.2, maxContentW);
              final widthPx = math.max(0.0, rightPx - leftPx);

              final bool isPulsing = widget.enableSelectionPulse &&
                  _selectionPulseController.isAnimating;
              final double pulseProgress =
                  isPulsing ? _selectionPulseController.value : 0.0;

              // Dynamic laser beam opacity: full intensity during circuit,
              // smoothly fades out near completion (0.68 -> 1.0)
              final double dynamicOpacity = isPulsing
                  ? (pulseProgress < 0.68
                      ? 1.0
                      : ((1.0 - pulseProgress) / 0.32).clamp(0.0, 1.0))
                  : 0.0;

              // Static border opacity: stays hidden while dynamic pulse runs,
              // then fades in smoothly (0.65 -> 1.0)
              final double staticBorderOpacity = isPulsing
                  ? (pulseProgress > 0.65
                      ? ((pulseProgress - 0.65) / 0.35).clamp(0.0, 1.0)
                      : 0.0)
                  : 1.0;

              final isUnderline =
                  widget.indicatorStyle == ByTabIndicatorStyle.underline;
              final indicatorRadius = isUnderline
                  ? BorderRadius.circular(widget.underlineHeight / 2)
                  : effectiveIndicatorRadius;
              final indicatorHeight =
                  isUnderline ? widget.underlineHeight : innerHeight;

              final Widget pillBase = Container(
                width: widthPx,
                height: indicatorHeight,
                decoration: BoxDecoration(
                  color: widget.indicatorGradient == null ? indColor : null,
                  gradient: widget.indicatorGradient,
                  borderRadius: indicatorRadius,
                  border: !isUnderline &&
                          widget.indicatorBorderColor != null &&
                          staticBorderOpacity > 0.0
                      ? Border.all(
                          color: widget.indicatorBorderColor!.withValues(
                            alpha: widget.indicatorBorderColor!.a *
                                staticBorderOpacity,
                          ),
                          width: widget.indicatorBorderWidth ?? 1.0,
                        )
                      : null,
                  boxShadow: effectiveShadowBlur > 0
                      ? [
                          BoxShadow(
                            color: effectiveShadowColor,
                            blurRadius: effectiveShadowBlur,
                            offset: isUnderline
                                ? const Offset(0, 1)
                                : const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
              );

              final pulseColors = widget.selectionPulseColors ??
                  [
                    Colors.white,
                    indColor,
                    const Color(0xFF38BDF8),
                  ];

              final Widget indicatorPill = Stack(
                fit: StackFit.passthrough,
                clipBehavior: Clip.none,
                children: [
                  pillBase,
                  if (widget.enableDynamicBorder &&
                      borderColors != null &&
                      !isPulsing)
                    Positioned.fill(
                      child: ByDynamicBorderLayer(
                        key: const ValueKey('indicator_continuous_border'),
                        config: ByDynamicBorder(
                          enabled: true,
                          colors: borderColors,
                          width: widget.dynamicBorderWidth,
                          glowBlur: widget.dynamicBorderGlowBlur,
                          duration: widget.dynamicBorderDuration,
                          autoStart: true,
                          repeatCount: null,
                        ),
                        borderRadius: indicatorRadius,
                      ),
                    ),
                  if (widget.enableSelectionPulse &&
                      isPulsing &&
                      dynamicOpacity > 0.0)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: dynamicOpacity,
                          child: CustomPaint(
                            painter: ByDynamicBorderPainter(
                              config: ByDynamicBorder(
                                enabled: true,
                                colors: pulseColors,
                                width: widget.dynamicBorderWidth * 1.3,
                                glowBlur: widget.dynamicBorderGlowBlur + 3.0,
                                duration: widget.selectionPulseDuration,
                              ),
                              borderRadius: indicatorRadius,
                              progress: pulseProgress.clamp(0.001, 0.999),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );

              final tabWidgets = List.generate(tabCount, (index) {
                final tab = widget.tabs[index];
                final isSelected = widget.selectedIndex == index;

                // Calculate exact real-time overlap fraction with the indicator pill
                double overlap = isSelected ? 1.0 : 0.0;
                if (widget.enableColorTransition && !isUnderline) {
                  final tabUStart = index.toDouble();
                  final tabUEnd = (index + 1).toDouble();
                  final overlapStart = math.max(tabUStart, _currentULeft);
                  final overlapEnd = math.min(tabUEnd, _currentURight);
                  overlap = (overlapEnd - overlapStart).clamp(0.0, 1.0);
                }

                final effectiveTextColor = isUnderline
                    ? (isSelected ? selTextColor : unselTextColor)
                    : (widget.enableColorTransition
                        ? Color.lerp(unselTextColor, selTextColor, overlap)!
                        : (isSelected ? selTextColor : unselTextColor));

                final effectiveIconColor = isUnderline
                    ? (isSelected ? selTextColor : unselTextColor)
                    : (widget.enableColorTransition
                        ? Color.lerp(unselTextColor, selTextColor, overlap)!
                        : (isSelected ? selTextColor : unselTextColor));

                final badgeBg = tab.badgeColor ??
                    (!isUnderline && widget.enableColorTransition
                        ? Color.lerp(
                            indColor.withValues(alpha: 0.15),
                            Colors.white.withValues(alpha: 0.25),
                            overlap,
                          )!
                        : (isSelected
                            ? indColor.withValues(alpha: 0.2)
                            : indColor.withValues(alpha: 0.15)));

                final badgeFg = tab.badgeTextColor ??
                    (!isUnderline && widget.enableColorTransition
                        ? Color.lerp(indColor, selTextColor, overlap)!
                        : (isSelected
                            ? (isUnderline ? indColor : selTextColor)
                            : indColor));

                final effectiveFontWeight =
                    (isUnderline ? isSelected : overlap >= 0.5)
                        ? widget.selectedFontWeight
                        : widget.unselectedFontWeight;

                Widget itemContent = Opacity(
                  opacity: tab.isDisabled ? 0.38 : 1.0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (tab.isDisabled) return;
                      if (widget.selectedIndex != index) {
                        widget.onTabChanged(index);
                        if (widget.isScrollable && _scrollController != null) {
                          final targetOffset = (index * tabWidth) -
                              (innerWidth / 2) +
                              (tabWidth / 2);
                          final clamped = targetOffset.clamp(
                            0.0,
                            _scrollController!.position.maxScrollExtent,
                          );
                          _scrollController!.animateTo(
                            clamped,
                            duration: widget.animationDuration,
                            curve: widget.animationCurve,
                          );
                        }
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: widget.tabPadding ??
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (tab.iconWidget != null) ...[
                                tab.iconWidget!,
                                SizedBox(width: widget.iconSpacing),
                              ] else if (tab.icon != null) ...[
                                Icon(
                                  tab.icon,
                                  size: widget.iconSize,
                                  color: effectiveIconColor,
                                ),
                                SizedBox(width: widget.iconSpacing),
                              ],
                              Text(
                                tab.label,
                                style: TextStyle(
                                  color: effectiveTextColor,
                                  fontSize: widget.fontSize,
                                  fontWeight: effectiveFontWeight,
                                ),
                              ),
                              if (tab.badge != null) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    tab.badge!,
                                    style: TextStyle(
                                      color: badgeFg,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );

                if (tab.tooltip != null) {
                  itemContent = Tooltip(
                    message: tab.tooltip!,
                    waitDuration: const Duration(milliseconds: 300),
                    child: itemContent,
                  );
                }

                if (widget.isScrollable) {
                  return SizedBox(width: tabWidth, child: itemContent);
                }

                return Expanded(child: itemContent);
              });

              final innerStack = SizedBox(
                width: widget.isScrollable ? contentWidth : innerWidth,
                height: innerHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Fluid Sliding Indicator
                    Positioned(
                      left: leftPx,
                      width: widthPx,
                      top: isUnderline ? null : 0,
                      bottom: 0,
                      height: isUnderline ? widget.underlineHeight : null,
                      child: indicatorPill,
                    ),

                    // Interactive Tab Items Layer
                    Row(
                      children: tabWidgets,
                    ),
                  ],
                ),
              );

              if (widget.isScrollable) {
                return NotificationListener<ScrollNotification>(
                  onNotification: (_) => true,
                  child: ClipRRect(
                    borderRadius: innerClipRadius,
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      child: innerStack,
                    ),
                  ),
                );
              }

              if (isUnderline) {
                return ClipRRect(
                  borderRadius: innerClipRadius,
                  clipBehavior: Clip.antiAlias,
                  child: innerStack,
                );
              }

              return innerStack;
            },
          ),
        );

        if (widget.enableOuterDynamicBorder ||
            widget.outerDynamicBorder != null) {
          bar = ByDynamicBorderLayer(
            config: widget.outerDynamicBorder ??
                ByDynamicBorder(
                  enabled: true,
                  colors: borderColors ??
                      [
                        indColor,
                        Colors.white,
                        const Color(0xFF38BDF8),
                      ],
                  width: widget.dynamicBorderWidth,
                  glowBlur: widget.dynamicBorderGlowBlur,
                  duration: widget.dynamicBorderDuration,
                  autoStart: true,
                  repeatCount: null,
                ),
            borderRadius: widget.borderRadius,
            child: bar,
          );
        }

        return bar;
      },
    );
  }
}

/// Backward compatibility alias for [ByTabBar].
typedef BySegmentedTabBar = ByTabBar;
