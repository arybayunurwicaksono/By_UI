import 'package:flutter/material.dart';
import 'by_card_enums.dart';

/// Custom painter rendering the animated body, dynamic directional gradient border,
/// and spatial gradient shadow for [ByCard].
class ByCardPainter extends CustomPainter {
  /// Visual variant mode of the card.
  final ByCardVariant variant;

  /// Current normalized tilt coordinate (-1.0 to 1.0).
  final Offset tilt;

  /// Solid background fill color.
  final Color backgroundColor;

  /// Corner radius of the card.
  final BorderRadius borderRadius;

  /// Thickness of the outer border.
  final double borderWidth;

  /// Solid color for standard border.
  final Color? borderColor;

  /// Gradient specification for the border stroke.
  final Gradient? borderGradient;

  /// Standard box shadows for [ByCardVariant.normal].
  final List<BoxShadow>? shadows;

  /// Directional gradient specification for ambient glow / shadow.
  final Gradient? shadowGradient;

  /// Radius for blur effect on the directional shadow.
  final double shadowBlur;

  /// Maximum distance the directional shadow shifts with tilt.
  final double maxShadowOffset;

  /// Whether to render dynamic specular inner glow inside the card.
  final bool enableInnerGlow;

  /// Custom opacity multiplier for the inner glow.
  final double? innerGlowOpacity;

  /// Custom blur radius for the inner glow. Defaults to [shadowBlur] if omitted.
  final double? innerGlowBlur;

