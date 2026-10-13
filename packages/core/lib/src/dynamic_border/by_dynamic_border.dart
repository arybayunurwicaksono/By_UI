import 'package:flutter/material.dart';
import 'by_dynamic_border_controller.dart';

/// Defines the perimeter starting point (Point A) for [ByDynamicBorder] pulse traversal.
enum ByBorderOrigin {
  /// Center of the top perimeter edge. Ideal default for modals, cards, and toasts.
  topCenter,

  /// Top-left corner just following the radius.
  topLeft,

  /// Top-right corner just following the radius.
  topRight,

  /// Center of the bottom perimeter edge.
  bottomCenter,

  /// Bottom-left corner.
  bottomLeft,

  /// Bottom-right corner.
  bottomRight,

  /// Center of the left perimeter edge.
  centerLeft,

  /// Center of the right perimeter edge.
  centerRight,
}

/// Encapsulates all configuration properties for a traveling pulse dynamic border.
///
/// Executes a 3-phase one-shot perimeter circuit:
/// - Phase 1: Slow emergence from origin with progressive fade-in.
/// - Phase 2: High-velocity transit around the rounded rectangle perimeter.
/// - Phase 3: Deceleration approaching origin with smooth dissipate to 0.0 opacity.
class ByDynamicBorder {
  /// Whether the dynamic pulse border is enabled. Defaults to `true`.
  final bool enabled;

  /// List of colors for the traveling gradient beam.
  ///
  /// If a single color is provided, renders a solid neon laser beam.
  final List<Color> colors;

  /// Optional custom gradient for the traveling beam, overriding [colors].
  final Gradient? gradient;

  /// Optional custom shadow color (independent from border colors/gradient).
  /// If null, defaults to a subtle dark ambient tint.
  final Color? shadowColor;

  /// Backward-compatibility alias for [shadowColor].
  Color? get glowColor => shadowColor;

  /// Stroke width of the primary pulse border in logical pixels.
  final double width;

  /// Total duration of one complete perimeter circuit.
  final Duration duration;

  /// Origin point (Point A) where the pulse emerges and returns.
  final ByBorderOrigin origin;

  /// Relative length of the primary border beam as a fraction of total perimeter (e.g. 0.28 = 28%).
  final double beamLength;

  /// Outer shadow blur radius in logical pixels. Defaults to `3.0px` (thin and crisp).
  final double shadowBlur;

  /// Backward-compatibility alias for [shadowBlur].
  double get glowBlur => shadowBlur;

  /// Stroke thickness of the outer shadow in logical pixels. Defaults to `2.0px`.
  final double shadowWidth;

  /// Relative length of the outer shadow along the perimeter.
  /// If null, automatically matches [beamLength].
  final double? shadowLength;

  /// Whether to automatically trigger the pulse animation on entrance/mount.
  final bool autoStart;

  /// Optional repeat count (1 = pulse once then disappear, N = loop N times, null = infinite).
  final int? repeatCount;

  /// Optional pause/rest duration between periodic pulse cycles.
  ///
  /// When provided (e.g. `Duration(seconds: 4)`), the pulse rests for this
  /// duration after completing each perimeter circuit before launching the next cycle.
  final Duration? periodicInterval;

  /// Buffer duration after pulse completes before sensor border begins easing in.
  /// Defaults to 300ms.
  final Duration sensorResumeDelay;

  /// Transition duration for the sensor border ease-in animation.
  /// Defaults to 400ms.
  final Duration sensorEntranceDuration;

  /// Easing curve used to ease in the sensor border after pulse completion.
  /// Defaults to [Curves.easeIn].
  final Curve sensorEntranceCurve;

  /// Optional callback invoked when the pulse finishes its circuit and disappears.
  final VoidCallback? onComplete;

  /// Optional external controller to imperatively trigger pulses (e.g. on card tap).
  final ByDynamicBorderController? controller;

  /// Creates a [ByDynamicBorder] configuration.
  const ByDynamicBorder({
    this.enabled = true,
    this.colors = const [Color(0xFF38BDF8), Color(0xFF6366F1)],
    this.gradient,
    Color? shadowColor,
    Color? glowColor,
    this.width = 2.0,
    this.duration = const Duration(milliseconds: 1400),
    this.origin = ByBorderOrigin.topCenter,
    this.beamLength = 0.28,
    double? shadowBlur,
    double? glowBlur,
    this.shadowWidth = 2.0,
    this.shadowLength,
    this.autoStart = true,
    this.repeatCount = 1,
    this.periodicInterval,
    this.sensorResumeDelay = const Duration(milliseconds: 300),
    this.sensorEntranceDuration = const Duration(milliseconds: 400),
    this.sensorEntranceCurve = Curves.easeIn,
    this.onComplete,
    this.controller,
  })  : shadowColor = shadowColor ?? glowColor,
        shadowBlur = shadowBlur ?? glowBlur ?? 3.0;

