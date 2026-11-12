import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../../models/dummy_data.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyle.dart';
import '../widgets/activity_desktop_sidebar.dart';
import '../widgets/dashboard_search_bar.dart';

/// Activity and transaction history tab with keyword search, multi-column desktop grid,
/// right-hand recommendation rail, and ByToast interactions.
class ActivityTab extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDesktop;

  const ActivityTab({
    super.key,
    required this.scrollController,
    this.isDesktop = false,
  });

  @override
  State<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  int _selectedFilterIndex = 0;
  String _selectedTimeframe = 'All Time';
  late final TextEditingController _searchController;
  String _searchQuery = '';

  static const List<String> _mobileFilters = [
    'All',
    'Successful',
    'Pending',
    'Failed',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return AppColors.success;
      case TransactionStatus.pending:
        return AppColors.warning;
      case TransactionStatus.failed:
        return AppColors.error;
    }
  }

  String _getStatusLabel(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return 'Successful';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  void _onTransactionTapped(TransactionItem trx) {
    final statusColor = _getStatusColor(trx.status);
    final statusLabel = _getStatusLabel(trx.status);

    ByToast.show(
      context,
      title: trx.title,
      message: '${trx.amount} • Status: $statusLabel (${trx.date})',
      icon: trx.icon,
      backgroundColor: statusColor,
    );
  }

  List<TransactionItem> _getFilteredTransactions() {
    final query = _searchQuery.trim().toLowerCase();

    return DummyRepository.transactions.where((t) {
      // 1. Status Filter
      if (_selectedFilterIndex == 1 && t.status != TransactionStatus.success) {
        return false;
      }
      if (_selectedFilterIndex == 2 && t.status != TransactionStatus.pending) {
        return false;
      }
      if (_selectedFilterIndex == 3 && t.status != TransactionStatus.failed) {
        return false;
      }

      // 2. Search Query Filter
      if (query.isNotEmpty) {
        final matchesTitle = t.title.toLowerCase().contains(query);
        final matchesCategory = t.category.toLowerCase().contains(query);
        final matchesAmount = t.amount.toLowerCase().contains(query);
        final matchesDate = t.date.toLowerCase().contains(query);
        final matchesId = t.id.toLowerCase().contains(query);

        if (!matchesTitle &&
            !matchesCategory &&
            !matchesAmount &&
            !matchesDate &&
            !matchesId) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Builds a single transaction item card styled for grid or list.
  Widget _buildTransactionCard(TransactionItem trx, {bool isGrid = false}) {
    final statusColor = _getStatusColor(trx.status);
    final statusLabel = _getStatusLabel(trx.status);

    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: Colors.white,
      borderColor: AppColors.cardBorder,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(14),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _onTransactionTapped(trx),
        child: isGrid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: (trx.isIncome
                                  ? AppColors.success
                                  : AppColors.primary)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          trx.icon,
                          color: trx.isIncome
                              ? AppColors.success
                              : AppColors.primary,
                          size: 18,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusLabel,
                          style: AppTextStyle.badge.copyWith(
                            fontSize: 9,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trx.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bodyBold,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${trx.category} • ${trx.date}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.caption.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        trx.id,
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        trx.amount,
                        style: AppTextStyle.bodyBold.copyWith(
                          color: trx.isIncome
                              ? AppColors.success
                              : AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: (trx.isIncome
                              ? AppColors.success
                              : AppColors.primary)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      trx.icon,
                      color:
                          trx.isIncome ? AppColors.success : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trx.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyBold,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                trx.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '•',
                              style: AppTextStyle.caption.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                trx.date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.caption.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        trx.amount,
                        style: AppTextStyle.bodyBold.copyWith(
                          color: trx.isIncome
                              ? AppColors.success
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusLabel,
                          style: AppTextStyle.badge.copyWith(
                            fontSize: 9,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  /// Builds a 3-metric quick summary grid for the top of the desktop activity feed.
  Widget _buildDesktopSummaryMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            title: 'Total Inflow',
            value: '+\$18,250.00',
            subtitle: '3 Incoming Payments',
            icon: Icons.arrow_downward_rounded,
            iconColor: AppColors.success,
            iconBg: AppColors.successLight,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildMetricTile(
            title: 'Total Outflow',
            value: '-\$7,420.00',
            subtitle: 'Cloud & License Fees',
            icon: Icons.arrow_upward_rounded,
            iconColor: AppColors.warning,
            iconBg: AppColors.warningLight,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildMetricTile(
            title: 'Net Performance',
            value: '+\$10,830.00',
            subtitle: '88% Success Rate',
            icon: Icons.insights_rounded,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: Colors.white,
      borderColor: AppColors.cardBorder,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(14),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.caption,
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyBold.copyWith(fontSize: 13),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isCompact = mediaQuery.size.width < 440;

    final filteredList = _getFilteredTransactions();

    // 1. Search Bar at the top
    final searchBarWidget = Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: DashboardSearchBar(
        controller: _searchController,
        hintText: 'Search transactions, categories, or amounts...',
        onChanged: (q) {
          setState(() {
            _searchQuery = q;
          });
        },
        onClear: () {
          setState(() {
            _searchQuery = '';
          });
        },
      ),
    );

    // 2. Active Search Query Pill (if searching)
    final activeSearchPill = _searchQuery.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
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
                          setState(() {
                            _searchQuery = '';
                          });
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
                const SizedBox(width: 8),
                Text(
                  '(${filteredList.length} matching)',
                  style: AppTextStyle.caption,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();

    // 3. Mobile Filter Chips (visible on mobile only)
    final mobileFilterChips = !widget.isDesktop
        ? Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(_mobileFilters.length, (idx) {
                  final isSelected = _selectedFilterIndex == idx;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: BySelectOption(
                      label: Text(_mobileFilters[idx]),
                      isSelected: isSelected,
                      selectedBorderColor: AppColors.primary,
                      selectedTextColor: AppColors.primaryDark,
                      unselectedBorderColor: AppColors.cardBorder,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = idx;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
          )
        : const SizedBox.shrink();

    // 4. Main Transaction Feed Content
    Widget buildTransactionStream() {
      if (filteredList.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.receipt_long_rounded,
                  size: 40,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 10),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'No transactions matching "$_searchQuery"'
                      : 'No transactions found for this filter',
                  style: AppTextStyle.subheading,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Try searching for different terms or reset your filters',
                  style: AppTextStyle.caption,
                ),
              ],
            ),
          ),
        );
      }

      // On Desktop: 2-Column Responsive Card Grid
      if (widget.isDesktop) {
        final List<Widget> gridRows = [];
        for (int i = 0; i < filteredList.length; i += 2) {
          final trxA = filteredList[i];
          final trxB = (i + 1 < filteredList.length) ? filteredList[i + 1] : null;

          gridRows.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTransactionCard(trxA, isGrid: true)),
                  const SizedBox(width: 14),
                  if (trxB != null)
                    Expanded(child: _buildTransactionCard(trxB, isGrid: true))
                  else
                    const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction Records (Desktop Grid)',
                  style: AppTextStyle.subheading,
                ),
                Text(
                  '${filteredList.length} items',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...gridRows,
          ],
        );
      }

      // On Mobile: Single Column Vertical List
      return Column(
        children: filteredList.map((trx) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildTransactionCard(trx, isGrid: false),
          );
        }).toList(),
      );
    }

    return ListView(
      controller: widget.scrollController,
      padding: EdgeInsets.fromLTRB(
        widget.isDesktop ? 24 : (isCompact ? 12 : 16),
        widget.isDesktop ? 20 : 14,
        widget.isDesktop ? 24 : (isCompact ? 12 : 16),
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
                activeSearchPill,
                mobileFilterChips,

                if (widget.isDesktop) ...[
                  // Summary Metrics 3-Card Grid
                  _buildDesktopSummaryMetrics(),
                  const SizedBox(height: 20),

                  // 2-Column Split: Grid Stream (Left) + Activity Desktop Sidebar (Right)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Transaction Grid
                      Expanded(
                        child: buildTransactionStream(),
                      ),

                      const SizedBox(width: 24),

                      // Right: Filters & Recommendations Sidebar
                      SizedBox(
                        width: 320,
                        child: ActivityDesktopSidebar(
                          selectedFilterIndex: _selectedFilterIndex,
                          onFilterChanged: (idx) {
                            setState(() {
                              _selectedFilterIndex = idx;
                            });
                          },
                          selectedTimeframe: _selectedTimeframe,
                          onTimeframeChanged: (tf) {
                            setState(() {
                              _selectedTimeframe = tf;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Mobile View
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Transaction History',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.heading,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ByButton(
                        size: ByButtonSize.small,
                        variant: ByButtonVariant.ghost,
                        foregroundColor: AppColors.primary,
                        prefix: isCompact
                            ? null
                            : const Icon(Icons.flash_on_rounded, size: 14),
                        onPressed: () {
                          ByToast.show(
                            context,
                            title: 'Stacked Toast Notification',
                            message: 'ByUI multiple notifications stack seamlessly',
                            icon: Icons.layers_rounded,
                            backgroundColor: AppColors.primaryDark,
                          );
                        },
                        child: const Text('Test Toast'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  buildTransactionStream(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
