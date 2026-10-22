import 'package:flutter/material.dart';

/// Visual style for active item indicator in [BySidebar].
enum BySidebarIndicatorStyle {
  /// Filled container background with rounded corners (default).
  fill,

  /// Sleek vertical accent pill bar docked along the leading edge.
  leadingBar,

  /// Subtle outline border around the item without a heavy fill.
  outline,
}

/// Navigation item model for [ByVerticalSidebar].
class BySidebarItem {
  /// The icon glyph representing the sidebar destination.
  final IconData icon;

  /// Optional custom widget icon taking precedence over [icon].
  final Widget? customIcon;

  /// Semantic text label.
  final String label;

  /// Optional badge pill text (e.g. "PRO", "9+").
  final String? badge;

  /// Optional custom badge background color.
  final Color? badgeColor;

  /// Optional custom badge text color.
  final Color? badgeTextColor;

  /// Whether this item represents a separator divider rather than a clickable route.
  final bool isDivider;

  /// Whether this item represents a category/section header label.
  final bool isSectionHeader;

  /// Optional custom trailing widget (e.g. keyboard shortcut chip `⌘K`, icon, switch).
  final Widget? trailing;

  /// Optional custom active theme color for this specific item.
  final Color? activeColor;

  /// Optional custom route identifier or metadata tag.
  final String? id;

  /// Whether this item is enabled and interactable. Defaults to true.
  final bool enabled;

  /// Creates a [BySidebarItem].
  const BySidebarItem({
    required this.icon,
    required this.label,
    this.customIcon,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    this.isDivider = false,
    this.isSectionHeader = false,
    this.trailing,
    this.activeColor,
    this.id,
    this.enabled = true,
  });

  /// Factory constructor for a clean section divider line.
  const BySidebarItem.divider()
      : icon = Icons.remove,
        customIcon = null,
        label = '',
        badge = null,
        badgeColor = null,
        badgeTextColor = null,
        isDivider = true,
        isSectionHeader = false,
        trailing = null,
        activeColor = null,
        id = null,
        enabled = true;

  /// Factory constructor for a category section header.
  ///
  /// In expanded mode, renders an uppercase muted section title.
  /// In collapsed mode, renders a subtle micro-divider spacer.
  const BySidebarItem.section(String title)
      : icon = Icons.remove,
        customIcon = null,
        label = title,
        badge = null,
        badgeColor = null,
        badgeTextColor = null,
        isDivider = false,
        isSectionHeader = true,
        trailing = null,
        activeColor = null,
        id = null,
        enabled = true;
}

/// Placement position for [ByVerticalSidebar].
enum BySidebarPosition {
  /// Docked on the left screen edge.
  left,

  /// Docked on the right screen edge.
  right,
}

/// Placement position for the collapse/expand toggle controls.
enum BySidebarTogglePlacement {
  /// Bottom full-width action tile (default).
  bottom,

  /// In the top header bar.
  header,

  /// No built-in toggle button (managed externally).
  none,
}

/// A desktop/tablet navigation sidebar featuring real-time cursor proximity
/// border tracking, spotlight ambient backlight spill, and fluid collapsible layout modes.
class BySidebar extends StatefulWidget {
  /// The list of items rendered in the sidebar.
  final List<BySidebarItem> items;

  /// Placement position of the sidebar (left or right). Defaults to [BySidebarPosition.left].
  final BySidebarPosition position;

  /// Currently selected item index.
  final int selectedIndex;

  /// Callback fired when an item is selected.
  final ValueChanged<int> onItemSelected;

  /// Whether the sidebar is in its collapsed (icon-only) state.
  final bool isCollapsed;

  /// Callback fired when the collapse toggle button is pressed.
  final VoidCallback? onToggleCollapse;

  /// Width when expanded. Defaults to 240.0.
  final double expandedWidth;

  /// Width when collapsed. Defaults to 72.0.
  final double collapsedWidth;

  /// Background color of the sidebar surface.
  final Color? backgroundColor;

  /// Outer border color.
  final Color? borderColor;

  /// Outer border stroke width. Defaults to 1.0.
  final double borderWidth;

  /// Active item accent theme color.
  final Color? activeColor;

  /// Corner radius for individual sidebar item rows. Defaults to 10.0.
  final BorderRadius itemBorderRadius;

  /// Optional custom padding inside each sidebar item row.
  final EdgeInsetsGeometry? itemPadding;

