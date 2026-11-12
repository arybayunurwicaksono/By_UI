import 'package:flutter/material.dart';

/// Financial and wallet overview metrics.
class AccountSummary {
  final String formattedBalance;
  final String monthlyGrowth;
  final int rewardPoints;
  final String accountNumber;
  final String monthlyIncome;
  final String monthlyExpense;

  const AccountSummary({
    required this.formattedBalance,
    required this.monthlyGrowth,
    required this.rewardPoints,
    required this.accountNumber,
    required this.monthlyIncome,
    required this.monthlyExpense,
  });

  static const sample = AccountSummary(
    formattedBalance: '\$28,450.00',
    monthlyGrowth: '+14.8%',
    rewardPoints: 1850,
    accountNumber: '**** 8842',
    monthlyIncome: '+\$18,250.00',
    monthlyExpense: '-\$7,420.00',
  );
}

/// Status enum for transactions.
enum TransactionStatus {
  success,
  pending,
  failed,
}

/// Transaction data model.
class TransactionItem {
  final String id;
  final String title;
  final String category;
  final String date;
  final String amount;
  final bool isIncome;
  final TransactionStatus status;
  final IconData icon;

  const TransactionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.status,
    required this.icon,
  });
}

/// Exploration / service catalog item.
class ExploreServiceItem {
  final String id;
  final String title;
  final String category;
  final String description;
  final String badgeText;
  final IconData icon;
  final Color themeColor;

  const ExploreServiceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.badgeText,
    required this.icon,
    required this.themeColor,
  });
}

/// Sequence activity and recommendation item model.
class SequenceActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Color accentColor;
  final String amount;

  const SequenceActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.accentColor,
    required this.amount,
  });
}

/// Mock repository providing clean English data for the UX sample app.
abstract final class DummyRepository {
  static const List<TransactionItem> transactions = [
    TransactionItem(
      id: 'TRX-901',
      title: 'Cloud Server Infrastructure',
      category: 'Cloud Services',
      date: 'Nov 03, 2026, 14:15',
      amount: '-\$450.00',
      isIncome: false,
      status: TransactionStatus.success,
      icon: Icons.cloud_done_rounded,
    ),
    TransactionItem(
      id: 'TRX-902',
      title: 'Inbound Client Payment',
      category: 'Project Revenue',
      date: 'Nov 03, 2026, 11:20',
      amount: '+\$6,200.00',
      isIncome: true,
      status: TransactionStatus.success,
      icon: Icons.arrow_downward_rounded,
    ),
    TransactionItem(
      id: 'TRX-903',
      title: 'ByUI Pro License Plan',
      category: 'Subscriptions',
      date: 'Nov 02, 2026, 18:00',
      amount: '-\$299.00',
      isIncome: false,
      status: TransactionStatus.success,
      icon: Icons.workspace_premium_rounded,
    ),
    TransactionItem(
      id: 'TRX-904',
      title: 'Digital Wallet Deposit',
      category: 'Account Funding',
      date: 'Nov 01, 2026, 09:30',
      amount: '+\$1,500.00',
      isIncome: true,
      status: TransactionStatus.pending,
      icon: Icons.account_balance_wallet_rounded,
    ),
    TransactionItem(
      id: 'TRX-905',
      title: 'Merchant Checkout Fee',
      category: 'E-Commerce',
      date: 'Oct 31, 2026, 20:45',
      amount: '-\$185.00',
      isIncome: false,
      status: TransactionStatus.failed,
      icon: Icons.shopping_bag_rounded,
    ),
  ];

  static const List<ExploreServiceItem> services = [
    ExploreServiceItem(
      id: 'SRV-01',
      title: 'ByDynamic Gateway',
      category: 'Financial',
      description: 'Ultra-fast payment routing with dynamic perimeter encryption.',
      badgeText: 'INSTANT',
      icon: Icons.bolt_rounded,
      themeColor: Color(0xFF06B6D4),
    ),
    ExploreServiceItem(
      id: 'SRV-02',
      title: 'Smart Analytics AI',
      category: 'Analytics',
      description: 'Realtime cash flow forecasts and visual predictive metrics.',
      badgeText: 'AI AUTO',
      icon: Icons.insights_rounded,
      themeColor: Color(0xFF0284C7),
    ),
    ExploreServiceItem(
      id: 'SRV-03',
      title: 'Multi-Vault Savings',
      category: 'Investment',
      description: 'High-yield treasury vaults with insured principal protection.',
      badgeText: 'HOT 7%',
      icon: Icons.shield_rounded,
      themeColor: Color(0xFF10B981),
    ),
    ExploreServiceItem(
      id: 'SRV-04',
      title: 'Global Virtual Card',
      category: 'Financial',
      description: 'Zero FX conversion fees across 120+ international markets.',
      badgeText: 'NEW',
      icon: Icons.credit_card_rounded,
      themeColor: Color(0xFF0891B2),
    ),
  ];

