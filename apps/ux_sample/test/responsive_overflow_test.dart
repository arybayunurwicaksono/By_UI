import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';
import 'package:ux_sample/screens/auth/login_screen.dart';
import 'package:ux_sample/screens/dashboard/dashboard_screen.dart';
import 'package:ux_sample/screens/splash/splash_screen.dart';

void main() {
  Widget buildTestHost(Widget child) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: child);
  }

  void checkNoException(WidgetTester tester, String stage) {
    final err = tester.takeException();
    expect(err, isNull, reason: 'Failed at stage: $stage');
  }

  group('Small Viewport Responsive Zero-Overflow Tests', () {
    testWidgets(
      'SplashScreen renders on 360x800 and 320x640 without RenderFlex overflow',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(buildTestHost(const SplashScreen()));
        await tester.pump(const Duration(milliseconds: 200));
        checkNoException(tester, 'SplashScreen 360x800');

        // Ultra-compact 320dp width
        tester.view.physicalSize = const Size(320, 640);
        await tester.pump(const Duration(milliseconds: 200));
        checkNoException(tester, 'SplashScreen 320x640');
      },
    );

    testWidgets(
      'LoginScreen renders on 360x800 and 320x640 without RenderFlex overflow',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(buildTestHost(const LoginScreen()));
        await tester.pump(const Duration(milliseconds: 200));
        checkNoException(tester, 'LoginScreen 360x800');

        // Ultra-compact 320dp width
        tester.view.physicalSize = const Size(320, 640);
        await tester.pump(const Duration(milliseconds: 200));
        checkNoException(tester, 'LoginScreen 320x640');

        // Verify Login Card uses ByCardVariant.dynamicSensor with 1x pulse
        final byCardFinder = find.byType(ByCard);
        expect(byCardFinder, findsWidgets);
        final cardWidget = tester.widget<ByCard>(byCardFinder.first);
        expect(cardWidget.variant, equals(ByCardVariant.dynamicSensor));
        expect(cardWidget.dynamicBorder?.repeatCount, equals(1));
        expect(cardWidget.enableHoverTilt, isTrue);

        // Verify simulated mouse hover on ByCard does not throw
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        await gesture.moveTo(tester.getCenter(byCardFinder.first));
        await tester.pump(const Duration(milliseconds: 50));
        checkNoException(tester, 'LoginScreen 320x640 Hover');
        await gesture.removePointer();

        // Verify tapping login button triggers morphing into loading state without RenderFlex overflow
        await tester.tap(find.text('Sign In'));
        await tester.pump(const Duration(milliseconds: 150));
        checkNoException(tester, 'LoginScreen 320x640 Morphing Progress 50%');

        await tester.pump(const Duration(milliseconds: 250));
        checkNoException(tester, 'LoginScreen 320x640 Morphed Circle 100%');

        // Finish simulated network delay and transitions
        await tester.pump(const Duration(milliseconds: 1600));
        await tester.pump(const Duration(milliseconds: 400));
        checkNoException(tester, 'LoginScreen 320x640 Settle');
      },
    );

    testWidgets(
      'LoginScreen renders horizontal 6:4 split card on desktop viewports 1024x768 and 1280x900 without overflow',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(buildTestHost(const LoginScreen()));
        await tester.pump(const Duration(milliseconds: 200));
        checkNoException(tester, 'LoginScreen 1280x900 initial');

        // Verify ByCard is rendered with dynamicSensor and 1x pulse
        final byCardFinder = find.byType(ByCard);
        expect(byCardFinder, findsWidgets);
        final cardWidget = tester.widget<ByCard>(byCardFinder.first);
        expect(cardWidget.variant, equals(ByCardVariant.dynamicSensor));
        expect(cardWidget.dynamicBorder?.repeatCount, equals(1));
        expect(cardWidget.enableHoverTilt, isTrue);

        // Verify branding and fields inside card
        expect(find.text('Welcome Back'), findsOneWidget);
        expect(find.text('Sign in to access your workspace'), findsOneWidget);
        expect(
          find.text('ByUI Component Library • UX Showcase'),
          findsOneWidget,
        );

        // Test hover tilt on desktop card
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        await gesture.moveTo(tester.getCenter(byCardFinder.first));
        await tester.pump(const Duration(milliseconds: 50));
        checkNoException(tester, 'LoginScreen 1280x900 Hover');
        await gesture.removePointer();

        // Test 1024x768 desktop viewport
        tester.view.physicalSize = const Size(1024, 768);
        await tester.pump(const Duration(milliseconds: 200));
        checkNoException(tester, 'LoginScreen 1024x768 viewport');

        // Test Sign In button morphing
        await tester.tap(find.text('Sign In'));
        await tester.pump(const Duration(milliseconds: 150));
        checkNoException(tester, 'LoginScreen Desktop Morphing 50%');

        await tester.pump(const Duration(milliseconds: 250));
        checkNoException(tester, 'LoginScreen Desktop Morphed Circle 100%');

        await tester.pump(const Duration(milliseconds: 1600));
        await tester.pump(const Duration(milliseconds: 400));
        checkNoException(tester, 'LoginScreen Desktop Settle');
      },
    );

    testWidgets(
      'DashboardScreen renders all tabs on 360x800 and 320x640 without RenderFlex overflow',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(buildTestHost(const DashboardScreen()));
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen 360x800 initial');

        // Ultra-compact 320dp width
        tester.view.physicalSize = const Size(320, 640);
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen 320x640 initial');

        // Verify tapping each navigation item does not throw overflow
        // Tab 1: Explore
        await tester.tap(find.byIcon(Icons.explore_rounded));
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen 320x640 Tab Explore');

        // Tab 2: Activity
        await tester.tap(find.byIcon(Icons.receipt_long_rounded));
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen 320x640 Tab Activity');

        // Tab 3: Profile
        await tester.tap(find.byIcon(Icons.person_rounded).first);
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen 320x640 Tab Profile');

        // Return to Tab 0: Home
        await tester.tap(find.byIcon(Icons.dashboard_rounded));
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen 320x640 Back Home');

        // Desktop browser viewport test (1024x768 & 1280x900)
        tester.view.physicalSize = const Size(1024, 768);
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen 1024x768 Desktop Browser');
        expect(find.byType(BySidebar), findsOneWidget);
        expect(find.byType(ByBottomNav), findsNothing);

        tester.view.physicalSize = const Size(1280, 900);
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen 1280x900 Desktop Browser');

        // Verify desktop has no ByAppBar (removed in favor of full-height content)
        expect(find.byType(ByAppBar), findsNothing);

        // Verify BySidebar is collapsed by default with enableHoverExpand: true
        final sidebarFinder = find.byType(BySidebar);
        expect(sidebarFinder, findsOneWidget);
        final sidebarWidget = tester.widget<BySidebar>(sidebarFinder);
        expect(sidebarWidget.enableHoverExpand, isTrue);
        expect(sidebarWidget.isCollapsed, isTrue);

        // Verify hovering over BySidebar expands it and reveals the notification icon button
        final mouseGesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await mouseGesture.addPointer(location: Offset.zero);
        await mouseGesture.moveTo(tester.getCenter(sidebarFinder));
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.byIcon(Icons.notifications_outlined), findsWidgets);

        // Tapping notification icon switches to tab 2 (Activity & Notifications)
        await tester.tap(
          find.byIcon(Icons.notifications_outlined).first,
          warnIfMissed: false,
        );
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(
          tester,
          'DashboardScreen Desktop Sidebar Header Notification Click',
        );
        await mouseGesture.removePointer();

        // Verify switching tabs via BySidebar on Desktop
        await tester.tap(find.byIcon(Icons.explore_rounded).first);
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen Desktop Sidebar Tab Explore');

        await tester.tap(find.byIcon(Icons.receipt_long_rounded).first);
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(
          tester,
          'DashboardScreen Desktop Sidebar Tab Activity',
        );

        await tester.tap(find.byIcon(Icons.dashboard_rounded).first);
        await tester.pump(const Duration(milliseconds: 300));
        checkNoException(tester, 'DashboardScreen Desktop Sidebar Back Home');
      },
    );
  });
}
