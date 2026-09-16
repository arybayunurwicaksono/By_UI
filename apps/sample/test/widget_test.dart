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

  testWidgets('Drawer displays theme switcher and switches modes', (
    WidgetTester tester,
  ) async {
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
    },
  );

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
    },
  );

  testWidgets(
    'Toast showcase and Dialog showcase have Pure White theme options',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ByUISampleApp());
      await tester.pumpAndSettle();

      final verticalScrollable = find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      );

      // Scroll until Pure White (Solid) swatch is visible in Toast showcase
      final toastWhiteFinder = find.byKey(
        const ValueKey('theme_Pure White (Solid)'),
      );
      await tester.scrollUntilVisible(
        toastWhiteFinder,
        200,
        scrollable: verticalScrollable,
      );
      await tester.pumpAndSettle();
      expect(toastWhiteFinder, findsOneWidget);
      await tester.tap(toastWhiteFinder);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: toastWhiteFinder,
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );

      // Open drawer and check ByUI header
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();
      expect(find.text('ByUI'), findsWidgets);
      expect(find.text('packages/core'), findsOneWidget);

      // Switch to ByDialog
      await tester.tap(find.text('ByDialog'));
      await tester.pumpAndSettle();

      // Scroll until Pure White swatch is visible in Dialog showcase
      final dialogWhiteFinder = find.byKey(const ValueKey('theme_Pure White'));
      await tester.scrollUntilVisible(
        dialogWhiteFinder,
        200,
        scrollable: verticalScrollable,
      );
      await tester.pumpAndSettle();
      expect(dialogWhiteFinder, findsOneWidget);
      await tester.tap(dialogWhiteFinder);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: dialogWhiteFinder,
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Toast showcase displays corner anchor positions (Top-Left, Top-Right, etc.)',
    (tester) async {
      await tester.pumpWidget(const ByUISampleApp());
      await tester.pumpAndSettle();

      final verticalScrollable = find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      );

      final topCenterFinder = find.text('Top (Center)');
      await tester.scrollUntilVisible(
        topCenterFinder,
        100,
        scrollable: verticalScrollable,
      );
      await tester.pumpAndSettle();

      expect(topCenterFinder, findsOneWidget);
      expect(find.text('Bottom (Center)'), findsOneWidget);
      expect(find.text('Top-Left'), findsOneWidget);
      expect(find.text('Top-Right'), findsOneWidget);
      expect(find.text('Bottom-Left'), findsOneWidget);
      expect(find.text('Bottom-Right'), findsOneWidget);

      final topRightFinder = find.text('Top-Right');
      await tester.ensureVisible(topRightFinder);
      await tester.pumpAndSettle();
      await tester.tap(topRightFinder);
      await tester.pumpAndSettle();
      expect(ToastConfigStore.instance.position, ByToastPosition.topRight);
    },
  );

  testWidgets('Toast showcase displays active configuration preview card', (
    tester,
  ) async {
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

  testWidgets(
    'Dialog showcase displays button customization controls and updates preview',
    (tester) async {
      await tester.pumpWidget(const ByUISampleApp());
      await tester.pumpAndSettle();

      // Switch to ByDialog showcase
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ByDialog'));
      await tester.pumpAndSettle();

      // Verify summary card has Buttons & Order row
      expect(find.text('Buttons & Order'), findsOneWidget);

      // Scroll to Section 5: BUTTON ACTIONS & STYLING
      final section5Finder = find.text('5. BUTTON ACTIONS & STYLING');
      final verticalScrollable = find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      );
      await tester.scrollUntilVisible(
        section5Finder,
        300,
        scrollable: verticalScrollable,
      );
      await tester.pumpAndSettle();
      expect(section5Finder, findsOneWidget);

      // Test button corner radius selection
      final pillFinder = find.text('24px (Pill)');
      expect(pillFinder, findsOneWidget);
      await tester.ensureVisible(pillFinder);
      await tester.pumpAndSettle();
      await tester.tap(pillFinder);
      await tester.pumpAndSettle();

      // Test reverse button order switch
      final reverseFinder = find.text('Reverse Button Order');
      expect(reverseFinder, findsOneWidget);
      await tester.ensureVisible(reverseFinder);
      await tester.pumpAndSettle();
      await tester.tap(reverseFinder);
      await tester.pumpAndSettle();

      // Scroll back to preview card to check updated summary
      final previewFinder = find.text('ACTIVE CONFIGURATION PREVIEW');
      await tester.scrollUntilVisible(
        previewFinder,
        -300,
        scrollable: verticalScrollable,
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('24px • Reversed'), findsOneWidget);
    },
  );

  testWidgets(
    'Drawer navigates to ByCard showcase and renders live card controls',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ByUISampleApp());
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();

      // Verify ByCard exists in drawer and tap it
      expect(find.text('ByCard'), findsOneWidget);
      await tester.tap(find.text('ByCard'));
      await tester.pumpAndSettle();

      // Verify CardShowcaseScreen loaded
      expect(find.text('ByCard'), findsWidgets);
      expect(find.text('Showcase'), findsOneWidget);
      expect(find.text('ByCard Interactive Pass'), findsOneWidget);
      expect(find.text('Spatial Aurora'), findsOneWidget);

      final verticalScrollable = find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      );

      final colorSectionFinder = find.text(
        '3. COLOR TRANSITIONS & ACCENT PALETTE',
      );
      await tester.scrollUntilVisible(
        colorSectionFinder,
        150,
        scrollable: verticalScrollable,
      );
      await tester.pumpAndSettle();

      expect(colorSectionFinder, findsOneWidget);
      expect(
        find.text('Border Gradient — Color A (Start Tone):'),
        findsOneWidget,
      );
      expect(
        find.text('Border Gradient — Color B (End Tone):'),
        findsOneWidget,
      );
      expect(find.text('Gradient Preview (A → B)'), findsOneWidget);
    },
  );

  testWidgets(
    'AppBar help button opens title-less ByDialog parameter reference dialog',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ByUISampleApp());
      await tester.pumpAndSettle();

      // Verify help button exists
      final helpButton = find.byTooltip('Widget Parameters');
      expect(helpButton, findsOneWidget);

      // Tap help button
      await tester.tap(helpButton);
      await tester.pumpAndSettle();

      // Verify title-less parameter dialog opens with parameters and Close button
      expect(find.text('message'), findsOneWidget);
      expect(find.text('String'), findsWidgets);
      expect(find.text('Close'), findsOneWidget);

      // Tap 'Close' to dismiss
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Close'), findsNothing);
    },
  );
}
