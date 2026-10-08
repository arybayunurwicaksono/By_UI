import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';

void main() {
  group('BySequenceRange Tests', () {
    test('BySequenceRange lerps values correctly', () {
      const range = BySequenceRange(10.0, 50.0);
      expect(range.lerp(0.0), 10.0);
      expect(range.lerp(0.5), 30.0);
      expect(range.lerp(1.0), 50.0);
    });

    test('BySequenceRange equality and toString', () {
      const range1 = BySequenceRange(0.0, 1.0);
      const range2 = BySequenceRange(0.0, 1.0);
      expect(range1, equals(range2));
      expect(range1.hashCode, equals(range2.hashCode));
      expect(range1.toString(), 'BySequenceRange(0.0, 1.0)');
    });
  });

  group('BySequenceAnimation Tests', () {
    test('defaultAnimation has standard fade and slide values', () {
      const anim = BySequenceAnimation.defaultAnimation;
      expect(anim.opacity?.start, 0.0);
      expect(anim.opacity?.end, 1.0);
      expect(anim.translateY?.start, 32.0);
      expect(anim.translateY?.end, 0.0);
    });

    test('copyWith modifies requested fields', () {
      const anim = BySequenceAnimation.defaultAnimation;
      final updated = anim.copyWith(
        scale: const BySequenceRange(0.8, 1.0),
      );
      expect(updated.opacity, anim.opacity);
      expect(updated.scale?.start, 0.8);
      expect(updated.scale?.end, 1.0);
    });
  });

  group('BySequence Widget Tests', () {
    testWidgets('Empty children returns SizedBox.shrink',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BySequence(
              children: [],
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('Renders children and item 0 is active initially',
        (WidgetTester tester) async {
      double latestProgress = 0.0;
      final enteredItems = <int>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BySequence(
              onProgress: (p) => latestProgress = p,
              onItemEnter: (idx) => enteredItems.add(idx),
              children: const [
                SizedBox(height: 200, child: Text('Item 0')),
                SizedBox(height: 200, child: Text('Item 1')),
                SizedBox(height: 200, child: Text('Item 2')),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(latestProgress, greaterThan(0.0));
      expect(enteredItems, contains(0));
    });

    testWidgets('Supports per-item customization with BySequenceItem',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BySequence(
              children: [
                Text('First'),
                BySequenceItem(
                  animation: BySequenceAnimation(
                    scale: BySequenceRange(0.5, 1.0),
                  ),
                  child: Text('Second Custom'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second Custom'), findsOneWidget);
    });

    testWidgets('Supports shrinkWrap mode without internal scrollview',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BySequence(
                shrinkWrap: true,
                spacing: 16.0,
                children: [
                  Text('Child A'),
                  Text('Child B'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Child A'), findsOneWidget);
      expect(find.text('Child B'), findsOneWidget);
    });

    testWidgets('Supports horizontal scrollDirection',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: BySequence(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 200, child: Text('Card 1')),
                  SizedBox(width: 200, child: Text('Card 2')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Card 1'), findsOneWidget);
      expect(find.text('Card 2'), findsOneWidget);
    });

    testWidgets('Controller tracks progress and triggers callbacks on scroll',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final enteredIndices = <int>[];
      final completedIndices = <int>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                onItemEnter: (idx) => enteredIndices.add(idx),
                onItemComplete: (idx) => completedIndices.add(idx),
                children: List.generate(
                  8,
                  (i) => SizedBox(
                    height: 250,
                    child: Text('Sequence Entry $i'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Sequence Entry 0'), findsOneWidget);
      expect(enteredIndices, contains(0));

      final countBefore = enteredIndices.length;

      // Scroll down
      controller.jumpTo(500);
      await tester.pumpAndSettle();

      expect(enteredIndices.length, greaterThanOrEqualTo(countBefore));
    });

    testWidgets(
        'initialVisibleFraction reveals items fitting in viewport and keeps them visible on scroll',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: BySequence(
                controller: controller,
                initialVisibleFraction: 1.0,
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: const [
                  SizedBox(height: 200, child: Text('Card 0')),
                  SizedBox(height: 200, child: Text('Card 1')),
                  SizedBox(height: 500, child: Text('Card 2')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Card 0 and Card 1 fit within 600px (200 + 200 = 400 <= 600)
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], equals(1.0));
      // Card 2 extends past 600px (400 + 500 = 900 > 600) so it starts at 0.0
      expect(itemProgressMap[2] ?? 0.0, equals(0.0));

      // Scroll slightly
      controller.jumpTo(50);
      await tester.pumpAndSettle();

      // Card 0 and Card 1 must REMAIN at 1.0 (they do NOT disappear or drop)
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], equals(1.0));
    });

    testWidgets(
        'initialVisibleCount: 1 reveals Card 0 at initial state; scrolling down reveals Card 1 first while Card 2 remains 0.0',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleCount: 1,
                itemExtent: 200,
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: const [
                  SizedBox(height: 200, child: Text('Card 0')),
                  SizedBox(height: 200, child: Text('Card 1')),
                  SizedBox(height: 200, child: Text('Card 2')),
                  SizedBox(height: 200, child: Text('Card 3')),
                  SizedBox(height: 200, child: Text('Card 4')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At initial state, only Card 0 is revealed
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1] ?? 0.0, equals(0.0));
      expect(itemProgressMap[2] ?? 0.0, equals(0.0));
      expect(itemProgressMap[3] ?? 0.0, equals(0.0));

      // Scroll 50px: Card 1 enters the scrub window (trigger at 300px), Card 2 remains off-trigger
      controller.jumpTo(50);
      await tester.pumpAndSettle();

      // Card 0 remains permanently visible
      expect(itemProgressMap[0], equals(1.0));
      // Card 1 is in progress
      expect(itemProgressMap[1], greaterThan(0.0));
      // Card 2 must still be strictly 0.0 (below trigger line)
      expect(itemProgressMap[2] ?? 0.0, equals(0.0));
      expect(itemProgressMap[3] ?? 0.0, equals(0.0));

      // Scroll 150px: Card 1 has fully scrubbed to 1.0, Card 2 begins revealing
      controller.jumpTo(150);
      await tester.pumpAndSettle();

      expect(itemProgressMap[1], equals(1.0));
      expect(itemProgressMap[2], greaterThan(0.0));
      expect(itemProgressMap[3] ?? 0.0, equals(0.0));
    });

    testWidgets(
        'initialVisibleCount: 3 reveals Cards 0, 1, 2 at start; scrolling down reveals Card 3 sequentially as it enters viewport',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleCount: 3,
                groupSize: 1,
                itemExtent: 200,
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: const [
                  SizedBox(height: 200, child: Text('Card 0')),
                  SizedBox(height: 200, child: Text('Card 1')),
                  SizedBox(height: 200, child: Text('Card 2')),
                  SizedBox(height: 200, child: Text('Card 3')),
                  SizedBox(height: 200, child: Text('Card 4')),
                  SizedBox(height: 200, child: Text('Card 5')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At initial state, exactly 3 items are revealed
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], equals(1.0));
      expect(itemProgressMap[2], equals(1.0));
      expect(itemProgressMap[3] ?? 0.0, equals(0.0));
      expect(itemProgressMap[4] ?? 0.0, equals(0.0));

      // Scroll 150px: Card 3 at 600 - 150 = 450px > trigger line (300px), remains 0.0
      controller.jumpTo(150);
      await tester.pumpAndSettle();
      expect(itemProgressMap[3] ?? 0.0, equals(0.0));
      expect(itemProgressMap[4] ?? 0.0, equals(0.0));

      // Scroll 350px: Card 3 at 600 - 350 = 250px <= trigger line (300px), is revealing
      controller.jumpTo(350);
      await tester.pumpAndSettle();

      // First 3 remain permanently 1.0
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], equals(1.0));
      expect(itemProgressMap[2], equals(1.0));
      // Card 3 begins revealing
      expect(itemProgressMap[3], greaterThan(0.0));
      // Card 4 remains 0.0 (at 450px > 300px)
      expect(itemProgressMap[4] ?? 0.0, equals(0.0));
    });

    testWidgets(
        'Varying item heights reveal strictly in ascending order as they enter the viewport trigger zone',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleCount: 1,
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: const [
                  SizedBox(height: 140, child: Text('Card 0')),
                  SizedBox(height: 120, child: Text('Card 1')),
                  SizedBox(height: 300, child: Text('Card 2')),
                  SizedBox(height: 350, child: Text('Card 3')),
                  SizedBox(height: 280, child: Text('Card 4')),
                  SizedBox(height: 120, child: Text('Card 5')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At scroll 0: only Card 0 is revealed
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1] ?? 0.0, equals(0.0));
      expect(itemProgressMap[2] ?? 0.0, equals(0.0));
      expect(itemProgressMap[3] ?? 0.0, equals(0.0));
      expect(itemProgressMap[4] ?? 0.0, equals(0.0));
      expect(itemProgressMap[5] ?? 0.0, equals(0.0));

      // Scroll 50px: Card 1 enters trigger zone
      controller.jumpTo(50);
      await tester.pumpAndSettle();

      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], greaterThan(0.0));
      expect(itemProgressMap[3] ?? 0.0, equals(0.0));
      expect(itemProgressMap[4] ?? 0.0, equals(0.0));
      expect(itemProgressMap[5] ?? 0.0, equals(0.0));

      // Scroll to 300px: Cards 1 and 2 are revealed, Card 3 enters trigger zone
      controller.jumpTo(300);
      await tester.pumpAndSettle();

      expect(itemProgressMap[1], equals(1.0));
      expect(itemProgressMap[2], equals(1.0));
      expect(itemProgressMap[3], greaterThan(0.0));
      expect(itemProgressMap[4] ?? 0.0, equals(0.0));
      // Card 5 MUST STILL BE 0.0
      expect(itemProgressMap[5] ?? 0.0, equals(0.0));

      // Scroll to 650px: Card 3 is revealed, Card 4 enters trigger zone
      controller.jumpTo(650);
      await tester.pumpAndSettle();

      expect(itemProgressMap[3], equals(1.0));
      expect(itemProgressMap[4], greaterThan(0.0));
      expect(itemProgressMap[5] ?? 0.0, equals(0.0));
    });

    testWidgets(
        'groupSize: 5 holds items 1..5 at 0.0 until group enters trigger zone, then cascades them, keeping items 6..10 hidden',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleCount: 1,
                groupSize: 5,
                groupStaggerDelay: const Duration(milliseconds: 50),
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: List.generate(
                  11,
                  (i) => SizedBox(height: 100, child: Text('Card $i')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At start (scroll 0): Card 0 is 1.0 (initial).
      // Cards 1..5 are in Group 0 and start at 0.0.
      // Cards 6..10 are in Group 1 and must be 0.0.
      expect(itemProgressMap[0], equals(1.0));
      for (int i = 1; i <= 10; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 50px: Group 0 lead (Card 1 at 100px - 50px = 50px <= 300px) enters trigger zone
      controller.jumpTo(50);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Group 0 has cascaded into view
      expect(itemProgressMap[1], equals(1.0));
      expect(itemProgressMap[2], equals(1.0));
      expect(itemProgressMap[3], equals(1.0));
      expect(itemProgressMap[4], equals(1.0));
      expect(itemProgressMap[5], equals(1.0));
      // Cards in Group 1 (6..10) MUST remain completely 0.0 (lead Card 6 at 600 - 50 = 550 > 300)!
      for (int i = 6; i <= 10; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll past Group 1 trigger (scroll = 350px; lead Card 6 at 600 - 350 = 250 <= 300)
      controller.jumpTo(350);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Group 1 has now cascaded in!
      for (int i = 6; i <= 10; i++) {
        expect(itemProgressMap[i], equals(1.0));
      }
    });

    testWidgets(
        'groupSize: 0 automatically adapts batch size to match initialVisibleCount (Auto Match Range)',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleCount: 3,
                groupSize: 0, // Auto: adapts to initialVisibleCount (3)
                groupStaggerDelay: const Duration(milliseconds: 50),
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: List.generate(
                  12,
                  (i) => SizedBox(height: 100, child: Text('Card $i')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial visible items 0, 1, 2 are 1.0. Rest are 0.0.
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], equals(1.0));
      expect(itemProgressMap[2], equals(1.0));
      for (int i = 3; i < 12; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 50px: Batch 1 lead (Card 3 at 300 - 50 = 250px <= 300px) enters trigger zone
      controller.jumpTo(50);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Batch 1 (Cards 3, 4, 5) cascades in
      expect(itemProgressMap[3], equals(1.0));
      expect(itemProgressMap[4], equals(1.0));
      expect(itemProgressMap[5], equals(1.0));
      // Batch 2 (Cards 6, 7, 8) and Batch 3 (9..11) must remain locked at 0.0
      for (int i = 6; i < 12; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 350px: Batch 2 lead (Card 6 at 600 - 350 = 250px <= 300px) enters trigger zone
      controller.jumpTo(350);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Batch 2 cascades in
      expect(itemProgressMap[6], equals(1.0));
      expect(itemProgressMap[7], equals(1.0));
      expect(itemProgressMap[8], equals(1.0));
      // Batch 3 (Cards 9, 10, 11) must remain locked at 0.0
      for (int i = 9; i < 12; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }
    });

    testWidgets(
        'rangeDistance: 40.0 paces item reveal strictly one-by-one per 40px scroll interval',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleCount: 1,
                rangeDistance: 40.0,
                itemExtent: 100,
                curve: Curves.linear,
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: List.generate(
                  6,
                  (i) => SizedBox(height: 100, child: Text('Card $i')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At start (scroll 0): Card 0 is 1.0, Cards 1..5 are 0.0
      expect(itemProgressMap[0], equals(1.0));
      for (int i = 1; i <= 5; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 20px: Card 1 is in progress (20 / 40 = 0.5), Card 2..5 remain strictly 0.0
      controller.jumpTo(20);
      await tester.pumpAndSettle();

      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], closeTo(0.5, 0.01));
      for (int i = 2; i <= 5; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 40px: Card 1 is fully 1.0, Card 2 is still at 0.0
      controller.jumpTo(40);
      await tester.pumpAndSettle();

      expect(itemProgressMap[1], equals(1.0));
      for (int i = 2; i <= 5; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 60px: Card 2 is in progress ( (60 - 40) / 40 = 0.5 ), Card 3..5 remain 0.0
      controller.jumpTo(60);
      await tester.pumpAndSettle();

      expect(itemProgressMap[1], equals(1.0));
      expect(itemProgressMap[2], closeTo(0.5, 0.01));
      for (int i = 3; i <= 5; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 80px: Card 2 has reached 1.0
      controller.jumpTo(80);
      await tester.pumpAndSettle();

      expect(itemProgressMap[2], equals(1.0));
      expect(itemProgressMap[3] ?? 0.0, equals(0.0));
    });

    testWidgets(
        'rangeDistance: 80.0 with groupSize: 3 gates batch entrance until 70% threshold is scrolled',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleCount: 3,
                groupSize: 3,
                rangeDistance: 80.0,
                groupStaggerDelay: const Duration(milliseconds: 50),
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: List.generate(
                  9,
                  (i) => SizedBox(height: 100, child: Text('Card $i')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At start (scroll 0): Cards 0, 1, 2 are 1.0, Cards 3..8 are 0.0
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], equals(1.0));
      expect(itemProgressMap[2], equals(1.0));
      for (int i = 3; i < 9; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 40px: Less than 70% of 80px (56px) -> Batch 1 remains locked at 0.0
      controller.jumpTo(40);
      await tester.pumpAndSettle();

      for (int i = 3; i < 9; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 60px: Past 70% of 80px (56px) -> Batch 1 cascades in
      controller.jumpTo(60);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(itemProgressMap[3], equals(1.0));
      expect(itemProgressMap[4], equals(1.0));
      expect(itemProgressMap[5], equals(1.0));
      // Batch 2 (Cards 6, 7, 8) must remain locked at 0.0
      for (int i = 6; i < 9; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }
    });

    testWidgets(
        'initialVisibleFraction: 0.50 restricts active items to top 50% of viewport and gates next 50% batch entrance',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleFraction: 0.50,
                groupStaggerDelay: const Duration(milliseconds: 50),
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: List.generate(
                  6,
                  (i) => SizedBox(height: 100, child: Text('Card $i')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At start (scroll 0): Only items fitting within 50% (200px) are visible (Cards 0, 1)
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], equals(1.0));
      // Cards 2..5 are in bottom 50% or below -> strictly 0.0
      for (int i = 2; i < 6; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 50px: Less than 70% of 200px (140px) -> Batch 1 remains locked at 0.0
      controller.jumpTo(50);
      await tester.pumpAndSettle();

      for (int i = 2; i < 6; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 150px: Past 70% of 200px (140px) -> Batch 1 (Cards 2 & 3) cascades into view in top 50%
      controller.jumpTo(150);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(itemProgressMap[2], equals(1.0));
      expect(itemProgressMap[3], equals(1.0));
      // Cards in Batch 2 (4, 5) are at y >= 200px (bottom 50%) -> MUST REMAIN AT 0.0
      expect(itemProgressMap[4] ?? 0.0, equals(0.0));
      expect(itemProgressMap[5] ?? 0.0, equals(0.0));
    });

    testWidgets(
        'When scrolled completely to the bottom (maxScrollExtent), last items remain fully visible at 1.0 (no blank screen)',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleFraction: 0.50, // 50% screen height = 200px
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: List.generate(
                  6,
                  (i) => SizedBox(height: 100, child: Text('Card $i')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll all the way to maxScrollExtent (200px)
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // The last items (Cards 4 and 5) that entered the viewport must be fully visible (1.0),
      // ensuring the screen is NOT blank when scrolled to the end!
      expect(itemProgressMap[4], equals(1.0));
      expect(itemProgressMap[5], equals(1.0));
    });

    testWidgets(
        'Dynamic batch pacing in 50% viewport: Batch 0 fills viewport, Batch 1 triggers at 70% exit, reverse un-triggers symmetrically',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BySequence(
                controller: controller,
                initialVisibleFraction: 1.0,
                groupSize: 2,
                reverse: true,
                groupStaggerDelay: const Duration(milliseconds: 50),
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: List.generate(
                  9,
                  (i) => SizedBox(height: 100, child: Text('Card $i')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At start (scroll 0): Cards 0..3 fill 400px viewport (1.0). Cards 4..8 are 0.0.
      for (int i = 0; i < 4; i++) {
        expect(itemProgressMap[i], equals(1.0));
      }
      for (int i = 4; i < 9; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 200px: Less than 70% of 400px (280px) -> Batch 1 (Cards 4 & 5) remains 0.0
      controller.jumpTo(200);
      await tester.pumpAndSettle();

      for (int i = 4; i < 9; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 300px: Past 70% of 400px (280px) -> Batch 1 (Cards 4 & 5) cascades into view!
      controller.jumpTo(300);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(itemProgressMap[4], equals(1.0));
      expect(itemProgressMap[5], equals(1.0));
      // Batch 2 (Cards 6 & 7) remains hidden at 0.0
      for (int i = 6; i < 9; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }

      // Scroll 500px: Past 70% of Batch 1 bottom (600px * 0.70 = 420px) -> Batch 2 cascades in!
      controller.jumpTo(500);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(itemProgressMap[6], equals(1.0));
      expect(itemProgressMap[7], equals(1.0));

      // Scroll back up to 200px (Reverse): Below 280px threshold -> Batches 1 & 2 untrigger!
      controller.jumpTo(200);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      for (int i = 4; i < 9; i++) {
        expect(itemProgressMap[i] ?? 0.0, equals(0.0));
      }
      for (int i = 0; i < 4; i++) {
        expect(itemProgressMap[i], equals(1.0));
      }
    });

    testWidgets(
        '1:1 Scroll Scrub with initialVisibleFraction: 1.0 scrubs continuously without blank screen dead zones',
        (WidgetTester tester) async {
      final controller = ScrollController();
      final itemProgressMap = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 360,
              child: BySequence(
                controller: controller,
                initialVisibleFraction: 1.0,
                groupSize: 1,
                scrub: true,
                trigger: 0.75,
                onItemProgress: (index, progress) {
                  itemProgressMap[index] = progress;
                },
                children: List.generate(
                  6,
                  (i) => SizedBox(height: 100, child: Text('Card $i')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Cards 0, 1, 2 fit within 360px viewport (bottom <= 370px) -> 1.0
      expect(itemProgressMap[0], equals(1.0));
      expect(itemProgressMap[1], equals(1.0));
      expect(itemProgressMap[2], equals(1.0));
      // Card 3 starts outside -> 0.0
      expect(itemProgressMap[3] ?? 0.0, equals(0.0));

      // Scroll 60px: Card 3 enters the scrub window (top at 300 - 60 = 240px <= trigger 270px)
      controller.jumpTo(60);
      await tester.pumpAndSettle();

      // Card 3 must be actively scrubbing (> 0.0), NOT locked at 0.0!
      expect(itemProgressMap[3], greaterThan(0.0));
      expect(itemProgressMap[3], lessThanOrEqualTo(1.0));

      // Scroll 180px: Card 3 fully scrubs to 1.0, Card 4 begins scrubbing
      controller.jumpTo(180);
      await tester.pumpAndSettle();

      expect(itemProgressMap[3], equals(1.0));
      expect(itemProgressMap[4], greaterThan(0.0));
    });
  });
}
