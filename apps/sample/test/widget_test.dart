import 'package:by_ui/by_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample/main.dart';
import 'package:sample/models/app_theme_store.dart';
import 'package:sample/models/toast_config_store.dart';
import 'package:sample/navigation/showcase_navigator.dart';
import 'package:sample/screens/button_showcase_screen.dart';
import 'package:sample/screens/auto_shimmer_showcase_screen.dart';
import 'package:sample/screens/bottom_nav_showcase_screen.dart';
import 'package:sample/screens/sidebar_showcase_screen.dart';
import 'package:sample/screens/tab_bar_showcase_screen.dart';

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
      // Drag down slightly so the swatch moves below the floating AppBar
      await tester.drag(verticalScrollable, const Offset(0, 100));
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
      // Drag down slightly so the swatch moves below the floating AppBar
      await tester.drag(verticalScrollable, const Offset(0, 100));
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

      final topCenterFinder = find.text('Top (Center)').last;
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

    final previewFinder = find.text('Active Configuration Preview');
    expect(previewFinder, findsOneWidget);
    expect(find.text('Anchor'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Opacity'), findsOneWidget);
    expect(find.text('Border'), findsOneWidget);
    expect(find.text('Motion'), findsOneWidget);
    expect(find.text('Dialog Morph'), findsOneWidget);
    expect(find.text('Max Lines'), findsOneWidget);
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

      // Verify summary card has Btn Radius metric
      expect(find.text('Btn Radius'), findsOneWidget);

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
      final previewFinder = find.text('Active Configuration Preview');
      await tester.scrollUntilVisible(
        previewFinder,
        -300,
        scrollable: verticalScrollable,
      );
      await tester.pumpAndSettle();

      expect(find.text('24px'), findsOneWidget);
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
      expect(find.text('Active Configuration Preview'), findsOneWidget);
      expect(find.text('Spatial Aurora'), findsOneWidget);
      expect(find.text('Integrated with ByDynamicBorder'), findsOneWidget);

      final verticalScrollable = find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      );

      final heroPassFinder = find.text('ByCard Interactive Pass');
      await tester.scrollUntilVisible(
        heroPassFinder,
        100,
        scrollable: verticalScrollable,
      );
      await tester.pumpAndSettle();

      expect(heroPassFinder, findsOneWidget);

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

  testWidgets('Drawer navigates to ByAppBar showcase and renders live controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ByUISampleApp());
    await tester.pumpAndSettle();

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    final drawerScrollable = find.descendant(
      of: find.byType(Drawer),
      matching: find.byType(Scrollable),
    );
    final byAppBarDrawerItem = find.text('ByAppBar');
    await tester.scrollUntilVisible(
      byAppBarDrawerItem,
      100,
      scrollable: drawerScrollable,
    );
    await tester.pumpAndSettle();

    // Tap ByAppBar drawer item
    expect(byAppBarDrawerItem, findsOneWidget);
    await tester.tap(byAppBarDrawerItem);
    await tester.pumpAndSettle();

    // Verify ByAppBar showcase screen rendered with Active Configuration Preview
    expect(find.text('Active Configuration Preview'), findsOneWidget);

    final screenScrollable = find.descendant(
      of: find.byType(Scaffold),
      matching: find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      ),
    );
    final section1 = find.text('1. FLOATING DYNAMICS & SCROLL BEHAVIOR');
    await tester.scrollUntilVisible(
      section1,
      150,
      scrollable: screenScrollable,
    );
    await tester.pumpAndSettle();
    expect(section1, findsOneWidget);
    final section2 = find.text('2. COLOR THEME & GLASSMORPHIC OPACITY');
    await tester.scrollUntilVisible(
      section2,
      150,
      scrollable: screenScrollable,
    );
    await tester.pumpAndSettle();
    expect(section2, findsOneWidget);
  });

  testWidgets(
    'ByAppBar allows Scaffold.body content to scroll behind floating app bar without clipping',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ByUISampleApp());
      await tester.pumpAndSettle();

      // Verify Scaffold has extendBodyBehindAppBar enabled
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.extendBodyBehindAppBar, isTrue);

      // Verify ByAppBar is present
      expect(find.byType(ByAppBar), findsOneWidget);

      final screenScrollable = find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      );

      // Scroll content up
      await tester.drag(screenScrollable, const Offset(0, -60));
      await tester.pumpAndSettle();

      // Verify app bar is still rendered in front
      expect(find.byType(ByAppBar), findsOneWidget);
    },
  );

  testWidgets(
    'Drawer navigates to BySequence showcase and renders live controls',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ByUISampleApp());
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();

      final drawerScrollable = find.descendant(
        of: find.byType(Drawer),
        matching: find.byType(Scrollable),
      );
      final bySequenceDrawerItem = find.text('BySequence');
      await tester.scrollUntilVisible(
        bySequenceDrawerItem,
        100,
        scrollable: drawerScrollable,
      );
      await tester.pumpAndSettle();

      // Tap BySequence drawer item
      expect(bySequenceDrawerItem, findsOneWidget);
      await tester.tap(bySequenceDrawerItem);
      await tester.pumpAndSettle();

      // Verify BySequence showcase screen loaded
      expect(find.text('BySequence'), findsWidgets);
      expect(find.text('Showcase'), findsOneWidget);
      expect(find.text('Active Configuration Preview'), findsOneWidget);
      expect(find.text('Preset Example'), findsOneWidget);

      final section1 = find.text('1. CONTAINER VIEWPORT & SCROLLER');
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(section1, findsOneWidget);

      // Verify help button opens parameter dialog for BySequence
      final helpButton = find.byTooltip('Widget Parameters');
      expect(helpButton, findsOneWidget);
      await tester.tap(helpButton);
      await tester.pumpAndSettle();
      expect(find.text('children'), findsOneWidget);
      expect(find.text('animation'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'Drawer navigates to ByButton showcase and renders live controls',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ByUISampleApp());
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();

      final drawerScrollable = find.descendant(
        of: find.byType(Drawer),
        matching: find.byType(Scrollable),
      );
      final byButtonDrawerItem = find.text('ByButton');
      await tester.scrollUntilVisible(
        byButtonDrawerItem,
        100,
        scrollable: drawerScrollable,
      );
      await tester.pumpAndSettle();

      // Tap ByButton drawer item
      expect(byButtonDrawerItem, findsOneWidget);
      await tester.tap(byButtonDrawerItem);
      await tester.pumpAndSettle();

      // Verify ByButton showcase screen loaded
      expect(find.text('ByButton'), findsWidgets);
      expect(find.text('Active Configuration Preview'), findsOneWidget);
      expect(find.text('Preset Example'), findsOneWidget);
      expect(find.text('Idle Border'), findsOneWidget);
      expect(find.text('Loading Border'), findsOneWidget);

      // Verify help button opens parameter dialog for ByButton
      final helpButton = find.byTooltip('Widget Parameters');
      expect(helpButton, findsOneWidget);
      await tester.tap(helpButton);
      await tester.pumpAndSettle();
      expect(find.text('borderWidth'), findsWidgets);
      expect(find.text('loadingBorderWidth'), findsOneWidget);
      expect(find.text('borderColor'), findsOneWidget);
      expect(find.text('successIconColor'), findsOneWidget);
      expect(find.text('errorIconColor'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'Button showcase Enabled State switch triggers state transition pulse',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ButtonShowcaseScreen()));
      await tester.pumpAndSettle();

      final switchFinder = find.text('Enabled State');
      expect(switchFinder, findsOneWidget);

      // Tap the switch to toggle to disabled
      await tester.tap(switchFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final layerFinder = find.descendant(
        of: find.byType(ByButton),
        matching: find.byType(ByDynamicBorderLayer),
      );
      expect(layerFinder, findsOneWidget);
      final layer = tester.widget<ByDynamicBorderLayer>(layerFinder);
      expect(layer.config.repeatCount, equals(1));
      expect(
        layer.config.colors.first.toARGB32(),
        equals(ByButtonDefaults.disableTransitionPulseColors.first.toARGB32()),
      );

      // Wait for the disable pulse to complete (1400ms)
      await tester.pump(const Duration(milliseconds: 1400));

      // Now toggle back to ENABLED
      await tester.tap(switchFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final layerFinder2 = find.descendant(
        of: find.byType(ByButton),
        matching: find.byType(ByDynamicBorderLayer),
      );
      final layer2 = tester.widget<ByDynamicBorderLayer>(layerFinder2);
      expect(layer2.config.repeatCount, equals(1));
      expect(
        layer2.config.colors.first.toARGB32(),
        isIn([Colors.white.toARGB32(), Colors.black.toARGB32()]),
      );
    },
  );

  testWidgets('New showcase screens render and function properly', (
    WidgetTester tester,
  ) async {
    // 1. ByAutoShimmer
    await tester.pumpWidget(
      const MaterialApp(home: AutoShimmerShowcaseScreen()),
    );
    await tester.pump();
    expect(find.text('ByAutoShimmer'), findsWidgets);
    expect(find.text('Active Configuration Preview'), findsOneWidget);

    // 2. ByTabBar
    await tester.pumpWidget(const MaterialApp(home: TabBarShowcaseScreen()));
    await tester.pump();
    expect(find.text('ByTabBar'), findsWidgets);
    expect(find.text('Active Configuration Preview'), findsOneWidget);

    // 3. ByBottomNav
    await tester.pumpWidget(const MaterialApp(home: BottomNavShowcaseScreen()));
    await tester.pump();
    expect(find.text('ByBottomNav'), findsWidgets);
    expect(find.text('Active Configuration Preview'), findsOneWidget);

    // 4. BySidebar
    await tester.pumpWidget(const MaterialApp(home: SidebarShowcaseScreen()));
    await tester.pump();
    expect(find.text('BySidebar'), findsWidgets);
    expect(find.text('Active Configuration Preview'), findsOneWidget);
  });

  testWidgets('ShowcaseNavigator routes to all new screens', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () =>
                  ShowcaseNavigator.pushReplacement(context, 'ByAutoShimmer'),
              child: const Text('GO_SHIMMER'),
            );
          },
        ),
      ),
    );

    // Test routing to ByAutoShimmer
    await tester.tap(find.text('GO_SHIMMER'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(AutoShimmerShowcaseScreen), findsOneWidget);
  });

  testWidgets(
    'Settings tab in TabBar and Sidebar renders without ListTile assertions',
    (WidgetTester tester) async {
      // 1. BySidebar live preview with settings route (index 5)
      await tester.pumpWidget(const MaterialApp(home: SidebarShowcaseScreen()));
      await tester.pumpAndSettle();

      // Click maximize button
      final maximizeFinder = find.byTooltip('Maximize Live Preview');
      expect(maximizeFinder, findsOneWidget);
      await tester.tap(maximizeFinder);
      await tester.pumpAndSettle();

      // Tap settings item in sidebar (Route Index 5: Settings)
      final settingsIconFinder = find.byIcon(Icons.settings_rounded);
      expect(settingsIconFinder, findsOneWidget);
      await tester.tap(settingsIconFinder);
      await tester.pumpAndSettle();

      expect(find.text('Environment Policies'), findsOneWidget);
      expect(
        find.text('Automated Zero-Downtime Rolling Update'),
        findsOneWidget,
      );
      expect(find.text('Strict Mutual TLS (mTLS) Encryption'), findsOneWidget);

      // 2. ByTabBar live preview with Settings tab
      await tester.pumpWidget(const MaterialApp(home: TabBarShowcaseScreen()));
      await tester.pumpAndSettle();

      final maxTabFinder = find.byTooltip('Maximize Preview');
      expect(maxTabFinder, findsOneWidget);
      await tester.tap(maxTabFinder);
      await tester.pumpAndSettle();

      final settingsTabFinder = find.text('Settings');
      expect(settingsTabFinder, findsOneWidget);
      await tester.tap(settingsTabFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cluster Node Preferences'), findsOneWidget);
      expect(find.text('Continuous Sensor Polling'), findsOneWidget);
    },
  );

  testWidgets(
    'ByShowcaseHeader view code button opens ByCodeDialog with generated code snippet',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ByUISampleApp());
      await tester.pumpAndSettle();

      // Find the code snippet button in ByShowcaseHeader
      final codeBtnFinder = find.byTooltip('View & Copy Code');
      expect(codeBtnFinder, findsOneWidget);

      // Tap View & Copy Code
      await tester.tap(codeBtnFinder);
      await tester.pumpAndSettle();

      // Verify ByCodeDialog opened
      expect(find.text('Active Configuration Code'), findsOneWidget);
      expect(find.text('Copy Code'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      // Verify code contains ByToast invocation
      expect(find.textContaining('ByToast.show('), findsOneWidget);

      // Tap Copy Code button
      await tester.tap(find.text('Copy Code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify button updates state to Copied!
      expect(find.text('Copied!'), findsOneWidget);

      // Close the dialog
      await tester.tap(find.text('Close'));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Dialog is dismissed
      expect(find.text('Active Configuration Code'), findsNothing);
    },
  );
}
