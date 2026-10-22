import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';

void main() {
  group('ByAutoShimmer & Skeleton Ecosystem Tests', () {
    testWidgets('ByBone renders standalone without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ByBone.text(width: 120),
                ByBone.circular(size: 40),
                ByBone.rect(width: 200, height: 100),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ByBone), findsNWidgets(3));
    });

    testWidgets('ByShimmerScope coordinates phase across multiple bones',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ByShimmerScope(
              child: Column(
                children: [
                  ByBone.text(width: 100),
                  ByBone.text(width: 150),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ByShimmerScope), findsOneWidget);
      expect(find.byType(ByBone), findsNWidgets(2));
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('ByAutoShimmer renders skeletonBuilder during isLoading: true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ByAutoShimmer(
              isLoading: true,
              skeletonBuilder: (context) => const Text('SKELETON_PLACEHOLDER'),
              child: const Text('LIVE_CONTENT'),
            ),
          ),
        ),
      );

      expect(find.text('SKELETON_PLACEHOLDER'), findsOneWidget);
      expect(find.text('LIVE_CONTENT'), findsNothing);
    });

    testWidgets(
        'ByAutoShimmer transitions to live content when isLoading: false',
        (tester) async {
      bool isRevealed = false;
      bool loading = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    ByAutoShimmer(
                      isLoading: loading,
                      skeletonBuilder: (context) =>
                          const Text('SKELETON_PLACEHOLDER'),
                      onRevealComplete: () => isRevealed = true,
                      child: const Text('LIVE_CONTENT'),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => loading = false),
                      child: const Text('TOGGLE'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('SKELETON_PLACEHOLDER'), findsOneWidget);
      expect(find.text('LIVE_CONTENT'), findsNothing);

      await tester.tap(find.text('TOGGLE'));
      await tester.pumpAndSettle();

      expect(find.text('LIVE_CONTENT'), findsOneWidget);
      expect(isRevealed, isTrue);
    });

    testWidgets(
        'BySkeletonStyle supports full customization tokens and copyWith',
        (tester) async {
      const customStyle = BySkeletonStyle(
        variant: BySkeletonVariant.solid,
        baseColor: Colors.blueGrey,
        highlightColor: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        scanlineOpacity: 0.3,
        shimmerDuration: Duration(milliseconds: 2000),
        borderColor: Colors.amber,
        borderWidth: 2.0,
        shimmerWidthFactor: 2.0,
        scanlineSpacing: 8.0,
      );

      expect(customStyle.shimmerDuration,
          equals(const Duration(milliseconds: 2000)));
      expect(customStyle.borderColor, equals(Colors.amber));
      expect(customStyle.borderWidth, equals(2.0));
      expect(customStyle.shimmerWidthFactor, equals(2.0));
      expect(customStyle.scanlineSpacing, equals(8.0));

      final modified = customStyle.copyWith(
        borderWidth: 3.5,
        shimmerDuration: const Duration(milliseconds: 1000),
      );
      expect(modified.borderWidth, equals(3.5));
      expect(
          modified.shimmerDuration, equals(const Duration(milliseconds: 1000)));
      expect(modified.borderColor, equals(Colors.amber));
    });

    testWidgets(
        'ByBone renders with direct color, border, and margin overrides',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ByBone(
              width: 100,
              height: 50,
              baseColor: Colors.purple,
              highlightColor: Colors.cyan,
              borderColor: Colors.white,
              borderWidth: 1.5,
              margin: EdgeInsets.all(8.0),
            ),
          ),
        ),
      );

      expect(find.byType(ByBone), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets(
        'ByAutoShimmer renders with custom padding, background, and dynamic border configurations',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ByAutoShimmer(
              isLoading: true,
              backgroundColor: Colors.black54,
              borderColor: Colors.indigo,
              borderWidth: 2.0,
              padding: EdgeInsets.all(12.0),
              dynamicBorderWidth: 3.0,
              dynamicBorderGlowBlur: 14.0,
              dynamicBorderDuration: Duration(milliseconds: 1800),
              child: Text('CHILD_CONTENT'),
            ),
          ),
        ),
      );

      expect(find.byType(ByAutoShimmer), findsOneWidget);
      expect(find.byType(DecoratedBox), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets(
        'ByAutoShimmer supports card and listTile factory constructors and direction: diagonal',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ByAutoShimmer.card(
                  isLoading: true,
                  direction: ByShimmerDirection.diagonal,
                  child: const Text('CARD_CONTENT'),
                ),
                ByAutoShimmer.listTile(
                  isLoading: true,
                  child: const Text('TILE_CONTENT'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ByBone), findsWidgets);
      expect(find.byType(ByAutoShimmer), findsNWidgets(2));
    });

    testWidgets(
        'ByAutoShimmer and ByBone support all ByShimmerDirection variants',
        (tester) async {
      for (final dir in ByShimmerDirection.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ByAutoShimmer(
                isLoading: true,
                direction: dir,
                skeletonBuilder: (context) => Column(
                  children: [
                    ByBone.text(direction: dir, width: 100, height: 16),
                    ByBone.circular(direction: dir, size: 40),
                    ByBone(direction: dir, width: 80, height: 20),
                  ],
                ),
                child: const Text('CONTENT'),
              ),
            ),
          ),
        );
        expect(find.byType(ByBone), findsNWidgets(3));
        expect(tester.takeException(), isNull);
      }
    });
  });
}
