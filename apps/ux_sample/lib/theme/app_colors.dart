import 'package:flutter/material.dart';

/// Semantic color tokens tailored for the Cyan Light Theme UX Sample app.
abstract final class AppColors {
  // Brand Primary & Accents (Vibrant Cyan Palette)
  static const Color primary = Color(0xFF06B6D4); // Cyan 500
  static const Color primaryLight = Color(0xFFECFEFF); // Cyan 50
  static const Color primaryDark = Color(0xFF0891B2); // Cyan 600
  static const Color primaryDeep = Color(0xFF0E7490); // Cyan 700
  static const Color primaryText = Color(0xFF155E75); // Cyan 800
  static const Color primaryAccent = Color(0xFF22D3EE); // Cyan 400
  static const Color cyanAccent = Color(0xFF00E5FF); // Bright Cyan / Aqua

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successLight = Color(0xFFECFDF5); // Emerald 50
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFEF2F2); // Red 50
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFFFBEB); // Amber 50
  static const Color info = Color(0xFF0284C7); // Sky 600
  static const Color infoLight = Color(0xFFF0F9FF); // Sky 50

  // Neutral Light Surfaces & Backgrounds
  static const Color scaffoldBg = Color(0xFFF8FAFC); // Slate 50
  static const Color cardSurface = Colors.white;
  static const Color cardBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color cardBorderSubtle = Color(0xFFF1F5F9); // Slate 100
  static const Color inputBg = Color(0xFFF8FAFC);
  static const Color inputBorder = Color(0xFFCBD5E1); // Slate 300

  // Text Typography Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400

  // Laser dynamic border colors
  static const List<Color> laserColors = [
    Color(0xFF06B6D4), // Cyan 500
    Color(0xFF22D3EE), // Cyan 400
    Color(0xFF00E5FF), // Aqua Accent
  ];

  // Cyan & Blue dynamic pulse gradient tokens
  static const List<Color> cyanBlueLaserColors = [
    Color(0xFF00E5FF), // Aqua / Bright Cyan
    Color(0xFF06B6D4), // Cyan 500
    Color(0xFF0284C7), // Sky Blue 600
    Color(0xFF2563EB), // Royal Blue 600
  ];

  static const LinearGradient cyanBlueGradient = LinearGradient(
    colors: [
      Color(0xFF00E5FF), // Bright Cyan
      Color(0xFF06B6D4), // Cyan 500
      Color(0xFF0284C7), // Sky Blue 600
      Color(0xFF2563EB), // Royal Blue 600
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
