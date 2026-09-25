import 'package:flutter/material.dart';

/// Default constants, sensible presets, and styling helpers for [ByCard].
class ByCardDefaults {
  const ByCardDefaults._();

  /// Default border radius applied to [ByCard].
  static const BorderRadius borderRadius =
      BorderRadius.all(Radius.circular(16));

  /// Default border width for cards.
  static const double borderWidth = 1.2;

  /// Default blur radius for directional gradient shadow/glow.
  static const double shadowBlur = 18.0;

  /// Default maximum distance the shadow offset will travel during tilt.
  static const double maxShadowOffset = 10.0;

  /// Default opacity multiplier for the inner glow/sheen effect.
  static const double innerGlowOpacity = 1.0;

  /// Default transition animation duration when card properties change.
  static const Duration animationDuration = Duration(milliseconds: 300);

  /// Default transition animation curve.
  static const Curve animationCurve = Curves.easeInOutCubic;

  /// Default gradient border highlight for light and dark environments.
  static const Gradient defaultBorderGradient = SweepGradient(
    colors: [
      Color(0xFF6366F1), // Indigo 500
      Color(0xFF38BDF8), // Sky 400
      Color(0xFF8B5CF6), // Violet 500
      Colors.transparent,
      Colors.transparent,
      Color(0xFF6366F1),
    ],
    stops: [0.0, 0.25, 0.5, 0.65, 0.85, 1.0],
  );

  /// Default directional glow gradient matching the border illumination.
  static Gradient defaultShadowGradient(Color accentColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        accentColor.withValues(alpha: 0.35),
        accentColor.withValues(alpha: 0.0),
      ],
    );
  }
}
