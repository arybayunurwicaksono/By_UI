import 'package:by_ui/by_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample/main.dart';
import 'package:sample/models/app_theme_store.dart';
import 'package:sample/models/toast_config_store.dart';

void main() {
  setUp(() {
    AppThemeStore.instance.setThemeMode(ThemeMode.system);
  });

  testWidgets('ByUISampleApp launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ByUISampleApp());
    await tester.pumpAndSettle();

    expect(find.text('ByToast'), findsWidgets);
    expect(find.text('Showcase'), findsOneWidget);
    expect(AppThemeStore.instance.themeMode, equals(ThemeMode.system));
  });

  testWidgets('Drawer displays theme switcher and switches modes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ByUISampleApp());
    await tester.pumpAndSettle();

    // Verify initial theme mode is system (auto follows device)
    expect(AppThemeStore.instance.themeMode, equals(ThemeMode.system));

    // Open drawer
    final menuButton = find.byIcon(Icons.menu_rounded);
    expect(menuButton, findsOneWidget);
    await tester.tap(menuButton);
    await tester.pumpAndSettle();

    // Verify Theme Mode section exists in drawer
    expect(find.text('THEME MODE'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);

    // Tap 'Light' option
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(AppThemeStore.instance.themeMode, equals(ThemeMode.light));

    // Tap 'Dark' option
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(AppThemeStore.instance.themeMode, equals(ThemeMode.dark));

    // Tap 'System' option (revert to auto-follow device)
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    expect(AppThemeStore.instance.themeMode, equals(ThemeMode.system));
  });

  testWidgets(
      'Showcase screen immediately reflects theme change from drawer without extra interaction',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ByUISampleApp());
    await tester.pumpAndSettle();

    // Verify initial background is light (in test environment default brightness is light)
    Scaffold scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, equals(const Color(0xFFF8FAFC)));

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    // Switch to Dark mode
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    // Verify screen Scaffold immediately updated to dark color
    scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, equals(const Color(0xFF090D16)));

    // Switch to Light mode
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    // Verify screen Scaffold immediately reverted to light color
    scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, equals(const Color(0xFFF8FAFC)));
  });

  testWidgets(
      'DialogShowcaseScreen immediately reflects theme change from drawer',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ByUISampleApp());
    await tester.pumpAndSettle();

    // Open drawer and switch to ByDialog showcase
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ByDialog'));
    await tester.pumpAndSettle();

    expect(find.text('ByDialog'), findsWidgets);

    // Initial background is light
    Scaffold scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, equals(const Color(0xFFF8FAFC)));

    // Open drawer in Dialog screen
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    // Switch to Dark mode
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    // Verify Dialog screen Scaffold immediately updated to dark color
    scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, equals(const Color(0xFF090D16)));
  });

  testWidgets('Toast showcase and Dialog showcase have Pure White theme options',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ByUISampleApp());
    await tester.pumpAndSettle();

    // Scroll until Pure White (Solid) is visible in Toast showcase
    final toastWhiteFinder = find.text('Pure White (Solid)');
    await tester.scrollUntilVisible(toastWhiteFinder, 200);
    await tester.pumpAndSettle();
    expect(toastWhiteFinder, findsOneWidget);
    await tester.tap(toastWhiteFinder);
    await tester.pumpAndSettle();

    // Open drawer and check ByUI header
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    expect(find.text('ByUI'), findsWidgets);
    expect(find.text('packages/core'), findsOneWidget);

    // Switch to ByDialog
    await tester.tap(find.text('ByDialog'));
    await tester.pumpAndSettle();

    // Scroll until Pure White is visible in Dialog showcase
    final dialogWhiteFinder = find.text('Pure White');
    await tester.scrollUntilVisible(dialogWhiteFinder, 200);
    await tester.pumpAndSettle();
    expect(dialogWhiteFinder, findsOneWidget);
    await tester.tap(dialogWhiteFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('Toast showcase displays corner anchor positions (Top-Left, Top-Right, etc.)', (tester) async {
    await tester.pumpWidget(const ByUISampleApp());
    await tester.pumpAndSettle();

    final topCenterFinder = find.text('Top (Center)');
    await tester.scrollUntilVisible(topCenterFinder, 100);
    await tester.pumpAndSettle();

    expect(topCenterFinder, findsOneWidget);
    expect(find.text('Bottom (Center)'), findsOneWidget);
    expect(find.text('Top-Left'), findsOneWidget);
    expect(find.text('Top-Right'), findsOneWidget);
    expect(find.text('Bottom-Left'), findsOneWidget);
    expect(find.text('Bottom-Right'), findsOneWidget);

    await tester.tap(find.text('Top-Right'));
    await tester.pumpAndSettle();
    expect(ToastConfigStore.instance.position, ByToastPosition.topRight);
  });

  testWidgets('Toast showcase displays active configuration preview card', (tester) async {
    await tester.pumpWidget(const ByUISampleApp());
    await tester.pumpAndSettle();

    final previewFinder = find.text('ACTIVE CONFIGURATION PREVIEW');
    expect(previewFinder, findsOneWidget);
    expect(find.text('Screen Anchor'), findsOneWidget);
    expect(find.text('Theme Palette'), findsOneWidget);
    expect(find.text('Opacity & Border'), findsOneWidget);
    expect(find.text('Entrance & Motion'), findsOneWidget);
    expect(find.text('Expand to Dialog'), findsOneWidget);
    expect(find.text('Text Clamp'), findsOneWidget);
  });
}


