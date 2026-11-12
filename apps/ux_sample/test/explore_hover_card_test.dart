import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ux_sample/models/explore_post.dart';
import 'package:ux_sample/screens/dashboard/widgets/explore_post_card.dart';

void main() {
  ExplorePost createMockPost({
    String id = 'post-1',
    String authorName = 'Alice Designer',
    String authorHandle = '@alice_ux',
    int shares = 12,
  }) {
    return ExplorePost(
      id: id,
      authorName: authorName,
      authorHandle: authorHandle,
      authorRole: 'Design Systems Architect',
      avatarColor: const Color(0xFF06B6D4),
      isVerified: true,
      timeAgo: '2h',
      category: 'Design System',
      content: 'Exploring the new ByHoverCard cursor-anchored popover!',
      hashtags: ['#ByUI', '#Flutter'],
      mediaGradient: const [Color(0xFF06B6D4), Color(0xFF0284C7)],
      mediaIcon: Icons.auto_awesome_rounded,
      likes: 42,
      comments: 7,
      shares: shares,
    );
  }

  Widget buildTestableWidget(Widget child, {Size size = const Size(1280, 800)}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(
          body: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
    );
  }

  group('ExplorePostCard ByHoverCard interactions', () {
    testWidgets('Desktop hover over author reveals profile preview card and follow button triggers ByToast', (tester) async {
      final post = createMockPost();
      await tester.pumpWidget(buildTestableWidget(ExplorePostCard(post: post)));
      await tester.pumpAndSettle();

      // Find author avatar / name trigger
      final authorFinder = find.text('Alice Designer');
      expect(authorFinder, findsOneWidget);

      // Verify profile preview card is not open initially
      expect(find.text('Specializing in Design System architecture and interactive design systems.'), findsNothing);

      // Simulate mouse hover enter
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(authorFinder));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 200)); // pass openDelay (150ms)
      await tester.pumpAndSettle();

      // Profile preview card is now displayed
      expect(find.text('Specializing in Design System architecture and interactive design systems.'), findsOneWidget);
      expect(find.text('14.5K '), findsOneWidget);
      expect(find.text('Follow'), findsOneWidget);

      // Tap Follow button inside hover card
      await tester.tap(find.text('Follow'));
      await tester.pumpAndSettle();

      // Card dismissed and ByToast shown
      expect(find.text('Specializing in Design System architecture and interactive design systems.'), findsNothing);
      expect(find.text('Followed'), findsOneWidget);
    });

    testWidgets('Hover over repost button reveals Repost and Repost with quotes options', (tester) async {
      final post = createMockPost(shares: 25);
      await tester.pumpWidget(buildTestableWidget(ExplorePostCard(post: post)));
      await tester.pumpAndSettle();

      final repostIconFinder = find.byIcon(Icons.repeat_rounded);
      expect(repostIconFinder, findsOneWidget);

      // Initial state: menu not visible
      expect(find.text('Repost with quotes'), findsNothing);

      // Mouse hover over repost button
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(repostIconFinder));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 200)); // pass openDelay
      await tester.pumpAndSettle();

      // Repost options popover is visible
      expect(find.text('Repost'), findsOneWidget);
      expect(find.text('Repost with quotes'), findsOneWidget);
      expect(find.text('Instantly share to your feed'), findsOneWidget);
      expect(find.text('Add your thoughts and comments'), findsOneWidget);

      // Tap 'Repost' option
      await tester.tap(find.text('Repost'));
      await tester.pumpAndSettle();

      // Verify repost count incremented from 25 to 26 and ByToast shown
      expect(find.text('26'), findsOneWidget);
      expect(find.text('Reposted'), findsOneWidget);
    });

    testWidgets('Mobile touch tap parity on repost button displays popover and triggers quote draft toast', (tester) async {
      final post = createMockPost(shares: 10);
      // Mobile screen size
      await tester.pumpWidget(buildTestableWidget(ExplorePostCard(post: post), size: const Size(360, 800)));
      await tester.pumpAndSettle();

      final repostFinder = find.byIcon(Icons.repeat_rounded);
      expect(repostFinder, findsOneWidget);

      // Mobile tap on repost icon
      await tester.tap(repostFinder);
      await tester.pumpAndSettle();

      // Popover displays identically on mobile touch
      expect(find.text('Repost with quotes'), findsOneWidget);

      // Tap 'Repost with quotes'
      await tester.tap(find.text('Repost with quotes'));
      await tester.pumpAndSettle();

      // Card dismissed and Quote Draft ByToast displayed
      expect(find.text('Repost with quotes'), findsNothing);
      expect(find.text('Quote Draft'), findsOneWidget);
    });

    testWidgets('Mobile tap outside dismisses open hover card', (tester) async {
      final post = createMockPost();
      await tester.pumpWidget(buildTestableWidget(ExplorePostCard(post: post), size: const Size(360, 800)));
      await tester.pumpAndSettle();

      // Tap author to open
      await tester.tap(find.text('Alice Designer'));
      await tester.pumpAndSettle();
      expect(find.text('Specializing in Design System architecture and interactive design systems.'), findsOneWidget);

      // Tap outside (e.g. top edge of screen)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Verify card dismissed
      expect(find.text('Specializing in Design System architecture and interactive design systems.'), findsNothing);
    });

    testWidgets('Hover on repost at mobile viewport does not crash or throw unmounted exception', (tester) async {
      final post = createMockPost(shares: 5);
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ExplorePostCard(post: post),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final repostFinder = find.byIcon(Icons.repeat_rounded);
      expect(repostFinder, findsOneWidget);

      // Simulate mouse hover at mobile width (e.g. desktop Chrome resized to mobile width)
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(repostFinder));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Verify popover opened smoothly without errors
      expect(find.text('Repost'), findsOneWidget);
      expect(find.text('Repost with quotes'), findsOneWidget);

      // Now simulate window resize or widget unmount while card is open
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Resized View')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no exception was thrown and previous card unmounted cleanly
      expect(find.text('Resized View'), findsOneWidget);
      expect(find.text('Repost with quotes'), findsNothing);
    });
  });
}
