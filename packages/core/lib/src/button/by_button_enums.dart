/// Enums for [ByButton] styling, sizing, and transactional states.
library;

/// Visual variant presets for [ByButton].
enum ByButtonVariant {
  /// Solid filled background with subtle depth.
  filled,

  /// High-tech vibrant gradient background with soft glow.
  gradient,

  /// Transparent background with crisp perimeter border stroke.
  outline,

  /// Borderless minimal button with subtle hover/press tint.
  ghost,
}

/// Sizing presets for standardized button dimensions and typography padding.
enum ByButtonSize {
  /// Compact height (36.0px) for dense toolbars or secondary actions.
  small,

  /// Standard height (48.0px) for forms and primary actions.
  medium,

  /// Prominent height (56.0px) for hero and marketing call-to-actions.
  large,
}

/// Transactional state of the [ByButton].
enum ByButtonState {
  /// Normal interactive state.
  idle,

  /// Morphed to a circle running the 3-phase traveling pulse spinner.
  loading,

  /// Morphed circle displaying an animated success checkmark.
  success,

  /// Morphed circle displaying an animated error cross.
  error,
}
