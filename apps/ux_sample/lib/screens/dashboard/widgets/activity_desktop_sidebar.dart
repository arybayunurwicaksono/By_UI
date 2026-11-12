import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../../models/dummy_data.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyle.dart';

/// Right-hand desktop rail sidebar for the Activity tab, providing filter presets,
/// spending analytics breakdown, and recommended financial actions.
class ActivityDesktopSidebar extends StatefulWidget {
  final int selectedFilterIndex;
  final ValueChanged<int> onFilterChanged;
  final String selectedTimeframe;
  final ValueChanged<String> onTimeframeChanged;

  const ActivityDesktopSidebar({
    super.key,
    required this.selectedFilterIndex,
    required this.onFilterChanged,
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
  });

  @override
  State<ActivityDesktopSidebar> createState() => _ActivityDesktopSidebarState();
}

class _ActivityDesktopSidebarState extends State<ActivityDesktopSidebar> {
  static const List<String> _timeframes = [
    'All Time',
    'This Month',
    'This Week',
    'Today',
  ];

  static const List<Map<String, dynamic>> _statusFilters = [
    {'label': 'All Transactions', 'status': null, 'color': AppColors.primary},
    {
      'label': 'Successful',
      'status': TransactionStatus.success,
      'color': AppColors.success,
    },
    {
      'label': 'Pending',
      'status': TransactionStatus.pending,
      'color': AppColors.warning,
    },
    {
      'label': 'Failed',
      'status': TransactionStatus.failed,
      'color': AppColors.error,
    },
  ];

  int _getCountForFilter(int index) {
    if (index == 0) return DummyRepository.transactions.length;
    if (index == 1) {
      return DummyRepository.transactions
          .where((t) => t.status == TransactionStatus.success)
          .length;
    }
    if (index == 2) {
      return DummyRepository.transactions
          .where((t) => t.status == TransactionStatus.pending)
          .length;
    }
    return DummyRepository.transactions
        .where((t) => t.status == TransactionStatus.failed)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Status Filter & Timeframe Card
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
                          Icons.tune_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Filter Activity',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.subheading,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${DummyRepository.transactions.length} TOTAL',
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.cardBorder, height: 1),
              const SizedBox(height: 12),

              // Status Filter Options
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _statusFilters.length,
                separatorBuilder: (context, index) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final isSelected = widget.selectedFilterIndex == index;
                  final filter = _statusFilters[index];
                  final count = _getCountForFilter(index);
                  final Color filterColor = filter['color'] as Color;

                  return InkWell(
                    onTap: () => widget.onFilterChanged(index),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryLight
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: filterColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                filter['label'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primaryDark
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.scaffoldBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),
              const Text(
                'TIMEFRAME',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Timeframe Chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _timeframes.map((tf) {
                  final isSelected = widget.selectedTimeframe == tf;
                  return GestureDetector(
                    onTap: () => widget.onTimeframeChanged(tf),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.cardBorder,
                        ),
                      ),
                      child: Text(
                        tf,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 2. Spending Breakdown & Cashflow Card
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
                    Icons.pie_chart_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cash Flow Breakdown',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.subheading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.cardBorder, height: 1),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monthly Inflow', style: AppTextStyle.caption),
                        SizedBox(height: 2),
                        Text(
                          '+\$18,250.00',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28,
                    color: AppColors.cardBorder,
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Monthly Outflow', style: AppTextStyle.caption),
                        SizedBox(height: 2),
                        Text(
                          '-\$7,420.00',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Category progress bars
              _buildCategoryProgress('Cloud Services', 0.45, '\$450.00', AppColors.primary),
              const SizedBox(height: 8),
              _buildCategoryProgress('Subscriptions', 0.30, '\$299.00', AppColors.cyanAccent),
              const SizedBox(height: 8),
              _buildCategoryProgress('E-Commerce', 0.18, '\$185.00', AppColors.warning),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 3. Recommended Actions & Subscriptions Card
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
                    Icons.auto_awesome_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Recommended Actions',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.subheading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.cardBorder, height: 1),
              const SizedBox(height: 12),

              // Export statement action
              ByButton(
                width: double.infinity,
                size: ByButtonSize.small,
                variant: ByButtonVariant.outline,
                borderColor: AppColors.primary,
                foregroundColor: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                prefix: const Icon(Icons.download_rounded, size: 14),
                onPressed: () {
                  ByToast.show(
                    context,
                    title: 'Financial Statement Export',
                    message: 'Activity report (PDF/CSV) generated successfully',
                    icon: Icons.file_download_done_rounded,
                    backgroundColor: AppColors.primaryDark,
                  );
                },
                child: const Text('Export Statement (PDF)'),
              ),
              const SizedBox(height: 10),

              // Tax summary action
              ByButton(
                width: double.infinity,
                size: ByButtonSize.small,
                variant: ByButtonVariant.ghost,
                foregroundColor: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(10),
                prefix: const Icon(Icons.receipt_long_rounded, size: 14),
                onPressed: () {
                  ByToast.show(
                    context,
                    title: 'Tax & Audit Ready',
                    message: '2026 transaction records verified for audit',
                    icon: Icons.verified_user_rounded,
                    backgroundColor: AppColors.success,
                  );
                },
                child: const Text('Tax & Audit Report'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryProgress(
    String label,
    double fraction,
    String amount,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyle.caption),
            Text(
              amount,
              style: AppTextStyle.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 5,
            backgroundColor: AppColors.scaffoldBg,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
