import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';

/// Global singleton store holding user-selected ByToast configurations
/// across the showcase application.
class ToastConfigStore {
  static final ToastConfigStore instance = ToastConfigStore._();
  ToastConfigStore._();

  // Screen Anchor Position & Direction
  ByToastPosition position = ByToastPosition.top;
  ByToastSlideDirection? slideDirection;
  ByToastAnimationType animationType = ByToastAnimationType.slideAndFade;

  // Theme & Surface Appearance
  int selectedColorIndex = 0;
  double backgroundOpacity = 1.0;
  bool showCloseButton = true;
  bool useOutlineBorder = false;
  bool isMultiLine = false;

  // Text Truncation & Overflow
  int? maxLines = 3;
  TextOverflow overflow = TextOverflow.ellipsis;

  // Prefix & Suffix Icon Selection
  int selectedLeftIconIndex = 1;
  int selectedRightActionIndex = 1;

  // Tap-to-dialog Morphing Configuration
  bool enableTapToDialog = true;
  int selectedDialogMode = 0;

  // Available Theme Colors & Gradients
  final List<Map<String, dynamic>> colorThemes = [
    {
      'name': 'Dark Slate (Solid)',
      'color': const Color(0xFF0F172A),
      'textColor': Colors.white,
      'gradient': null,
    },
    {
      'name': 'Pure White (Solid)',
      'color': Colors.white,
      'textColor': const Color(0xFF0F172A),
      'gradient': null,
    },
    {
      'name': 'Mint Emerald (Solid)',
      'color': const Color(0xFF10B981),
      'textColor': Colors.white,
      'gradient': null,
    },
    {
      'name': 'Ruby Crimson (Solid)',
      'color': const Color(0xFFEF4444),
      'textColor': Colors.white,
      'gradient': null,
    },
    {
      'name': 'Royal Indigo (Solid)',
      'color': const Color(0xFF4F46E5),
      'textColor': Colors.white,
      'gradient': null,
    },
    {
      'name': 'Aurora Midnight (Gradient)',
      'color': const Color(0xFF1E1B4B),
      'textColor': Colors.white,
      'gradient': const LinearGradient(
        colors: [Color(0xFF312E81), Color(0xFF0F172A)],
      ),
    },
    {
      'name': 'Sunset Violet (Gradient)',
      'color': const Color(0xFF7C3AED),
      'textColor': Colors.white,
      'gradient': const LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
      ),
    },
  ];

  Map<String, dynamic> get activeTheme => colorThemes[selectedColorIndex];

  /// Displays an action feedback toast following user's active settings on ByToast page.
  void showFeedback(
    BuildContext context, {
    required String message,
    String? title,
    IconData? icon,
    Color? iconColor,
    Color? customColor,
    Gradient? customGradient,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final theme = activeTheme;
    final effectiveColor = customColor ?? theme['color'] as Color;
    final effectiveGradient =
        customGradient ?? (theme['gradient'] as Gradient?);
    final effectiveTextColor = textColor ?? theme['textColor'] as Color;

    final effectiveSlideDirection = slideDirection ??
        (position == ByToastPosition.top
            ? ByToastSlideDirection.fromTop
            : ByToastSlideDirection.fromBottom);

    ByToast.show(
      context,
      message: message,
      title: title,
      icon: icon,
      iconColor: iconColor ?? effectiveTextColor,
      backgroundColor: effectiveColor,
      gradient: effectiveGradient,
      textColor: effectiveTextColor,
      position: position,
      slideDirection: effectiveSlideDirection,
      animationType: animationType,
      showCloseButton: showCloseButton,
      border: useOutlineBorder
          ? Border.all(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.8),
              width: 1.2,
            )
          : null,
      enterCurve: animationType == ByToastAnimationType.bounce
          ? Curves.easeOutBack
          : Curves.easeOutCubic,
      duration: duration,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
