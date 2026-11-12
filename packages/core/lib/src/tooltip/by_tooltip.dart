import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dynamic_border/by_dynamic_border.dart';
import '../dynamic_border/by_dynamic_border_layer.dart';
import 'by_tooltip_enums.dart';

/// Scope widget providing access to dismiss the active [ByTooltip].
class ByTooltipScope extends InheritedWidget {
  /// Callback to dismiss the tooltip or popover.
  final VoidCallback onClose;

  const ByTooltipScope({
    super.key,
    required this.onClose,
    required super.child,
  });

  /// Retrieves the nearest [ByTooltipScope] in the widget tree.
  static ByTooltipScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ByTooltipScope>();
  }

  /// Closes the nearest ancestor [ByTooltip] if currently visible.
  static void close(BuildContext context) {
    maybeOf(context)?.onClose();
  }

  @override
  bool updateShouldNotify(ByTooltipScope oldWidget) =>
      onClose != oldWidget.onClose;
}

/// A responsive, cursor-anchored or target-anchored tooltip & popover for Web, Desktop, and Touch devices.
///
/// Features:
/// - Real-time cursor coordinate tracking with frozen anchor on emergence ([ByTooltipAnchor.cursor]).
/// - Target-relative bounding box anchoring ([ByTooltipAnchor.target]).
/// - Full layout customizability via [builder] (or [cardBuilder]).
/// - Standard tooltip styling (background, border, radius, shadows, padding).
/// - Dynamic traveling laser pulse integration via [dynamicBorder].
/// - Automatic screen boundary clamping & auto-flipping (prevents off-screen clipping).
/// - Interactive hover bridge: moving cursor into the tooltip keeps it active and clickable.
/// - Auto-dismiss on scroll and Escape key.
/// - Mobile touch parity: tapping or long-pressing the trigger opens the floating tooltip.
class ByTooltip extends StatefulWidget {
  /// The target widget that triggers the tooltip.
  final Widget child;

  /// Builder callback that constructs the tooltip content layout.
  final WidgetBuilder? builder;

  /// Backward-compatible alias for [builder].
  final WidgetBuilder? cardBuilder;

  /// Where the tooltip anchors: [ByTooltipAnchor.cursor] (default) or [ByTooltipAnchor.target].
  final ByTooltipAnchor anchor;

  /// Offset applied to the anchor position. Defaults to Offset(12, 12).
  final Offset offset;

  /// Delay before opening the tooltip after pointer enters the trigger.
  /// Defaults to 150ms to prevent jitter when cursor sweeps across.
  final Duration openDelay;

  /// Grace period before closing the tooltip after pointer exits trigger/tooltip.
  /// Defaults to 220ms, allowing users to move cursor seamlessly into the tooltip.
  final Duration closeDelay;

  /// Duration of entrance and exit animations.
  final Duration animationDuration;

  /// Animation style transition. Defaults to [ByTooltipAnimation.fadeAndScale].
  final ByTooltipAnimation animationType;

  /// Easing curve for the entrance animation. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Solid background surface color. If null, automatically adapts to current theme
  /// (white on light theme, dark slate `#0F172A` on dark theme).
  final Color? backgroundColor;

  /// Corner radius of the tooltip container. Defaults to 14px.
  final BorderRadius borderRadius;

  /// Optional border stroke around the tooltip.
  final Border? border;

  /// Elevation shadows for the tooltip.
  final List<BoxShadow>? shadows;

  /// Inner padding of the tooltip container. Defaults to symmetric(12px).
  final EdgeInsetsGeometry padding;

  /// Explicit fixed width for the tooltip.
  final double? width;

  /// Maximum constrained width for the tooltip.
  final double? maxWidth;

  /// Minimum constrained width for the tooltip.
  final double? minWidth;

  /// Explicit fixed height for the tooltip.
  final double? height;

  /// Maximum constrained height for the tooltip.
  final double? maxHeight;

