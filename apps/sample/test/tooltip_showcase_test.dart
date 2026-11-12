import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample/models/app_theme_store.dart';
import 'package:sample/screens/tooltip_showcase_screen.dart';
import 'package:sample/widgets/by_showcase_preview_card.dart';
import 'package:sample/widgets/by_showcase_preset_card.dart';
import 'package:sample/widgets/by_showcase_integration_banner.dart';

void main() {
  testWidgets(
    'TooltipShowcaseScreen adheres strictly to 5-layer showcase hierarchy',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: TooltipShowcaseScreen()));
      await tester.pumpAndSettle();

      // Layer 1: Standalone ByShowcasePreviewCard
      expect(find.byType(ByShowcasePreviewCard), findsOneWidget);

      // Layer 2: ByShowcasePresetCard
      expect(find.byType(ByShowcasePresetCard), findsOneWidget);

      // Layer 3: ByShowcaseIntegrationBanner
      expect(find.byType(ByShowcaseIntegrationBanner), findsOneWidget);

      // Layer 4: Standard INTERACTIVE PREVIEW header & Hero Target
      expect(find.text('INTERACTIVE PREVIEW'), findsOneWidget);
      expect(find.text('Hover or Tap Me (Active Setup)'), findsOneWidget);
      expect(find.text('User Profile'), findsOneWidget);
      expect(find.text('Action Menu'), findsOneWidget);
      expect(find.text('Info Tooltip'), findsOneWidget);

      // Layer 5: Uppercase Numbered Control Sections
      expect(find.text('1. ANCHORING & OFFSET'), findsOneWidget);
      expect(find.text('2. TIMING & HOVER BRIDGE'), findsOneWidget);
      expect(find.text('3. TRANSITION ANIMATIONS'), findsOneWidget);
      expect(
        find.text('4. PULSE DYNAMIC BORDER (ONE-SHOT TRAVELING BEAM)'),
        findsOneWidget,
      );
      expect(find.text('5. MOBILE TOUCH BEHAVIORS'), findsOneWidget);
      expect(find.text('6. DIMENSIONS & DISMISSAL BEHAVIORS'), findsOneWidget);

      // Test tap on Hero Trigger opens active preset popover (Preset 0: Sarah Connor Profile)
      await tester.tap(find.text('Hover or Tap Me (Active Setup)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Sarah Connor'), findsOneWidget);
      expect(find.text('Follow'), findsOneWidget);

      // Tap Follow button inside popover
      await tester.tap(find.text('Follow'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Sarah Connor'), findsNothing);
    },
  );

  testWidgets(
    'TooltipShowcaseScreen updates dynamically when theme mode switches',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      AppThemeStore.instance.setThemeMode(ThemeMode.light);

      await tester.pumpWidget(
        ListenableBuilder(
          listenable: AppThemeStore.instance,
          builder: (context, _) => MaterialApp(
            themeMode: AppThemeStore.instance.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const TooltipShowcaseScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open hero hover card in light mode
      await tester.tap(find.text('Hover or Tap Me (Active Setup)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Sarah Connor'), findsOneWidget);

      // Switch theme mode to Dark
      AppThemeStore.instance.setThemeMode(ThemeMode.dark);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      // The screen and card must remain active and functional
      expect(find.text('Sarah Connor'), findsOneWidget);

      // Close card
      await tester.tap(find.text('Follow'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      // Reset to system theme for teardown
      AppThemeStore.instance.setThemeMode(ThemeMode.system);
    },
  );

  testWidgets(
    'TooltipShowcaseScreen renders on small viewports (360x800 and 320x640) without RenderFlex overflow',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const MaterialApp(home: TooltipShowcaseScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Scroll Layer 4 cleanly into view on 360dp mobile screen
      await tester.drag(find.byType(ListView), const Offset(0, -220));
      await tester.pumpAndSettle();

      // Tap contextual profile trigger on 360dp mobile screen
      await tester.tap(find.text('User Profile'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(tester.takeException(), isNull);
      expect(find.text('Sarah Connor'), findsOneWidget);
      expect(
        find.text(
          'Lead Systems Architect specializing in spatial micro-interactions and Flutter design systems.',
        ),
        findsOneWidget,
      );

      // Close card via Follow button
      await tester.tap(find.text('Follow'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Sarah Connor'), findsNothing);

      // Tap contextual repost trigger
      await tester.tap(find.text('Action Menu'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(tester.takeException(), isNull);
      expect(find.text('Instantly share to feed'), findsOneWidget);

      // Tap Repost item to close
      await tester.tap(find.text('Instantly share to feed'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Tap hero trigger on 360dp mobile screen
      await tester.tap(find.text('Hover or Tap Me (Active Setup)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(tester.takeException(), isNull);
      expect(find.text('Sarah Connor'), findsOneWidget);

      // Tap hero trigger again to toggle close on mobile
      await tester.tap(find.text('Hover or Tap Me (Active Setup)'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Sarah Connor'), findsNothing);

      // Test ultra-compact 320x640 viewport
      tester.view.physicalSize = const Size(320, 640);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
