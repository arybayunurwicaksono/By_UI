import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_textstyle.dart';
import 'tabs/activity_tab.dart';
import 'tabs/explore_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/profile_tab.dart';

/// Main Dashboard shell utilizing standard ByAppBar directly, with Cyan theme and ByBottomNav dock.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = false;
  late final ScrollController _homeScrollController;
  late final ScrollController _exploreScrollController;
  late final ScrollController _activityScrollController;
  late final ScrollController _profileScrollController;

  static const List<ByBottomNavItem> _navItems = [
    ByBottomNavItem(icon: Icons.dashboard_rounded, label: 'Home'),
    ByBottomNavItem(
      icon: Icons.explore_rounded,
      label: 'Explore',
      badgeText: 'HOT',
    ),
    ByBottomNavItem(
      icon: Icons.receipt_long_rounded,
      label: 'Activity',
      badgeCount: 2,
    ),
    ByBottomNavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  static const List<BySidebarItem> _sidebarItems = [
    BySidebarItem(icon: Icons.dashboard_rounded, label: 'Home'),
    BySidebarItem(icon: Icons.explore_rounded, label: 'Explore', badge: 'HOT'),
    BySidebarItem(
      icon: Icons.receipt_long_rounded,
      label: 'Activity',
      badge: '2',
    ),
    BySidebarItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _homeScrollController = ScrollController();
    _exploreScrollController = ScrollController();
    _activityScrollController = ScrollController();
    _profileScrollController = ScrollController();
  }

  @override
  void dispose() {
    _homeScrollController.dispose();
    _exploreScrollController.dispose();
    _activityScrollController.dispose();
    _profileScrollController.dispose();
    super.dispose();
  }

  ScrollController get _activeScrollController {
    switch (_selectedIndex) {
      case 0:
        return _homeScrollController;
      case 1:
        return _exploreScrollController;
      case 2:
        return _activityScrollController;
      default:
        return _profileScrollController;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDesktop = mediaQuery.size.width >= 900;
    final isCompact = mediaQuery.size.width < 360;

    // Desktop Layout with BySidebar & Multi-Column View
    if (isDesktop) {
      return ByScrollScope(
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: Stack(
            children: [
              // Main Desktop View Area (stable fixed left gutter for the 72px collapsed sidebar)
              Positioned(
                left: 72.0,
                top: 0,
                right: 0,
                bottom: 0,
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    HomeTab(
                      scrollController: _homeScrollController,
                      isDesktop: true,
                    ),
                    ExploreTab(
                      scrollController: _exploreScrollController,
                      isDesktop: true,
                      isActive: _selectedIndex == 1,
                    ),
                    ActivityTab(
                      scrollController: _activityScrollController,
                      isDesktop: true,
                    ),
                    ProfileTab(
                      scrollController: _profileScrollController,
                      isDesktop: true,
                    ),
                  ],
                ),
              ),

              // Desktop Sidebar with auto open on hover as floating preview overlay
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: BySidebar(
                  items: _sidebarItems,
                  selectedIndex: _selectedIndex,
                  onItemSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  isCollapsed: true, // Default closed / collapsed on web
                  enableHoverExpand:
                      true, // Auto open on hover, auto collapse on exit
                  onHoverExpandChanged: (val) {
                    if (_isSidebarExpanded != val) {
                      setState(() {
                        _isSidebarExpanded = val;
                      });
                    }
                  },
                  expandedWidth: 240,
                  collapsedWidth: 72,
                  activeColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  borderColor: AppColors.cardBorder,
                  enableSpotlightSpill: true,
                  enableCursorBorderTracking: true,
                  header: SizedBox(
                    height: 68,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17.5,
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.primary.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.asset(
                                'assets/images/logo_by_ui_showcase.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.layers_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                              ),
                            ),
                          ),
                          if (_isSidebarExpanded)
                            Expanded(
                              child: SizedBox(
                                height: 36,
                                child: ClipRect(
                                  child: OverflowBox(
                                    alignment: Alignment.centerLeft,
                                    minWidth: 0,
                                    maxWidth: 168,
                                    minHeight: 0,
                                    maxHeight: 36,
                                    child: SizedBox(
                                      width: 168,
                                      height: 36,
                                      child: AnimatedOpacity(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeInOut,
                                        opacity: _isSidebarExpanded ? 1.0 : 0.0,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            const Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'ByUI Pulse',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.clip,
                                                    softWrap: false,
                                                    style:
                                                        AppTextStyle.subheading,
                                                  ),
                                                  Text(
                                                    'Fintech Workspace',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.clip,
                                                    softWrap: false,
                                                    style: AppTextStyle.caption,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(
                                                minWidth: 32,
                                                minHeight: 32,
                                              ),
                                              icon: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .notifications_outlined,
                                                    size: 20,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                  Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            2.5,
                                                          ),
                                                      decoration:
                                                          const BoxDecoration(
                                                            color:
                                                                AppColors.error,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      constraints:
                                                          const BoxConstraints(
                                                            minWidth: 7,
                                                            minHeight: 7,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _selectedIndex =
                                                      2; // Jump to activity/notifications tab
                                                });
                                                ByToast.show(
                                                  context,
                                                  message:
                                                      'Switched to Activity & Notifications',
                                                  icon: Icons
                                                      .notifications_active_rounded,
                                                  backgroundColor:
                                                      AppColors.primary,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  footer: SizedBox(
                    height: 56,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 19.5,
                        vertical: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(
                              Icons.person_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          if (_isSidebarExpanded)
                            Expanded(
                              child: SizedBox(
                                height: 32,
                                child: ClipRect(
                                  child: OverflowBox(
                                    alignment: Alignment.centerLeft,
                                    minWidth: 0,
                                    maxWidth: 160,
                                    minHeight: 0,
                                    maxHeight: 32,
                                    child: SizedBox(
                                      width: 160,
                                      height: 32,
                                      child: AnimatedOpacity(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeInOut,
                                        opacity: _isSidebarExpanded ? 1.0 : 0.0,
                                        child: const Row(
                                          children: [
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Alex Rivera',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.clip,
                                                    softWrap: false,
                                                    style: AppTextStyle.caption,
                                                  ),
                                                  Text(
                                                    'Platinum Member',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.clip,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          AppColors.primaryDark,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Native Mobile Layout with ByBottomNav
    return ByScrollScope(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        extendBodyBehindAppBar: false,
        appBar: ByAppBar(
          key: ByToast.appBarKey,
          scrollController: _activeScrollController,
          backgroundColor: Colors.white,
          borderColor: AppColors.cardBorder,
          borderWidth: 1.0,
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 12.0 : 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Avatar & Brand Greeting (Protected with Expanded/Flexible)
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.asset(
                            'assets/images/logo_by_ui_showcase.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.person_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    'ByUI Pulse',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.subheading.copyWith(
                                      fontSize: isCompact ? 14 : 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                            Text(
                              'Alex Rivera • Platinum',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.caption.copyWith(
                                color: AppColors.primaryDark,
                                fontSize: isCompact ? 10 : 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Notifications Action
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        size: 22,
                        color: AppColors.textPrimary,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2; // Jump to activity/notifications tab
                    });
                    ByToast.show(
                      context,
                      message: 'Switched to Activity & Notifications',
                      icon: Icons.notifications_active_rounded,
                      backgroundColor: AppColors.primary,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            // Multi-tab content view
            IndexedStack(
              index: _selectedIndex,
              children: [
                HomeTab(
                  scrollController: _homeScrollController,
                  isDesktop: false,
                ),
                ExploreTab(
                  scrollController: _exploreScrollController,
                  isDesktop: false,
                  isActive: _selectedIndex == 1,
                ),
                ActivityTab(
                  scrollController: _activityScrollController,
                  isDesktop: false,
                ),
                ProfileTab(
                  scrollController: _profileScrollController,
                  isDesktop: false,
                ),
              ],
            ),

            // Glassmorphic Floating ByBottomNav Dock anchored at bottom
            Positioned(
              left: isCompact ? 10 : 16,
              right: isCompact ? 10 : 16,
              bottom: isCompact ? 12 : 18,
              child: Center(
                child: ByBottomNav(
                  key: ByToast.bottomBarKey,
                  items: _navItems,
                  selectedIndex: _selectedIndex,
                  onItemSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  activeColor: AppColors.primary,
                  backgroundColor: Colors.white.withValues(alpha: 0.92),
                  borderColor: AppColors.cardBorder,
                  autoContentColor: true,
                  borderRadius: BorderRadius.circular(26),
                  itemBorderRadius: BorderRadius.circular(14),
                  itemSize: isCompact ? 40 : 44,
                  iconSize: isCompact ? 20 : 22,
                  borderWidth: 1.0,
                  glowBlurRadius: 14.0,
                  blurSigma: 16.0,
                  enableMagneticProximity: true,
                  enableSensor: true,
                  enableDynamicBorder: true,
                  dynamicBorderColors: AppColors.laserColors,
                  enableSelectionPulse: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
