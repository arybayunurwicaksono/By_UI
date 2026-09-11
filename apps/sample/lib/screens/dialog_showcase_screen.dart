import 'dart:math';
import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/toast_config_store.dart';
import '../widgets/by_drawer.dart';
import 'toast_showcase_screen.dart';

/// Highly customizable interactive showcase screen for ByDialog components.
/// Features live controls matching ByToast: Theme colors, gradients, borders,
/// radius, custom icons, animation curves, durations, and dismissible behavior.
class DialogShowcaseScreen extends StatefulWidget {
  const DialogShowcaseScreen({super.key});

  @override
  State<DialogShowcaseScreen> createState() => _DialogShowcaseScreenState();
}

class _DialogShowcaseScreenState extends State<DialogShowcaseScreen> {
  // Dialog Type: 0: Alert (Single Action), 1: Confirm (Two Actions), 2: Custom Receipt
  int _selectedDialogType = 0;

  // Theme & Surface Customization
  int _selectedThemeIndex = 0;
  bool _useGradient = false;
  bool _useOutlineBorder = true;
  double _selectedCornerRadius = 22.0;

  // Icon Selection: 0: None, 1: Info, 2: Checkmark, 3: Warning, 4: Help, 5: Shield, 6: Receipt, 7: Flame
  int _selectedIconIndex = 1;

  // Animation & Behavior
  Curve _selectedCurve = Curves.easeOutCubic;
  Duration _selectedDuration = const Duration(milliseconds: 320);
  bool _barrierDismissible = true;

