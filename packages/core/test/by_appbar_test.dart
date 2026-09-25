import 'package:by_ui/by_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ByAppBar renders empty widget by default when child is null', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: ByAppBar(),
        ),
      ),
    );

    expect(find.byType(ByAppBar), findsOneWidget);
  });

  testWidgets('ByAppBar renders custom child when provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: ByAppBar(
            child: Center(child: Text('Custom Navigation Title')),
          ),
        ),
      ),
    );

    expect(find.text('Custom Navigation Title'), findsOneWidget);
  });

  testWidgets(
    'ByAppBar transitions to floating state when scroll threshold is exceeded',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ByScrollScope(
            scrollThreshold: 10.0,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: const ByAppBar(
                scrollThreshold: 10.0,
                child: Text('Floating Bar Test'),
              ),
              body: ListView(
                children: List.generate(
                  30,
                  (i) => SizedBox(
                    height: 50,
                    child: Text('Item $i'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Floating Bar Test'), findsOneWidget);

      // Scroll list down past threshold
      await tester.drag(find.byType(ListView), const Offset(0, -50));
      await tester.pumpAndSettle();

      // Verify app bar is still visible and rendered in floating state
      expect(find.text('Floating Bar Test'), findsOneWidget);
    },
  );

  testWidgets('ByAppBar supports dynamic motion tilt parameters', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: ByAppBar(
            enableHoverTilt: true,
            manualTilt: Offset(0.5, -0.5),
            child: Text('Sensor Bar'),
          ),
          body: SizedBox.expand(),
        ),
      ),
    );

    expect(find.text('Sensor Bar'), findsOneWidget);
  });

  testWidgets('ByAppBar.getContentTopPadding calculates correct padding', (
    WidgetTester tester,
  ) async {
    late double topPadding;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 30.0)),
          child: Builder(
            builder: (context) {
              topPadding = ByAppBar.getContentTopPadding(
                context,
                toolbarHeight: 56.0,
                extra: 14.0,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    // 30.0 (safeArea.top) + 56.0 (toolbarHeight) + 14.0 (extra) = 100.0
    expect(topPadding, equals(100.0));
  });

  testWidgets(
    'ByAppBar renders dynamic gradient border with hover tilt without recursion',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: ByAppBar(
              borderGradient: ByAppBar.defaultSensorGradient,
              enableHoverTilt: true,
              child: Text('Dynamic Border Bar'),
            ),
            body: SizedBox.expand(),
          ),
        ),
      );

      expect(find.text('Dynamic Border Bar'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      // Simulate mouse hover over the app bar
      final gesture =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.text('Dynamic Border Bar')));
      await tester.pumpAndSettle();

      expect(find.text('Dynamic Border Bar'), findsOneWidget);
      await gesture.removePointer();
    },
  );

  testWidgets('ByAppBar defaults to zero border width and covers notch when static', (
    WidgetTester tester,
  ) async {
    const appBar = ByAppBar();
    expect(appBar.borderWidth, equals(0.0));
    expect(appBar.floatingBorderWidth, equals(0.0));

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(top: 24.0)),
          child: Scaffold(
            appBar: ByAppBar(
              backgroundColor: Color(0xFF1E293B),
            ),
          ),
        ),
      ),
    );

    // Verify notch cover is present with top background color when padding.top > 0
    final animatedOpacityFinder = find.byType(AnimatedOpacity);
    expect(animatedOpacityFinder, findsOneWidget);
    final animatedOpacity = tester.widget<AnimatedOpacity>(animatedOpacityFinder);
    expect(animatedOpacity.opacity, equals(1.0));

    final decoratedBoxFinder = find.descendant(
      of: animatedOpacityFinder,
      matching: find.byType(DecoratedBox),
    );
    expect(decoratedBoxFinder, findsOneWidget);
    final decoratedBox = tester.widget<DecoratedBox>(decoratedBoxFinder);
    final boxDecoration = decoratedBox.decoration as BoxDecoration;
    expect(boxDecoration.color, equals(const Color(0xFF1E293B)));
  });

  testWidgets(
    'ByAppBar animates notch cover to transparent when floating state is activated',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(top: 24.0)),
            child: ByScrollScope(
              scrollThreshold: 10.0,
              child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: const ByAppBar(
                  scrollThreshold: 10.0,
                  backgroundColor: Color(0xFF1E293B),
                  child: Text('Floating Test'),
                ),
                body: ListView(
                  children: List.generate(
                    30,
                    (i) => SizedBox(
                      height: 50,
                      child: Text('Item $i'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Initially not floating: notch cover opacity is 1.0
      AnimatedOpacity opacityWidget = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(opacityWidget.opacity, equals(1.0));

      // Scroll past threshold to trigger floating state
      await tester.drag(find.byType(ListView), const Offset(0, -50));
      await tester.pumpAndSettle();

      // Floating is now active: notch cover opacity animates to 0.0
      opacityWidget = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(opacityWidget.opacity, equals(0.0));
    },
  );

  testWidgets(
    'ByAppBar defaults enableInnerShadow to false and supports enabling it',
    (WidgetTester tester) async {
      const defaultBar = ByAppBar(
        child: Text('Default Shadow Test'),
      );

      expect(defaultBar.enableInnerShadow, isFalse);
      expect(defaultBar.enableInnerGlow, isFalse);
      expect(defaultBar.innerShadowOpacity, isNull);
      expect(defaultBar.innerGlowOpacity, isNull);

      const enabledBar = ByAppBar(
        enableInnerShadow: true,
        innerShadowOpacity: 0.75,
        child: Text('Enabled Shadow Test'),
      );

      expect(enabledBar.enableInnerShadow, isTrue);
      expect(enabledBar.enableInnerGlow, isTrue);
      expect(enabledBar.innerShadowOpacity, equals(0.75));
      expect(enabledBar.innerGlowOpacity, equals(0.75));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: enabledBar,
          ),
        ),
      );

      expect(find.text('Enabled Shadow Test'), findsOneWidget);
    },
  );
}
