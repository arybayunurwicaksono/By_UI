import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';

void main() {
  group('ByBottomNav Widget Tests', () {
    testWidgets('renders dock items and fires selection callback on tap',
        (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: ByBottomNav(
                    items: const [
                      ByBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
                      ByBottomNavItem(
                          icon: Icons.search_rounded,
                          label: 'Search',
                          badgeCount: 3),
                      ByBottomNavItem(
                          icon: Icons.settings_rounded, label: 'Settings'),
                    ],
                    selectedIndex: selected,
                    onItemSelected: (index) {
                      setState(() => selected = index);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      expect(selected, equals(1));
    });

    testWidgets(
        'supports itemSize, iconSize, itemBorderRadius, customIcon, and showActiveDot toggle',
        (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByBottomNav(
                items: const [
                  ByBottomNavItem(
                    icon: Icons.star,
                    customIcon: Text('CUSTOM_ICON'),
                    label: 'Custom Star',
                    badgeCount: 2,
                    badgeColor: Colors.purple,
                    badgeTextColor: Colors.white,
                  ),
                  ByBottomNavItem(
                    icon: Icons.map,
                    label: 'Map',
                  ),
                ],
                selectedIndex: selected,
                onItemSelected: (val) => selected = val,
                itemSize: 52.0,
                iconSize: 26.0,
                borderWidth: 2.0,
                itemBorderRadius: BorderRadius.circular(16),
                showActiveDot: false,
                glowColor: Colors.blueAccent,
                glowBlurRadius: 20.0,
              ),
            ),
          ),
        ),
      );

      expect(find.text('CUSTOM_ICON'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);
    });

    testWidgets(
        'magnetic proximity scales only the hovered item and its immediate neighbors correctly',
        (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByBottomNav(
                items: const [
                  ByBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
                  ByBottomNavItem(
                      icon: Icons.explore_rounded, label: 'Explore'),
                  ByBottomNavItem(
                      icon: Icons.favorite_rounded, label: 'Favorites'),
                  ByBottomNavItem(
                      icon: Icons.notifications_rounded,
                      label: 'Inbox',
                      badgeCount: 5),
                  ByBottomNavItem(icon: Icons.person_rounded, label: 'Profile'),
                ],
                selectedIndex: selected,
                onItemSelected: (index) => selected = index,
                maxMagnification: 1.35,
                proximityRange: 90.0,
                enableMagneticProximity: true,
              ),
            ),
          ),
        ),
      );

      List<double> getScales() {
        return tester
            .widgetList<AnimatedScale>(find.byType(AnimatedScale))
            .map((w) => w.scale)
            .toList();
      }

      // Verify all items start at scale 1.0
      expect(getScales(), equals([1.0, 1.0, 1.0, 1.0, 1.0]));

      // Create mouse pointer
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Hover directly over Inbox (index 3)
      final inboxCenter =
          tester.getCenter(find.byIcon(Icons.notifications_rounded));
      await gesture.moveTo(inboxCenter);
      await tester.pump();

      final scalesAtInbox = getScales();
      // Inbox (index 3) must be magnified towards 1.35
      expect(scalesAtInbox[3], closeTo(1.35, 0.01));
      // Distant item Explore (index 1) must NOT be magnified! Must be 1.0
      expect(scalesAtInbox[1], equals(1.0));
      // Distant item Home (index 0) must be 1.0
      expect(scalesAtInbox[0], equals(1.0));

      // Now move hover directly over Explore (index 1)
      final exploreCenter =
          tester.getCenter(find.byIcon(Icons.explore_rounded));
      await gesture.moveTo(exploreCenter);
      await tester.pump();

      final scalesAtExplore = getScales();
      // Explore (index 1) must be magnified towards 1.35
      expect(scalesAtExplore[1], closeTo(1.35, 0.01));
      // Distant item Inbox (index 3) must NOT be magnified! Must be 1.0
      expect(scalesAtExplore[3], equals(1.0));
      // Profile (index 4) must be 1.0
      expect(scalesAtExplore[4], equals(1.0));

      // Now move cursor completely away from the dock
      await gesture.moveTo(const Offset(10, 10));
      await tester.pump();

      final scalesExited = getScales();
      expect(scalesExited, equals([1.0, 1.0, 1.0, 1.0, 1.0]));

      await gesture.removePointer();
    });

    testWidgets('magnetic proximity respects enableMagneticProximity = false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByBottomNav(
                items: const [
                  ByBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
                  ByBottomNavItem(
                      icon: Icons.explore_rounded, label: 'Explore'),
                ],
                selectedIndex: 0,
                onItemSelected: (_) {},
                enableMagneticProximity: false,
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byIcon(Icons.home_rounded)));
      await tester.pump();

      final scales = tester
          .widgetList<AnimatedScale>(find.byType(AnimatedScale))
          .map((w) => w.scale)
          .toList();
      expect(scales, equals([1.0, 1.0]));

      await gesture.removePointer();
    });

    testWidgets(
        'dynamic border uses dynamicBorderRepeatCount = 1 by default and supports custom repeat count',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByBottomNav(
                items: const [
                  ByBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
                ],
                selectedIndex: 0,
                onItemSelected: (_) {},
                enableDynamicBorder: true,
              ),
            ),
          ),
        ),
      );

      final layerFinder = find.byType(ByDynamicBorderLayer);
      expect(layerFinder, findsOneWidget);
      final layer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(layer.config.repeatCount, equals(1));
      expect(layer.config.autoStart, isTrue);

      // Verify custom repeat count (e.g. infinite)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByBottomNav(
                items: const [
                  ByBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
                ],
                selectedIndex: 0,
                onItemSelected: (_) {},
                enableDynamicBorder: true,
                dynamicBorderRepeatCount: null,
              ),
            ),
          ),
        ),
      );

      final customLayer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(customLayer.config.repeatCount, isNull);
    });

    testWidgets(
        'complies with small screen zero-overflow rule when constrained to 280px',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 280,
                child: ByBottomNav(
                  items: const [
                    ByBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
                    ByBottomNavItem(
                        icon: Icons.explore_rounded, label: 'Explore'),
                    ByBottomNavItem(
                        icon: Icons.favorite_rounded, label: 'Favorites'),
                    ByBottomNavItem(
                        icon: Icons.notifications_rounded,
                        label: 'Inbox',
                        badgeCount: 5),
                    ByBottomNavItem(
                        icon: Icons.person_rounded, label: 'Profile'),
                  ],
                  selectedIndex: 0,
                  onItemSelected: (_) {},
                  enableMagneticProximity: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Verify no overflow exception was thrown
      expect(tester.takeException(), isNull);
      expect(find.byType(ByBottomNav), findsOneWidget);
      expect(find.byType(FittedBox), findsOneWidget);

      // Verify all 5 items are rendered and visible
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.explore_rounded), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);

      // Verify magnetic proximity hover works accurately on the scaled dock
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      final inboxCenter =
          tester.getCenter(find.byIcon(Icons.notifications_rounded));
      await gesture.moveTo(inboxCenter);
      await tester.pump();

      final scales = tester
          .widgetList<AnimatedScale>(find.byType(AnimatedScale))
          .map((w) => w.scale)
          .toList();
      expect(scales[3], closeTo(1.35, 0.01));
      expect(scales[0], equals(1.0));

      await gesture.removePointer();
    });

    testWidgets(
        'supports labelBehavior, isFloating, activeIndicatorStyle, badgeText, showBadgeDot, and enabled: false',
        (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByBottomNav(
                items: const [
                  ByBottomNavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                  ),
                  ByBottomNavItem(
                    icon: Icons.notifications_rounded,
                    label: 'Alerts',
                    badgeText: '99+',
                  ),
                  ByBottomNavItem(
                    icon: Icons.mail_rounded,
                    label: 'Messages',
                    showBadgeDot: true,
                  ),
                  ByBottomNavItem(
                    icon: Icons.block_rounded,
                    label: 'Disabled',
                    enabled: false,
                  ),
                ],
                selectedIndex: selected,
                onItemSelected: (val) => selected = val,
                labelBehavior: ByBottomNavLabelBehavior.alwaysShow,
                isFloating: false,
                activeIndicatorStyle: ByBottomNavIndicatorStyle.line,
              ),
            ),
          ),
        ),
      );

      // Verify labels and badges are rendered
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Alerts'), findsOneWidget);
      expect(find.text('99+'), findsOneWidget);

      // Tap disabled item - should NOT change selected
      await tester.tap(find.byIcon(Icons.block_rounded));
      await tester.pumpAndSettle();
      expect(selected, equals(0));

      // Tap enabled item - should change selected
      await tester.tap(find.byIcon(Icons.notifications_rounded));
      await tester.pumpAndSettle();
      expect(selected, equals(1));
    });
  });
}
