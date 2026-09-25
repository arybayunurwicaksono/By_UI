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

    testWidgets(
      'ByToast message defaults to maxLines = 3 and overflow = TextOverflow.ellipsis',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.show(
                      context,
                      message: 'Line 1\nLine 2\nLine 3\nLine 4\nLine 5',
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

        final textFinder = find.text('Line 1\nLine 2\nLine 3\nLine 4\nLine 5');
        expect(textFinder, findsOneWidget);

        final textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.maxLines, 3);
        expect(textWidget.overflow, TextOverflow.ellipsis);

        ByToast.clear();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'ByToast supports customizable maxLines, overflow, and titleMaxLines',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.show(
                      context,
                      title: 'My Custom Title\nSecond Title Line',
                      message: 'Custom message line 1\nLine 2',
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      titleMaxLines: 1,
                      titleOverflow: TextOverflow.fade,
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

        final titleWidget = tester.widget<Text>(
          find.text('My Custom Title\nSecond Title Line'),
        );
        expect(titleWidget.maxLines, 1);
        expect(titleWidget.overflow, TextOverflow.fade);

        final msgWidget = tester.widget<Text>(
          find.text('Custom message line 1\nLine 2'),
        );
        expect(msgWidget.maxLines, 1);
        expect(msgWidget.overflow, TextOverflow.clip);

        ByToast.clear();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'ByToast long message with default settings opens dialog showing full text on tap',
      (WidgetTester tester) async {
        const longMessage =
            'Order #1042 has been placed successfully with 3 items. Receipt sent to thermal printer.';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.show(
                      context,
                      title: 'Order Completed',
                      message: longMessage,
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

        // Toast card has maxLines 3 and ellipsis
        final cardTextWidget = tester.widget<Text>(find.text(longMessage));
        expect(cardTextWidget.maxLines, 3);
        expect(cardTextWidget.overflow, TextOverflow.ellipsis);

        // Tap the message text to open the dialog
        await tester.tap(find.text(longMessage));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 450));

        // In the dialog, the full message is displayed and ByToastMorphDialog is present
        expect(find.byType(ByToastMorphDialog), findsOneWidget);
        expect(find.text('Order Completed'), findsOneWidget);
        expect(find.text(longMessage), findsOneWidget);

        // Close dialog
        await tester.tap(find.byKey(const Key('by_toast_dialog_close')));
        await tester.pumpAndSettle();

        expect(find.byType(ByToastMorphDialog), findsNothing);

        ByToast.clear();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'ByToast backgroundOpacity reduces background surface alpha while leaving foreground text color untouched',
      (WidgetTester tester) async {
        const testBgColor = Color(0xFF10B981);
        const testTextColor = Colors.white;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.show(
                      context,
                      message: 'Translucent Background',
                      backgroundColor: testBgColor,
                      textColor: testTextColor,
                      backgroundOpacity: 0.6,
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

        // Find the card container decoration
        final containerFinder = find.descendant(
          of: find.byType(ByToastCard),
          matching: find.byType(Container),
        );
        expect(containerFinder, findsWidgets);

        // Find the specific container with BoxDecoration
        bool foundDecoratedCard = false;
        for (final element in containerFinder.evaluate()) {
          final widget = element.widget as Container;
          final decoration = widget.decoration;
          if (decoration is BoxDecoration && decoration.color != null) {
            // Verify background opacity has been multiplied (1.0 * 0.6 = 0.6)
            expect(decoration.color!.a, closeTo(0.6, 0.01));
            foundDecoratedCard = true;
            break;
          }
        }
        expect(foundDecoratedCard, isTrue);

        // Verify text color is untouched (still full opacity 1.0)
        final textWidget =
            tester.widget<Text>(find.text('Translucent Background'));
        expect(textWidget.style?.color?.a ?? 1.0, closeTo(1.0, 0.01));

        ByToast.clear();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'ByToastMorphDialog maintains fully solid background even when toast backgroundOpacity is reduced',
      (WidgetTester tester) async {
        const testBgColor = Color(0xFF10B981);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.show(
                      context,
                      message: 'Tap to Morph',
                      backgroundColor: testBgColor,
                      backgroundOpacity: 0.4,
                      enableTapToExpand: true,
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

        // Tap the message to expand into dialog
        await tester.tap(find.text('Tap to Morph'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 450));

        expect(find.byType(ByToastMorphDialog), findsOneWidget);

        // Verify the dialog card maintains full solid alpha (1.0)
        final dialogContainerFinder = find.descendant(
          of: find.byType(ByToastMorphDialog),
          matching: find.byType(Container),
        );
        bool foundSolidDialog = false;
        for (final element in dialogContainerFinder.evaluate()) {
          final widget = element.widget as Container;
          final decoration = widget.decoration;
          if (decoration is BoxDecoration && decoration.color == testBgColor) {
            expect(decoration.color!.a, 1.0);
            foundSolidDialog = true;
            break;
          }
        }
        expect(foundSolidDialog, isTrue);

        // Dismiss dialog
        await tester.tap(find.byKey(const Key('by_toast_dialog_close')));
        await tester.pumpAndSettle();

        ByToast.clear();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'ByToast supports corner positions (topRight, topLeft, bottomRight, bottomLeft)',
      (WidgetTester tester) async {
        expect(ByToastPosition.topLeft.isTop, isTrue);
        expect(ByToastPosition.topLeft.isLeft, isTrue);
        expect(ByToastPosition.topLeft.isRight, isFalse);
        expect(ByToastPosition.topLeft.isCenter, isFalse);

        expect(ByToastPosition.topRight.isTop, isTrue);
        expect(ByToastPosition.topRight.isRight, isTrue);

        expect(ByToastPosition.bottomLeft.isBottom, isTrue);
        expect(ByToastPosition.bottomLeft.isLeft, isTrue);

        expect(ByToastPosition.bottomRight.isBottom, isTrue);
        expect(ByToastPosition.bottomRight.isRight, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.show(
                      context,
                      message: 'Desktop Corner Notification',
                      position: ByToastPosition.topRight,
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

        expect(find.text('Desktop Corner Notification'), findsOneWidget);

        final animatedPosFinder = find.byType(AnimatedPositioned);
        expect(animatedPosFinder, findsWidgets);

        final animatedPos =
            tester.widget<AnimatedPositioned>(animatedPosFinder.first);
        expect(animatedPos.right, 16.0);
        expect(animatedPos.left, isNull);
        expect(animatedPos.width, 400.0);

        ByToast.clear();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'ByToast supports customizable textSize and titleSize',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.show(
                      context,
                      title: 'Title with custom size',
                      message: 'Message with custom size',
                      titleSize: 16.0,
                      textSize: 14.5,
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

        final titleWidget =
            tester.widget<Text>(find.text('Title with custom size'));
        expect(titleWidget.style?.fontSize, 16.0);

        final msgWidget =
            tester.widget<Text>(find.text('Message with custom size'));
        expect(msgWidget.style?.fontSize, 14.5);

        ByToast.clear();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'ByToast preset showSuccess supports customizable textSize and titleSize',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByToast.showSuccess(
                      context,
                      title: 'Success Title',
                      message: 'Success Message',
                      titleSize: 15.0,
                      textSize: 12.0,
                    );
                  },
                  child: const Text('Show Success'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Success'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        final titleWidget = tester.widget<Text>(find.text('Success Title'));
        expect(titleWidget.style?.fontSize, 15.0);

        final msgWidget = tester.widget<Text>(find.text('Success Message'));
        expect(msgWidget.style?.fontSize, 12.0);

        ByToast.clear();
        await tester.pumpAndSettle();
      },
    );
  });
}
