import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../../models/explore_post.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyle.dart';

/// Social post card component with Instagram/Facebook feed styling.
class ExplorePostCard extends StatefulWidget {
  final ExplorePost post;
  final ValueChanged<String>? onTagPressed;
  final VoidCallback? onLikeToggle;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onBookmarkToggle;

  const ExplorePostCard({
    super.key,
    required this.post,
    this.onTagPressed,
    this.onLikeToggle,
    this.onCommentTap,
    this.onShareTap,
    this.onBookmarkToggle,
  });

  @override
  State<ExplorePostCard> createState() => _ExplorePostCardState();
}

class _ExplorePostCardState extends State<ExplorePostCard> {
  late bool _isLiked;
  late int _likeCount;
  late bool _isBookmarked;
  late int _sharesCount;
  bool _isReposted = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likes;
    _isBookmarked = widget.post.isBookmarked;
    _sharesCount = widget.post.shares;
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
      widget.post.isLiked = _isLiked;
      widget.post.likes = _likeCount;
    });
    widget.onLikeToggle?.call();
  }

  void _handleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
      widget.post.isBookmarked = _isBookmarked;
    });
    widget.onBookmarkToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ByCard(
        variant: ByCardVariant.normal,
        backgroundColor: Colors.white,
        borderColor: AppColors.cardBorder,
        borderWidth: 1.0,
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.all(16.0),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Author header
            Row(
              children: [
                Expanded(
                  child: ByHoverCard(
                    anchor: ByHoverCardAnchor.cursor,
                    width: 290,
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: Colors.white,
                    border: Border.all(
                      color: AppColors.cardBorder,
                      width: 1.0,
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    padding: EdgeInsets.zero,
                    dynamicBorder: const ByDynamicBorder(
                      enabled: true,
                      origin: ByBorderOrigin.topLeft,
                      width: 2.0,
                      shadowBlur: 10.0,
                      colors: AppColors.cyanBlueLaserColors,
                    ),
                    cardBuilder: (context) =>
                        _buildAuthorProfilePreview(context, post),
                    child: Row(
                      children: [
                        // Avatar with initial
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: post.avatarColor.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: post.avatarColor.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              post.authorName.isNotEmpty
                                  ? post.authorName[0]
                                  : 'U',
                              style: TextStyle(
                                color: post.avatarColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Name & Handle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      post.authorName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.subheading.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (post.isVerified) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.verified_rounded,
                                      size: 15,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${post.authorHandle} · ${post.timeAgo}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Category pill badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: post.avatarColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: post.avatarColor.withValues(alpha: 0.2),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    post.category,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: post.avatarColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 2. Post Caption Text
            Text(
              post.content,
              style: AppTextStyle.body.copyWith(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // 3. Hashtags
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: post.hashtags.map((tag) {
                return GestureDetector(
                  onTap: () => widget.onTagPressed?.call(tag),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // 4. Media Banner Container
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: post.mediaGradient,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            post.mediaIcon,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_graph_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'ByUI Verified',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (post.mediaTitle != null)
                      Text(
                        post.mediaTitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    if (post.mediaSubtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        post.mediaSubtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 5. Actions Footer (Like, Comment, Share, Bookmark)
            Row(
              children: [
                // Like Button
                InkWell(
                  onTap: _handleLike,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isLiked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 19,
                          color: _isLiked
                              ? AppColors.error
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$_likeCount',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _isLiked
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Comment Button
                InkWell(
                  onTap: widget.onCommentTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${post.comments}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Repost Hover Card Button
                ByHoverCard(
                  anchor: ByHoverCardAnchor.cursor,
                  width: 220,
                  borderRadius: BorderRadius.circular(14),
                  backgroundColor: Colors.white,
                  border: Border.all(
                    color: AppColors.cardBorder,
                    width: 1.0,
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  padding: EdgeInsets.zero,
                  dynamicBorder: const ByDynamicBorder(
                    enabled: true,
                    origin: ByBorderOrigin.topLeft,
                    width: 2.0,
                    shadowBlur: 8.0,
                    colors: [
                      AppColors.success,
                      AppColors.primary,
                    ],
                  ),
                  cardBuilder: (context) =>
                      _buildRepostPopoverContent(context, post),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.repeat_rounded,
                          size: 19,
                          color: _isReposted
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_sharesCount',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _isReposted
                                ? AppColors.success
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Bookmark Button
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: Icon(
                    _isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 20,
                    color: _isBookmarked
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  onPressed: _handleBookmark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorProfilePreview(BuildContext context, ExplorePost post) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: post.avatarColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: post.avatarColor.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    post.authorName.isNotEmpty ? post.authorName[0] : 'U',
                    style: TextStyle(
                      color: post.avatarColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            post.authorName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (post.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            color: AppColors.primary,
                            size: 15,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.authorHandle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Specializing in ${post.category} architecture and interactive design systems.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1,280 ',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Following',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '14.5K ',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                ByHoverCardScope.close(context);
                ByToast.showSuccess(
                  context,
                  title: 'Followed',
                  message:
                      'Now following ${post.authorName} (${post.authorHandle})!',
                );
              },
              child: const Text(
                'Follow',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepostPopoverContent(BuildContext context, ExplorePost post) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Repost Option
          InkWell(
            hoverColor: AppColors.primaryLight.withValues(alpha: 0.5),
            splashColor: AppColors.primaryLight,
            onTap: () {
              ByHoverCardScope.close(context);
              setState(() {
                _isReposted = true;
                _sharesCount += 1;
                widget.post.shares = _sharesCount;
              });
              widget.onShareTap?.call();
              ByToast.showSuccess(
                context,
                title: 'Reposted',
                message: 'Post successfully shared to your feed!',
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.repeat_rounded,
                    color: AppColors.success,
                    size: 19,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Repost',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Instantly share to your feed',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.cardBorderSubtle, height: 1),
          // Repost with quotes Option
          InkWell(
            hoverColor: AppColors.primaryLight.withValues(alpha: 0.5),
            splashColor: AppColors.primaryLight,
            onTap: () {
              ByHoverCardScope.close(context);
              ByToast.showInfo(
                context,
                title: 'Quote Draft',
                message: 'Quote draft composer opened.',
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Repost with quotes',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Add your thoughts and comments',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
