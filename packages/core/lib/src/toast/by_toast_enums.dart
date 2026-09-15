/// Defines where the toast stack should anchor on the screen.
enum ByToastPosition {
  /// Toast stack anchors near the top (below AppBar or top SafeArea).
  /// Newer items appear at the top and push older items downward.
  top,

  /// Toast stack anchors near the bottom (above bottom bar or bottom SafeArea).
  /// Newer items appear at the bottom and push older items upward.
  bottom,

  /// Toast stack anchors at the top-left corner (ideal for desktop/web).
  topLeft,

  /// Toast stack anchors at the top-right corner (ideal for desktop/web).
  topRight,

  /// Toast stack anchors at the bottom-left corner (ideal for desktop/web).
  bottomLeft,

  /// Toast stack anchors at the bottom-right corner (ideal for desktop/web).
  bottomRight;

  /// Whether this position anchors near the top edge of the screen.
  bool get isTop =>
      this == ByToastPosition.top ||
      this == ByToastPosition.topLeft ||
      this == ByToastPosition.topRight;

  /// Whether this position anchors near the bottom edge of the screen.
  bool get isBottom => !isTop;

  /// Whether this position aligns to the left corner.
  bool get isLeft =>
      this == ByToastPosition.topLeft || this == ByToastPosition.bottomLeft;

  /// Whether this position aligns to the right corner.
  bool get isRight =>
      this == ByToastPosition.topRight || this == ByToastPosition.bottomRight;

  /// Whether this position spans/centers horizontally across the screen.
  bool get isCenter => !isLeft && !isRight;
}

/// Defines the direction from which the toast slides into the screen.
enum ByToastSlideDirection {
  /// Slides in vertically from the top edge.
  fromTop,

  /// Slides in vertically from the bottom edge.
  fromBottom,

  /// Slides in horizontally from the left edge.
  fromLeft,

  /// Slides in horizontally from the right edge.
  fromRight,
}

/// Defines the animation style for toast entrance and exit.
enum ByToastAnimationType {
  /// Combined slide, fade, and subtle scale transition.
  slideAndFade,

  /// Pure slide transition without opacity/scale changes.
  slideOnly,

  /// Pure fade-in/fade-out transition.
  fadeOnly,

  /// Scale pop-in and fade transition.
  scaleAndFade,

  /// Bouncy pop-in transition using spring/back curves.
  bounce,
}

// Backward compatibility alias
typedef ByNotificationPosition = ByToastPosition;
typedef ByNotificationSlideDirection = ByToastSlideDirection;
typedef ByNotificationAnimationType = ByToastAnimationType;
