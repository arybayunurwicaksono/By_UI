import 'package:flutter/material.dart';

/// Modern and aesthetic navigation drawer showcasing ByUI components.
class ByDrawer extends StatelessWidget {
  final String activeComponent;
  final ValueChanged<String>? onSelectComponent;

  const ByDrawer({
    super.key,
    this.activeComponent = 'ByToast',
    this.onSelectComponent,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0B0F19),
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header with ByUI Brand Styling
            _buildDrawerHeader(),

            const SizedBox(height: 12),
            const Divider(color: Color(0xFF1E293B), height: 1),

            // Drawer Content List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                children: [
                  // Active Components Section
                  _buildSectionHeader('AVAILABLE COMPONENTS (2)'),
                  const SizedBox(height: 8),

                  _buildDrawerItem(
                    title: 'ByToast',
                    subtitle: 'Stacked toast & banner overlay',
                    icon: Icons.notifications_active_rounded,
                    isActive: activeComponent == 'ByToast',
                    badgeText: 'READY',
                    badgeColor: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.pop(context);
                      onSelectComponent?.call('ByToast');
                    },
                  ),
                  const SizedBox(height: 6),

                  _buildDrawerItem(
                    title: 'ByDialog',
                    subtitle: 'Modal alerts, confirms & dialogs',
                    icon: Icons.chat_bubble_outline_rounded,
                    isActive: activeComponent == 'ByDialog',
                    badgeText: 'READY',
                    badgeColor: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.pop(context);
                      onSelectComponent?.call('ByDialog');
                    },
                  ),

                  const SizedBox(height: 24),

                  // Upcoming Components Roadmap Section
                  _buildSectionHeader('ROADMAP COMPONENTS'),
                  const SizedBox(height: 8),

                  _buildDrawerItem(
                    title: 'ByButton',
                    subtitle: 'Haptic & fluid press states',
                    icon: Icons.smart_button_rounded,
                    isActive: false,
                    isUpcoming: true,
                    badgeText: 'SOON',
                    badgeColor: const Color(0xFF64748B),
                  ),
                  const SizedBox(height: 6),
                  _buildDrawerItem(
                    title: 'ByCard',
                    subtitle: 'Bento & glassmorphic surfaces',
                    icon: Icons.dashboard_customize_rounded,
                    isActive: false,
                    isUpcoming: true,
                    badgeText: 'SOON',
                    badgeColor: const Color(0xFF64748B),
                  ),
                  const SizedBox(height: 6),
                  _buildDrawerItem(
                    title: 'ByBottomSheet',
                    subtitle: 'Draggable spring bottom sheet',
                    icon: Icons.vertical_align_bottom_rounded,
                    isActive: false,
                    isUpcoming: true,
                    badgeText: 'SOON',
                    badgeColor: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),

            // Drawer Footer
            _buildDrawerFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1B4B),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Stylized Brand Monogram
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'BY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 1.2,
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
                        const Text(
                          'ByUI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'v0.1.0',
                            style: TextStyle(
                              color: Color(0xFFA5B4FC),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Core Component Library',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hub_rounded, size: 13, color: Color(0xFF38BDF8)),
                SizedBox(width: 6),
                Text(
                  'Monorepo: packages/core',
                  style: TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    bool isUpcoming = false,
    required String badgeText,
    required Color badgeColor,
    VoidCallback? onTap,
  }) {
    final activeBg = const Color(0xFF6366F1).withValues(alpha: 0.15);
    final activeBorder = const Color(0xFF6366F1).withValues(alpha: 0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isUpcoming ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? activeBorder : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF6366F1).withValues(alpha: 0.25)
                      : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isActive
                      ? const Color(0xFFA5B4FC)
                      : (isUpcoming
                          ? const Color(0xFF475569)
                          : const Color(0xFF94A3B8)),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isUpcoming
                            ? const Color(0xFF64748B)
                            : (isActive ? Colors.white : const Color(0xFFE2E8F0)),
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isUpcoming
                            ? const Color(0xFF475569)
                            : const Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: badgeColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Sample App • Ready to test',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            'ByUI',
            style: TextStyle(
              color: Color(0xFF6366F1),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
