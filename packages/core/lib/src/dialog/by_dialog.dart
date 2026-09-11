import 'dart:math';
import 'package:flutter/material.dart';

/// Facade and controller for ByUI standalone dialogs.
/// Supports alerts, confirms, and custom modal layouts with sleek glassmorphic surfaces.
abstract class ByDialog {
  /// Displays a customizable modal dialog with smooth scale and fade transition.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x99000000),
    Duration transitionDuration = const Duration(milliseconds: 320),
    Curve enterCurve = Curves.easeOutCubic,
    BorderRadius? borderRadius,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss Dialog',
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (ctx, anim1, anim2) {
        return SafeArea(
          child: Center(
            child: Material(color: Colors.transparent, child: builder(ctx)),
          ),
        );
      },
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        final curved = CurvedAnimation(parent: anim, curve: enterCurve);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.88, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Displays an alert dialog with an icon, title, message, and a single 'OK' button.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon = Icons.info_outline_rounded,
    Color? iconColor,
    String buttonText = 'OK',
    Color backgroundColor = const Color(0xFF0F172A),
    Gradient? gradient,
    Color textColor = Colors.white,
    Border? border,
    BorderRadius? borderRadius,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x99000000),
    Duration transitionDuration = const Duration(milliseconds: 320),
    Curve enterCurve = Curves.easeOutCubic,
    Color? buttonColor,
    VoidCallback? onConfirm,
  }) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(22);

    return show(
      context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      enterCurve: enterCurve,
      builder: (ctx) {
        final screenSize = MediaQuery.of(ctx).size;
        final double cardWidth = min(screenSize.width - 40.0, 380.0);

        return Container(
          width: cardWidth,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          decoration: BoxDecoration(
            color: gradient == null ? backgroundColor : null,
            gradient: gradient,
            borderRadius: effectiveBorderRadius,
            border: border ??
                Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.2,
                ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: (iconColor ?? buttonColor ?? const Color(0xFF6366F1))
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? buttonColor ?? const Color(0xFF6366F1),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.8),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor ?? const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx, rootNavigator: true).pop();
                    onConfirm?.call();
                  },
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Displays a confirmation dialog with 'Cancel' and 'Confirm' buttons.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon = Icons.help_outline_rounded,
    Color? iconColor,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color confirmColor = const Color(0xFF6366F1),
    Color backgroundColor = const Color(0xFF0F172A),
    Gradient? gradient,
    Color textColor = Colors.white,
    Border? border,
    BorderRadius? borderRadius,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x99000000),
    Duration transitionDuration = const Duration(milliseconds: 320),
    Curve enterCurve = Curves.easeOutCubic,
  }) async {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(22);

    final result = await show<bool>(
      context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      enterCurve: enterCurve,
      builder: (ctx) {
        final screenSize = MediaQuery.of(ctx).size;
        final double cardWidth = min(screenSize.width - 40.0, 380.0);

        return Container(
          width: cardWidth,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          decoration: BoxDecoration(
            color: gradient == null ? backgroundColor : null,
            gradient: gradient,
            borderRadius: effectiveBorderRadius,
            border: border ??
                Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.2,
                ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: (iconColor ?? confirmColor).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: iconColor ?? confirmColor, size: 28),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.8),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textColor.withValues(alpha: 0.7),
                        side: BorderSide(
                          color: textColor.withValues(alpha: 0.2),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(ctx, rootNavigator: true).pop(false),
                      child: Text(cancelText),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(ctx, rootNavigator: true).pop(true),
                      child: Text(
                        confirmText,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }

  /// Preset success alert dialog with vibrant emerald green accent.
  static Future<void> success(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Done',
    VoidCallback? onConfirm,
  }) {
    return alert(
      context,
      title: title,
      message: message,
      icon: Icons.check_circle_outline_rounded,
      iconColor: const Color(0xFF10B981),
      buttonColor: const Color(0xFF10B981),
      buttonText: buttonText,
      onConfirm: onConfirm,
    );
  }

  /// Preset error alert dialog with warning crimson accent.
  static Future<void> error(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Dismiss',
    VoidCallback? onConfirm,
  }) {
    return alert(
      context,
      title: title,
      message: message,
      icon: Icons.error_outline_rounded,
      iconColor: const Color(0xFFEF4444),
      buttonColor: const Color(0xFFEF4444),
      buttonText: buttonText,
      onConfirm: onConfirm,
    );
  }

  /// Preset warning alert dialog with warm amber accent.
  static Future<void> warning(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Understood',
    VoidCallback? onConfirm,
  }) {
    return alert(
      context,
      title: title,
      message: message,
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFF59E0B),
      buttonColor: const Color(0xFFF59E0B),
      buttonText: buttonText,
      onConfirm: onConfirm,
    );
  }

  /// Preset informational alert dialog with sky blue accent.
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return alert(
      context,
      title: title,
      message: message,
      icon: Icons.info_outline_rounded,
      iconColor: const Color(0xFF3B82F6),
      buttonColor: const Color(0xFF3B82F6),
      buttonText: buttonText,
      onConfirm: onConfirm,
    );
  }
}
