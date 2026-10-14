import 'package:flutter/material.dart';
import '../screens/app_bar_showcase_screen.dart';
import '../screens/button_showcase_screen.dart';
import '../screens/card_showcase_screen.dart';
import '../screens/dialog_showcase_screen.dart';
import '../screens/sequence_showcase_screen.dart';
import '../screens/toast_showcase_screen.dart';

/// Centralized router helper for transitioning between showcase screens.
class ShowcaseNavigator {
  const ShowcaseNavigator._();

  /// Transitions to the target showcase screen using replacement navigation.
  static void pushReplacement(BuildContext context, String componentName) {
    Widget? targetScreen;
    switch (componentName) {
      case 'ByToast':
        targetScreen = const ToastShowcaseScreen();
        break;
      case 'ByDialog':
        targetScreen = const DialogShowcaseScreen();
        break;
      case 'ByCard':
        targetScreen = const CardShowcaseScreen();
        break;
      case 'ByAppBar':
        targetScreen = const AppBarShowcaseScreen();
        break;
      case 'BySequence':
        targetScreen = const SequenceShowcaseScreen();
        break;
      case 'ByButton':
        targetScreen = const ButtonShowcaseScreen();
        break;
    }

    if (targetScreen != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => targetScreen!),
      );
    }
  }
}