  /// Vertical spacing between sidebar item rows. Defaults to 6.0.
  final double itemSpacing;

  /// Background color for the selected item row.
  final Color? selectedItemBackgroundColor;

  /// Background color for hovered item rows.
  final Color? hoverItemBackgroundColor;

  /// Custom text color for the selected item label.
  final Color? selectedTextColor;

  /// Custom text color for unselected item labels.
  final Color? unselectedTextColor;

  /// Custom icon color for the selected item icon.
  final Color? selectedIconColor;

  /// Custom icon color for unselected item icons.
  final Color? unselectedIconColor;

  /// Whether to render the spotlight radial spill behind hovered/active items.
  final bool enableSpotlightSpill;

  /// Radius for the radial spotlight glow spill. Defaults to 120.0.
  final double spotlightRadius;

  /// Color of the spotlight radial backlight spill.
  final Color? spotlightColor;

  /// Opacity multiplier for the spotlight radial spill.
  final double? spotlightOpacity;

  /// Whether to illuminate the vertical trailing border coordinate near the mouse cursor.
  final bool enableCursorBorderTracking;

  /// Height of the illuminated trailing border glow segment. Defaults to 100.0.
  final double cursorBorderGlowHeight;

  /// Stroke width of the illuminated trailing border segment. Defaults to 2.0.
  final double cursorBorderWidth;

  /// Color of the illuminated trailing border segment.
  final Color? cursorBorderColor;

  /// Optional container corner radius if used as a floating or card sidebar.
  final BorderRadius? borderRadius;

  /// Default background color for item badges.
  final Color? badgeColor;

  /// Default text color for item badges.
  final Color? badgeTextColor;

  /// Optional custom header widget (e.g. brand logo).
  final Widget? header;

  /// Optional custom footer widget (e.g. user profile avatar).
  final Widget? footer;

  /// Placement position for the collapse/expand toggle controls.
  /// Defaults to [BySidebarTogglePlacement.bottom].
  final BySidebarTogglePlacement togglePlacement;

  /// Whether to allow horizontal swipe/drag gestures to expand or collapse.
  /// Defaults to true.
  final bool enableSwipeGesture;

  /// Whether hovering over the collapsed sidebar expands it temporarily as a preview overlay.
  ///
  /// When true, the sidebar defaults to collapsed mode, expands purely on cursor hover,
  /// and automatically hides manual collapse toggle buttons to avoid interaction ambiguity.
  /// Defaults to false.
  final bool enableHoverExpand;

  /// Callback fired when the hover-expand state changes.
  final ValueChanged<bool>? onHoverExpandChanged;

  /// Custom label shown on the collapse toggle tile when expanded.
  /// Defaults to 'Collapse'.
  final String collapseLabel;

  /// Custom label shown on the expand tooltip.
  /// Defaults to 'Expand'.
  final String expandLabel;

  /// Visual style of the active item indicator. Defaults to [BySidebarIndicatorStyle.fill].
  final BySidebarIndicatorStyle indicatorStyle;

  /// Width of the vertical accent bar when [indicatorStyle] is [BySidebarIndicatorStyle.leadingBar].
  /// Defaults to 3.5.
  final double leadingBarWidth;

  /// Custom typography style for section headers created with [BySidebarItem.section].
  final TextStyle? sectionTextStyle;

  /// Transition duration when toggling collapsed/expanded state.
  final Duration animationDuration;

  /// Creates a [ByVerticalSidebar].
  const BySidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.position = BySidebarPosition.left,
    this.isCollapsed = false,
    this.onToggleCollapse,
    this.expandedWidth = 240.0,
    this.collapsedWidth = 72.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.activeColor,
    this.itemBorderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.itemPadding,
    this.itemSpacing = 6.0,
    this.selectedItemBackgroundColor,
    this.hoverItemBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.enableSpotlightSpill = true,
    this.spotlightRadius = 120.0,
    this.spotlightColor,
    this.spotlightOpacity,
    this.enableCursorBorderTracking = true,
    this.cursorBorderGlowHeight = 100.0,
    this.cursorBorderWidth = 2.0,
    this.cursorBorderColor,
    this.borderRadius,
    this.badgeColor,
    this.badgeTextColor,
    this.header,
    this.footer,
    this.animationDuration = const Duration(milliseconds: 280),
    this.togglePlacement = BySidebarTogglePlacement.bottom,
    this.enableSwipeGesture = true,
    this.enableHoverExpand = false,
    this.onHoverExpandChanged,
    this.collapseLabel = 'Collapse',
    this.expandLabel = 'Expand',
    this.indicatorStyle = BySidebarIndicatorStyle.fill,
    this.leadingBarWidth = 3.5,
    this.sectionTextStyle,
  });

  @override
  State<BySidebar> createState() => _BySidebarState();
}

