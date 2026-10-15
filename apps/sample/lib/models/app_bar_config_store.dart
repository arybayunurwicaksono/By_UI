import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../theme/app_theme.dart';
import '../widgets/by_dynamic_border_controls.dart';

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
  bool autoHideOnScroll = false;
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

  // 6. Pulse Dynamic Border (Traveling neon laser beam Point A -> Point A)
  final ByPulseBorderConfig pulseConfig = ByPulseBorderConfig(
    enabled: false,
    durationMs: 1400,
    beamLength: 0.28,
    width: 2.0,
    shadowBlur: 3.0,
    shadowWidth: 2.0,
    shadowLength: 0.28,
    colorAIndex: 0,
    colorBIndex: 2,
    shadowColorIndex: 0,
  );

  bool get enablePulseBorder => pulseConfig.enabled;
  set enablePulseBorder(bool val) => pulseConfig.enabled = val;

  bool pulseAutoStart = false;

  int get pulseOriginIndex => pulseConfig.origin.index;
  set pulseOriginIndex(int val) {
    if (val >= 0 && val < ByBorderOrigin.values.length) {
      pulseConfig.origin = ByBorderOrigin.values[val];
    }
  }

  ByBorderOrigin get pulseOrigin => pulseConfig.origin;
  set pulseOrigin(ByBorderOrigin val) => pulseConfig.origin = val;

  int get pulseDurationMs => pulseConfig.durationMs;
  set pulseDurationMs(int val) => pulseConfig.durationMs = val;

  double get pulseBeamLength => pulseConfig.beamLength;
  set pulseBeamLength(double val) => pulseConfig.beamLength = val;

  double get pulseWidth => pulseConfig.width;
  set pulseWidth(double val) => pulseConfig.width = val;

  double get pulseShadowBlur => pulseConfig.shadowBlur;
  set pulseShadowBlur(double val) => pulseConfig.shadowBlur = val;

  double get pulseShadowWidth => pulseConfig.shadowWidth;
  set pulseShadowWidth(double val) => pulseConfig.shadowWidth = val;

  double get pulseShadowLength => pulseConfig.shadowLength;
  set pulseShadowLength(double val) => pulseConfig.shadowLength = val;

  int get selectedPulseShadowColorIndex => pulseConfig.shadowColorIndex;
  set selectedPulseShadowColorIndex(int val) =>
      pulseConfig.shadowColorIndex = val;

  double get pulseGlowBlur => pulseShadowBlur;
  set pulseGlowBlur(double val) => pulseShadowBlur = val;

  int sensorResumeDelayMs = 300;
  int sensorEntranceDurationMs = 400;

  int get selectedPulseColorAIndex => pulseConfig.colorAIndex;
  set selectedPulseColorAIndex(int val) => pulseConfig.colorAIndex = val;

  int get selectedPulseColorBIndex => pulseConfig.colorBIndex;
  set selectedPulseColorBIndex(int val) => pulseConfig.colorBIndex = val;

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
    bool? autoHideOnScroll,
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
    bool? enablePulseBorder,
    bool? pulseAutoStart,
    int? pulseOriginIndex,
    int? pulseDurationMs,
    double? pulseBeamLength,
    double? pulseWidth,
    double? pulseShadowBlur,
    double? pulseShadowWidth,
    double? pulseShadowLength,
    int? selectedPulseShadowColorIndex,
    double? pulseGlowBlur,
    int? sensorResumeDelayMs,
    int? sensorEntranceDurationMs,
    int? selectedPulseColorAIndex,
    int? selectedPulseColorBIndex,
  }) {
    if (isFloatingEnabled != null) this.isFloatingEnabled = isFloatingEnabled;
    if (autoHideOnScroll != null) this.autoHideOnScroll = autoHideOnScroll;
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

    if (enablePulseBorder != null) this.enablePulseBorder = enablePulseBorder;
    if (pulseAutoStart != null) this.pulseAutoStart = pulseAutoStart;
    if (pulseOriginIndex != null) this.pulseOriginIndex = pulseOriginIndex;
    if (pulseDurationMs != null) this.pulseDurationMs = pulseDurationMs;
    if (pulseBeamLength != null) this.pulseBeamLength = pulseBeamLength;
    if (pulseWidth != null) this.pulseWidth = pulseWidth;
    if (pulseShadowBlur != null) this.pulseShadowBlur = pulseShadowBlur;
    if (pulseShadowWidth != null) this.pulseShadowWidth = pulseShadowWidth;
    if (pulseShadowLength != null) this.pulseShadowLength = pulseShadowLength;
    if (selectedPulseShadowColorIndex != null) {
      this.selectedPulseShadowColorIndex = selectedPulseShadowColorIndex;
    }
    if (pulseGlowBlur != null) this.pulseShadowBlur = pulseGlowBlur;
    if (sensorResumeDelayMs != null) {
      this.sensorResumeDelayMs = sensorResumeDelayMs;
    }
    if (sensorEntranceDurationMs != null) {
      this.sensorEntranceDurationMs = sensorEntranceDurationMs;
    }
    if (selectedPulseColorAIndex != null) {
      this.selectedPulseColorAIndex = selectedPulseColorAIndex;
    }
    if (selectedPulseColorBIndex != null) {
      this.selectedPulseColorBIndex = selectedPulseColorBIndex;
    }

    notifyListeners();
  }

  void resetToDefaults() {
    isFloatingEnabled = true;
    autoHideOnScroll = false;
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

    pulseConfig.reset();
    pulseAutoStart = false;
    sensorResumeDelayMs = 300;
    sensorEntranceDurationMs = 400;

    notifyListeners();
  }
}
