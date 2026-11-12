import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ux_sample/screens/dashboard/tabs/activity_tab.dart';
import 'package:ux_sample/screens/dashboard/tabs/explore_tab.dart';
import 'package:ux_sample/screens/dashboard/tabs/home_tab.dart';
import 'package:ux_sample/screens/dashboard/tabs/profile_tab.dart';

void main() {
  Widget buildTestHost(Widget child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: child),
    );
  }

  group('Desktop & Web Viewport Centered Reduced-Width Layout Tests', () {
    testWidgets(
      'HomeTab centers content and constrains width to 1000px on 1920x1080 desktop',
      (tester) async {
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final scrollController = ScrollController();
        addTearDown(scrollController.dispose);

        await tester.pumpWidget(
          buildTestHost(
            HomeTab(scrollController: scrollController, isDesktop: true),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);

        final constrainedFinder = find.byWidgetPredicate(
          (w) => w is ConstrainedBox && w.constraints.maxWidth == 1000,
        );
        expect(constrainedFinder, findsOneWidget);

        final renderBox = tester.renderObject<RenderBox>(constrainedFinder);
        expect(renderBox.size.width, equals(1000.0));

        final centerOffset = tester.getCenter(constrainedFinder);
        expect(centerOffset.dx, closeTo(1920 / 2, 1.0));
      },
    );

    testWidgets(
      'ActivityTab centers content and constrains width to 1000px on 1920x1080 desktop',
      (tester) async {
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final scrollController = ScrollController();
        addTearDown(scrollController.dispose);

        await tester.pumpWidget(
          buildTestHost(
            ActivityTab(scrollController: scrollController, isDesktop: true),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);

        final constrainedFinder = find.byWidgetPredicate(
          (w) => w is ConstrainedBox && w.constraints.maxWidth == 1000,
        );
        expect(constrainedFinder, findsOneWidget);

        final renderBox = tester.renderObject<RenderBox>(constrainedFinder);
        expect(renderBox.size.width, equals(1000.0));

        final centerOffset = tester.getCenter(constrainedFinder);
        expect(centerOffset.dx, closeTo(1920 / 2, 1.0));
      },
    );

    testWidgets(
      'ProfileTab centers content and constrains width to 1000px on 1920x1080 desktop',
      (tester) async {
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final scrollController = ScrollController();
        addTearDown(scrollController.dispose);

        await tester.pumpWidget(
          buildTestHost(
            ProfileTab(scrollController: scrollController, isDesktop: true),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);

        final constrainedFinder = find.byWidgetPredicate(
          (w) => w is ConstrainedBox && w.constraints.maxWidth == 1000,
        );
        expect(constrainedFinder, findsOneWidget);

        final renderBox = tester.renderObject<RenderBox>(constrainedFinder);
        expect(renderBox.size.width, equals(1000.0));

        final centerOffset = tester.getCenter(constrainedFinder);
        expect(centerOffset.dx, closeTo(1920 / 2, 1.0));
      },
    );

    testWidgets(
      'ExploreTab centers content and constrains width to 1000px on 1920x1080 desktop',
      (tester) async {
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final scrollController = ScrollController();
        addTearDown(scrollController.dispose);

        await tester.pumpWidget(
          buildTestHost(
            ExploreTab(scrollController: scrollController, isDesktop: true),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 750));

        expect(tester.takeException(), isNull);

        final constrainedFinder = find.byWidgetPredicate(
          (w) => w is ConstrainedBox && w.constraints.maxWidth == 1000,
        );
        expect(constrainedFinder, findsOneWidget);

        final renderBox = tester.renderObject<RenderBox>(constrainedFinder);
        expect(renderBox.size.width, equals(1000.0));

        final centerOffset = tester.getCenter(constrainedFinder);
        expect(centerOffset.dx, closeTo(1920 / 2, 1.0));
      },
    );
  });
}
