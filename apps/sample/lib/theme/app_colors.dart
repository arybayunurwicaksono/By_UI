import 'package:flutter/material.dart';
import '../models/app_theme_store.dart';

/// Semantic color tokens and adaptive palette for the ByUI Showcase app.
///
/// Eliminates repetitive `isDark ? colorA : colorB` conditions across widget trees
/// via [AppColors.of(context)] or [AppColors.fromBrightness(isDark)].
class AppColors {
  // Brand & Accent Colors
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryLight = Color(0xFF818CF8); // Indigo 400
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryDeep = Color(0xFF4338CA); // Indigo 700
  static const Color primaryText = Color(0xFF3730A3); // Indigo 800
  static const Color primaryTextLight = Color(0xFFA5B4FC); // Indigo 300
  static const Color primaryAccent = Color(0xFF8B5CF6); // Violet 500

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color cyanAccent = Color(0xFF38BDF8); // Sky 400

  // Dark Theme Neutral Palette
  static const Color darkScaffoldBg = Color(0xFF090D16);
  static const Color darkDrawerBg = Color(0xFF0B0F19);
  static const Color darkCard = Color(0xFF0F172A); // Slate 900
  static const Color darkSurfaceVariant = Color(0xFF1E293B); // Slate 800
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkBorderSubtle = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Slate 300
  static const Color darkTextMuted = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextSubtle = Color(0xFF64748B); // Slate 500

  // Light Theme Neutral Palette
  static const Color lightScaffoldBg = Color(0xFFF8FAFC); // Slate 50
  static const Color lightDrawerBg = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightBorderSubtle = Color(0xFFCBD5E1); // Slate 300
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600
  static const Color lightTextMuted = Color(0xFF64748B); // Slate 500
  static const Color lightTextSubtle = Color(0xFF94A3B8); // Slate 400

  /// Resolves the active [AppColorPalette] from the [BuildContext].
  static AppColorPalette of(BuildContext context) {
    final isDark = AppThemeStore.instance.isDarkMode(context);
    return fromBrightness(isDark);
  }

  /// Resolves the active [AppColorPalette] based on [isDark] flag.
  static AppColorPalette fromBrightness(bool isDark) => isDark ? dark : light;

  /// Direct helper getters for widgets taking a boolean [isDark].
  static Color background(bool isDark) => isDark ? darkScaffoldBg : lightScaffoldBg;
  static Color surface(bool isDark) => isDark ? darkCard : lightCard;
  static Color surfaceCard(bool isDark) => isDark ? darkCard : lightCard;
  static Color chipUnselected(bool isDark) => isDark ? darkSurfaceVariant : lightSurfaceVariant;
  static Color border(bool isDark) => isDark ? darkBorder : lightBorder;
  static Color borderSubtle(bool isDark) => isDark ? darkBorderSubtle : lightBorderSubtle;
  static Color textPrimary(bool isDark) => isDark ? darkTextPrimary : lightTextPrimary;
  static Color textSecondary(bool isDark) => isDark ? darkTextSecondary : lightTextSecondary;
  static Color textMuted(bool isDark) => isDark ? darkTextMuted : lightTextMuted;
  static Color drawerBg(bool isDark) => isDark ? darkDrawerBg : lightDrawerBg;
  static Color footerBg(bool isDark) => isDark ? darkCard : lightScaffoldBg;

  /// Complete dark color palette instance.
  static const AppColorPalette dark = AppColorPalette(
    isDark: true,
    scaffoldBg: darkScaffoldBg,
    drawerBg: darkDrawerBg,
    cardBg: darkCard,
    surfaceVariant: darkSurfaceVariant,
    chipBg: darkSurfaceVariant,
    border: darkBorder,
    borderSubtle: darkBorderSubtle,
    textPrimary: darkTextPrimary,
    textSecondary: darkTextSecondary,
    textMuted: darkTextMuted,
    textSubtle: darkTextSubtle,
    bannerBg: Color(0x1F6366F1), // 12% alpha
    bannerBorder: Color(0x596366F1), // 35% alpha
    bannerText: Color(0xFFE0E7FF),
    badgeBg: Color(0x386366F1), // 22% alpha
    badgeBorder: Color(0x736366F1), // 45% alpha
    badgeText: primaryTextLight,
    chipSelectedBg: Color(0x386366F1), // 22% alpha
    chipSelectedBorder: Color(0xFF818CF8),
    chipSelectedText: Colors.white,
    switchActiveBg: Color(0xFF6366F1),
    switchActiveText: Colors.white,
  );

  /// Complete light color palette instance.
  static const AppColorPalette light = AppColorPalette(
    isDark: false,
    scaffoldBg: lightScaffoldBg,
    drawerBg: lightDrawerBg,
    cardBg: lightCard,
    surfaceVariant: lightSurfaceVariant,
    chipBg: lightSurfaceVariant,
    border: lightBorder,
    borderSubtle: lightBorderSubtle,
    textPrimary: lightTextPrimary,
    textSecondary: lightTextSecondary,
    textMuted: lightTextMuted,
    textSubtle: lightTextSubtle,
    bannerBg: Color(0x146366F1), // 8% alpha
    bannerBorder: Color(0x406366F1), // 25% alpha
    bannerText: primaryText,
    badgeBg: Color(0x1F6366F1), // 12% alpha
    badgeBorder: Color(0x4D6366F1), // 30% alpha
    badgeText: primaryDark,
    chipSelectedBg: Color(0x266366F1), // 15% alpha
    chipSelectedBorder: Color(0xFF6366F1),
    chipSelectedText: Color(0xFF1E1B4B),
    switchActiveBg: Color(0xFF6366F1),
    switchActiveText: Colors.white,
  );
}

/// Immutable semantic color set representing the active theme appearance.
class AppColorPalette {
  final bool isDark;
  final Color scaffoldBg;
  final Color drawerBg;
  final Color cardBg;
  final Color surfaceVariant;
  final Color chipBg;
  final Color border;
  final Color borderSubtle;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textSubtle;
  final Color bannerBg;
  final Color bannerBorder;
  final Color bannerText;
  final Color badgeBg;
  final Color badgeBorder;
  final Color badgeText;
  final Color chipSelectedBg;
  final Color chipSelectedBorder;
  final Color chipSelectedText;
  final Color switchActiveBg;
  final Color switchActiveText;

  const AppColorPalette({
    required this.isDark,
    required this.scaffoldBg,
    required this.drawerBg,
    required this.cardBg,
    required this.surfaceVariant,
    required this.chipBg,
    required this.border,
    required this.borderSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textSubtle,
    required this.bannerBg,
    required this.bannerBorder,
    required this.bannerText,
    required this.badgeBg,
    required this.badgeBorder,
    required this.badgeText,
    required this.chipSelectedBg,
    required this.chipSelectedBorder,
    required this.chipSelectedText,
    required this.switchActiveBg,
    required this.switchActiveText,
  });
}
