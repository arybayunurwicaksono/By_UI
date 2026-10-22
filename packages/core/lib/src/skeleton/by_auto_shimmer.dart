import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../dynamic_border/by_dynamic_border.dart';
import '../dynamic_border/by_dynamic_border_controller.dart';
import '../dynamic_border/by_dynamic_border_layer.dart';
import 'by_bone.dart';
import 'by_shimmer_scope.dart';
import 'by_skeleton_style.dart';

/// An automated skeleton loading container that intercepts child geometry or provides
/// structural placeholder bones with signature hardware-accelerated dynamic border physics.
///
/// ### Core Features:
/// 1. **Perimeter Dynamic Border Pulse:** During loading (`isLoading: true`), a rhythmic
///    flowing laser beam traverses the perimeter edge, communicating active background synchronization.
/// 2. **Laser Beam Materialize Reveal:** When loading completes, an animated perimeter laser sweep
///    fluidly morphs placeholder bones into crisp live content.
/// 3. **Synchronized Multi-Card Phase:** If placed inside a [ByShimmerScope], all skeleton cards
///    shimmer in harmonious unified phase without causing a "ticker storm".
/// 4. **Graceful Fallback:** Supports [skeletonBuilder] for explicit bones when models might be
///    null during initial API fetching.
class ByAutoShimmer extends StatefulWidget {
  /// Whether the component is currently in the data-fetching / loading state.
  final bool isLoading;

  /// The live content widget rendered when loading is false.
  final Widget child;

  /// Optional custom skeleton widget tree. If omitted, [ByAutoShimmer] renders an
  /// automated layout mask across [child].
  final WidgetBuilder? skeletonBuilder;

  /// Styling tokens for the skeleton bone surface and shimmer wave.
  final BySkeletonStyle? style;

  /// Corner radius of the container perimeter. Defaults to 12.0.
  final BorderRadius borderRadius;

  /// Whether to pulse a traveling dynamic border around the perimeter while loading.
  final bool enableDynamicBorderPulse;

  /// Whether to trigger a laser beam reveal sweep when transitioning from loading to ready.
  final bool enableLaserReveal;

  /// Colors for the perimeter laser beam during pulse and reveal.
  final List<Color>? laserColors;

  /// Background surface color of the skeleton container.
  final Color? backgroundColor;

  /// Outer border stroke color of the container.
  final Color? borderColor;

  /// Outer border stroke width of the container.
  final double? borderWidth;

  /// Inner padding of the skeleton container.
  final EdgeInsetsGeometry? padding;

  /// Width of the dynamic laser border pulse. Defaults to 2.0.
  final double dynamicBorderWidth;

  /// Glow blur radius of the dynamic laser border pulse. Defaults to 10.0.
  final double dynamicBorderGlowBlur;

  /// Animation duration of one cycle of dynamic border laser pulse. Defaults to 1400ms.
  final Duration dynamicBorderDuration;

  /// Duration of the cross-fade / morph transition when loading finishes.
  final Duration transitionDuration;

  /// Optional callback invoked when the laser reveal transition completes.
  final VoidCallback? onRevealComplete;

  /// Direction of the shimmer wave sweep. Defaults to [ByShimmerDirection.ltr].
  final ByShimmerDirection direction;

  /// Duration of one complete cycle of the background shimmer wave. Defaults to 1500ms.
  final Duration shimmerDuration;

  /// Easing curve for the materialize laser reveal transition. Defaults to [Curves.easeOutCubic].
  final Curve transitionCurve;

  /// Width multiplier for the illuminated shimmer sweep beam. Defaults to 1.5.
  final double shimmerWaveWidth;

