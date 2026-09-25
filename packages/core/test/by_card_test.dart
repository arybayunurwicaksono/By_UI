import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';

void main() {
  group('ByCard Tests', () {
    testWidgets('ByCard renders child widget in normal mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ByCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets(
        'ByCard supports custom styling (backgroundColor, padding, margin)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ByCard(
              backgroundColor: Color(0xFF0F172A),
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.all(12),
              borderWidth: 2.0,
              borderColor: Color(0xFF6366F1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Text('Styled Card'),
            ),
          ),
        ),
      );

      expect(find.text('Styled Card'), findsOneWidget);
      final paddingWidget = tester.widget<Padding>(
        find.descendant(
          of: find.byType(ByCard),
          matching: find.byWidgetPredicate(
              (w) => w is Padding && w.padding == const EdgeInsets.all(24)),
        ),
      );
      expect(paddingWidget.padding, const EdgeInsets.all(24));
    });

    testWidgets('ByCard renders in gradient mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ByCard(
              variant: ByCardVariant.gradient,
              borderGradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
              shadowGradient: LinearGradient(
                colors: [Colors.blue, Colors.transparent],
              ),
              child: Text('Gradient Card'),
            ),
          ),
        ),
      );

      expect(find.text('Gradient Card'), findsOneWidget);
    });

    testWidgets('ByCard renders in dynamicSensor mode with manualTilt',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ByCard(
              variant: ByCardVariant.dynamicSensor,
              manualTilt: Offset(0.5, 0.8),
              child: Text('Sensor Card'),
            ),
          ),
        ),
      );

      expect(find.text('Sensor Card'), findsOneWidget);
    });

    testWidgets('ByCard triggers onTap callback when tapped',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ByCard(
              onTap: () => tapped = true,
              child: const Text('Tappable Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tappable Card'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets(
        'ByCard smoothly animates color changes via ImplicitlyAnimatedWidget',
        (WidgetTester tester) async {
      Color currentColor = const Color(0xFF10B981);

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: ByCard(
                  backgroundColor: currentColor,
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentColor = const Color(0xFFEF4444);
                      });
                    },
                    child: const Text('Change Color'),
                  ),
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Change Color'));
      // Pump mid-animation
      await tester.pump(const Duration(milliseconds: 150));
      // Pump to completion
      await tester.pumpAndSettle();

      expect(find.byType(ByCard), findsOneWidget);
    });

    test('ByTiltController clamps coordinates and resets properly', () {
      Offset? updatedTilt;
      final controller = ByTiltController(
        enableSensor: false,
        onTiltChanged: (tilt) => updatedTilt = tilt,
      );

      expect(controller.tiltNotifier.value, const Offset(0.0, 1.0));

      controller.setManualTilt(const Offset(2.5, -3.0));
      expect(controller.tiltNotifier.value.dx, inInclusiveRange(0.0, 1.0));
      expect(controller.tiltNotifier.value.dy, inInclusiveRange(-1.0, 1.0));
      expect(updatedTilt, isNotNull);

      controller.resetToNeutral();
      expect(controller.tiltNotifier.value, Offset.zero);
      controller.dispose();
    });

    test('ByTiltController allows dynamic onTiltChanged mutation', () {
      Offset? firstCallbackTilt;
      Offset? secondCallbackTilt;

      final controller = ByTiltController(
        enableSensor: false,
        onTiltChanged: (tilt) => firstCallbackTilt = tilt,
      );

      controller.setManualTilt(const Offset(0.4, 0.6));
      expect(firstCallbackTilt, const Offset(0.4, 0.6));

      // Reassign onTiltChanged
      controller.onTiltChanged = (tilt) => secondCallbackTilt = tilt;
      controller.setManualTilt(const Offset(0.8, -0.2));

      expect(secondCallbackTilt, const Offset(0.8, -0.2));
      controller.dispose();
    });

    testWidgets('ByCard renders correctly in table flat pose (Offset.zero)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ByCard(
              variant: ByCardVariant.dynamicSensor,
              manualTilt: Offset.zero,
              child: Text('Table Flat Card'),
            ),
          ),
        ),
      );

      expect(find.text('Table Flat Card'), findsOneWidget);
    });

    test(
        'ByTiltController smoothResetToNeutral animates smoothly to Offset.zero',
        () async {
      final controller = ByTiltController(
        enableSensor: false,
        initialTilt: const Offset(0.8, -0.6),
      );

      expect(controller.tiltNotifier.value, const Offset(0.8, -0.6));

      controller.smoothResetToNeutral(
        duration: const Duration(milliseconds: 60),
      );

      // Wait for timer ticks to finish
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(controller.tiltNotifier.value, Offset.zero);
      controller.dispose();
    });

    testWidgets(
        'ByCard.dynamicSensor convenience constructor renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ByCard.dynamicSensor(
              colors: const [Colors.cyan, Colors.indigo],
              child: const Text('Dynamic Sensor Named Card'),
            ),
          ),
        ),
      );

      expect(find.text('Dynamic Sensor Named Card'), findsOneWidget);
      final card = tester.widget<ByCard>(find.byType(ByCard));
      expect(card.variant, ByCardVariant.dynamicSensor);
      expect(card.enableSensor, isTrue);
      expect(card.enableHoverTilt, isTrue);
      expect(card.borderGradient, isNotNull);
    });

    testWidgets('ByCard.gradient convenience constructor renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ByCard.gradient(
              colors: const [Colors.purple, Colors.pink],
              child: const Text('Gradient Named Card'),
            ),
          ),
        ),
      );

      expect(find.text('Gradient Named Card'), findsOneWidget);
      final card = tester.widget<ByCard>(find.byType(ByCard));
      expect(card.variant, ByCardVariant.gradient);
      expect(card.borderGradient, isNotNull);
    });

    testWidgets('ByCard renders with enableInnerGlow in dynamicSensor variant',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ByCard.dynamicSensor(
              enableInnerGlow: true,
              innerGlowOpacity: 0.5,
              innerGlowBlur: 22.0,
              manualTilt: const Offset(0.3, 0.7),
              child: const Text('Inner Glow Sensor Card'),
            ),
          ),
        ),
      );

      expect(find.text('Inner Glow Sensor Card'), findsOneWidget);
      final card = tester.widget<ByCard>(find.byType(ByCard));
      expect(card.enableInnerGlow, isTrue);
      expect(card.innerGlowOpacity, 0.5);
      expect(card.innerGlowBlur, 22.0);
    });

    testWidgets('ByCard renders with enableInnerGlow in gradient variant',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ByCard.gradient(
              enableInnerGlow: true,
              colors: const [Colors.teal, Colors.amber],
              child: const Text('Inner Glow Gradient Card'),
            ),
          ),
        ),
      );

      expect(find.text('Inner Glow Gradient Card'), findsOneWidget);
      final card = tester.widget<ByCard>(find.byType(ByCard));
      expect(card.enableInnerGlow, isTrue);
    });
  });
}
