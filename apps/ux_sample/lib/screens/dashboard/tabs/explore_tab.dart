import 'dart:async';
import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../../models/explore_post.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyle.dart';
import '../widgets/dashboard_search_bar.dart';
import '../widgets/explore_desktop_sidebar.dart';
import '../widgets/explore_post_card.dart';
import '../widgets/explore_skeleton_card.dart';

/// Social & community explore feed tab showcasing ByAutoShimmer, 50-post auto-load pagination,
/// live keyword search, and responsive desktop discovery sidebar.
class ExploreTab extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDesktop;
  final bool isActive;

  const ExploreTab({
    super.key,
    required this.scrollController,
    this.isDesktop = false,
    this.isActive = true,
  });

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  late final List<ExplorePost> _allPosts;
  final List<ExplorePost> _displayedPosts = [];
  Timer? _reloadTimer;
  late final TextEditingController _searchController;
  String _searchQuery = '';

  String _selectedCategory = 'All';
  String? _selectedTag;

  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  static const int _pageSize = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _allPosts = ExploreRepository.generate50Posts();
    _searchController = TextEditingController();
    widget.scrollController.addListener(_onScroll);

    // If active upon entry, run shimmer auto-reload
    if (widget.isActive) {
      _triggerShimmerReload();
    } else {
      _populateNextBatch();
      _isInitialLoading = false;
    }
  }

  @override
  void didUpdateWidget(covariant ExploreTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-reload and run ByAutoShimmer whenever user navigates into Explore tab
    if (widget.isActive && !oldWidget.isActive) {
      _triggerShimmerReload();
    }
  }

  @override
  void dispose() {
    _reloadTimer?.cancel();
    _searchController.dispose();
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.position.pixels;

    // Auto-load next page when user scrolls within 220px of bottom
    if (currentScroll >= maxScroll - 220 &&
        !_isLoadingMore &&
        _hasMore &&
        !_isInitialLoading) {
      _loadNextPage();
    }
  }

  Future<void> _triggerShimmerReload() async {
    _reloadTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _isInitialLoading = true;
      _displayedPosts.clear();
      _currentPage = 1;
      _hasMore = true;
    });

    _reloadTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _populateNextBatch();
        _isInitialLoading = false;
      });
    });
  }

  List<ExplorePost> _getFilteredMasterList() {
    final query = _searchQuery.trim().toLowerCase();
    return _allPosts.where((post) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          post.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesTag =
          _selectedTag == null || post.hashtags.contains(_selectedTag);
      final matchesQuery = query.isEmpty ||
          post.content.toLowerCase().contains(query) ||
          post.authorName.toLowerCase().contains(query) ||
          post.authorHandle.toLowerCase().contains(query) ||
          (post.mediaTitle != null &&
              post.mediaTitle!.toLowerCase().contains(query)) ||
          post.hashtags.any((t) => t.toLowerCase().contains(query));
      return matchesCategory && matchesTag && matchesQuery;
    }).toList();
  }

  void _populateNextBatch() {
    final filtered = _getFilteredMasterList();
    final startIndex = (_currentPage - 1) * _pageSize;

    if (startIndex >= filtered.length) {
      _hasMore = false;
      return;
    }

    final endIndex = (startIndex + _pageSize).clamp(0, filtered.length);
    final nextBatch = filtered.sublist(startIndex, endIndex);

    _displayedPosts.addAll(nextBatch);
    _currentPage++;

    if (_displayedPosts.length >= filtered.length) {
      _hasMore = false;
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate realistic pagination fetch latency with ByAutoShimmer skeleton
    await Future.delayed(const Duration(milliseconds: 650));

    if (!mounted) return;

    setState(() {
      _populateNextBatch();
      _isLoadingMore = false;
    });
  }

  void _onSearchChanged(String val) {
    setState(() {
      _searchQuery = val;
      _displayedPosts.clear();
      _currentPage = 1;
      _hasMore = true;
      _populateNextBatch();
    });
  }

  void _selectCategory(String category) {
    if (_selectedCategory == category && _selectedTag == null) return;

    setState(() {
      _selectedCategory = category;
      _selectedTag = null;
      _displayedPosts.clear();
      _currentPage = 1;
      _hasMore = true;
      _populateNextBatch();
    });
  }

  void _selectTag(String tag) {
    setState(() {
      _selectedTag = tag;
      _displayedPosts.clear();
      _currentPage = 1;
      _hasMore = true;
      _populateNextBatch();
    });
  }

  void _clearTagFilter() {
    setState(() {
      _selectedTag = null;
      _displayedPosts.clear();
      _currentPage = 1;
      _hasMore = true;
      _populateNextBatch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isCompact = mediaQuery.size.width < 360;

    final filteredMaster = _getFilteredMasterList();

    // 1. Search Bar Widget at the top
    final searchBarWidget = Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DashboardSearchBar(
        controller: _searchController,
        hintText: 'Search explore posts, topics, or creators...',
        onChanged: _onSearchChanged,
        onClear: () => _onSearchChanged(''),
      ),
    );

    // 2. Active Filter Pills (Tag or Search Query)
    final bool hasActiveFilter = _selectedTag != null || _searchQuery.isNotEmpty;
    final activeFiltersWidget = hasActiveFilter
        ? Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (_selectedTag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.tag_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _selectedTag!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: _clearTagFilter,
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_searchQuery.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '"$_searchQuery"',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(
                  '(${filteredMaster.length} matching)',
                  style: AppTextStyle.caption,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();

    // 3. Mobile Category Chips & Trending Carousel (visible only on mobile)
    final mobileHeaderChips = !widget.isDesktop
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category filter horizontal chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ExploreRepository.categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = ExploreRepository.categories[index];
                    final isSelected =
                        _selectedCategory.toLowerCase() == cat.toLowerCase();

                    return GestureDetector(
                      onTap: () => _selectCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.cardBorder,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Trending hashtags horizontal stream
              SizedBox(
                height: 28,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ExploreRepository.trendingTopics.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final topic = ExploreRepository.trendingTopics[index];
                    final isSelected = _selectedTag == topic.tag;

                    return GestureDetector(
                      onTap: () => _selectTag(topic.tag),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryLight
                              : AppColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.cardBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              topic.tag,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            if (topic.isHot) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
            ],
          )
        : const SizedBox.shrink();

    // 4. Main Feed Stream (Live cards + Skeletons inside ByShimmerScope)
    final feedStream = ByShimmerScope(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // If initial loading: render 3 ByAutoShimmer skeleton cards
          if (_isInitialLoading) ...[
            const ExploreSkeletonCard(isLoading: true),
            const ExploreSkeletonCard(isLoading: true),
            const ExploreSkeletonCard(isLoading: true),
          ] else ...[
            // Render currently loaded posts
            ..._displayedPosts.map((post) {
              return ExplorePostCard(
                key: ValueKey(post.id),
                post: post,
                onTagPressed: (tag) => _selectTag(tag),
                onCommentTap: () {
                  ByToast.show(
                    context,
                    message:
                        'Opening conversation thread (${post.comments} comments)',
                    icon: Icons.chat_bubble_rounded,
                  );
                },
                onShareTap: () {
                  ByToast.show(
                    context,
                    message: 'Post link copied to clipboard',
                    icon: Icons.share_rounded,
                  );
                },
              );
            }),

            // If loading more via pagination auto-load: append 2 skeleton cards
            if (_isLoadingMore) ...[
              const ExploreSkeletonCard(isLoading: true),
              const ExploreSkeletonCard(isLoading: true),
            ],

            // If reached the end of all items
            if (!_hasMore && _displayedPosts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.successLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.done_all_rounded,
                          color: AppColors.success,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You\'re all caught up!',
                        style: AppTextStyle.subheading.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'All ${filteredMaster.length} posts successfully loaded via auto-pagination',
                        style: AppTextStyle.caption,
                      ),
                    ],
                  ),
                ),
              ),

            // If no matching items found for category or search query
            if (_displayedPosts.isEmpty && !_isInitialLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        size: 40,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'No posts matching "$_searchQuery"'
                            : 'No posts found in $_selectedCategory',
                        style: AppTextStyle.subheading,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'Try different keywords or clearing tag filters'
                            : 'Try switching categories or clearing search filters',
                        style: AppTextStyle.caption,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );

    // 5. Layout assembly (Centered reduced-width desktop/web layout like LinkedIn feed)
    return RefreshIndicator(
      onRefresh: () async {
        _triggerShimmerReload();
        await Future.delayed(const Duration(milliseconds: 750));
      },
      color: AppColors.primary,
      backgroundColor: Colors.white,
      child: ListView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          widget.isDesktop ? 24 : (isCompact ? 10 : 16),
          widget.isDesktop ? 20 : 14,
          widget.isDesktop ? 24 : (isCompact ? 10 : 16),
          widget.isDesktop ? 36 : 96,
        ),
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.isDesktop ? 1000 : 640,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  searchBarWidget,
                  activeFiltersWidget,
                  if (!widget.isDesktop) mobileHeaderChips,
                  if (widget.isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Feed (Live Cards + Shimmer Skeletons)
                        Expanded(child: feedStream),

                        const SizedBox(width: 24),

                        // Right Column: Trending, Filters, & Creators Sidebar
                        SizedBox(
                          width: 320,
                          child: ExploreDesktopSidebar(
                            selectedCategory: _selectedCategory,
                            selectedTag: _selectedTag,
                            onCategorySelected: (cat) => _selectCategory(cat),
                            onTagSelected: (tag) => _selectTag(tag),
                          ),
                        ),
                      ],
                    )
                  else
                    feedStream,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