  /// Creates a [ByCardPainter].
  ByCardPainter({
    required this.variant,
    required this.tilt,
    required this.backgroundColor,
    required this.borderRadius,
    required this.borderWidth,
    this.borderColor,
    this.borderGradient,
    this.shadows,
    this.shadowGradient,
    this.shadowBlur = 18.0,
    this.maxShadowOffset = 10.0,
    this.enableInnerGlow = false,
    this.innerGlowOpacity,
    this.innerGlowBlur,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    // 1. Render Shadow Layer
    _paintShadow(canvas, rrect, rect);

    // 2. Render Card Background Fill
    final Paint bodyPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = backgroundColor;
    canvas.drawRRect(rrect, bodyPaint);

    // 2.5. Render Dynamic Specular Inner Glow / Sheen
    if (enableInnerGlow && variant != ByCardVariant.normal) {
      _paintInnerGlow(canvas, rrect, rect);
    }

    // 3. Render Border Layer
    if (borderWidth > 0) {
      _paintBorder(canvas, rrect, rect);
    }
  }

  void _paintShadow(Canvas canvas, RRect rrect, Rect rect) {
    if (variant == ByCardVariant.normal) {
      // Paint standard BoxShadows if provided
      if (shadows != null && shadows!.isNotEmpty) {
        for (final BoxShadow shadow in shadows!) {
          final Paint shadowPaint = shadow.toPaint();
          final RRect shadowRRect =
              rrect.shift(shadow.offset).inflate(shadow.spreadRadius);
          canvas.drawRRect(shadowRRect, shadowPaint);
        }
      }
      return;
    }

    // Directional Spatial Glow for Gradient & DynamicSensor modes
    if (shadowBlur <= 0) return;

    final double magnitude = tilt.distance.clamp(0.0, 1.0);
    final Offset shadowOffset = magnitude < 0.08
        ? Offset.zero
        : Offset(tilt.dx * maxShadowOffset, tilt.dy * maxShadowOffset);

    final RRect shadowRRect = rrect.shift(shadowOffset);

    final Paint glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

    // Extract colors for fallback or dynamic glow
    List<Color> shadowColors = const [
      Color(0xFF6366F1),
      Color(0xFF38BDF8),
    ];
    if (shadowGradient != null) {
      final nonTransparent =
          shadowGradient!.colors.where((c) => c.a > 0.05).toList();
      if (nonTransparent.isNotEmpty) {
        shadowColors = nonTransparent;
      } else {
        shadowColors = shadowGradient!.colors;
      }
    }
    final Color sColorA = shadowColors.first;
    final Color sColorB = shadowColors.length > 1 ? shadowColors.last : sColorA;

    if (magnitude < 0.08) {
      // Centered balanced ambient glow when flat on table or neutral
      final Gradient fallbackGlow = RadialGradient(
        center: Alignment.center,
        radius: 1.1,
        colors: [
          sColorA.withValues(alpha: 0.35),
          sColorB.withValues(alpha: 0.22),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      );
      glowPaint.shader = fallbackGlow.createShader(shadowRRect.outerRect);
    } else {
      final double dirX = tilt.dx / magnitude;
      final double dirY = tilt.dy / magnitude;

      if (shadowGradient is LinearGradient) {
        glowPaint.shader = LinearGradient(
          begin: Alignment(-dirX, -dirY),
          end: Alignment(dirX, dirY),
          colors: [
            Colors.transparent,
            sColorA.withValues(alpha: 0.25 * magnitude),
            sColorB.withValues(alpha: 0.40 * magnitude),
          ],
          stops: const [0.0, 0.50, 1.0],
        ).createShader(shadowRRect.outerRect);
      } else {
        // Dynamic Radial Gradient shifted along tilt vector
        glowPaint.shader = RadialGradient(
          center: Alignment(dirX * 0.75, dirY * 0.75),
          radius: 1.2,
          colors: [
            sColorA.withValues(alpha: 0.35 * magnitude),
            sColorB.withValues(alpha: 0.20 * magnitude),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(shadowRRect.outerRect);
      }
    }

    canvas.drawRRect(shadowRRect, glowPaint);
  }

  void _paintBorder(Canvas canvas, RRect rrect, Rect rect) {
    final RRect borderRRect = rrect.deflate(borderWidth / 2);
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    if (variant == ByCardVariant.normal) {
      if (borderColor != null && borderColor!.a > 0) {
        borderPaint.color = borderColor!;
        canvas.drawRRect(borderRRect, borderPaint);
      }
      return;
    }

    if (variant == ByCardVariant.dynamicSensor) {
      // 1. Resolve colors from borderGradient or fall back to high-tech defaults
      List<Color> resolvedColors = const [
        Color(0xFF38BDF8), // Sky Cyan
        Color(0xFF6366F1), // Indigo
      ];

      if (borderGradient != null) {
        final List<Color> nonTransparent =
            borderGradient!.colors.where((c) => c.a > 0.05).toList();
        if (nonTransparent.isNotEmpty) {
          resolvedColors = nonTransparent;
        } else {
          resolvedColors = borderGradient!.colors;
        }
      }

      final Color colorA = resolvedColors.first;
      final Color colorB =
          resolvedColors.length > 1 ? resolvedColors.last : colorA;

      final double magnitude = tilt.distance.clamp(0.0, 1.0);

      if (magnitude < 0.08) {
        // Table / neutral pose: full gradient across the entire border
        if (borderGradient is LinearGradient) {
          final linear = borderGradient as LinearGradient;
          borderPaint.shader = LinearGradient(
            begin: linear.begin,
            end: linear.end,
            colors: [colorA, colorB],
            stops: linear.stops,
            tileMode: linear.tileMode,
          ).createShader(borderRRect.outerRect);
        } else {
          borderPaint.shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorA, colorB],
          ).createShader(borderRRect.outerRect);
        }
      } else {
        // Physical directional lighting:
        // Project a direct linear gradient across the card in the direction of the tilt vector.
        // begin is at the opposite side (shadow), end is at the tilt side (full bright highlight).
        final double dirX = tilt.dx / magnitude;
        final double dirY = tilt.dy / magnitude;

        // When magnitude is small (0.08 to 0.40), the opposite side smoothly dims from full color to transparent
        final double oppositeAlpha =
            (1.0 - ((magnitude - 0.08) / 0.32)).clamp(0.0, 1.0);
        final double midStop = (0.50 - 0.15 * magnitude).clamp(0.25, 0.50);
        final double highlightStop =
            (0.80 - 0.10 * magnitude).clamp(0.60, 0.85);

        borderPaint.shader = LinearGradient(
          begin: Alignment(-dirX, -dirY),
          end: Alignment(dirX, dirY),
          colors: [
            colorA.withValues(alpha: oppositeAlpha),
            colorA.withValues(
                alpha: oppositeAlpha > 0.08 ? oppositeAlpha : 0.08),
            colorA,
            colorB,
          ],
          stops: [0.0, midStop, highlightStop, 1.0],
        ).createShader(borderRRect.outerRect);
      }
    } else {
      // Static gradient mode
      if (borderGradient != null) {
        borderPaint.shader =
            borderGradient!.createShader(borderRRect.outerRect);
      } else {
        const Gradient staticGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF38BDF8),
          ],
        );
        borderPaint.shader = staticGradient.createShader(borderRRect.outerRect);
      }
    }

