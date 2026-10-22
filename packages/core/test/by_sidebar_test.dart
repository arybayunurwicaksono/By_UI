import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';

void main() {
  group('BySidebar Widget Tests', () {
    testWidgets('renders sidebar items and handles collapse toggle',
        (tester) async {
      int selected = 0;
      bool collapsed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return BySidebar(
                  items: const [
                    BySidebarItem(
                        icon: Icons.dashboard_rounded, label: 'Dashboard'),
                    BySidebarItem(
                        icon: Icons.analytics_rounded,
                        label: 'Analytics',
                        badge: 'PRO'),
                    BySidebarItem.divider(),
                    BySidebarItem(
                        icon: Icons.settings_rounded, label: 'Settings'),
                  ],
                  selectedIndex: selected,
                  isCollapsed: collapsed,
                  onToggleCollapse: () {
                    setState(() => collapsed = !collapsed);
                  },
                  onItemSelected: (index) {
                    setState(() => selected = index);
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('PRO'), findsOneWidget);

      // Tap on Analytics
      await tester.tap(find.text('Analytics'));
      await tester.pumpAndSettle();
      expect(selected, equals(1));

      // Toggle collapse
      await tester.tap(find.byTooltip('Collapse'));
      await tester.pumpAndSettle();
      expect(collapsed, isTrue);

      // In collapsed mode, labels are hidden
      expect(find.text('Dashboard'), findsNothing);

      // Toggle expand again (verifies transition frames don't overflow)
      await tester.tap(find.byTooltip('Expand'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(collapsed, isFalse);
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('renders safely under narrow constraints without overflow',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 72,
              child: BySidebar(
                items: const [
                  BySidebarItem(
                      icon: Icons.dashboard_rounded,
                      label: 'Very Long Dashboard Label That Might Overflow'),
                  BySidebarItem(
                      icon: Icons.analytics_rounded,
                      label: 'Analytics',
                      badge: 'SUPER_LONG_BADGE'),
                ],
                selectedIndex: 0,
                isCollapsed:
                    false, // Intentionally test small width even if isCollapsed is false
                onItemSelected: (_) {},
              ),
            ),
          ),
        ),
      );

      // Should render without throwing RenderFlex overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'supports extensive customizations (colors, geometry, customIcon, and badge colors)',
        (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BySidebar(
              items: const [
                BySidebarItem(
                  icon: Icons.star,
                  customIcon: Icon(Icons.star_purple500_outlined,
                      key: Key('custom_sidebar_icon')),
                  label: 'Starred',
                  badge: 'NEW',
                  badgeColor: Colors.purple,
                  badgeTextColor: Colors.white,
                  activeColor: Colors.amber,
                ),
                BySidebarItem.divider(),
                BySidebarItem(
                  icon: Icons.settings,
                  label: 'Preferences',
                ),
              ],
              selectedIndex: selected,
              onItemSelected: (index) => selected = index,
              expandedWidth: 260.0,
              collapsedWidth: 80.0,
              borderWidth: 2.0,
              itemBorderRadius: BorderRadius.circular(14),
              itemPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemSpacing: 8.0,
              selectedItemBackgroundColor: Colors.amber.withValues(alpha: 0.15),
              selectedTextColor: Colors.amber,
              selectedIconColor: Colors.amber,
              unselectedTextColor: Colors.grey,
              unselectedIconColor: Colors.grey,
              enableSpotlightSpill: true,
              spotlightRadius: 150.0,
              spotlightColor: Colors.amber,
              spotlightOpacity: 0.1,
              enableCursorBorderTracking: true,
              cursorBorderGlowHeight: 120.0,
              cursorBorderWidth: 3.0,
              cursorBorderColor: Colors.amberAccent,
              badgeColor: Colors.cyan,
              badgeTextColor: Colors.black,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('custom_sidebar_icon')), findsOneWidget);
      expect(find.text('Starred'), findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);

      await tester.tap(find.text('Preferences'));
      await tester.pumpAndSettle();
      expect(selected, equals(2));
    });
    testWidgets(
        'renders tactile bottom action tile with custom labels and handles collapse',
        (tester) async {
      bool collapsed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return BySidebar(
                  items: const [
                    BySidebarItem(icon: Icons.folder, label: 'Documents'),
                  ],
                  selectedIndex: 0,
                  isCollapsed: collapsed,
                  collapseLabel: 'Minimize Menu',
                  expandLabel: 'Maximize Menu',
                  onToggleCollapse: () =>
                      setState(() => collapsed = !collapsed),
                  onItemSelected: (_) {},
                );
              },
            ),
          ),
        ),
      );

      // In expanded state, action tile shows label
      expect(find.text('Minimize Menu'), findsOneWidget);

      await tester.tap(find.text('Minimize Menu'));
      await tester.pumpAndSettle();
      expect(collapsed, isTrue);

      // In collapsed state, label text is hidden, tooltip exists
      expect(find.text('Minimize Menu'), findsNothing);
      expect(find.byTooltip('Maximize Menu'), findsOneWidget);

      await tester.tap(find.byTooltip('Maximize Menu'));
      await tester.pumpAndSettle();
      expect(collapsed, isFalse);
      expect(find.text('Minimize Menu'), findsOneWidget);
    });

    testWidgets(
        'hides toggle when togglePlacement is none and prevents narrow overflow in toggle tile',
        (tester) async {
      bool collapsed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return BySidebar(
                  items: const [
                    BySidebarItem(icon: Icons.home, label: 'Home'),
                  ],
                  selectedIndex: 0,
                  isCollapsed: collapsed,
                  togglePlacement: BySidebarTogglePlacement.none,
                  onToggleCollapse: () =>
                      setState(() => collapsed = !collapsed),
                  onItemSelected: (_) {},
                );
              },
            ),
          ),
        ),
      );

      // Neither bottom tile nor header toggle should be rendered
      expect(find.byTooltip('Collapse'), findsNothing);
      expect(find.byTooltip('Expand'), findsNothing);
    });

    testWidgets('renders header toggle button when togglePlacement is header',
        (tester) async {
      bool collapsed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return BySidebar(
                  items: const [
                    BySidebarItem(icon: Icons.home, label: 'Home'),
                  ],
                  selectedIndex: 0,
                  isCollapsed: collapsed,
                  togglePlacement: BySidebarTogglePlacement.header,
                  header: const Text('My App'),
                  onToggleCollapse: () =>
                      setState(() => collapsed = !collapsed),
                  onItemSelected: (_) {},
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('My App'), findsOneWidget);
      expect(find.byTooltip('Collapse'), findsOneWidget);

      await tester.tap(find.byTooltip('Collapse'));
      await tester.pumpAndSettle();
      expect(collapsed, isTrue);
    });

    testWidgets('supports horizontal swipe gesture to collapse and expand',
        (tester) async {
      bool collapsed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return BySidebar(
                  items: const [
                    BySidebarItem(icon: Icons.home, label: 'Home'),
                  ],
                  selectedIndex: 0,
                  isCollapsed: collapsed,
                  enableSwipeGesture: true,
                  onToggleCollapse: () =>
                      setState(() => collapsed = !collapsed),
                  onItemSelected: (_) {},
                );
              },
            ),
          ),
        ),
      );

      // Swipe left to collapse
      await tester.fling(find.byType(BySidebar), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();
      expect(collapsed, isTrue);

      // Swipe right to expand
      await tester.fling(find.byType(BySidebar), const Offset(300, 0), 1000);
      await tester.pumpAndSettle();
      expect(collapsed, isFalse);
    });

    testWidgets(
        'supports hover auto-expand preview when enableHoverExpand is true and prevents overflow',
        (tester) async {
      bool? lastHoverState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BySidebar(
              items: const [
                BySidebarItem(icon: Icons.home, label: 'Home Label'),
              ],
              selectedIndex: 0,
              isCollapsed:
                  false, // Should default to collapsed when enableHoverExpand is true!
              enableHoverExpand: true,
              onHoverExpandChanged: (hovered) => lastHoverState = hovered,
              onToggleCollapse: () {},
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      // When enableHoverExpand is true, default state is collapsed: label is hidden
      expect(find.text('Home Label'), findsNothing);
      // Toggle button is hidden to avoid interaction ambiguity
      expect(find.byTooltip('Collapse'), findsNothing);
      expect(find.byTooltip('Expand'), findsNothing);

      // Hover over the sidebar
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(BySidebar)));
      // Pump transition frame to verify zero overflow during width animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // In hover preview mode: label becomes visible!
      expect(find.text('Home Label'), findsOneWidget);
      expect(lastHoverState, isTrue);

      // Move pointer away
      await gesture.moveTo(const Offset(500, 500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 300));

      // Reverts to collapsed: label is hidden again
      expect(find.text('Home Label'), findsNothing);
      expect(lastHoverState, isFalse);
    });

    testWidgets(
        'supports BySidebarItem.section, trailing widget, collapsed tooltip, and indicatorStyle',
        (tester) async {
      int selected = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BySidebar(
              items: const [
                BySidebarItem.section('MANAGEMENT'),
                BySidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  trailing: Text('⌘D'),
                ),
                BySidebarItem(
                  icon: Icons.lock_rounded,
                  label: 'Locked Feature',
                  enabled: false,
                ),
              ],
              selectedIndex: selected,
              isCollapsed: false,
              indicatorStyle: BySidebarIndicatorStyle.leadingBar,
              onItemSelected: (val) => selected = val,
            ),
          ),
        ),
      );

      // Verify section header and trailing are displayed
      expect(find.text('MANAGEMENT'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('⌘D'), findsOneWidget);

      // Verify disabled item does not fire selection
      await tester.tap(find.text('Locked Feature'));
      await tester.pumpAndSettle();
      expect(selected, equals(1));
    });

    testWidgets(
        'adapts text colors for high contrast when backgroundColor is light',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BySidebar(
              backgroundColor: Colors.white,
              items: const [
                BySidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                ),
              ],
              selectedIndex: 0,
              isCollapsed: false,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      final labelText = tester.widget<Text>(find.text('Dashboard'));
      expect(labelText.style?.color, isNot(equals(Colors.white)));
      expect(labelText.style?.color, equals(const Color(0xFF0F172A)));
    });
  });
}
