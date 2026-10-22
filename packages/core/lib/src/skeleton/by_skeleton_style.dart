import 'package:flutter/material.dart';

/// Visual presentation variants for skeleton bone structures.
enum BySkeletonVariant {
  /// Standard solid slate bone placeholders with smooth gradient shimmer sweep.
  solid,

  /// Semi-translucent glassmorphic bones with subtle blueprint scanlines and glow.
  glassmorphic,
}

/// Direction of the sweeping animated light highlight in [ByAutoShimmer] and [ByBone].
enum ByShimmerDirection {
  /// Left to right (standard default).
  ltr,

  /// Right to left (ideal for RTL text layouts or reverse effects).
  rtl,

  /// Top to bottom.
  ttb,

  /// Bottom to top.
  btt,

  /// Diagonal from top-left to bottom-right.
  diagonal,
}

/// Theming and styling configuration tokens for [ByAutoShimmer] and [ByBone].
class BySkeletonStyle {
  /// The visual skeleton variant.
  final BySkeletonVariant variant;

  /// Direction of the traveling shimmer wave sweep.
  final ByShimmerDirection direction;

  /// Base background color of the bone geometry before the shimmer sweep.
  final Color baseColor;

  /// Highlight color at the center of the traveling shimmer wave.
  final Color highlightColor;

  /// Default border radius applied to rectangular bones.
  final BorderRadius borderRadius;

  /// Opacity multiplier for the holographic blueprint scanlines in [BySkeletonVariant.glassmorphic].
  final double scanlineOpacity;

  /// Duration of one complete traveling shimmer wave sweep.
  final Duration shimmerDuration;

  /// Optional border stroke color applied to bones.
  final Color? borderColor;

  /// Optional border stroke width applied to bones.
  final double? borderWidth;

  /// Ratio multiplier for the shimmer sweep width relative to bone width.
  final double shimmerWidthFactor;

  /// Vertical spacing between holographic scanlines in [BySkeletonVariant.glassmorphic].
  final double scanlineSpacing;

  /// Optional custom gradient for the traveling shimmer sweep wave.
  final LinearGradient? shimmerGradient;

  /// Creates a [BySkeletonStyle] configuration.
  const BySkeletonStyle({
    this.variant = BySkeletonVariant.solid,
    this.direction = ByShimmerDirection.ltr,
    this.baseColor = const Color(0xFF1E293B),
    this.highlightColor = const Color(0xFF334155),
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.scanlineOpacity = 0.15,
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.borderColor,
    this.borderWidth,
    this.shimmerWidthFactor = 1.5,
    this.scanlineSpacing = 5.0,
    this.shimmerGradient,
  });

  /// Dark slate theme default, optimized for dark mode.
  static const BySkeletonStyle darkSlate = BySkeletonStyle(
    variant: BySkeletonVariant.solid,
    baseColor: Color(0xFF1E293B),
    highlightColor: Color(0xFF334155),
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
  );

  /// Clean light theme default, optimized for high-contrast light surfaces.
  static const BySkeletonStyle lightSlate = BySkeletonStyle(
    variant: BySkeletonVariant.solid,
    baseColor: Color(0xFFE2E8F0),
    highlightColor: Color(0xFFF8FAFC),
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
  );

  /// Futuristic holographic cyber/blueprint theme.
  static const BySkeletonStyle cyberGlass = BySkeletonStyle(
    variant: BySkeletonVariant.glassmorphic,
    baseColor: Color(0x1F6366F1),
    highlightColor: Color(0x4038BDF8),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    scanlineOpacity: 0.25,
    borderWidth: 1.0,
  );

  /// Resolves the effective style according to the ambient theme brightness.
  static BySkeletonStyle resolve(BuildContext context,
      {BySkeletonStyle? custom}) {
    if (custom != null) return custom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkSlate : lightSlate;
  }

  /// Creates a copy of this style with selected fields replaced.
  BySkeletonStyle copyWith({
    BySkeletonVariant? variant,
    ByShimmerDirection? direction,
    Color? baseColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
    double? scanlineOpacity,
    Duration? shimmerDuration,
    Color? borderColor,
    double? borderWidth,
    double? shimmerWidthFactor,
    double? scanlineSpacing,
    LinearGradient? shimmerGradient,
  }) {
    return BySkeletonStyle(
      variant: variant ?? this.variant,
      direction: direction ?? this.direction,
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      borderRadius: borderRadius ?? this.borderRadius,
      scanlineOpacity: scanlineOpacity ?? this.scanlineOpacity,
      shimmerDuration: shimmerDuration ?? this.shimmerDuration,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shimmerWidthFactor: shimmerWidthFactor ?? this.shimmerWidthFactor,
      scanlineSpacing: scanlineSpacing ?? this.scanlineSpacing,
      shimmerGradient: shimmerGradient ?? this.shimmerGradient,
    );
  }
}
