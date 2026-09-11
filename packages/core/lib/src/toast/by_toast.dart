import 'package:flutter/material.dart';
import 'by_toast_container.dart';
import 'by_toast_enums.dart';
import 'by_toast_model.dart';

/// Facade and controller for the ByUI toast system.
///
/// Supports fluid stacked spatial animations, dual screen positions (top and bottom),
/// multi-directional slide entrances, dynamic height calculations, and extensive
/// styling customizations (solid colors, gradients, custom borders, and suffix actions),
/// plus interactive Tap-to-Dialog morphing transitions!
abstract class ByToast {
  /// Optional GlobalKey attached to the active AppBar.
  /// When attached, top-positioned toasts anchor directly below this AppBar.
  static final GlobalKey appBarKey = GlobalKey(debugLabel: 'ByToastAppBarKey');

  /// Optional GlobalKey attached to the active BottomNavigationBar or BottomAppBar.
  /// When attached, bottom-positioned toasts anchor directly above this bar.
  static final GlobalKey bottomBarKey = GlobalKey(
    debugLabel: 'ByToastBottomBarKey',
  );

  static OverlayEntry? _overlayEntry;
  static final List<ByToastModel> _activeItems = [];
  static final _containerKey = GlobalKey<ByToastContainerState>();

  /// Maximum number of stacked toasts visible at the same time.
  static int maxVisibleItems = 3;

  /// Vertical spacing between stacked cards in logical pixels.
  static double itemSpacing = 10.0;

