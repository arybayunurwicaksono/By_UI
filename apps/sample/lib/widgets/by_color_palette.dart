import 'package:flutter/material.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';

/// Representation of an individual item displayed in [ByColorPalette].
class ByColorPaletteItem {
  /// The optional display name or tooltip description.
  final String? label;

  /// The solid background color (mutually exclusive with [gradient] if gradient is provided).
  final Color? color;

  /// The gradient background fill.
  final Gradient? gradient;

  /// The underlying value represented by this swatch item.
  final dynamic value;

  const ByColorPaletteItem({
    this.label,
    this.color,
    this.gradient,
    this.value,
  });

  /// Creates a palette item from a [ShowcaseThemePreset].
  factory ByColorPaletteItem.fromPreset(ShowcaseThemePreset preset) {
    return ByColorPaletteItem(
      label: preset.name,
      color: preset.color,
      gradient: preset.gradient,
      value: preset,
    );
  }

  /// Creates a palette item from a [ShowcaseColorOption].
  factory ByColorPaletteItem.fromOption(ShowcaseColorOption option) {
    return ByColorPaletteItem(
      label: option.name,
      color: option.color,
      value: option,
    );
  }

  /// Creates a palette item from a solid [Color].
  factory ByColorPaletteItem.fromColor(Color color, [String? label]) {
    return ByColorPaletteItem(
      label: label,
      color: color,
      value: color,
    );
  }
}

/// Standardized, universal color palette swatch picker for ByUI showcase screens.
///
/// Design Specification:
/// - **Unselected**: Full size circular swatch (default 36x36), subtle 1px border, NO shadow.
/// - **Selected (`isSelected`)**:
///   - Completely borderless (`border: null`).
///   - Completely shadow-free (`boxShadow: null`) to avoid scroll-boundary clipping.
///   - Shrinks in size (default 30x30) inside the reserved 36x36 slot.
///   - Centered checkmark icon with automatic luminance-aware contrast.
class ByColorPalette extends StatelessWidget {
  /// List of items to display as color swatches.
  final List<ByColorPaletteItem> items;

  /// Index of the currently selected swatch.
  final int selectedIndex;

  /// Callback invoked when a swatch is tapped.
  final ValueChanged<int> onSelected;

  /// The full diameter of unselected swatches. Defaults to 36.0.
  final double size;

  /// The shrunken diameter of the active/selected swatch. Defaults to 30.0.
  final double selectedSize;

  /// Spacing between swatch items. Defaults to 10.0.
  final double itemSpacing;

  /// The scroll direction. Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Optional padding around the scrollable list.
  final EdgeInsetsGeometry? padding;

  /// Creates a universal color palette picker with custom [items].
  const ByColorPalette({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.size = 36.0,
    this.selectedSize = 30.0,
    this.itemSpacing = 10.0,
    this.scrollDirection = Axis.horizontal,
    this.padding,
  });

  /// Factory constructor to build swatches directly from [ShowcaseThemePreset] presets.
  factory ByColorPalette.fromPresets({
    Key? key,
    required List<ShowcaseThemePreset> presets,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
    double size = 36.0,
    double selectedSize = 30.0,
    double itemSpacing = 10.0,
    Axis scrollDirection = Axis.horizontal,
    EdgeInsetsGeometry? padding,
  }) {
    return ByColorPalette(
      key: key,
      items: presets.map(ByColorPaletteItem.fromPreset).toList(),
      selectedIndex: selectedIndex,
      onSelected: onSelected,
      size: size,
      selectedSize: selectedSize,
      itemSpacing: itemSpacing,
      scrollDirection: scrollDirection,
      padding: padding,
    );
  }

  /// Factory constructor to build swatches directly from [ShowcaseColorOption] options.
  factory ByColorPalette.fromOptions({
    Key? key,
    required List<ShowcaseColorOption> options,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
    double size = 36.0,
    double selectedSize = 30.0,
    double itemSpacing = 10.0,
    Axis scrollDirection = Axis.horizontal,
    EdgeInsetsGeometry? padding,
  }) {
    return ByColorPalette(
      key: key,
      items: options.map(ByColorPaletteItem.fromOption).toList(),
      selectedIndex: selectedIndex,
      onSelected: onSelected,
      size: size,
      selectedSize: selectedSize,
      itemSpacing: itemSpacing,
      scrollDirection: scrollDirection,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeStore.instance.isDarkMode(context);
    final colors = AppColors.of(context);

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(items.length, (index) {
        final isSelected = selectedIndex == index;
        final item = items[index];
        final color = item.color;
        final gradient = item.gradient;
        final isWhite = color == Colors.white;

        final isLight = gradient == null &&
            color != null &&
            (color.computeLuminance() > 0.6 || isWhite);

        final iconColor = isLight ? const Color(0xFF0F172A) : Colors.white;

        Widget swatch = Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            width: isSelected ? selectedSize : size,
            height: isSelected ? selectedSize : size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gradient == null ? color : null,
              gradient: gradient,
              border: isSelected
                  ? null
                  : Border.all(
                      color: isWhite && !isDark
                          ? colors.border
                          : colors.borderSubtle,
                      width: 1.0,
                    ),
              // Strictly no boxShadow to prevent clipping at scroll boundaries
            ),
            child: isSelected
                ? Center(
                    child: Icon(
                      AppIcons.checkRaw,
                      size: (selectedSize * 0.62).clamp(12.0, 20.0),
                      color: iconColor,
                    ),
                  )
                : null,
          ),
        );

        Widget itemWidget = Container(
          margin: EdgeInsets.only(
            right: index == items.length - 1 ? 0 : itemSpacing,
          ),
          width: size,
          height: size,
          child: GestureDetector(
            key: item.label != null ? ValueKey('theme_${item.label}') : null,
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelected(index),
            child: swatch,
          ),
        );

        if (item.label != null && item.label!.isNotEmpty) {
          itemWidget = Tooltip(
            message: item.label!,
            child: itemWidget,
          );
        }

        return itemWidget;
      }),
    );

    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      padding: padding,
      child: row,
    );
  }
}
