import 'package:flutter/material.dart';

/// Comprehensive styling configuration for [ByButton] across enabled and disabled states.
@immutable
class ByButtonStyle {
  // --- Enabled Visual Styling ---
  /// Background color when enabled. If [backgroundGradient] is provided, gradient takes precedence.
  final Color? backgroundColor;

  /// Background gradient when enabled. Overrides [backgroundColor].
  final Gradient? backgroundGradient;

  /// Text and content foreground color when enabled.
  final Color? foregroundColor;

  /// Perimeter border stroke color when enabled.
  final Color? borderColor;

  /// Perimeter border stroke width when enabled.
  final double? borderWidth;

  /// Perimeter border stroke width during circular loading state.
  /// If null, falls back to [borderWidth] when greater than 0.0, or default 2.5px.
  final double? loadingBorderWidth;

  /// Elevation shadows when enabled.
  final List<BoxShadow>? shadows;

  // --- Disabled Visual Styling ---
  /// Background color when disabled.
  final Color? disabledBackgroundColor;

  /// Background gradient when disabled. Overrides [disabledBackgroundColor].
  final Gradient? disabledBackgroundGradient;

  /// Text and content foreground color when disabled.
  final Color? disabledForegroundColor;

  /// Perimeter border stroke color when disabled.
  final Color? disabledBorderColor;

  /// Perimeter border stroke width when disabled.
  final double? disabledBorderWidth;

  /// Elevation shadows when disabled.
  final List<BoxShadow>? disabledShadows;

  // --- Geometry & Feedback ---
  /// Corner radius of the button in normal (unmorphed) state.
  final BorderRadius? borderRadius;

  /// Internal padding enclosing prefix, child, and suffix.
  final EdgeInsetsGeometry? padding;

  /// Icon size for prefix, suffix, and state icons.
  final double? iconSize;

  /// Icon tint color when enabled.
  final Color? iconColor;

  /// Icon tint color when disabled.
  final Color? disabledIconColor;

  /// Mouse cursor when enabled. Defaults to [SystemMouseCursors.click].
  final MouseCursor? enabledCursor;

  /// Mouse cursor when disabled. Defaults to [SystemMouseCursors.forbidden].
  final MouseCursor? disabledCursor;

  /// Creates a [ByButtonStyle].
  const ByButtonStyle({
    this.backgroundColor,
    this.backgroundGradient,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.loadingBorderWidth,
    this.shadows,
    this.disabledBackgroundColor,
    this.disabledBackgroundGradient,
    this.disabledForegroundColor,
    this.disabledBorderColor,
    this.disabledBorderWidth,
    this.disabledShadows,
    this.borderRadius,
    this.padding,
    this.iconSize,
    this.iconColor,
    this.disabledIconColor,
    this.enabledCursor,
    this.disabledCursor,
  });

  /// Creates a copy of this style with the given fields replaced.
  ByButtonStyle copyWith({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    double? loadingBorderWidth,
    List<BoxShadow>? shadows,
    Color? disabledBackgroundColor,
    Gradient? disabledBackgroundGradient,
    Color? disabledForegroundColor,
    Color? disabledBorderColor,
    double? disabledBorderWidth,
    List<BoxShadow>? disabledShadows,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    double? iconSize,
    Color? iconColor,
    Color? disabledIconColor,
    MouseCursor? enabledCursor,
    MouseCursor? disabledCursor,
  }) {
    return ByButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      loadingBorderWidth: loadingBorderWidth ?? this.loadingBorderWidth,
      shadows: shadows ?? this.shadows,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      disabledBackgroundGradient:
          disabledBackgroundGradient ?? this.disabledBackgroundGradient,
      disabledForegroundColor:
          disabledForegroundColor ?? this.disabledForegroundColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      disabledBorderWidth: disabledBorderWidth ?? this.disabledBorderWidth,
      disabledShadows: disabledShadows ?? this.disabledShadows,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      enabledCursor: enabledCursor ?? this.enabledCursor,
      disabledCursor: disabledCursor ?? this.disabledCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ByButtonStyle &&
        other.backgroundColor == backgroundColor &&
        other.backgroundGradient == backgroundGradient &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.loadingBorderWidth == loadingBorderWidth &&
        other.disabledBackgroundColor == disabledBackgroundColor &&
        other.disabledBackgroundGradient == disabledBackgroundGradient &&
        other.disabledForegroundColor == disabledForegroundColor &&
        other.disabledBorderColor == disabledBorderColor &&
        other.disabledBorderWidth == disabledBorderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.iconSize == iconSize &&
        other.iconColor == iconColor &&
        other.disabledIconColor == disabledIconColor &&
        other.enabledCursor == enabledCursor &&
        other.disabledCursor == disabledCursor;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        backgroundGradient,
        foregroundColor,
        borderColor,
        borderWidth,
        loadingBorderWidth,
        disabledBackgroundColor,
        disabledBackgroundGradient,
        disabledForegroundColor,
        disabledBorderColor,
        disabledBorderWidth,
        borderRadius,
        padding,
        iconSize,
        iconColor,
        disabledIconColor,
        enabledCursor,
        disabledCursor,
      );
}
