import 'package:flutter/material.dart';
import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';

/// Modern and aesthetic navigation drawer showcasing ByUI components.
/// Includes dynamic theme selection (System / Light / Dark) at the bottom.
class ByDrawer extends StatelessWidget {
  final String activeComponent;
  final ValueChanged<String>? onSelectComponent;

  const ByDrawer({
    super.key,
    this.activeComponent = 'ByToast',
    this.onSelectComponent,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        final colors = AppColors.of(context);

        return Drawer(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            color: colors.drawerBg,
            child: SafeArea(
              child: Column(
                children: [
                  // Drawer Header Card with ByUI Brand Styling
                  _buildDrawerHeader(colors),

                  // Drawer Content List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      children: [
                        // Active Components Section
                        _buildSectionHeader('AVAILABLE COMPONENTS (4)', colors),
                        const SizedBox(height: 8),

                        _buildDrawerItem(
                          title: 'ByToast',
                          subtitle: 'Stacked toast & banner overlay',
                          icon: AppIcons.notification,
                          isActive: activeComponent == 'ByToast',
                          badgeText: 'Ready',
                          badgeColor: AppColors.success,
                          colors: colors,
                          onTap: () {
                            Navigator.of(context).pop();
                            onSelectComponent?.call('ByToast');
                          },
                        ),
                        const SizedBox(height: 6),

                        _buildDrawerItem(
                          title: 'ByDialog',
                          subtitle: 'Animated shrink-wrap modal',
                          icon: AppIcons.layers,
                          isActive: activeComponent == 'ByDialog',
                          badgeText: 'Ready',
                          badgeColor: AppColors.success,
                          colors: colors,
                          onTap: () {
                            Navigator.of(context).pop();
                            onSelectComponent?.call('ByDialog');
                          },
                        ),
                        const SizedBox(height: 6),

                        _buildDrawerItem(
                          title: 'ByCard',
                          subtitle: 'Spatial & dynamic sensor card',
                          icon: AppIcons.card,
                          isActive: activeComponent == 'ByCard',
                          badgeText: 'Ready',
                          badgeColor: AppColors.success,
                          colors: colors,
                          onTap: () {
                            Navigator.of(context).pop();
                            onSelectComponent?.call('ByCard');
                          },
                        ),
                        const SizedBox(height: 6),

                        _buildDrawerItem(
                          title: 'ByAppBar',
                          subtitle: 'Dynamic floating & glassmorphic app bar',
                          icon: Icons.web_asset_rounded,
                          isActive: activeComponent == 'ByAppBar',
                          badgeText: 'Ready',
                          badgeColor: AppColors.success,
                          colors: colors,
                          onTap: () {
                            Navigator.of(context).pop();
                            onSelectComponent?.call('ByAppBar');
                          },
                        ),

                        const SizedBox(height: 18),

                        // Upcoming Roadmap Section
                        _buildSectionHeader('ROADMAP COMPONENTS', colors),
                        const SizedBox(height: 8),

                        _buildDrawerItem(
                          title: 'ByBottomSheet',
                          subtitle: 'Fluid draggable modal sheets',
                          icon: Icons.vertical_align_bottom_rounded,
                          isActive: false,
                          isUpcoming: true,
                          badgeText: 'SOON',
                          badgeColor: AppColors.warning,
                          colors: colors,
                        ),
                        const SizedBox(height: 6),

                        _buildDrawerItem(
                          title: 'ByDropdown',
                          subtitle: 'Searchable spatial dropdowns',
                          icon: Icons.arrow_drop_down_circle_outlined,
                          isActive: false,
                          isUpcoming: true,
                          badgeText: 'SOON',
                          badgeColor: AppColors.warning,
                          colors: colors,
                        ),
                        const SizedBox(height: 6),

                        _buildDrawerItem(
                          title: 'ByAvatarBadge',
                          subtitle: 'Online presence avatar clusters',
                          icon: Icons.account_circle_outlined,
                          isActive: false,
                          isUpcoming: true,
                          badgeText: 'PLANNED',
                          badgeColor: colors.textMuted,
                          colors: colors,
                        ),
                      ],
                    ),
                  ),

                  // Bottom Theme Mode Switcher
                  _buildThemeSelector(context, colors),

                  // Drawer Footer
                  _buildDrawerFooter(colors),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerHeader(AppColorPalette colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Stylized Brand Monogram
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'BY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'ByUI',
                          style: AppTextStyle.appBarTitle.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.badgeBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: colors.badgeBorder,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'v0.1.4',
                            style: AppTextStyle.badgeSmall.copyWith(
                              color: colors.badgeText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Core Component Library',
                      style: AppTextStyle.fieldLabel.copyWith(
                        color: colors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.hub_rounded,
                  size: 13,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'packages/core',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.code.copyWith(
                      color: colors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppColorPalette colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: AppTextStyle.sectionHeader.copyWith(
          color: colors.textSubtle,
          fontSize: 11,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    bool isUpcoming = false,
    required String badgeText,
    required Color badgeColor,
    required AppColorPalette colors,
    VoidCallback? onTap,
  }) {
    final activeBg = AppColors.primary.withValues(
      alpha: colors.isDark ? 0.15 : 0.10,
    );
    final activeBorder = AppColors.primary.withValues(alpha: 0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isUpcoming ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? activeBorder : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(
                          alpha: colors.isDark ? 0.25 : 0.15,
                        )
                      : colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isActive
                      ? (colors.isDark
                            ? AppColors.primaryTextLight
                            : AppColors.primaryDark)
                      : (isUpcoming ? colors.textMuted : colors.textSubtle),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.body.copyWith(
                        color: isUpcoming
                            ? colors.textMuted
                            : (isActive
                                  ? colors.textPrimary
                                  : colors.textSecondary),
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyle.caption.copyWith(
                        color: isUpcoming
                            ? colors.textMuted
                            : (isActive
                                  ? (colors.isDark
                                        ? AppColors.primaryTextLight
                                        : AppColors.primaryDark)
                                  : colors.textSubtle),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: badgeColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  badgeText,
                  style: AppTextStyle.badgeSmall.copyWith(
                    color: badgeColor,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Theme Mode Selector situated at the bottom of the drawer.
  Widget _buildThemeSelector(BuildContext context, AppColorPalette colors) {
    final themeStore = AppThemeStore.instance;
    final currentMode = themeStore.themeMode;

    String currentModeLabel;
    if (themeStore.isSystem) {
      currentModeLabel = 'Auto (${colors.isDark ? 'Dark' : 'Light'})';
    } else if (themeStore.isLight) {
      currentModeLabel = 'Light';
    } else {
      currentModeLabel = 'Dark';
    }

    final int activeIndex = currentMode == ThemeMode.system
        ? 0
        : (currentMode == ThemeMode.light ? 1 : 2);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.palette_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'THEME MODE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.sectionHeader.copyWith(
                          color: colors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currentModeLabel,
                  style: AppTextStyle.badgeSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RepaintBoundary(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // High-performance GPU sliding indicator
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        offset: Offset(activeIndex.toDouble(), 0.0),
                        child: FractionallySizedBox(
                          widthFactor: 1 / 3,
                          heightFactor: 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Button options layer
                  Row(
                    children: [
                      Expanded(
                        child: _buildThemeOptionButton(
                          mode: ThemeMode.system,
                          label: 'System',
                          icon: AppIcons.themeAuto,
                          isSelected: currentMode == ThemeMode.system,
                          colors: colors,
                          onTap: () =>
                              themeStore.setThemeMode(ThemeMode.system),
                        ),
                      ),
                      Expanded(
                        child: _buildThemeOptionButton(
                          mode: ThemeMode.light,
                          label: 'Light',
                          icon: AppIcons.themeLight,
                          isSelected: currentMode == ThemeMode.light,
                          colors: colors,
                          onTap: () => themeStore.setThemeMode(ThemeMode.light),
                        ),
                      ),
                      Expanded(
                        child: _buildThemeOptionButton(
                          mode: ThemeMode.dark,
                          label: 'Dark',
                          icon: AppIcons.themeDark,
                          isSelected: currentMode == ThemeMode.dark,
                          colors: colors,
                          onTap: () => themeStore.setThemeMode(ThemeMode.dark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOptionButton({
    required ThemeMode mode,
    required String label,
    required IconData icon,
    required bool isSelected,
    required AppColorPalette colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 13,
                    color: isSelected ? Colors.white : colors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: AppTextStyle.badge.copyWith(
                      color: isSelected ? Colors.white : colors.textSecondary,
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter(AppColorPalette colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border(top: BorderSide(color: colors.border, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sample App • Ready to test',
              style: AppTextStyle.caption.copyWith(
                color: colors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            'ByUI',
            style: AppTextStyle.fieldLabel.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