  /// Factory shorthand for a single-color solid pulse beam.
  factory ByDynamicBorder.solid({
    required Color color,
    Color? shadowColor,
    Color? glowColor,
    double width = 2.0,
    Duration duration = const Duration(milliseconds: 1400),
    ByBorderOrigin origin = ByBorderOrigin.topCenter,
    double beamLength = 0.28,
    double? shadowBlur,
    double? glowBlur,
    double shadowWidth = 2.0,
    double? shadowLength,
    bool autoStart = true,
    int? repeatCount = 1,
    Duration sensorResumeDelay = const Duration(milliseconds: 300),
    Duration sensorEntranceDuration = const Duration(milliseconds: 400),
    Curve sensorEntranceCurve = Curves.easeIn,
    VoidCallback? onComplete,
    ByDynamicBorderController? controller,
    Duration? periodicInterval,
  }) {
    return ByDynamicBorder(
      enabled: true,
      colors: [color],
      shadowColor: shadowColor ?? glowColor,
      width: width,
      duration: duration,
      origin: origin,
      beamLength: beamLength,
      shadowBlur: shadowBlur ?? glowBlur ?? 3.0,
      shadowWidth: shadowWidth,
      shadowLength: shadowLength,
      autoStart: autoStart,
      repeatCount: repeatCount,
      periodicInterval: periodicInterval,
      sensorResumeDelay: sensorResumeDelay,
      sensorEntranceDuration: sensorEntranceDuration,
      sensorEntranceCurve: sensorEntranceCurve,
      onComplete: onComplete,
      controller: controller,
    );
  }

  /// Factory shorthand for a gradient pulse beam.
  factory ByDynamicBorder.gradient({
    required Gradient gradient,
    Color? shadowColor,
    Color? glowColor,
    double width = 2.0,
    Duration duration = const Duration(milliseconds: 1400),
    ByBorderOrigin origin = ByBorderOrigin.topCenter,
    double beamLength = 0.28,
    double? shadowBlur,
    double? glowBlur,
    double shadowWidth = 2.0,
    double? shadowLength,
    bool autoStart = true,
    int? repeatCount = 1,
    Duration sensorResumeDelay = const Duration(milliseconds: 300),
    Duration sensorEntranceDuration = const Duration(milliseconds: 400),
    Curve sensorEntranceCurve = Curves.easeIn,
    VoidCallback? onComplete,
    ByDynamicBorderController? controller,
    Duration? periodicInterval,
  }) {
    return ByDynamicBorder(
      enabled: true,
      colors: gradient.colors,
      gradient: gradient,
      shadowColor: shadowColor ?? glowColor,
      width: width,
      duration: duration,
      origin: origin,
      beamLength: beamLength,
      shadowBlur: shadowBlur ?? glowBlur ?? 3.0,
      shadowWidth: shadowWidth,
      shadowLength: shadowLength,
      autoStart: autoStart,
      repeatCount: repeatCount,
      periodicInterval: periodicInterval,
      sensorResumeDelay: sensorResumeDelay,
      sensorEntranceDuration: sensorEntranceDuration,
      sensorEntranceCurve: sensorEntranceCurve,
      onComplete: onComplete,
      controller: controller,
    );
  }

