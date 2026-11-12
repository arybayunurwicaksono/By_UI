import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../../models/explore_post.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyle.dart';

/// Right-hand discovery sidebar widget for desktop and wide screen viewports.
class ExploreDesktopSidebar extends StatefulWidget {
  final String selectedCategory;
  final String? selectedTag;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onTagSelected;

  const ExploreDesktopSidebar({
    super.key,
    required this.selectedCategory,
    this.selectedTag,
    required this.onCategorySelected,
    required this.onTagSelected,
  });

  @override
  State<ExploreDesktopSidebar> createState() => _ExploreDesktopSidebarState();
}

class _ExploreDesktopSidebarState extends State<ExploreDesktopSidebar> {
  late final List<ExploreCreator> _creators;

  @override
  void initState() {
    super.initState();
    _creators = ExploreRepository.getSuggestedCreators();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Trending Topics Card
        ByCard(
          variant: ByCardVariant.normal,
          backgroundColor: Colors.white,
          borderColor: AppColors.cardBorder,
          borderWidth: 1.0,
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.all(18),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Trending For You',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.subheading,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(color: AppColors.cardBorder, height: 1),
              const SizedBox(height: 10),

              // Trending topic list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ExploreRepository.trendingTopics.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final topic = ExploreRepository.trendingTopics[index];
                  final isSelected = widget.selectedTag == topic.tag;

                  return InkWell(
                    onTap: () => widget.onTagSelected(topic.tag),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  topic.category.toUpperCase(),
                                  style: AppTextStyle.caption.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  topic.tag,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  topic.postCount,
                                  style: AppTextStyle.caption.copyWith(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (topic.isHot)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.errorLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'HOT',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Recommended Category Filters Card
        ByCard(
          variant: ByCardVariant.normal,
          backgroundColor: Colors.white,
          borderColor: AppColors.cardBorder,
          borderWidth: 1.0,
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.all(18),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Filter by Category',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.subheading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 8,
                children: ExploreRepository.categories.map((cat) {
                  final isSelected =
                      widget.selectedCategory.toLowerCase() ==
                      cat.toLowerCase();

                  return GestureDetector(
                    onTap: () => widget.onCategorySelected(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.cardBorder,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 3. Who to Follow / Suggested Creators Card
        ByCard(
          variant: ByCardVariant.normal,
          backgroundColor: Colors.white,
          borderColor: AppColors.cardBorder,
          borderWidth: 1.0,
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.all(18),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.person_add_alt_1_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Suggested Creators',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.subheading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.cardBorder, height: 1),
              const SizedBox(height: 8),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _creators.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final creator = _creators[index];

                  return Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: creator.avatarColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            creator.name[0],
                            style: TextStyle(
                              color: creator.avatarColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    creator.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (creator.isVerified) ...[
                                  const SizedBox(width: 3),
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 13,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              creator.role,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.caption.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          setState(() {
                            creator.isFollowing = !creator.isFollowing;
                          });
                          ByToast.show(
                            context,
                            message: creator.isFollowing
                                ? 'Now following ${creator.name}'
                                : 'Unfollowed ${creator.name}',
                            icon: creator.isFollowing
                                ? Icons.person_add_rounded
                                : Icons.person_remove_rounded,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: creator.isFollowing
                                ? AppColors.scaffoldBg
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: creator.isFollowing
                                  ? AppColors.cardBorder
                                  : AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            creator.isFollowing ? 'Following' : 'Follow',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: creator.isFollowing
                                  ? AppColors.textSecondary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
