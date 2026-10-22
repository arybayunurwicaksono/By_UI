import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'by_shimmer_scope.dart';
import 'by_skeleton_style.dart';

/// A standalone placeholder bone geometry used within skeletons.
///
/// Automatically synchronizes its shimmer sweep with any ambient [ByShimmerScope],
/// or creates an internal lightweight animation if rendered standalone.
class ByBone extends StatefulWidget {
  /// The explicit width of the bone, or null to expand to parent constraints.
  final double? width;

  /// The explicit height of the bone, or null to expand to parent constraints.
  final double? height;

  /// Corner radius geometry for rectangular shapes.
  final BorderRadius? borderRadius;

  /// Whether the bone shape is a perfect circle.
  final bool isCircle;

  /// Optional direct base color override.
  final Color? baseColor;

  /// Optional direct highlight shimmer color override.
  final Color? highlightColor;

  /// Optional border stroke color.
  final Color? borderColor;

  /// Optional border stroke width.
  final double? borderWidth;

  /// Optional outer margin around the bone.
  final EdgeInsetsGeometry? margin;

  /// Optional custom style override.
  final BySkeletonStyle? style;

  /// Optional explicit direction override for the traveling shimmer wave.
  final ByShimmerDirection? direction;

  /// Creates a generic [ByBone].
  const ByBone({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.isCircle = false,
    this.baseColor,
    this.highlightColor,
    this.borderColor,
    this.borderWidth,
    this.margin,
    this.style,
    this.direction,
  });

  /// Creates a rectangular bone tailored for text lines with standard typographical height.
  const ByBone.text({
    super.key,
    this.width,
    this.height = 14.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.baseColor,
    this.highlightColor,
    this.borderColor,
    this.borderWidth,
    this.margin,
    this.style,
    this.direction,
  }) : isCircle = false;

  /// Creates a circular bone tailored for avatars, icons, or token badges.
  const ByBone.circular({
    super.key,
    required double size,
    this.baseColor,
    this.highlightColor,
    this.borderColor,
    this.borderWidth,
    this.margin,
    this.style,
    this.direction,
  })  : width = size,
        height = size,
        borderRadius = null,
        isCircle = true;

  /// Creates a rectangular bone tailored for cards, image containers, or button blocks.
  const ByBone.rect({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.baseColor,
    this.highlightColor,
    this.borderColor,
    this.borderWidth,
    this.margin,
    this.style,
    this.direction,
  }) : isCircle = false;

  @override
  State<ByBone> createState() => _ByBoneState();
}

class _ByBoneState extends State<ByBone> with SingleTickerProviderStateMixin {
  AnimationController? _fallbackController;

  @override
  void dispose() {
    _fallbackController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = ByShimmerScope.maybeOf(context);
    final effectiveStyle =
        BySkeletonStyle.resolve(context, custom: widget.style);

    Widget result;
    // If an ancestor ByShimmerScope is present, synchronize directly with its phase.
    if (scope != null) {
      result = _buildBonePainter(scope.phase, effectiveStyle, scope);
    } else {
      // Otherwise, lazily instantiate a local controller for standalone usage.
      _fallbackController ??= AnimationController(
        vsync: this,
        duration: effectiveStyle.shimmerDuration,
      )..repeat();

      result = AnimatedBuilder(
        animation: _fallbackController!,
        builder: (context, _) {
          return _buildBonePainter(
              _fallbackController!.value, effectiveStyle, null);
        },
      );
    }

    if (widget.margin != null) {
      return Padding(
        padding: widget.margin!,
        child: result,
      );
    }
    return result;
  }

  Widget _buildBonePainter(
    double phase,
    BySkeletonStyle style,
    ByShimmerScopeState? scope,
  ) {
    final effectiveDirection =
        widget.direction ?? scope?.direction ?? style.direction;
    final effectiveWaveWidth =
        scope?.shimmerWaveWidth ?? style.shimmerWidthFactor;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: _ByBonePainter(
          phase: phase,
          isCircle: widget.isCircle,
          borderRadius: widget.borderRadius ?? style.borderRadius,
          baseColor: widget.baseColor,
          highlightColor: widget.highlightColor,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
          style: style,
          direction: effectiveDirection,
          shimmerWaveWidth: effectiveWaveWidth,
        ),
      ),
    );
  }
}

class _ByBonePainter extends CustomPainter {
  final double phase;
  final bool isCircle;
  final BorderRadius borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Color? borderColor;
  final double? borderWidth;
  final BySkeletonStyle style;
  final ByShimmerDirection direction;
  final double shimmerWaveWidth;

