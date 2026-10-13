import 'package:flutter/material.dart';
import 'by_button_enums.dart';
import 'by_button_style.dart';

/// Sensible default geometries, durations, curves, and styles for [ByButton].
abstract final class ByButtonDefaults {
  /// Default height for a given [ByButtonSize].
  static double heightFor(ByButtonSize size) {
    return switch (size) {
      ByButtonSize.small => 36.0,
      ByButtonSize.medium => 48.0,
      ByButtonSize.large => 56.0,
    };
  }

  /// Default corner radius for a given [ByButtonSize].
  static BorderRadius borderRadiusFor(ByButtonSize size) {
    return switch (size) {
      ByButtonSize.small => BorderRadius.circular(8.0),
      ByButtonSize.medium => BorderRadius.circular(12.0),
      ByButtonSize.large => BorderRadius.circular(14.0),
    };
  }

  /// Default padding for a given [ByButtonSize].
  static EdgeInsetsGeometry paddingFor(ByButtonSize size) {
    return switch (size) {
      ByButtonSize.small => const EdgeInsets.symmetric(horizontal: 14.0),
      ByButtonSize.medium => const EdgeInsets.symmetric(horizontal: 20.0),
      ByButtonSize.large => const EdgeInsets.symmetric(horizontal: 26.0),
    };
  }

  /// Default icon size for a given [ByButtonSize].
  static double iconSizeFor(ByButtonSize size) {
    return switch (size) {
      ByButtonSize.small => 16.0,
      ByButtonSize.medium => 18.0,
      ByButtonSize.large => 22.0,
    };
  }

  /// Default typography style for a given [ByButtonSize].
  static TextStyle textStyleFor(ByButtonSize size) {
    return switch (size) {
      ByButtonSize.small => const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ByButtonSize.medium => const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
      ByButtonSize.large => const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
    };
  }

  /// Default button surface color (Vibrant Cyan Accent).
  static const Color defaultButtonColor = Color(0xFF06B6D4);

  /// Pulse colors when transitioning to enabled (vibrant primary gradient).
  static const List<Color> enableTransitionPulseColors = [
    Color(0xFF38BDF8), // Sky Cyan
    Color(0xFF6366F1), // Indigo
    Color(0xFFA855F7), // Neon Purple
  ];

  /// Pulse colors when transitioning to disabled (muted slate gray).
  static const List<Color> disableTransitionPulseColors = [
    Color(0xFF94A3B8), // Slate 400
    Color(0xFF64748B), // Slate 500
    Color(0xFF475569), // Slate 600
  ];

  /// Default traveling beam colors for loading circular pulse spinner.
  static const List<Color> defaultLoadingPulseColors = [
    Color(0xFF38BDF8), // Sky Cyan
    Color(0xFF6366F1), // Indigo
    Color(0xFFA855F7), // Neon Purple
  ];

  /// Default unified border and pulse stroke width in logical pixels.
  static const double defaultBorderWidth = 2.5;

  /// Default pulse stroke width in logical pixels (matches [defaultBorderWidth]).
  static const double defaultPulseWidth = defaultBorderWidth;

  /// Default pulse outer shadow blur in logical pixels.
  static const double defaultPulseShadowBlur = 10.0;

  /// Default pulse outer shadow width in logical pixels.
  static const double defaultPulseShadowWidth = 4.0;

