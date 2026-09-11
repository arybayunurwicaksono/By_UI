import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';

void main() {
  group('ByToast Tests', () {
    testWidgets('ByToast.show renders toast in overlay', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ByToast.show(
                    context,
                    message: 'Hello ByToast!',
                    icon: Icons.check,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      // Initially no toast
      expect(find.text('Hello ByToast!'), findsNothing);

      // Tap button to trigger toast
      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Toast is visible in overlay
      expect(find.text('Hello ByToast!'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Clear toasts
      ByToast.clear();
      await tester.pumpAndSettle();
      expect(find.text('Hello ByToast!'), findsNothing);
    });

    testWidgets('ByToast supports custom suffix icon and tap callback', (
      WidgetTester tester,
    ) async {
      bool suffixTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ByToast.show(
                    context,
                    message: 'Item added',
                    suffixIcon: Icons.arrow_forward,
                    onSuffixTap: () {
                      suffixTapped = true;
                    },
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

      // Tap suffix icon
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump();
      expect(suffixTapped, isTrue);

      ByToast.clear();
      await tester.pumpAndSettle();
    });

    testWidgets('ByToast supports bottom positioning and presets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ByToast.showError(
                    context,
                    message: 'Printer error!',
                    position: ByToastPosition.bottom,
                  );
                },
                child: const Text('Trigger Error'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger Error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Printer error!'), findsOneWidget);
      expect(find.byIcon(Icons.error_rounded), findsOneWidget);

      ByToast.clear();
      await tester.pumpAndSettle();
    });

    testWidgets('ByToast close button dismisses item', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ByToast.show(
                    context,
                    message: 'Dismissible toast',
                    showCloseButton: true,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Dismissible toast'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Dismissible toast'), findsNothing);
    });

    testWidgets('ByToast tap message text morphs into detail dialog', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ByToast.show(
                    context,
                    message: 'Tap to see transaction',
                    enableTapToExpand: true,
                    detailTitle: 'Transaction Details',
                    detailMessage: 'Payment #1042 was successful.',
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Tap to see transaction'), findsOneWidget);
      expect(find.text('Transaction Details'), findsNothing);

      // Tap the message text to expand dialog
      await tester.tap(find.text('Tap to see transaction'));
      await tester.pump();
      await tester.pump(
        const Duration(milliseconds: 450),
      ); // allow morph animation

      // Detail dialog is visible
      expect(find.text('Transaction Details'), findsOneWidget);
      expect(find.text('Payment #1042 was successful.'), findsOneWidget);

      // Verify dialog card height is compact and content-adaptive (not fixed to 360)
      final cardFinder = find.descendant(
        of: find.byType(ByToastMorphDialog),
        matching: find.byType(ClipRRect),
      );
      expect(cardFinder, findsOneWidget);
      final cardSize = tester.getSize(cardFinder);
      expect(cardSize.height, lessThan(250.0));

      // Tap 'X' close button on dialog
      await tester.tap(find.byKey(const Key('by_toast_dialog_close')));
      await tester.pumpAndSettle();

      expect(find.text('Transaction Details'), findsNothing);

      ByToast.clear();
      await tester.pumpAndSettle();
    });

    testWidgets('ByToast drag towards center morphs into detail dialog', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ByToast.show(
                    context,
                    message: 'Drag me down to center',
                    enableDragToExpand: true,
                    detailTitle: 'Order Details',
                    detailMessage: 'Order #999 confirmed.',
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Drag me down to center'), findsOneWidget);
      expect(find.text('Order Details'), findsNothing);

      // Drag downward towards center
      await tester.drag(
        find.text('Drag me down to center'),
        const Offset(0, 80),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 450));

      // Detail dialog is visible
      expect(find.text('Order Details'), findsOneWidget);
      expect(find.text('Order #999 confirmed.'), findsOneWidget);

      // Close dialog
      await tester.tap(find.byKey(const Key('by_toast_dialog_close')));
      await tester.pumpAndSettle();

      expect(find.text('Order Details'), findsNothing);

      ByToast.clear();
      await tester.pumpAndSettle();
    });

    testWidgets('ByToast swipe away from center dismisses toast', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ByToast.show(context, message: 'Swipe me up to dismiss');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Swipe me up to dismiss'), findsOneWidget);

      // Swipe upward to dismiss
      await tester.drag(
        find.text('Swipe me up to dismiss'),
        const Offset(0, -60),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Swipe me up to dismiss'), findsNothing);

      ByToast.clear();
      await tester.pumpAndSettle();
    });
  });
}
