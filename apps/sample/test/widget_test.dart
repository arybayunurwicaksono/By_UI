import 'package:flutter_test/flutter_test.dart';
import 'package:sample/main.dart';

void main() {
  testWidgets('ByUISampleApp launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ByUISampleApp());
    await tester.pumpAndSettle();

    expect(find.text('ByToast'), findsWidgets);
    expect(find.text('Showcase'), findsOneWidget);
  });
}