class _BySidebarState extends State<BySidebar> {
  Offset? _cursorPosition;
  int? _hoveredIndex;
  bool _isHoverExpanded = false;
  bool _isToggleHovered = false;
  bool _isHeaderToggleHovered = false;
  double _dragDelta = 0.0;

  bool get _effectiveCollapsed {
    if (widget.enableHoverExpand) {
      return !_isHoverExpanded;
    }
    return widget.isCollapsed;
  }

  void _setHoverExpanded(bool value) {
    if (_isHoverExpanded != value) {
      setState(() {
        _isHoverExpanded = value;
      });
      widget.onHoverExpandChanged?.call(value);
    }
  }

  @override
  void didUpdateWidget(covariant BySidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enableHoverExpand && _isHoverExpanded) {
      _isHoverExpanded = false;
    }
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    if (!widget.enableSwipeGesture ||
        widget.enableHoverExpand ||
        widget.onToggleCollapse == null) {
      return;
    }
    final vx = details.primaryVelocity ?? 0.0;
    final delta = _dragDelta;
    _dragDelta = 0.0;

    final isLeft = widget.position == BySidebarPosition.left;
    final isSwipingOutward =
        isLeft ? (vx > 150 || delta > 30) : (vx < -150 || delta < -30);
    final isSwipingInward =
        isLeft ? (vx < -150 || delta < -30) : (vx > 150 || delta > 30);

