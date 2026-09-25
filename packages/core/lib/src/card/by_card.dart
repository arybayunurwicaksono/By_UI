import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'by_card_controller.dart';
import 'by_card_enums.dart';
import 'by_card_painter.dart';
import 'by_card_theme.dart';

/// A modern, versatile card component supporting standard flat styling, static
/// gradients, and dynamic gyroscope-reactive spatial lighting.
///
/// [ByCard] extends [ImplicitlyAnimatedWidget] to provide seamless, fluid color
/// transitions (e.g. during theme toggles or dynamic state changes).
///
/// ### Modes:
/// - **Normal**: Operates as a standard performant card with solid background and optional border.
/// - **Gradient**: Features static gradient border and directional ambient glow.
/// - **Dynamic Sensor**: Real-time spatial lighting that rotates gradient border and shadow
///   based on physical device orientation (accelerometer) on mobile or cursor hover on Desktop/Web.
class ByCard extends ImplicitlyAnimatedWidget {
  /// The primary content widget nested inside the card.
  final Widget child;

  /// The visual mode and sensor interactivity level.
  final ByCardVariant variant;

  /// Whether to activate device motion sensors when [variant] is [ByCardVariant.dynamicSensor].
  final bool enableSensor;

  /// Optional manual tilt coordinate (-1.0 to 1.0) overriding sensor tracking.
  final Offset? manualTilt;

  /// Card surface fill color. Smoothly animates upon change.
  final Color? backgroundColor;

  /// Corner radius geometry. Smoothly animates upon change.
  final BorderRadiusGeometry borderRadius;

  /// Internal content padding.
  final EdgeInsetsGeometry padding;

  /// External margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Thickness of the card border. Smoothly animates upon change.
  final double borderWidth;

  /// Solid color for border stroke in [ByCardVariant.normal].
  final Color? borderColor;

  /// Gradient specification for the border stroke in gradient modes.
  final Gradient? borderGradient;

  /// Standard box shadows used in [ByCardVariant.normal].
  final List<BoxShadow>? shadows;

  /// Directional gradient specification for ambient glow / shadow in spatial modes.
  final Gradient? shadowGradient;

  /// Blur radius for the directional gradient shadow.
  final double shadowBlur;

  /// Maximum distance the directional shadow shifts with tilt.
  final double maxShadowOffset;

  /// Enables mouse hover parallax effect on Desktop and Web platforms.
  final bool enableHoverTilt;

  /// Enables dynamic specular inner glow / sheen inside the card layout following tilt.
  /// Defaults to `false`.
  final bool enableInnerGlow;

  /// Custom opacity multiplier for the inner glow (0.0 to 1.0).
  final double? innerGlowOpacity;

  /// Custom blur radius for the inner glow. Defaults to [shadowBlur] if omitted.
  final double? innerGlowBlur;

  /// Optional callback invoked when the spatial tilt coordinate updates
  /// from physical sensors, cursor hover, or manual input.
  final ValueChanged<Offset>? onTiltChanged;

  /// Optional callback invoked when the card is tapped.
  final VoidCallback? onTap;

  /// Clipping behavior for content extending beyond the rounded card bounds.
  final Clip clipBehavior;

  /// Creates a [ByCard].
  const ByCard({
    super.key,
    required this.child,
    this.variant = ByCardVariant.normal,
    this.enableSensor = false,
    this.manualTilt,
    this.onTiltChanged,
    this.backgroundColor,
    this.borderRadius = ByCardDefaults.borderRadius,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderWidth = ByCardDefaults.borderWidth,
    this.borderColor,
    this.borderGradient,
    this.shadows,
    this.shadowGradient,
    this.shadowBlur = ByCardDefaults.shadowBlur,
    this.maxShadowOffset = ByCardDefaults.maxShadowOffset,
    this.enableHoverTilt = true,
    this.enableInnerGlow = false,
    this.innerGlowOpacity,
    this.innerGlowBlur,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
    super.duration = ByCardDefaults.animationDuration,
    super.curve = ByCardDefaults.animationCurve,
  });

