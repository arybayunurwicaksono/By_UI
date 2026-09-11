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

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(confirmResult, isFalse);

        // Test confirm
        await tester.tap(find.text('Show Confirm'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(confirmResult, isTrue);
      },
    );
  });
}
