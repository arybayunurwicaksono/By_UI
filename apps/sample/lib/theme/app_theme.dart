import 'package:flutter/material.dart';
import 'app_colors.dart';

export 'app_colors.dart';
export 'app_textstyle.dart';

/// Central theme definitions for the ByUI Showcase app.
class AppTheme {
  // Brand accent colors
  static const Color primary = AppColors.primary;
  static const Color primaryAccent = AppColors.primaryAccent;

  /// Light ThemeData optimized for crisp contrast and modern aesthetics.
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightScaffoldBg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryAccent,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightBorderSubtle,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightCard,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
    ),
    cardColor: AppColors.lightCard,
    dividerColor: AppColors.lightBorder,
  );

  /// Dark ThemeData with the signature obsidian slate styling.
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkScaffoldBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryAccent,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkBorderSubtle,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkCard,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
    ),
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkBorder,
  );
}
