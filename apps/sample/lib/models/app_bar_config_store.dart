import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Specification for styling inner components inside ByAppBar (brand pill, accents, action buttons).
class ByComponentPreset {
  final String name;
  final List<Color> colors;
  final Color accent;

  const ByComponentPreset({
    required this.name,
    required this.colors,
    required this.accent,
  });

  Gradient get gradient => LinearGradient(
    colors: colors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Global singleton store holding user-selected ByAppBar configurations
/// applied dynamically across showcase screens in real-time.
class AppBarConfigStore extends ChangeNotifier {
  static final AppBarConfigStore instance = AppBarConfigStore._();
  AppBarConfigStore._();

  // 1. Floating Dynamics
  bool isFloatingEnabled = true;
  double scrollThreshold = 12.0;
  double horizontalMargin = 14.0;
  double topMargin = 8.0;
  double borderRadius = 16.0;
  double blurSigma = 16.0;

  // 2. Theming & Colors (Static Background & Floating Background)
  int selectedColorIndex = 0;
  Color? customColor;

  int selectedFloatingColorIndex = 0;
  Color? customFloatingColor;

  double floatingOpacity = 0.84;

  // 3. Elevation & Borders
  double elevation = 0.0;
  double floatingElevation = 4.0;
  bool enableBorder = false;
  double borderWidth = 1.0;
  bool centerTitle = false;

  // 4. Dynamic Cursor Lighting & Border (Reactive to cursor direction, Rule: Disabled by default, blue & cyan default gradient)
  bool enableDynamicBorder = false;
  bool get enableDynamicSensor => enableDynamicBorder;
  set enableDynamicSensor(bool val) => enableDynamicBorder = val;

  bool enableSensor = true;
  bool enableHoverTilt = true;
  bool enableInnerShadow = false;
  double innerShadowOpacity = 1.0;
  double get innerGlowOpacity => innerShadowOpacity;
  set innerGlowOpacity(double val) => innerShadowOpacity = val;
  int selectedSensorGradientIndex = 0;

  static const List<ShowcaseThemePreset> sensorGradients =
      AppColors.appBarSensorGradients;

  List<ShowcaseThemePreset> get sensorGradientPresets => sensorGradients;

  String get activeSensorGradientName =>
      sensorGradients[selectedSensorGradientIndex].name;

  Gradient get activeSensorGradient =>
      sensorGradients[selectedSensorGradientIndex].gradient!;

  // 5. Component Coloring Presets (Controls inner toolbar elements like badge pill & actions)
  int selectedComponentPresetIndex = 0;

  static const List<ByComponentPreset> componentPresetDefinitions = [
    ByComponentPreset(
      name: 'Indigo Neon (Default)',
      colors: [AppColors.primary, AppColors.primaryAccent],
      accent: AppColors.primary,
    ),
    ByComponentPreset(
      name: 'Sky Cyan & Ocean',
      colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
      accent: Color(0xFF06B6D4),
    ),
    ByComponentPreset(
      name: 'Emerald Mint',
      colors: [Color(0xFF059669), Color(0xFF10B981)],
      accent: Color(0xFF10B981),
    ),
    ByComponentPreset(
      name: 'Amber Sunset',
      colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
      accent: Color(0xFFF59E0B),
    ),
    ByComponentPreset(
      name: 'Crimson Passion',
      colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
      accent: Color(0xFFEF4444),
    ),
    ByComponentPreset(
      name: 'Royal Purple',
      colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
      accent: Color(0xFFA855F7),
    ),
  ];

  List<ByComponentPreset> get componentPresets => componentPresetDefinitions;

  ByComponentPreset get activeComponentPreset =>
      componentPresetDefinitions[selectedComponentPresetIndex];

  void update({
    bool? isFloatingEnabled,
    double? scrollThreshold,
    double? horizontalMargin,
    double? topMargin,
    double? borderRadius,
    double? blurSigma,
    int? selectedColorIndex,
    Color? customColor,
    bool clearCustomColor = false,
    int? selectedFloatingColorIndex,
    Color? customFloatingColor,
    bool clearCustomFloatingColor = false,
    double? floatingOpacity,
    double? elevation,
    double? floatingElevation,
    bool? enableBorder,
    double? borderWidth,
    bool? centerTitle,
    bool? enableDynamicBorder,
    bool? enableDynamicSensor,
    bool? enableSensor,
    bool? enableHoverTilt,
    bool? enableInnerShadow,
    double? innerShadowOpacity,
    double? innerGlowOpacity,
    int? selectedSensorGradientIndex,
    int? selectedComponentPresetIndex,
  }) {
    if (isFloatingEnabled != null) this.isFloatingEnabled = isFloatingEnabled;
    if (scrollThreshold != null) this.scrollThreshold = scrollThreshold;
    if (horizontalMargin != null) this.horizontalMargin = horizontalMargin;
    if (topMargin != null) this.topMargin = topMargin;
    if (borderRadius != null) this.borderRadius = borderRadius;
    if (blurSigma != null) this.blurSigma = blurSigma;

    if (clearCustomColor) {
      this.customColor = null;
    } else if (customColor != null) {
      this.customColor = customColor;
    }
    if (selectedColorIndex != null) {
      this.selectedColorIndex = selectedColorIndex;
    }

    if (clearCustomFloatingColor) {
      this.customFloatingColor = null;
    } else if (customFloatingColor != null) {
      this.customFloatingColor = customFloatingColor;
    }
    if (selectedFloatingColorIndex != null) {
      this.selectedFloatingColorIndex = selectedFloatingColorIndex;
    }

    if (floatingOpacity != null) this.floatingOpacity = floatingOpacity;
    if (elevation != null) this.elevation = elevation;
    if (floatingElevation != null) this.floatingElevation = floatingElevation;
    if (enableBorder != null) this.enableBorder = enableBorder;
    if (borderWidth != null) this.borderWidth = borderWidth;
    if (centerTitle != null) this.centerTitle = centerTitle;

    if (enableDynamicBorder != null) {
      this.enableDynamicBorder = enableDynamicBorder;
    }
    if (enableDynamicSensor != null) {
      this.enableDynamicBorder = enableDynamicSensor;
    }
    if (enableSensor != null) this.enableSensor = enableSensor;
    if (enableHoverTilt != null) this.enableHoverTilt = enableHoverTilt;
    if (enableInnerShadow != null) this.enableInnerShadow = enableInnerShadow;
    if (innerShadowOpacity != null) {
      this.innerShadowOpacity = innerShadowOpacity;
    }
    if (innerGlowOpacity != null) this.innerShadowOpacity = innerGlowOpacity;

    if (selectedSensorGradientIndex != null) {
      this.selectedSensorGradientIndex = selectedSensorGradientIndex;
    }
    if (selectedComponentPresetIndex != null) {
      this.selectedComponentPresetIndex = selectedComponentPresetIndex;
    }

    notifyListeners();
  }

  void resetToDefaults() {
    isFloatingEnabled = true;
    scrollThreshold = 12.0;
    horizontalMargin = 14.0;
    topMargin = 8.0;
    borderRadius = 16.0;
    blurSigma = 16.0;

    selectedColorIndex = 0;
    customColor = null;

    selectedFloatingColorIndex = 0;
    customFloatingColor = null;

    floatingOpacity = 0.84;
    elevation = 0.0;
    floatingElevation = 4.0;
    enableBorder = false;
    borderWidth = 1.0;
    centerTitle = false;

    enableDynamicBorder = false;
    enableSensor = true;
    enableHoverTilt = true;
    enableInnerShadow = false;
    innerShadowOpacity = 1.0;
    selectedSensorGradientIndex = 0;
    selectedComponentPresetIndex = 0;

    notifyListeners();
  }
}
