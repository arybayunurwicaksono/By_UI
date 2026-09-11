import 'dart:async';
import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../widgets/by_drawer.dart';
import 'dialog_showcase_screen.dart';
import '../models/toast_config_store.dart';

/// Interactive showcase screen for the ByToast component.
class ToastShowcaseScreen extends StatefulWidget {
  const ToastShowcaseScreen({super.key});

  @override
  State<ToastShowcaseScreen> createState() => _ToastShowcaseScreenState();
}

class _ToastShowcaseScreenState extends State<ToastShowcaseScreen> {
  // State configurations for ByToast
  ByToastPosition _position = ByToastPosition.top;
  ByToastSlideDirection _slideDirection = ByToastSlideDirection.fromTop;
  ByToastAnimationType _animationType = ByToastAnimationType.slideAndFade;

  int _selectedColorIndex = 0;
  bool _showCloseButton = true;
  bool _useOutlineBorder = false;
  bool _isMultiLine = false;

  // Left Icon (Prefix) selection: 0: None, 1: Bell, 2: Checkmark, 3: Info
  int _selectedLeftIconIndex = 1;

  // Right Action (Suffix) selection: 0: None, 1: Chevron Action, 2: Undo Button
  int _selectedRightActionIndex = 1;

  // Tap-to-Dialog Morphing configurations
  bool _enableTapToDialog = true;
  int _selectedDialogMode = 0; // 0: Default Text (Option 1), 1: Custom Receipt Widget (Option 2)

