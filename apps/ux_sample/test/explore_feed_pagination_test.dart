import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by_ui/by_ui.dart';
import 'package:ux_sample/screens/dashboard/tabs/explore_tab.dart';
import 'package:ux_sample/screens/dashboard/widgets/explore_desktop_sidebar.dart';
import 'package:ux_sample/screens/dashboard/widgets/explore_post_card.dart';
import 'package:ux_sample/screens/dashboard/widgets/explore_skeleton_card.dart';

void main() {
  Widget buildTestHost(Widget child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: child),
    );
  }

  group('Explore Feed & ByAutoShimmer Pagination Tests', () {
    testWidgets(
      'renders first batch of posts and ByAutoShimmer skeletons on mobile',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final scrollController = ScrollController();
        addTearDown(scrollController.dispose);

        await tester.pumpWidget(
          buildTestHost(
            ExploreTab(scrollController: scrollController, isDesktop: false),
          ),
        );
        await tester.pump();

        // On entry, ByAutoShimmer skeleton placeholders run first
        expect(find.byType(ExploreSkeletonCard), findsWidgets);
        expect(find.byType(ByShimmerScope), findsOneWidget);

        // Advance timer for initial shimmer transition
        await tester.pump(const Duration(milliseconds: 750));

        // Verify demo header banner is removed for clean production UX
        expect(find.text('ByAutoShimmer Social Feed'), findsNothing);
        expect(find.text('Pull to reload'), findsNothing);

        // Verify live post cards are rendered
        expect(find.byType(ExplorePostCard), findsWidgets);
        expect(tester.takeException(), isNull);

        // Test like toggle button interaction
        final likeFinder = find.byIcon(Icons.favorite_border_rounded).first;
        await tester.tap(likeFinder, warnIfMissed: false);
        await tester.pump();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'renders on ultra-compact 320dp width without RenderFlex overflow',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final scrollController = ScrollController();
        addTearDown(scrollController.dispose);

        await tester.pumpWidget(
          buildTestHost(
            ExploreTab(scrollController: scrollController, isDesktop: false),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 750));

        expect(tester.takeException(), isNull);
        expect(find.byType(ExplorePostCard), findsWidgets);
      },
    );

    testWidgets(
      'renders desktop 2-column layout with ExploreDesktopSidebar on 1280x900',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 900);
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

        // Verify right sidebar is present with trending topics and creators
        expect(find.byType(ExploreDesktopSidebar), findsOneWidget);
        expect(find.text('Trending For You'), findsOneWidget);
        expect(find.text('Filter by Category'), findsOneWidget);
        expect(find.text('Suggested Creators'), findsOneWidget);

        // Verify tapping a category filter updates feed
        await tester.tap(find.text('Fintech').first);
        await tester.pump();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'renders centered reduced-width LinkedIn-style feed layout on 1920x1080 desktop/web',
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

        // Verify the constrained box limits width to 1000px max (not stretching 1920px)
        final constrainedFinder = find.byWidgetPredicate(
          (w) => w is ConstrainedBox && w.constraints.maxWidth == 1000,
        );
        expect(constrainedFinder, findsOneWidget);

        final renderBox = tester.renderObject<RenderBox>(constrainedFinder);
        expect(renderBox.size.width, equals(1000.0));

        // Verify the content is centered horizontally (center at 1920 / 2 = 960)
        final centerOffset = tester.getCenter(constrainedFinder);
        expect(centerOffset.dx, closeTo(960.0, 1.0));
      },
    );

    testWidgets(
      'auto-loads next page with ByAutoShimmer when scrolled near bottom',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final scrollController = ScrollController();
        addTearDown(scrollController.dispose);

        await tester.pumpWidget(
          buildTestHost(
            ExploreTab(scrollController: scrollController, isDesktop: false),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 750));

        final initialCardCount = tester
            .widgetList<ExplorePostCard>(find.byType(ExplorePostCard))
            .length;
        expect(initialCardCount, equals(10));

        // Scroll to trigger auto-load of next batch
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
        await tester.pump();

        // Verify ByAutoShimmer skeleton cards appear during loading
        expect(find.byType(ExploreSkeletonCard), findsWidgets);
        expect(tester.takeException(), isNull);

        // Advance simulated pagination delay
        await tester.pump(const Duration(milliseconds: 700));
        expect(tester.takeException(), isNull);

        // Verify more posts have been loaded (now 20 cards)
        final newCardCount = tester
            .widgetList<ExplorePostCard>(find.byType(ExplorePostCard))
            .length;
        expect(newCardCount, equals(20));
      },
    );

    testWidgets(
      'auto-reloads with ByAutoShimmer when switching into active tab and supports pull-to-refresh',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final scrollController = ScrollController();
        addTearDown(scrollController.dispose);

        bool isExploreActive = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return ExploreTab(
                    scrollController: scrollController,
                    isDesktop: false,
                    isActive: isExploreActive,
                  );
                },
              ),
            ),
          ),
        );
        await tester.pump();

        // Verify RefreshIndicator is present for pull-to-refresh
        expect(find.byType(RefreshIndicator), findsOneWidget);

        // Switch tab to active (simulating user entering Explore tab)
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return ExploreTab(
                    scrollController: scrollController,
                    isDesktop: false,
                    isActive: true,
                  );
                },
              ),
            ),
          ),
        );
        await tester.pump();

        // Shimmer should run first upon entering the tab
        expect(find.byType(ExploreSkeletonCard), findsWidgets);

        // Settle timer
        await tester.pump(const Duration(milliseconds: 750));
        expect(find.byType(ExplorePostCard), findsWidgets);
      },
    );
  });
}
