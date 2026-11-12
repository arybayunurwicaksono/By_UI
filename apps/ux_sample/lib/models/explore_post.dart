import 'package:flutter/material.dart';

/// Social post model representing community & fintech feed items.
class ExplorePost {
  final String id;
  final String authorName;
  final String authorHandle;
  final String authorRole;
  final Color avatarColor;
  final bool isVerified;
  final String timeAgo;
  final String category;
  final String content;
  final List<String> hashtags;
  final String? mediaTitle;
  final String? mediaSubtitle;
  final List<Color> mediaGradient;
  final IconData mediaIcon;
  int likes;
  bool isLiked;
  final int comments;
  int shares;
  bool isBookmarked;

  ExplorePost({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.authorRole,
    required this.avatarColor,
    required this.isVerified,
    required this.timeAgo,
    required this.category,
    required this.content,
    required this.hashtags,
    this.mediaTitle,
    this.mediaSubtitle,
    required this.mediaGradient,
    required this.mediaIcon,
    required this.likes,
    this.isLiked = false,
    required this.comments,
    required this.shares,
    this.isBookmarked = false,
  });
}

/// Trending topic item for discovery sidebar.
class ExploreTrendingTopic {
  final String tag;
  final String category;
  final String postCount;
  final bool isHot;

  const ExploreTrendingTopic({
    required this.tag,
    required this.category,
    required this.postCount,
    this.isHot = false,
  });
}

/// Recommended creator to follow.
class ExploreCreator {
  final String name;
  final String handle;
  final String role;
  final Color avatarColor;
  final bool isVerified;
  final String followers;
  bool isFollowing;

  ExploreCreator({
    required this.name,
    required this.handle,
    required this.role,
    required this.avatarColor,
    required this.isVerified,
    required this.followers,
    this.isFollowing = false,
  });
}

/// Repository supplying 50 realistic posts, trending topics, and creator suggestions.
class ExploreRepository {
  static const List<String> categories = [
    'All',
    'Fintech',
    'Architecture',
    'Design System',
    'Crypto & Web3',
    'Markets',
    'Tech & AI',
  ];

  static const List<ExploreTrendingTopic> trendingTopics = [
    ExploreTrendingTopic(
      tag: '#ByUI2_0',
      category: 'Design System',
      postCount: '18.4K posts',
      isHot: true,
    ),
    ExploreTrendingTopic(
      tag: '#FintechPulse',
      category: 'Fintech',
      postCount: '12.8K posts',
      isHot: true,
    ),
    ExploreTrendingTopic(
      tag: '#FlutterResponsive',
      category: 'Tech & AI',
      postCount: '9.5K posts',
    ),
    ExploreTrendingTopic(
      tag: '#CleanArchitecture',
      category: 'Architecture',
      postCount: '7.2K posts',
    ),
    ExploreTrendingTopic(
      tag: '#DeFiYields',
      category: 'Crypto & Web3',
      postCount: '6.4K posts',
    ),
    ExploreTrendingTopic(
      tag: '#GlobalMarkets',
      category: 'Markets',
      postCount: '5.1K posts',
    ),
  ];

  static List<ExploreCreator> getSuggestedCreators() => [
    ExploreCreator(
      name: 'Sarah Lin',
      handle: '@sarahlin_ui',
      role: 'Lead Design Systems Engineer',
      avatarColor: const Color(0xFF6366F1),
      isVerified: true,
      followers: '24.2K',
    ),
    ExploreCreator(
      name: 'Marcus Vance',
      handle: '@marcus_quant',
      role: 'Quantitative Asset Manager',
      avatarColor: const Color(0xFF0EA5E9),
      isVerified: true,
      followers: '19.8K',
    ),
    ExploreCreator(
      name: 'Elena Rostova',
      handle: '@elena_core',
      role: 'Flutter Core Contributor',
      avatarColor: const Color(0xFF10B981),
      isVerified: true,
      followers: '31.5K',
    ),
    ExploreCreator(
      name: 'David Kim',
      handle: '@kim_fintech',
      role: 'Fintech Security Researcher',
      avatarColor: const Color(0xFFF59E0B),
      isVerified: false,
      followers: '14.1K',
    ),
  ];

