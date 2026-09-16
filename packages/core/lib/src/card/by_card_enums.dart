/// Defines variants and modes for the [ByCard] component.
library by_card_enums;

/// Specifies visual behavior and sensor interaction modes of [ByCard].
enum ByCardVariant {
  /// Standard card with solid background, optional solid border, and standard box shadows.
  /// Does not consume sensor resources.
  normal,

  /// Card featuring a static gradient border and directional ambient glow.
  /// Angle is fixed or manually configured without sensor tracking.
  gradient,

  /// Spatial card with gradient border and glow that dynamically rotate and shift
  /// according to physical device orientation (accelerometer/gyroscope) or pointer hover.
  dynamicSensor,
}

/// The active tilt tracking source driving the spatial lighting of [ByCard].
enum ByTiltSource {
  /// Physical accelerometer/gyroscope sensors from mobile devices.
  sensor,

  /// Desktop/Web cursor hover position.
  hover,

  /// Explicit manual offset override (useful for testing, sliders, or fixed angles).
  manual,

  /// Static orientation with no motion updates.
  none,
}
