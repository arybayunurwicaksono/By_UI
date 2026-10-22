import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';

void main() {
  group('ByTabBar Widget Tests', () {
    testWidgets('renders all tabs and responds to tab change taps',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ByTabBar(
                  tabs: const [
                    ByTabItem(label: 'Tab 1', icon: Icons.home),
                    ByTabItem(
                        label: 'Tab 2', icon: Icons.explore, badge: 'NEW'),
                    ByTabItem(label: 'Tab 3', icon: Icons.person),
                  ],
                  selectedIndex: selectedIndex,
                  onTabChanged: (index) {
                    setState(() => selectedIndex = index);
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);

      // Tap on Tab 2
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
    });

    testWidgets(
        'supports custom indicatorBorderRadius, gradients, sizing, and tab badges',
        (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ByTabBar(
              tabs: const [
                ByTabItem(
                  label: 'Custom Tab 1',
                  iconWidget: Icon(Icons.star, size: 20),
                  badge: 'VIP',
                  badgeColor: Colors.deepPurple,
                  badgeTextColor: Colors.yellow,
                ),
                ByTabItem(
                  label: 'Custom Tab 2',
                  icon: Icons.flash_on,
                ),
              ],
              selectedIndex: selected,
              onTabChanged: (val) => selected = val,
              height: 52.0,
              borderWidth: 2.0,
              borderRadius: BorderRadius.circular(16),
              indicatorBorderRadius: BorderRadius.circular(12),
              indicatorGradient: const LinearGradient(
                colors: [Colors.indigo, Colors.cyan],
              ),
              indicatorShadowBlur: 14.0,
              liquidStretchFactor: 1.4,
              fontSize: 14.0,
              iconSize: 18.0,
              iconSpacing: 8.0,
            ),
          ),
        ),
      );

      expect(find.text('Custom Tab 1'), findsOneWidget);
      expect(find.text('Custom Tab 2'), findsOneWidget);
      expect(find.text('VIP'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets(
        'supports rapid tab interruptions and custom animationCurve without layout overflow',
        (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ByTabBar(
                      tabs: const [
                        ByTabItem(label: 'Alpha', icon: Icons.looks_one),
                        ByTabItem(label: 'Beta', icon: Icons.looks_two),
                        ByTabItem(label: 'Gamma', icon: Icons.looks_3),
                        ByTabItem(label: 'Delta', icon: Icons.looks_4),
                      ],
                      selectedIndex: selected,
                      onTabChanged: (val) => setState(() => selected = val),
                      animationCurve: Curves.easeOutCubic,
                      enableColorTransition: true,
                      enableLiquidMorphing: true,
                      liquidStretchFactor: 1.35,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Delta'), findsOneWidget);

      // Tap Delta (Tab 3)
      await tester.tap(find.text('Delta'));
      // Advance by half the duration
      await tester.pump(const Duration(milliseconds: 100));

      // Mid-flight: tap Beta (Tab 1)
      await tester.tap(find.text('Beta'));
      await tester.pump(const Duration(milliseconds: 80));

      // Mid-flight: tap Gamma (Tab 2)
      await tester.tap(find.text('Gamma'));
      await tester.pump(const Duration(milliseconds: 50));

      // Settle animation to completion
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(selected, equals(2));
    });

    testWidgets(
        'supports indicatorStyle: underline, isScrollable, isDisabled, and tooltip',
        (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ByTabBar(
                      tabs: const [
                        ByTabItem(label: 'Tab 1', tooltip: 'First Tab'),
                        ByTabItem(label: 'Tab 2', isDisabled: true),
                        ByTabItem(label: 'Tab 3'),
                        ByTabItem(label: 'Tab 4'),
                        ByTabItem(label: 'Tab 5'),
                        ByTabItem(label: 'Tab 6'),
                      ],
                      selectedIndex: selected,
                      onTabChanged: (val) => setState(() => selected = val),
                      isScrollable: true,
                      indicatorStyle: ByTabIndicatorStyle.underline,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Verify tabs rendered
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);

      // Tap disabled tab - should not change selected
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();
      expect(selected, equals(0));

      // Tap tab 3 - should select tab 3
      await tester.tap(find.text('Tab 3'));
      await tester.pumpAndSettle();
      expect(selected, equals(2));
    });

    testWidgets(
        'underline indicator on light background selects high-contrast text color (not white)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: ByTabBar(
              tabs: const [
                ByTabItem(label: 'Home'),
                ByTabItem(label: 'Explore'),
              ],
              selectedIndex: 0,
              onTabChanged: (_) {},
              indicatorStyle: ByTabIndicatorStyle.underline,
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFF4F46E5),
            ),
          ),
        ),
      );

      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.color, isNot(equals(Colors.white)));
      expect(homeText.style?.color, equals(const Color(0xFF4F46E5)));
    });

    testWidgets(
        'pill indicator on rightmost tab fits symmetrically inside border without clipping',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: ByTabBar(
                  tabs: const [
                    ByTabItem(label: 'Overview'),
                    ByTabItem(label: 'Analytics'),
                    ByTabItem(label: 'Settings'),
                  ],
                  selectedIndex: 2,
                  onTabChanged: (_) {},
                  height: 46.0,
                  borderWidth: 1.0,
                  padding: const EdgeInsets.all(4.0),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final positionedWidgets =
          tester.widgetList<Positioned>(find.byType(Positioned));
      // First positioned widget is the sliding indicator
      final indicatorPos = positionedWidgets.first;
      // Width 360, padding 4 on each side, border 1 on each side -> innerWidth = 360 - 8 - 2 = 350
      // 3 tabs -> tabWidth = 350 / 3 = 116.6666...
      // Selected index 2 -> left = 2 * (350 / 3) = 233.333...
      // width = 350 / 3 = 116.666...
      // left + width = 350.0 exactly matching innerWidth
      expect(indicatorPos.left, closeTo(233.33, 0.1));
      expect(indicatorPos.width, closeTo(116.67, 0.1));
      expect((indicatorPos.left ?? 0) + (indicatorPos.width ?? 0),
          closeTo(350.0, 0.01));
    });

    testWidgets(
        'scrollable tab bar wraps in ClipRRect with innerClipRadius and absorbs scroll notifications',
        (tester) async {
      int scrollNotificationCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 250,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (_) {
                    scrollNotificationCount++;
                    return false;
                  },
                  child: ByTabBar(
                    tabs: const [
                      ByTabItem(label: 'Tab 1'),
                      ByTabItem(label: 'Tab 2'),
                      ByTabItem(label: 'Tab 3'),
                      ByTabItem(label: 'Tab 4'),
                      ByTabItem(label: 'Tab 5'),
                    ],
                    selectedIndex: 0,
                    onTabChanged: (_) {},
                    isScrollable: true,
                    borderRadius: BorderRadius.circular(24.0),
                    padding: const EdgeInsets.all(4.0),
                    borderWidth: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find ClipRRect within ByTabBar
      final clipFinder = find.descendant(
        of: find.byType(ByTabBar),
        matching: find.byType(ClipRRect),
      );
      expect(clipFinder, findsOneWidget);

      final clipRRect = tester.widget<ClipRRect>(clipFinder);
      // concentric: 24 - 4 (padding) - 1 (borderWidth) = 19
      expect(clipRRect.borderRadius, equals(BorderRadius.circular(19.0)));
      expect(clipRRect.clipBehavior, equals(Clip.antiAlias));

      // Scroll horizontally
      await tester.drag(find.text('Tab 1'), const Offset(-100, 0));
      await tester.pumpAndSettle();

      // The ancestor NotificationListener must NOT receive the scroll notification
      expect(scrollNotificationCount, equals(0));
    });

    testWidgets('underline style wraps in ClipRRect with innerClipRadius',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: ByTabBar(
                  tabs: const [
                    ByTabItem(label: 'Tab 1'),
                    ByTabItem(label: 'Tab 2'),
                  ],
                  selectedIndex: 0,
                  onTabChanged: (_) {},
                  indicatorStyle: ByTabIndicatorStyle.underline,
                  borderRadius: BorderRadius.circular(16.0),
                  padding: const EdgeInsets.all(2.0),
                  borderWidth: 1.0,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final clipFinder = find.descendant(
        of: find.byType(ByTabBar),
        matching: find.byType(ClipRRect),
      );
      expect(clipFinder, findsOneWidget);

      final clipRRect = tester.widget<ClipRRect>(clipFinder);
      // concentric: 16 - 2 - 1 = 13
      expect(clipRRect.borderRadius, equals(BorderRadius.circular(13.0)));
      expect(clipRRect.clipBehavior, equals(Clip.antiAlias));
    });
  });
}