  /// Generates a curated, deterministic dataset of 50 posts.
  static List<ExplorePost> generate50Posts() {
    final List<Map<String, dynamic>> rawSeeds = [
      {
        'author': 'Alex Rivera',
        'handle': '@alexrivera',
        'role': 'Product Architect',
        'color': const Color(0xFF4F46E5),
        'category': 'Fintech',
        'time': '12m ago',
        'text':
            'Just deployed zero-latency cross-border settlement protocols in our testing cluster. The ByUI responsive dashboard ensures real-time metrics stay clean on mobile and wide displays alike!',
        'tags': ['#FintechPulse', '#CleanArchitecture', '#ByUI2_0'],
        'mediaTitle': 'Autonomous Liquidity Aggregator',
        'mediaSubtitle': 'Real-time settlement throughput (+99.98% uptime)',
        'gradient': [const Color(0xFF4F46E5), const Color(0xFF06B6D4)],
        'icon': Icons.bolt_rounded,
        'likes': 248,
        'comments': 34,
        'shares': 19,
      },
      {
        'author': 'Sarah Lin',
        'handle': '@sarahlin_ui',
        'role': 'Design Systems Lead',
        'color': const Color(0xFF0EA5E9),
        'category': 'Design System',
        'time': '34m ago',
        'text':
            'Exploring the ByAutoShimmer laser sweep physics. Harmonious multi-card shimmer phase eliminates CPU ticker storms and makes loading states look like high-end fintech hardware.',
        'tags': ['#ByUI2_0', '#DesignSystem', '#FlutterWeb'],
        'mediaTitle': 'ByAutoShimmer Laser Matrix',
        'mediaSubtitle': 'Dynamic perimeter border pulse & seamless reveal',
        'gradient': [const Color(0xFF0EA5E9), const Color(0xFF3B82F6)],
        'icon': Icons.auto_awesome_rounded,
        'likes': 412,
        'comments': 58,
        'shares': 42,
      },
      {
        'author': 'Marcus Vance',
        'handle': '@marcus_quant',
        'role': 'Quantitative Analyst',
        'color': const Color(0xFF10B981),
        'category': 'Markets',
        'time': '1h ago',
        'text':
            'Federal interest rate equilibrium model indicates volatility compression over the next 14 trading days. Diversified algorithmic hedging remains top priority.',
        'tags': ['#GlobalMarkets', '#AlgoTrading', '#Hedging'],
        'mediaTitle': 'Volatility Compression Index',
        'mediaSubtitle': 'Cross-asset volatility corridor & momentum shifts',
        'gradient': [const Color(0xFF059669), const Color(0xFF10B981)],
        'icon': Icons.show_chart_rounded,
        'likes': 189,
        'comments': 22,
        'shares': 15,
      },
      {
        'author': 'Elena Rostova',
        'handle': '@elena_core',
        'role': 'Flutter Contributor',
        'color': const Color(0xFF8B5CF6),
        'category': 'Tech & AI',
        'time': '2h ago',
        'text':
            'Why subpixel geometry matters: pinning coordinates during 72px <-> 240px sidebar hover width animations avoids layout switching and RenderFlex assertions on 320dp viewports.',
        'tags': ['#FlutterResponsive', '#ZeroOverflow', '#Performance'],
        'mediaTitle': 'Geometry Constraint Pinning',
        'mediaSubtitle':
            'Mathematically verified subpixel stability (60/120 FPS)',
        'gradient': [const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
        'icon': Icons.layers_rounded,
        'likes': 560,
        'comments': 87,
        'shares': 73,
      },
      {
        'author': 'David Kim',
        'handle': '@kim_fintech',
        'role': 'Security Engineer',
        'color': const Color(0xFFF59E0B),
        'category': 'Crypto & Web3',
        'time': '3h ago',
        'text':
            'Multi-signature threshold vaults coupled with hardware security modules ensure institutional clients maintain non-custodial sovereignty without single points of compromise.',
        'tags': ['#DeFiYields', '#Web3Security', '#ZeroTrust'],
        'mediaTitle': 'Threshold Cryptography Vault',
        'mediaSubtitle': 'MPC multi-party computation security audit PASSED',
        'gradient': [const Color(0xFFD97706), const Color(0xFFF59E0B)],
        'icon': Icons.security_rounded,
        'likes': 315,
        'comments': 41,
        'shares': 29,
      },
      {
        'author': 'Maya Patel',
        'handle': '@maya_architect',
        'role': 'Solutions Architect',
        'color': const Color(0xFF06B6D4),
        'category': 'Architecture',
        'time': '4h ago',
        'text':
            'Clean Architecture boundary enforcement: separating data access layers from stateful UI presentation keeps domain logic testable and unit test suites running under 2 seconds.',
        'tags': ['#CleanArchitecture', '#DomainDriven', '#CodeQuality'],
        'mediaTitle': 'Domain Boundary Isolation',
        'mediaSubtitle': 'Decoupled presentation from repository abstractions',
        'gradient': [const Color(0xFF0891B2), const Color(0xFF06B6D4)],
        'icon': Icons.account_tree_rounded,
        'likes': 274,
        'comments': 31,
        'shares': 26,
      },
      {
        'author': 'Liam O’Connor',
        'handle': '@liam_invest',
        'role': 'Angel Investor',
        'color': const Color(0xFF14B8A6),
        'category': 'Fintech',
        'time': '5h ago',
        'text':
            'Seed stage fintech valuations in Q4: investors are prioritizing genuine unit economics, capital-efficient retention, and defensible UI experience over vanity metric growth.',
        'tags': ['#FintechPulse', '#VentureCapital', '#Startups'],
        'mediaTitle': 'Fintech Capital Efficiency Index',
        'mediaSubtitle': 'Net revenue retention vs customer acquisition costs',
        'gradient': [const Color(0xFF0D9488), const Color(0xFF14B8A6)],
        'icon': Icons.pie_chart_rounded,
        'likes': 420,
        'comments': 63,
        'shares': 38,
      },
      {
        'author': 'Sophie Martin',
        'handle': '@sophie_design',
        'role': 'UI/UX Lead',
        'color': const Color(0xFFF43F5E),
        'category': 'Design System',
        'time': '6h ago',
        'text':
            'Micro-interactions should feel tactile and grounded. Dynamic borders responding to physical device gyroscope tilts or cursor proximity transform passive apps into living surfaces.',
        'tags': ['#DesignSystem', '#MicroInteractions', '#ByUI2_0'],
        'mediaTitle': 'Spatial Proximity Engine',
        'mediaSubtitle': 'Sensor-assisted perimeter gradient tracking',
        'gradient': [const Color(0xFFE11D48), const Color(0xFFF43F5E)],
        'icon': Icons.touch_app_rounded,
        'likes': 388,
        'comments': 45,
        'shares': 35,
      },
      {
        'author': 'Kenji Sato',
        'handle': '@kenji_trader',
        'role': 'Global Macro Trader',
        'color': const Color(0xFF6366F1),
        'category': 'Markets',
        'time': '7h ago',
        'text':
            'Asia-Pacific foreign exchange liquidity corridors saw strong demand overnight. Sovereign debt yields stabilized following central bank policy clarification.',
        'tags': ['#GlobalMarkets', '#MacroEconomics', '#FXCorridors'],
        'mediaTitle': 'APAC Foreign Exchange Corridor',
        'mediaSubtitle': 'Daily turnover volume and cross-currency spreads',
        'gradient': [const Color(0xFF4F46E5), const Color(0xFF6366F1)],
        'icon': Icons.currency_exchange_rounded,
        'likes': 195,
        'comments': 18,
        'shares': 12,
      },
      {
        'author': 'Chloe Dupont',
        'handle': '@chloe_ai',
        'role': 'AI Infrastructure Researcher',
        'color': const Color(0xFF8B5CF6),
        'category': 'Tech & AI',
        'time': '8h ago',
        'text':
            'Synthesizing tabular financial time-series with local quantized transformer models. Privacy-preserving inference directly in user edge workspaces is now viable.',
        'tags': ['#TechAI', '#LocalLLM', '#EdgeComputing'],
        'mediaTitle': 'Edge Model Quantization',
        'mediaSubtitle': 'Sub-15ms latency on consumer desktop hardware',
        'gradient': [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)],
        'icon': Icons.psychology_rounded,
        'likes': 510,
        'comments': 72,
        'shares': 54,
      },
    ];

    // Expand the 10 rich seeds systematically into 50 distinct realistic posts
    final List<ExplorePost> list = [];
    final List<String> cats = [
      'Fintech',
      'Design System',
      'Markets',
      'Tech & AI',
      'Crypto & Web3',
      'Architecture',
    ];

    for (int i = 0; i < 50; i++) {
      final seed = rawSeeds[i % rawSeeds.length];
      final cat = cats[i % cats.length];
      final pageIndex = (i ~/ 10) + 1;
      final postIndexInPage = (i % 10) + 1;

      list.add(
        ExplorePost(
          id: 'post_${i + 1}',
          authorName: seed['author'] as String,
          authorHandle: seed['handle'] as String,
          authorRole: seed['role'] as String,
          avatarColor: seed['color'] as Color,
          isVerified: i % 2 == 0,
          timeAgo: '${(i * 18 + 12)}m ago',
          category: cat,
          content: '${seed['text']} (Insight #$pageIndex.$postIndexInPage)',
          hashtags: (seed['tags'] as List<String>),
          mediaTitle: '${seed['mediaTitle']} #$postIndexInPage',
          mediaSubtitle: seed['mediaSubtitle'] as String,
          mediaGradient: seed['gradient'] as List<Color>,
          mediaIcon: seed['icon'] as IconData,
          likes: (seed['likes'] as int) + i * 3,
          isLiked: i % 3 == 0,
          comments: (seed['comments'] as int) + (i % 7),
          shares: (seed['shares'] as int) + (i % 5),
          isBookmarked: i % 4 == 0,
        ),
      );
    }

    return list;
  }
}
