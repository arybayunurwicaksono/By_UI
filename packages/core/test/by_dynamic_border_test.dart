import 'package:by_ui/by_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ByDynamicBorder Model & Factories', () {
    test('default constructor initializes correctly', () {
      const border = ByDynamicBorder();
      expect(border.enabled, isTrue);
      expect(border.autoStart, isTrue);
      expect(border.width, equals(2.0));
      expect(
          border.colors, equals(const [Color(0xFF38BDF8), Color(0xFF6366F1)]));
      expect(border.origin, equals(ByBorderOrigin.topCenter));
      expect(border.duration, equals(const Duration(milliseconds: 1400)));
      expect(border.beamLength, equals(0.28));
      expect(border.shadowBlur, equals(3.0));
      expect(border.glowBlur, equals(3.0));
      expect(border.shadowWidth, equals(2.0));
      expect(border.shadowLength, isNull);
      expect(
          border.sensorResumeDelay, equals(const Duration(milliseconds: 300)));
      expect(border.sensorEntranceDuration,
          equals(const Duration(milliseconds: 400)));
    });

    test('.solid factory initializes single-color pulse', () {
      final border = ByDynamicBorder.solid(
        color: Colors.red,
        shadowColor: Colors.black,
        width: 2.0,
      );
      expect(border.colors, equals([Colors.red]));
      expect(border.shadowColor, equals(Colors.black));
      expect(border.glowColor, equals(Colors.black));
      expect(border.width, equals(2.0));
    });

    test('.gradient factory creates gradient-based pulse', () {
      const gradient = LinearGradient(colors: [Colors.green, Colors.yellow]);
      final border = ByDynamicBorder.gradient(
        gradient: gradient,
        width: 3.0,
        shadowLength: 0.15,
      );
      expect(border.gradient, equals(gradient));
      expect(border.width, equals(3.0));
      expect(border.shadowLength, equals(0.15));
    });

    test('.pulse factory creates multi-color pulse', () {
      final border = ByDynamicBorder.pulse(
        colors: [Colors.purple, Colors.pink],
        origin: ByBorderOrigin.topLeft,
        shadowWidth: 3.5,
      );
      expect(border.colors, equals([Colors.purple, Colors.pink]));
      expect(border.origin, equals(ByBorderOrigin.topLeft));
      expect(border.shadowWidth, equals(3.5));
    });

    test('copyWith properly overrides values', () {
      const border = ByDynamicBorder();
      final modified = border.copyWith(
        width: 4.0,
        origin: ByBorderOrigin.bottomRight,
        beamLength: 0.4,
        shadowLength: 0.20,
        shadowColor: Colors.amber,
      );
      expect(modified.width, equals(4.0));
      expect(modified.origin, equals(ByBorderOrigin.bottomRight));
      expect(modified.beamLength, equals(0.4));
      expect(modified.shadowLength, equals(0.20));
      expect(modified.shadowColor, equals(Colors.amber));
      expect(modified.duration, equals(border.duration));
    });
  });

  group('ByDynamicBorderController', () {
    test('attach and updatePulsingState trigger listeners', () {
      final controller = ByDynamicBorderController();
      bool listenerCalled = false;
      controller.addListener(() {
        listenerCalled = true;
      });

      bool pulsed = false;
      bool stopped = false;
      bool resetCalled = false;

      controller.attach(
        onPulse: () => pulsed = true,
        onStop: () => stopped = true,
        onReset: () => resetCalled = true,
      );

      controller.pulse();
      expect(pulsed, isTrue);

      controller.stop();
      expect(stopped, isTrue);

      controller.reset();
      expect(resetCalled, isTrue);

      expect(controller.isPulsing, isFalse);
      controller.updatePulsingState(true);
      expect(controller.isPulsing, isTrue);
      expect(listenerCalled, isTrue);

      controller.dispose();
    });
  });

  group('ByDynamicBorder Widget Integration', () {
    testWidgets('ByCard renders ByDynamicBorderLayer and executes pulse',
        (tester) async {
      final controller = ByDynamicBorderController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByCard(
                dynamicBorder: ByDynamicBorder(
                  controller: controller,
                  autoStart: false,
                  duration: const Duration(milliseconds: 600),
                ),
                child: const Text('Dynamic Border Card'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Dynamic Border Card'), findsOneWidget);
      expect(find.byType(ByDynamicBorderLayer), findsOneWidget);

      // Trigger pulse
      controller.pulse();
      await tester.pump();
      expect(controller.isPulsing, isTrue);

      // Advance halfway through pulse (Phase 2)
      await tester.pump(const Duration(milliseconds: 300));
      expect(controller.isPulsing, isTrue);

      // Complete pulse
      await tester.pump(const Duration(milliseconds: 400));
      expect(controller.isPulsing, isFalse);
    });

    testWidgets('ByCard sequential handover dims and restores sensor border',
        (tester) async {
      final controller = ByDynamicBorderController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByCard(
                variant: ByCardVariant.dynamicSensor,
                enableSensor: false,
                borderWidth: 2.0,
                dynamicBorder: ByDynamicBorder(
                  controller: controller,
                  autoStart: false,
                  duration: const Duration(milliseconds: 400),
                  sensorResumeDelay: const Duration(milliseconds: 200),
                  sensorEntranceDuration: const Duration(milliseconds: 300),
                ),
                child: const Text('Sensor Handover Card'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sensor Handover Card'), findsOneWidget);

      // Trigger pulse: should hold/dim sensor border
      controller.pulse();
      await tester.pump();
      expect(controller.isPulsing, isTrue);

      // Finish pulse (400ms)
      await tester.pump(const Duration(milliseconds: 450));
      expect(controller.isPulsing, isFalse);

      // Rest buffer (200ms)
      await tester.pump(const Duration(milliseconds: 200));

      // Sensor border ease-in animation completes (300ms)
      await tester.pump(const Duration(milliseconds: 350));
    });

    testWidgets('ByAppBar renders ByDynamicBorderLayer and triggers pulse',
        (tester) async {
      final controller = ByDynamicBorderController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ByAppBar(
              child: const Center(child: Text('App Bar Pulse')),
              dynamicBorder: ByDynamicBorder(
                controller: controller,
                autoStart: false,
                duration: const Duration(milliseconds: 500),
              ),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      expect(find.text('App Bar Pulse'), findsOneWidget);
      expect(find.byType(ByDynamicBorderLayer), findsOneWidget);

      controller.pulse();
      await tester.pump();
      expect(controller.isPulsing, isTrue);

      await tester.pump(const Duration(milliseconds: 600));
      expect(controller.isPulsing, isFalse);
    });

    testWidgets(
        'ByDynamicBorderLayer executes periodic pulses with rest intervals',
        (tester) async {
      final controller = ByDynamicBorderController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByDynamicBorderLayer(
                borderRadius: BorderRadius.circular(12.0),
                config: ByDynamicBorder.periodic(
                  interval: const Duration(milliseconds: 1000),
                  duration: const Duration(milliseconds: 500),
                  controller: controller,
                  autoStart: true,
                ),
                child: const SizedBox(width: 100, height: 40),
              ),
            ),
          ),
        ),
      );

      // Frame 1 post-frame callback starts first pulse
      await tester.pump();
      expect(controller.isPulsing, isTrue);

      // Finish first circuit (500ms)
      await tester.pump(const Duration(milliseconds: 550));
      expect(controller.isPulsing, isFalse); // Resting

      // Advance halfway through rest interval (500ms out of 1000ms)
      await tester.pump(const Duration(milliseconds: 500));
      expect(controller.isPulsing, isFalse); // Still resting

      // Advance remaining rest interval (500ms) -> triggers next pulse
      await tester.pump(const Duration(milliseconds: 550));
      expect(controller.isPulsing, isTrue); // Second pulse active!

      // Finish second circuit
      await tester.pump(const Duration(milliseconds: 550));
      expect(controller.isPulsing, isFalse); // Resting again
    });
  });
}
