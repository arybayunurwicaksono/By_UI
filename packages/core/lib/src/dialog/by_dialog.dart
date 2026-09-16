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

  /// Displays an alert dialog with an icon, optional title, message or custom content, and a single action button.
  static Future<void> alert(
    BuildContext context, {
    String? title,
    String? message,
    Widget? content,
    double? maxWidth,
    IconData? icon = Icons.info_outline_rounded,
    Color? iconColor,
    String buttonText = 'OK',
    Color backgroundColor = const Color(0xFF0F172A),
    Gradient? gradient,
    Color textColor = Colors.white,
    Border? border,
    BorderRadius? borderRadius,
    int? messageMaxLines,
    TextOverflow? messageOverflow,
    int? titleMaxLines,
    TextOverflow? titleOverflow,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x99000000),
    Duration transitionDuration = const Duration(milliseconds: 320),
    Curve enterCurve = Curves.easeOutCubic,
    Color? buttonColor,
    Color? buttonTextColor,
    BorderRadius? buttonBorderRadius,
    VoidCallback? onConfirm,
  }) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(22);
    final effectiveButtonRadius =
        buttonBorderRadius ?? BorderRadius.circular(12);

    return show(
      context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      enterCurve: enterCurve,
      builder: (ctx) {
        final screenSize = MediaQuery.of(ctx).size;
        final double cardWidth =
            min(screenSize.width - 40.0, maxWidth ?? 380.0);

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
              if (title != null && title.isNotEmpty) ...[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: titleMaxLines,
                  overflow: titleOverflow,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              if (content != null)
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenSize.height * 0.62,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: content,
                    ),
                  ),
                )
              else if (message != null && message.isNotEmpty)
                Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: messageMaxLines,
                  overflow: messageOverflow,
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
                    foregroundColor: buttonTextColor ?? Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: effectiveButtonRadius,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx, rootNavigator: true).pop();
                    onConfirm?.call();
                  },
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: buttonTextColor ?? Colors.white,
                    ),
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
    Color? confirmTextColor,
    Color? cancelColor,
    Color? cancelBorderColor,
    Color? cancelTextColor,
    BorderRadius? buttonBorderRadius,
    bool reverseButtonOrder = false,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color backgroundColor = const Color(0xFF0F172A),
    Gradient? gradient,
    Color textColor = Colors.white,
    Border? border,
    BorderRadius? borderRadius,
    int? messageMaxLines,
    TextOverflow? messageOverflow,
    int? titleMaxLines,
    TextOverflow? titleOverflow,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x99000000),
    Duration transitionDuration = const Duration(milliseconds: 320),
    Curve enterCurve = Curves.easeOutCubic,
  }) async {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(22);
    final effectiveButtonRadius =
        buttonBorderRadius ?? BorderRadius.circular(12);

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
                maxLines: titleMaxLines,
                overflow: titleOverflow,
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
                maxLines: messageMaxLines,
                overflow: messageOverflow,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.8),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              Builder(
                builder: (ctx) {
                  final effectiveCancelBorder = cancelBorderColor ??
                      (cancelColor != null
                          ? Colors.transparent
                          : textColor.withValues(alpha: 0.2));
                  final effectiveCancelText = cancelTextColor ??
                      (cancelColor != null
                          ? Colors.white
                          : textColor.withValues(alpha: 0.7));

                  final Widget cancelButton = Expanded(
                    child: cancelColor != null
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cancelColor,
                              foregroundColor: effectiveCancelText,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: effectiveButtonRadius,
                                side: cancelBorderColor != null
                                    ? BorderSide(color: cancelBorderColor)
                                    : BorderSide.none,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx, rootNavigator: true).pop(false);
                              onCancel?.call();
                            },
                            child: Text(
                              cancelText,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: effectiveCancelText,
                              ),
                            ),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: effectiveCancelText,
                              side: BorderSide(
                                color: effectiveCancelBorder,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: effectiveButtonRadius,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx, rootNavigator: true).pop(false);
                              onCancel?.call();
                            },
                            child: Text(
                              cancelText,
                              style: TextStyle(color: effectiveCancelText),
                            ),
                          ),
                  );

                  final Widget confirmButton = Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        foregroundColor: confirmTextColor ?? Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: effectiveButtonRadius,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx, rootNavigator: true).pop(true);
                        onConfirm?.call();
                      },
                      child: Text(
                        confirmText,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: confirmTextColor ?? Colors.white,
                        ),
                      ),
                    ),
                  );

                  return Row(
                    children: reverseButtonOrder
                        ? [
                            confirmButton,
                            const SizedBox(width: 10),
                            cancelButton
                          ]
                        : [
                            cancelButton,
                            const SizedBox(width: 10),
                            confirmButton
                          ],
                  );
                },
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
    Color? buttonTextColor,
    BorderRadius? buttonBorderRadius,
    int? messageMaxLines,
    TextOverflow? messageOverflow,
    int? titleMaxLines,
    TextOverflow? titleOverflow,
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
      buttonTextColor: buttonTextColor,
      buttonBorderRadius: buttonBorderRadius,
      messageMaxLines: messageMaxLines,
      messageOverflow: messageOverflow,
      titleMaxLines: titleMaxLines,
      titleOverflow: titleOverflow,
      onConfirm: onConfirm,
    );
  }

  /// Preset error alert dialog with warning crimson accent.
  static Future<void> error(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Dismiss',
    Color? buttonTextColor,
    BorderRadius? buttonBorderRadius,
    int? messageMaxLines,
    TextOverflow? messageOverflow,
    int? titleMaxLines,
    TextOverflow? titleOverflow,
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
      buttonTextColor: buttonTextColor,
      buttonBorderRadius: buttonBorderRadius,
      messageMaxLines: messageMaxLines,
      messageOverflow: messageOverflow,
      titleMaxLines: titleMaxLines,
      titleOverflow: titleOverflow,
      onConfirm: onConfirm,
    );
  }

  /// Preset warning alert dialog with warm amber accent.
  static Future<void> warning(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Understood',
    Color? buttonTextColor,
    BorderRadius? buttonBorderRadius,
    int? messageMaxLines,
    TextOverflow? messageOverflow,
    int? titleMaxLines,
    TextOverflow? titleOverflow,
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
      buttonTextColor: buttonTextColor,
      buttonBorderRadius: buttonBorderRadius,
      messageMaxLines: messageMaxLines,
      messageOverflow: messageOverflow,
      titleMaxLines: titleMaxLines,
      titleOverflow: titleOverflow,
      onConfirm: onConfirm,
    );
  }

  /// Preset informational alert dialog with sky blue accent.
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    Color? buttonTextColor,
    BorderRadius? buttonBorderRadius,
    int? messageMaxLines,
    TextOverflow? messageOverflow,
    int? titleMaxLines,
    TextOverflow? titleOverflow,
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
      buttonTextColor: buttonTextColor,
      buttonBorderRadius: buttonBorderRadius,
      messageMaxLines: messageMaxLines,
      messageOverflow: messageOverflow,
      titleMaxLines: titleMaxLines,
      titleOverflow: titleOverflow,
      onConfirm: onConfirm,
    );
  }
}