  _ByBonePainter({
    required this.phase,
    required this.isCircle,
    required this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.borderColor,
    this.borderWidth,
    required this.style,
    this.direction = ByShimmerDirection.ltr,
    this.shimmerWaveWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    final effectiveBaseColor = baseColor ?? style.baseColor;
    final effectiveHighlightColor = highlightColor ?? style.highlightColor;
    final effectiveBorderColor = borderColor ?? style.borderColor;
    final effectiveBorderWidth = borderWidth ?? style.borderWidth;

    // 1. Base bone background
    final basePaint = Paint()
      ..color = effectiveBaseColor
      ..style = PaintingStyle.fill;

    if (isCircle) {
      canvas.drawCircle(rect.center, size.shortestSide / 2, basePaint);
    } else {
      canvas.drawRRect(rrect, basePaint);
    }

    // 2. Blueprint scanlines for glassmorphic variant
    if (style.variant == BySkeletonVariant.glassmorphic) {
      final linePaint = Paint()
        ..color =
            effectiveHighlightColor.withValues(alpha: style.scanlineOpacity)
        ..strokeWidth = 1.0;

      canvas.save();
      if (isCircle) {
        final path = Path()..addOval(rect);
        canvas.clipPath(path);
      } else {
        canvas.clipRRect(rrect);
      }

      final spacing = style.scanlineSpacing;
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
      }
      canvas.restore();
    }

    // 3. Animated gradient shimmer sweep according to direction
    final Alignment begin;
    final Alignment end;
    final Rect shaderRect;

    switch (direction) {
      case ByShimmerDirection.ltr:
        begin = Alignment.centerLeft;
        end = Alignment.centerRight;
        final sweepWidth = size.width * shimmerWaveWidth;
        final sweepStart = -sweepWidth + (phase * (size.width + sweepWidth));
        final sweepEnd = sweepStart + sweepWidth;
        shaderRect = Rect.fromLTRB(sweepStart, 0, sweepEnd, size.height);
        break;
      case ByShimmerDirection.rtl:
        begin = Alignment.centerRight;
        end = Alignment.centerLeft;
        final sweepWidth = size.width * shimmerWaveWidth;
        final sweepStart =
            size.width + sweepWidth - (phase * (size.width + sweepWidth));
        final sweepEnd = sweepStart - sweepWidth;
        shaderRect = Rect.fromLTRB(sweepEnd, 0, sweepStart, size.height);
        break;
      case ByShimmerDirection.ttb:
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
        final sweepHeight = size.height * shimmerWaveWidth;
        final sweepStart = -sweepHeight + (phase * (size.height + sweepHeight));
        final sweepEnd = sweepStart + sweepHeight;
        shaderRect = Rect.fromLTRB(0, sweepStart, size.width, sweepEnd);
        break;
      case ByShimmerDirection.btt:
        begin = Alignment.bottomCenter;
        end = Alignment.topCenter;
        final sweepHeight = size.height * shimmerWaveWidth;
        final sweepStart =
            size.height + sweepHeight - (phase * (size.height + sweepHeight));
        final sweepEnd = sweepStart - sweepHeight;
        shaderRect = Rect.fromLTRB(0, sweepEnd, size.width, sweepStart);
        break;
      case ByShimmerDirection.diagonal:
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
        final sweepDim = math.max(size.width, size.height) * shimmerWaveWidth;
        final sweepStart = -sweepDim +
            (phase * (math.max(size.width, size.height) + sweepDim));
        final sweepEnd = sweepStart + sweepDim;
        shaderRect = Rect.fromLTRB(sweepStart, sweepStart, sweepEnd, sweepEnd);
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
              Colors.transparent,
              effectiveHighlightColor.withValues(
                alpha: style.variant == BySkeletonVariant.glassmorphic
                    ? 0.45
                    : 0.65,
              ),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          );

    final sweepPaint = Paint()
      ..shader = sweepGradient.createShader(shaderRect)
      ..blendMode = style.variant == BySkeletonVariant.glassmorphic
          ? BlendMode.screen
          : BlendMode.srcATop;

    canvas.save();
    if (isCircle) {
      canvas.drawCircle(rect.center, size.shortestSide / 2, sweepPaint);
    } else {
      canvas.drawRRect(rrect, sweepPaint);
    }
    canvas.restore();

    // 4. Border stroke for glassmorphic variant or explicit borderColor
    if (effectiveBorderColor != null ||
        style.variant == BySkeletonVariant.glassmorphic) {
      final strokeW = effectiveBorderWidth ?? 1.0;
      final strokeColor = effectiveBorderColor ??
          effectiveHighlightColor.withValues(alpha: 0.35);

      final borderPaint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW;

      final halfStroke = strokeW / 2;
      if (isCircle) {
        canvas.drawCircle(
            rect.center, (size.shortestSide / 2) - halfStroke, borderPaint);
      } else {
        canvas.drawRRect(rrect.deflate(halfStroke), borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ByBonePainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.style != style ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.isCircle != isCircle ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}
