import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ux_sample/screens/dashboard/widgets/dashboard_search_bar.dart';

void main() {
  group('DashboardSearchBar optical alignment and functional tests', () {
    testWidgets('DashboardSearchBar optical alignment metrics', (tester) async {
      final controller = TextEditingController(text: 'Search explore posts, topics, or creators...');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                child: DashboardSearchBar(
                  controller: controller,
                  hintText: 'Search explore posts, topics, or creators...',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(Icons.search_rounded);
      final textFinder = find.byType(EditableText);
      final barFinder = find.byType(DashboardSearchBar);

      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);

      final iconCenter = tester.getCenter(iconFinder);
      final textCenter = tester.getCenter(textFinder);
      final barBox = tester.getRect(barFinder);
      final textTopLeft = tester.getTopLeft(textFinder);
      final textHeight = tester.getSize(textFinder).height;

      final centerDiff = (textCenter.dy - iconCenter.dy).abs();
      final topGap = textTopLeft.dy - barBox.top;
      final bottomGap = barBox.bottom - (textTopLeft.dy + textHeight);

      debugPrint('SearchBar rect: $barBox (center: ${barBox.center.dy})');
      debugPrint('Icon center: $iconCenter');
      debugPrint('Text center: $textCenter');
      debugPrint('Center difference (|text - icon|): $centerDiff');
      debugPrint('Top gap: $topGap');
      debugPrint('Bottom gap: $bottomGap');

      // Container height must be stable at 44px
      expect(barBox.height, 44.0);

      // Icon center must be closely aligned with container center
      expect((iconCenter.dy - barBox.center.dy).abs(), lessThanOrEqualTo(1.0));

      // Text vertical center should be within 2.0px of icon center for optical compensation
      expect(centerDiff, lessThanOrEqualTo(2.0));

      // Top and bottom padding gaps should be balanced (gap asymmetry <= 3px for typography baseline offset)
      expect((topGap - bottomGap).abs(), lessThanOrEqualTo(3.0));
    });

    testWidgets('DashboardSearchBar clear button works and triggers callbacks', (tester) async {
      final controller = TextEditingController(text: 'Initial Query');
      addTearDown(controller.dispose);

      String? changedValue;
      bool clearTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                child: DashboardSearchBar(
                  controller: controller,
                  hintText: 'Search...',
                  onChanged: (val) => changedValue = val,
                  onClear: () => clearTriggered = true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Clear button should be visible when text is non-empty
      final clearFinder = find.byIcon(Icons.close_rounded);
      expect(clearFinder, findsOneWidget);

      // Tap clear button
      await tester.tap(clearFinder);
      await tester.pumpAndSettle();

      // Verify controller is empty and callbacks fired
      expect(controller.text, '');
      expect(changedValue, '');
      expect(clearTriggered, isTrue);

      // Clear button should disappear when empty
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });
  });
}