  /// Creates a [ByAutoShimmer].
  const ByAutoShimmer({
    super.key,
    required this.isLoading,
    required this.child,
    this.skeletonBuilder,
    this.style,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.enableDynamicBorderPulse = true,
    this.enableLaserReveal = true,
    this.laserColors,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.dynamicBorderWidth = 2.0,
    this.dynamicBorderGlowBlur = 10.0,
    this.dynamicBorderDuration = const Duration(milliseconds: 1400),
    this.transitionDuration = const Duration(milliseconds: 400),
    this.onRevealComplete,
    this.direction = ByShimmerDirection.ltr,
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.transitionCurve = Curves.easeOutCubic,
    this.shimmerWaveWidth = 1.5,
  });

  /// Factory constructor for a pre-configured card skeleton placeholder.
  ///
  /// Displays an image banner placeholder and two text line bones while loading.
  factory ByAutoShimmer.card({
    Key? key,
    required bool isLoading,
    required Widget child,
    double? width,
    double? height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    EdgeInsetsGeometry? padding = const EdgeInsets.all(12.0),
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    ByShimmerDirection direction = ByShimmerDirection.ltr,
    bool enableDynamicBorderPulse = true,
    bool enableLaserReveal = true,
  }) {
    return ByAutoShimmer(
      key: key,
      isLoading: isLoading,
      borderRadius: borderRadius,
      padding: padding,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      direction: direction,
      enableDynamicBorderPulse: enableDynamicBorderPulse,
      enableLaserReveal: enableLaserReveal,
      skeletonBuilder: (context) {
        return SizedBox(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ByBone.rect(
                width: double.infinity,
                height: 120.0,
                borderRadius: BorderRadius.circular(8.0),
              ),
              const SizedBox(height: 12.0),
              const ByBone.text(width: double.infinity, height: 16.0),
              const SizedBox(height: 8.0),
              const ByBone.text(width: 140.0, height: 12.0),
            ],
          ),
        );
      },
      child: child,
    );
  }

  /// Factory constructor for a pre-configured list tile skeleton placeholder.
  ///
  /// Displays a leading circular avatar placeholder with title and subtitle line bones.
  factory ByAutoShimmer.listTile({
    Key? key,
    required bool isLoading,
    required Widget child,
    double avatarSize = 40.0,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    EdgeInsetsGeometry? padding =
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    ByShimmerDirection direction = ByShimmerDirection.ltr,
    bool enableDynamicBorderPulse = true,
    bool enableLaserReveal = true,
  }) {
    return ByAutoShimmer(
      key: key,
      isLoading: isLoading,
      borderRadius: borderRadius,
      padding: padding,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      direction: direction,
      enableDynamicBorderPulse: enableDynamicBorderPulse,
      enableLaserReveal: enableLaserReveal,
      skeletonBuilder: (context) {
        return Row(
          children: [
            ByBone.circular(size: avatarSize),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  ByBone.text(width: double.infinity, height: 14.0),
                  SizedBox(height: 6.0),
                  ByBone.text(width: 120.0, height: 11.0),
                ],
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }

  @override
  State<ByAutoShimmer> createState() => _ByAutoShimmerState();
}

class _ByAutoShimmerState extends State<ByAutoShimmer>
    with TickerProviderStateMixin {
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;
  ByDynamicBorderController? _borderPulseController;
  AnimationController? _fallbackShimmerController;

  @override
  void initState() {
    super.initState();
    _borderPulseController = ByDynamicBorderController();

    _revealController = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: widget.transitionCurve,
    );

    if (!widget.isLoading) {
      _revealController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ByAutoShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading) {
      // Transition from LOADING -> CONTENT (Trigger Laser Reveal)
      _fallbackShimmerController?.stop();
      _triggerLaserReveal();
    } else if (!oldWidget.isLoading && widget.isLoading) {
      // Transition from CONTENT -> LOADING
      _revealController.value = 0.0;
      _fallbackShimmerController?.repeat();
    }
  }

  void _triggerLaserReveal() {
    if (widget.enableLaserReveal) {
      _borderPulseController?.pulse();
    }
    _revealController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {});
        widget.onRevealComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _revealController.dispose();
    _borderPulseController?.dispose();
    _fallbackShimmerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        BySkeletonStyle.resolve(context, custom: widget.style);

    // If completely loaded and not transitioning, return clean child directly
    if (!widget.isLoading && _revealController.isCompleted) {
      return widget.child;
    }

    final laserColors = widget.laserColors ??
        const [
          Color(0xFF38BDF8), // Sky Cyan
          Color(0xFF6366F1), // Indigo
          Color(0xFFA855F7), // Purple
        ];

    final dynamicBorderConfig = ByDynamicBorder(
      enabled: widget.enableDynamicBorderPulse || widget.enableLaserReveal,
      controller: _borderPulseController,
      colors: laserColors,
      width: widget.dynamicBorderWidth,
      glowBlur: widget.dynamicBorderGlowBlur,
      duration: widget.dynamicBorderDuration,
      autoStart: widget.isLoading && widget.enableDynamicBorderPulse,
      repeatCount:
          widget.isLoading ? -1 : 1, // Repeat continuously while loading
      periodicInterval: const Duration(milliseconds: 150),
    );

    Widget skeletonContent;
    if (widget.skeletonBuilder != null) {
      final built = widget.skeletonBuilder!(context);
      final ambientScope = ByShimmerScope.maybeOf(context);
      if (ambientScope == null) {
        skeletonContent = ByShimmerScope(
          duration: widget.shimmerDuration,
          direction: widget.direction,
          shimmerWaveWidth: widget.shimmerWaveWidth,
          enabled: widget.isLoading,
          child: built,
        );
      } else {
        skeletonContent = built;
      }
    } else {
      skeletonContent = _buildAutoMask(effectiveStyle);
    }

    Widget body;
    if (widget.isLoading && _revealController.value == 0.0) {
      body = skeletonContent;
    } else {
      // Cross-fade with Laser Reveal morphing
      body = Stack(
        fit: StackFit.passthrough,
        children: [
          // Content fading in
          FadeTransition(
            opacity: _revealAnimation,
            child: widget.child,
          ),
          // Skeleton bones dissolving out
          if (!_revealController.isCompleted)
            Positioned.fill(
              child: ClipRect(
                child: FadeTransition(
                  opacity: Tween<double>(begin: 1.0, end: 0.0)
                      .animate(_revealAnimation),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: FittedBox(
                          fit: BoxFit.none,
                          alignment: Alignment.topLeft,
                          clipBehavior: Clip.hardEdge,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                              maxWidth: constraints.maxWidth,
                            ),
                            child: skeletonContent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      );
    }

    if (widget.padding != null) {
      body = Padding(
        padding: widget.padding!,
        child: body,
      );
    }

    if (widget.backgroundColor != null || widget.borderColor != null) {
      body = DecoratedBox(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          border: widget.borderColor != null
              ? Border.all(
                  color: widget.borderColor!,
                  width: widget.borderWidth ?? 1.0,
                )
              : null,
        ),
        child: body,
      );
    }

    if (widget.enableDynamicBorderPulse || widget.enableLaserReveal) {
      return ByDynamicBorderLayer(
        config: dynamicBorderConfig,
        borderRadius: widget.borderRadius,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: body,
        ),
      );
    }

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: body,
    );
  }

  /// Builds automated shader masking over the child tree without altering layout dimensions.
  Widget _buildAutoMask(BySkeletonStyle style) {
    final scope = ByShimmerScope.maybeOf(context);

    if (scope != null) {
      return _ByAutomatedMaskPainterWidget(
        phase: scope.phase,
        style: style,
        direction: widget.direction,
        shimmerWaveWidth: widget.shimmerWaveWidth,
        child: widget.child,
      );
    }

    _fallbackShimmerController ??= AnimationController(
      vsync: this,
      duration: widget.shimmerDuration,
    )..repeat();

    return AnimatedBuilder(
      animation: _fallbackShimmerController!,
      builder: (context, _) {
        return _ByAutomatedMaskPainterWidget(
          phase: _fallbackShimmerController!.value,
          style: style,
          direction: widget.direction,
          shimmerWaveWidth: widget.shimmerWaveWidth,
          child: widget.child,
        );
      },
    );
  }
}

class _ByAutomatedMaskPainterWidget extends StatelessWidget {
  final double phase;
  final BySkeletonStyle style;
  final Widget child;
  final ByShimmerDirection direction;
  final double shimmerWaveWidth;

  const _ByAutomatedMaskPainterWidget({
    required this.phase,
    required this.style,
    required this.child,
    this.direction = ByShimmerDirection.ltr,
    this.shimmerWaveWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        final Alignment begin;
        final Alignment end;
        final Rect shaderRect;

        switch (direction) {
          case ByShimmerDirection.ltr:
            begin = Alignment.centerLeft;
            end = Alignment.centerRight;
            final sweepWidth = bounds.width * shimmerWaveWidth;
            final sweepStart =
                -sweepWidth + (phase * (bounds.width + sweepWidth));
            final sweepEnd = sweepStart + sweepWidth;
            shaderRect = Rect.fromLTRB(sweepStart, 0, sweepEnd, bounds.height);
            break;
          case ByShimmerDirection.rtl:
            begin = Alignment.centerRight;
            end = Alignment.centerLeft;
            final sweepWidth = bounds.width * shimmerWaveWidth;
            final sweepStart = bounds.width +
                sweepWidth -
                (phase * (bounds.width + sweepWidth));
            final sweepEnd = sweepStart - sweepWidth;
            shaderRect = Rect.fromLTRB(sweepEnd, 0, sweepStart, bounds.height);
            break;
          case ByShimmerDirection.ttb:
            begin = Alignment.topCenter;
            end = Alignment.bottomCenter;
            final sweepHeight = bounds.height * shimmerWaveWidth;
            final sweepStart =
                -sweepHeight + (phase * (bounds.height + sweepHeight));
            final sweepEnd = sweepStart + sweepHeight;
            shaderRect = Rect.fromLTRB(0, sweepStart, bounds.width, sweepEnd);
            break;
          case ByShimmerDirection.btt:
            begin = Alignment.bottomCenter;
            end = Alignment.topCenter;
            final sweepHeight = bounds.height * shimmerWaveWidth;
            final sweepStart = bounds.height +
                sweepHeight -
                (phase * (bounds.height + sweepHeight));
            final sweepEnd = sweepStart - sweepHeight;
            shaderRect = Rect.fromLTRB(0, sweepEnd, bounds.width, sweepStart);
            break;
          case ByShimmerDirection.diagonal:
            begin = Alignment.topLeft;
            end = Alignment.bottomRight;
            final sweepDim =
                math.max(bounds.width, bounds.height) * shimmerWaveWidth;
            final sweepStart = -sweepDim + (phase * (bounds.width + sweepDim));
            final sweepEnd = sweepStart + sweepDim;
            shaderRect =
                Rect.fromLTRB(sweepStart, sweepStart, sweepEnd, sweepEnd);
            break;
        }

        final sweepGradient = style.shimmerGradient != null
            ? LinearGradient(
                begin: begin,
                end: end,
                colors: style.shimmerGradient!.colors,
                stops: style.shimmerGradient!.stops,
                tileMode: style.shimmerGradient!.tileMode,
                transform: style.shimmerGradient!.transform,
              )
            : LinearGradient(
                begin: begin,
                end: end,
                colors: [
                  style.baseColor,
                  style.highlightColor,
                  style.baseColor,
                ],
                stops: const [0.0, 0.5, 1.0],
              );

        return sweepGradient.createShader(shaderRect);
      },
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          style.baseColor,
          BlendMode.srcIn,
        ),
        child: child,
      ),
    );
  }
}

/// Backward compatibility alias for [ByAutoShimmer].
typedef ByAutoSkeleton = ByAutoShimmer;