  /// Displays a customized toast banner.
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    Widget? leading,
    Widget? prefix,
    IconData? icon = Icons.info_outline_rounded,
    IconData? prefixIcon,
    Color? iconColor,
    Color? prefixIconColor,
    VoidCallback? onIconTap,
    VoidCallback? onPrefixTap,
    Widget? suffix,
    IconData? suffixIcon,
    Color? suffixIconColor,
    VoidCallback? onSuffixTap,
    VoidCallback? onTap,
    Color backgroundColor = const Color(0xFF0F172A),
    Gradient? gradient,
    Color textColor = Colors.white,
    TextStyle? textStyle,
    TextStyle? titleStyle,
    Border? border,
    List<BoxShadow>? boxShadow,
    BorderRadius? borderRadius,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 380),
    Curve enterCurve = Curves.easeOutCubic,
    Curve exitCurve = Curves.easeInCubic,
    ByToastPosition position = ByToastPosition.top,
    ByToastSlideDirection? slideDirection,
    ByToastAnimationType animationType = ByToastAnimationType.slideAndFade,
    bool showCloseButton = true,
    Color? closeButtonColor,
    EdgeInsetsGeometry? padding,
    double horizontalMargin = 16.0,

    // Tap-to-Dialog Morphing fields
    String? detailTitle,
    String? detailMessage,
    WidgetBuilder? detailBuilder,
    double? dialogHeight,
    bool? enableTapToExpand,
    bool? enableDragToExpand,
    Duration dialogAnimationDuration = const Duration(milliseconds: 380),
    Curve dialogEnterCurve = Curves.easeOutCubic,
    Curve dialogExitCurve = Curves.easeInCubic,
  }) {
    final overlay =
        Overlay.maybeOf(context, rootOverlay: true) ?? Overlay.maybeOf(context);
    if (overlay == null) return;

    // Resolve default slide direction based on screen anchor position
    final effectiveSlideDirection = slideDirection ??
        (position == ByToastPosition.top
            ? ByToastSlideDirection.fromTop
            : ByToastSlideDirection.fromBottom);

    final effectiveLeading = prefix ?? leading;
    final effectiveIcon = prefixIcon ?? icon;
    final effectiveIconColor = prefixIconColor ?? iconColor;
    final effectiveOnIconTap = onPrefixTap ?? onIconTap;

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final newItem = ByToastModel(
      id: id,
      message: message,
      title: title,
      leading: effectiveLeading,
      icon: effectiveIcon,
      iconColor: effectiveIconColor,
      onIconTap: effectiveOnIconTap,
      suffix: suffix,
      suffixIcon: suffixIcon,
      suffixIconColor: suffixIconColor,
      onSuffixTap: onSuffixTap,
      onTap: onTap,
      backgroundColor: backgroundColor,
      gradient: gradient,
      textColor: textColor,
      textStyle: textStyle,
      titleStyle: titleStyle,
      border: border,
      boxShadow: boxShadow,
      borderRadius: borderRadius,
      duration: duration,
      animationDuration: animationDuration,
      enterCurve: enterCurve,
      exitCurve: exitCurve,
      position: position,
      slideDirection: effectiveSlideDirection,
      animationType: animationType,
      showCloseButton: showCloseButton,
      closeButtonColor: closeButtonColor,
      padding: padding,
      horizontalMargin: horizontalMargin,
      detailTitle: detailTitle,
      detailMessage: detailMessage,
      detailBuilder: detailBuilder,
      dialogHeight: dialogHeight,
      enableTapToExpand: enableTapToExpand,
      enableDragToExpand: enableDragToExpand,
      dialogAnimationDuration: dialogAnimationDuration,
      dialogEnterCurve: dialogEnterCurve,
      dialogExitCurve: dialogExitCurve,
    );

    // Insert new toast at the front of stack (newest first)
    _activeItems.insert(0, newItem);

    // Prune items that exceed maximum visible buffer
    if (_activeItems.length > maxVisibleItems + 2) {
      _activeItems.removeLast();
    }

    if (_overlayEntry == null || !_overlayEntry!.mounted) {
      _overlayEntry?.remove();
      _overlayEntry = OverlayEntry(
        builder: (ctx) {
          return ByToastContainer(
            key: _containerKey,
            items: _activeItems,
            maxVisibleItems: maxVisibleItems,
            itemSpacing: itemSpacing,
            onDismissItem: (itemId) => _removeItem(itemId),
          );
        },
      );
      overlay.insert(_overlayEntry!);
    } else {
      _containerKey.currentState?.updateItems(_activeItems);
    }
  }

  /// Displays a preset success toast with emerald green background.
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Color backgroundColor = const Color(0xFF10B981),
    Gradient? gradient,
    Color textColor = Colors.white,
    IconData? icon = Icons.check_circle_rounded,
    IconData? prefixIcon,
    Color? iconColor,
    Color? prefixIconColor,
    VoidCallback? onIconTap,
    VoidCallback? onPrefixTap,
    IconData? suffixIcon,
    Color? suffixIconColor,
    VoidCallback? onSuffixTap,
    VoidCallback? onTap,
    Border? border,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 380),
    Curve enterCurve = Curves.easeOutCubic,
    Curve exitCurve = Curves.easeInCubic,
    ByToastPosition position = ByToastPosition.top,
    ByToastSlideDirection? slideDirection,
    ByToastAnimationType animationType = ByToastAnimationType.slideAndFade,
    bool showCloseButton = true,
    String? detailTitle,
    String? detailMessage,
    WidgetBuilder? detailBuilder,
    double? dialogHeight,
    bool? enableTapToExpand,
    bool? enableDragToExpand,
  }) {
    show(
      context,
      message: message,
      title: title,
      backgroundColor: backgroundColor,
      gradient: gradient,
      textColor: textColor,
      icon: icon,
      prefixIcon: prefixIcon,
      iconColor: iconColor,
      prefixIconColor: prefixIconColor,
      onIconTap: onIconTap,
      onPrefixTap: onPrefixTap,
      suffixIcon: suffixIcon,
      suffixIconColor: suffixIconColor,
      onSuffixTap: onSuffixTap,
      onTap: onTap,
      border: border,
      duration: duration,
      animationDuration: animationDuration,
      enterCurve: enterCurve,
      exitCurve: exitCurve,
      position: position,
      slideDirection: slideDirection,
      animationType: animationType,
      showCloseButton: showCloseButton,
      detailTitle: detailTitle,
      detailMessage: detailMessage,
      detailBuilder: detailBuilder,
      dialogHeight: dialogHeight,
      enableTapToExpand: enableTapToExpand ?? enableDragToExpand,
    );
  }

  /// Displays a preset error toast with crimson red background.
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Color backgroundColor = const Color(0xFFEF4444),
    Gradient? gradient,
    Color textColor = Colors.white,
    IconData? icon = Icons.error_rounded,
    IconData? prefixIcon,
    Color? iconColor,
    Color? prefixIconColor,
    VoidCallback? onIconTap,
    VoidCallback? onPrefixTap,
    IconData? suffixIcon,
    Color? suffixIconColor,
    VoidCallback? onSuffixTap,
    VoidCallback? onTap,
    Border? border,
    Duration duration = const Duration(seconds: 4),
    Duration animationDuration = const Duration(milliseconds: 380),
    Curve enterCurve = Curves.easeOutCubic,
    Curve exitCurve = Curves.easeInCubic,
    ByToastPosition position = ByToastPosition.top,
    ByToastSlideDirection? slideDirection,
    ByToastAnimationType animationType = ByToastAnimationType.slideAndFade,
    bool showCloseButton = true,
    String? detailTitle,
    String? detailMessage,
    WidgetBuilder? detailBuilder,
    double? dialogHeight,
    bool? enableTapToExpand,
    bool? enableDragToExpand,
  }) {
    show(
      context,
      message: message,
      title: title,
      backgroundColor: backgroundColor,
      gradient: gradient,
      textColor: textColor,
      icon: icon,
      prefixIcon: prefixIcon,
      iconColor: iconColor,
      prefixIconColor: prefixIconColor,
      onIconTap: onIconTap,
      onPrefixTap: onPrefixTap,
      suffixIcon: suffixIcon,
      suffixIconColor: suffixIconColor,
      onSuffixTap: onSuffixTap,
      onTap: onTap,
      border: border,
      duration: duration,
      animationDuration: animationDuration,
      enterCurve: enterCurve,
      exitCurve: exitCurve,
      position: position,
      slideDirection: slideDirection,
      animationType: animationType,
      showCloseButton: showCloseButton,
      detailTitle: detailTitle,
      detailMessage: detailMessage,
      detailBuilder: detailBuilder,
      dialogHeight: dialogHeight,
      enableTapToExpand: enableTapToExpand ?? enableDragToExpand,
    );
  }

  /// Displays a preset informational toast with bright blue background.
  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Color backgroundColor = const Color(0xFF3B82F6),
    Gradient? gradient,
    Color textColor = Colors.white,
    IconData? icon = Icons.info_rounded,
    IconData? prefixIcon,
    Color? iconColor,
    Color? prefixIconColor,
    VoidCallback? onIconTap,
    VoidCallback? onPrefixTap,
    IconData? suffixIcon,
    Color? suffixIconColor,
    VoidCallback? onSuffixTap,
    VoidCallback? onTap,
    Border? border,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 380),
    Curve enterCurve = Curves.easeOutCubic,
    Curve exitCurve = Curves.easeInCubic,
    ByToastPosition position = ByToastPosition.top,
    ByToastSlideDirection? slideDirection,
    ByToastAnimationType animationType = ByToastAnimationType.slideAndFade,
    bool showCloseButton = true,
    String? detailTitle,
    String? detailMessage,
    WidgetBuilder? detailBuilder,
    double? dialogHeight,
    bool? enableTapToExpand,
    bool? enableDragToExpand,
  }) {
    show(
      context,
      message: message,
      title: title,
      backgroundColor: backgroundColor,
      gradient: gradient,
      textColor: textColor,
      icon: icon,
      prefixIcon: prefixIcon,
      iconColor: iconColor,
      prefixIconColor: prefixIconColor,
      onIconTap: onIconTap,
      onPrefixTap: onPrefixTap,
      suffixIcon: suffixIcon,
      suffixIconColor: suffixIconColor,
      onSuffixTap: onSuffixTap,
      onTap: onTap,
      border: border,
      duration: duration,
      animationDuration: animationDuration,
      enterCurve: enterCurve,
      exitCurve: exitCurve,
      position: position,
      slideDirection: slideDirection,
      animationType: animationType,
      showCloseButton: showCloseButton,
      detailTitle: detailTitle,
      detailMessage: detailMessage,
      detailBuilder: detailBuilder,
      dialogHeight: dialogHeight,
      enableTapToExpand: enableTapToExpand ?? enableDragToExpand,
    );
  }

  /// Displays a preset warning toast with warm amber background.
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Color backgroundColor = const Color(0xFFF59E0B),
    Gradient? gradient,
    Color textColor = Colors.white,
    IconData? icon = Icons.warning_amber_rounded,
    IconData? prefixIcon,
    Color? iconColor,
    Color? prefixIconColor,
    VoidCallback? onIconTap,
    VoidCallback? onPrefixTap,
    IconData? suffixIcon,
    Color? suffixIconColor,
    VoidCallback? onSuffixTap,
    VoidCallback? onTap,
    Border? border,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 380),
    Curve enterCurve = Curves.easeOutCubic,
    Curve exitCurve = Curves.easeInCubic,
    ByToastPosition position = ByToastPosition.top,
    ByToastSlideDirection? slideDirection,
    ByToastAnimationType animationType = ByToastAnimationType.slideAndFade,
    bool showCloseButton = true,
    String? detailTitle,
    String? detailMessage,
    WidgetBuilder? detailBuilder,
    double? dialogHeight,
    bool? enableTapToExpand,
    bool? enableDragToExpand,
  }) {
    show(
      context,
      message: message,
      title: title,
      backgroundColor: backgroundColor,
      gradient: gradient,
      textColor: textColor,
      icon: icon,
      prefixIcon: prefixIcon,
      iconColor: iconColor,
      prefixIconColor: prefixIconColor,
      onIconTap: onIconTap,
      onPrefixTap: onPrefixTap,
      suffixIcon: suffixIcon,
      suffixIconColor: suffixIconColor,
      onSuffixTap: onSuffixTap,
      onTap: onTap,
      border: border,
      duration: duration,
      animationDuration: animationDuration,
      enterCurve: enterCurve,
      exitCurve: exitCurve,
      position: position,
      slideDirection: slideDirection,
      animationType: animationType,
      showCloseButton: showCloseButton,
      detailTitle: detailTitle,
      detailMessage: detailMessage,
      detailBuilder: detailBuilder,
      dialogHeight: dialogHeight,
      enableTapToExpand: enableTapToExpand ?? enableDragToExpand,
    );
  }

  static void _removeItem(String id) {
    _activeItems.removeWhere((item) => item.id == id);
    if (_activeItems.isEmpty) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _containerKey.currentState?.updateItems(_activeItems);
    }
  }

  /// Removes all currently active toasts and dismisses the overlay immediately.
  static void clear() {
    _activeItems.clear();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

// Backward compatibility alias
typedef ByNotification = ByToast;