  /// Optional traveling laser beam dynamic border configuration.
  final ByDynamicBorder? dynamicBorder;

  /// Whether the user can move the pointer into the tooltip and click items.
  /// Defaults to `true`.
  final bool isInteractive;

  /// Whether tapping outside the tooltip dismisses it. Defaults to `true`.
  final bool dismissOnTapOutside;

  /// Whether scrolling the ancestor scroll view dismisses the tooltip. Defaults to `true`.
  final bool dismissOnScroll;

  /// Whether pressing the Escape key dismisses the tooltip. Defaults to `true`.
  final bool dismissOnEsc;

  /// Whether tapping or pressing the trigger on mobile/touch toggles the tooltip. Defaults to `true`.
  final bool enableOnTouch;

  /// Touch activation mode on mobile and touch devices.
  /// Defaults to [ByMobileTrigger.tap].
  final ByMobileTrigger mobileTrigger;

  /// Master switch to enable or disable the tooltip. Defaults to `true`.
  final bool enabled;

  /// Optional callback invoked when the tooltip opens.
  final VoidCallback? onOpen;

  /// Optional callback invoked when the tooltip closes.
  final VoidCallback? onClose;

  const ByTooltip({
    super.key,
    required this.child,
    this.builder,
    this.cardBuilder,
    this.anchor = ByTooltipAnchor.cursor,
    this.offset = const Offset(12, 12),
    this.openDelay = const Duration(milliseconds: 150),
    this.closeDelay = const Duration(milliseconds: 220),
    this.animationDuration = const Duration(milliseconds: 240),
    this.animationType = ByTooltipAnimation.fadeAndScale,
    this.curve = Curves.easeOutCubic,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.border,
    this.shadows,
    this.padding = const EdgeInsets.all(12),
    this.width,
    this.maxWidth,
    this.minWidth,
    this.height,
    this.maxHeight,
    this.dynamicBorder,
    this.isInteractive = true,
    this.dismissOnTapOutside = true,
    this.dismissOnScroll = true,
    this.dismissOnEsc = true,
    this.enableOnTouch = true,
    this.mobileTrigger = ByMobileTrigger.tap,
    this.enabled = true,
    this.onOpen,
    this.onClose,
  }) : assert(
          builder != null || cardBuilder != null,
          'Either builder or cardBuilder must be provided to ByTooltip.',
        );

  /// Resolves the active widget builder callback.
  WidgetBuilder get effectiveBuilder => (builder ?? cardBuilder)!;

  @override
  State<ByTooltip> createState() => ByTooltipState();
}

