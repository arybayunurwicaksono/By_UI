import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../card/by_card_controller.dart';
import '../dynamic_border/by_dynamic_border.dart';
import '../dynamic_border/by_dynamic_border_layer.dart';
import '../dynamic_border/by_dynamic_border_painter.dart';

/// Behavior for displaying item labels in [ByBottomNav].
enum ByBottomNavLabelBehavior {
  /// Labels are only shown on hover or long-press via a tooltip.
  tooltipOnly,

  /// Labels are permanently visible underneath icons.
  alwaysShow,

  /// Labels are only visible for the currently active/selected item.
  onlySelected,
}

/// Visual style for active item indicator in [ByBottomNav].
enum ByBottomNavIndicatorStyle {
  /// Illuminated glowing micro-dot underneath the icon (default).
  dot,

  /// Subtle horizontal accent line beneath the icon.
  line,

  /// Active background pill/capsule surrounding the item.
  pill,

  /// No additional active indicator shape.
  none,
}

/// Data item configuration for [ByFloatingNavDock].
class ByBottomNavItem {
  /// Icon displayed in the dock.
  final IconData icon;

  /// Optional custom widget icon taking precedence over [icon].
  final Widget? customIcon;

  /// Semantic text label or tooltip for the dock item.
  final String label;

  /// Optional numeric badge count (e.g. unread count).
  final int? badgeCount;

  /// Optional custom text badge (e.g. "99+", "HOT", "NEW"). Takes precedence over [badgeCount].
  final String? badgeText;

  /// Whether to show an unread status dot badge instead of a numeric badge.
  final bool showBadgeDot;

  /// Optional custom background color for the badge indicator.
  final Color? badgeColor;

  /// Optional custom text color for the badge indicator.
  final Color? badgeTextColor;

  /// Optional custom accent color for this specific item when active.
  final Color? activeColor;

  /// Whether this item is enabled and interactable. Defaults to true.
  final bool enabled;

  /// Creates a [ByDockItem].
  const ByBottomNavItem({
    required this.icon,
    required this.label,
    this.customIcon,
    this.badgeCount,
    this.badgeText,
    this.showBadgeDot = false,
    this.badgeColor,
    this.badgeTextColor,
    this.activeColor,
    this.enabled = true,
  });
}

/// A macOS/iPadOS-inspired floating glassmorphic navigation dock featuring
/// parabolic magnetic cursor proximity magnification and spatial tilt glow.
class ByBottomNav extends StatefulWidget {
  /// The collection of navigation items.
  final List<ByBottomNavItem> items;

  /// Currently selected item index.
  final int selectedIndex;

  /// Callback fired when an item is selected.
  final ValueChanged<int> onItemSelected;

  /// Maximum scale multiplier when cursor/touch is directly centered on an item. Defaults to 1.35.
  final double maxMagnification;

  /// Distance in logical pixels where magnetic proximity scaling takes effect. Defaults to 90.0.
  final double proximityRange;

  /// Whether to enable device accelerometer tilt tracking on mobile.
  final bool enableSensor;

  /// Whether to enable magnetic hover magnification on Desktop/Web.
  final bool enableMagneticProximity;

  /// Glassmorphism backdrop blur sigma. Defaults to 16.0.
  final double blurSigma;

  /// Base surface background color with transparency.
  final Color? backgroundColor;

  /// Outer border stroke color.
  final Color? borderColor;

  /// Outer border stroke width. Defaults to 1.2.
  final double borderWidth;

  /// Active indicator glow color.
  final Color? activeColor;

  /// Width and height of individual dock item slot containers. Defaults to 44.0.
  final double itemSize;

  /// Size of icon glyphs inside dock item slots. Defaults to 22.0.
  final double iconSize;

  /// Corner radius for individual dock item slot containers. Defaults to 14.0.
  final BorderRadius itemBorderRadius;

  /// Background surface color for the active dock item slot.
  final Color? activeItemBackgroundColor;

  /// Color for unselected/inactive item icons.
  final Color? unselectedItemColor;

  /// Whether to display the illuminated dot indicator under the active item. Defaults to true.
  final bool showActiveDot;

  /// Diameter size of the active illuminated dot indicator. Defaults to 4.0.
  final double activeDotSize;

  /// Color of the active illuminated dot indicator.
  final Color? activeDotColor;

  /// Color of the ambient spatial tilt / dock drop shadow.
  final Color? glowColor;

