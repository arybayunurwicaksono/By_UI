/// Defines where the toast stack should anchor on the screen.
enum ByToastPosition {
  /// Toast stack anchors near the top (below AppBar or top SafeArea).
  /// Newer items appear at the top and push older items downward.
  top,

  /// Toast stack anchors near the bottom (above bottom bar or bottom SafeArea).
  /// Newer items appear at the bottom and push older items upward.
  bottom,
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
