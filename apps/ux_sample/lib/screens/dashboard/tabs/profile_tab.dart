import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyle.dart';
import '../../auth/login_screen.dart';

/// User profile and settings tab with multi-column desktop grid layout,
/// security metrics, privilege cards, and ByDialog logout confirmation.
class ProfileTab extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDesktop;

  const ProfileTab({
    super.key,
    required this.scrollController,
    this.isDesktop = false,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  void _showLogoutConfirmation() {
    ByDialog.show(
      context,
      borderRadius: BorderRadius.circular(22),
      dynamicBorder: const ByDynamicBorder(
        enabled: true,
        width: 2.0,
        shadowBlur: 8.0,
        duration: Duration(milliseconds: 1800),
        gradient: LinearGradient(
          colors: [AppColors.error, Color(0xFFF43F5E), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      builder: (dialogCtx) {
        return Container(
          width: 320,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.errorLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign Out Confirmation',
                style: AppTextStyle.heading,
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to end your current ByUI Pulse session?',
                textAlign: TextAlign.center,
                style: AppTextStyle.body,
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: ByButton(
                      size: ByButtonSize.medium,
                      variant: ByButtonVariant.ghost,
                      foregroundColor: AppColors.textSecondary,
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ByButton(
                      size: ByButtonSize.medium,
                      variant: ByButtonVariant.filled,
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      borderWidth: 0,
                      onPressed: () {
                        Navigator.of(dialogCtx).pop();
                        ByToast.show(
                          context,
                          message: 'Account session ended successfully',
                          icon: Icons.check_circle_outline_rounded,
                          backgroundColor: AppColors.primaryDark,
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('Yes, Sign Out'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryDark, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodyBold.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.caption.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText,
                style: AppTextStyle.badge.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard({required bool isCompact}) {
    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: Colors.white,
      borderColor: AppColors.cardBorder,
      borderWidth: 1.0,
      borderRadius: BorderRadius.circular(22),
      padding: EdgeInsets.all(isCompact ? 14 : 18),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        children: [
          Container(
            width: isCompact ? 54 : 64,
            height: isCompact ? 54 : 64,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Image.asset(
                'assets/images/logo_by_ui_showcase.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Alex Rivera',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.heading.copyWith(
                          fontSize: isCompact ? 16 : 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'alex.rivera@byui.dev',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.caption,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Platinum Member • ByUI Tier 1',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.badge.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 4-Item metric grid for the top right of the desktop profile view
  Widget _buildDesktopProfileMetrics() {
    final metrics = [
      {
        'title': 'Security Level',
        'value': '98 / 100',
        'badge': 'EXCELLENT',
        'color': AppColors.success,
        'icon': Icons.shield_rounded,
      },
      {
        'title': 'Active Sessions',
        'value': '2 Devices',
        'badge': 'VERIFIED',
        'color': AppColors.primary,
        'icon': Icons.devices_rounded,
      },
      {
        'title': 'Workspace Role',
        'value': 'Lead Architect',
        'badge': 'TIER 1',
        'color': AppColors.primaryDark,
        'icon': Icons.badge_rounded,
      },
      {
        'title': 'Account ID',
        'value': '#BY-94021',
        'badge': 'ACTIVE',
        'color': AppColors.cyanAccent,
        'icon': Icons.fingerprint_rounded,
      },
    ];

    return Row(
      children: metrics.map((m) {
        final Color col = m['color'] as Color;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(m['icon'] as IconData, size: 18, color: col),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: col.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            m['badge'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: col,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    m['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.caption.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    m['value'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodyBold.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Security & Credentials Card
  Widget _buildSecurityCard() {
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
          const Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Security & Authentication',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.subheading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.cardBorderSubtle),
          _buildSettingsMenuTile(
            icon: Icons.fingerprint_rounded,
            title: 'Biometrics & Passkeys',
            subtitle: 'Hardware passkey active on 2 devices',
            badgeText: 'Active',
            onTap: () {
              ByToast.show(
                context,
                message: 'Biometric status: Active & Secured',
                icon: Icons.fingerprint_rounded,
                backgroundColor: AppColors.primaryDark,
              );
            },
          ),
          const Divider(height: 1, color: AppColors.cardBorderSubtle),
          _buildSettingsMenuTile(
            icon: Icons.security_rounded,
            title: 'Two-Factor Authentication',
            subtitle: 'Authenticator App (TOTP) enabled',
            badgeText: 'Enabled',
            onTap: () {
              ByToast.show(
                context,
                message: '2FA protection active across all logins',
                icon: Icons.security_rounded,
                backgroundColor: AppColors.success,
              );
            },
          ),
          const Divider(height: 1, color: AppColors.cardBorderSubtle),
          _buildSettingsMenuTile(
            icon: Icons.password_rounded,
            title: 'Master Password',
            subtitle: 'Last updated 28 days ago',
            badgeText: 'Secure',
            onTap: () {
              ByToast.show(
                context,
                message: 'Password strength: High (Entropy 92)',
                icon: Icons.password_rounded,
                backgroundColor: AppColors.info,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Preferences & App Settings Card
  Widget _buildPreferencesCard() {
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
          const Row(
            children: [
              Icon(
                Icons.tune_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Workspace Preferences',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.subheading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.cardBorderSubtle),
          _buildSettingsMenuTile(
            icon: Icons.palette_outlined,
            title: 'Display Theme',
            subtitle: 'Cyan Light Theme active',
            badgeText: 'Cyan',
            onTap: () {
              ByToast.show(
                context,
                message: 'Theme: ByUI Pulse Cyan Light',
                icon: Icons.palette_rounded,
                backgroundColor: AppColors.primaryDark,
              );
            },
          ),
          const Divider(height: 1, color: AppColors.cardBorderSubtle),
          _buildSettingsMenuTile(
            icon: Icons.language_rounded,
            title: 'Interface Language',
            subtitle: 'English (United States)',
            badgeText: 'EN-US',
            onTap: () {
              ByToast.show(
                context,
                message: 'Active language: English (US)',
                icon: Icons.language_rounded,
                backgroundColor: AppColors.primaryDark,
              );
            },
          ),
          const Divider(height: 1, color: AppColors.cardBorderSubtle),
          _buildSettingsMenuTile(
            icon: Icons.notifications_active_outlined,
            title: 'Push Notifications',
            subtitle: 'Instant transaction alerts enabled',
            badgeText: 'Active',
            onTap: () {
              ByToast.show(
                context,
                message: 'Push notification service operating normally',
                icon: Icons.notifications_active_rounded,
                backgroundColor: AppColors.info,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Platinum Privileges & Benefits Card
  Widget _buildPrivilegesCard() {
    final privileges = [
      'Zero FX conversion fees on international transfers',
      'Priority 24/7 dedicated concierge workspace support',
      'Unlimited free domestic ATM & QRIS cash withdrawals',
      'High-yield treasury vault bonus yield (+0.5% APY)',
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
                      Icons.workspace_premium_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Tier 1 Platinum Privileges',
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
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'VIP',
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
          const Divider(height: 1, color: AppColors.cardBorderSubtle),
          const SizedBox(height: 8),
          ...privileges.map((p) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p,
                      style: AppTextStyle.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// System Info & Specs Card
  Widget _buildSystemInfoCard() {
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
          const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'By_UI System Architecture',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.subheading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.cardBorderSubtle),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Library Release', style: AppTextStyle.caption),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'v${ByUI.version}',
                  style: AppTextStyle.badge.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Rendering Pipeline', style: AppTextStyle.caption),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Impeller / Skia Hardware Accelerate',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyBold.copyWith(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Architecture Spec', style: AppTextStyle.caption),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'ByUI Pulse Reactive v2.0',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyBold.copyWith(fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isCompact = mediaQuery.size.width < 360;

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
                // 1. Profile Hero Section
                if (widget.isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: _buildProfileHeaderCard(isCompact: false),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 6,
                        child: _buildDesktopProfileMetrics(),
                      ),
                    ],
                  )
                else
                  _buildProfileHeaderCard(isCompact: isCompact),

                const SizedBox(height: 20),

                // 2. Main Grid Layout on Desktop vs Stacked on Mobile
                if (widget.isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1: Security
                      Expanded(
                        child: _buildSecurityCard(),
                      ),
                      const SizedBox(width: 16),

                      // Column 2: Preferences
                      Expanded(
                        child: _buildPreferencesCard(),
                      ),
                      const SizedBox(width: 16),

                      // Column 3: Privileges & System Specs
                      Expanded(
                        child: Column(
                          children: [
                            _buildPrivilegesCard(),
                            const SizedBox(height: 16),
                            _buildSystemInfoCard(),
                            const SizedBox(height: 16),
                            // Logout Action Button
                            ByButton(
                              width: double.infinity,
                              size: ByButtonSize.medium,
                              variant: ByButtonVariant.outline,
                              borderColor: AppColors.error,
                              foregroundColor: AppColors.error,
                              borderRadius: BorderRadius.circular(12),
                              prefix: const Icon(
                                Icons.logout_rounded,
                                size: 16,
                                color: AppColors.error,
                              ),
                              onPressed: _showLogoutConfirmation,
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else ...[
                  // Mobile Stacked Layout
                  _buildSecurityCard(),
                  const SizedBox(height: 16),
                  _buildPreferencesCard(),
                  const SizedBox(height: 16),
                  _buildPrivilegesCard(),
                  const SizedBox(height: 16),
                  _buildSystemInfoCard(),
                  const SizedBox(height: 20),
                  ByButton(
                    width: double.infinity,
                    size: ByButtonSize.large,
                    variant: ByButtonVariant.outline,
                    borderColor: AppColors.error,
                    foregroundColor: AppColors.error,
                    borderRadius: BorderRadius.circular(14),
                    prefix: const Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                    onPressed: _showLogoutConfirmation,
                    child: const Text('Sign Out'),
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
