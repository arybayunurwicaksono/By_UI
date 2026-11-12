import 'package:by_ui/by_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    ByToast.defaultPositionResolver = (context) {
      final width = MediaQuery.of(context).size.width;
      return width >= 768 ? ByToastPosition.bottomRight : ByToastPosition.top;
    };
  });

  tearDown(() {
    ByToast.clear();
    ByToast.defaultPositionResolver = null;
  });

  group('ByToast responsive positioning & modal morphing in ux_sample', () {
    testWidgets(
      'Desktop/Web viewport (1920x1080): Toast anchors at bottomRight, max 400px width (not full-width)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.show(
                      context,
                      title: 'Explore Update',
                      message: 'New recommended post discovered in your feed.',
                    );
                  },
                  child: const Text('Trigger Desktop Toast'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger Desktop Toast'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Explore Update'), findsOneWidget);
        expect(
          find.text('New recommended post discovered in your feed.'),
          findsOneWidget,
        );

        final animatedPosFinder = find.byType(AnimatedPositioned);
        expect(animatedPosFinder, findsWidgets);

        final animatedPos =
            tester.widget<AnimatedPositioned>(animatedPosFinder.first);

        // Desktop corner toast specifications:
        // 1. Anchored bottom-right
        expect(animatedPos.right, 16.0);
        expect(animatedPos.left, isNull);
        expect(animatedPos.bottom, isNotNull);
        expect(animatedPos.top, isNull);

        // 2. Not full-width: capped at 400.0px
        expect(animatedPos.width, 400.0);

        // 3. Test tap-to-expand morphing dialog
        await tester.tap(find.text('New recommended post discovered in your feed.'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 450));

        expect(find.byType(ByToastMorphDialog), findsOneWidget);

        // Close modal
        await tester.tap(find.byKey(const Key('by_toast_dialog_close')));
        await tester.pumpAndSettle();

        expect(find.byType(ByToastMorphDialog), findsNothing);
      },
    );

    testWidgets(
      'Mobile viewport (360x800): Toast anchors at top, full-width between margins',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.show(
                      context,
                      title: 'Mobile Sync',
                      message: 'Vault balances refreshed successfully.',
                    );
                  },
                  child: const Text('Trigger Mobile Toast'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger Mobile Toast'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Mobile Sync'), findsOneWidget);

        final animatedPosFinder = find.byType(AnimatedPositioned);
        expect(animatedPosFinder, findsWidgets);

        final animatedPos =
            tester.widget<AnimatedPositioned>(animatedPosFinder.first);

        // Mobile top toast specifications:
        // 1. Anchored top
        expect(animatedPos.top, isNotNull);
        expect(animatedPos.bottom, isNull);

        // 2. Full-width between 16px margins (left: 16, right: 16, width: null)
        expect(animatedPos.left, 16.0);
        expect(animatedPos.right, 16.0);
        expect(animatedPos.width, isNull);

        // 3. Drag down towards center morphs into modal dialog
        await tester.drag(
          find.text('Vault balances refreshed successfully.'),
          const Offset(0, 80),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 450));

        expect(find.byType(ByToastMorphDialog), findsOneWidget);

        // Close modal
        await tester.tap(find.byKey(const Key('by_toast_dialog_close')));
        await tester.pumpAndSettle();

        expect(find.byType(ByToastMorphDialog), findsNothing);
      },
    );
  });
}
