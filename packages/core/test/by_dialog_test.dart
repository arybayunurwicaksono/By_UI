import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';

void main() {
  group('ByDialog Tests', () {
    testWidgets('ByDialog.alert displays and closes with button tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ByDialog.alert(
                    context,
                    title: 'Alert Title',
                    message: 'Alert Message Content',
                  );
                },
                child: const Text('Show Alert'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Alert'));
      await tester.pumpAndSettle();

      expect(find.text('Alert Title'), findsOneWidget);
      expect(find.text('Alert Message Content'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.byType(ByButton), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Alert Title'), findsNothing);
    });

    testWidgets(
      'ByDialog.confirm returns true on confirm and false on cancel',
      (WidgetTester tester) async {
        bool? confirmResult;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    confirmResult = await ByDialog.confirm(
                      context,
                      title: 'Confirm Title',
                      message: 'Confirm Message Content',
                    );
                  },
                  child: const Text('Show Confirm'),
                ),
              ),
            ),
          ),
        );

        // Test cancel
        await tester.tap(find.text('Show Confirm'));
        await tester.pumpAndSettle();

        expect(find.text('Confirm Title'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
        expect(find.byType(ByButton), findsNWidgets(2));

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(confirmResult, isFalse);

        // Test confirm
        await tester.tap(find.text('Show Confirm'));
        await tester.pumpAndSettle();

        expect(find.byType(ByButton), findsNWidgets(2));

        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(confirmResult, isTrue);
      },
    );

    testWidgets(
      'ByDialog.confirm supports button customization, reverseButtonOrder, and callbacks',
      (WidgetTester tester) async {
        bool onConfirmCalled = false;
        bool onCancelCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    await ByDialog.confirm(
                      context,
                      title: 'Custom Buttons',
                      message: 'Testing custom button styling and callbacks',
                      confirmText: 'Accept',
                      cancelText: 'Dismiss',
                      confirmColor: Colors.purple,
                      confirmTextColor: Colors.yellow,
                      cancelColor: Colors.grey,
                      cancelTextColor: Colors.cyan,
                      buttonBorderRadius: BorderRadius.circular(20),
                      reverseButtonOrder: true,
                      onConfirm: () => onConfirmCalled = true,
                      onCancel: () => onCancelCalled = true,
                    );
                  },
                  child: const Text('Show Custom Confirm'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Custom Confirm'));
        await tester.pumpAndSettle();

        // Verify custom button labels are rendered
        expect(find.text('Accept'), findsOneWidget);
        expect(find.text('Dismiss'), findsOneWidget);
        expect(find.byType(ByButton), findsNWidgets(2));

        // Verify reversed order: Accept should be rendered to the left of Dismiss
        final acceptOffset = tester.getTopLeft(find.text('Accept'));
        final dismissOffset = tester.getTopLeft(find.text('Dismiss'));
        expect(acceptOffset.dx, lessThan(dismissOffset.dx));

        // Tap dismiss (Cancel) and check callback
        await tester.tap(find.text('Dismiss'));
        await tester.pumpAndSettle();
        expect(onCancelCalled, isTrue);
        expect(onConfirmCalled, isFalse);

        // Open again to test onConfirm
        await tester.tap(find.text('Show Custom Confirm'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Accept'));
        await tester.pumpAndSettle();
        expect(onConfirmCalled, isTrue);
      },
    );

    testWidgets(
      'ByDialog positive button defaults to zero border',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ByDialog.alert(
                      context,
                      title: 'Border Test',
                      message: 'Checking zero border on positive button',
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        final buttonFinder = find.byType(ByButton);
        expect(buttonFinder, findsOneWidget);
        final byButton = tester.widget<ByButton>(buttonFinder);
        expect(byButton.borderWidth, equals(0.0));
      },
    );
  });
}
