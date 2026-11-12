import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../../models/dummy_data.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyle.dart';

/// Presentation cards specifically for the [BySequence] feed in HomeTab.
abstract final class HomeSequenceCards {
  /// Builds an interactive detail dialog modal using [ByDialog] with dynamic border.
  static void showItemDetailDialog(
    BuildContext context,
    SequenceActivityItem item,
  ) {
    ByDialog.show(
      context,
      borderRadius: BorderRadius.circular(22),
      dynamicBorder: const ByDynamicBorder(
        enabled: true,
        width: 2.0,
        shadowBlur: 10.0,
        duration: Duration(milliseconds: 2000),
        gradient: LinearGradient(
          colors: AppColors.laserColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      builder: (dialogCtx) {
        return Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.accentColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.subheading,
                        ),
                        Text(
                          'ID: ${item.id}',
                          style: AppTextStyle.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount / Value:', style: AppTextStyle.caption),
                    Text(item.amount, style: AppTextStyle.bodyBold),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.subtitle,
                style: AppTextStyle.body,
              ),
              const SizedBox(height: 20),
              ByButton(
                width: double.infinity,
                variant: ByButtonVariant.filled,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Close Details'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the list of widgets rendered sequentially by [BySequence].
  ///
  /// On mobile ([isDesktop] is `false`), renders vertical list cards (~60px).
  /// On desktop ([isDesktop] is `true`), chunks items into rows of paired desktop cards (~135px height).
  static List<Widget> buildSequenceItems(
    BuildContext context, {
    bool isDesktop = false,
  }) {
    const items = DummyRepository.sequenceActivities;

    if (!isDesktop) {
      return items.map((item) => _buildMobileCard(context, item)).toList();
    }

    // Desktop: chunk items into paired Rows for a 2-column grid inside BySequence
    final List<Widget> rows = [];
    for (int i = 0; i < items.length; i += 2) {
      final itemA = items[i];
      final itemB = (i + 1 < items.length) ? items[i + 1] : null;

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDesktopCard(context, itemA)),
            const SizedBox(width: 14),
            if (itemB != null)
              Expanded(child: _buildDesktopCard(context, itemB))
            else
              const Expanded(child: SizedBox.shrink()),
          ],
        ),
      );
    }
    return rows;
  }

  /// Compact single-line list tile card tailored for mobile viewports.
  static Widget _buildMobileCard(
    BuildContext context,
    SequenceActivityItem item,
  ) {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: Colors.white,
      borderColor: AppColors.cardBorder,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(14),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => showItemDetailDialog(context, item),
        child: Row(
          children: [
            // Icon Badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: item.accentColor, size: 22),
            ),
            const SizedBox(width: 12),

            // Title, Subtitle, & Badge (Protected against overflow with Expanded/Flexible)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.subheading,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: item.accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 54),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              item.badge,
                              style: AppTextStyle.badge.copyWith(
                                fontSize: 9,
                                color: item.accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.caption,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Amount & Chevron Action Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 72),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.amount,
                      style: AppTextStyle.bodyBold.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Rich, balanced dashboard card tailored for desktop/web grid layouts.
  static Widget _buildDesktopCard(
    BuildContext context,
    SequenceActivityItem item,
  ) {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: Colors.white,
      borderColor: AppColors.cardBorder,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(16),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => showItemDetailDialog(context, item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Icon badge + Status pill + Amount
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: item.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.accentColor, size: 20),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: item.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.badge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.badge.copyWith(
                        fontSize: 10,
                        color: item.accentColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.amount,
                  style: AppTextStyle.bodyBold.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Middle: Title & Subtitle
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.subheading.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 3),
            Text(
              item.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Bottom Footer Row: ID tag + "View Details" action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${item.id}',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Details',
                      style: AppTextStyle.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
