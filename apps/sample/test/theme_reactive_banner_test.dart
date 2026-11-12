import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample/models/app_theme_store.dart';
import 'package:sample/screens/tooltip_showcase_screen.dart';
import 'package:sample/theme/app_theme.dart';

void main() {
  testWidgets('Verify TooltipShowcaseScreen const banner text reacts dynamically to live drawer theme switch', (tester) async {
    // Reset to dark
    AppThemeStore.instance.setThemeMode(ThemeMode.dark);

    await tester.pumpWidget(
      ListenableBuilder(
        listenable: AppThemeStore.instance,
        builder: (context, _) {
          return MaterialApp(
            themeMode: AppThemeStore.instance.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const TooltipShowcaseScreen(),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    final textFinder = find.text('Integrated with ByDynamicBorder');
    expect(textFinder, findsOneWidget);

    Text textWidget = tester.widget<Text>(textFinder);
    // In dark mode, bannerText should be Color(0xFFE0E7FF)
    expect(textWidget.style?.color, const Color(0xFFE0E7FF));

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    // Switch to Light
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    textWidget = tester.widget<Text>(textFinder);
    // In light mode, bannerText should be AppColors.primaryText (Color(0xFF3730A3))
    expect(textWidget.style?.color, AppColors.primaryText);
  });
}
