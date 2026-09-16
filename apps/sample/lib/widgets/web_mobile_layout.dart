import 'package:flutter/material.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';

/// Layout wrapper for ByUI Showcase on Web & Desktop.
///
/// When the display window is wider than a mobile device (such as in fullscreen
/// desktop browser), this layout constrains the showcase width to a portrait
/// mobile viewport (~430px), centered gracefully against an adaptive canvas
/// with accompanying showcase details and interactive width presets.
///
/// On actual mobile screens or narrower viewports, it seamlessly falls back to
/// 100% edge-to-edge native display.
class WebMobileLayout extends StatefulWidget {
  final Widget child;
  final double defaultMobileWidth;

  const WebMobileLayout({
    super.key,
    required this.child,
    this.defaultMobileWidth = 430.0,
  });

  @override
  State<WebMobileLayout> createState() => _WebMobileLayoutState();
}

class _WebMobileLayoutState extends State<WebMobileLayout> {
  late double _selectedWidth;

  // Viewport width presets
  static const List<Map<String, dynamic>> _widthPresets = [
    {
      'name': 'Compact',
      'width': 390.0,
      'device': 'iPhone 15 / Small Phone',
      'icon': Icons.phone_iphone_rounded,
    },
    {
      'name': 'Standard',
      'width': 412.0,
      'device': 'Pixel 8 / Galaxy S24',
      'icon': Icons.phone_android_rounded,
    },
    {
      'name': 'Large (Default)',
      'width': 430.0,
      'device': 'Large Phone (430px)',
      'icon': Icons.stay_current_portrait_rounded,
    },
    {
      'name': 'Max',
      'width': 860.0,
      'device': 'Tablet / Foldable (860px)',
      'icon': Icons.tablet_mac_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedWidth = widget.defaultMobileWidth;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        final bool isDark = AppThemeStore.instance.isDarkMode(context);
        final AppColorPalette colors = AppColors.fromBrightness(isDark);

        return LayoutBuilder(
          builder: (context, constraints) {
            // If window is already smaller than or equal to selected width, render edge-to-edge without wrapper
            if (constraints.maxWidth <= _selectedWidth) {
              return widget.child;
            }

            final availableSideSpace =
                (constraints.maxWidth - _selectedWidth) / 2;
            final showSidePanels = availableSideSpace >= 260;
            final sidePanelWidth = (availableSideSpace - 48).clamp(
              220.0,
              360.0,
            );

            return Material(
              color: isDark ? const Color(0xFF06090E) : const Color(0xFFF1F5F9),
              child: Stack(
                children: [
                  // 1. Ambient Desktop Background Gradient
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0.0, -0.6),
                            radius: 1.3,
                            colors: isDark
                                ? const [Color(0xFF0F172A), Color(0xFF06090E)]
                                : const [Color(0xFFEEF2FF), Color(0xFFE2E8F0)],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 2. Desktop Companion Panels (Only rendered when screen is wide enough)
                  if (showSidePanels) ...[
                    // Left Panel: Library Branding & Viewport Width Presets
                    Positioned(
                      left: 36,
                      top: 0,
                      bottom: 0,
                      width: sidePanelWidth,
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: RepaintBoundary(
                            child: _buildLeftPanel(colors),
                          ),
                        ),
                      ),
                    ),

                    // Right Panel: Interactive Gesture Guide & Showcase Tips
                    Positioned(
                      right: 36,
                      top: 0,
                      bottom: 0,
                      width: sidePanelWidth,
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: RepaintBoundary(
                            child: _buildRightPanel(colors),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // 3. Compact Floating Dock (When side panels cannot fit)
                  if (!showSidePanels)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: RepaintBoundary(
                          child: _buildCompactWidthSelector(colors),
                        ),
                      ),
                    ),

                  // 4. Centered Portrait Mobile / Expanded Screen Container
                  Center(
                    child: RepaintBoundary(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        width: _selectedWidth,
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: colors.scaffoldBg,
                          border: Border.symmetric(
                            vertical: BorderSide(
                              color: colors.border,
                              width: 1.5,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.7)
                                  : Colors.black.withValues(alpha: 0.08),
                              blurRadius: 48,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: widget.child,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Left Desktop Companion Panel
  Widget _buildLeftPanel(AppColorPalette colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Header
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryAccent],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.widgets_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ByUI',
                  style: AppTextStyle.appBarTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  'Component Showcase',
                  style: AppTextStyle.caption.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Description
        Text(
          'Modern Flutter UI component library featuring fluid spatial animations, interactive toasts, and shrink-wrap dialogs.',
          style: AppTextStyle.body.copyWith(
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        // Device Viewport Width Selector
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBg.withValues(alpha: colors.isDark ? 0.75 : 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
            boxShadow: colors.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.stay_current_portrait_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PORTRAIT VIEWPORT WIDTH',
                    style: AppTextStyle.sectionHeader.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._widthPresets.map((preset) {
                final double width = preset['width'] as double;
                final bool isSelected = _selectedWidth == width;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedWidth = width;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.chipSelectedBg
                            : colors.chipBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : colors.borderSubtle,
                          width: isSelected ? 1.4 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            preset['icon'] as IconData,
                            size: 16,
                            color: isSelected
                                ? AppColors.primary
                                : colors.textMuted,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  preset['name'] as String,
                                  style:
                                      (isSelected
                                              ? AppTextStyle.chipSelected
                                              : AppTextStyle.chipUnselected)
                                          .copyWith(
                                            color: isSelected
                                                ? (colors.isDark
                                                      ? Colors.white
                                                      : AppColors.primaryDark)
                                                : colors.textPrimary,
                                          ),
                                ),
                                Text(
                                  '${preset['device']} • ${width.toInt()}px',
                                  style: AppTextStyle.caption.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : colors.textMuted,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Live Status Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _selectedWidth >= 860.0
                    ? 'Fullscreen Frame: ${_selectedWidth.toInt()}px (Max)'
                    : 'Fullscreen Mobile Frame: ${_selectedWidth.toInt()}px',
                style: AppTextStyle.badge.copyWith(color: AppColors.success),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Right Desktop Companion Panel
  Widget _buildRightPanel(AppColorPalette colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBg.withValues(alpha: colors.isDark ? 0.75 : 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
            boxShadow: colors.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.touch_app_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'INTERACTION GUIDE',
                    style: AppTextStyle.sectionHeader.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildGuideItem(
                icon: Icons.ads_click_rounded,
                title: 'Tap to Morph into Dialog',
                description:
                    'Tap on the toast card message to trigger a spatial morphing transition into a modal dialog.',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _buildGuideItem(
                icon: Icons.swipe_rounded,
                title: 'Swipe to Dismiss',
                description:
                    'Fling or swipe any active toast card to dismiss it instantly with fluid spring physics.',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _buildGuideItem(
                icon: Icons.drag_handle_rounded,
                title: 'Drag Inward to Expand',
                description:
                    'Pull the toast towards the center of the viewport to open full transaction or order details.',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _buildGuideItem(
                icon: Icons.menu_rounded,
                title: 'Component Switcher',
                description:
                    'Use the top-left menu icon to switch between ByToast and ByDialog showcases.',
                colors: colors,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required String title,
    required String description,
    required AppColorPalette colors,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: colors.isDark ? 0.15 : 0.10,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.sectionLabel.copyWith(
                  color: colors.textPrimary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactWidthSelector(AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: colors.isDark ? 0.94 : 0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: colors.isDark ? 0.5 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _widthPresets.map((preset) {
          final double width = preset['width'] as double;
          final bool isSelected = _selectedWidth == width;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedWidth = width;
                });
              },
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      preset['icon'] as IconData,
                      size: 14,
                      color: isSelected ? Colors.white : colors.textMuted,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${width.toInt()}px',
                      style:
                          (isSelected
                                  ? AppTextStyle.chipSelected
                                  : AppTextStyle.chipUnselected)
                              .copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : colors.textMuted,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