  /// Blur radius of the ambient spatial tilt / dock drop shadow. Defaults to 18.0.
  final double glowBlurRadius;

  /// Corner radius of the dock capsule. Defaults to 28.0.
  final BorderRadius borderRadius;

  /// Internal padding around dock items.
  final EdgeInsets padding;

  /// Whether to render a traveling dynamic neon border along the dock perimeter.
  final bool enableDynamicBorder;

  /// Colors for the traveling dynamic border beam.
  final List<Color>? dynamicBorderColors;

  /// Stroke width for the traveling dynamic border beam. Defaults to 1.5.
  final double dynamicBorderWidth;

  /// Glow blur radius for the traveling dynamic border beam. Defaults to 8.0.
  final double dynamicBorderGlowBlur;

  /// Duration for one complete cycle of the dynamic border beam. Defaults to 2000ms.
  final Duration dynamicBorderDuration;

  /// Repeat count for the traveling dynamic perimeter neon border.
  /// 1 = pulse once upon load/mount then disappear (default),
  /// N = loop N times, null = loop indefinitely.
  final int? dynamicBorderRepeatCount;

  /// Default background color for item badges. Defaults to Red 500 (#EF4444).
  final Color? badgeColor;

  /// Default text color for item badges. Defaults to white.
  final Color? badgeTextColor;

  /// Optional custom color override for the selected item icon/label.
  final Color? selectedItemColor;

  /// Whether to automatically adapt icon and content contrast against the dock background.
  /// When true, a light background automatically switches content to crisp dark slate / black87.
  /// Defaults to true.
  final bool autoContentColor;

  /// Whether to trigger a dynamic border pulse beam around the tapped item slot before
  /// revealing the static active border. Defaults to true.
  final bool enableSelectionPulse;

  /// Colors for the item slot selection dynamic pulse beam.
  final List<Color>? selectionPulseColors;

  /// Duration for the selection dynamic pulse cycle. Defaults to 650ms.
  final Duration selectionPulseDuration;

  /// Controls how text labels are rendered. Defaults to [ByBottomNavLabelBehavior.tooltipOnly].
  final ByBottomNavLabelBehavior labelBehavior;

  /// Whether the navigation bar is rendered as a floating capsule dock (true) or
  /// a full-width bar docked at the bottom of the screen with safe area padding (false).
  /// Defaults to true.
  final bool isFloating;

  /// Visual style of the active item indicator. Defaults to [ByBottomNavIndicatorStyle.dot].
  final ByBottomNavIndicatorStyle activeIndicatorStyle;

  /// Whether to trigger subtle tactile haptic vibration when tapping items. Defaults to true.
  final bool enableHapticFeedback;

  /// Custom typography style for selected item text labels.
  final TextStyle? selectedLabelStyle;

  /// Custom typography style for unselected item text labels.
  final TextStyle? unselectedLabelStyle;

  /// Vertical spacing between the icon slot and the text label. Defaults to 3.0.
  final double labelSpacing;

  /// Creates a [ByFloatingNavDock].
  const ByBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.maxMagnification = 1.35,
    this.proximityRange = 90.0,
    this.enableSensor = false,
    this.enableMagneticProximity = true,
    this.blurSigma = 16.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.activeColor,
    this.itemSize = 44.0,
    this.iconSize = 22.0,
    this.itemBorderRadius = const BorderRadius.all(Radius.circular(14.0)),
    this.activeItemBackgroundColor,
    this.unselectedItemColor,
    this.selectedItemColor,
    this.autoContentColor = true,
    this.showActiveDot = true,
    this.activeDotSize = 4.0,
    this.activeDotColor,
    this.glowColor,
    this.glowBlurRadius = 18.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(28.0)),
    this.padding = const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
    this.enableDynamicBorder = false,
    this.dynamicBorderColors,
    this.dynamicBorderWidth = 1.5,
    this.dynamicBorderGlowBlur = 8.0,
    this.dynamicBorderDuration = const Duration(milliseconds: 2000),
    this.dynamicBorderRepeatCount = 1,
    this.badgeColor,
    this.badgeTextColor,
    this.enableSelectionPulse = true,
    this.selectionPulseColors,
    this.selectionPulseDuration = const Duration(milliseconds: 650),
    this.labelBehavior = ByBottomNavLabelBehavior.tooltipOnly,
    this.isFloating = true,
    this.activeIndicatorStyle = ByBottomNavIndicatorStyle.dot,
    this.enableHapticFeedback = true,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.labelSpacing = 3.0,
  });

  @override
  State<ByBottomNav> createState() => _ByBottomNavState();
}

