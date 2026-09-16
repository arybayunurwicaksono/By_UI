import 'package:by_ui/by_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BySelectOption Tests', () {
    testWidgets('renders label and handles tap event', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BySelectOption(
              label: const Text('Option 1'),
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BySelectOption(
              label: const Text('With Icon'),
              isSelected: true,
              icon: const Icon(Icons.star),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });

    testWidgets('selected state changes border and subtle background',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                BySelectOption(
                  key: const ValueKey('unselected'),
                  label: const Text('Unselected'),
                  isSelected: false,
                  selectedBorderColor: const Color(0xFF6366F1),
                  unselectedBorderColor: const Color(0xFF334155),
                  selectedBackgroundColor: const Color(0x226366F1),
                  unselectedBackgroundColor: Colors.transparent,
                ),
                BySelectOption(
                  key: const ValueKey('selected'),
                  label: const Text('Selected'),
                  isSelected: true,
                  selectedBorderColor: const Color(0xFF6366F1),
                  unselectedBorderColor: const Color(0xFF334155),
                  selectedBackgroundColor: const Color(0x226366F1),
                  unselectedBackgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      );

      final unselectedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byKey(const ValueKey('unselected')),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final unselectedDec = unselectedContainer.decoration as BoxDecoration;
      expect(unselectedDec.color, equals(Colors.transparent));

      final selectedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byKey(const ValueKey('selected')),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final selectedDec = selectedContainer.decoration as BoxDecoration;
      expect(selectedDec.color, equals(const Color(0x226366F1)));
    });
  });

  group('BySelectOptionGroup Tests', () {
    testWidgets('renders multiple options horizontally and notifies selection',
        (tester) async {
      int selected = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: BySelectOptionGroup<int>(
                  selectedValue: selected,
                  items: const [
                    BySelectOptionItem(value: 0, label: 'First'),
                    BySelectOptionItem(value: 1, label: 'Second'),
                    BySelectOptionItem(value: 2, label: 'Third'),
                  ],
                  onSelected: (val) {
                    setState(() => selected = val);
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Third'), findsOneWidget);

      await tester.tap(find.text('Second'));
      await tester.pumpAndSettle();

      expect(selected, equals(1));
    });
  });
}