  // Available Theme Colors
  final List<Map<String, dynamic>> _themePresets = [
    {
      'name': 'Indigo Modern',
      'color': const Color(0xFF0F172A),
      'accent': const Color(0xFF6366F1),
      'gradient': const LinearGradient(
        colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'name': 'Emerald Success',
      'color': const Color(0xFF064E3B),
      'accent': const Color(0xFF10B981),
      'gradient': const LinearGradient(
        colors: [Color(0xFF064E3B), Color(0xFF022C22)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'name': 'Crimson Danger',
      'color': const Color(0xFF7F1D1D),
      'accent': const Color(0xFFEF4444),
      'gradient': const LinearGradient(
        colors: [Color(0xFF7F1D1D), Color(0xFF450A0A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'name': 'Amber Warning',
      'color': const Color(0xFF78350F),
      'accent': const Color(0xFFF59E0B),
      'gradient': const LinearGradient(
        colors: [Color(0xFF78350F), Color(0xFF451A03)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'name': 'Sky Minimalist',
      'color': const Color(0xFF0C4A6E),
      'accent': const Color(0xFF0EA5E9),
      'gradient': const LinearGradient(
        colors: [Color(0xFF0C4A6E), Color(0xFF082F49)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'name': 'Purple Violet',
      'color': const Color(0xFF3B0764),
      'accent': const Color(0xFF8B5CF6),
      'gradient': const LinearGradient(
        colors: [Color(0xFF3B0764), Color(0xFF1E0A3C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  // Available Icons
  final List<Map<String, dynamic>> _iconPresets = [
    {'name': 'None', 'icon': null},
    {'name': 'Info', 'icon': Icons.info_outline_rounded},
    {'name': 'Success', 'icon': Icons.check_circle_outline_rounded},
    {'name': 'Warning', 'icon': Icons.warning_amber_rounded},
    {'name': 'Help', 'icon': Icons.help_outline_rounded},
    {'name': 'Shield', 'icon': Icons.verified_user_outlined},
    {'name': 'Receipt', 'icon': Icons.receipt_long_rounded},
    {'name': 'Flame', 'icon': Icons.local_fire_department_outlined},
  ];

  void _triggerDialog() {
    final theme = _themePresets[_selectedThemeIndex];
    final Color bgColor = theme['color'] as Color;
    final Color accentColor = theme['accent'] as Color;
    final Gradient? gradient = _useGradient ? theme['gradient'] as Gradient : null;
    final IconData? icon = _iconPresets[_selectedIconIndex]['icon'] as IconData?;
    final BorderRadius radius = BorderRadius.circular(_selectedCornerRadius);

    final Border? border = _useOutlineBorder
        ? Border.all(color: accentColor.withValues(alpha: 0.8), width: 1.2)
        : null;

    if (_selectedDialogType == 0) {
      // Alert Dialog
      ByDialog.alert(
        context,
        title: 'System Health Check',
        message:
            'All background microservices and cloud synchronization endpoints are operating with optimal latency.',
        icon: icon,
        iconColor: accentColor,
        buttonColor: accentColor,
        buttonText: 'Got It',
        backgroundColor: bgColor,
        gradient: gradient,
        borderRadius: radius,
        border: border,
        barrierDismissible: _barrierDismissible,
        transitionDuration: _selectedDuration,
        enterCurve: _selectedCurve,
        onConfirm: () {
          ToastConfigStore.instance.showFeedback(
            context,
            message: 'Alert acknowledged.',
            icon: Icons.check_circle_rounded,
          );
        },
      );
    } else if (_selectedDialogType == 1) {
      // Confirm Dialog
      ByDialog.confirm(
        context,
        title: 'Void Transaction #1042?',
        message:
            'This action will reverse the transaction and update the inventory ledger accordingly. Do you wish to continue?',
        icon: icon ?? Icons.help_outline_rounded,
        iconColor: accentColor,
        confirmColor: accentColor,
        confirmText: 'Void Transaction',
        cancelText: 'Keep Transaction',
        backgroundColor: bgColor,
        gradient: gradient,
        borderRadius: radius,
        border: border,
        barrierDismissible: _barrierDismissible,
        transitionDuration: _selectedDuration,
        enterCurve: _selectedCurve,
      ).then((confirmed) {
        if (mounted) {
          ToastConfigStore.instance.showFeedback(
            context,
            message: confirmed
                ? 'Transaction #1042 was voided.'
                : 'Action canceled by user.',
            icon: confirmed
                ? Icons.delete_forever_rounded
                : Icons.close_rounded,
          );
        }
      });
    } else {
      // Custom Receipt Dialog
      ByDialog.show(
        context,
        barrierDismissible: _barrierDismissible,
        transitionDuration: _selectedDuration,
        enterCurve: _selectedCurve,
        builder: (ctx) {
          final screenSize = MediaQuery.of(ctx).size;
          final double cardWidth = min(screenSize.width - 40.0, 380.0);

          return Container(
            width: cardWidth,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: gradient == null ? bgColor : null,
              gradient: gradient,
              borderRadius: radius,
              border: border ??
                  Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1.2,
                  ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 32,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon ?? Icons.receipt_long_rounded,
                        color: accentColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cashier Receipt #1042',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Payment: QRIS Dynamic',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.of(ctx, rootNavigator: true).pop(),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF1E293B), height: 1),
                const SizedBox(height: 14),
                _buildReceiptRow('Robusta Latte x2', 'Rp 50.000'),
                const SizedBox(height: 8),
                _buildReceiptRow('Caramel Croissant x1', 'Rp 28.000'),
                const SizedBox(height: 8),
                _buildReceiptRow('Mineral Water x1', 'Rp 10.000'),
                const SizedBox(height: 14),
                const Divider(color: Color(0xFF1E293B), height: 1),
                const SizedBox(height: 14),
                _buildReceiptRow('Subtotal', 'Rp 88.000', isBold: true),
                const SizedBox(height: 6),
                _buildReceiptRow('Tax (11%)', 'Rp 9.680'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Rp 97.680',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.print_rounded, size: 18),
                    label: const Text(
                      'Print Thermal Receipt',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      Navigator.of(ctx, rootNavigator: true).pop();
                      ToastConfigStore.instance.showFeedback(
                        context,
                        message: 'Printing thermal receipt...',
                        icon: Icons.print_rounded,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildReceiptRow(String item, String price, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item,
          style: TextStyle(
            color: isBold ? Colors.white : const Color(0xFFCBD5E1),
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            color: isBold ? Colors.white : const Color(0xFF94A3B8),
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'ByDialog',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Showcase',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      drawer: ByDrawer(
        activeComponent: 'ByDialog',
        onSelectComponent: (comp) {
          if (comp == 'ByToast') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ToastShowcaseScreen(),
              ),
            );
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Quick Preset Bar (1-Click Test)
          _buildPresetPills(),

          const SizedBox(height: 18),

          // Integrated Feature Hint
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF6366F1).withValues(alpha: 0.35),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFA5B4FC),
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Integrated with ByToast',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'ByDialog can also be opened seamlessly by tapping the text of a ByToast notification card!',
                        style: TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Live Configuration Summary Card
          _buildConfigSummaryCard(),

          const SizedBox(height: 18),

          // Control Section 1: Dialog Type
          _buildControlCard(
            title: '1. DIALOG TYPE & LAYOUT MODE',
            icon: Icons.dashboard_customize_rounded,
            children: [
              const Text(
                'Select Dialog Template:',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Alert (Single)',
                      isSelected: _selectedDialogType == 0,
                      onTap: () => setState(() => _selectedDialogType = 0),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Confirm (Dual)',
                      isSelected: _selectedDialogType == 1,
                      onTap: () => setState(() => _selectedDialogType = 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Custom Receipt',
                      isSelected: _selectedDialogType == 2,
                      onTap: () => setState(() => _selectedDialogType = 2),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Control Section 2: Color Theme & Appearance
          _buildControlCard(
            title: '2. COLOR THEME & SURFACE STYLING',
            icon: Icons.palette_rounded,
            children: [
              const Text(
                'Preset Color Palette:',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  _themePresets.length,
                  (index) => _buildThemeColorChip(index, _themePresets[index]),
                ),
              ),
              const SizedBox(height: 16),
              Material(
                color: Colors.transparent,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF6366F1),
                  title: const Text(
                    'Gradient Surface Background',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Switches from deep solid color to rich multi-hue linear gradient',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                  value: _useGradient,
                  onChanged: (val) => setState(() => _useGradient = val),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF6366F1),
                  title: const Text(
                    'Outline Glow Border',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Adds a subtle high-contrast border matching the accent color',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                  value: _useOutlineBorder,
                  onChanged: (val) => setState(() => _useOutlineBorder = val),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Corner Radius:',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: '16px (Subtle)',
                      isSelected: _selectedCornerRadius == 16.0,
                      onTap: () => setState(() => _selectedCornerRadius = 16.0),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      label: '22px (Standard)',
                      isSelected: _selectedCornerRadius == 22.0,
                      onTap: () => setState(() => _selectedCornerRadius = 22.0),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      label: '28px (Soft)',
                      isSelected: _selectedCornerRadius == 28.0,
                      onTap: () => setState(() => _selectedCornerRadius = 28.0),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Control Section 3: Icon & Badge
          _buildControlCard(
            title: '3. HEADER ICON & ACCENT BADGE',
            icon: Icons.star_border_rounded,
            children: [
              const Text(
                'Select Header Icon:',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_iconPresets.length, (index) {
                  final item = _iconPresets[index];
                  final bool isSelected = _selectedIconIndex == index;
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setState(() => _selectedIconIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF818CF8)
                              : const Color(0xFF334155),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item['icon'] != null) ...[
                            Icon(
                              item['icon'] as IconData,
                              size: 15,
                              color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            item['name'] as String,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Control Section 4: Animation & Behavior
          _buildControlCard(
            title: '4. ANIMATION & INTERACTION BEHAVIOR',
            icon: Icons.motion_photos_on_rounded,
            children: [
              const Text(
                'Entrance Animation Curve:',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Cubic (Smooth)',
                      isSelected: _selectedCurve == Curves.easeOutCubic,
                      onTap: () => setState(() => _selectedCurve = Curves.easeOutCubic),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Back (Bouncy)',
                      isSelected: _selectedCurve == Curves.easeOutBack,
                      onTap: () => setState(() => _selectedCurve = Curves.easeOutBack),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Linear',
                      isSelected: _selectedCurve == Curves.linear,
                      onTap: () => setState(() => _selectedCurve = Curves.linear),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Transition Duration:',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Fast (200ms)',
                      isSelected: _selectedDuration.inMilliseconds == 200,
                      onTap: () => setState(() => _selectedDuration = const Duration(milliseconds: 200)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Normal (320ms)',
                      isSelected: _selectedDuration.inMilliseconds == 320,
                      onTap: () => setState(() => _selectedDuration = const Duration(milliseconds: 320)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Slow (550ms)',
                      isSelected: _selectedDuration.inMilliseconds == 550,
                      onTap: () => setState(() => _selectedDuration = const Duration(milliseconds: 550)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Material(
                color: Colors.transparent,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF6366F1),
                  title: const Text(
                    'Barrier Dismissible',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Allows closing the dialog by clicking on the dark backdrop scrim',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                  value: _barrierDismissible,
                  onChanged: (val) => setState(() => _barrierDismissible = val),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          border: const Border(top: BorderSide(color: Color(0xFF1E293B))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 20),
                  label: const Text(
                    'Trigger Dialog',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  onPressed: _triggerDialog,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF38BDF8),
                    side: const BorderSide(color: Color(0xFF38BDF8), width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.help_outline_rounded, size: 18),
                  label: const Text(
                    'Confirm Flow',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  onPressed: () {
                    setState(() => _selectedDialogType = 1);
                    _triggerDialog();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetPills() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QUICK PRESETS (1-CLICK TEST)',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildPresetBtn('Success', const Color(0xFF10B981), () {
                ByDialog.success(
                  context,
                  title: 'Transaction Successful',
                  message: 'Payment #1042 was settled via QRIS Dynamic.',
                );
              }),
              const SizedBox(width: 6),
              _buildPresetBtn('Error', const Color(0xFFEF4444), () {
                ByDialog.error(
                  context,
                  title: 'Printer Connection Failed',
                  message: 'Unable to pair with Bluetooth printer POS-PRT-02.',
                );
              }),
              const SizedBox(width: 6),
              _buildPresetBtn('Warning', const Color(0xFFF59E0B), () {
                ByDialog.warning(
                  context,
                  title: 'Inventory Threshold Alert',
                  message: 'Robusta medium beans is down to 3 portions.',
                );
              }),
              const SizedBox(width: 6),
              _buildPresetBtn('Info', const Color(0xFF3B82F6), () {
                ByDialog.info(
                  context,
                  title: 'Cloud Sync in Progress',
                  message: 'Syncing 14 local transactions to cloud server.',
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetBtn(String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfigSummaryCard() {
    final theme = _themePresets[_selectedThemeIndex];
    final typeName = _selectedDialogType == 0
        ? 'Alert Modal'
        : _selectedDialogType == 1
            ? 'Confirm Modal'
            : 'Custom Receipt';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (theme['accent'] as Color).withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ACTIVE CONFIGURATION PREVIEW',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (theme['accent'] as Color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  typeName,
                  style: TextStyle(
                    color: theme['accent'] as Color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Theme Palette', theme['name'] as String),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Surface Type',
            _useGradient ? 'Linear Gradient Surface' : 'Solid Deep Surface',
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Border & Radius',
            '${_selectedCornerRadius.toInt()}px ${_useOutlineBorder ? '+ Accent Glow Border' : ''}',
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Animation',
            '${_selectedCurve.runtimeType} (${_selectedDuration.inMilliseconds}ms)',
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Dismissible',
            _barrierDismissible ? 'Yes (Backdrop Tap)' : 'No (Modal Locked)',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildControlCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: const Color(0xFF6366F1)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFF818CF8) : const Color(0xFF334155),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeColorChip(int index, Map<String, dynamic> theme) {
    final bool isSelected = _selectedThemeIndex == index;
    final Color accent = theme['accent'] as Color;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => setState(() => _selectedThemeIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? accent.withValues(alpha: 0.2) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? accent : const Color(0xFF334155),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              theme['name'] as String,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
