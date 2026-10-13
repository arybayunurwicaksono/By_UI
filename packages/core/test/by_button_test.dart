import 'dart:async';

import 'package:by_ui/by_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ByButton Widget Tests', () {
    testWidgets('renders custom widget child correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, key: Key('star-icon')),
                    Text('Custom Child', key: Key('custom-text')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('star-icon')), findsOneWidget);
      expect(find.byKey(const Key('custom-text')), findsOneWidget);
    });

    testWidgets('renders prefix and suffix in proper order', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                prefix: const Icon(Icons.arrow_back, key: Key('prefix-icon')),
                suffix:
                    const Icon(Icons.arrow_forward, key: Key('suffix-icon')),
                child: const Text('Action'),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('prefix-icon')), findsOneWidget);
      expect(find.byKey(const Key('suffix-icon')), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('triggers onPressed when tapped and enabled', (tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () => tapCount++,
                child: const Text('Tap Me'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(tapCount, equals(1));
    });

    testWidgets('does not trigger onPressed when isEnabled is false',
        (tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                isEnabled: false,
                onPressed: () => tapCount++,
                child: const Text('Disabled'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(tapCount, equals(0));
    });

    testWidgets(
        'auto-async Future automatically triggers loading and reverts to idle',
        (tester) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () => completer.future,
                child: const Text('Async Action'),
              ),
            ),
          ),
        ),
      );

      // Initially idle, child is visible
      expect(find.text('Async Action'), findsOneWidget);

      // Tap to trigger async Future
      await tester.tap(find.text('Async Action'));
      await tester.pump(); // Start async handler
      await tester
          .pump(const Duration(milliseconds: 350)); // Advance morph animation

      // Should find circular ByDynamicBorderLayer indicator during loading
      expect(find.byType(ByDynamicBorderLayer), findsWidgets);

      // Complete future to succeed
      completer.complete();
      await tester.pump(); // Rebuild with success state
      await tester.pump(
          const Duration(milliseconds: 500)); // Advance success icon scale

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // Advance past resultDuration (1000ms)
      await tester.pump(const Duration(milliseconds: 1000));
      // Advance morph reverse animation (300ms)
      await tester.pump(const Duration(milliseconds: 350));

      // Should be back to normal idle content
      expect(find.text('Async Action'), findsOneWidget);
    });

    testWidgets('explicit isLoading true renders circular dynamic border',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                isLoading: true,
                onPressed: () {},
                child: const Text('Loading Button'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 350));
      expect(find.byType(ByDynamicBorderLayer), findsWidgets);
    });

    testWidgets('supports floating badge', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                badge: const CircleAvatar(
                  radius: 8,
                  key: Key('button-badge'),
                ),
                child: const Text('Notifications'),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('button-badge')), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('supports variants constructors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ByButton(
                  onPressed: () {},
                  child: const Text('Filled'),
                ),
                ByButton.gradient(
                  onPressed: () {},
                  child: const Text('Gradient'),
                ),
                ByButton.outline(
                  onPressed: () {},
                  child: const Text('Outline'),
                ),
                ByButton.ghost(
                  onPressed: () {},
                  child: const Text('Ghost'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Filled'), findsOneWidget);
      expect(find.text('Gradient'), findsOneWidget);
      expect(find.text('Outline'), findsOneWidget);
      expect(find.text('Ghost'), findsOneWidget);
    });

    testWidgets(
        'supports direct custom properties without overflow during morph',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                borderRadius: BorderRadius.circular(20.0),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.amber,
                loadingPulseColors: const [Colors.amber, Colors.orange],
                prefix: const Icon(Icons.rocket),
                suffix: const Icon(Icons.arrow_forward),
                child: const Text('Very Long Action Button Label For Testing'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Very Long Action Button Label For Testing'),
          findsOneWidget);

      // Trigger tap to verify tap doesn't throw flex overflow
      await tester.tap(find.text('Very Long Action Button Label For Testing'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 200));

      // No RenderFlex overflow occurs!
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'supports custom borderWidth, borderColor, successIconColor, and errorIconColor',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                borderWidth: 3.5,
                borderColor: Colors.red,
                state: ByButtonState.idle,
                child: const Text('Custom Border Button'),
              ),
            ),
          ),
        ),
      );

      // Check AnimatedContainer border in idle state
      final containerFinder = find.descendant(
        of: find.byType(ByButton),
        matching: find.byType(AnimatedContainer),
      );
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<AnimatedContainer>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
      final border = decoration.border as Border;
      expect(border.top.width, equals(3.5));
      expect(border.top.color.toARGB32(), equals(Colors.red.toARGB32()));

      // Now verify success state renders successIconColor
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                state: ByButtonState.success,
                successIconColor: Colors.greenAccent,
                child: const Text('Custom Border Button'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      final iconFinder = find.byIcon(Icons.check_rounded);
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, equals(Colors.greenAccent));
    });

    testWidgets(
        'default filled button uses Cyan, defaultBorderWidth and pulse width are 2.5',
        (tester) async {
      expect(
          ByButtonDefaults.defaultButtonColor, equals(const Color(0xFF06B6D4)));
      expect(ByButtonDefaults.defaultBorderWidth, equals(2.5));
      expect(ByButtonDefaults.defaultPulseWidth, equals(2.5));
      expect(ByButtonDefaults.defaultPulseShadowBlur, equals(10.0));
      expect(ByButtonDefaults.defaultPulseShadowWidth, equals(4.0));
    });

    testWidgets(
        'unified border: borderWidth dictates pulse layer and base border fades to 0.0 alpha during loading (sequential handover)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                borderWidth: 3.0,
                borderColor: const Color(0xFFFFFFFF),
                isLoading: true,
                child: const Text('Loading Button'),
              ),
            ),
          ),
        ),
      );

      // Advance morph animation (300ms) to circular loading state
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Check AnimatedContainer border has dimmed alpha to 0.0 during loading
      final containerFinder = find.descendant(
        of: find.byType(ByButton),
        matching: find.byType(AnimatedContainer),
      );
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<AnimatedContainer>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
      final border = decoration.border as Border;
      expect(border.top.width, equals(3.0));
      // Base border alpha should be completely hidden (0.0) during loading
      expect(border.top.color.a, equals(0.0));

      // Verify ByDynamicBorderLayer adopts the exact same borderWidth (3.0)
      final dynamicLayers = tester
          .widgetList<ByDynamicBorderLayer>(find.byType(ByDynamicBorderLayer))
          .toList();
      expect(dynamicLayers, isNotEmpty);
      for (final layer in dynamicLayers) {
        expect(layer.config.width, equals(3.0));
      }
    });

    testWidgets(
        'renders unified dynamicBorder and adapts to continuous circular pulse during loading',
        (tester) async {
      final borderController = ByDynamicBorderController();
      final customBorder = ByDynamicBorder(
        colors: const [Color(0xFF00FF00), Color(0xFF0000FF)],
        width: 3.5,
        periodicInterval: const Duration(seconds: 4),
        controller: borderController,
        autoStart: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                dynamicBorder: customBorder,
                child: const Text('Periodic Button'),
              ),
            ),
          ),
        ),
      );

      // Verify single ByDynamicBorderLayer is rendered with customBorder
      final layerFinder = find.byType(ByDynamicBorderLayer);
      expect(layerFinder, findsOneWidget);
      final initialLayer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(initialLayer.config.colors, equals(customBorder.colors));
      expect(initialLayer.config.width, equals(3.5));
      expect(initialLayer.config.periodicInterval,
          equals(const Duration(seconds: 4)));

      // Rebuild with isLoading = true
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                isLoading: true,
                dynamicBorder: customBorder,
                child: const Text('Periodic Button'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // In loading, the SAME dynamicBorder is adapted with continuous repeat and zero interval
      final loadingLayer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(loadingLayer.config.colors, equals(customBorder.colors));
      expect(loadingLayer.config.width, equals(3.5));
      expect(loadingLayer.config.repeatCount, isNull);
      expect(loadingLayer.config.periodicInterval, equals(Duration.zero));
    });

    testWidgets(
        'zero borderWidth button renders no static border, but still wraps with active pulse layer on perimeter',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                borderWidth: 0.0,
                dynamicBorder: const ByDynamicBorder(
                  width: 2.5,
                  colors: [Colors.cyan],
                  autoStart: true,
                ),
                child: const Text('Zero Border Button'),
              ),
            ),
          ),
        ),
      );

      // Check AnimatedContainer has NO static border
      final containerFinder = find.descendant(
        of: find.byType(ByButton),
        matching: find.byType(AnimatedContainer),
      );
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<AnimatedContainer>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNull);

      // Verify ByDynamicBorderLayer wraps outer buttonBody and uses default 2.5px pulse width
      final layerFinder = find.byType(ByDynamicBorderLayer);
      expect(layerFinder, findsOneWidget);
      final layer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(layer.config.width, equals(2.5));
      expect(layer.child, equals(container));
    });

    testWidgets(
        'toggling isEnabled triggers state transition pulse with onSurface colors',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                isEnabled: true,
                child: const Text('Toggle State Button'),
              ),
            ),
          ),
        ),
      );

      // Now toggle to disabled
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Center(
              child: ByButton(
                onPressed: () {},
                isEnabled: false,
                child: const Text('Toggle State Button'),
              ),
            ),
          ),
        ),
      );

      await tester
          .pump(); // Frame to process didUpdateWidget and schedule pulse

      // Should render 1-shot ByDynamicBorderLayer with disableTransitionPulseColors default color
      final layerFinder = find.byType(ByDynamicBorderLayer);
      expect(layerFinder, findsOneWidget);
      final layer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(layer.config.repeatCount, equals(1));
      // First color should match ByButtonDefaults.disableTransitionPulseColors
      expect(
          layer.config.colors.first.toARGB32(),
          equals(
              ByButtonDefaults.disableTransitionPulseColors.first.toARGB32()));
    });

    testWidgets(
        'renders success and error icon with gradient ShaderMask when provided',
        (tester) async {
      const successGradient = LinearGradient(
        colors: [Color(0xFF34D399), Color(0xFF06B6D4)],
      );

      // Render success state with gradient
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                state: ByButtonState.success,
                successIconGradient: successGradient,
                child: const Text('Success Button'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(ShaderMask), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      const errorGradient = LinearGradient(
        colors: [Color(0xFFF87171), Color(0xFFFBBF24)],
      );

      // Render error state with gradient
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                state: ByButtonState.error,
                errorIconGradient: errorGradient,
                child: const Text('Error Button'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(ShaderMask), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });

    testWidgets(
        'passes loadingPulseGradient to ByDynamicBorder in loading state',
        (tester) async {
      const pulseGrad = LinearGradient(
        colors: [Color(0xFF00F0FF), Color(0xFFFF007F)],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                state: ByButtonState.loading,
                loadingPulseGradient: pulseGrad,
                child: const Text('Loading Button'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      final layerFinder = find.byType(ByDynamicBorderLayer);
      expect(layerFinder, findsOneWidget);
      final layer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(layer.config.gradient, equals(pulseGrad));
    });

    testWidgets(
        'smart cascading border widths: explicit loadingBorderWidth overrides idle borderWidth',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                state: ByButtonState.loading,
                borderWidth: 1.0,
                loadingBorderWidth: 4.0,
                child: const Text('Loading Button'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      final layerFinder = find.byType(ByDynamicBorderLayer);
      expect(layerFinder, findsOneWidget);
      final layer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(layer.config.width, equals(4.0));
    });

    testWidgets(
        'smart cascading border widths: loading inherits idle borderWidth when > 0 and loadingBorderWidth is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                state: ByButtonState.loading,
                borderWidth: 1.5,
                child: const Text('Loading Button'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      final layerFinder = find.byType(ByDynamicBorderLayer);
      expect(layerFinder, findsOneWidget);
      final layer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(layer.config.width, equals(1.5));
    });

    testWidgets(
        'smart cascading border widths: loading falls back to 2.5px when idle borderWidth is 0.0 or null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ByButton(
                state: ByButtonState.loading,
                borderWidth: 0.0,
                child: const Text('Loading Button'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      final layerFinder = find.byType(ByDynamicBorderLayer);
      expect(layerFinder, findsOneWidget);
      final layer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(layer.config.width, equals(ByButtonDefaults.defaultPulseWidth));
    });

    testWidgets('state transition pulse fires when isEnabled changes',
        (tester) async {
      bool isEnabled = true;
      final controller = ByDynamicBorderController();
      late void Function(void Function()) stateSetter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                stateSetter = setState;
                return Center(
                  child: ByButton(
                    isEnabled: isEnabled,
                    dynamicBorder: ByDynamicBorder(
                      controller: controller,
                      periodicInterval: const Duration(seconds: 4),
                    ),
                    onPressed: isEnabled ? () {} : null,
                    child: const Text('Test Button'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();

      // Now toggle isEnabled
      stateSetter(() {
        isEnabled = false;
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.isPulsing, isTrue);
    });
  });
}