  /// Creates a [ByCard] with dynamic spatial lighting reactive to physical device
  /// motion sensors on mobile, or cursor hover parallax on Desktop/Web.
  ///
  /// [colors] is an optional convenience parameter to define the gradient border colors
  /// without manually wrapping them in a [LinearGradient].
  ByCard.dynamicSensor({
    super.key,
    required this.child,
    List<Color>? colors,
    Gradient? borderGradient,
    this.enableSensor = true,
    this.enableHoverTilt = true,
    this.enableInnerGlow = false,
    this.innerGlowOpacity,
    this.innerGlowBlur,
    this.backgroundColor,
    this.borderRadius = ByCardDefaults.borderRadius,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderWidth = ByCardDefaults.borderWidth,
    this.shadowGradient,
    this.shadowBlur = ByCardDefaults.shadowBlur,
    this.maxShadowOffset = ByCardDefaults.maxShadowOffset,
    this.manualTilt,
    this.onTiltChanged,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
    super.duration = ByCardDefaults.animationDuration,
    super.curve = ByCardDefaults.animationCurve,
  })  : variant = ByCardVariant.dynamicSensor,
        borderGradient = borderGradient ??
            (colors != null ? LinearGradient(colors: colors) : null),
        borderColor = null,
        shadows = null;

  /// Creates a [ByCard] featuring a static gradient border and directional ambient glow.
  ///
  /// [colors] is an optional convenience parameter to define the gradient border colors
  /// without manually wrapping them in a [LinearGradient].
  ByCard.gradient({
    super.key,
    required this.child,
    List<Color>? colors,
    Gradient? borderGradient,
    this.enableInnerGlow = false,
    this.innerGlowOpacity,
    this.innerGlowBlur,
    this.backgroundColor,
    this.borderRadius = ByCardDefaults.borderRadius,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderWidth = ByCardDefaults.borderWidth,
    this.shadowGradient,
    this.shadowBlur = ByCardDefaults.shadowBlur,
    this.maxShadowOffset = ByCardDefaults.maxShadowOffset,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
    super.duration = ByCardDefaults.animationDuration,
    super.curve = ByCardDefaults.animationCurve,
  })  : variant = ByCardVariant.gradient,
        borderGradient = borderGradient ??
            (colors != null ? LinearGradient(colors: colors) : null),
        borderColor = null,
        shadows = null,
        enableSensor = false,
        enableHoverTilt = false,
        manualTilt = null,
        onTiltChanged = null;

  @override
  AnimatedWidgetBaseState<ByCard> createState() => _ByCardState();
}

class _ByCardState extends AnimatedWidgetBaseState<ByCard> {
  ColorTween? _backgroundColorTween;
  ColorTween? _borderColorTween;
  BorderRadiusTween? _borderRadiusTween;
  Tween<double>? _borderWidthTween;
  Tween<double>? _shadowBlurTween;
  Tween<double>? _innerGlowOpacityTween;
  Tween<double>? _innerGlowBlurTween;

  late ByTiltController _tiltController;

