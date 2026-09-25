import 'package:flutter/material.dart';

/// Item model for use with [BySelectOptionGroup].
class BySelectOptionItem<T> {
  /// The underlying value represented by this option.
  final T value;

  /// The text label displayed on the option chip.
  final String label;

  /// Optional icon or widget displayed to the left of the label.
  final Widget? icon;

  /// Optional widget key for test identification.
  final Key? key;

  /// Creates a [BySelectOptionItem].
  const BySelectOptionItem({
    required this.value,
    required this.label,
    this.icon,
    this.key,
  });
}

/// A sleek, compact select option chip widget following ByUI design standards.
///
/// When selected, it highlights with a distinct border and subtle background tint,
/// avoiding heavy solid primary fill colors for a modern, lightweight look.
class BySelectOption extends StatelessWidget {
  /// The label text or widget to display.
  final Widget label;

  /// Whether this option is currently selected.
  final bool isSelected;

  /// Callback triggered when this option is tapped.
  final VoidCallback? onTap;

  /// Optional icon or widget placed before the label.
  final Widget? icon;

  /// Border color when selected. Defaults to ByUI primary indigo (`Color(0xFF6366F1)`).
  final Color? selectedBorderColor;

  /// Border color when unselected. Defaults to subtle border (`Color(0x2A94A3B8)`).
  final Color? unselectedBorderColor;

  /// Background color when selected. Defaults to a subtle tint of [selectedBorderColor].
  final Color? selectedBackgroundColor;

  /// Background color when unselected. Defaults to transparent.
  final Color? unselectedBackgroundColor;

  /// Text and icon color when selected. Defaults to [selectedBorderColor].
  final Color? selectedTextColor;

  /// Text and icon color when unselected. Defaults to muted slate (`Color(0xFF64748B)`).
  final Color? unselectedTextColor;

  /// Padding inside the option chip. Defaults to `EdgeInsets.symmetric(horizontal: 10, vertical: 6)`.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the chip corners. Defaults to `BorderRadius.circular(10)`.
  final BorderRadius? borderRadius;

  /// Border line width. Defaults to `1.2`.
  final double borderWidth;

  /// Animation duration for state transitions. Defaults to `200ms`.
  final Duration duration;

  /// Animation curve. Defaults to [Curves.easeInOut].
  final Curve curve;

  /// Creates a [BySelectOption] chip.
  const BySelectOption({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.icon,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.padding,
    this.borderRadius,
    this.borderWidth = 1.2,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveSelectedBorder =
        selectedBorderColor ?? const Color(0xFF6366F1);
    final effectiveUnselectedBorder =
        unselectedBorderColor ?? const Color(0x2A94A3B8);

    final effectiveSelectedBg = selectedBackgroundColor ??
        effectiveSelectedBorder.withValues(alpha: isDark ? 0.20 : 0.12);
    final effectiveUnselectedBg =
        unselectedBackgroundColor ?? Colors.transparent;

    final effectiveSelectedText =
        selectedTextColor ?? (isDark ? Colors.white : Colors.black);
    final effectiveUnselectedText =
        unselectedTextColor ?? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    final effectiveRadius = borderRadius ?? BorderRadius.circular(10);
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: effectiveRadius,
        onTap: onTap,
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: isSelected ? effectiveSelectedBg : effectiveUnselectedBg,
            borderRadius: effectiveRadius,
            border: Border.all(
              color: isSelected
                  ? effectiveSelectedBorder
                  : effectiveUnselectedBorder,
              width: borderWidth,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final textWidget = DefaultTextStyle(
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? effectiveSelectedText
                      : effectiveUnselectedText,
                ),
                child: label,
              );

              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    IconTheme.merge(
                      data: IconThemeData(
                        size: 14,
                        color: isSelected
                            ? effectiveSelectedText
                            : effectiveUnselectedText,
                      ),
                      child: icon!,
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (constraints.maxWidth.isFinite)
                    Flexible(child: textWidget)
                  else
                    textWidget,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A collection of [BySelectOption] chips displayed as a horizontal scrollable row
/// or a standard row/wrap layout.
class BySelectOptionGroup<T> extends StatelessWidget {
  /// The list of items to display.
  final List<BySelectOptionItem<T>> items;

  /// The currently selected value.
  final T? selectedValue;

  /// Callback when an item is selected.
  final ValueChanged<T>? onSelected;

  /// Whether to wrap items in a horizontal [SingleChildScrollView]. Defaults to `true`.
  final bool scrollable;

  /// Spacing between option chips. Defaults to `8.0`.
  final double spacing;

  /// Optional padding around the scrollable container.
  final EdgeInsetsGeometry padding;

  /// Custom border color when selected.
  final Color? selectedBorderColor;

  /// Custom border color when unselected.
  final Color? unselectedBorderColor;

  /// Custom background color when selected.
  final Color? selectedBackgroundColor;

  /// Custom background color when unselected.
  final Color? unselectedBackgroundColor;

  /// Custom text color when selected.
  final Color? selectedTextColor;

  /// Custom text color when unselected.
  final Color? unselectedTextColor;

  /// Custom border radius.
  final BorderRadius? borderRadius;

  /// Custom chip padding.
  final EdgeInsetsGeometry? chipPadding;

  /// Creates a [BySelectOptionGroup].
  const BySelectOptionGroup({
    super.key,
    required this.items,
    required this.selectedValue,
    this.onSelected,
    this.scrollable = true,
    this.spacing = 8.0,
    this.padding = EdgeInsets.zero,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.borderRadius,
    this.chipPadding,
  });

  @override
  Widget build(BuildContext context) {
    final chips = items.map((item) {
      final isSelected = item.value == selectedValue;
      return Padding(
        key: item.key,
        padding: EdgeInsets.only(right: spacing),
        child: BySelectOption(
          label: Text(item.label),
          isSelected: isSelected,
          icon: item.icon,
          selectedBorderColor: selectedBorderColor,
          unselectedBorderColor: unselectedBorderColor,
          selectedBackgroundColor: selectedBackgroundColor,
          unselectedBackgroundColor: unselectedBackgroundColor,
          selectedTextColor: selectedTextColor,
          unselectedTextColor: unselectedTextColor,
          borderRadius: borderRadius,
          padding: chipPadding,
          onTap: () {
            if (onSelected != null) {
              onSelected!(item.value);
            }
          },
        ),
      );
    }).toList();

    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: chips,
        ),
      );
    }

    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: chips,
      ),
    );
  }
}
