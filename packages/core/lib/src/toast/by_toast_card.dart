import 'dart:async';
import 'package:flutter/material.dart';
import 'by_toast_enums.dart';
import 'by_toast_model.dart';

/// Internal widget that renders an animated, interactive toast card.
class ByToastCard extends StatefulWidget {
  final ByToastModel item;
  final int index;
  final VoidCallback onDismiss;
  final ValueChanged<double>? onHeightMeasured;
  final ValueChanged<Rect>? onExpandToDialog;

  const ByToastCard({
    super.key,
    required this.item,
    required this.index,
    required this.onDismiss,
    this.onHeightMeasured,
    this.onExpandToDialog,
  });

  @override
  State<ByToastCard> createState() => _ByToastCardState();
}

class _ByToastCardState extends State<ByToastCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _dragResetController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _dragResetAnim;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  bool _hasTriggeredExpand = false;
  Timer? _autoDismissTimer;
  bool _isDismissing = false;
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.item.animationDuration,
    );

    _dragResetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addListener(() {
        if (mounted) {
          setState(() {
            _dragOffset = _dragResetAnim.value;
          });
        }
      });

    _setupAnimations();

    _controller.forward();

    // Schedule auto dismiss timer
    if (widget.item.duration > Duration.zero) {
      _autoDismissTimer = Timer(widget.item.duration, () {
        _dismissWithAnimation();
      });
    }

    // Measure height after initial render
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeight());
  }

  void _measureHeight() {
    if (!mounted) return;
    final context = _cardKey.currentContext;
    if (context != null) {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        widget.onHeightMeasured?.call(renderBox.size.height);
      }
    }
  }

  void _setupAnimations() {
    final enterCurve = widget.item.enterCurve;

    // Fade Animation
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.85, curve: enterCurve),
    );

    // Slide Offset based on slide direction
    Offset beginOffset;
    switch (widget.item.slideDirection) {
      case ByToastSlideDirection.fromTop:
        beginOffset = const Offset(0.0, -0.8);
        break;
      case ByToastSlideDirection.fromBottom:
        beginOffset = const Offset(0.0, 0.8);
        break;
      case ByToastSlideDirection.fromLeft:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case ByToastSlideDirection.fromRight:
        beginOffset = const Offset(1.0, 0.0);
        break;
    }

    final effectiveCurve =
        widget.item.animationType == ByToastAnimationType.bounce
            ? Curves.easeOutBack
            : enterCurve;

    _slideAnim = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: effectiveCurve));

    // Scale Animation
    final double beginScale =
        widget.item.animationType == ByToastAnimationType.bounce ? 0.88 : 0.95;

    _scaleAnim = Tween<double>(
      begin: beginScale,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: effectiveCurve));
  }

  Future<void> _dismissWithAnimation() async {
    if (_isDismissing) return;
    _isDismissing = true;
    _autoDismissTimer?.cancel();
    _dragResetController.stop();

    if (mounted) {
      final exitCurved = CurvedAnimation(
        parent: _controller,
        curve: widget.item.exitCurve,
      );
      _fadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(exitCurved);
      _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(exitCurved);

      await _controller.reverse();
      if (mounted) {
        widget.onDismiss();
      }
    }
  }

  void _triggerExpandToDialog() {
    if (_isDismissing || _hasTriggeredExpand) return;
    _hasTriggeredExpand = true;
    _isDismissing = true;
    _autoDismissTimer?.cancel();
    _dragResetController.stop();

    final context = _cardKey.currentContext;
    if (context != null) {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final origin = renderBox.localToGlobal(Offset.zero);
        final rect = origin & renderBox.size;
        widget.onExpandToDialog?.call(rect);
      }
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (_isDismissing || _hasTriggeredExpand) return;
    _autoDismissTimer?.cancel();
    _dragResetController.stop();
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDismissing || _hasTriggeredExpand) return;

    final isTop = widget.item.position == ByToastPosition.top;
    final canExpand = widget.item.canDragToExpand;
    final dy = details.delta.dy;
    final dx = details.delta.dx;

    // Center drag: for top toast, positive dy moves toward center.
    // For bottom toast, negative dy moves toward center.
    final bool movingTowardsCenter =
        isTop ? (_dragOffset.dy + dy > 0) : (_dragOffset.dy + dy < 0);

    double effectiveDy = dy;
    if (movingTowardsCenter && !canExpand) {
      effectiveDy *= 0.25;
    }

    setState(() {
      _dragOffset += Offset(dx, effectiveDy);
    });

    // Real-time threshold check: if dragged towards center >= 60px
    final double centerDragDistance = isTop ? _dragOffset.dy : -_dragOffset.dy;
    if (canExpand && centerDragDistance >= 60.0) {
      _triggerExpandToDialog();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDismissing || _hasTriggeredExpand) return;
    _isDragging = false;

    final isTop = widget.item.position == ByToastPosition.top;
    final canExpand = widget.item.canDragToExpand;
    final double centerDragDistance = isTop ? _dragOffset.dy : -_dragOffset.dy;
    final double velocityY = details.velocity.pixelsPerSecond.dy;
    final double centerVelocity = isTop ? velocityY : -velocityY;

    // 1. Check if released after dragging or flicking towards center
    if (canExpand && (centerDragDistance >= 30.0 || centerVelocity >= 350.0)) {
      _triggerExpandToDialog();
      return;
    }

    // 2. Check if swiped away from center to dismiss
    final double dismissDistance = isTop ? -_dragOffset.dy : _dragOffset.dy;
    final double dismissVelocity = isTop ? -velocityY : velocityY;
    if (dismissDistance >= 30.0 || dismissVelocity >= 350.0) {
      _dismissWithAnimation();
      return;
    }

    // 3. Check horizontal swipe to dismiss
    final double horizontalDistance = _dragOffset.dx.abs();
    final double horizontalVelocity = details.velocity.pixelsPerSecond.dx.abs();
    if (horizontalDistance >= 40.0 || horizontalVelocity >= 350.0) {
      _dismissWithAnimation();
      return;
    }

    // 4. Otherwise, spring back to resting position
    _springBack();
  }

  void _onPanCancel() {
    if (_isDismissing || _hasTriggeredExpand) return;
    _isDragging = false;
    _springBack();
  }

  void _springBack() {
    setState(() {
      _isDragging = false;
    });
    _dragResetAnim =
        Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _dragResetController,
        curve: Curves.easeOutBack,
      ),
    );
    _dragResetController.forward(from: 0.0);

    // Restart auto dismiss timer
    if (widget.item.duration > Duration.zero) {
      _autoDismissTimer?.cancel();
      _autoDismissTimer = Timer(widget.item.duration, () {
        _dismissWithAnimation();
      });
    }
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    _dragResetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    Widget cardContent = Container(
      key: _cardKey,
      padding: item.padding ??
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: item.gradient == null ? item.backgroundColor : null,
        gradient: item.gradient,
        borderRadius: item.borderRadius ?? BorderRadius.circular(14),
        border: item.border,
        boxShadow: item.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Prefix Widget / Leading (Left Icon)
          if (item.leading != null) ...[
            item.leading!,
            const SizedBox(width: 10),
          ] else if (item.icon != null) ...[
            if (item.onIconTap != null)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: item.onIconTap,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      item.icon,
                      color: item.iconColor ?? item.textColor,
                      size: 20,
                    ),
                  ),
                ),
              )
            else
              Icon(
                item.icon,
                color: item.iconColor ?? item.textColor,
                size: 20,
              ),
            const SizedBox(width: 10),
          ],

          // Message & Optional Title (Tap on text opens the morphing dialog!)
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap:
                    item.canTapToExpand ? _triggerExpandToDialog : item.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 4.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.title != null && item.title!.isNotEmpty) ...[
                        Text(
                          item.title!,
                          style: item.titleStyle ??
                              TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: item.textColor,
                              ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        item.message,
                        style: item.textStyle ??
                            TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: item.textColor,
                              height: 1.3,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Suffix Action / Icon
          if (item.suffix != null) ...[
            const SizedBox(width: 8),
            item.suffix!,
          ] else if (item.suffixIcon != null) ...[
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: item.onSuffixTap,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    item.suffixIcon,
                    size: 18,
                    color: item.suffixIconColor ?? item.textColor,
                  ),
                ),
              ),
            ),
          ],

          // Close Button ('X')
          if (item.showCloseButton) ...[
            const SizedBox(width: 6),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _dismissWithAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: item.closeButtonColor ??
                        item.textColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    // Interactive drag wrapper for swipe-to-dismiss & drag-to-center expand
    Widget animatedBody = Transform.translate(
      offset: _dragOffset,
      child: Transform.scale(
        scale: _isDragging ? 1.015 : 1.0,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          onPanCancel: _onPanCancel,
          child: Material(color: Colors.transparent, child: cardContent),
        ),
      ),
    );

    // Apply Animation Transitions based on AnimationType
    switch (item.animationType) {
      case ByToastAnimationType.fadeOnly:
        animatedBody = FadeTransition(opacity: _fadeAnim, child: animatedBody);
        break;
      case ByToastAnimationType.slideOnly:
        animatedBody = SlideTransition(
          position: _slideAnim,
          child: animatedBody,
        );
        break;
      case ByToastAnimationType.scaleAndFade:
        animatedBody = FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(scale: _scaleAnim, child: animatedBody),
        );
        break;
      case ByToastAnimationType.slideAndFade:
      case ByToastAnimationType.bounce:
        animatedBody = FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: ScaleTransition(scale: _scaleAnim, child: animatedBody),
          ),
        );
        break;
    }

    return animatedBody;
  }
}

// Backward compatibility alias
typedef ByNotificationCard = ByToastCard;