    if (isSwipingInward && !widget.isCollapsed) {
      widget.onToggleCollapse!();
    } else if (isSwipingOutward && widget.isCollapsed) {
      widget.onToggleCollapse!();
    }
  }

  Widget? _buildHeaderSlot({
    required Color borderCol,
    required Color activeCol,
    required bool isBgLight,
    required bool showHeaderToggle,
  }) {
    if (widget.header == null && !showHeaderToggle) return null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 110 || _effectiveCollapsed;

        if (!showHeaderToggle) return widget.header!;

        final isLeft = widget.position == BySidebarPosition.left;
        final toggleIcon = isLeft
            ? (_effectiveCollapsed
                ? Icons.chevron_right_rounded
                : Icons.chevron_left_rounded)
            : (_effectiveCollapsed
                ? Icons.chevron_left_rounded
                : Icons.chevron_right_rounded);

        final toggleTooltip =
            _effectiveCollapsed ? widget.expandLabel : widget.collapseLabel;

        final toggleBtn = MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHeaderToggleHovered = true),
          onExit: (_) => setState(() => _isHeaderToggleHovered = false),
          child: Tooltip(
            message: toggleTooltip,
            waitDuration: const Duration(milliseconds: 300),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onToggleCollapse,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _isHeaderToggleHovered
                      ? activeCol.withValues(alpha: isBgLight ? 0.08 : 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isHeaderToggleHovered
                        ? activeCol.withValues(alpha: 0.5)
                        : borderCol.withValues(alpha: 0.6),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  toggleIcon,
                  size: 18,
                  color: _isHeaderToggleHovered
                      ? activeCol
                      : (isBgLight
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8)),
                ),
              ),
            ),
          ),
        );

        if (widget.header == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Align(
              alignment: isNarrow
                  ? Alignment.center
                  : (isLeft ? Alignment.centerRight : Alignment.centerLeft),
              child: toggleBtn,
            ),
          );
        }

        if (isNarrow) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.header!,
                const SizedBox(height: 8),
                toggleBtn,
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Expanded(child: widget.header!),
              const SizedBox(width: 8),
              toggleBtn,
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomToggleTile({
    required bool isBgLight,
    required Color borderCol,
    required Color activeCol,
    required Color unselectedTextColor,
    required Color unselectedIconColor,
  }) {
    final isLeft = widget.position == BySidebarPosition.left;
    final iconData = isLeft
        ? (_effectiveCollapsed
            ? Icons.chevron_right_rounded
            : Icons.chevron_left_rounded)
        : (_effectiveCollapsed
            ? Icons.chevron_left_rounded
            : Icons.chevron_right_rounded);

    final label =
        _effectiveCollapsed ? widget.expandLabel : widget.collapseLabel;
    final hoverBg = widget.hoverItemBackgroundColor ??
        activeCol.withValues(alpha: isBgLight ? 0.06 : 0.12);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 110 || _effectiveCollapsed;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isToggleHovered = true),
            onExit: (_) => setState(() => _isToggleHovered = false),
            child: Tooltip(
              message: label,
              waitDuration: const Duration(milliseconds: 300),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onToggleCollapse,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 40,
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.symmetric(
                    horizontal: isNarrow ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: _isToggleHovered ? hoverBg : Colors.transparent,
                    borderRadius: widget.itemBorderRadius,
                    border: Border.all(
                      color: _isToggleHovered
                          ? activeCol.withValues(alpha: 0.4)
                          : borderCol.withValues(alpha: 0.7),
                      width: 1.0,
                    ),
                  ),
                  child: isNarrow
                      ? Center(
                          child: Icon(
                            iconData,
                            size: 20,
                            color: _isToggleHovered
                                ? activeCol
                                : unselectedIconColor,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              iconData,
                              size: 20,
                              color: _isToggleHovered
                                  ? activeCol
                                  : unselectedIconColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _isToggleHovered
                                      ? (isBgLight
                                          ? const Color(0xFF0F172A)
                                          : Colors.white)
                                      : unselectedTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC));
    final isBgLight = bgColor.computeLuminance() > 0.5;
    final borderCol = widget.borderColor ??
        (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));
    final activeCol = widget.activeColor ??
        (isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5));

    final currentWidth =
        _effectiveCollapsed ? widget.collapsedWidth : widget.expandedWidth;

    final effectiveSpotlightColor = widget.spotlightColor ?? activeCol;
    final defaultSpotlightAlpha = isBgLight ? 0.05 : 0.08;
    final effectiveSpotlightAlpha =
        widget.spotlightOpacity ?? defaultSpotlightAlpha;

    final effectiveCursorBorderColor = widget.cursorBorderColor ?? activeCol;

    final defaultUnselectedTextColor = widget.unselectedTextColor ??
        (isBgLight ? const Color(0xFF334155) : const Color(0xFFCBD5E1));
    final defaultUnselectedIconColor = widget.unselectedIconColor ??
        (isBgLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8));

    final showBottomToggle = widget.onToggleCollapse != null &&
        !widget.enableHoverExpand &&
        widget.togglePlacement == BySidebarTogglePlacement.bottom;

    final showHeaderToggle = widget.onToggleCollapse != null &&
        !widget.enableHoverExpand &&
        widget.togglePlacement == BySidebarTogglePlacement.header;

    final headerWidget = _buildHeaderSlot(
      borderCol: borderCol,
      activeCol: activeCol,
      isBgLight: isBgLight,
      showHeaderToggle: showHeaderToggle,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart:
          widget.enableSwipeGesture ? (_) => _dragDelta = 0.0 : null,
      onHorizontalDragUpdate: widget.enableSwipeGesture
          ? (details) => _dragDelta += details.primaryDelta ?? 0.0
          : null,
      onHorizontalDragEnd:
          widget.enableSwipeGesture ? _handleHorizontalDragEnd : null,
      onHorizontalDragCancel:
          widget.enableSwipeGesture ? () => _dragDelta = 0.0 : null,
      child: MouseRegion(
        onEnter: (_) {
          if (widget.enableHoverExpand && !_isHoverExpanded) {
            _setHoverExpanded(true);
          }
        },
        onHover: (event) {
          if (widget.enableHoverExpand && !_isHoverExpanded) {
            _setHoverExpanded(true);
          }
          setState(() {
            _cursorPosition = event.localPosition;
          });
        },
        onExit: (_) {
          setState(() {
            _cursorPosition = null;
            _hoveredIndex = null;
          });
          if (_isHoverExpanded) {
            _setHoverExpanded(false);
          }
        },
        child: AnimatedContainer(
          duration: widget.animationDuration,
          curve: Curves.easeOutCubic,
          width: currentWidth,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: widget.borderRadius,
            border: widget.borderWidth > 0
                ? (widget.position == BySidebarPosition.left
                    ? Border(
                        right: BorderSide(
                          color: borderCol,
                          width: widget.borderWidth,
                        ),
                      )
                    : Border(
                        left: BorderSide(
                          color: borderCol,
                          width: widget.borderWidth,
                        ),
                      ))
                : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Spotlight Ambient Spill Layer
              if (widget.enableSpotlightSpill && _cursorPosition != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _SidebarSpotlightPainter(
                      cursorPosition: _cursorPosition!,
                      color: effectiveSpotlightColor.withValues(
                        alpha: effectiveSpotlightAlpha,
                      ),
                      radius: widget.spotlightRadius,
                    ),
                  ),
                ),

              // 2. Main Content (Header, Items, Bottom Toggle, Footer)
              Column(
                children: [
                  // Header Slot
                  if (headerWidget != null) headerWidget,

                  // Items List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      itemCount: widget.items.length,
                      separatorBuilder: (context, index) {
                        if (widget.items[index].isDivider) {
                          return const SizedBox(height: 4);
                        }
                        return SizedBox(height: widget.itemSpacing);
                      },
                      itemBuilder: (context, index) {
                        final item = widget.items[index];

                        if (item.isDivider) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(
                              color: borderCol,
                              height: 1,
                              thickness: 1,
                            ),
                          );
                        }

                        if (item.isSectionHeader) {
                          if (_effectiveCollapsed) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Container(
                                  width: 18,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: borderCol.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 14.0,
                              bottom: 6.0,
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: Text(
                              item.label.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: widget.sectionTextStyle ??
                                  TextStyle(
                                    color: isBgLight
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF94A3B8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.1,
                                  ),
                            ),
                          );
                        }

                        final isSelected = widget.selectedIndex == index;
                        final isHovered = _hoveredIndex == index;
                        final itemActiveColor = item.activeColor ?? activeCol;

                        final Color selectedBg;
                        final Border selectedBorder;
                        switch (widget.indicatorStyle) {
                          case BySidebarIndicatorStyle.leadingBar:
                            selectedBg = widget.selectedItemBackgroundColor ??
                                itemActiveColor.withValues(
                                  alpha: isBgLight ? 0.06 : 0.10,
                                );
                            selectedBorder = Border.all(
                              color: Colors.transparent,
                              width: 1.0,
                            );
                            break;
                          case BySidebarIndicatorStyle.outline:
                            selectedBg = widget.selectedItemBackgroundColor ??
                                Colors.transparent;
                            selectedBorder = Border.all(
                              color: itemActiveColor,
                              width: 1.2,
                            );
                            break;
                          case BySidebarIndicatorStyle.fill:
                            selectedBg = widget.selectedItemBackgroundColor ??
                                itemActiveColor.withValues(
                                  alpha: isBgLight ? 0.12 : 0.18,
                                );
                            selectedBorder = Border.all(
                              color: isSelected
                                  ? itemActiveColor.withValues(alpha: 0.5)
                                  : Colors.transparent,
                              width: 1.0,
                            );
                            break;
                        }

                        final hoverBg = widget.hoverItemBackgroundColor ??
                            itemActiveColor.withValues(
                              alpha: isBgLight ? 0.05 : 0.08,
                            );

                        final effectiveSelectedTextColor =
                            widget.selectedTextColor ??
                                (isBgLight
                                    ? const Color(0xFF0F172A)
                                    : Colors.white);
                        final effectiveUnselectedTextColor =
                            widget.unselectedTextColor ??
                                (isBgLight
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFCBD5E1));

                        final effectiveSelectedIconColor =
                            widget.selectedIconColor ?? itemActiveColor;
                        final effectiveUnselectedIconColor =
                            widget.unselectedIconColor ??
                                (isBgLight
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8));

                        final itemIconColor = isSelected
                            ? effectiveSelectedIconColor
                            : effectiveUnselectedIconColor;

                        final badgeBackground = item.badgeColor ??
                            widget.badgeColor ??
                            itemActiveColor.withValues(alpha: 0.2);
                        final badgeForeground = item.badgeTextColor ??
                            widget.badgeTextColor ??
                            itemActiveColor;

                        return MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = null),
                          child: Opacity(
                            opacity: item.enabled ? 1.0 : 0.38,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: item.enabled
                                  ? () => widget.onItemSelected(index)
                                  : null,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final isNarrow = constraints.maxWidth < 110 ||
                                      _effectiveCollapsed;

                                  final defaultPadding = EdgeInsets.symmetric(
                                    horizontal: isNarrow ? 0 : 12,
                                    vertical: 10,
                                  );

                                  Widget itemRow = isNarrow
                                      ? Center(
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Center(
                                              child: item.customIcon ??
                                                  Icon(
                                                    item.icon,
                                                    size: 20,
                                                    color: itemIconColor,
                                                  ),
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: Center(
                                                child: item.customIcon ??
                                                    Icon(
                                                      item.icon,
                                                      size: 20,
                                                      color: itemIconColor,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                item.label,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? effectiveSelectedTextColor
                                                      : effectiveUnselectedTextColor,
                                                  fontSize: 13,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            if (item.badge != null) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: badgeBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  item.badge!,
                                                  style: TextStyle(
                                                    color: badgeForeground,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            if (item.trailing != null) ...[
                                              const SizedBox(width: 6),
                                              item.trailing!,
                                            ],
                                          ],
                                        );

                                  if (isNarrow && item.label.isNotEmpty) {
                                    itemRow = Tooltip(
                                      message: item.label,
                                      waitDuration:
                                          const Duration(milliseconds: 300),
                                      child: itemRow,
                                    );
                                  }

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    clipBehavior: Clip.hardEdge,
                                    padding:
                                        widget.itemPadding ?? defaultPadding,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? selectedBg
                                          : (isHovered
                                              ? hoverBg
                                              : Colors.transparent),
                                      borderRadius: widget.itemBorderRadius,
                                      border: isSelected
                                          ? selectedBorder
                                          : Border.all(
                                              color: Colors.transparent,
                                              width: 1.0,
                                            ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        itemRow,
                                        if (isSelected &&
                                            widget.indicatorStyle ==
                                                BySidebarIndicatorStyle
                                                    .leadingBar)
                                          Positioned(
                                            top: 4,
                                            bottom: 4,
                                            left: widget.position ==
                                                    BySidebarPosition.left
                                                ? 0
                                                : null,
                                            right: widget.position ==
                                                    BySidebarPosition.right
                                                ? 0
                                                : null,
                                            width: widget.leadingBarWidth,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: itemActiveColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.leadingBarWidth /
                                                            2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: itemActiveColor
                                                        .withValues(alpha: 0.4),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Toggle Tile
                  if (showBottomToggle)
                    _buildBottomToggleTile(
                      isBgLight: isBgLight,
                      borderCol: borderCol,
                      activeCol: activeCol,
                      unselectedTextColor: defaultUnselectedTextColor,
                      unselectedIconColor: defaultUnselectedIconColor,
                    ),

                  // Footer Slot
                  if (widget.footer != null) widget.footer!,
                ],
              ),

              // 3. Trailing Cursor Proximity Illuminated Border
              if (widget.enableCursorBorderTracking && _cursorPosition != null)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: widget.position == BySidebarPosition.right ? 0 : null,
                  right: widget.position == BySidebarPosition.left ? 0 : null,
                  width: widget.cursorBorderWidth,
                  child: CustomPaint(
                    painter: _SidebarTrailingBorderPainter(
                      cursorY: _cursorPosition!.dy,
                      color: effectiveCursorBorderColor,
                      glowHeight: widget.cursorBorderGlowHeight,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarSpotlightPainter extends CustomPainter {
  final Offset cursorPosition;
  final Color color;
  final double radius;

  _SidebarSpotlightPainter({
    required this.cursorPosition,
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [
          color,
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: cursorPosition, radius: radius),
      );

    canvas.drawCircle(cursorPosition, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _SidebarSpotlightPainter oldDelegate) {
    return oldDelegate.cursorPosition != cursorPosition ||
        oldDelegate.color != color ||
        oldDelegate.radius != radius;
  }
}

class _SidebarTrailingBorderPainter extends CustomPainter {
  final double cursorY;
  final Color color;
  final double glowHeight;

  _SidebarTrailingBorderPainter({
    required this.cursorY,
    required this.color,
    required this.glowHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final top = cursorY - (glowHeight / 2);
    final bottom = cursorY + (glowHeight / 2);

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        color,
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTRB(0, top, size.width, bottom),
      )
      ..strokeWidth = size.width;

    canvas.drawLine(
      Offset(size.width / 2, top.clamp(0.0, size.height)),
      Offset(size.width / 2, bottom.clamp(0.0, size.height)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SidebarTrailingBorderPainter oldDelegate) {
    return oldDelegate.cursorY != cursorY ||
        oldDelegate.color != color ||
        oldDelegate.glowHeight != glowHeight;
  }
}

/// Backward compatibility alias for [BySidebar].
typedef ByVerticalSidebar = BySidebar;
