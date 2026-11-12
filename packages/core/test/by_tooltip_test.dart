import 'package:by_ui/by_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ByTooltip Tests', () {
    testWidgets('Hover enter shows tooltip at cursor position after openDelay',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByTooltip(
                openDelay: const Duration(milliseconds: 100),
                closeDelay: const Duration(milliseconds: 100),
                offset: const Offset(10, 10),
                width: 200,
                builder: (context) => const Text('Tooltip Content'),
                child: const Text('Hover Target'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hover Target'), findsOneWidget);
      expect(find.text('Tooltip Content'), findsNothing);

      // Create a mouse pointer
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Move over the target
      final targetCenter = tester.getCenter(find.text('Hover Target'));
      await gesture.moveTo(targetCenter);
      await tester.pump();

      // Before openDelay, tooltip is not yet visible
      expect(find.text('Tooltip Content'), findsNothing);

      // Advance past openDelay
      await tester.pump(const Duration(milliseconds: 120));
      await tester.pump(const Duration(milliseconds: 250)); // animation forward

      // Tooltip is now visible in the overlay!
      expect(find.text('Tooltip Content'), findsOneWidget);

      // Check position matches targetCenter + offset
      final tooltipTopLeft = tester.getTopLeft(find.text('Tooltip Content'));
      expect(tooltipTopLeft.dx, greaterThanOrEqualTo(targetCenter.dx));
      expect(tooltipTopLeft.dy, greaterThanOrEqualTo(targetCenter.dy));

      // Move away
      await gesture.moveTo(const Offset(5, 5));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      await tester.pump(const Duration(milliseconds: 250)); // animation reverse

      // Tooltip dismisses
      expect(find.text('Tooltip Content'), findsNothing);

      await gesture.removePointer();
    });

    testWidgets('Interactive bridge keeps tooltip open when hovering inside',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByTooltip(
                openDelay: const Duration(milliseconds: 50),
                closeDelay: const Duration(milliseconds: 150),
                offset: const Offset(5, 5),
                width: 150,
                builder: (context) => ElevatedButton(
                  onPressed: () {},
                  child: const Text('Action Button'),
                ),
                child: const Text('Target Trigger'),
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Move over target
      await gesture.moveTo(tester.getCenter(find.text('Target Trigger')));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Action Button'), findsOneWidget);

      // Move into the tooltip's action button within grace period
      final buttonCenter = tester.getCenter(find.text('Action Button'));
      await gesture.moveTo(buttonCenter);
      await tester.pump(const Duration(milliseconds: 200));

      // Tooltip must STAY OPEN because mouse is inside
      expect(find.text('Action Button'), findsOneWidget);

      await gesture.removePointer();
    });

    testWidgets('ByTooltipScope.close(context) dismisses the active tooltip',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByTooltip(
                openDelay: Duration.zero,
                builder: (context) => ElevatedButton(
                  onPressed: () => ByTooltipScope.close(context),
                  child: const Text('Close Me'),
                ),
                child: const Text('Click Target'),
              ),
            ),
          ),
        ),
      );

      // Open via mobile tap fallback
      await tester.tap(find.text('Click Target'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Close Me'), findsOneWidget);

      // Tap Close Me inside tooltip
      await tester.tap(find.text('Close Me'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Close Me'), findsNothing);
    });

    testWidgets('Auto-flips and clamps when cursor is near right/bottom edges',
        (tester) async {
      tester.view.physicalSize = const Size(600, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomRight,
              child: ByTooltip(
                openDelay: Duration.zero,
                width: 250,
                height: 150,
                builder: (context) => const Text('Edge Popover'),
                child: const Text('Corner Trigger'),
              ),
            ),
          ),
        ),
      );

      // Tap near bottom-right
      await tester.tap(find.text('Corner Trigger'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Edge Popover'), findsOneWidget);

      final cardRect = tester.getRect(find.text('Edge Popover'));
      // Must be safely inside 600x400 screen bounds
      expect(cardRect.right, lessThanOrEqualTo(600.0));
      expect(cardRect.bottom, lessThanOrEqualTo(400.0));
      expect(cardRect.left, greaterThanOrEqualTo(0.0));
      expect(cardRect.top, greaterThanOrEqualTo(0.0));
    });

    testWidgets('Integrates ByDynamicBorder laser pulse when configured',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByTooltip(
                openDelay: Duration.zero,
                dynamicBorder: const ByDynamicBorder(
                  enabled: true,
                  colors: [Colors.cyan, Colors.blue],
                ),
                builder: (context) => const Text('Glowing Tooltip'),
                child: const Text('Laser Trigger'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Laser Trigger'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Glowing Tooltip'), findsOneWidget);
      expect(find.byType(ByDynamicBorderLayer), findsOneWidget);
    });

    testWidgets(
        'ByMobileTrigger.longPress opens on long press but not on quick tap',
        (tester) async {
      int tapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByTooltip(
                openDelay: Duration.zero,
                mobileTrigger: ByMobileTrigger.longPress,
                builder: (context) => const Text('Long Press Content'),
                child: GestureDetector(
                  onTap: () => tapCount++,
                  child: const Text('Long Press Trigger'),
                ),
              ),
            ),
          ),
        ),
      );

      // Quick tap should execute child tap, not open tooltip
      await tester.tap(find.text('Long Press Trigger'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(tapCount, 1);
      expect(find.text('Long Press Content'), findsNothing);

      // Long press should open the tooltip
      await tester.longPress(find.text('Long Press Trigger'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Long Press Content'), findsOneWidget);
    });

    testWidgets('ByMobileTrigger.none disables touch activation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByTooltip(
                openDelay: Duration.zero,
                mobileTrigger: ByMobileTrigger.none,
                builder: (context) => const Text('Touch Disabled'),
                child: const Text('Disabled Touch Trigger'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled Touch Trigger'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Touch Disabled'), findsNothing);

      await tester.longPress(find.text('Disabled Touch Trigger'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Touch Disabled'), findsNothing);
    });

    testWidgets(
        'Coordinates translate properly when Overlay has an offset origin',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                const SizedBox(width: 200), // Left margin
                Expanded(
                  child: ClipRect(
                    child: Navigator(
                      onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 50),
                              child: ByTooltip(
                                openDelay: Duration.zero,
                                offset: const Offset(10, 10),
                                width: 120,
                                height: 80,
                                builder: (context) =>
                                    const Text('Offset Overlay Tooltip'),
                                child: const Text('Nested Trigger'),
                              ),
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
      );

      await tester.tap(find.text('Nested Trigger'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Offset Overlay Tooltip'), findsOneWidget);
      final cardRect = tester.getRect(find.text('Offset Overlay Tooltip'));
      expect(cardRect.left, greaterThanOrEqualTo(200.0));
    });

    testWidgets('Adapts background color dynamically to Light and Dark theme',
        (tester) async {
      final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

      await tester.pumpWidget(
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, themeMode, _) {
            return MaterialApp(
              themeMode: themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: Scaffold(
                body: Center(
                  child: ByTooltip(
                    openDelay: Duration.zero,
                    builder: (context) => const Text('Adaptive Tooltip'),
                    child: const Text('Theme Trigger'),
                  ),
                ),
              ),
            );
          },
        ),
      );

      // Open in Light mode
      await tester.tap(find.text('Theme Trigger'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Adaptive Tooltip'), findsOneWidget);

      final cardContainerFinder = find.ancestor(
        of: find.text('Adaptive Tooltip'),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(cardContainerFinder.first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.white);

      // Switch to Dark mode while tooltip is OPEN
      themeNotifier.value = ThemeMode.dark;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      final darkContainerFinder = find.ancestor(
        of: find.text('Adaptive Tooltip'),
        matching: find.byType(Container),
      );
      final darkContainer = tester.widget<Container>(darkContainerFinder.first);
      final darkDecoration = darkContainer.decoration as BoxDecoration;
      expect(darkDecoration.color, const Color(0xFF0F172A));
    });

    testWidgets(
        'Backward compatibility: ByHoverCard alias and cardBuilder work correctly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByHoverCard(
                openDelay: Duration.zero,
                cardBuilder: (context) => ElevatedButton(
                  onPressed: () => ByHoverCardScope.close(context),
                  child: const Text('Close Alias Card'),
                ),
                child: const Text('Legacy HoverCard Trigger'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Legacy HoverCard Trigger'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Close Alias Card'), findsOneWidget);

      await tester.tap(find.text('Close Alias Card'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Close Alias Card'), findsNothing);
    });
  });
}
