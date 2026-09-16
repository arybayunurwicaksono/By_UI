import 'package:flutter/material.dart';

/// Represents a named icon option for showcase component pickers and previews.
class ShowcaseIconOption {
  final String name;
  final IconData? icon;

  const ShowcaseIconOption(this.name, this.icon);

  /// Allows indexed lookup for seamless backward compatibility with Map-based APIs.
  dynamic operator [](String key) {
    if (key == 'name') return name;
    if (key == 'icon') return icon;
    return null;
  }
}

/// Centralized icon registry and preset collections for the ByUI Showcase app.
///
/// Eliminates duplicated [IconData] instantiations across showcase screens,
/// drawer menus, toolbars, and parameter dialogs.
class AppIcons {
  // Navigation & Shell
  static const IconData menu = Icons.menu_rounded;
  static const IconData reset = Icons.restart_alt_rounded;
  static const IconData help = Icons.help_outline_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData checkRaw = Icons.check;
  static const IconData arrowForward = Icons.arrow_forward_ios_rounded;
  static const IconData undo = Icons.undo_rounded;
  static const IconData delete = Icons.delete_forever_rounded;
  static const IconData print = Icons.print_rounded;
  static const IconData play = Icons.play_arrow_rounded;
  static const IconData sparkle = Icons.auto_awesome_rounded;
  static const IconData dashboard = Icons.dashboard_customize_rounded;
  static const IconData star = Icons.star_border_rounded;
  static const IconData button = Icons.smart_button_rounded;
  static const IconData position = Icons.open_with_rounded;
  static const IconData animation = Icons.animation_rounded;
  static const IconData external = Icons.open_in_new_rounded;
  static const IconData wrapText = Icons.wrap_text_rounded;
  static const IconData bolt = Icons.bolt_rounded;
  static const IconData radioUnchecked = Icons.radio_button_unchecked_rounded;

  // Status & Feedback
  static const IconData info = Icons.info_outline_rounded;
  static const IconData success = Icons.check_circle_outline_rounded;
  static const IconData successFilled = Icons.check_circle_rounded;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData error = Icons.error_outline_rounded;
  static const IconData notification = Icons.notifications_active_rounded;

  // Dialog Thematic Icons
  static const IconData shield = Icons.verified_user_outlined;
  static const IconData receipt = Icons.receipt_long_rounded;
  static const IconData flame = Icons.local_fire_department_outlined;

  // Card & Controls
  static const IconData palette = Icons.palette_rounded;
  static const IconData tune = Icons.tune_rounded;
  static const IconData screenRotation = Icons.screen_rotation_rounded;
  static const IconData explore = Icons.explore_rounded;
  static const IconData gradient = Icons.gradient_rounded;
  static const IconData cardNormal = Icons.check_box_outline_blank_rounded;
  static const IconData card = Icons.credit_card_rounded;
  static const IconData motion = Icons.motion_photos_on_rounded;
  static const IconData layers = Icons.layers_rounded;

  // Theme Modes
  static const IconData themeAuto = Icons.brightness_auto_rounded;
  static const IconData themeLight = Icons.light_mode_rounded;
  static const IconData themeDark = Icons.dark_mode_rounded;

  // Device Preview Toolbar
  static const IconData phoneIphone = Icons.phone_iphone_rounded;
  static const IconData phoneAndroid = Icons.phone_android_rounded;
  static const IconData phoneGeneric = Icons.stay_current_portrait_rounded;
  static const IconData tablet = Icons.tablet_mac_rounded;
  static const IconData widgets = Icons.widgets_rounded;
  static const IconData touch = Icons.touch_app_rounded;
  static const IconData click = Icons.ads_click_rounded;
  static const IconData swipe = Icons.swipe_rounded;
  static const IconData drag = Icons.drag_handle_rounded;

  /// Standardized icon presets for ByDialog showcase icon selection.
  static const List<ShowcaseIconOption> dialogIconPresets = [
    ShowcaseIconOption('None', null),
    ShowcaseIconOption('Info', info),
    ShowcaseIconOption('Success', success),
    ShowcaseIconOption('Warning', warning),
    ShowcaseIconOption('Help', help),
    ShowcaseIconOption('Shield', shield),
    ShowcaseIconOption('Receipt', receipt),
    ShowcaseIconOption('Flame', flame),
  ];

  /// Standardized prefix icon presets for ByToast showcase icon selection.
  static const List<ShowcaseIconOption> toastLeftIconPresets = [
    ShowcaseIconOption('None', null),
    ShowcaseIconOption('Bell Icon', notification),
    ShowcaseIconOption('Checkmark', successFilled),
    ShowcaseIconOption('Info Icon', info),
  ];
}