/// State for [ByTooltip] providing programmatic show/hide controls.
class ByTooltipState extends State<ByTooltip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<Offset> _slideAnim;

  OverlayEntry? _overlayEntry;
  Timer? _openTimer;
  Timer? _closeTimer;

  Offset? _cursorPosition;
  Offset? _frozenAnchorPosition;
  Rect? _targetRect;
  Size? _overlaySize;

  bool _isHoveringTrigger = false;
  bool _isHoveringCard = false;
  bool _isOpen = false;
  bool _isTouchTrigger = false;

  /// Whether the tooltip overlay is currently visible.
  bool get isOpen => _isOpen;

  /// Programmatically opens the tooltip or popover.
  void show() {
    _isTouchTrigger = true;
    _show();
  }

  /// Programmatically closes the tooltip or popover.
  void hide() {
    _hide();
  }

  /// Programmatically toggles the tooltip visibility.
  void toggle() {
    if (_isOpen) {
      hide();
    } else {
      show();
    }
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: widget.curve,
    );

    _scaleAnim = Tween<double>(
      begin: widget.animationType == ByTooltipAnimation.bounce ? 0.85 : 0.94,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: widget.animationType == ByTooltipAnimation.bounce
            ? Curves.easeOutBack
            : widget.curve,
      ),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: widget.curve,
      ),
    );
  }

  @override
  void didUpdateWidget(ByTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpen && _overlayEntry != null && _overlayEntry!.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isOpen && _overlayEntry != null && _overlayEntry!.mounted) {
          _overlayEntry!.markNeedsBuild();
        }
      });
    }
  }

  @override
  void dispose() {
    _isOpen = false;
    _openTimer?.cancel();
    _closeTimer?.cancel();
    _removeOverlayImmediate();
    _animController.dispose();
    super.dispose();
  }

  void _onPointerEnter(PointerEnterEvent event) {
    if (!widget.enabled) return;
    _isTouchTrigger = false;
    _isHoveringTrigger = true;
    _cursorPosition = event.position;
    _closeTimer?.cancel();

    _openTimer?.cancel();
    _openTimer = Timer(widget.openDelay, () {
      if (_isHoveringTrigger && !_isOpen && mounted) {
        _show();
      }
    });
  }

  void _onPointerHover(PointerHoverEvent event) {
    if (!_isOpen) {
      _cursorPosition = event.position;
    }
  }

  void _onPointerExit(PointerExitEvent event) {
    _isHoveringTrigger = false;
    _openTimer?.cancel();

    if (_isOpen) {
      _scheduleClose();
    }
  }

  void _onTapTrigger() {
    if (!widget.enabled ||
        !widget.enableOnTouch ||
        widget.mobileTrigger == ByMobileTrigger.none) {
      return;
    }
    _isTouchTrigger = true;
    if (_isOpen) {
      _hide();
    } else {
      HapticFeedback.lightImpact();
      _show();
    }
  }

  void _onCardEnter() {
    if (!widget.isInteractive) return;
    _isHoveringCard = true;
    _closeTimer?.cancel();
  }

  void _onCardExit() {
    _isHoveringCard = false;
    _scheduleClose();
  }

  void _scheduleClose() {
    _closeTimer?.cancel();
    _closeTimer = Timer(widget.closeDelay, () {
      if (!_isHoveringTrigger && !_isHoveringCard && _isOpen && mounted) {
        _hide();
      }
    });
  }

  void _show() {
    if (_isOpen || !mounted) return;
    _isOpen = true;

    final overlay =
        Overlay.maybeOf(context, rootOverlay: true) ?? Overlay.maybeOf(context);
    if (overlay == null) return;

    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    final overlayOrigin = (overlayBox != null && overlayBox.hasSize)
        ? overlayBox.localToGlobal(Offset.zero)
        : Offset.zero;
    final overlaySize = (overlayBox != null && overlayBox.hasSize)
        ? overlayBox.size
        : (MediaQuery.maybeOf(context)?.size ?? Size.zero);

    _overlaySize = overlaySize;

    final renderBox = context.findRenderObject() as RenderBox?;
    final Rect localTargetRect;
    if (renderBox != null && renderBox.hasSize) {
      final targetGlobalOrigin = renderBox.localToGlobal(Offset.zero);
      localTargetRect = (targetGlobalOrigin - overlayOrigin) & renderBox.size;
    } else {
      final fallbackCenter =
          Offset(overlaySize.width / 2, overlaySize.height / 2);
      localTargetRect =
          Rect.fromCenter(center: fallbackCenter, width: 40, height: 40);
    }
    _targetRect = localTargetRect;

    // Freeze anchor point at emergence coordinate in overlay-local space
    if (widget.anchor == ByTooltipAnchor.cursor && !_isTouchTrigger) {
      if (_cursorPosition != null) {
        _frozenAnchorPosition = _cursorPosition! - overlayOrigin;
      } else {
        _frozenAnchorPosition = localTargetRect.center;
      }
    } else {
      _frozenAnchorPosition = _targetRect!.topLeft;
    }

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => _buildOverlayContent(overlayContext),
    );

    overlay.insert(_overlayEntry!);
    _animController.forward(from: 0.0);
    widget.onOpen?.call();
  }

  Future<void> _hide() async {
    if (!_isOpen) return;
    _isOpen = false;
    _openTimer?.cancel();
    _closeTimer?.cancel();

    if (mounted) {
      await _animController.reverse();
    }
    _removeOverlayImmediate();
    if (mounted) {
      widget.onClose?.call();
    }
  }

  void _removeOverlayImmediate() {
    if (_overlayEntry != null) {
      if (_overlayEntry!.mounted) {
        _overlayEntry!.remove();
      }
      _overlayEntry = null;
    }
    _frozenAnchorPosition = null;
    _targetRect = null;
    _overlaySize = null;
  }

  Widget _buildOverlayContent(BuildContext overlayContext) {
    if (!mounted) {
      return const SizedBox.shrink();
    }

    final overlayBox = overlayContext.findRenderObject() as RenderBox?;
    final overlaySize = (overlayBox != null && overlayBox.hasSize)
        ? overlayBox.size
        : (_overlaySize ?? MediaQuery.of(overlayContext).size);

    final viewPadding = MediaQuery.of(overlayContext).padding;
    const double screenMargin = 12.0;

    final double maxAllowedWidth =
        (overlaySize.width - screenMargin * 2).clamp(140.0, double.infinity);
    final double requestedWidth =
        widget.width ?? (widget.maxWidth ?? 280.0).clamp(160.0, 480.0);
    final double effectiveWidth = requestedWidth.clamp(140.0, maxAllowedWidth);
    final double estimatedHeight = widget.height ?? 220.0;

    double left;
    double top;

    final anchorPoint = _frozenAnchorPosition ??
        Offset(overlaySize.width / 2, overlaySize.height / 2);

    final bool useTargetAnchor =
        _isTouchTrigger || widget.anchor == ByTooltipAnchor.target;

    if (!useTargetAnchor) {
      // 1. Horizontal positioning with auto-flip on right viewport edge
      if (anchorPoint.dx + widget.offset.dx + effectiveWidth >
          overlaySize.width - screenMargin) {
        left = anchorPoint.dx - effectiveWidth - widget.offset.dx;
      } else {
        left = anchorPoint.dx + widget.offset.dx;
      }

      // 2. Vertical positioning with auto-flip on bottom viewport edge
      if (anchorPoint.dy + widget.offset.dy + estimatedHeight >
          overlaySize.height - screenMargin - viewPadding.bottom) {
        top = anchorPoint.dy - estimatedHeight - widget.offset.dy;
      } else {
        top = anchorPoint.dy + widget.offset.dy;
      }
    } else {
      // Target anchor mode (ideal for mobile popovers and dropdown-like attachments)
      if (_targetRect != null) {
        final targetOrigin = _targetRect!.topLeft;
        final targetSize = _targetRect!.size;

        left = targetOrigin.dx +
            (targetSize.width - effectiveWidth) / 2 +
            widget.offset.dx;
        top = targetOrigin.dy + targetSize.height + widget.offset.dy;

        // Auto flip above target if overflowing bottom
        if (top + estimatedHeight >
            overlaySize.height - screenMargin - viewPadding.bottom) {
          top = targetOrigin.dy - estimatedHeight - widget.offset.dy;
        }
      } else {
        left = anchorPoint.dx + widget.offset.dx;
        top = anchorPoint.dy + widget.offset.dy;
      }
    }

    // Viewport clamping guarantee
    final double maxLeft = (overlaySize.width - effectiveWidth - screenMargin)
        .clamp(screenMargin, double.infinity);
    left = left.clamp(screenMargin, maxLeft);

    final double minTop = screenMargin + viewPadding.top;
    final double maxTop = (overlaySize.height -
            estimatedHeight -
            screenMargin -
            viewPadding.bottom)
        .clamp(minTop, double.infinity);
    top = top.clamp(minTop, maxTop);

    final bool isDark = Theme.of(overlayContext).brightness == Brightness.dark;
    final Color effectiveBg = widget.backgroundColor ??
        (isDark ? const Color(0xFF0F172A) : Colors.white);
    final Border effectiveBorder = widget.border ??
        Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : const Color(0xFFE2E8F0),
          width: 1.0,
        );
    final List<BoxShadow> effectiveShadows = widget.shadows ??
        (isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]);

    Widget cardBody = Container(
      width: effectiveWidth,
      height: widget.height,
      constraints: BoxConstraints(
        minWidth: (widget.minWidth ?? 0.0).clamp(0.0, effectiveWidth),
        maxWidth: effectiveWidth,
        minHeight: 0.0,
        maxHeight: (overlaySize.height -
                viewPadding.top -
                viewPadding.bottom -
                screenMargin * 2)
            .clamp(80.0, double.infinity),
      ),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: widget.borderRadius,
        border: effectiveBorder,
        boxShadow: effectiveShadows,
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: ByTooltipScope(
          onClose: _hide,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Builder(builder: widget.effectiveBuilder),
          ),
        ),
      ),
    );

    // Apply ByDynamicBorder layer if configured
    if (widget.dynamicBorder != null && widget.dynamicBorder!.enabled) {
      cardBody = ByDynamicBorderLayer(
        config: widget.dynamicBorder!,
        borderRadius: widget.borderRadius,
        child: cardBody,
      );
    }

    // Apply animation transitions
    switch (widget.animationType) {
      case ByTooltipAnimation.fadeOnly:
        cardBody = FadeTransition(opacity: _fadeAnim, child: cardBody);
        break;
      case ByTooltipAnimation.slideAndFade:
        cardBody = FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(position: _slideAnim, child: cardBody),
        );
        break;
      case ByTooltipAnimation.fadeAndScale:
      case ByTooltipAnimation.bounce:
        cardBody = FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(scale: _scaleAnim, child: cardBody),
        );
        break;
    }

    return Stack(
      children: [
        // Transparent dismiss backdrop (closes on tap outside)
        if (widget.dismissOnTapOutside)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hide,
            ),
          ),

        // Floating Positioned Card
        Positioned(
          left: left,
          top: top,
          child: Material(
            color: Colors.transparent,
            child: Focus(
              autofocus: widget.dismissOnEsc,
              onKeyEvent: (node, event) {
                if (widget.dismissOnEsc &&
                    event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.escape) {
                  _hide();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: MouseRegion(
                onEnter: (_) => _onCardEnter(),
                onExit: (_) => _onCardExit(),
                child: cardBody,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canTap = widget.enabled &&
        widget.enableOnTouch &&
        widget.mobileTrigger == ByMobileTrigger.tap;
    final bool canLongPress = widget.enabled &&
        widget.enableOnTouch &&
        widget.mobileTrigger == ByMobileTrigger.longPress;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (widget.dismissOnScroll && _isOpen) {
          _hide();
        }
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: canTap
            ? (details) => _cursorPosition = details.globalPosition
            : null,
        onTap: canTap ? _onTapTrigger : null,
        onLongPressStart: canLongPress
            ? (details) => _cursorPosition = details.globalPosition
            : null,
        onLongPress: canLongPress ? _onTapTrigger : null,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: _onPointerEnter,
          onHover: _onPointerHover,
          onExit: _onPointerExit,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Backward compatibility alias for [ByTooltip].
typedef ByHoverCard = ByTooltip;

/// Backward compatibility alias for [ByTooltipState].
typedef ByHoverCardState = ByTooltipState;

/// Backward compatibility alias for [ByTooltipScope].
typedef ByHoverCardScope = ByTooltipScope;

/// Universal alias for contextual popovers.
typedef ByPopover = ByTooltip;

/// Universal alias for contextual popover state.
typedef ByPopoverState = ByTooltipState;