class _ByBottomNavState extends State<ByBottomNav>
    with SingleTickerProviderStateMixin {
  Offset? _cursorGlobalPos;
  late List<GlobalKey> _itemKeys;
  late final ByTiltController _tiltController;
  int? _pulsingIndex;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
    _tiltController = ByTiltController(
      enableSensor: widget.enableSensor &&
          !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: widget.selectionPulseDuration,
    );
    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _pulsingIndex = null;
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant ByBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != oldWidget.items.length) {
      _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
    }
    if (widget.selectionPulseDuration != oldWidget.selectionPulseDuration) {
      _pulseController.duration = widget.selectionPulseDuration;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tiltController.dispose();
    super.dispose();
  }

  double _calculateScale(int index) {
    if (!widget.enableMagneticProximity || _cursorGlobalPos == null) {
      return 1.0;
    }
    if (index >= _itemKeys.length) {
      return 1.0;
    }

    final key = _itemKeys[index];
    final itemContext = key.currentContext;
    if (itemContext == null || !itemContext.mounted) {
      return 1.0;
    }

    final renderBox = itemContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      return 1.0;
    }

    try {
      final itemCenterGlobal =
          renderBox.localToGlobal(renderBox.size.center(Offset.zero));
      final distance = (_cursorGlobalPos!.dx - itemCenterGlobal.dx).abs();

      // Proportional proximity scaling if the dock is scaled down by FittedBox on small viewports
      final localOrigin = renderBox.localToGlobal(Offset.zero);
      final localRight =
          renderBox.localToGlobal(Offset(renderBox.size.width, 0));
      final physicalItemWidth = (localRight.dx - localOrigin.dx).abs();
      final scaleRatio = renderBox.size.width > 0
          ? (physicalItemWidth / renderBox.size.width)
          : 1.0;
      final effectiveProximityRange =
          widget.proximityRange * scaleRatio.clamp(0.4, 1.0);

      if (distance >= effectiveProximityRange) {
        return 1.0;
      }
      // Parabolic easing curve: 1 - (d / range)^2
      final factor = 1.0 - (distance / effectiveProximityRange);
      final parabolic = factor * factor;
      return 1.0 + (widget.maxMagnification - 1.0) * parabolic;
    } catch (_) {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = widget.backgroundColor ??
        (isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.75)
            : const Color(0xFFFFFFFF).withValues(alpha: 0.85));

    final borderCol = widget.borderColor ??
        (isDark
            ? const Color(0xFF334155).withValues(alpha: 0.6)
            : const Color(0xFFCBD5E1).withValues(alpha: 0.8));

    final activeCol = widget.activeColor ??
        (isDark ? const Color(0xFF38BDF8) : const Color(0xFF6366F1));

    final effectiveGlowColor =
        widget.glowColor ?? activeCol.withValues(alpha: 0.25);

    return MouseRegion(
      onHover: (event) {
        setState(() {
          _cursorGlobalPos = event.position;
        });
      },
      onExit: (_) {
        setState(() {
          _cursorGlobalPos = null;
        });
      },
      child: ValueListenableBuilder<Offset>(
        valueListenable: _tiltController.tiltNotifier,
        builder: (context, tilt, _) {
          // Dynamic tilt-driven ambient glow shadow
          final shadowOffset = Offset(tilt.dx * 8.0, tilt.dy * 8.0);

          final effectiveBorderRadius = widget.isFloating
              ? widget.borderRadius
              : const BorderRadius.vertical(top: Radius.circular(16.0));

          Widget dockBody = ClipRRect(
            borderRadius: effectiveBorderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blurSigma,
                sigmaY: widget.blurSigma,
              ),
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: effectiveBorderRadius,
                  border: widget.borderWidth > 0
                      ? (widget.isFloating
                          ? Border.all(
                              color: borderCol, width: widget.borderWidth)
                          : Border(
                              top: BorderSide(
                                  color: borderCol, width: widget.borderWidth)))
                      : null,
                  boxShadow: widget.glowBlurRadius > 0
                      ? [
                          BoxShadow(
                            color: effectiveGlowColor,
                            blurRadius: widget.glowBlurRadius,
                            offset: shadowOffset,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize:
                      widget.isFloating ? MainAxisSize.min : MainAxisSize.max,
                  mainAxisAlignment: widget.isFloating
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceEvenly,
                  children: List.generate(widget.items.length, (index) {
                    final item = widget.items[index];
                    final isSelected = widget.selectedIndex == index;
                    final scale = _calculateScale(index);

                    final itemActiveColor = item.activeColor ?? activeCol;

                    final isBgLight = bgColor.computeLuminance() > 0.5;

                    final effectiveUnselectedColor =
                        widget.unselectedItemColor ??
                            (widget.autoContentColor
                                ? (isBgLight
                                    ? const Color(0xFF475569)
                                    : const Color(0xFF94A3B8))
                                : (isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B)));

                    final effectiveSelectedColor = widget.selectedItemColor ??
                        item.activeColor ??
                        (widget.autoContentColor
                            ? (isBgLight
                                ? const Color(0xFF0F172A)
                                : Colors.white)
                            : activeCol);

                    final itemBgColor = isSelected
                        ? (widget.activeItemBackgroundColor ??
                            itemActiveColor.withValues(
                              alpha: isDark ? 0.25 : 0.15,
                            ))
                        : Colors.transparent;

                    final itemFgColor = isSelected
                        ? effectiveSelectedColor
                        : effectiveUnselectedColor;

                    final badgeBackground = item.badgeColor ??
                        widget.badgeColor ??
                        const Color(0xFFEF4444);
                    final badgeForeground = item.badgeTextColor ??
                        widget.badgeTextColor ??
                        Colors.white;

                    final effectiveDotColor = widget.activeDotColor ??
                        (widget.autoContentColor
                            ? (isBgLight
                                ? const Color(0xFF0F172A)
                                : itemActiveColor)
                            : itemActiveColor);

                    return Opacity(
                      opacity: item.enabled ? 1.0 : 0.38,
                      child: GestureDetector(
                        key: _itemKeys[index],
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (!item.enabled) return;
                          if (widget.selectedIndex != index) {
                            if (widget.enableHapticFeedback) {
                              HapticFeedback.selectionClick();
                            }
                            if (widget.enableSelectionPulse) {
                              setState(() {
                                _pulsingIndex = index;
                              });
                              _pulseController.forward(from: 0.0);
                            }
                            widget.onItemSelected(index);
                          }
                        },
                        child: AnimatedScale(
                          scale: scale,
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOutCubic,
                          child: Tooltip(
                            message: item.label,
                            waitDuration: const Duration(milliseconds: 500),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 6.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      AnimatedBuilder(
                                        animation: _pulseController,
                                        builder: (context, _) {
                                          final bool isPulsing =
                                              widget.enableSelectionPulse &&
                                                  _pulsingIndex == index;
                                          final double pulseProgress = isPulsing
                                              ? _pulseController.value
                                              : 0.0;

                                          // Dynamic laser beam opacity: full intensity during circuit,
                                          // smoothly fades out near completion (0.68 -> 1.0)
                                          final double dynamicOpacity =
                                              isPulsing
                                                  ? (pulseProgress < 0.68
                                                      ? 1.0
                                                      : ((1.0 - pulseProgress) /
                                                              0.32)
                                                          .clamp(0.0, 1.0))
                                                  : 0.0;

                                          // Static border opacity: stays hidden while dynamic pulse runs,
                                          // then fades in smoothly (0.65 -> 1.0)
                                          final double staticBorderOpacity =
                                              isSelected
                                                  ? (isPulsing
                                                      ? (pulseProgress > 0.65
                                                          ? ((pulseProgress -
                                                                      0.65) /
                                                                  0.35)
                                                              .clamp(0.0, 1.0)
                                                          : 0.0)
                                                      : 1.0)
                                                  : 0.0;

                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: widget.itemSize,
                                                height: widget.itemSize,
                                                decoration: BoxDecoration(
                                                  color: itemBgColor,
                                                  borderRadius:
                                                      widget.itemBorderRadius,
                                                  border: staticBorderOpacity >
                                                          0.0
                                                      ? Border.all(
                                                          color: itemActiveColor
                                                              .withValues(
                                                            alpha: 0.6 *
                                                                staticBorderOpacity,
                                                          ),
                                                          width: 1.2,
                                                        )
                                                      : null,
                                                ),
                                                child: Center(
                                                  child: item.customIcon ??
                                                      Icon(
                                                        item.icon,
                                                        size: widget.iconSize,
                                                        color: itemFgColor,
                                                      ),
                                                ),
                                              ),
                                              if (isPulsing &&
                                                  dynamicOpacity > 0.0)
                                                Positioned.fill(
                                                  child: IgnorePointer(
                                                    child: Opacity(
                                                      opacity: dynamicOpacity,
                                                      child: CustomPaint(
                                                        painter:
                                                            ByDynamicBorderPainter(
                                                          config:
                                                              ByDynamicBorder(
                                                            enabled: true,
                                                            colors: widget
                                                                    .selectionPulseColors ??
                                                                [
                                                                  itemActiveColor,
                                                                  Colors.white,
                                                                  const Color(
                                                                      0xFF38BDF8),
                                                                ],
                                                            width: 1.8,
                                                            glowBlur: 7.0,
                                                          ),
                                                          borderRadius: widget
                                                              .itemBorderRadius,
                                                          progress:
                                                              (pulseProgress /
                                                                      0.85)
                                                                  .clamp(0.0,
                                                                      0.999),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                      if (item.showBadgeDot)
                                        Positioned(
                                          top: -2,
                                          right: -2,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: badgeBackground,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      else if (item.badgeText != null ||
                                          (item.badgeCount != null &&
                                              item.badgeCount! > 0))
                                        Positioned(
                                          top: -4,
                                          right: -6,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: badgeBackground,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              item.badgeText ??
                                                  '${item.badgeCount}',
                                              style: TextStyle(
                                                color: badgeForeground,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (widget.activeIndicatorStyle ==
                                          ByBottomNavIndicatorStyle.dot &&
                                      widget.showActiveDot) ...[
                                    const SizedBox(height: 4),
                                    // Active Dot Indicator
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width:
                                          isSelected ? widget.activeDotSize : 0,
                                      height:
                                          isSelected ? widget.activeDotSize : 0,
                                      decoration: BoxDecoration(
                                        color: effectiveDotColor,
                                        shape: BoxShape.circle,
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: effectiveDotColor,
                                                  blurRadius: 4,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ] else if (widget.activeIndicatorStyle ==
                                      ByBottomNavIndicatorStyle.line) ...[
                                    const SizedBox(height: 4),
                                    // Active Line Indicator
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: isSelected ? 16.0 : 0.0,
                                      height: 2.5,
                                      decoration: BoxDecoration(
                                        color: effectiveDotColor,
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: effectiveDotColor,
                                                  blurRadius: 4,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ],
                                  if (widget.labelBehavior !=
                                      ByBottomNavLabelBehavior.tooltipOnly) ...[
                                    SizedBox(height: widget.labelSpacing),
                                    AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      opacity: (widget.labelBehavior ==
                                                  ByBottomNavLabelBehavior
                                                      .alwaysShow ||
                                              isSelected)
                                          ? 1.0
                                          : 0.0,
                                      child: Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: isSelected
                                            ? (widget.selectedLabelStyle ??
                                                TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: itemFgColor,
                                                ))
                                            : (widget.unselectedLabelStyle ??
                                                TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: itemFgColor,
                                                )),
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
                  }),
                ),
              ),
            ),
          );

          if (widget.enableDynamicBorder) {
            final borderColors = widget.dynamicBorderColors ??
                [
                  activeCol,
                  Colors.white,
                  const Color(0xFF38BDF8),
                ];

            dockBody = ByDynamicBorderLayer(
              config: ByDynamicBorder(
                enabled: true,
                colors: borderColors,
                width: widget.dynamicBorderWidth,
                glowBlur: widget.dynamicBorderGlowBlur,
                duration: widget.dynamicBorderDuration,
                autoStart: true,
                repeatCount: widget.dynamicBorderRepeatCount,
              ),
              borderRadius: effectiveBorderRadius,
              child: dockBody,
            );
          }

          if (widget.isFloating) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: dockBody,
            );
          }

          return SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: dockBody,
            ),
          );
        },
      ),
    );
  }
}

/// Backward compatibility alias for [ByBottomNavItem].
typedef ByNavItem = ByBottomNavItem;

/// Backward compatibility alias for [ByBottomNavItem].
typedef ByDockItem = ByBottomNavItem;

/// Backward compatibility alias for [ByBottomNav].
typedef ByFloatingNavDock = ByBottomNav;
