import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'by_dynamic_border.dart';

/// Custom painter rendering a high-precision 3-phase traveling pulse beam
/// along the perimeter of a rounded rectangle ([RRect]).
class ByDynamicBorderPainter extends CustomPainter {
  /// Configuration specification for the dynamic pulse border.
  final ByDynamicBorder config;

  /// Corner radius of the host widget.
  final BorderRadius borderRadius;

  /// Normalized animation timeline progress in range [0.0, 1.0].
  final double progress;

  /// Creates a [ByDynamicBorderPainter].
  ByDynamicBorderPainter({
    required this.config,
    required this.borderRadius,
    required this.progress,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !config.enabled || progress <= 0.0 || progress >= 1.0) {
      return;
    }

    final double opacity = _calculateBeamOpacity(progress);
    if (opacity <= 0.002) return;

    final Rect rect = Offset.zero & size;
    // Deflate by half border width so the stroke stays aligned to the edge
    final RRect rrect = borderRadius
        .toRRect(rect)
        .deflate((config.width.clamp(1.0, 10.0)) / 2.0);

    final Path perimeterPath = _buildPerimeterPath(rrect, config.origin);
    final List<PathMetric> metrics = perimeterPath.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final PathMetric metric = metrics.first;
    final double totalLength = metric.length;
    if (totalLength <= 0.0) return;

    // Calculate physical head along perimeter with C^1 continuous 3-phase velocity
    final double headProgress = _calculatePerimeterPosition(progress);
    final double headDistance = headProgress * totalLength;

    // Smooth width bloom factor: starts near zero and blooms smoothly to prevent blunt stubs at Point A
    final double widthFactor = _calculateBeamWidthFactor(progress);
    final double strokeWidth = (config.width * widthFactor).clamp(0.1, 12.0);

    // 1. Calculate perimeter segment for the primary border beam
    final double targetBeamLength =
        config.beamLength.clamp(0.02, 1.0) * totalLength;
    final double beamTailDistance = _calculateTailDistance(
      progress,
      headDistance,
      targetBeamLength,
      totalLength,
    );
    final Path beamPath = _extractPerimeterSegment(
      metric,
      totalLength,
      beamTailDistance,
      headDistance,
    );

    // 2. Calculate perimeter segment for the outer shadow
    final double shadowLengthFraction =
        (config.shadowLength ?? config.beamLength).clamp(0.02, 1.0);
    final double targetShadowLength = shadowLengthFraction * totalLength;
    final double shadowTailDistance = _calculateTailDistance(
      progress,
      headDistance,
      targetShadowLength,
      totalLength,
    );
    final Path shadowPath = _extractPerimeterSegment(
      metric,
      totalLength,
      shadowTailDistance,
      headDistance,
    );

    final double shadowBlur =
        (config.shadowBlur * widthFactor).clamp(0.0, 32.0);
    final double shadowThickness =
        (config.shadowWidth * widthFactor).clamp(0.0, 20.0);

    // 1. Subtle Outer-Only Shadow Pass (Decoupled color, length, and thickness)
    // Strictly clipped outside the widget boundary (EvenOdd) so zero shadow casts inward.
    if (shadowBlur > 0.0 || shadowThickness > 0.0) {
      canvas.save();
      final Path outerClip = Path()
        ..addRect(
          rect.inflate(
            (shadowBlur + shadowThickness) * 3.0 + strokeWidth * 3.0,
          ),
        )
        ..addRRect(borderRadius.toRRect(rect))
        ..fillType = PathFillType.evenOdd;
      canvas.clipPath(outerClip);

      final Color baseShadowColor =
          config.shadowColor ?? const Color(0x66000000);
      final Paint shadowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = strokeWidth + shadowThickness
        ..color = baseShadowColor.withValues(
          alpha: (baseShadowColor.a * opacity).clamp(0.0, 1.0),
        );

      if (shadowBlur > 0.0) {
        shadowPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);
      }

      canvas.drawPath(shadowPath, shadowPaint);
      canvas.restore();
    }

