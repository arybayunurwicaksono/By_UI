/// Defines where the tooltip or popover anchors relative to the pointer or target.
enum ByTooltipAnchor {
  /// Anchors directly to the cursor position where the pointer entered/hovered.
  /// Ideal for desktop and web tooltips and dynamic profile cards.
  cursor,

  /// Anchors to the geometric bounding box of the trigger [child] widget.
  /// Ideal for dropdown-like action menus and button attachments.
  target,
}

/// Defines the entrance and exit animation style for [ByTooltip].
enum ByTooltipAnimation {
  /// Combined fade and subtle scale pop-in (default).
  fadeAndScale,

  /// Pure fade-in/fade-out transition.
  fadeOnly,

  /// Combined slide and fade transition.
  slideAndFade,

  /// Bouncy elastic pop-in transition using back curves.
  bounce,
}

/// Defines the touch activation mode on mobile and touch devices.
enum ByMobileTrigger {
  /// A quick tap on the trigger toggles the tooltip / popover (default).
  tap,

  /// A long press (press-and-hold for ~300ms) opens the tooltip, allowing quick tap
  /// to execute primary actions like navigation or selection.
  longPress,

  /// Touch activation is disabled on mobile; only pointer hover triggers the tooltip.
  none,
}

/// Backward compatibility alias for [ByTooltipAnchor].
typedef ByHoverCardAnchor = ByTooltipAnchor;

/// Backward compatibility alias for [ByTooltipAnimation].
typedef ByHoverCardAnimation = ByTooltipAnimation;