    canvas.drawRRect(borderRRect, borderPaint);
  }

  void _paintInnerGlow(Canvas canvas, RRect rrect, Rect rect) {
    final double blur = innerGlowBlur ?? shadowBlur;
    if (blur <= 0) return;

    final double opacity = (innerGlowOpacity ?? 1.0).clamp(0.0, 1.0);
    if (opacity <= 0) return;

    // Resolve sheen colors: prefer shadowGradient, fallback to borderGradient, then defaults
    List<Color> sheenColors = const [
      Color(0xFF6366F1),
      Color(0xFF38BDF8),
    ];
    if (shadowGradient != null) {
      final nonTransparent =
          shadowGradient!.colors.where((c) => c.a > 0.05).toList();
      if (nonTransparent.isNotEmpty) {
        sheenColors = nonTransparent;
      } else {
        sheenColors = shadowGradient!.colors;
      }
    } else if (borderGradient != null) {
      final nonTransparent =
          borderGradient!.colors.where((c) => c.a > 0.05).toList();
      if (nonTransparent.isNotEmpty) {
        sheenColors = nonTransparent;
      } else {
        sheenColors = borderGradient!.colors;
      }
    }

    final Color sColorA = sheenColors.first;
    final Color sColorB = sheenColors.length > 1 ? sheenColors.last : sColorA;

    final double magnitude = tilt.distance.clamp(0.0, 1.0);
    final Offset sheenOffset = magnitude < 0.08
        ? Offset.zero
        : Offset(tilt.dx * maxShadowOffset, tilt.dy * maxShadowOffset);

    final RRect sheenRRect = rrect.shift(sheenOffset);

    final Paint sheenPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    if (magnitude < 0.08) {
      // Balanced even ambient inner glow across the entire card when neutral
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
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
      }

      final Gradient fallbackGlow = LinearGradient(
        begin: begin,
        end: end,
        colors: [
          sColorA.withValues(alpha: 0.22 * opacity),
          sColorB.withValues(alpha: 0.18 * opacity),
        ],
      );
      sheenPaint.shader = fallbackGlow.createShader(sheenRRect.outerRect);
    } else {
      final double dirX = tilt.dx / magnitude;
      final double dirY = tilt.dy / magnitude;

      sheenPaint.shader = LinearGradient(
        begin: Alignment(-dirX, -dirY),
        end: Alignment(dirX, dirY),
        colors: [
          Colors.transparent,
          sColorA.withValues(alpha: 0.25 * magnitude * opacity),
          sColorB.withValues(alpha: 0.40 * magnitude * opacity),
        ],
        stops: const [0.0, 0.50, 1.0],
      ).createShader(sheenRRect.outerRect);
    }

    // Clip to card boundary so the inner sheen stays cleanly within the layout
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRRect(sheenRRect, sheenPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ByCardPainter oldDelegate) {
    return oldDelegate.variant != variant ||
        oldDelegate.tilt != tilt ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderGradient != borderGradient ||
        oldDelegate.shadows != shadows ||
        oldDelegate.shadowGradient != shadowGradient ||
        oldDelegate.shadowBlur != shadowBlur ||
        oldDelegate.maxShadowOffset != maxShadowOffset ||
        oldDelegate.enableInnerGlow != enableInnerGlow ||
        oldDelegate.innerGlowOpacity != innerGlowOpacity ||
        oldDelegate.innerGlowBlur != innerGlowBlur;
  }
}
