import 'package:flutter/material.dart';
import 'by_toast_enums.dart';

/// Data model representing an active toast item in the ByUI toast system.
class ByToastModel {
  /// Unique identifier for this toast instance.
  final String id;

  /// Primary message text displayed in the toast.
  final String message;

  /// Optional header title displayed above the message.
  final String? title;

  /// Optional custom leading widget. If provided, overrides [icon].
  final Widget? leading;

  /// Optional prefix icon displayed on the left side of the message.
  final IconData? icon;

  /// Color tint applied to the prefix [icon]. Defaults to [textColor].
  final Color? iconColor;

  /// Optional callback executed when the leading [icon] is tapped.
  final VoidCallback? onIconTap;

  /// Optional custom suffix widget displayed before or in place of close button.
  /// If provided, overrides [suffixIcon].
  final Widget? suffix;

  /// Optional suffix icon displayed on the right side.
  final IconData? suffixIcon;

  /// Color tint applied to [suffixIcon]. Defaults to [textColor].
  final Color? suffixIconColor;

  /// Callback executed when [suffixIcon] or [suffix] is tapped.
  final VoidCallback? onSuffixTap;

  /// Callback executed when the toast card body is tapped.
  final VoidCallback? onTap;

  /// Solid background color for the toast card.
  final Color backgroundColor;

  /// Optional gradient background. When provided, takes precedence over solid [backgroundColor].
  final Gradient? gradient;

  /// Opacity multiplier applied strictly to the background surface (0.0 to 1.0).
  ///
  /// Defaults to 1.0 (fully opaque). Foreground elements (text, icons, buttons)
  /// preserve their original opacity and clarity.
  final double backgroundOpacity;

  /// Text color for the message and default tint for icons.
  final Color textColor;

  /// Custom typography style for the message text.
  final TextStyle? textStyle;

  /// Custom typography style for the optional [title].
  final TextStyle? titleStyle;

  /// Maximum number of lines for the message text. Defaults to 3.
  final int? maxLines;

  /// How visual overflow should be handled for the message text. Defaults to [TextOverflow.ellipsis].
  final TextOverflow? overflow;

  /// Optional maximum number of lines for the optional [title].
  final int? titleMaxLines;

  /// Optional overflow behavior for the optional [title].
  final TextOverflow? titleOverflow;

  /// Optional outline border around the toast card.
  final Border? border;

  /// Custom shadow elevation for the toast card.
  final List<BoxShadow>? boxShadow;

  /// Corner radius of the toast card. Defaults to BorderRadius.circular(14).
  final BorderRadius? borderRadius;

  /// How long the toast stays visible before auto-dismissing.
  final Duration duration;

  /// Duration of entrance and exit animations.
  final Duration animationDuration;

  /// Easing curve for entrance animation.
  final Curve enterCurve;

  /// Easing curve for exit animation.
  final Curve exitCurve;

  /// Screen anchor position (top or bottom).
  final ByToastPosition position;

  /// Direction from which the toast slides in.
  final ByToastSlideDirection slideDirection;

  /// Animation style transition.
  final ByToastAnimationType animationType;

  /// Whether to display the close button ('X' icon) on the trailing end.
  final bool showCloseButton;

  /// Color tint for the close button icon.
  final Color? closeButtonColor;

  /// Inner padding of the toast card. Defaults to symmetric(horizontal: 14, vertical: 12).
  final EdgeInsetsGeometry? padding;

  /// Horizontal margin of the card from screen edges. Defaults to 16px.
  final double horizontalMargin;

  /// Optional header title displayed inside the expanded detail dialog.
  final String? detailTitle;

  /// Optional extended message displayed inside the default detail dialog (Option 1).
  final String? detailMessage;

  /// Optional custom builder for the expanded dialog content (Option 2).
  /// Takes precedence over [detailMessage].
  final WidgetBuilder? detailBuilder;

  /// Explicit toggle for tap-to-expand gesture.
  /// If null, automatically enables when [detailBuilder], [detailMessage], or [detailTitle] is set.
  final bool? enableTapToExpand;

