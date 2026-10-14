import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Presentation card mock widgets used for BySequence animation showcase.
class SequenceSampleCards {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final TextEditingController newsletterController;
  final TextEditingController promoController;

  const SequenceSampleCards({
    required this.nameController,
    required this.emailController,
    required this.messageController,
    required this.newsletterController,
    required this.promoController,
  });

  TextEditingController get _nameController => nameController;
  TextEditingController get _emailController => emailController;
  TextEditingController get _messageController => messageController;
  TextEditingController get _newsletterController => newsletterController;
  TextEditingController get _promoController => promoController;

  List<Widget> buildCards({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return [
      _buildProfileCard(colors: colors, isDark: isDark, isVertical: isVertical),
      _buildFeatureStepCard(
        step: '02',
        title: 'Scroll Interpolator',
        subtitle: 'Item progress computes dynamically from viewport metrics.',
        icon: Icons.auto_graph_rounded,
        color: AppColors.primaryAccent,
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildFormCard(colors: colors, isDark: isDark, isVertical: isVertical),
      _buildPhotoGalleryCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildNewsletterCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildFeatureStepCard(
        step: '06',
        title: 'Spatial Layout Matrix',
        subtitle: 'Executes rotation, scale, and multi-axis translation.',
        icon: Icons.transform_rounded,
        color: AppColors.info,
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildMessageFormCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildMilestonesCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildPricingPlanCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildAnalyticsCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildMediaCard(colors: colors, isDark: isDark, isVertical: isVertical),
      _buildTestimonialCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildWeatherStatusCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildPromoCard(colors: colors, isDark: isDark, isVertical: isVertical),
      _buildSecurityCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildCompletionCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildKpiRevenueCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildGitCommitCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildAudioPlayerCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildStorageGaugeCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildQuickActionGridCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildSmartHomeSensorCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildTaskChecklistCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildBatteryEfficiencyCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildCryptoTickerCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildFileDownloadCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildTeamAvatarStackCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildOrderReceiptCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildNotificationAlertCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildCustomerRatingCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildGpsNavigationCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
      _buildGrandCompletionCard(
        colors: colors,
        isDark: isDark,
        isVertical: isVertical,
      ),
    ];
  }

  // 1. Profile / Photo Avatar Card
  Widget _buildProfileCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 22,
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
                            'Alex Rivera',
                            style: AppTextStyle.captionBold.copyWith(
                              color: colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: AppColors.info,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Staff Systems Architect',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                '01',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Active Member',
                style: AppTextStyle.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  'San Francisco, CA',
                  style: AppTextStyle.caption.copyWith(color: colors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2 & 6. Classic Feature Step Card
  Widget _buildFeatureStepCard({
    required String step,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      step,
                      style: AppTextStyle.badge.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Form Card with Full Name & Email
  Widget _buildFormCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 285,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyanAccent.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 16,
                color: AppColors.cyanAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Profile Registration Form',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '03',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.cyanAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Form inputs retain data during scroll (maintainState: true)',
            style: AppTextStyle.caption.copyWith(
              color: colors.textMuted,
              fontSize: 9.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          _buildCompactTextField(
            controller: _nameController,
            hint: 'Full Name (e.g. Alex Rivera)',
            icon: Icons.person_outline_rounded,
            colors: colors,
            isDark: isDark,
          ),
          const SizedBox(height: 6),
          _buildCompactTextField(
            controller: _emailController,
            hint: 'Email Address',
            icon: Icons.alternate_email_rounded,
            colors: colors,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // 4. Photo Gallery Card with Styled Scenery Banner
  Widget _buildPhotoGalleryCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Spatial Photography Feed',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '04',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.emeraldDeep,
                  AppColors.skyDeep,
                  AppColors.primaryDeep,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.landscape_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Lofoten Aurora â€¢ 4K',
                            style: AppTextStyle.captionBold.copyWith(
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'HDR 60 FPS',
                      style: AppTextStyle.caption.copyWith(
                        color: Colors.white,
                        fontSize: 8.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                size: 14,
                color: AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                '2.4k Likes',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  'Norway â€¢ Nature',
                  style: AppTextStyle.caption.copyWith(color: colors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. Newsletter Subscription Card
  Widget _buildNewsletterCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.mark_email_read_rounded,
                size: 16,
                color: AppColors.primaryAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Developer Digest Newsletter',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '05',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Join 10k+ developers receiving spatial Flutter updates.',
            style: AppTextStyle.caption.copyWith(color: colors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCompactTextField(
                  controller: _newsletterController,
                  hint: 'Your email address',
                  icon: Icons.mail_outline_rounded,
                  colors: colors,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Join',
                  style: AppTextStyle.captionBold.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 7. Direct Message Inquiry Card
  Widget _buildMessageFormCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 16,
                color: AppColors.warning,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Direct Inquiry Message',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '07',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Need custom animation tuning? Send our team a note.',
            style: AppTextStyle.caption.copyWith(color: colors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCompactTextField(
                  controller: _messageController,
                  hint: 'Write your message here...',
                  icon: Icons.edit_outlined,
                  colors: colors,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.warning, AppColors.amberDeep],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.send_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Send',
                      style: AppTextStyle.captionBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 8. Milestones & Task Progress Card
  Widget _buildMilestonesCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.checklist_rtl_rounded,
                size: 16,
                color: AppColors.primaryAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Sprint Delivery Milestones',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '08',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Core sequence engine deployed',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '1:1 scrub interpolation verified',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 9. Pricing & Subscription Plan Card
  Widget _buildPricingPlanCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.diamond_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Enterprise Spatial Tier',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '09',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '\$49',
                style: AppTextStyle.screenHeader.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/ month',
                style: AppTextStyle.caption.copyWith(color: colors.textMuted),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PRO ACCESS',
                  style: AppTextStyle.captionBold.copyWith(
                    color: AppColors.primary,
                    fontSize: 8.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 10. Viewport Realtime Analytics Card
  Widget _buildAnalyticsCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyanAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights_rounded,
                size: 16,
                color: AppColors.cyanAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Realtime Viewport Telemetry',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '10',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.cyanAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '60.0 FPS',
                        style: AppTextStyle.captionBold.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Render Pacing',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '0.4 ms',
                        style: AppTextStyle.captionBold.copyWith(
                          color: AppColors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Frame Latency',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 11. Spatial Ambient Soundscape Media Card
  Widget _buildMediaCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.graphic_eq_rounded,
                size: 16,
                color: AppColors.primaryAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Spatial Soundscape Audio',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '11',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primaryAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nordic Horizon Ambient â€¢ 24-bit',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '03:45 / 05:20 â€¢ Hi-Res Audio',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                        fontSize: 9,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 12. Verified Developer Testimonial Card
  Widget _buildTestimonialCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.format_quote_rounded,
                size: 16,
                color: AppColors.warning,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Developer Feedback',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '12',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
              (index) => const Icon(
                Icons.star_rounded,
                size: 13,
                color: AppColors.warning,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '"BySequence delivered silky 60fps scroll scrubbing right out of the box!"',
            style: AppTextStyle.caption.copyWith(
              color: colors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 13. Edge Node Cluster Environment Card
  Widget _buildWeatherStatusCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.cloudy_snowing, size: 16, color: AppColors.info),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Edge Cluster Atmosphere',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '13',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '21Â°C',
                style: AppTextStyle.captionBold.copyWith(
                  color: colors.textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'US-East Node â€¢ 99.99% Uptime',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 14. Promo Voucher Application Card
  Widget _buildPromoCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_offer_outlined,
                size: 16,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Apply Promo Voucher',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '14',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCompactTextField(
                  controller: _promoController,
                  hint: 'Promo Code (BYUI-2026)',
                  icon: Icons.confirmation_number_outlined,
                  colors: colors,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.success, AppColors.emeraldDeep],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Apply',
                  style: AppTextStyle.captionBold.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 15. Hardware Security Enclave Card
  Widget _buildSecurityCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Hardware Security Enclave',
                  style: AppTextStyle.captionBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '15',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.fingerprint_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biometric Auth Verified',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'AES-256 GCM Keychain Active',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                        fontSize: 9,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 16. Completion Trophy Card
  Widget _buildCompletionCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyanAccent.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.warning,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Midway Checkpoint',
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '16',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '16 items revealed. 16 more diverse cards ahead!',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 17. KPI Revenue Card
  Widget _buildKpiRevenueCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      size: 16,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Net ARR Growth',
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '17',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$48,250.00',
                    style: AppTextStyle.sectionHeader.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        size: 12,
                        color: AppColors.success,
                      ),
                      Text(
                        '+18.4% vs last mo.',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [12, 18, 14, 24, 28, 36].map((h) {
                  return Container(
                    width: 5,
                    height: h.toDouble(),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(
                        alpha: h > 20 ? 0.9 : 0.35,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 18. Git Commit Activity Card
  Widget _buildGitCommitCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.commit_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Repository Activity',
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '18',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'feat(sequence): 32-item dynamic scroll viewport',
            style: AppTextStyle.captionBold.copyWith(color: colors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'main #8f2a1b',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '4 mins ago',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 19. Audio Player Card
  Widget _buildAudioPlayerCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryAccent],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Midnight Synthwave',
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '19',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 4,
                    backgroundColor: colors.borderSubtle,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'ByUI Audio Engine',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textMuted,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '02:45 / 04:12',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 20. Cloud Storage Gauge Card
  Widget _buildStorageGaugeCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.cloud_done_rounded,
                    size: 16,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'High-Speed NVMe Storage',
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '20',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.76,
              minHeight: 8,
              backgroundColor: colors.borderSubtle,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '194.5 GB of 256.0 GB used',
                style: AppTextStyle.caption.copyWith(color: colors.textPrimary),
              ),
              Text(
                '76%',
                style: AppTextStyle.captionBold.copyWith(color: AppColors.info),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 21. Quick Action Grid Card
  Widget _buildQuickActionGridCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    final actions = [
      {'icon': Icons.send_rounded, 'label': 'Transfer'},
      {'icon': Icons.download_rounded, 'label': 'Receive'},
      {'icon': Icons.swap_horiz_rounded, 'label': 'Swap'},
      {'icon': Icons.history_rounded, 'label': 'History'},
    ];
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Actions Hub',
                style: AppTextStyle.captionBold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '21',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.map((act) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Icon(
                      act['icon'] as IconData,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    act['label'] as String,
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 22. Smart Home Climate Sensor Card
  Widget _buildSmartHomeSensorCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyanAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cyanAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.thermostat_rounded,
              color: AppColors.cyanAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Living Room AC',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '22',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '22.5Â°C',
                      style: AppTextStyle.sectionHeader.copyWith(
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Eco Cool',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '48% RH',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 23. Task Checklist Card
  Widget _buildTaskChecklistCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.checklist_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Release Sprint Tasks',
                    style: AppTextStyle.captionBold.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '23',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Optimize BySequence scrub listener',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textMuted,
                    decoration: TextDecoration.lineThrough,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.radio_button_unchecked_rounded,
                size: 14,
                color: AppColors.warning,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Verify responsive landscape orientation',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 24. Battery & Power Efficiency Card
  Widget _buildBatteryEfficiencyCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SuperVOOC 65W Flash',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '24',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '94% Charged â€¢ 8 mins to full capacity',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 25. Crypto / Market Ticker Card
  Widget _buildCryptoTickerCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.currency_bitcoin_rounded,
              color: AppColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BTC / USD Index',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '25',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$68,490.50',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '+3.85%',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 26. File Download Progress Card
  Widget _buildFileDownloadCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.folder_zip_rounded,
                    size: 16,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'by_ui_design_tokens_v2.zip',
                    style: AppTextStyle.captionBold.copyWith(
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                '26',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: 0.82,
              minHeight: 5,
              backgroundColor: colors.borderSubtle,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '52.4 MB / 64.0 MB',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                  fontSize: 10,
                ),
              ),
              Text(
                '3.8 MB/s',
                style: AppTextStyle.captionBold.copyWith(
                  color: AppColors.info,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 27. Team Avatar Stack Card
  Widget _buildTeamAvatarStackCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    final avatarColors = [
      AppColors.primary,
      AppColors.cyanAccent,
      AppColors.warning,
      AppColors.primaryAccent,
    ];
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 32,
            child: Stack(
              children: List.generate(avatarColors.length, (i) {
                return Positioned(
                  left: i * 14.0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: avatarColors[i],
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.cardBg, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        i == 3 ? '+4' : '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Core Design Team',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '27',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  '7 engineers live on branch',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 28. Order Receipt Card
  Widget _buildOrderReceiptCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Order #BY-9402',
                    style: AppTextStyle.captionBold.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '28',
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ByUI Enterprise License (3 Seats)',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '\$149.00',
                style: AppTextStyle.captionBold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PAID & FULFILLED',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Instant Access',
                style: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 29. Notification Alert Card
  Widget _buildNotificationAlertCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'System Notification',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '29',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Cloud cluster upgrade complete with 99.99% uptime guarantee.',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 30. Customer Rating Card
  Widget _buildCustomerRatingCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '4.9',
                style: AppTextStyle.sectionHeader.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              Row(
                children: List.generate(5, (_) {
                  return const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: 14,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Developer Reviews',
                      style: AppTextStyle.captionBold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '30',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Rated outstanding by 1,480+ mobile engineers worldwide.',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 31. GPS Speedometer & Navigation Card
  Widget _buildGpsNavigationCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.navigation_rounded,
              color: AppColors.info,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Route Guidance HUD',
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '31',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'In 400m, keep right toward Silicon Valley Blvd',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '64 km/h',
            style: AppTextStyle.badge.copyWith(
              color: AppColors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 32. Grand Finale Milestone Card
  Widget _buildGrandCompletionCard({
    required AppColorPalette colors,
    required bool isDark,
    required bool isVertical,
  }) {
    return Container(
      width: isVertical ? double.infinity : 275,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.45),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryAccent,
                  AppColors.cyanAccent,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.35),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.military_tech_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Grand Finale Complete!',
                        style: AppTextStyle.captionBold.copyWith(
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '32',
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'All 32 sequence items dynamically calculated & rendered in viewport.',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required AppColorPalette colors,
    required bool isDark,
    int maxLines = 1,
  }) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: colors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              textAlignVertical: TextAlignVertical.center,
              style: AppTextStyle.caption.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTextStyle.caption.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}