  /// Factory shorthand for a classic single 360-degree pulse loop.
  factory ByDynamicBorder.pulse({
    List<Color> colors = const [Color(0xFF38BDF8), Color(0xFF6366F1)],
    Gradient? gradient,
    Color? shadowColor,
    Color? glowColor,
    double width = 2.0,
    Duration duration = const Duration(milliseconds: 1400),
    ByBorderOrigin origin = ByBorderOrigin.topCenter,
    double beamLength = 0.28,
    double? shadowBlur,
    double? glowBlur,
    double shadowWidth = 2.0,
    double? shadowLength,
    bool autoStart = true,
    int? repeatCount = 1,
    Duration sensorResumeDelay = const Duration(milliseconds: 300),
    Duration sensorEntranceDuration = const Duration(milliseconds: 400),
    Curve sensorEntranceCurve = Curves.easeIn,
    VoidCallback? onComplete,
    ByDynamicBorderController? controller,
    Duration? periodicInterval,
  }) {
    return ByDynamicBorder(
      enabled: true,
      colors: colors,
      gradient: gradient,
      shadowColor: shadowColor ?? glowColor,
      width: width,
      duration: duration,
      origin: origin,
      beamLength: beamLength,
      shadowBlur: shadowBlur ?? glowBlur ?? 3.0,
      shadowWidth: shadowWidth,
      shadowLength: shadowLength,
      autoStart: autoStart,
      repeatCount: repeatCount,
      periodicInterval: periodicInterval,
      sensorResumeDelay: sensorResumeDelay,
      sensorEntranceDuration: sensorEntranceDuration,
      sensorEntranceCurve: sensorEntranceCurve,
      onComplete: onComplete,
      controller: controller,
    );
  }

  /// Factory shorthand for an infinitely repeating periodic pulse border.
  factory ByDynamicBorder.periodic({
    required Duration interval,
    List<Color> colors = const [Color(0xFF38BDF8), Color(0xFF6366F1)],
    Gradient? gradient,
    Color? shadowColor,
    Color? glowColor,
    double width = 2.0,
    Duration duration = const Duration(milliseconds: 1400),
    ByBorderOrigin origin = ByBorderOrigin.topLeft,
    double beamLength = 0.28,
    double? shadowBlur,
    double? glowBlur,
    double shadowWidth = 2.0,
    double? shadowLength,
    bool autoStart = true,
    int? repeatCount,
    ByDynamicBorderController? controller,
  }) {
    return ByDynamicBorder(
      enabled: true,
      colors: colors,
      gradient: gradient,
      shadowColor: shadowColor ?? glowColor,
      width: width,
      duration: duration,
      origin: origin,
      beamLength: beamLength,
      shadowBlur: shadowBlur ?? glowBlur ?? 3.0,
      shadowWidth: shadowWidth,
      shadowLength: shadowLength,
      autoStart: autoStart,
      repeatCount: repeatCount,
      periodicInterval: interval,
      controller: controller,
    );
  }

  /// Creates a copy of this [ByDynamicBorder] with specified overrides.
  ByDynamicBorder copyWith({
    bool? enabled,
    List<Color>? colors,
    Gradient? gradient,
    Color? shadowColor,
    Color? glowColor,
    double? width,
    Duration? duration,
    ByBorderOrigin? origin,
    double? beamLength,
    double? shadowBlur,
    double? glowBlur,
    double? shadowWidth,
    double? shadowLength,
    bool? autoStart,
    Object? repeatCount = _borderSentinel,
    Object? periodicInterval = _borderSentinel,
    Duration? sensorResumeDelay,
    Duration? sensorEntranceDuration,
    Curve? sensorEntranceCurve,
    VoidCallback? onComplete,
    ByDynamicBorderController? controller,
  }) {
    return ByDynamicBorder(
      enabled: enabled ?? this.enabled,
      colors: colors ?? this.colors,
      gradient: gradient ?? this.gradient,
      shadowColor: shadowColor ?? glowColor ?? this.shadowColor,
      width: width ?? this.width,
      duration: duration ?? this.duration,
      origin: origin ?? this.origin,
      beamLength: beamLength ?? this.beamLength,
      shadowBlur: shadowBlur ?? glowBlur ?? this.shadowBlur,
      shadowWidth: shadowWidth ?? this.shadowWidth,
      shadowLength: shadowLength ?? this.shadowLength,
      autoStart: autoStart ?? this.autoStart,
      repeatCount: identical(repeatCount, _borderSentinel)
          ? this.repeatCount
          : (repeatCount as int?),
      periodicInterval: identical(periodicInterval, _borderSentinel)
          ? this.periodicInterval
          : (periodicInterval as Duration?),
      sensorResumeDelay: sensorResumeDelay ?? this.sensorResumeDelay,
      sensorEntranceDuration:
          sensorEntranceDuration ?? this.sensorEntranceDuration,
      sensorEntranceCurve: sensorEntranceCurve ?? this.sensorEntranceCurve,
      onComplete: onComplete ?? this.onComplete,
      controller: controller ?? this.controller,
    );
  }
}

const Object _borderSentinel = Object();