  final List<Map<String, dynamic>> _colorThemes = [
    {
      'name': 'Dark Slate (Solid)',
      'color': const Color(0xFF0F172A),
      'textColor': Colors.white,
      'gradient': null,
    },
    {
      'name': 'Mint Emerald (Solid)',
      'color': const Color(0xFF10B981),
      'textColor': Colors.white,
      'gradient': null,
    },
    {
      'name': 'Ruby Crimson (Solid)',
      'color': const Color(0xFFEF4444),
      'textColor': Colors.white,
      'gradient': null,
    },
    {
      'name': 'Royal Indigo (Solid)',
      'color': const Color(0xFF4F46E5),
      'textColor': Colors.white,
      'gradient': null,
    },
    {
      'name': 'Aurora Midnight (Gradient)',
      'color': const Color(0xFF1E1B4B),
      'textColor': Colors.white,
      'gradient': const LinearGradient(
        colors: [Color(0xFF312E81), Color(0xFF0F172A)],
      ),
    },
    {
      'name': 'Sunset Violet (Gradient)',
      'color': const Color(0xFF7C3AED),
      'textColor': Colors.white,
      'gradient': const LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
      ),
    },
  ];

  int _counter = 1;

  @override
  void initState() {
    super.initState();
    final store = ToastConfigStore.instance;
    _position = store.position;
    _slideDirection = store.slideDirection ??
        (_position == ByToastPosition.top
            ? ByToastSlideDirection.fromTop
            : ByToastSlideDirection.fromBottom);
    _animationType = store.animationType;
    _selectedColorIndex = store.selectedColorIndex;
    _showCloseButton = store.showCloseButton;
    _useOutlineBorder = store.useOutlineBorder;
    _isMultiLine = store.isMultiLine;
    _selectedLeftIconIndex = store.selectedLeftIconIndex;
    _selectedRightActionIndex = store.selectedRightActionIndex;
    _enableTapToDialog = store.enableTapToDialog;
    _selectedDialogMode = store.selectedDialogMode;
  }

  void _syncStore() {
    final store = ToastConfigStore.instance;
    store.position = _position;
    store.slideDirection = _slideDirection;
    store.animationType = _animationType;
    store.selectedColorIndex = _selectedColorIndex;
    store.showCloseButton = _showCloseButton;
    store.useOutlineBorder = _useOutlineBorder;
    store.isMultiLine = _isMultiLine;
    store.selectedLeftIconIndex = _selectedLeftIconIndex;
    store.selectedRightActionIndex = _selectedRightActionIndex;
    store.enableTapToDialog = _enableTapToDialog;
    store.selectedDialogMode = _selectedDialogMode;
  }

  void _triggerToast({String? customMessage}) {
    _syncStore();

    final theme = _colorThemes[_selectedColorIndex];
    final String message = customMessage ??
        (_isMultiLine
            ? 'Toast #$_counter: Cashier order processed successfully. Payment receipt sent to Bluetooth thermal printer and PDF invoice dispatched to customer email.'
            : 'Toast #$_counter: Cashier transaction saved successfully.');

    _counter++;

    // Resolve Left Icon (Prefix)
    IconData? leftIcon;
    VoidCallback? onLeftIconTap;

    switch (_selectedLeftIconIndex) {
      case 1:
        leftIcon = Icons.notifications_active_rounded;
        onLeftIconTap = () {
          ToastConfigStore.instance.showFeedback(
            context,
            message: 'Left icon tapped!',
            icon: Icons.notifications_active_rounded,
          );
        };
        break;
      case 2:
        leftIcon = Icons.check_circle_rounded;
        break;
      case 3:
        leftIcon = Icons.info_outline_rounded;
        break;
      case 0:
      default:
        leftIcon = null;
        break;
    }

    // Resolve Right Action (Suffix)
    IconData? suffixIcon;
    Widget? customSuffix;
    VoidCallback? onSuffixTap;

    if (_selectedRightActionIndex == 1) {
      suffixIcon = Icons.arrow_forward_ios_rounded;
      onSuffixTap = () {
        ToastConfigStore.instance.showFeedback(
          context,
          message: 'Chevron Right tapped: Opening details',
          icon: Icons.arrow_forward_ios_rounded,
        );
      };
    } else if (_selectedRightActionIndex == 2) {
      customSuffix = GestureDetector(
        onTap: () {
          ToastConfigStore.instance.showFeedback(
            context,
            message: 'UNDO action executed successfully!',
            icon: Icons.undo_rounded,
            customColor: const Color(0xFF10B981),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'UNDO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    // Resolve Dialog Details
    String? detailTitle;
    String? detailMessage;
    WidgetBuilder? detailBuilder;

    if (_enableTapToDialog) {
      if (_selectedDialogMode == 0) {
        // Option 1: Default Text Dialog
        detailTitle = 'Transaction Details #1042';
        detailMessage =
            '• Order ID: #TRX-2026-1042\n'
            '• Date/Time: 11 Sep 2026, 13:45 WIB\n'
            '• Cashier: Ary Bayu (POS Terminal 01)\n'
            '• Customer: Walk-in Guest (Table 04)\n\n'
            'Ordered Items:\n'
            ' 1. Robusta Latte (Hot, Double Shot) x2 — Rp 50.000\n'
            ' 2. Caramel Butter Croissant x1 — Rp 28.000\n'
            ' 3. Artisan Mineral Water x1 — Rp 10.000\n\n'
            'Pricing Breakdown:\n'
            ' • Subtotal: Rp 88.000\n'
            ' • Service Charge (5%): Rp 4.400\n'
            ' • PB1 Government Tax (10%): Rp 9.240\n'
            ' • Total Paid: Rp 101.640\n\n'
            'Payment Details:\n'
            ' • Method: QRIS Dynamic (ShopeePay/GoPay/BCA)\n'
            ' • RRN: 928371902834\n'
            ' • Settlement Status: SUCCESSFUL / VERIFIED\n\n'
            'Thank you for your visit!';
      } else {
        // Option 2: Custom Receipt Builder
        detailBuilder = (dialogContext) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFF6366F1),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Custom Receipt Widget',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Rendered via Option 2 (detailBuilder)',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Close Button ('X')
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: const Key('by_toast_dialog_close'),
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => ByToast.clear(),
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
                const SizedBox(height: 14),
                const Divider(color: Color(0xFF1E293B), height: 1),
                const SizedBox(height: 12),
                _buildDialogRow('Robusta Latte x2', 'Rp 50.000'),
                const SizedBox(height: 6),
                _buildDialogRow('Caramel Croissant x1', 'Rp 28.000'),
                const SizedBox(height: 6),
                _buildDialogRow('Mineral Water x1', 'Rp 10.000'),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFF1E293B), height: 1),
                const SizedBox(height: 10),
                _buildDialogRow('Total Paid', 'Rp 88.000', isHighlight: true),
              ],
            ),
          );
        };
      }
    }

    ByToast.show(
      context,
      message: message,
      icon: leftIcon,
      onIconTap: onLeftIconTap,
      backgroundColor: theme['color'] as Color,
      gradient: theme['gradient'] as Gradient?,
      textColor: theme['textColor'] as Color,
      position: _position,
      slideDirection: _slideDirection,
      animationType: _animationType,
      showCloseButton: _showCloseButton,
      suffixIcon: suffixIcon,
      suffix: customSuffix,
      onSuffixTap: onSuffixTap,
      border: _useOutlineBorder
          ? Border.all(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.8),
              width: 1.2,
            )
          : null,
      enterCurve: _animationType == ByToastAnimationType.bounce
          ? Curves.easeOutBack
          : Curves.easeOutCubic,
      enableTapToExpand: _enableTapToDialog,
      enableDragToExpand: _enableTapToDialog,
      detailTitle: detailTitle,
      detailMessage: detailMessage,
      detailBuilder: detailBuilder,
    );
  }

  Widget _buildDialogRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isHighlight ? const Color(0xFF38BDF8) : const Color(0xFFCBD5E1),
            fontSize: isHighlight ? 14 : 13,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? const Color(0xFF38BDF8) : Colors.white,
            fontSize: isHighlight ? 14 : 13,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _triggerRapidFireStack() {
    for (int i = 0; i < 3; i++) {
      Timer(Duration(milliseconds: i * 240), () {
        if (mounted) {
          _triggerToast(
            customMessage: 'Stack Item #${i + 1}: Toast in queue ${i + 1}',
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        key: ByToast.appBarKey,
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
                'ByToast',
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
        actions: [
          IconButton(
            tooltip: 'Clear active toasts',
            icon: const Icon(Icons.delete_sweep_rounded, color: Color(0xFFEF4444)),
            onPressed: ByToast.clear,
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: ByDrawer(
        activeComponent: 'ByToast',
        onSelectComponent: (comp) {
          if (comp == 'ByDialog') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const DialogShowcaseScreen(),
              ),
            );
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Quick Preset Bar
          _buildPresetPills(),

          const SizedBox(height: 18),

          // Visual Hint for Tap-to-Dialog feature
          if (_enableTapToDialog)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: Color(0xFFA5B4FC),
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '💡 How to try: Simply tap on the toast text to open the detail dialog!',
                      style: TextStyle(
                        color: Color(0xFFE0E7FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Main Controls Section 1: Position & Slide Direction
          _buildControlCard(
            title: '1. SCREEN ANCHOR & SLIDE DIRECTION',
            icon: Icons.open_with_rounded,
            children: [
              const Text(
                'Screen Anchor Position:',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Top (Glides Downward)',
                      isSelected: _position == ByToastPosition.top,
                      onTap: () {
                        setState(() {
                          _position = ByToastPosition.top;
                          _slideDirection = ByToastSlideDirection.fromTop;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Bottom (Glides Upward)',
                      isSelected: _position == ByToastPosition.bottom,
                      onTap: () {
                        setState(() {
                          _position = ByToastPosition.bottom;
                          _slideDirection = ByToastSlideDirection.fromBottom;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Entrance Slide Direction:',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSmallChip('From Top', ByToastSlideDirection.fromTop),
                  _buildSmallChip('From Bottom', ByToastSlideDirection.fromBottom),
                  _buildSmallChip('From Left', ByToastSlideDirection.fromLeft),
                  _buildSmallChip('From Right', ByToastSlideDirection.fromRight),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Section 2: Animation Style & Curves
          _buildControlCard(
            title: '2. ANIMATION STYLE & CURVES',
            icon: Icons.animation_rounded,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildAnimChip('Slide & Fade', ByToastAnimationType.slideAndFade),
                  _buildAnimChip('Bounce / Spring', ByToastAnimationType.bounce),
                  _buildAnimChip('Scale & Fade', ByToastAnimationType.scaleAndFade),
                  _buildAnimChip('Slide Only', ByToastAnimationType.slideOnly),
                  _buildAnimChip('Fade Only', ByToastAnimationType.fadeOnly),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Section 3: Icons & Close Button
          _buildControlCard(
            title: '3. ICONS (LEFT & RIGHT) & CLOSE BUTTON',
            icon: Icons.smart_button_rounded,
            children: [
              // Left Icon (Prefix)
              const Text(
                'Left Icon (Prefix):',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'None',
                      isSelected: _selectedLeftIconIndex == 0,
                      onTap: () => setState(() => _selectedLeftIconIndex = 0),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Bell Icon',
                      isSelected: _selectedLeftIconIndex == 1,
                      onTap: () => setState(() => _selectedLeftIconIndex = 1),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Checkmark',
                      isSelected: _selectedLeftIconIndex == 2,
                      onTap: () => setState(() => _selectedLeftIconIndex = 2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Info Icon',
                      isSelected: _selectedLeftIconIndex == 3,
                      onTap: () => setState(() => _selectedLeftIconIndex = 3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Right Action (Suffix)
              const Text(
                'Right Action (Suffix):',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'None',
                      isSelected: _selectedRightActionIndex == 0,
                      onTap: () => setState(() => _selectedRightActionIndex = 0),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Chevron Right',
                      isSelected: _selectedRightActionIndex == 1,
                      onTap: () => setState(() => _selectedRightActionIndex = 1),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Undo Button',
                      isSelected: _selectedRightActionIndex == 2,
                      onTap: () => setState(() => _selectedRightActionIndex = 2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Close Button Toggle
              Material(
                color: Colors.transparent,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF6366F1),
                  title: const Text(
                    'Show Close Button (\'X\')',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Can be toggled active or inactive independently',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                  value: _showCloseButton,
                  onChanged: (val) => setState(() => _showCloseButton = val),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Section 4: Tap & Drag-to-Dialog Morphing Feature
          _buildControlCard(
            title: '4. EXPAND TO DIALOG (TAP & DRAG)',
            icon: Icons.open_in_new_rounded,
            children: [
              Material(
                color: Colors.transparent,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF6366F1),
                  title: const Text(
                    'Enable Expand to Dialog (Tap & Drag)',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Tap message text or drag toast towards screen center to morph into dialog',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                  value: _enableTapToDialog,
                  onChanged: (val) => setState(() => _enableTapToDialog = val),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                child: _enableTapToDialog
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          const Text(
                            'Dialog Content Mode:',
                            style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildChoiceChip(
                                  label: 'Option 1: Default Text',
                                  isSelected: _selectedDialogMode == 0,
                                  onTap: () => setState(() => _selectedDialogMode = 0),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildChoiceChip(
                                  label: 'Option 2: Custom Receipt',
                                  isSelected: _selectedDialogMode == 1,
                                  onTap: () => setState(() => _selectedDialogMode = 1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Section 5: Coloring & Themes
          _buildControlCard(
            title: '5. COLORING (SOLID COLOR & GRADIENT)',
            icon: Icons.palette_rounded,
            children: [
              for (int i = 0; i < _colorThemes.length; i++) ...[
                GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedColorIndex == i
                          ? const Color(0xFF6366F1).withValues(alpha: 0.18)
                          : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _selectedColorIndex == i
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF334155),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _colorThemes[i]['gradient'] == null
                                ? _colorThemes[i]['color'] as Color
                                : null,
                            gradient: _colorThemes[i]['gradient'] as Gradient?,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _colorThemes[i]['name'] as String,
                          style: TextStyle(
                            color: _selectedColorIndex == i
                                ? Colors.white
                                : const Color(0xFFCBD5E1),
                            fontSize: 13,
                            fontWeight: _selectedColorIndex == i
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _buildToggleChip(
                      label: 'Subtle Outline Border',
                      isSelected: _useOutlineBorder,
                      onChanged: (val) => setState(() => _useOutlineBorder = val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildToggleChip(
                      label: 'Multi-line (Test Height)',
                      isSelected: _isMultiLine,
                      onChanged: (val) => setState(() => _isMultiLine = val),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Fixed Bottom Navigation Bar for Triggers
      bottomNavigationBar: Container(
        key: ByToast.bottomBarKey,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          border: Border(
            top: BorderSide(color: Color(0xFF1E293B), width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
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
                    'Trigger',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  onPressed: () => _triggerToast(),
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
                  icon: const Icon(Icons.bolt_rounded, size: 18),
                  label: const Text(
                    'Stack x3',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  onPressed: _triggerRapidFireStack,
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
                ByToast.showSuccess(
                  context,
                  message: 'Transaction completed successfully!',
                  position: _position,
                  slideDirection: _slideDirection,
                  detailTitle: 'Transaction #1042 Completed',
                  detailMessage: 'Payment verified via QRIS. Thermal receipt ready to print.',
                  enableTapToExpand: _enableTapToDialog,
                );
              }),
              const SizedBox(width: 6),
              _buildPresetBtn('Error', const Color(0xFFEF4444), () {
                ByToast.showError(
                  context,
                  message: 'Thermal printer connection timed out.',
                  position: _position,
                  slideDirection: _slideDirection,
                  detailTitle: 'Hardware Connection Error',
                  detailMessage:
                      'The system could not communicate with Bluetooth printer POS-PRT-02. Please ensure the printer is turned on and paired.',
                  enableTapToExpand: _enableTapToDialog,
                );
              }),
              const SizedBox(width: 6),
              _buildPresetBtn('Warning', const Color(0xFFF59E0B), () {
                ByToast.showWarning(
                  context,
                  message: 'Robusta coffee bean stock is low.',
                  position: _position,
                  slideDirection: _slideDirection,
                  detailTitle: 'Low Stock Alert',
                  detailMessage:
                      'Robusta Medium Roast Beans is below the reorder threshold (remaining: 3 portions). Please contact supplier.',
                  enableTapToExpand: _enableTapToDialog,
                );
              }),
              const SizedBox(width: 6),
              _buildPresetBtn('Info', const Color(0xFF3B82F6), () {
                ByToast.showInfo(
                  context,
                  message: 'Cloud data synchronization in progress.',
                  position: _position,
                  slideDirection: _slideDirection,
                  detailTitle: 'Background Sync Status',
                  detailMessage:
                      'Syncing 14 local transactions and 2 inventory logs with cloud server api.azuba.tech.',
                  enableTapToExpand: _enableTapToDialog,
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

  Widget _buildControlCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withValues(alpha: 0.2)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF334155),
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withValues(alpha: 0.25)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF334155),
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSmallChip(String label, ByToastSlideDirection direction) {
    final bool isSelected = _slideDirection == direction;
    return ChoiceChip(
      showCheckmark: false,
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF6366F1).withValues(alpha: 0.25),
      backgroundColor: const Color(0xFF1E293B),
      side: BorderSide(
        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF334155),
        width: 1.2,
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF94A3B8),
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      onSelected: (_) => setState(() => _slideDirection = direction),
    );
  }

  Widget _buildAnimChip(String label, ByToastAnimationType type) {
    final bool isSelected = _animationType == type;
    return ChoiceChip(
      showCheckmark: false,
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF6366F1).withValues(alpha: 0.25),
      backgroundColor: const Color(0xFF1E293B),
      side: BorderSide(
        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF334155),
        width: 1.2,
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF94A3B8),
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      onSelected: (_) => setState(() => _animationType = type),
    );
  }
}