    // 2. Dominant Core Border Pass (Crisp, sharp, multi-color gradient supported)
    final Paint corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    if (config.gradient != null) {
      corePaint.shader = _modulateGradient(
        config.gradient!,
        rrect.outerRect,
        opacity,
      ).createShader(rrect.outerRect);
    } else if (config.colors.length > 1) {
      final List<Color> modulatedColors = config.colors
          .map((c) => c.withValues(alpha: (c.a * opacity).clamp(0.0, 1.0)))
          .toList();
      corePaint.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: modulatedColors,
      ).createShader(rrect.outerRect);
    } else if (config.colors.isNotEmpty) {
      final Color c = config.colors.first;
      corePaint.color = c.withValues(alpha: (c.a * opacity).clamp(0.0, 1.0));
    } else {
      corePaint.color = const Color(0xFF38BDF8).withValues(alpha: opacity);
    }

    canvas.drawPath(beamPath, corePaint);
  }

  /// Modulates the opacity of any Gradient type ([LinearGradient], [RadialGradient], [SweepGradient]).
  Gradient _modulateGradient(Gradient gradient, Rect bounds, double alpha) {
    if (alpha >= 0.999) return gradient;
    if (gradient is LinearGradient) {
      return LinearGradient(
        begin: gradient.begin,
        end: gradient.end,
        colors: gradient.colors
            .map((c) => c.withValues(alpha: (c.a * alpha).clamp(0.0, 1.0)))
            .toList(),
        stops: gradient.stops,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
      );
    } else if (gradient is RadialGradient) {
      return RadialGradient(
        center: gradient.center,
        radius: gradient.radius,
        colors: gradient.colors
            .map((c) => c.withValues(alpha: (c.a * alpha).clamp(0.0, 1.0)))
            .toList(),
        stops: gradient.stops,
        tileMode: gradient.tileMode,
        focal: gradient.focal,
        focalRadius: gradient.focalRadius,
        transform: gradient.transform,
      );
    } else if (gradient is SweepGradient) {
      return SweepGradient(
        center: gradient.center,
        startAngle: gradient.startAngle,
        endAngle: gradient.endAngle,
        colors: gradient.colors
            .map((c) => c.withValues(alpha: (c.a * alpha).clamp(0.0, 1.0)))
            .toList(),
        stops: gradient.stops,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
      );
    }
    return gradient;
  }

  /// Extracts a subsegment along the perimeter [metric] handling start/end wrap.
  Path _extractPerimeterSegment(
    PathMetric metric,
    double totalLength,
    double tailDistance,
    double headDistance,
  ) {
    final Path segmentPath = Path();
    if (tailDistance < 0.0) {
      final double end = headDistance.clamp(0.0, totalLength);
      if (end > 0.0) {
        segmentPath.addPath(metric.extractPath(0.0, end), Offset.zero);
      }
    } else if (headDistance > totalLength) {
      final double start = tailDistance.clamp(0.0, totalLength);
      segmentPath.addPath(metric.extractPath(start, totalLength), Offset.zero);
      final double wrapEnd =
          (headDistance - totalLength).clamp(0.0, totalLength);
      if (wrapEnd > 0.0) {
        segmentPath.addPath(metric.extractPath(0.0, wrapEnd), Offset.zero);
      }
    } else {
      segmentPath.addPath(
        metric.extractPath(tailDistance, headDistance),
        Offset.zero,
      );
    }
    return segmentPath;
  }

  /// Calculates smooth width emergence factor in [0.0, 1.0] to prevent blunt stubs at Point A.
  double _calculateBeamWidthFactor(double tau) {
    final double t = tau.clamp(0.0, 1.0);
    const double t1 = 0.28;
    const double t2 = 0.72;
    if (t < t1) {
      final double norm = t / t1;
      return math.sqrt(norm);
    } else if (t > t2) {
      final double norm = (1.0 - t) / (1.0 - t2);
      return math.sqrt(norm);
    } else {
      return 1.0;
    }
  }

  /// Calculates the continuous C^1 3-phase perimeter distance fraction in [0.0, 1.0].
  ///
  /// - Phase 1 (PELAN: 0.00 to 0.28): Quadratic acceleration from v = 0 up to cruise speed (~19.4% distance).
  /// - Phase 2 (KENCANG: 0.28 to 0.72): High-velocity constant cruise V ~= 1.3889 (~61.1% distance).
  /// - Phase 3 (PELAN LAGI: 0.72 to 1.00): Quadratic deceleration from cruise speed to v = 0 (~19.4% distance).
  double _calculatePerimeterPosition(double tau) {
    final double t = tau.clamp(0.0, 1.0);
    const double t1 = 0.28;
    const double t2 = 0.72;
    const double cruiseV = 1.0 / t2; // ~1.3888889
    const double d1 = 0.5 * cruiseV * t1; // ~0.1944444

    if (t <= t1) {
      // Phase 1 (PELAN): Quadratic launch from v = 0
      final double norm = t / t1;
      return d1 * (norm * norm);
    } else if (t <= t2) {
      // Phase 2 (KENCANG): Steady high-speed cruise
      return d1 + cruiseV * (t - t1);
    } else {
      // Phase 3 (PELAN LAGI): Quadratic deceleration to v = 0
      final double norm = (1.0 - t) / (1.0 - t2);
      return 1.0 - (d1 * (norm * norm));
    }
  }

  /// Calculates the strictly monotonic tail distance along the perimeter.
  ///
  /// During Phase 1 (Perlahan Muncul), the tail smoothly glides forward from
  /// Point A (0.0) behind the head, expanding up to [targetLength] in early Phase 2.
  /// During Phase 3 (Perlahan Menghilang), the tail catches up to dock with head at [totalLength].
  double _calculateTailDistance(
    double tau,
    double headDistance,
    double targetLength,
    double totalLength,
  ) {
    final double t = tau.clamp(0.0, 1.0);
    const double t1 = 0.28;
    const double t2 = 0.72;
    const double tFull = 0.42;

    if (t <= tFull) {
      // Emergence Phase (Perlahan Muncul):
      const double cruiseV = 1.0 / t2;
      const double d1 = 0.5 * cruiseV * t1;
      final double headAtFull = (d1 + cruiseV * (tFull - t1)) * totalLength;
      final double tailAtFull = math.max(0.0, headAtFull - targetLength);
      final double norm = t / tFull;
      return (tailAtFull * (norm * norm)).clamp(0.0, headDistance);
    } else if (t <= t2) {
      // Cruise Phase (Kencang): Constant beam length
      return math.max(0.0, headDistance - targetLength);
    } else {
      // Dissipation Phase (Perlahan Menghilang):
      final double norm = ((1.0 - t) / (1.0 - t2)).clamp(0.0, 1.0);
      final double shrinkLength = targetLength * (norm * norm);
      return math.max(0.0, headDistance - shrinkLength);
    }
  }

  /// Calculates the 3-phase beam opacity multiplier in [0.0, 1.0].
  ///
  /// - 0.00 to 0.28: Symmetrical quadratic ease-in from 0.0 (Perlahan Muncul).
  /// - 0.28 to 0.72: Full vivid solid opacity (1.0) (Kencang).
  /// - 0.72 to 1.00: Symmetrical quadratic ease-out to 0.0 (Perlahan Menghilang).
  double _calculateBeamOpacity(double tau) {
    final double t = tau.clamp(0.0, 1.0);
    const double t1 = 0.28;
    const double t2 = 0.72;
    if (t < t1) {
      final double norm = t / t1;
      return norm * norm;
    } else if (t <= t2) {
      return 1.0;
    } else {
      final double norm = (1.0 - t) / (1.0 - t2);
      return norm * norm;
    }
  }

  /// Constructs a deterministic clockwise perimeter path starting exactly
  /// at the chosen [ByBorderOrigin] (Point A).
  Path _buildPerimeterPath(RRect rrect, ByBorderOrigin origin) {
    final double left = rrect.left;
    final double top = rrect.top;
    final double right = rrect.right;
    final double bottom = rrect.bottom;
    final double width = rrect.width;
    final double height = rrect.height;

    final double rtlX = math.min(rrect.tlRadiusX, width / 2);
    final double rtlY = math.min(rrect.tlRadiusY, height / 2);
    final double rtrX = math.min(rrect.trRadiusX, width / 2);
    final double rtrY = math.min(rrect.trRadiusY, height / 2);
    final double rbrX = math.min(rrect.brRadiusX, width / 2);
    final double rbrY = math.min(rrect.brRadiusY, height / 2);
    final double rblX = math.min(rrect.blRadiusX, width / 2);
    final double rblY = math.min(rrect.blRadiusY, height / 2);

    final Path path = Path();

    void addTopRightCorner() {
      if (rtrX > 0.001 && rtrY > 0.001) {
        path.arcTo(
          Rect.fromLTWH(right - 2 * rtrX, top, 2 * rtrX, 2 * rtrY),
          1.5 * math.pi,
          0.5 * math.pi,
          false,
        );
      } else {
        path.lineTo(right, top);
      }
    }

    void addBottomRightCorner() {
      if (rbrX > 0.001 && rbrY > 0.001) {
        path.arcTo(
          Rect.fromLTWH(
              right - 2 * rbrX, bottom - 2 * rbrY, 2 * rbrX, 2 * rbrY),
          0.0,
          0.5 * math.pi,
          false,
        );
      } else {
        path.lineTo(right, bottom);
      }
    }

    void addBottomLeftCorner() {
      if (rblX > 0.001 && rblY > 0.001) {
        path.arcTo(
          Rect.fromLTWH(left, bottom - 2 * rblY, 2 * rblX, 2 * rblY),
          0.5 * math.pi,
          0.5 * math.pi,
          false,
        );
      } else {
        path.lineTo(left, bottom);
      }
    }

    void addTopLeftCorner() {
      if (rtlX > 0.001 && rtlY > 0.001) {
        path.arcTo(
          Rect.fromLTWH(left, top, 2 * rtlX, 2 * rtlY),
          1.0 * math.pi,
          0.5 * math.pi,
          false,
        );
      } else {
        path.lineTo(left, top);
      }
    }

    switch (origin) {
      case ByBorderOrigin.topCenter:
        path.moveTo(left + width / 2, top);
        path.lineTo(right - rtrX, top);
        addTopRightCorner();
        path.lineTo(right, bottom - rbrY);
        addBottomRightCorner();
        path.lineTo(left + rblX, bottom);
        addBottomLeftCorner();
        path.lineTo(left, top + rtlY);
        addTopLeftCorner();
        path.lineTo(left + width / 2, top);
        break;

      case ByBorderOrigin.topLeft:
        path.moveTo(left + rtlX, top);
        path.lineTo(right - rtrX, top);
        addTopRightCorner();
        path.lineTo(right, bottom - rbrY);
        addBottomRightCorner();
        path.lineTo(left + rblX, bottom);
        addBottomLeftCorner();
        path.lineTo(left, top + rtlY);
        addTopLeftCorner();
        break;

      case ByBorderOrigin.topRight:
        path.moveTo(right, top + rtrY);
        path.lineTo(right, bottom - rbrY);
        addBottomRightCorner();
        path.lineTo(left + rblX, bottom);
        addBottomLeftCorner();
        path.lineTo(left, top + rtlY);
        addTopLeftCorner();
        path.lineTo(right - rtrX, top);
        addTopRightCorner();
        break;

      case ByBorderOrigin.centerRight:
        path.moveTo(right, top + height / 2);
        path.lineTo(right, bottom - rbrY);
        addBottomRightCorner();
        path.lineTo(left + rblX, bottom);
        addBottomLeftCorner();
        path.lineTo(left, top + rtlY);
        addTopLeftCorner();
        path.lineTo(right - rtrX, top);
        addTopRightCorner();
        path.lineTo(right, top + height / 2);
        break;

      case ByBorderOrigin.bottomRight:
        path.moveTo(right - rbrX, bottom);
        path.lineTo(left + rblX, bottom);
        addBottomLeftCorner();
        path.lineTo(left, top + rtlY);
        addTopLeftCorner();
        path.lineTo(right - rtrX, top);
        addTopRightCorner();
        path.lineTo(right, bottom - rbrY);
        addBottomRightCorner();
        break;

      case ByBorderOrigin.bottomCenter:
        path.moveTo(left + width / 2, bottom);
        path.lineTo(left + rblX, bottom);
        addBottomLeftCorner();
        path.lineTo(left, top + rtlY);
        addTopLeftCorner();
        path.lineTo(right - rtrX, top);
        addTopRightCorner();
        path.lineTo(right, bottom - rbrY);
        addBottomRightCorner();
        path.lineTo(left + width / 2, bottom);
        break;

      case ByBorderOrigin.bottomLeft:
        path.moveTo(left, bottom - rblY);
        path.lineTo(left, top + rtlY);
        addTopLeftCorner();
        path.lineTo(right - rtrX, top);
        addTopRightCorner();
        path.lineTo(right, bottom - rbrY);
        addBottomRightCorner();
        path.lineTo(left + rblX, bottom);
        addBottomLeftCorner();
        break;

      case ByBorderOrigin.centerLeft:
        path.moveTo(left, top + height / 2);
        path.lineTo(left, top + rtlY);
        addTopLeftCorner();
        path.lineTo(right - rtrX, top);
        addTopRightCorner();
        path.lineTo(right, bottom - rbrY);
        addBottomRightCorner();
        path.lineTo(left + rblX, bottom);
        addBottomLeftCorner();
        path.lineTo(left, top + height / 2);
        break;
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant ByDynamicBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.config != config ||
        oldDelegate.borderRadius != borderRadius;
  }
}
