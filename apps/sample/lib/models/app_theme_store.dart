import 'package:flutter/material.dart';

/// Global controller managing the application's [ThemeMode].
///
/// By default, [themeMode] is set to [ThemeMode.system], meaning the app
/// automatically follows the host device's theme (Light or Dark).
/// Users can override this setting manually via the navigation drawer.
class AppThemeStore extends ChangeNotifier {
  static final AppThemeStore instance = AppThemeStore._();
  AppThemeStore._();

  ThemeMode _themeMode = ThemeMode.system;

  /// Current active [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// Whether the app is configured to automatically follow the device/system theme.
  bool get isSystem => _themeMode == ThemeMode.system;

  /// Whether the app is explicitly forced to Light theme.
  bool get isLight => _themeMode == ThemeMode.light;

  /// Whether the app is explicitly forced to Dark theme.
  bool get isDark => _themeMode == ThemeMode.dark;

  /// Updates the application theme mode and notifies listeners.
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  /// Evaluates whether the currently displayed brightness is dark.
  ///
  /// When [themeMode] is [ThemeMode.system], this queries the host platform's
  /// brightness via [MediaQuery.platformBrightnessOf].
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
