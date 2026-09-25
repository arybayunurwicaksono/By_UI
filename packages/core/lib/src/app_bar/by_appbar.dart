import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../card/by_card_controller.dart';
import 'by_scroll_scope.dart';

/// Reusable top navigation AppBar component for the ByUI library.
///
/// Features dynamic floating transitions, frosted glass blur, full customization
/// for static and floating states, and optional dynamic motion sensor tilt tracking.
///
/// By default, the content inside the app bar is completely open to modification
/// via [child] (defaults to an empty widget).
///
/// **Important Usage Note**:
/// To allow the [Scaffold.body] content to remain visible behind the floating app bar
/// (through the transparent/frosted-glass surface and around floating margins) without
/// getting clipped by the Scaffold layout, always configure your [Scaffold]:
/// ```dart
/// Scaffold(
///   extendBodyBehindAppBar: true,
///   appBar: ByAppBar(
///     child: MyCustomHeader(),
///   ),
///   body: ListView(
///     padding: EdgeInsets.fromLTRB(
///       12,
///       ByAppBar.getContentTopPadding(context),
///       12,
///       20,
///     ),
///     children: [...],
///   ),
/// )
/// ```
class ByAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Default blue & cyan gradient for dynamic sensor and gradient borders.
  static const Gradient defaultSensorGradient = LinearGradient(
    colors: [
      Color(0xFF2563EB), // Royal Blue
      Color(0xFF06B6D4), // Cyan
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// The primary custom content widget nested inside the app bar toolbar area.
  /// Defaults to null (empty widget [SizedBox.shrink]).
  final Widget? child;

  /// Optional widget displayed at the bottom of the toolbar (such as a TabBar).
  final PreferredSizeWidget? bottom;

  /// Height of the toolbar content area (defaults to [kToolbarHeight] = 56.0).
  final double toolbarHeight;

  /// Controls whether the dynamic floating transition is enabled upon scrolling.
  final bool isFloatingEnabled;

  /// Scroll distance (in px) required to trigger the floating transition.
  final double scrollThreshold;

  /// Optional explicit [ScrollController]. If omitted, [ByAppBar] automatically
  /// detects scroll events via ancestor [ByScrollScope].
  final ScrollController? scrollController;

  /// Duration of the transition animation between static and floating states.
  final Duration animationDuration;

  /// Curve of the transition animation.
  final Curve animationCurve;

  /// Margins applied when in static state (defaults to [EdgeInsets.zero]).
  final EdgeInsets? margin;

  /// Margins applied when in floating state (defaults to `EdgeInsets.fromLTRB(14, 8, 14, 0)`).
  final EdgeInsets? floatingMargin;

  /// Corner radius when at the top of the viewport (defaults to [BorderRadius.zero]).
  final BorderRadius? borderRadius;

  /// Corner radius when in floating state (defaults to `BorderRadius.circular(16)`).
  final BorderRadius? floatingBorderRadius;

  /// Frosted glass Gaussian blur strength applied when floating.
  final double floatingBlurSigma;

  /// Custom opacity applied to the floating background (defaults to 0.82 in dark mode, 0.88 in light mode).
  /// If [floatingBackgroundColor] is omitted, this opacity is automatically applied to [backgroundColor].
  final double? floatingOpacity;

  /// Custom background color when at the top of the viewport.
  final Color? backgroundColor;

  /// Custom background color when floating (e.g. semi-transparent fill).
  final Color? floatingBackgroundColor;

  /// Optional gradient background applied when at the top of the viewport.
  final Gradient? backgroundGradient;

  /// Optional gradient background applied when floating.
  final Gradient? floatingBackgroundGradient;

  /// Optional complete border applied when at the top of the viewport.
  final BoxBorder? border;

  /// Optional complete border applied when in floating state.
  final BoxBorder? floatingBorder;

  /// Custom border outline color when at the top of the viewport.
  final Color? borderColor;

  /// Custom border outline color when in floating state.
  final Color? floatingBorderColor;

  /// Stroke width for the border when at the top of the viewport.
  final double borderWidth;

  /// Stroke width for the border when in floating state.
  final double floatingBorderWidth;

  /// Optional gradient for border stroke (defaults to [defaultSensorGradient] when sensors active).
  final Gradient? borderGradient;

  /// Elevation shadow depth when at the top of the viewport.
  final double elevation;

  /// Elevation shadow depth when in floating state.
  final double floatingElevation;

  /// Custom box shadows applied when at the top of the viewport.
  final List<BoxShadow>? shadows;

  /// Custom box shadows applied when in floating state.
  final List<BoxShadow>? floatingShadows;

  /// Directional gradient specification for ambient glow / shadow in sensor modes.
  final Gradient? shadowGradient;

  /// Blur radius for the directional gradient shadow.
  final double shadowBlur;

  /// Maximum directional shadow translation distance when tilted.
  final double maxShadowOffset;

  /// Whether to render the dynamic directional spatial glow / inner shadow.
  /// Defaults to `false`.
  final bool enableInnerShadow;

  /// Synonym for [enableInnerShadow] providing API symmetry with [ByCard.enableInnerGlow].
  bool get enableInnerGlow => enableInnerShadow;

  /// Custom opacity multiplier for the inner shadow / spatial glow (0.0 to 1.0).
  /// Defaults to `null` (uses standard dynamic physics opacity).
  final double? innerShadowOpacity;

  /// Synonym for [innerShadowOpacity] providing API symmetry with [ByCard.innerGlowOpacity].
  double? get innerGlowOpacity => innerShadowOpacity;

  /// Enables physical accelerometer/gyroscope hardware tilt tracking on mobile devices.
  /// Defaults to `false`.
  final bool enableSensor;

  /// Enables mouse pointer hover parallax tilt on Desktop and Web platforms.
  /// Defaults to `true`.
  final bool enableHoverTilt;

  /// Optional manual tilt coordinate (-1.0 to 1.0) overriding sensor tracking.
  final Offset? manualTilt;

  /// Optional callback invoked when the spatial tilt coordinate updates.
  final ValueChanged<Offset>? onTiltChanged;

  /// Clipping behavior for child content.
  final Clip clipBehavior;

  const ByAppBar({
    super.key,
    this.child,
    this.bottom,
    this.toolbarHeight = kToolbarHeight,
    this.isFloatingEnabled = true,
    this.scrollThreshold = 12.0,
    this.scrollController,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeOutCubic,
    this.margin,
    this.floatingMargin = const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 0.0),
    this.borderRadius,
    this.floatingBorderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.floatingBlurSigma = 16.0,
    this.floatingOpacity,
    this.backgroundColor,
    this.floatingBackgroundColor,
    this.backgroundGradient,
    this.floatingBackgroundGradient,
    this.border,
    this.floatingBorder,
    this.borderColor,
    this.floatingBorderColor,
    this.borderWidth = 0.0,
    this.floatingBorderWidth = 0.0,
    this.borderGradient,
    this.elevation = 0.0,
    this.floatingElevation = 4.0,
    this.shadows,
    this.floatingShadows,
    this.shadowGradient,
    this.shadowBlur = 16.0,
    this.maxShadowOffset = 8.0,
    this.enableInnerShadow = false,
    this.innerShadowOpacity,
    this.enableSensor = false,
    this.enableHoverTilt = true,
    this.manualTilt,
    this.onTiltChanged,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Helper providing the recommended top content padding for scrollables
  /// when [extendBodyBehindAppBar] is active on [Scaffold].
  static double getContentTopPadding(
    BuildContext context, {
    double toolbarHeight = kToolbarHeight,
    double extra = 14.0,
  }) {
    final topSafeArea = MediaQuery.of(context).padding.top;
    return topSafeArea + toolbarHeight + extra;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  State<ByAppBar> createState() => _ByAppBarState();
}

class _ByAppBarState extends State<ByAppBar> {
  bool _isScrolledLocal = false;
  ValueNotifier<bool>? _scopeNotifier;
  late ByTiltController _tiltController;

  bool get _isMobilePlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onControllerScroll);
    _initTiltController();
  }

  void _initTiltController() {
    final bool isMobile = _isMobilePlatform;
    final bool canEnableSensor = isMobile && widget.enableSensor;
    final Offset defaultRestingTilt =
        isMobile ? const Offset(0.0, 1.0) : Offset.zero;

    _tiltController = ByTiltController(
      enableSensor: canEnableSensor,
      initialTilt: widget.manualTilt ?? defaultRestingTilt,
      onTiltChanged: widget.onTiltChanged,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newScopeNotifier = ByScrollScope.maybeOf(context);
    if (_scopeNotifier != newScopeNotifier) {
      _scopeNotifier?.removeListener(_onScopeScroll);
      _scopeNotifier = newScopeNotifier;
      _scopeNotifier?.addListener(_onScopeScroll);
      if (_scopeNotifier != null) {
        _isScrolledLocal = _scopeNotifier!.value;
      }
    }
  }

  @override
  void didUpdateWidget(covariant ByAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_onControllerScroll);
      widget.scrollController?.addListener(_onControllerScroll);
    }

    if (widget.onTiltChanged != oldWidget.onTiltChanged) {
      _tiltController.onTiltChanged = widget.onTiltChanged;
    }

    if (widget.manualTilt != null &&
        widget.manualTilt != oldWidget.manualTilt) {
      _tiltController.setManualTilt(widget.manualTilt!);
    }

    final bool sensorChanged = widget.enableSensor != oldWidget.enableSensor;
    final bool manualTiltCleared =
        oldWidget.manualTilt != null && widget.manualTilt == null;

    if (sensorChanged || manualTiltCleared) {
      _tiltController.dispose();
      _initTiltController();
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onControllerScroll);
    _scopeNotifier?.removeListener(_onScopeScroll);
    _tiltController.dispose();
    super.dispose();
  }

  void _onControllerScroll() {
    final isScrolled =
        (widget.scrollController?.offset ?? 0.0) > widget.scrollThreshold;
    if (_isScrolledLocal != isScrolled) {
      setState(() {
        _isScrolledLocal = isScrolled;
      });
    }
  }

  void _onScopeScroll() {
    if (_scopeNotifier != null && _isScrolledLocal != _scopeNotifier!.value) {
      setState(() {
        _isScrolledLocal = _scopeNotifier!.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      final scaffold = context.findAncestorWidgetOfExactType<Scaffold>();
      if (scaffold != null && !scaffold.extendBodyBehindAppBar) {
        debugPrint(
          'ByAppBar Note: To allow scaffold.body content to remain visible through '
          'transparent floating surfaces and around margins without being clipped, '
          'set extendBodyBehindAppBar: true on Scaffold and apply ByAppBar.getContentTopPadding(context) '
          'to your scrollable body.',
        );
      }
      return true;
    }());

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isFloating = widget.isFloatingEnabled && _isScrolledLocal;

    // Margin resolution
    final EdgeInsets effectiveMargin = isFloating
        ? (widget.floatingMargin ??
            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 0.0))
        : (widget.margin ?? EdgeInsets.zero);

    // Corner radius resolution
    final BorderRadius effectiveBorderRadius = isFloating
        ? (widget.floatingBorderRadius ?? BorderRadius.circular(16.0))
        : (widget.borderRadius ?? BorderRadius.zero);

    // Blur resolution
    final double blurVal = isFloating ? widget.floatingBlurSigma : 0.0;

    // Color & Background resolution
    final Color defaultCardBg = theme.cardColor;
    final Color topBgColor = widget.backgroundColor ?? defaultCardBg;
    final double defaultOpacity = isDark ? 0.82 : 0.88;
    final double effectiveOpacity = widget.floatingOpacity ?? defaultOpacity;
    final Color defaultFloatBg =
        defaultCardBg.withValues(alpha: effectiveOpacity);
    final Color floatingBgColor = widget.floatingBackgroundColor ??
        (widget.backgroundColor != null
            ? widget.backgroundColor!.withValues(alpha: effectiveOpacity)
            : defaultFloatBg);
    final Color effectiveBgColor = isFloating ? floatingBgColor : topBgColor;

    final Gradient? effectiveGradient = isFloating
        ? (widget.floatingBackgroundGradient ?? widget.backgroundGradient)
        : widget.backgroundGradient;

    // Elevation & Shadows resolution
    final double effectiveElevation =
        isFloating ? widget.floatingElevation : widget.elevation;

    final List<BoxShadow>? explicitShadows =
        isFloating ? widget.floatingShadows : widget.shadows;

    final List<BoxShadow>? effectiveShadows = explicitShadows ??
        (isFloating && effectiveElevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.38 : 0.08,
                  ),
                  blurRadius: effectiveElevation * 3,
                  offset: Offset(0, effectiveElevation * 0.7),
                ),
              ]
            : null);

    // Border resolution
    final Color normalBorderColor = widget.borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06));
    final Color floatBorderColor = widget.floatingBorderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.16)
            : Colors.black.withValues(alpha: 0.12));
    final double effectiveBorderWidth = isFloating
        ? (widget.floatingBorderWidth > 0
            ? widget.floatingBorderWidth
            : (widget.floatingBorderColor != null ||
                    widget.borderGradient != null ||
                    widget.enableSensor
                ? 1.0
                : 0.0))
        : (widget.borderWidth > 0
            ? widget.borderWidth
            : (widget.borderColor != null ||
                    widget.borderGradient != null ||
                    widget.enableSensor
                ? 1.0
                : 0.0));

    final BoxBorder? effectiveBorder = isFloating
        ? (widget.floatingBorder ??
            (widget.borderGradient != null ||
                    widget.enableSensor ||
                    effectiveBorderWidth <= 0
                ? null
                : Border.all(
                    color: floatBorderColor,
                    width: effectiveBorderWidth,
                  )))
        : (widget.border ??
            (widget.borderGradient != null ||
                    widget.enableSensor ||
                    effectiveBorderWidth <= 0
                ? null
                : Border.all(
                    color: normalBorderColor,
                    width: effectiveBorderWidth,
                  )));

    final bool hasSensorOrGradientBorder = widget.enableSensor ||
        widget.borderGradient != null ||
        (widget.enableInnerShadow && isFloating);

    // Inner Toolbar Content (Widget kosong jika null, user memiliki kontrol penuh)
    final Widget toolbarContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: widget.child ?? const SizedBox.shrink()),
        if (widget.bottom != null) widget.bottom!,
      ],
    );

    Widget innerBar = toolbarContent;

    // Dynamic Sensor Border & Directional Glow Painting
    if (hasSensorOrGradientBorder) {
      innerBar = ListenableBuilder(
        listenable: _tiltController.tiltNotifier,
        child: toolbarContent,
        builder: (context, child) {
          return CustomPaint(
            painter: _ByAppBarSensorPainter(
              tilt: _tiltController.tiltNotifier.value,
              borderRadius: effectiveBorderRadius,
              borderWidth: effectiveBorderWidth,
              borderGradient: widget.borderGradient ?? ByAppBar.defaultSensorGradient,
              shadowGradient: widget.shadowGradient,
              shadowBlur: widget.shadowBlur,
              maxShadowOffset: widget.maxShadowOffset,
              isFloating: isFloating,
              enableSensor: widget.enableSensor,
              enableInnerShadow: widget.enableInnerShadow,
              innerShadowOpacity: widget.innerShadowOpacity,
            ),
            child: child,
          );
        },
      );

      if (widget.enableHoverTilt) {
        final contentToWrap = innerBar;
        innerBar = Builder(
          builder: (barCtx) {
            return MouseRegion(
              onEnter: (event) {
                final RenderBox? renderBox =
                    barCtx.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  _tiltController.updateHoverPosition(
                    event.localPosition,
                    renderBox.size,
                  );
                }
              },
              onHover: (event) {
                final RenderBox? renderBox =
                    barCtx.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  _tiltController.updateHoverPosition(
                    event.localPosition,
                    renderBox.size,
                  );
                }
              },
              onExit: (_) => _tiltController.smoothResetToNeutral(),
              child: contentToWrap,
            );
          },
        );
      }
    }

    final double topSafeArea = MediaQuery.paddingOf(context).top;

    final Widget barContent = AnimatedContainer(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      margin: effectiveMargin,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveShadows,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        clipBehavior: widget.clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurVal, sigmaY: blurVal),
          child: AnimatedContainer(
            duration: widget.animationDuration,
            curve: widget.animationCurve,
            decoration: BoxDecoration(
              color: effectiveGradient == null ? effectiveBgColor : null,
              gradient: effectiveGradient,
              borderRadius: effectiveBorderRadius,
              border: effectiveBorder,
            ),
            child: innerBar,
          ),
        ),
      ),
    );

    final Widget safeAreaContent = SafeArea(
      bottom: false,
      child: barContent,
    );

    if (topSafeArea <= 0) {
      return safeAreaContent;
    }

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: topSafeArea,
          child: AnimatedOpacity(
            duration: widget.animationDuration,
            curve: widget.animationCurve,
            opacity: isFloating ? 0.0 : 1.0,
            child: DecoratedBox(
              decoration: effectiveGradient != null
                  ? BoxDecoration(gradient: effectiveGradient)
                  : BoxDecoration(color: topBgColor),
            ),
          ),
        ),
        safeAreaContent,
      ],
    );
  }
}