  /// Resolves the comprehensive default style for the specified variant, size, and brightness.
  static ByButtonStyle resolve({
    required BuildContext context,
    required ByButtonVariant variant,
    required ByButtonSize size,
    ByButtonStyle? customStyle,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // High-contrast defaults: White for dark mode, Black for light mode
    final contrastBorder = isDark ? Colors.white : Colors.black;
    final contrastFg = isDark ? Colors.white : Colors.black;

    // Disabled colors
    final disabledBg = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.6)
        : const Color(0xFFE2E8F0);
    final disabledFg =
        isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
    final disabledBorder = isDark
        ? const Color(0xFF334155).withValues(alpha: 0.4)
        : const Color(0xFFCBD5E1);

    ByButtonStyle base;

    switch (variant) {
      case ByButtonVariant.filled:
        base = ByButtonStyle(
          backgroundColor: defaultButtonColor,
          foregroundColor: contrastFg,
          borderColor: Colors.transparent,
          borderWidth: 0.0,
          shadows: [
            BoxShadow(
              color: defaultButtonColor.withValues(alpha: isDark ? 0.40 : 0.28),
              blurRadius: 14.0,
              offset: const Offset(0, 4),
            ),
          ],
          disabledBackgroundColor: disabledBg,
          disabledForegroundColor: disabledFg,
          disabledBorderColor: Colors.transparent,
          disabledBorderWidth: 0.0,
        );

      case ByButtonVariant.gradient:
        final gradientColors = isDark
            ? const [Color(0xFF06B6D4), Color(0xFF6366F1)]
            : const [Color(0xFF0891B2), Color(0xFF4F46E5)];
        base = ByButtonStyle(
          backgroundGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          foregroundColor: Colors.white,
          borderColor: Colors.transparent,
          borderWidth: 0.0,
          shadows: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.4),
              blurRadius: 16.0,
              offset: const Offset(0, 4),
            ),
          ],
          disabledBackgroundColor: disabledBg,
          disabledForegroundColor: disabledFg,
          disabledBorderColor: Colors.transparent,
          disabledBorderWidth: 0.0,
        );

      case ByButtonVariant.outline:
        base = ByButtonStyle(
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.02),
          foregroundColor: contrastFg,
          borderColor: contrastBorder,
          borderWidth: defaultBorderWidth,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: disabledFg,
          disabledBorderColor: disabledBorder,
          disabledBorderWidth: 1.0,
        );

      case ByButtonVariant.ghost:
        base = ByButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor:
              isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
          borderColor: Colors.transparent,
          borderWidth: 0.0,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: disabledFg,
          disabledBorderColor: Colors.transparent,
          disabledBorderWidth: 0.0,
        );
    }

    final defaultRadius = borderRadiusFor(size);
    final defaultPadding = paddingFor(size);
    final defaultIconSize = iconSizeFor(size);

    final effectiveGradient = customStyle?.backgroundColor != null &&
            customStyle?.backgroundGradient == null
        ? null
        : (customStyle?.backgroundGradient ?? base.backgroundGradient);

    return ByButtonStyle(
      backgroundColor: customStyle?.backgroundColor ?? base.backgroundColor,
      backgroundGradient: effectiveGradient,
      foregroundColor: customStyle?.foregroundColor ?? base.foregroundColor,
      borderColor: customStyle?.borderColor ?? base.borderColor,
      borderWidth: customStyle?.borderWidth ?? base.borderWidth,
      shadows: customStyle?.shadows ?? base.shadows,
      disabledBackgroundColor:
          customStyle?.disabledBackgroundColor ?? base.disabledBackgroundColor,
      disabledBackgroundGradient: customStyle?.disabledBackgroundGradient ??
          base.disabledBackgroundGradient,
      disabledForegroundColor:
          customStyle?.disabledForegroundColor ?? base.disabledForegroundColor,
      disabledBorderColor:
          customStyle?.disabledBorderColor ?? base.disabledBorderColor,
      disabledBorderWidth:
          customStyle?.disabledBorderWidth ?? base.disabledBorderWidth,
      disabledShadows: customStyle?.disabledShadows ?? base.disabledShadows,
      borderRadius: customStyle?.borderRadius ?? defaultRadius,
      padding: customStyle?.padding ?? defaultPadding,
      iconSize: customStyle?.iconSize ?? defaultIconSize,
      iconColor: customStyle?.iconColor ??
          customStyle?.foregroundColor ??
          base.foregroundColor,
      disabledIconColor:
          customStyle?.disabledIconColor ?? base.disabledForegroundColor,
      enabledCursor: customStyle?.enabledCursor ?? SystemMouseCursors.click,
      disabledCursor:
          customStyle?.disabledCursor ?? SystemMouseCursors.forbidden,
    );
  }
}
