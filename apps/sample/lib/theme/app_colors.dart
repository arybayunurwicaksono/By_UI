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

  // Extended Thematic & Rich Accent Palette
  static const Color deepRoyal = Color(0xFF1E1B4B);
  static const Color deepRoyalGradientStart = Color(0xFF312E81);
  static const Color emeraldDeep = Color(0xFF064E3B);
  static const Color emeraldDarkest = Color(0xFF022C22);
  static const Color crimsonDeep = Color(0xFF7F1D1D);
  static const Color crimsonDarkest = Color(0xFF450A0A);
  static const Color amberDeep = Color(0xFF78350F);
  static const Color amberDarkest = Color(0xFF451A03);
  static const Color skyDeep = Color(0xFF0C4A6E);
  static const Color skyDarkest = Color(0xFF082F49);
  static const Color skyAccent = Color(0xFF0EA5E9);
  static const Color purpleDeep = Color(0xFF3B0764);
  static const Color purpleDarkest = Color(0xFF1E0A3C);
  static const Color oceanDeep = Color(0xFF1E3A8A);
  static const Color oceanDarkest = Color(0xFF172554);
  static const Color oceanBlue = Color(0xFF2563EB);
  static const Color roseDeep = Color(0xFF831843);
  static const Color roseDarkest = Color(0xFF4C0519);
  static const Color roseAccent = Color(0xFFF43F5E);
  static const Color rosePink = Color(0xFFE11D48);
  static const Color tealDeep = Color(0xFF134E4A);
  static const Color tealDarkest = Color(0xFF042F2E);
  static const Color tealAccent = Color(0xFF14B8A6);
  static const Color obsidianDarkest = Color(0xFF020617);
  static const Color violetSunsetStart = Color(0xFF7C3AED);
  static const Color violetSunsetEnd = Color(0xFFDB2777);
  static const Color cyberNeonCyan = Color(0xFF06B6D4);

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
  static Color background(bool isDark) =>
      isDark ? darkScaffoldBg : lightScaffoldBg;
  static Color surface(bool isDark) => isDark ? darkCard : lightCard;
  static Color surfaceCard(bool isDark) => isDark ? darkCard : lightCard;
  static Color chipUnselected(bool isDark) =>
      isDark ? darkSurfaceVariant : lightSurfaceVariant;
  static Color border(bool isDark) => isDark ? darkBorder : lightBorder;
  static Color borderSubtle(bool isDark) =>
      isDark ? darkBorderSubtle : lightBorderSubtle;
  static Color textPrimary(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;
  static Color textSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;
  static Color textMuted(bool isDark) =>
      isDark ? darkTextMuted : lightTextMuted;
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

  /// Resolves the standard card background color options for showcase pickers.
  static List<ShowcaseColorOption> cardBgOptions(BuildContext context) {
    final isDark = AppThemeStore.instance.isDarkMode(context);
    final palette = fromBrightness(isDark);
    return cardBgOptionsFrom(isDark: isDark, cardBg: palette.cardBg);
  }

  /// Explicit resolver for card background color options.
  static List<ShowcaseColorOption> cardBgOptionsFrom({
    required bool isDark,
    required Color cardBg,
  }) => [
    ShowcaseColorOption('Card Slate', cardBg),
    const ShowcaseColorOption('Obsidian Dark', darkScaffoldBg),
    ShowcaseColorOption(
      'Surface Slate',
      isDark ? darkSurfaceVariant : lightSurfaceVariant,
    ),
    const ShowcaseColorOption('Deep Indigo', primaryDark),
    const ShowcaseColorOption('Midnight Blue', primaryDeep),
    const ShowcaseColorOption('Emerald Forest', success),
    const ShowcaseColorOption('Crimson Passion', error),
    const ShowcaseColorOption('Amber Sunset', warning),
    const ShowcaseColorOption('Sky Cyan', cyanAccent),
    const ShowcaseColorOption('Violet Neon', primaryAccent),
  ];

  /// Standard border gradient color stop options for card showcase.
  static const List<ShowcaseColorOption> gradientColorOptions = [
    ShowcaseColorOption('Sky Cyan', cyanAccent),
    ShowcaseColorOption('Indigo Blue', primary),
    ShowcaseColorOption('Violet Neon', primaryAccent),
    ShowcaseColorOption('Emerald Mint', success),
    ShowcaseColorOption('Amber Gold', warning),
    ShowcaseColorOption('Crimson Red', error),
    ShowcaseColorOption('Royal Ocean', info),
    ShowcaseColorOption('Pure White', Colors.white),
    ShowcaseColorOption('Pure Black', Colors.black),
  ];

  /// Standardized theme presets for ByDialog showcase and live preview.
  static const List<ShowcaseThemePreset> dialogThemePresets = [
    ShowcaseThemePreset(
      name: 'Indigo Modern',
      color: darkCard,
      accent: primary,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [deepRoyal, darkCard],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Pure White',
      color: Colors.white,
      accent: primary,
      textColor: darkCard,
      gradient: LinearGradient(
        colors: [Colors.white, lightScaffoldBg],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Deep Royal',
      color: deepRoyal,
      accent: primaryLight,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [deepRoyalGradientStart, deepRoyal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Emerald Success',
      color: emeraldDeep,
      accent: success,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [emeraldDeep, emeraldDarkest],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Crimson Danger',
      color: crimsonDeep,
      accent: error,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [crimsonDeep, crimsonDarkest],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Amber Warning',
      color: amberDeep,
      accent: warning,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [amberDeep, amberDarkest],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Sky Minimalist',
      color: skyDeep,
      accent: skyAccent,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [skyDeep, skyDarkest],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Purple Violet',
      color: purpleDeep,
      accent: primaryAccent,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [purpleDeep, purpleDarkest],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Ocean Navy',
      color: oceanDeep,
      accent: info,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [oceanDeep, oceanDarkest],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Rose Velvet',
      color: roseDeep,
      accent: roseAccent,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [roseDeep, roseDarkest],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Teal Cyber',
      color: tealDeep,
      accent: tealAccent,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [tealDeep, tealDarkest],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ShowcaseThemePreset(
      name: 'Obsidian Slate',
      color: obsidianDarkest,
      accent: darkTextMuted,
      textColor: Colors.white,
      gradient: LinearGradient(
        colors: [darkCard, obsidianDarkest],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  /// Standardized color & gradient themes for ByToast showcase.
  static const List<ShowcaseThemePreset> toastThemePresets = [
    ShowcaseThemePreset(
      name: 'Dark Slate (Solid)',
      color: darkCard,
      textColor: Colors.white,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Pure White (Solid)',
      color: Colors.white,
      textColor: darkCard,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Royal Indigo (Solid)',
      color: primaryDark,
      textColor: Colors.white,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Mint Emerald (Solid)',
      color: success,
      textColor: Colors.white,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Ruby Crimson (Solid)',
      color: error,
      textColor: Colors.white,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Amber Sunset (Solid)',
      color: warning,
      textColor: Colors.white,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Sky Cyan (Solid)',
      color: skyAccent,
      textColor: Colors.white,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Violet Neon (Solid)',
      color: primaryAccent,
      textColor: Colors.white,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Ocean Blue (Solid)',
      color: oceanBlue,
      textColor: Colors.white,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Rose Pink (Solid)',
      color: rosePink,
      textColor: Colors.white,
      gradient: null,
    ),
    ShowcaseThemePreset(
      name: 'Aurora Midnight (Gradient)',
      color: deepRoyal,
      textColor: Colors.white,
      gradient: LinearGradient(colors: [deepRoyalGradientStart, darkCard]),
    ),
    ShowcaseThemePreset(
      name: 'Sunset Violet (Gradient)',
      color: violetSunsetStart,
      textColor: Colors.white,
      gradient: LinearGradient(colors: [violetSunsetStart, violetSunsetEnd]),
    ),
    ShowcaseThemePreset(
      name: 'Cyber Neon (Gradient)',
      color: cyberNeonCyan,
      textColor: Colors.white,
      gradient: LinearGradient(colors: [cyberNeonCyan, primary]),
    ),
  ];
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

/// Represents a named color option for showcase component pickers and swatches.
class ShowcaseColorOption {
  final String name;
  final Color color;

  const ShowcaseColorOption(this.name, this.color);

  /// Allows indexed lookup for seamless backward compatibility with Map-based APIs.
  dynamic operator [](String key) {
    if (key == 'name') return name;
    if (key == 'color') return color;
    return null;
  }
}

/// Represents a standardized theme preset for showcase components (Dialog, Toast, Card, etc.).
class ShowcaseThemePreset {
  final String name;
  final Color color;
  final Color accent;
  final Color textColor;
  final Gradient? gradient;

  const ShowcaseThemePreset({
    required this.name,
    required this.color,
    this.accent = AppColors.primary,
    this.textColor = Colors.white,
    this.gradient,
  });

  /// Allows indexed lookup for seamless backward compatibility with Map-based APIs.
  dynamic operator [](String key) {
    switch (key) {
      case 'name':
        return name;
      case 'color':
        return color;
      case 'accent':
        return accent;
      case 'textColor':
        return textColor;
      case 'gradient':
        return gradient;
      default:
        return null;
    }
  }
}