  /// Explicit toggle for drag-to-expand gesture.
  /// If null, automatically enables when [detailBuilder], [detailMessage], or [detailTitle] is set.
  final bool? enableDragToExpand;

  /// Duration of the morphing dialog animation.
  final Duration dialogAnimationDuration;

  /// Entrance curve for the morphing dialog.
  final Curve dialogEnterCurve;

  /// Exit curve when the dialog closes.
  final Curve dialogExitCurve;

  /// Optional explicit height for the expanded dialog.
  /// If null, the dialog height automatically adjusts to fit the content dynamically.
  final double? dialogHeight;

  /// Whether tap-to-expand gesture is active on this toast.
  bool get canTapToExpand =>
      enableTapToExpand ??
      (onTap != null
          ? (detailBuilder != null ||
              detailMessage != null ||
              detailTitle != null)
          : (enableDragToExpand ?? true));

  /// Whether drag-to-expand gesture is active on this toast.
  bool get canDragToExpand =>
      enableDragToExpand ?? enableTapToExpand ?? true;

  /// Effective background color with [backgroundOpacity] applied.
  Color get effectiveBackgroundColor {
    final opacity = backgroundOpacity.clamp(0.0, 1.0);
    if (opacity >= 1.0) return backgroundColor;
    return backgroundColor.withValues(alpha: backgroundColor.a * opacity);
  }

  /// Effective gradient with [backgroundOpacity] applied to each color stop.
  Gradient? get effectiveGradient {
    final grad = gradient;
    if (grad == null) return null;
    final opacity = backgroundOpacity.clamp(0.0, 1.0);
    if (opacity >= 1.0) return grad;

    if (grad is LinearGradient) {
      return LinearGradient(
        begin: grad.begin,
        end: grad.end,
        colors: grad.colors
            .map((c) => c.withValues(alpha: c.a * opacity))
            .toList(),
        stops: grad.stops,
        tileMode: grad.tileMode,
        transform: grad.transform,
      );
    } else if (grad is RadialGradient) {
      return RadialGradient(
        center: grad.center,
        radius: grad.radius,
        colors: grad.colors
            .map((c) => c.withValues(alpha: c.a * opacity))
            .toList(),
        stops: grad.stops,
        tileMode: grad.tileMode,
        focal: grad.focal,
        focalRadius: grad.focalRadius,
        transform: grad.transform,
      );
    } else if (grad is SweepGradient) {
      return SweepGradient(
        center: grad.center,
        startAngle: grad.startAngle,
        endAngle: grad.endAngle,
        colors: grad.colors
            .map((c) => c.withValues(alpha: c.a * opacity))
            .toList(),
        stops: grad.stops,
        tileMode: grad.tileMode,
        transform: grad.transform,
      );
    }
    return grad;
  }

  const ByToastModel({
    required this.id,
    required this.message,
    this.title,
    this.leading,
    this.icon,
    this.iconColor,
    this.onIconTap,
    this.suffix,
    this.suffixIcon,
    this.suffixIconColor,
    this.onSuffixTap,
    this.onTap,
    required this.backgroundColor,
    this.gradient,
    this.backgroundOpacity = 1.0,
    required this.textColor,
    this.textStyle,
    this.titleStyle,
    this.maxLines = 3,
    this.overflow = TextOverflow.ellipsis,
    this.titleMaxLines,
    this.titleOverflow,
    this.border,
    this.boxShadow,
    this.borderRadius,
    required this.duration,
    required this.animationDuration,
    required this.enterCurve,
    required this.exitCurve,
    required this.position,
    required this.slideDirection,
    required this.animationType,
    required this.showCloseButton,
    this.closeButtonColor,
    this.padding,
    this.horizontalMargin = 16.0,
    this.detailTitle,
    this.detailMessage,
    this.detailBuilder,
    this.dialogHeight,
    this.enableTapToExpand,
    this.enableDragToExpand,
    this.dialogAnimationDuration = const Duration(milliseconds: 380),
    this.dialogEnterCurve = Curves.easeOutCubic,
    this.dialogExitCurve = Curves.easeInCubic,
  });
}

// Backward compatibility alias
typedef ByNotificationModel = ByToastModel;