  bool get _isMobilePlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    _initTiltController();
  }

  void _initTiltController() {
    final bool isMobile = _isMobilePlatform;
    final bool canEnableSensor = isMobile &&
        widget.variant == ByCardVariant.dynamicSensor &&
        widget.enableSensor;

    // For non-mobile platforms (Desktop & Web), resting neutral state is Offset.zero.
    // For mobile with sensors enabled, initial tilt starts at upright Offset(0.0, 1.0).
    final Offset defaultRestingTilt =
        isMobile ? const Offset(0.0, 1.0) : Offset.zero;

    _tiltController = ByTiltController(
      enableSensor: canEnableSensor,
      initialTilt: widget.manualTilt ?? defaultRestingTilt,
      onTiltChanged: widget.onTiltChanged,
    );
  }

  @override
  void didUpdateWidget(ByCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.onTiltChanged != oldWidget.onTiltChanged) {
      _tiltController.onTiltChanged = widget.onTiltChanged;
    }

    if (widget.manualTilt != null &&
        widget.manualTilt != oldWidget.manualTilt) {
      _tiltController.setManualTilt(widget.manualTilt!);
    }

    final bool sensorChanged = widget.enableSensor != oldWidget.enableSensor;
    final bool variantChanged = widget.variant != oldWidget.variant;

    if (sensorChanged || variantChanged) {
      _tiltController.dispose();
      _initTiltController();
    }
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _backgroundColorTween = visitor(
      _backgroundColorTween,
      widget.backgroundColor,
      (dynamic value) => ColorTween(begin: value as Color?),
    ) as ColorTween?;

    _borderColorTween = visitor(
      _borderColorTween,
      widget.borderColor,
      (dynamic value) => ColorTween(begin: value as Color?),
    ) as ColorTween?;

    _borderRadiusTween = visitor(
      _borderRadiusTween,
      widget.borderRadius is BorderRadius
          ? widget.borderRadius as BorderRadius
          : ByCardDefaults.borderRadius,
      (dynamic value) => BorderRadiusTween(begin: value as BorderRadius?),
    ) as BorderRadiusTween?;

    _borderWidthTween = visitor(
      _borderWidthTween,
      widget.borderWidth,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;

    _shadowBlurTween = visitor(
      _shadowBlurTween,
      widget.shadowBlur,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;

    _innerGlowOpacityTween = visitor(
      _innerGlowOpacityTween,
      widget.innerGlowOpacity,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;

    _innerGlowBlurTween = visitor(
      _innerGlowBlurTween,
      widget.innerGlowBlur,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;
  }

  @override
  void dispose() {
    _tiltController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color defaultBg = theme.cardColor;

    final Color resolvedBg = _backgroundColorTween?.evaluate(animation) ??
        widget.backgroundColor ??
        defaultBg;
    final Color? resolvedBorderColor =
        _borderColorTween?.evaluate(animation) ?? widget.borderColor;
    final BorderRadius resolvedRadius =
        _borderRadiusTween?.evaluate(animation) ??
            (widget.borderRadius is BorderRadius
                ? widget.borderRadius as BorderRadius
                : ByCardDefaults.borderRadius);
    final double resolvedWidth =
        _borderWidthTween?.evaluate(animation) ?? widget.borderWidth;
    final double resolvedBlur =
        _shadowBlurTween?.evaluate(animation) ?? widget.shadowBlur;
    final double? resolvedInnerGlowOpacity =
        _innerGlowOpacityTween?.evaluate(animation) ?? widget.innerGlowOpacity;
    final double? resolvedInnerGlowBlur =
        _innerGlowBlurTween?.evaluate(animation) ?? widget.innerGlowBlur;

    Widget content = Padding(
      padding: widget.padding,
      child: widget.child,
    );

    if (widget.clipBehavior != Clip.none) {
      content = ClipRRect(
        borderRadius: resolvedRadius,
        clipBehavior: widget.clipBehavior,
        child: content,
      );
    }

    if (widget.onTap != null) {
      content = Material(
        color: Colors.transparent,
        borderRadius: resolvedRadius,
        child: InkWell(
          borderRadius: resolvedRadius,
          onTap: widget.onTap,
          child: content,
        ),
      );
    }

    Widget cardCore = ListenableBuilder(
      listenable: _tiltController.tiltNotifier,
      builder: (context, _) {
        return CustomPaint(
          painter: ByCardPainter(
            variant: widget.variant,
            tilt: _tiltController.tiltNotifier.value,
            backgroundColor: resolvedBg,
            borderRadius: resolvedRadius,
            borderWidth: resolvedWidth,
            borderColor: resolvedBorderColor,
            borderGradient: widget.borderGradient,
            shadows: widget.shadows,
            shadowGradient: widget.shadowGradient,
            shadowBlur: resolvedBlur,
            maxShadowOffset: widget.maxShadowOffset,
            enableInnerGlow: widget.enableInnerGlow,
            innerGlowOpacity: resolvedInnerGlowOpacity,
            innerGlowBlur: resolvedInnerGlowBlur,
          ),
          child: content,
        );
      },
    );

    if (widget.enableHoverTilt &&
        widget.variant == ByCardVariant.dynamicSensor) {
      cardCore = MouseRegion(
        onEnter: (event) {
          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            _tiltController.updateHoverPosition(
              event.localPosition,
              renderBox.size,
            );
          }
        },
        onHover: (event) {
          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            _tiltController.updateHoverPosition(
              event.localPosition,
              renderBox.size,
            );
          }
        },
        onExit: (_) => _tiltController.smoothResetToNeutral(),
        child: cardCore,
      );
    }

    if (widget.margin != null) {
      cardCore = Padding(
        padding: widget.margin!,
        child: cardCore,
      );
    }

    return cardCore;
  }
}