/// Custom painter rendering dynamic directional gradient borders and spatial glow
/// for [ByAppBar] based on physical sensor tilt or cursor hover.
class _ByAppBarSensorPainter extends CustomPainter {
  final Offset tilt;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Gradient borderGradient;
  final Gradient? shadowGradient;
  final double shadowBlur;
  final double maxShadowOffset;
  final bool isFloating;
  final bool enableSensor;
  final bool enableInnerShadow;
  final double? innerShadowOpacity;

  _ByAppBarSensorPainter({
    required this.tilt,
    required this.borderRadius,
    required this.borderWidth,
    required this.borderGradient,
    this.shadowGradient,
    required this.shadowBlur,
    required this.maxShadowOffset,
    required this.isFloating,
    required this.enableSensor,
    this.enableInnerShadow = false,
    this.innerShadowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    // 1. Resolve colors from borderGradient or fall back to defaults
    List<Color> resolvedColors = const [
      Color(0xFF2563EB), // Royal Blue
      Color(0xFF06B6D4), // Cyan
    ];

    final List<Color> nonTransparent =
        borderGradient.colors.where((c) => c.a > 0.05).toList();
    if (nonTransparent.isNotEmpty) {
      resolvedColors = nonTransparent;
    } else {
      resolvedColors = borderGradient.colors;
    }

    final Color colorA = resolvedColors.first;
    final Color colorB =
        resolvedColors.length > 1 ? resolvedColors.last : colorA;

    final double magnitude = tilt.distance.clamp(0.0, 1.0);

    // 2. Paint Directional Spatial Glow when floating with tilt
    if (enableInnerShadow && isFloating && shadowBlur > 0) {
      final double opacity = (innerShadowOpacity ?? 1.0).clamp(0.0, 1.0);
      if (opacity > 0) {
        final Offset shadowOffset = magnitude < 0.08
            ? Offset.zero
            : Offset(tilt.dx * maxShadowOffset, tilt.dy * maxShadowOffset);
        final RRect shadowRRect = rrect.shift(shadowOffset);
        final Paint glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

        List<Color> shadowColors = resolvedColors;
        if (shadowGradient != null) {
          final List<Color> nonTransShadow =
              shadowGradient!.colors.where((c) => c.a > 0.05).toList();
          if (nonTransShadow.isNotEmpty) {
            shadowColors = nonTransShadow;
          } else {
            shadowColors = shadowGradient!.colors;
          }
        }
        final Color sColorA = shadowColors.first;
        final Color sColorB =
            shadowColors.length > 1 ? shadowColors.last : sColorA;

        if (magnitude < 0.08) {
          // Balanced even ambient glow across the entire bar when neutral
          final Alignment begin;
          final Alignment end;
          if (shadowGradient is LinearGradient) {
            begin = (shadowGradient as LinearGradient)
                .begin
                .resolve(TextDirection.ltr);
            end = (shadowGradient as LinearGradient)
                .end
                .resolve(TextDirection.ltr);
          } else if (borderGradient is LinearGradient) {
            begin = (borderGradient as LinearGradient)
                .begin
                .resolve(TextDirection.ltr);
            end = (borderGradient as LinearGradient)
                .end
                .resolve(TextDirection.ltr);
          } else {
            begin = Alignment.centerLeft;
            end = Alignment.centerRight;
          }

          final Gradient fallbackGlow = LinearGradient(
            begin: begin,
            end: end,
            colors: [
              sColorA.withValues(alpha: 0.25 * opacity),
              sColorB.withValues(alpha: 0.25 * opacity),
            ],
          );
          glowPaint.shader = fallbackGlow.createShader(shadowRRect.outerRect);
        } else {
          final double dirX = tilt.dx / magnitude;
          final double dirY = tilt.dy / magnitude;

          glowPaint.shader = LinearGradient(
            begin: Alignment(-dirX, -dirY),
            end: Alignment(dirX, dirY),
            colors: [
              Colors.transparent,
              sColorA.withValues(alpha: 0.25 * magnitude * opacity),
              sColorB.withValues(alpha: 0.40 * magnitude * opacity),
            ],
            stops: const [0.0, 0.50, 1.0],
          ).createShader(shadowRRect.outerRect);
        }

        canvas.drawRRect(shadowRRect, glowPaint);
      }
    }

    // 3. Paint Dynamic Gradient Border Stroke
    if (borderWidth > 0) {
      final RRect borderRRect = rrect.deflate(borderWidth / 2);
      final Paint borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

      // Determine baseline resting gradient alignment
      final AlignmentGeometry staticBegin = borderGradient is LinearGradient
          ? (borderGradient as LinearGradient).begin
          : Alignment.topLeft;
      final AlignmentGeometry staticEnd = borderGradient is LinearGradient
          ? (borderGradient as LinearGradient).end
          : Alignment.bottomRight;

      final Alignment resolvedStaticBegin =
          staticBegin.resolve(TextDirection.ltr);
      final Alignment resolvedStaticEnd =
          staticEnd.resolve(TextDirection.ltr);

      // Smoothly blend between static resting alignment and directional lighting vector
      final double dirX = magnitude > 0.001 ? tilt.dx / magnitude : 0.0;
      final double dirY = magnitude > 0.001 ? tilt.dy / magnitude : 0.0;

      final double blend = ((magnitude - 0.03) / 0.12).clamp(0.0, 1.0);
      final double s = blend * blend * (3.0 - 2.0 * blend);

      final Alignment effectiveBegin = Alignment.lerp(
            resolvedStaticBegin,
            Alignment(-dirX, -dirY),
            s,
          ) ??
          Alignment(-dirX, -dirY);
      final Alignment effectiveEnd = Alignment.lerp(
            resolvedStaticEnd,
            Alignment(dirX, dirY),
            s,
          ) ??
          Alignment(dirX, dirY);

      final double oppositeAlpha =
          (1.0 - ((magnitude - 0.03) / 0.35) * s).clamp(0.08, 1.0);
      final double midStop = (0.50 - 0.15 * magnitude * s).clamp(0.25, 0.50);
      final double highlightStop =
          (0.75 - 0.10 * magnitude * s).clamp(0.60, 0.85);

      final Color blendColorOpposite =
          Color.lerp(colorA, colorA.withValues(alpha: oppositeAlpha), s) ??
              colorA;
      final Color blendColorMid = Color.lerp(
            colorA,
            colorA.withValues(
                alpha: oppositeAlpha > 0.15 ? oppositeAlpha : 0.15),
            s,
          ) ??
          colorA;

      borderPaint.shader = LinearGradient(
        begin: effectiveBegin,
        end: effectiveEnd,
        colors: [
          blendColorOpposite,
          blendColorMid,
          colorA,
          colorB,
        ],
        stops: [
          0.0,
          0.33 * (1.0 - s) + midStop * s,
          0.66 * (1.0 - s) + highlightStop * s,
          1.0,
        ],
      ).createShader(borderRRect.outerRect);

      if (!isFloating && borderRadius == BorderRadius.zero) {
        // When static and flush against viewport edges, draw dynamic gradient
        // along the bottom border divider so it remains clean, elegant, and visible
        // above scrolling content rather than being clipped on 3 outer screen edges.
        final Path bottomLine = Path()
          ..moveTo(0, size.height - borderWidth / 2)
          ..lineTo(size.width, size.height - borderWidth / 2);
        canvas.drawPath(bottomLine, borderPaint);
      } else {
        canvas.drawRRect(borderRRect, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ByAppBarSensorPainter oldDelegate) {
    return oldDelegate.tilt != tilt ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderGradient != borderGradient ||
        oldDelegate.shadowGradient != shadowGradient ||
        oldDelegate.shadowBlur != shadowBlur ||
        oldDelegate.maxShadowOffset != maxShadowOffset ||
        oldDelegate.isFloating != isFloating ||
        oldDelegate.enableSensor != enableSensor ||
        oldDelegate.enableInnerShadow != enableInnerShadow ||
        oldDelegate.innerShadowOpacity != innerShadowOpacity;
  }
}
