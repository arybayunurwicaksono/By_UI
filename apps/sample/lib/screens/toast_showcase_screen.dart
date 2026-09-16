import 'dart:async';
import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_theme_store.dart';
import '../models/toast_config_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_drawer.dart';
import '../widgets/widget_params_dialog.dart';
import 'dialog_showcase_screen.dart';
import 'card_showcase_screen.dart';

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
  double _backgroundOpacity = 1.0;
  bool _showCloseButton = true;
  bool _useOutlineBorder = false;
  bool _isMultiLine = false;

  // Text Truncation & Overflow
  int? _maxLines = 3;
  TextOverflow _overflow = TextOverflow.ellipsis;

  // Left Icon (Prefix) selection: 0: None, 1: Bell, 2: Checkmark, 3: Info
  int _selectedLeftIconIndex = 1;

  // Right Action (Suffix) selection: 0: None, 1: Chevron Action, 2: Undo Button
  int _selectedRightActionIndex = 1;

  // Tap-to-Dialog Morphing configurations
  bool _enableTapToDialog = true;
  int _selectedDialogMode =
      0; // 0: Default Text (Option 1), 1: Custom Receipt Widget (Option 2)

  final List<ShowcaseThemePreset> _colorThemes = AppColors.toastThemePresets;

  int _counter = 1;

  bool get isDark => AppThemeStore.instance.isDarkMode(context);
  AppColorPalette get colors => AppColors.of(context);
  Color get labelTextColor => colors.textSecondary;

  @override
  void initState() {
    super.initState();
    final store = ToastConfigStore.instance;
    _position = store.position;
    _slideDirection =
        store.slideDirection ??
        (_position.isLeft
            ? ByToastSlideDirection.fromLeft
            : (_position.isRight
                  ? ByToastSlideDirection.fromRight
                  : (_position.isTop
                        ? ByToastSlideDirection.fromTop
                        : ByToastSlideDirection.fromBottom)));
    _animationType = store.animationType;
    _selectedColorIndex = store.selectedColorIndex;
    _backgroundOpacity = store.backgroundOpacity;
    _showCloseButton = store.showCloseButton;
    _useOutlineBorder = store.useOutlineBorder;
    _isMultiLine = store.isMultiLine;
    _maxLines = store.maxLines;
    _overflow = store.overflow;
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
    store.backgroundOpacity = _backgroundOpacity;
    store.showCloseButton = _showCloseButton;
    store.useOutlineBorder = _useOutlineBorder;
    store.isMultiLine = _isMultiLine;
    store.maxLines = _maxLines;
    store.overflow = _overflow;
    store.selectedLeftIconIndex = _selectedLeftIconIndex;
    store.selectedRightActionIndex = _selectedRightActionIndex;
    store.enableTapToDialog = _enableTapToDialog;
    store.selectedDialogMode = _selectedDialogMode;
  }

  void _triggerToast({String? customMessage}) {
    _syncStore();

    final theme = _colorThemes[_selectedColorIndex];
    final String message =
        customMessage ??
        (_isMultiLine
            ? 'Toast #$_counter: Cashier order processed successfully. Payment receipt sent to Bluetooth thermal printer POS-01 and PDF invoice dispatched to customer email. Accounting ledger and local database synchronized with cloud backend.'
            : 'Toast #$_counter: Cashier transaction saved successfully.');

    _counter++;

    // Resolve Left Icon (Prefix)
    IconData? leftIcon;
    VoidCallback? onLeftIconTap;

    switch (_selectedLeftIconIndex) {
      case 1:
        leftIcon = AppIcons.notification;
        onLeftIconTap = () {
          ToastConfigStore.instance.showFeedback(
            context,
            message: 'Left icon tapped!',
            icon: AppIcons.notification,
          );
        };
        break;
      case 2:
        leftIcon = AppIcons.successFilled;
        break;
      case 3:
        leftIcon = AppIcons.info;
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
      suffixIcon = AppIcons.arrowForward;
      onSuffixTap = () {
        ToastConfigStore.instance.showFeedback(
          context,
          message: 'Chevron Right tapped: Opening details',
          icon: AppIcons.arrowForward,
        );
      };
    } else if (_selectedRightActionIndex == 2) {
      customSuffix = GestureDetector(
        onTap: () {
          ToastConfigStore.instance.showFeedback(
            context,
            message: 'UNDO action executed successfully!',
            icon: AppIcons.undo,
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
                        AppIcons.receipt,
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
                            AppIcons.close,
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
      backgroundOpacity: _backgroundOpacity,
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
      maxLines: _maxLines,
      overflow: _overflow,
      enableTapToExpand: _enableTapToDialog,
      enableDragToExpand: _enableTapToDialog,
      detailTitle: detailTitle,
      detailMessage: detailMessage,
      detailBuilder: detailBuilder,
    );
  }

  Widget _buildDialogRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              (isHighlight
                      ? AppTextStyle.specHighlight
                      : AppTextStyle.specLabel)
                  .copyWith(
                    color: isHighlight
                        ? AppColors.primaryAccent
                        : const Color(0xFFCBD5E1),
                  ),
        ),
        Text(
          value,
          style:
              (isHighlight
                      ? AppTextStyle.specHighlight
                      : AppTextStyle.specValue)
                  .copyWith(
                    color: isHighlight ? AppColors.primaryAccent : Colors.white,
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

  void _resetToDefaults() {
    setState(() {
      _position = ByToastPosition.top;
      _slideDirection = ByToastSlideDirection.fromTop;
      _animationType = ByToastAnimationType.slideAndFade;
      _selectedColorIndex = 0;
      _backgroundOpacity = 1.0;
      _showCloseButton = true;
      _useOutlineBorder = false;
      _isMultiLine = false;
      _maxLines = 3;
      _overflow = TextOverflow.ellipsis;
      _selectedLeftIconIndex = 1;
      _selectedRightActionIndex = 1;
      _enableTapToDialog = true;
      _selectedDialogMode = 0;
    });
    ByToast.clear();
  }

  void _showByToastParams(BuildContext context) {
    showWidgetParametersDialog(
      context,
      parameters: const [
        WidgetParamInfo(
          name: 'message',
          type: 'String',
          description: 'Primary text message displayed inside the toast card.',
          isRequired: true,
        ),
        WidgetParamInfo(
          name: 'title',
          type: 'String?',
          description: 'Optional bold header text displayed above the message.',
        ),
        WidgetParamInfo(
          name: 'position',
          type: 'ByToastPosition',
          description:
              'Screen anchor position for toast placement (top, bottom, topLeft, topRight, bottomLeft, bottomRight).',
          defaultValue: 'ByToastPosition.top',
        ),
        WidgetParamInfo(
          name: 'slideDirection',
          type: 'ByToastSlideDirection?',
          description:
              'Direction of the entrance slide transition (fromTop, fromBottom, fromLeft, fromRight).',
        ),
        WidgetParamInfo(
          name: 'animationType',
          type: 'ByToastAnimationType',
          description:
              'Visual transition animation style (slideAndFade, fadeScale, bounce).',
          defaultValue: 'ByToastAnimationType.slideAndFade',
        ),
        WidgetParamInfo(
          name: 'duration',
          type: 'Duration',
          description: 'Display duration before toast automatically dismisses.',
          defaultValue: 'Duration(seconds: 3)',
        ),
        WidgetParamInfo(
          name: 'backgroundColor',
          type: 'Color',
          description: 'Background fill color of the toast surface.',
          defaultValue: '#0F172A',
        ),
        WidgetParamInfo(
          name: 'gradient',
          type: 'Gradient?',
          description:
              'Optional gradient decoration applied across the toast surface.',
        ),
        WidgetParamInfo(
          name: 'backgroundOpacity',
          type: 'double',
          description: 'Background transparency level (0.0 to 1.0).',
          defaultValue: '1.0',
        ),
        WidgetParamInfo(
          name: 'textColor',
          type: 'Color',
          description: 'Text color applied to the message and content.',
          defaultValue: 'Colors.white',
        ),
        WidgetParamInfo(
          name: 'icon / prefixIcon',
          type: 'IconData?',
          description:
              'Leading icon displayed at the left side of the message.',
        ),
        WidgetParamInfo(
          name: 'onIconTap',
          type: 'VoidCallback?',
          description: 'Callback invoked when tapping the leading icon.',
        ),
        WidgetParamInfo(
          name: 'suffixIcon / suffix',
          type: 'IconData? / Widget?',
          description:
              'Trailing action icon or custom widget on the right side.',
        ),
        WidgetParamInfo(
          name: 'onSuffixTap',
          type: 'VoidCallback?',
          description:
              'Callback invoked when tapping the trailing suffix action.',
        ),
        WidgetParamInfo(
          name: 'onTap',
          type: 'VoidCallback?',
          description: 'Callback invoked when the toast card is tapped.',
        ),
        WidgetParamInfo(
          name: 'showCloseButton',
          type: 'bool',
          description: "Whether to show an 'X' button to dismiss the toast.",
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'maxLines',
          type: 'int?',
          description:
              'Maximum number of lines for message text before truncation.',
          defaultValue: '3',
        ),
        WidgetParamInfo(
          name: 'overflow',
          type: 'TextOverflow?',
          description: 'Text overflow behavior when exceeding max lines.',
          defaultValue: 'TextOverflow.ellipsis',
        ),
        WidgetParamInfo(
          name: 'border',
          type: 'Border?',
          description: 'Outline border stroke around the toast card.',
        ),
        WidgetParamInfo(
          name: 'borderRadius',
          type: 'BorderRadius?',
          description: 'Corner rounding radius of the toast card.',
          defaultValue: '14.0',
        ),
        WidgetParamInfo(
          name: 'detailTitle / detailMessage',
          type: 'String?',
          description: 'Title and message for the morph detail dialog on tap.',
        ),
        WidgetParamInfo(
          name: 'detailBuilder',
          type: 'WidgetBuilder?',
          description:
              'Custom widget builder for the morph detail dialog on tap.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: colors.scaffoldBg,
          appBar: AppBar(
            key: ByToast.appBarKey,
            backgroundColor: colors.cardBg,
            elevation: 0,
            titleSpacing: 4.0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: Icon(AppIcons.menu, color: colors.textPrimary),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryAccent],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ByToast',
                    style: AppTextStyle.buttonPrimary.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Showcase',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: colors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Reset to Defaults',
                icon: const Icon(AppIcons.reset, color: AppColors.primary),
                onPressed: _resetToDefaults,
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Widget Parameters',
                icon: const Icon(AppIcons.help, color: AppColors.primary),
                onPressed: () => _showByToastParams(context),
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
              } else if (comp == 'ByCard') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CardShowcaseScreen()),
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
                    color: colors.bannerBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.bannerBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        AppIcons.touch,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '💡 How to try: Simply tap on the toast text to open the detail dialog!',
                          style: AppTextStyle.hint.copyWith(
                            color: colors.bannerText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Live Configuration Summary Card
              _buildConfigSummaryCard(),

              const SizedBox(height: 16),

              // Main Controls Section 1: Position & Slide Direction
              _buildControlCard(
                title: '1. SCREEN ANCHOR & SLIDE DIRECTION',
                icon: AppIcons.position,
                children: [
                  Text(
                    'Screen Anchor Position:',
                    style: AppTextStyle.sectionLabel.copyWith(
                      color: labelTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChoiceChip(
                          label: 'Top (Center)',
                          isSelected: _position == ByToastPosition.top,
                          onTap: () {
                            setState(() {
                              _position = ByToastPosition.top;
                              _slideDirection = ByToastSlideDirection.fromTop;
                              ToastConfigStore.instance.position = _position;
                              ToastConfigStore.instance.slideDirection =
                                  _slideDirection;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Bottom (Center)',
                          isSelected: _position == ByToastPosition.bottom,
                          onTap: () {
                            setState(() {
                              _position = ByToastPosition.bottom;
                              _slideDirection =
                                  ByToastSlideDirection.fromBottom;
                              ToastConfigStore.instance.position = _position;
                              ToastConfigStore.instance.slideDirection =
                                  _slideDirection;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Top-Left',
                          isSelected: _position == ByToastPosition.topLeft,
                          onTap: () {
                            setState(() {
                              _position = ByToastPosition.topLeft;
                              _slideDirection = ByToastSlideDirection.fromLeft;
                              ToastConfigStore.instance.position = _position;
                              ToastConfigStore.instance.slideDirection =
                                  _slideDirection;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Top-Right',
                          isSelected: _position == ByToastPosition.topRight,
                          onTap: () {
                            setState(() {
                              _position = ByToastPosition.topRight;
                              _slideDirection = ByToastSlideDirection.fromRight;
                              ToastConfigStore.instance.position = _position;
                              ToastConfigStore.instance.slideDirection =
                                  _slideDirection;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Bottom-Left',
                          isSelected: _position == ByToastPosition.bottomLeft,
                          onTap: () {
                            setState(() {
                              _position = ByToastPosition.bottomLeft;
                              _slideDirection = ByToastSlideDirection.fromLeft;
                              ToastConfigStore.instance.position = _position;
                              ToastConfigStore.instance.slideDirection =
                                  _slideDirection;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Bottom-Right',
                          isSelected: _position == ByToastPosition.bottomRight,
                          onTap: () {
                            setState(() {
                              _position = ByToastPosition.bottomRight;
                              _slideDirection = ByToastSlideDirection.fromRight;
                              ToastConfigStore.instance.position = _position;
                              ToastConfigStore.instance.slideDirection =
                                  _slideDirection;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Entrance Slide Direction:',
                    style: AppTextStyle.sectionLabel.copyWith(
                      color: labelTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSmallChip(
                          'From Top',
                          ByToastSlideDirection.fromTop,
                        ),
                        const SizedBox(width: 8),
                        _buildSmallChip(
                          'From Bottom',
                          ByToastSlideDirection.fromBottom,
                        ),
                        const SizedBox(width: 8),
                        _buildSmallChip(
                          'From Left',
                          ByToastSlideDirection.fromLeft,
                        ),
                        const SizedBox(width: 8),
                        _buildSmallChip(
                          'From Right',
                          ByToastSlideDirection.fromRight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Section 2: Animation Style & Curves
              _buildControlCard(
                title: '2. ANIMATION STYLE & CURVES',
                icon: AppIcons.animation,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildAnimChip(
                          'Slide & Fade',
                          ByToastAnimationType.slideAndFade,
                        ),
                        const SizedBox(width: 8),
                        _buildAnimChip(
                          'Bounce / Spring',
                          ByToastAnimationType.bounce,
                        ),
                        const SizedBox(width: 8),
                        _buildAnimChip(
                          'Scale & Fade',
                          ByToastAnimationType.scaleAndFade,
                        ),
                        const SizedBox(width: 8),
                        _buildAnimChip(
                          'Slide Only',
                          ByToastAnimationType.slideOnly,
                        ),
                        const SizedBox(width: 8),
                        _buildAnimChip(
                          'Fade Only',
                          ByToastAnimationType.fadeOnly,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Section 3: Icons & Close Button
              _buildControlCard(
                title: '3. ICONS (LEFT & RIGHT) & CLOSE BUTTON',
                icon: AppIcons.button,
                children: [
                  // Left Icon (Prefix)
                  Text(
                    'Left Icon (Prefix):',
                    style: AppTextStyle.sectionLabel.copyWith(
                      color: labelTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChoiceChip(
                          label: 'None',
                          isSelected: _selectedLeftIconIndex == 0,
                          onTap: () =>
                              setState(() => _selectedLeftIconIndex = 0),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Bell Icon',
                          isSelected: _selectedLeftIconIndex == 1,
                          onTap: () =>
                              setState(() => _selectedLeftIconIndex = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Checkmark',
                          isSelected: _selectedLeftIconIndex == 2,
                          onTap: () =>
                              setState(() => _selectedLeftIconIndex = 2),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Info Icon',
                          isSelected: _selectedLeftIconIndex == 3,
                          onTap: () =>
                              setState(() => _selectedLeftIconIndex = 3),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Right Action (Suffix)
                  Text(
                    'Right Action (Suffix):',
                    style: AppTextStyle.sectionLabel.copyWith(
                      color: labelTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChoiceChip(
                          label: 'None',
                          isSelected: _selectedRightActionIndex == 0,
                          onTap: () =>
                              setState(() => _selectedRightActionIndex = 0),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Chevron Right',
                          isSelected: _selectedRightActionIndex == 1,
                          onTap: () =>
                              setState(() => _selectedRightActionIndex = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Undo Button',
                          isSelected: _selectedRightActionIndex == 2,
                          onTap: () =>
                              setState(() => _selectedRightActionIndex = 2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Close Button Toggle
                  Material(
                    color: Colors.transparent,
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.primary,
                      title: Text(
                        'Show Close Button (\'X\')',
                        style: AppTextStyle.sectionLabel.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Can be toggled active or inactive independently',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                      value: _showCloseButton,
                      onChanged: (val) =>
                          setState(() => _showCloseButton = val),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Section 4: Tap & Drag-to-Dialog Morphing Feature
              _buildControlCard(
                title: '4. EXPAND TO DIALOG (TAP & DRAG)',
                icon: AppIcons.external,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.primary,
                      title: Text(
                        'Enable Expand to Dialog (Tap & Drag)',
                        style: AppTextStyle.sectionLabel.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Tap message text or drag toast towards screen center to morph into dialog',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                      value: _enableTapToDialog,
                      onChanged: (val) =>
                          setState(() => _enableTapToDialog = val),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOutCubic,
                    child: _enableTapToDialog
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                'Dialog Content Mode:',
                                style: AppTextStyle.sectionLabel.copyWith(
                                  color: labelTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildChoiceChip(
                                      label: 'Option 1: Default Text',
                                      isSelected: _selectedDialogMode == 0,
                                      onTap: () => setState(
                                        () => _selectedDialogMode = 0,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildChoiceChip(
                                      label: 'Option 2: Custom Receipt',
                                      isSelected: _selectedDialogMode == 1,
                                      onTap: () => setState(
                                        () => _selectedDialogMode = 1,
                                      ),
                                    ),
                                  ],
                                ),
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
                icon: AppIcons.palette,
                children: [
                  Text(
                    'Preset Color Palette:',
                    style: AppTextStyle.sectionLabel.copyWith(
                      color: labelTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_colorThemes.length, (index) {
                        final isSelected = _selectedColorIndex == index;
                        final theme = _colorThemes[index];
                        final Color color = theme['color'] as Color;
                        final Gradient? gradient =
                            theme['gradient'] as Gradient?;
                        final bool isWhite = color == Colors.white;

                        return Tooltip(
                          message: theme['name'] as String,
                          child: GestureDetector(
                            key: ValueKey('theme_${theme['name']}'),
                            onTap: () =>
                                setState(() => _selectedColorIndex = index),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: gradient == null ? color : null,
                                gradient: gradient,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? (isWhite && !isDark
                                            ? AppColors.primary
                                            : (isDark
                                                  ? Colors.white
                                                  : AppColors.primaryDark))
                                      : colors.borderSubtle,
                                  width: isSelected ? 2.5 : 1.0,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(
                                      AppIcons.checkRaw,
                                      size: 18,
                                      color: isWhite
                                          ? const Color(0xFF0F172A)
                                          : Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildToggleChip(
                    label: 'Subtle Outline Border',
                    isSelected: _useOutlineBorder,
                    onChanged: (val) => setState(() => _useOutlineBorder = val),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Background Opacity:',
                        style: AppTextStyle.sectionLabel.copyWith(
                          color: labelTextColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colors.badgeBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.badgeBorder),
                        ),
                        child: Text(
                          '${(_backgroundOpacity * 100).round()}%',
                          style: AppTextStyle.badge.copyWith(
                            color: colors.badgeText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: colors.borderSubtle,
                      thumbColor: AppColors.primaryLight,
                      overlayColor: AppColors.primary.withValues(alpha: 0.18),
                      trackHeight: 4.0,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7.0,
                      ),
                    ),
                    child: Slider(
                      value: _backgroundOpacity,
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      onChanged: (val) {
                        setState(() => _backgroundOpacity = val);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Section 6: Text Truncation & Overflow (maxLines & ellipsis)
              _buildControlCard(
                title: '6. TEXT TRUNCATION & OVERFLOW (MAXLINES & ELLIPSIS)',
                icon: AppIcons.wrapText,
                children: [
                  Text(
                    'Max Lines Clamp:',
                    style: AppTextStyle.sectionLabel.copyWith(
                      color: labelTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChoiceChip(
                          label: '1 Line',
                          isSelected: _maxLines == 1,
                          onTap: () => setState(() => _maxLines = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: '2 Lines',
                          isSelected: _maxLines == 2,
                          onTap: () => setState(() => _maxLines = 2),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: '3 Lines (Default)',
                          isSelected: _maxLines == 3,
                          onTap: () => setState(() => _maxLines = 3),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Unlimited (null)',
                          isSelected: _maxLines == null,
                          onTap: () => setState(() => _maxLines = null),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Text Overflow Behavior:',
                    style: AppTextStyle.sectionLabel.copyWith(
                      color: labelTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChoiceChip(
                          label: 'Ellipsis (...) (Default)',
                          isSelected: _overflow == TextOverflow.ellipsis,
                          onTap: () =>
                              setState(() => _overflow = TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Clip (Cut off)',
                          isSelected: _overflow == TextOverflow.clip,
                          onTap: () =>
                              setState(() => _overflow = TextOverflow.clip),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Fade',
                          isSelected: _overflow == TextOverflow.fade,
                          onTap: () =>
                              setState(() => _overflow = TextOverflow.fade),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Visible',
                          isSelected: _overflow == TextOverflow.visible,
                          onTap: () =>
                              setState(() => _overflow = TextOverflow.visible),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildToggleChip(
                      label: _isMultiLine
                          ? 'Long Multi-line Text Active (Tap toast to view full dialog)'
                          : 'Switch to Long Multi-line Text (Test 3 Lines & Ellipsis)',
                      isSelected: _isMultiLine,
                      onChanged: (val) => setState(() => _isMultiLine = val),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Fixed Bottom Navigation Bar for Triggers
          bottomNavigationBar: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            key: ByToast.bottomBarKey,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              border: Border(top: BorderSide(color: colors.border, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(AppIcons.play, size: 20),
                      label: Text('Trigger', style: AppTextStyle.buttonPrimary),
                      onPressed: () => _triggerToast(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryAccent,
                        side: const BorderSide(
                          color: AppColors.primaryAccent,
                          width: 1.2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(AppIcons.bolt, size: 18),
                      label: Text(
                        'Stack x3',
                        style: AppTextStyle.buttonSecondary.copyWith(
                          color: AppColors.primaryAccent,
                        ),
                      ),
                      onPressed: _triggerRapidFireStack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfigSummaryCard() {
    final theme = _colorThemes[_selectedColorIndex];
    final Color rawColor = theme['color'] as Color;
    final Color accentColor = rawColor == Colors.white
        ? AppColors.primary
        : (theme['gradient'] != null ? AppColors.primaryLight : rawColor);

    String positionLabel;
    switch (_position) {
      case ByToastPosition.top:
        positionLabel = 'Top Center';
        break;
      case ByToastPosition.bottom:
        positionLabel = 'Bottom Center';
        break;
      case ByToastPosition.topLeft:
        positionLabel = 'Top-Left';
        break;
      case ByToastPosition.topRight:
        positionLabel = 'Top-Right';
        break;
      case ByToastPosition.bottomLeft:
        positionLabel = 'Bottom-Left';
        break;
      case ByToastPosition.bottomRight:
        positionLabel = 'Bottom-Right';
        break;
    }

    String slideLabel;
    switch (_slideDirection) {
      case ByToastSlideDirection.fromTop:
        slideLabel = 'From Top';
        break;
      case ByToastSlideDirection.fromBottom:
        slideLabel = 'From Bottom';
        break;
      case ByToastSlideDirection.fromLeft:
        slideLabel = 'From Left';
        break;
      case ByToastSlideDirection.fromRight:
        slideLabel = 'From Right';
        break;
    }

    String animLabel;
    switch (_animationType) {
      case ByToastAnimationType.slideAndFade:
        animLabel = 'Slide & Fade';
        break;
      case ByToastAnimationType.bounce:
        animLabel = 'Bounce / Spring';
        break;
      case ByToastAnimationType.scaleAndFade:
        animLabel = 'Scale & Fade';
        break;
      case ByToastAnimationType.slideOnly:
        animLabel = 'Slide Only';
        break;
      case ByToastAnimationType.fadeOnly:
        animLabel = 'Fade Only';
        break;
    }

    final String leftIconLabel = _selectedLeftIconIndex == 0
        ? 'None'
        : (_selectedLeftIconIndex == 1
              ? 'Bell'
              : (_selectedLeftIconIndex == 2 ? 'Check' : 'Info'));

    final String rightActionLabel = _selectedRightActionIndex == 0
        ? 'None'
        : (_selectedRightActionIndex == 1 ? 'Chevron' : 'Undo');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.4 : 0.3),
          width: 1.2,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'ACTIVE CONFIGURATION PREVIEW',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.sectionHeader.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  positionLabel,
                  style: AppTextStyle.badgeSmall.copyWith(color: accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Screen Anchor', positionLabel),
          const SizedBox(height: 6),
          _buildSummaryRow('Theme Palette', theme['name'] as String),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Opacity & Border',
            '${(_backgroundOpacity * 100).round()}%${_useOutlineBorder ? ' • Outline Glow' : ' • Borderless'}',
          ),
          const SizedBox(height: 6),
          _buildSummaryRow('Entrance & Motion', '$slideLabel • $animLabel'),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Expand to Dialog',
            _enableTapToDialog
                ? (_selectedDialogMode == 0
                      ? 'Active (Default Text)'
                      : 'Active (Custom Receipt)')
                : 'Disabled',
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Icons & Actions',
            'Prefix: $leftIconLabel • Suffix: $rightActionLabel${_showCloseButton ? ' • Close (X)' : ''}',
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Text Clamp',
            '${_maxLines ?? 'Unlimited'} lines (${_overflow.name})',
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
          style: AppTextStyle.caption.copyWith(color: colors.textMuted),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.specValue.copyWith(color: colors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetPills() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUICK PRESETS (1-CLICK TEST)',
            style: AppTextStyle.sectionHeader.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildPresetBtn('Success', AppColors.success, () {
                ByToast.showSuccess(
                  context,
                  message: 'Transaction completed successfully!',
                  position: _position,
                  slideDirection: _slideDirection,
                  backgroundOpacity: _backgroundOpacity,
                  detailTitle: 'Transaction #1042 Completed',
                  detailMessage:
                      'Payment verified via QRIS. Thermal receipt ready to print.',
                  enableTapToExpand: _enableTapToDialog,
                  maxLines: _maxLines,
                  overflow: _overflow,
                );
              }),
              const SizedBox(width: 6),
              _buildPresetBtn('Error', AppColors.error, () {
                ByToast.showError(
                  context,
                  message: 'Thermal printer connection timed out.',
                  position: _position,
                  slideDirection: _slideDirection,
                  backgroundOpacity: _backgroundOpacity,
                  detailTitle: 'Hardware Connection Error',
                  detailMessage:
                      'The system could not communicate with Bluetooth printer POS-PRT-02. Please ensure the printer is turned on and paired.',
                  enableTapToExpand: _enableTapToDialog,
                  maxLines: _maxLines,
                  overflow: _overflow,
                );
              }),
              const SizedBox(width: 6),
              _buildPresetBtn('Warning', AppColors.warning, () {
                ByToast.showWarning(
                  context,
                  message: 'Robusta coffee bean stock is low.',
                  position: _position,
                  slideDirection: _slideDirection,
                  backgroundOpacity: _backgroundOpacity,
                  detailTitle: 'Low Stock Alert',
                  detailMessage:
                      'Robusta Medium Roast Beans is below the reorder threshold (remaining: 3 portions). Please contact supplier.',
                  enableTapToExpand: _enableTapToDialog,
                  maxLines: _maxLines,
                  overflow: _overflow,
                );
              }),
              const SizedBox(width: 6),
              _buildPresetBtn('Info', AppColors.info, () {
                ByToast.showInfo(
                  context,
                  message: 'Cloud data synchronization in progress.',
                  position: _position,
                  slideDirection: _slideDirection,
                  backgroundOpacity: _backgroundOpacity,
                  detailTitle: 'Background Sync Status',
                  detailMessage:
                      'Syncing 14 local transactions and 2 inventory logs with cloud server database. Estimated time remaining: 12 seconds.',
                  enableTapToExpand: _enableTapToDialog,
                  maxLines: _maxLines,
                  overflow: _overflow,
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
              border: Border.all(
                color: color.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTextStyle.pillButton.copyWith(color: color),
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
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 15, color: AppColors.primary),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyle.sectionHeader.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
    Widget? icon,
  }) {
    return BySelectOption(
      label: Text(label),
      isSelected: isSelected,
      icon: icon,
      selectedBorderColor: AppColors.primary,
      unselectedBorderColor: colors.borderSubtle,
      selectedBackgroundColor: colors.chipSelectedBg,
      unselectedBackgroundColor: colors.chipBg,
      selectedTextColor: isDark ? Colors.white : AppColors.primaryDark,
      unselectedTextColor: colors.textMuted,
      onTap: onTap,
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onChanged,
  }) {
    return BySelectOption(
      label: Text(label),
      isSelected: isSelected,
      icon: Icon(
        isSelected ? AppIcons.successFilled : AppIcons.radioUnchecked,
        size: 14,
      ),
      selectedBorderColor: AppColors.primary,
      unselectedBorderColor: colors.borderSubtle,
      selectedBackgroundColor: colors.chipSelectedBg,
      unselectedBackgroundColor: colors.chipBg,
      selectedTextColor: isDark ? Colors.white : AppColors.primaryDark,
      unselectedTextColor: colors.textMuted,
      onTap: () => onChanged(!isSelected),
    );
  }

  Widget _buildSmallChip(String label, ByToastSlideDirection direction) {
    return _buildChoiceChip(
      label: label,
      isSelected: _slideDirection == direction,
      onTap: () => setState(() => _slideDirection = direction),
    );
  }

  Widget _buildAnimChip(String label, ByToastAnimationType type) {
    return _buildChoiceChip(
      label: label,
      isSelected: _animationType == type,
      onTap: () => setState(() => _animationType = type),
    );
  }
}
