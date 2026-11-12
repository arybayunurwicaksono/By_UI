import 'dart:async';
import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../../models/dummy_data.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyle.dart';
import '../widgets/home_sequence_cards.dart';

/// Home tab featuring Hero Balance ByCard, responsive multi-column grid architecture,
/// ByAutoShimmer data synchronization, and 12-item sequential reveal feed via BySequence.
class HomeTab extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDesktop;

  const HomeTab({
    super.key,
    required this.scrollController,
    this.isDesktop = false,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isSyncing = false;
  Timer? _syncTimer;

  static const List<Map<String, dynamic>> _quickServices = [
    {
      'title': 'Quick Transfer',
      'desc': 'Send funds globally',
      'icon': Icons.send_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'E-Wallet Top Up',
      'desc': 'Instant balance reload',
      'icon': Icons.account_balance_wallet_rounded,
      'color': AppColors.cyanAccent,
    },
    {
      'title': 'Pay Utility Bills',
      'desc': 'Electricity & water',
      'icon': Icons.receipt_long_rounded,
      'color': AppColors.warning,
    },
    {
      'title': 'Invest & Growth',
      'desc': 'High-yield vaults 7%',
      'icon': Icons.trending_up_rounded,
      'color': AppColors.success,
    },
    {
      'title': 'QRIS Universal',
      'desc': 'Scan & pay anywhere',
      'icon': Icons.qr_code_scanner_rounded,
      'color': AppColors.primaryDark,
    },
    {
      'title': 'Split Bill',
      'desc': 'Shared workspace tab',
      'icon': Icons.call_split_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'Virtual Cards',
      'desc': 'Zero FX foreign cards',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFFEC4899),
    },
    {
      'title': 'Security Audit',
      'desc': 'Passkeys & biometrics',
      'icon': Icons.verified_user_rounded,
      'color': Color(0xFF14B8A6),
    },
  ];

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  void _triggerLiveSync() {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isSyncing = false;
      });
      ByToast.show(
        context,
        title: 'ByAutoShimmer Live Sync',
        message: 'Portfolio & market insights updated successfully',
        icon: Icons.check_circle_rounded,
        backgroundColor: AppColors.success,
      );
    });
  }

  Widget _buildHeroCard({required bool isCompact}) {
    return ByCard(
      variant: ByCardVariant.dynamicSensor,
      enableSensor: true,
      borderRadius: BorderRadius.circular(22),
      borderWidth: 1.5,
      borderGradient: const LinearGradient(
        colors: [
          AppColors.primary,
          AppColors.cyanAccent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shadowGradient: LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.18),
          AppColors.cyanAccent.withValues(alpha: 0.12),
        ],
      ),
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(isCompact ? 14 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Active Balance',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      size: 12,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AccountSummary.sample.monthlyGrowth,
                      style: AppTextStyle.badge.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AccountSummary.sample.formattedBalance,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.display.copyWith(
              fontSize: isCompact ? 22 : 26,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Account: ${AccountSummary.sample.accountNumber} • ${AccountSummary.sample.rewardPoints} Reward Points',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.caption,
          ),
          const SizedBox(height: 16),

          // Action Buttons Row (Responsive Small Screen Safe with ConstrainedBox)
          Row(
            children: [
              Expanded(
                child: ByButton(
                  size: ByButtonSize.small,
                  variant: ByButtonVariant.filled,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  borderWidth: 0,
                  style: const ByButtonStyle(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                  ),
                  prefix: isCompact
                      ? null
                      : const Icon(Icons.send_rounded, size: 14),
                  onPressed: () {
                    ByToast.show(
                      context,
                      message: 'Quick Transfer is ready to use',
                      icon: Icons.send_rounded,
                      backgroundColor: AppColors.primaryDark,
                    );
                  },
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: isCompact ? 56.0 : 80.0),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Send'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ByButton(
                  size: ByButtonSize.small,
                  variant: ByButtonVariant.outline,
                  borderColor: AppColors.primary,
                  foregroundColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  style: const ByButtonStyle(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                  ),
                  prefix: isCompact
                      ? null
                      : const Icon(Icons.add_circle_outline_rounded, size: 14),
                  onPressed: () {
                    ByToast.show(
                      context,
                      message: 'Select your preferred Top Up method',
                      icon: Icons.account_balance_rounded,
                      backgroundColor: AppColors.info,
                    );
                  },
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: isCompact ? 56.0 : 80.0),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Top Up'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ByButton(
                  size: ByButtonSize.small,
                  variant: ByButtonVariant.ghost,
                  foregroundColor: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(10),
                  style: const ByButtonStyle(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                  ),
                  prefix: isCompact
                      ? null
                      : const Icon(Icons.qr_code_scanner_rounded, size: 14),
                  onPressed: () {
                    ByToast.show(
                      context,
                      message: 'ByUI QR Scanner is active',
                      icon: Icons.qr_code_rounded,
                      backgroundColor: AppColors.primaryDark,
                    );
                  },
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: isCompact ? 56.0 : 80.0),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Scan QR'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowCards({required bool isCompact}) {
    return Row(
      children: [
        Expanded(
          child: ByCard(
            variant: ByCardVariant.normal,
            backgroundColor: Colors.white,
            borderColor: AppColors.cardBorder,
            borderWidth: 1.0,
            borderRadius: BorderRadius.circular(18),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_downward_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Monthly Income',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.caption,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AccountSummary.sample.monthlyIncome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyBold.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: isCompact ? 13 : 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '3 Inbound sources',
                  style: AppTextStyle.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ByCard(
            variant: ByCardVariant.normal,
            backgroundColor: Colors.white,
            borderColor: AppColors.cardBorder,
            borderWidth: 1.0,
            borderRadius: BorderRadius.circular(18),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        size: 14,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Monthly Expense',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.caption,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AccountSummary.sample.monthlyExpense,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyBold.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: isCompact ? 13 : 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '48% of budget used',
                  style: AppTextStyle.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Third column card on desktop: Savings goals & spending tracker
  Widget _buildSavingsVaultCard() {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: Colors.white,
      borderColor: AppColors.cardBorder,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.savings_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Treasury Vault Goal',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.subheading,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '82% DONE',
                  style: AppTextStyle.badge.copyWith(
                    color: AppColors.success,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '\$28,700.00 / \$35,000.00',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyBold.copyWith(fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '+\$6,300 left',
                style: AppTextStyle.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.82,
              minHeight: 6,
              backgroundColor: AppColors.scaffoldBg,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Auto-save 15% on revenue',
                style: AppTextStyle.caption,
              ),
              InkWell(
                onTap: () {
                  ByToast.show(
                    context,
                    message: 'Vault allocation rule: 15% Auto-Deposit active',
                    icon: Icons.tune_rounded,
                    backgroundColor: AppColors.primaryDark,
                  );
                },
                child: Text(
                  'Manage',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 4-Column responsive grid of 8 Quick Services on desktop
  Widget _buildQuickServicesGrid({required bool isDesktop}) {
    if (!isDesktop) {
      // Mobile: Horizontal scrolling pill cards
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: _quickServices.map((srv) {
            final Color color = srv['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  ByToast.show(
                    context,
                    title: srv['title'] as String,
                    message: '${srv['desc']} is ready to configure',
                    icon: srv['icon'] as IconData,
                    backgroundColor: color,
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(srv['icon'] as IconData,
                            size: 16, color: color),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        srv['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bodyBold.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        srv['desc'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.caption.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    // Desktop: 4-Column Card Grid (2 rows of 4 cards)
    final List<Widget> gridRows = [];
    for (int i = 0; i < _quickServices.length; i += 4) {
      final batch = _quickServices.sublist(
        i,
        (i + 4).clamp(0, _quickServices.length),
      );

      gridRows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: batch.map((srv) {
              final Color color = srv['color'] as Color;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ByCard(
                    variant: ByCardVariant.normal,
                    backgroundColor: Colors.white,
                    borderColor: AppColors.cardBorder,
                    borderWidth: 1.0,
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.all(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        ByToast.show(
                          context,
                          title: srv['title'] as String,
                          message: '${srv['desc']} is ready to configure',
                          icon: srv['icon'] as IconData,
                          backgroundColor: color,
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              srv['icon'] as IconData,
                              size: 18,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  srv['title'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.bodyBold
                                      .copyWith(fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  srv['desc'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.caption.copyWith(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Column(children: gridRows);
  }

  /// AI Market Pulse Card wrapped in ByAutoShimmer to showcase dynamic border pulse & laser reveal
  Widget _buildAiInsightsCard() {
    return ByAutoShimmer(
      isLoading: _isSyncing,
      borderRadius: BorderRadius.circular(18),
      enableDynamicBorderPulse: true,
      enableLaserReveal: true,
      laserColors: AppColors.laserColors,
      backgroundColor: Colors.white,
      borderColor: AppColors.cardBorder,
      borderWidth: 1.0,
      padding: const EdgeInsets.all(16.0),
      skeletonBuilder: (context) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ByBone.circular(size: 32),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ByBone.text(width: 120, height: 13),
                      SizedBox(height: 4),
                      ByBone.text(width: 80, height: 10),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            ByBone.text(width: double.infinity, height: 12),
            SizedBox(height: 6),
            ByBone.text(width: 200, height: 12),
            SizedBox(height: 14),
            ByBone.rect(width: 100, height: 26),
          ],
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        'AI Market Pulse',
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'REALTIME',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Smart Cashflow Forecast: Projected monthly buffer surplus of +\$3,420.00. Software licenses and cloud spending down 8.4% this cycle.',
            style: AppTextStyle.body.copyWith(
              fontSize: 12,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ByButton(
                size: ByButtonSize.small,
                variant: ByButtonVariant.filled,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
                prefix: const Icon(Icons.bolt_rounded, size: 14),
                onPressed: () {
                  ByToast.show(
                    context,
                    title: 'Strategy Forecast Ready',
                    message: 'Automated treasury rebalancing report generated',
                    icon: Icons.insights_rounded,
                    backgroundColor: AppColors.primaryDark,
                  );
                },
                child: const Text('View Full Report'),
              ),
              ByButton(
                size: ByButtonSize.small,
                variant: ByButtonVariant.ghost,
                foregroundColor: AppColors.primary,
                onPressed: _triggerLiveSync,
                child: const Text('Re-Sync'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Scheduled bills & recurring payments rail card
  Widget _buildScheduledBillsCard() {
    final bills = [
      {
        'title': 'AWS Cloud Hosting',
        'due': 'Due in 2 days',
        'amount': '\$48.20',
        'icon': Icons.cloud_outlined,
      },
      {
        'title': 'Figma Organization',
        'due': 'Due in 5 days',
        'amount': '\$75.00',
        'icon': Icons.draw_rounded,
      },
      {
        'title': 'Fiber Workspace Internet',
        'due': 'Due in 8 days',
        'amount': '\$55.00',
        'icon': Icons.wifi_rounded,
      },
    ];

    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: Colors.white,
      borderColor: AppColors.cardBorder,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(16),
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
                      Icons.event_repeat_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Upcoming Scheduled Bills',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.subheading,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '3 Active',
                style: AppTextStyle.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 8),
          ...bills.map((bill) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      bill['icon'] as IconData,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyBold.copyWith(fontSize: 12),
                        ),
                        Text(
                          bill['due'] as String,
                          style: AppTextStyle.caption.copyWith(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    bill['amount'] as String,
                    style: AppTextStyle.bodyBold.copyWith(fontSize: 12),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isCompact = mediaQuery.size.width < 440;

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
                // 1. Top Bar: Greeting + Live Data Sync Action Button (ByAutoShimmer trigger)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Workspace Overview',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.heading.copyWith(
                              fontSize: widget.isDesktop ? 20 : 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Multi-vault treasury & active micro-interactions',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ByButton(
                      size: ByButtonSize.small,
                      variant: ByButtonVariant.filled,
                      backgroundColor: _isSyncing
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                      foregroundColor:
                          _isSyncing ? Colors.white : AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      prefix: Icon(
                        Icons.sync_rounded,
                        size: 14,
                        color: _isSyncing ? Colors.white : AppColors.primaryDark,
                      ),
                      onPressed: _triggerLiveSync,
                      child: Text(_isSyncing ? 'Syncing...' : 'Sync Data'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 2. Top Overview Grid: 3-column split on Desktop, single-column vertical on Mobile
                if (widget.isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildHeroCard(isCompact: false),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildCashFlowCards(isCompact: false),
                            const SizedBox(height: 12),
                            _buildSavingsVaultCard(),
                          ],
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildHeroCard(isCompact: isCompact),
                  const SizedBox(height: 12),
                  _buildCashFlowCards(isCompact: isCompact),
                ],

                const SizedBox(height: 22),

                // 3. Quick Services & Capabilities Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Quick Services & Actions',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.heading,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '8 Capabilities',
                      style: AppTextStyle.caption.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildQuickServicesGrid(isDesktop: widget.isDesktop),

                const SizedBox(height: 22),

                // 4. Main Highlights Feed Grid + Realtime Insights Rail
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Highlights & Live Feed',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.heading,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.isDesktop
                            ? '12 Items (Desktop 2-Col Grid)'
                            : '12 BySequence Feed',
                        style:
                            AppTextStyle.badge.copyWith(color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (widget.isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: 2-Column Grid Feed via BySequence
                      Expanded(
                        flex: 6,
                        child: BySequence(
                          controller: widget.scrollController,
                          shrinkWrap: true,
                          spacing: 12.0,
                          trigger: 0.95,
                          groupSize: 1,
                          initialVisibleFraction: 1.05,
                          initialVisibleCount: 2,
                          animation: BySequenceAnimation.fadeSlide,
                          children: HomeSequenceCards.buildSequenceItems(
                            context,
                            isDesktop: true,
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Right: AI Market Pulse (ByAutoShimmer) & Scheduled Payments
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildAiInsightsCard(),
                            const SizedBox(height: 16),
                            _buildScheduledBillsCard(),
                          ],
                        ),
                      ),
                    ],
                  )
                else ...[
                  // Mobile: AI insights card at top of feed, then sequence items
                  _buildAiInsightsCard(),
                  const SizedBox(height: 14),
                  BySequence(
                    controller: widget.scrollController,
                    shrinkWrap: true,
                    spacing: 12.0,
                    trigger: 0.95,
                    groupSize: 1,
                    initialVisibleFraction: 1.05,
                    initialVisibleCount: 3,
                    animation: BySequenceAnimation.fadeSlide,
                    children: HomeSequenceCards.buildSequenceItems(
                      context,
                      isDesktop: false,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
