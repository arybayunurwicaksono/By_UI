import 'package:flutter/material.dart';

/// Centralized typographic models and text styles for the ByUI Showcase app.
///
/// Scaled and optimized for compact density across mobile, desktop, and web viewports.
class AppTextStyle {
  // Screen & Header Titles
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle screenHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const TextStyle screenSubtitle = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Section Headers & Card Titles
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static const TextStyle sectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
  );

  // Chips & Toggle Buttons
  static const TextStyle chipSelected = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle chipUnselected = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle pillButton = TextStyle(
    fontSize: 9.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  // Badges & Counters
  static const TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle badgeSmall = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  // Body & Paragraph Typography
  static const TextStyle body = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle captionBold = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  // Buttons & Interactive Triggers
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
  );

  // Showcase Spec Rows (Receipt / Config Summary)
  static const TextStyle specLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle specValue = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle specHighlight = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle code = TextStyle(
    fontSize: 10.5,
    fontFamily: 'monospace',
    fontWeight: FontWeight.w500,
  );
}