  static const List<SequenceActivityItem> sequenceActivities = [
    SequenceActivityItem(
      id: 'SEQ-01',
      title: 'Q4 Treasury Growth Goal',
      subtitle: '82% of \$35,000 target achieved',
      badge: 'PROGRESS',
      icon: Icons.track_changes_rounded,
      accentColor: Color(0xFF06B6D4),
      amount: '\$28.7k',
    ),
    SequenceActivityItem(
      id: 'SEQ-02',
      title: 'ByUI Reward Cashback',
      subtitle: 'Claim quarterly activity bonus before Nov 10',
      badge: 'CLAIM',
      icon: Icons.redeem_rounded,
      accentColor: Color(0xFF10B981),
      amount: '+\$75.00',
    ),
    SequenceActivityItem(
      id: 'SEQ-03',
      title: 'Account Security Audit',
      subtitle: 'Biometric passkeys active and verified',
      badge: 'SAFE',
      icon: Icons.verified_user_rounded,
      accentColor: Color(0xFF0284C7),
      amount: '100% OK',
    ),
    SequenceActivityItem(
      id: 'SEQ-04',
      title: 'Workspace Rent Auto-Pay',
      subtitle: 'Monthly lease debit scheduled for the 5th',
      badge: 'SCHEDULE',
      icon: Icons.event_repeat_rounded,
      accentColor: Color(0xFFF59E0B),
      amount: '-\$4,500.00',
    ),
    SequenceActivityItem(
      id: 'SEQ-05',
      title: 'Equity Portfolio Dividend',
      subtitle: 'Net distribution from ByUI Tech holdings',
      badge: 'DIVIDEND',
      icon: Icons.paid_rounded,
      accentColor: Color(0xFF10B981),
      amount: '+\$1,250.00',
    ),
    SequenceActivityItem(
      id: 'SEQ-06',
      title: 'Kubernetes Cloud Cluster',
      subtitle: 'Compute node charges for cluster-id-88',
      badge: 'INFRA',
      icon: Icons.cloud_queue_rounded,
      accentColor: Color(0xFF0891B2),
      amount: '-\$820.00',
    ),
    SequenceActivityItem(
      id: 'SEQ-07',
      title: 'Partner Merchant Voucher',
      subtitle: '30% discount on workstation equipment',
      badge: 'PROMO',
      icon: Icons.local_offer_rounded,
      accentColor: Color(0xFFEF4444),
      amount: '30% OFF',
    ),
    SequenceActivityItem(
      id: 'SEQ-08',
      title: 'Partner Inbound Wire',
      subtitle: 'Milestone 1 design system sign-off payment',
      badge: 'WIRE',
      icon: Icons.account_balance_rounded,
      accentColor: Color(0xFF10B981),
      amount: '+\$12,000.00',
    ),
    SequenceActivityItem(
      id: 'SEQ-09',
      title: 'Treasury Asset Allocation',
      subtitle: 'Balanced liquidity reserve investment',
      badge: 'ASSET',
      icon: Icons.currency_bitcoin_rounded,
      accentColor: Color(0xFFF59E0B),
      amount: '-\$3,500.00',
    ),
    SequenceActivityItem(
      id: 'SEQ-10',
      title: 'Multi-Currency Pocket',
      subtitle: 'USD foreign exchange currency balance',
      badge: 'FX POCKET',
      icon: Icons.currency_exchange_rounded,
      accentColor: Color(0xFF06B6D4),
      amount: '\$500.00',
    ),
    SequenceActivityItem(
      id: 'SEQ-11',
      title: 'Fixed Term Yield Payout',
      subtitle: 'Accrued compound yield for Q3 cycle',
      badge: 'YIELD',
      icon: Icons.savings_rounded,
      accentColor: Color(0xFF10B981),
      amount: '+\$410.00',
    ),
    SequenceActivityItem(
      id: 'SEQ-12',
      title: 'Corporate Tax Settlement',
      subtitle: 'Automated electronic tax filing completed',
      badge: 'TAX',
      icon: Icons.receipt_rounded,
      accentColor: Color(0xFF64748B),
      amount: '-\$2,100.00',
    ),
  ];
}
