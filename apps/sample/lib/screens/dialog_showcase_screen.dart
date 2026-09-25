import 'dart:math';
import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_theme_store.dart';
import '../models/toast_config_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_drawer.dart';
import '../widgets/by_showcase_header.dart';
import '../widgets/by_color_palette.dart';
import '../widgets/by_showcase_choice_chip.dart';
import '../widgets/widget_params_dialog.dart';
import 'app_bar_showcase_screen.dart';
import 'toast_showcase_screen.dart';
import 'card_showcase_screen.dart';

/// Highly customizable interactive showcase screen for ByDialog components.
/// Features live controls matching ByToast: Theme colors, gradients, borders,
/// radius, custom icons, animation curves, durations, and dismissible behavior.
class DialogShowcaseScreen extends StatefulWidget {
  const DialogShowcaseScreen({super.key});

  @override
  State<DialogShowcaseScreen> createState() => _DialogShowcaseScreenState();
}

class _DialogShowcaseScreenState extends State<DialogShowcaseScreen> {
  bool get isDark => AppThemeStore.instance.isDarkMode(context);
  AppColorPalette get colors => AppColors.of(context);
  Color get labelTextColor => colors.textSecondary;

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

  // Button Customization & Actions
  double _buttonCornerRadius = 12.0;
  bool _reverseButtonOrder = false;
  int _cancelStyleIndex = 0; // 0: Outline, 1: Solid Fill, 2: Danger Tint
  bool _customConfirmTextColor = false;

  // Available Theme Colors
  final List<ShowcaseThemePreset> _themePresets = AppColors.dialogThemePresets;

  // Available Icons
  final List<ShowcaseIconOption> _iconPresets = AppIcons.dialogIconPresets;

  void _triggerDialog() {
    final theme = _themePresets[_selectedThemeIndex];
    final Color bgColor = theme['color'] as Color;
    final Color accentColor = theme['accent'] as Color;
    final Color textColor = (theme['textColor'] as Color?) ?? Colors.white;
    final bool isDarkSurface = bgColor != Colors.white;
    final Gradient? gradient = _useGradient
        ? theme['gradient'] as Gradient
        : null;
    final IconData? icon =
        _iconPresets[_selectedIconIndex]['icon'] as IconData?;
    final BorderRadius radius = BorderRadius.circular(_selectedCornerRadius);

    final Border? border = _useOutlineBorder
        ? Border.all(color: accentColor.withValues(alpha: 0.8), width: 1.2)
        : null;

    final BorderRadius buttonRadius = BorderRadius.circular(
      _buttonCornerRadius,
    );

    Color? cancelColor;
    Color? cancelTextColor;
    Color? cancelBorderColor;
    if (_cancelStyleIndex == 1) {
      // Solid filled button
      cancelColor = isDark ? colors.surfaceVariant : colors.chipBg;
      cancelTextColor = colors.textPrimary;
    } else if (_cancelStyleIndex == 2) {
      // Danger Tint
      cancelBorderColor = AppColors.error.withValues(alpha: 0.6);
      cancelTextColor = AppColors.error;
    }

    final Color? confirmTextColor = _customConfirmTextColor
        ? (isDark ? Colors.black : Colors.white)
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
        buttonTextColor: confirmTextColor,
        buttonBorderRadius: buttonRadius,
        buttonText: 'Got It',
        backgroundColor: bgColor,
        gradient: gradient,
        textColor: textColor,
        borderRadius: radius,
        border: border,
        barrierDismissible: _barrierDismissible,
        transitionDuration: _selectedDuration,
        enterCurve: _selectedCurve,
        onConfirm: () {
          ToastConfigStore.instance.showFeedback(
            context,
            message: 'Alert acknowledged.',
            icon: AppIcons.successFilled,
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
        icon: icon ?? AppIcons.help,
        iconColor: accentColor,
        confirmColor: accentColor,
        confirmTextColor: confirmTextColor,
        cancelColor: cancelColor,
        cancelBorderColor: cancelBorderColor,
        cancelTextColor: cancelTextColor,
        buttonBorderRadius: buttonRadius,
        reverseButtonOrder: _reverseButtonOrder,
        confirmText: 'Void Transaction',
        cancelText: 'Keep Transaction',
        backgroundColor: bgColor,
        gradient: gradient,
        textColor: textColor,
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
            icon: confirmed ? AppIcons.delete : AppIcons.close,
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

          final surfacePalette = AppColors.fromBrightness(isDarkSurface);

          return Container(
            width: cardWidth,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: gradient == null ? bgColor : null,
              gradient: gradient,
              borderRadius: radius,
              border:
                  border ??
                  Border.all(
                    color: isDarkSurface
                        ? Colors.white.withValues(alpha: 0.12)
                        : surfacePalette.border,
                    width: 1.2,
                  ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDarkSurface ? 0.45 : 0.15,
                  ),
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
                        icon ?? AppIcons.receipt,
                        color: accentColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cashier Receipt #1042',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: surfacePalette.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Payment: QRIS Dynamic',
                            style: AppTextStyle.caption.copyWith(
                              color: surfacePalette.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () =>
                            Navigator.of(ctx, rootNavigator: true).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            AppIcons.close,
                            size: 20,
                            color: surfacePalette.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: surfacePalette.border, height: 1),
                const SizedBox(height: 14),
                _buildReceiptRow(
                  'Robusta Latte x2',
                  'Rp 50.000',
                  isDarkSurface: isDarkSurface,
                ),
                const SizedBox(height: 8),
                _buildReceiptRow(
                  'Caramel Croissant x1',
                  'Rp 28.000',
                  isDarkSurface: isDarkSurface,
                ),
                const SizedBox(height: 8),
                _buildReceiptRow(
                  'Mineral Water x1',
                  'Rp 10.000',
                  isDarkSurface: isDarkSurface,
                ),
                const SizedBox(height: 14),
                Divider(color: surfacePalette.border, height: 1),
                const SizedBox(height: 14),
                _buildReceiptRow(
                  'Subtotal',
                  'Rp 88.000',
                  isBold: true,
                  isDarkSurface: isDarkSurface,
                ),
                const SizedBox(height: 6),
                _buildReceiptRow(
                  'Tax (11%)',
                  'Rp 9.680',
                  isDarkSurface: isDarkSurface,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: AppTextStyle.sectionLabel.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Rp 97.680',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: accentColor,
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
                    icon: const Icon(AppIcons.print, size: 18),
                    label: Text(
                      'Print Thermal Receipt',
                      style: AppTextStyle.buttonPrimary,
                    ),
                    onPressed: () {
                      Navigator.of(ctx, rootNavigator: true).pop();
                      ToastConfigStore.instance.showFeedback(
                        context,
                        message: 'Printing thermal receipt...',
                        icon: AppIcons.print,
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

  Widget _buildReceiptRow(
    String item,
    String price, {
    bool isBold = false,
    bool isDarkSurface = true,
  }) {
    final surfacePalette = AppColors.fromBrightness(isDarkSurface);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item,
          style: (isBold ? AppTextStyle.bodyMedium : AppTextStyle.caption)
              .copyWith(
                color: isBold
                    ? surfacePalette.textPrimary
                    : surfacePalette.textSecondary,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
        ),
        Text(
          price,
          style: (isBold ? AppTextStyle.bodyMedium : AppTextStyle.caption)
              .copyWith(
                color: isBold
                    ? surfacePalette.textPrimary
                    : surfacePalette.textMuted,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
        ),
      ],
    );
  }

  void _resetToDefaults() {
    setState(() {
      _selectedDialogType = 0;
      _selectedThemeIndex = 0;
      _useGradient = false;
      _useOutlineBorder = true;
      _selectedCornerRadius = 22.0;
      _selectedIconIndex = 1;
      _selectedCurve = Curves.easeOutCubic;
      _selectedDuration = const Duration(milliseconds: 320);
      _barrierDismissible = true;
      _buttonCornerRadius = 12.0;
      _reverseButtonOrder = false;
      _cancelStyleIndex = 0;
      _customConfirmTextColor = false;
    });
  }

  void _showByDialogParams(BuildContext context) {
    showWidgetParametersDialog(
      context,
      parameters: const [
        WidgetParamInfo(
          name: 'title',
          type: 'String?',
          description:
              'Main title text displayed at the top of the dialog (optional).',
        ),
        WidgetParamInfo(
          name: 'message',
          type: 'String?',
          description:
              'Body message explaining the dialog purpose (optional if using content).',
        ),
        WidgetParamInfo(
          name: 'content',
          type: 'Widget?',
          description:
              'Custom body widget displayed in the dialog body replacing message.',
        ),
        WidgetParamInfo(
          name: 'icon',
          type: 'IconData?',
          description: 'Accent header icon displayed in the top container.',
          defaultValue: 'Icons.info_outline_rounded',
        ),
        WidgetParamInfo(
          name: 'iconColor',
          type: 'Color?',
          description: 'Color tint for the accent header icon.',
        ),
        WidgetParamInfo(
          name: 'buttonText / confirmText',
          type: 'String',
          description: 'Text label for the primary action / confirm button.',
          defaultValue: "'OK' / 'Confirm'",
        ),
        WidgetParamInfo(
          name: 'buttonColor / confirmColor',
          type: 'Color?',
          description: 'Background fill color for the primary action button.',
        ),
        WidgetParamInfo(
          name: 'buttonTextColor / confirmTextColor',
          type: 'Color?',
          description: 'Text color for the primary action button.',
        ),
        WidgetParamInfo(
          name: 'cancelText',
          type: 'String',
          description:
              'Text label for the secondary / cancel button in ByDialog.confirm.',
          defaultValue: "'Cancel'",
        ),
        WidgetParamInfo(
          name: 'cancelColor',
          type: 'Color?',
          description: 'Background fill color for filled cancel button style.',
        ),
        WidgetParamInfo(
          name: 'cancelTextColor',
          type: 'Color?',
          description: 'Text color for the cancel button.',
        ),
        WidgetParamInfo(
          name: 'cancelBorderColor',
          type: 'Color?',
          description: 'Border stroke color for outlined cancel button style.',
        ),
        WidgetParamInfo(
          name: 'reverseButtonOrder',
          type: 'bool',
          description:
              'Swaps the visual position of confirm and cancel buttons.',
          defaultValue: 'false',
        ),
        WidgetParamInfo(
          name: 'onConfirm',
          type: 'VoidCallback?',
          description: 'Callback executed when the confirm button is tapped.',
        ),
        WidgetParamInfo(
          name: 'onCancel',
          type: 'VoidCallback?',
          description: 'Callback executed when the cancel button is tapped.',
        ),
        WidgetParamInfo(
          name: 'backgroundColor',
          type: 'Color',
          description: 'Background fill color of the dialog card.',
          defaultValue: '#0F172A',
        ),
        WidgetParamInfo(
          name: 'gradient',
          type: 'Gradient?',
          description:
              'Optional surface gradient decoration for the dialog card.',
        ),
        WidgetParamInfo(
          name: 'textColor',
          type: 'Color',
          description: 'Default text color for title and message content.',
          defaultValue: 'Colors.white',
        ),
        WidgetParamInfo(
          name: 'border',
          type: 'Border?',
          description: 'Outer outline border stroke around the dialog card.',
        ),
        WidgetParamInfo(
          name: 'borderRadius',
          type: 'BorderRadius?',
          description: 'Corner radius geometry for the dialog card.',
          defaultValue: '22.0',
        ),
        WidgetParamInfo(
          name: 'buttonBorderRadius',
          type: 'BorderRadius?',
          description: 'Corner radius geometry for dialog action buttons.',
          defaultValue: '12.0',
        ),
        WidgetParamInfo(
          name: 'barrierDismissible',
          type: 'bool',
          description:
              'Whether the dialog can be dismissed by tapping the backdrop.',
          defaultValue: 'true',
        ),
        WidgetParamInfo(
          name: 'barrierColor',
          type: 'Color',
          description: 'Color tint for the modal backdrop overlay.',
          defaultValue: 'Color(0x99000000)',
        ),
        WidgetParamInfo(
          name: 'transitionDuration',
          type: 'Duration',
          description: 'Duration of the entry scale and fade animation.',
          defaultValue: 'Duration(milliseconds: 320)',
        ),
        WidgetParamInfo(
          name: 'enterCurve',
          type: 'Curve',
          description: 'Easing curve for the entry modal animation.',
          defaultValue: 'Curves.easeOutCubic',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        return ByScrollScope(
          child: Scaffold(
            backgroundColor: colors.scaffoldBg,
            extendBodyBehindAppBar: true,
            appBar: ByAppBar(
              child: ByShowcaseHeader(
                componentName: 'ByDialog',
                onReset: _resetToDefaults,
                onOpenParams: () => _showByDialogParams(context),
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
                } else if (comp == 'ByCard') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CardShowcaseScreen()),
                  );
                } else if (comp == 'ByAppBar') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppBarShowcaseScreen(),
                    ),
                  );
                }
              },
            ),
            body: ListView(
              padding: EdgeInsets.fromLTRB(
                12,
                ByAppBar.getContentTopPadding(context, extra: 10),
                12,
                20,
              ),
              children: [
              // 1. Active Configuration Preview Card
              _buildConfigSummaryCard(),

              const SizedBox(height: 10),

              // 2. Preset Example Card
              _buildPresetPills(),

              const SizedBox(height: 10),

              // 3. Integrated Feature Hint (Integrated with ByToast)
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: colors.bannerBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.bannerBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      AppIcons.sparkle,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Integrated with ByToast',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: colors.bannerText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ByDialog can also be opened seamlessly by tapping the text of a ByToast notification card!',
                            style: AppTextStyle.caption.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Control Section 1: Dialog Type
              _buildControlCard(
                title: '1. DIALOG TYPE & LAYOUT MODE',
                icon: AppIcons.dashboard,
                children: [
                  Text(
                    'Select Dialog Template:',
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
                          label: 'Alert (Single)',
                          isSelected: _selectedDialogType == 0,
                          onTap: () => setState(() => _selectedDialogType = 0),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Confirm (Dual)',
                          isSelected: _selectedDialogType == 1,
                          onTap: () => setState(() => _selectedDialogType = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Custom Receipt',
                          isSelected: _selectedDialogType == 2,
                          onTap: () => setState(() => _selectedDialogType = 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Control Section 2: Color Theme & Appearance
              _buildControlCard(
                title: '2. COLOR THEME & SURFACE STYLING',
                icon: AppIcons.palette,
                children: [
                  Text(
                    'Preset Color Palette:',
                    style: AppTextStyle.sectionLabel.copyWith(
                      color: labelTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ByColorPalette(
                    items: _themePresets.map((preset) => ByColorPaletteItem(
                      label: preset.name,
                      color: preset.accent,
                      value: preset,
                    )).toList(),
                    selectedIndex: _selectedThemeIndex,
                    onSelected: (index) =>
                        setState(() => _selectedThemeIndex = index),
                  ),
                  const SizedBox(height: 16),
                  ByShowcaseSwitchTile(
                    title: 'Gradient Surface Background',
                    subtitle:
                        'Switches from deep solid color to rich multi-hue linear gradient',
                    value: _useGradient,
                    onChanged: (val) => setState(() => _useGradient = val),
                  ),
                  const SizedBox(height: 12),
                  ByShowcaseSwitchTile(
                    title: 'Outline Glow Border',
                    subtitle:
                        'Adds a subtle high-contrast border matching the accent color',
                    value: _useOutlineBorder,
                    onChanged: (val) =>
                        setState(() => _useOutlineBorder = val),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Corner Radius:',
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
                          label: '16px (Subtle)',
                          isSelected: _selectedCornerRadius == 16.0,
                          onTap: () =>
                              setState(() => _selectedCornerRadius = 16.0),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: '22px (Standard)',
                          isSelected: _selectedCornerRadius == 22.0,
                          onTap: () =>
                              setState(() => _selectedCornerRadius = 22.0),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: '28px (Soft)',
                          isSelected: _selectedCornerRadius == 28.0,
                          onTap: () =>
                              setState(() => _selectedCornerRadius = 28.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Control Section 3: Icon & Badge
              _buildControlCard(
                title: '3. HEADER ICON & ACCENT BADGE',
                icon: AppIcons.star,
                children: [
                  Text(
                    'Select Header Icon:',
                    style: AppTextStyle.sectionLabel.copyWith(
                      color: labelTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_iconPresets.length, (index) {
                        final item = _iconPresets[index];
                        final bool isSelected = _selectedIconIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildChoiceChip(
                            label: item['name'] as String,
                            icon: item['icon'] != null
                                ? Icon(item['icon'] as IconData, size: 14)
                                : null,
                            isSelected: isSelected,
                            onTap: () =>
                                setState(() => _selectedIconIndex = index),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Control Section 4: Animation & Behavior
              _buildControlCard(
                title: '4. ANIMATION & INTERACTION BEHAVIOR',
                icon: AppIcons.motion,
                children: [
                  Text(
                    'Entrance Animation Curve:',
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
                          label: 'Cubic (Smooth)',
                          isSelected: _selectedCurve == Curves.easeOutCubic,
                          onTap: () => setState(
                            () => _selectedCurve = Curves.easeOutCubic,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Back (Bouncy)',
                          isSelected: _selectedCurve == Curves.easeOutBack,
                          onTap: () => setState(
                            () => _selectedCurve = Curves.easeOutBack,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Linear',
                          isSelected: _selectedCurve == Curves.linear,
                          onTap: () =>
                              setState(() => _selectedCurve = Curves.linear),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Transition Duration:',
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
                          label: 'Fast (200ms)',
                          isSelected: _selectedDuration.inMilliseconds == 200,
                          onTap: () => setState(
                            () => _selectedDuration = const Duration(
                              milliseconds: 200,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Normal (320ms)',
                          isSelected: _selectedDuration.inMilliseconds == 320,
                          onTap: () => setState(
                            () => _selectedDuration = const Duration(
                              milliseconds: 320,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Slow (550ms)',
                          isSelected: _selectedDuration.inMilliseconds == 550,
                          onTap: () => setState(
                            () => _selectedDuration = const Duration(
                              milliseconds: 550,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ByShowcaseSwitchTile(
                    title: 'Barrier Dismissible',
                    subtitle:
                        'Allows closing the dialog by clicking on the dark backdrop scrim',
                    value: _barrierDismissible,
                    onChanged: (val) =>
                        setState(() => _barrierDismissible = val),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Control Section 5: Button Customization & Actions
              _buildControlCard(
                title: '5. BUTTON ACTIONS & STYLING',
                icon: AppIcons.button,
                children: [
                  Text(
                    'Button Corner Radius:',
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
                          label: '6px (Sharp)',
                          isSelected: _buttonCornerRadius == 6.0,
                          onTap: () =>
                              setState(() => _buttonCornerRadius = 6.0),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: '12px (Standard)',
                          isSelected: _buttonCornerRadius == 12.0,
                          onTap: () =>
                              setState(() => _buttonCornerRadius = 12.0),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: '24px (Pill)',
                          isSelected: _buttonCornerRadius == 24.0,
                          onTap: () =>
                              setState(() => _buttonCornerRadius = 24.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Negative (Cancel) Button Style:',
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
                          label: 'Outline',
                          isSelected: _cancelStyleIndex == 0,
                          onTap: () => setState(() => _cancelStyleIndex = 0),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Solid Fill',
                          isSelected: _cancelStyleIndex == 1,
                          onTap: () => setState(() => _cancelStyleIndex = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Danger Tint',
                          isSelected: _cancelStyleIndex == 2,
                          onTap: () => setState(() => _cancelStyleIndex = 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ByShowcaseSwitchTile(
                    title: 'Reverse Button Order',
                    subtitle:
                        'Places Confirm on the left and Cancel on the right',
                    value: _reverseButtonOrder,
                    onChanged: (val) =>
                        setState(() => _reverseButtonOrder = val),
                  ),
                  const SizedBox(height: 12),
                  ByShowcaseSwitchTile(
                    title: 'High-Contrast Confirm Text',
                    subtitle:
                        'Switches confirm button text color between dark and white',
                    value: _customConfirmTextColor,
                    onChanged: (val) =>
                        setState(() => _customConfirmTextColor = val),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
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
                      label: Text(
                        'Trigger Dialog',
                        style: AppTextStyle.buttonPrimary,
                      ),
                      onPressed: _triggerDialog,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(AppIcons.help, size: 18),
                      label: Text(
                        'Confirm Flow',
                        style: AppTextStyle.buttonSecondary.copyWith(
                          color: AppColors.primary,
                        ),
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
        ),
      );
    },
    );
  }

  Widget _buildPresetPills() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            'Preset Example',
            style: AppTextStyle.sectionHeader.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPresetBtn('Success', AppColors.success, () {
                  ByDialog.success(
                    context,
                    title: 'Transaction Successful',
                    message: 'Payment #1042 was settled via QRIS Dynamic.',
                  );
                }),
                const SizedBox(width: 8),
                _buildPresetBtn('Error', AppColors.error, () {
                  ByDialog.error(
                    context,
                    title: 'Printer Connection Failed',
                    message: 'Unable to pair with Bluetooth printer POS-PRT-02.',
                  );
                }),
                const SizedBox(width: 8),
                _buildPresetBtn('Warning', AppColors.warning, () {
                  ByDialog.warning(
                    context,
                    title: 'Inventory Threshold Alert',
                    message: 'Robusta medium beans is down to 3 portions.',
                  );
                }),
                const SizedBox(width: 8),
                _buildPresetBtn('Info', AppColors.info, () {
                  ByDialog.info(
                    context,
                    title: 'Cloud Sync in Progress',
                    message: 'Syncing 14 local transactions to cloud server.',
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetBtn(String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
    );
  }

  Widget _buildConfigSummaryCard() {
    final theme = _themePresets[_selectedThemeIndex];
    final typeName = _selectedDialogType == 0
        ? 'Alert Modal'
        : _selectedDialogType == 1
        ? 'Confirm Modal'
        : 'Custom Receipt';

    return ByCard(
      variant: ByCardVariant.normal,
      backgroundColor: colors.cardBg,
      borderColor: colors.border,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  AppIcons.shield,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Configuration Preview',
                      style: AppTextStyle.screenSubtitle.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Live modal surface, curve, and action styling',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'The ByDialog modals render smoothly with frosted scrims, custom surface shaders, and unified action layouts.',
            style: AppTextStyle.body.copyWith(
              color: colors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ByMetricBadge(label: 'Type', value: typeName),
              ByMetricBadge(label: 'Theme', value: theme['name'] as String),
              ByMetricBadge(
                label: 'Surface',
                value: _useGradient ? 'Gradient' : 'Solid',
              ),
              ByMetricBadge(
                label: 'Radius',
                value: '${_selectedCornerRadius.toInt()}px',
              ),
              ByMetricBadge(
                label: 'Glow Border',
                value: _useOutlineBorder ? 'Active' : 'Off',
              ),
              ByMetricBadge(
                label: 'Duration',
                value: '${_selectedDuration.inMilliseconds}ms',
              ),
              ByMetricBadge(
                label: 'Dismissible',
                value: _barrierDismissible ? 'Backdrop Tap' : 'Locked',
              ),
              ByMetricBadge(
                label: 'Btn Radius',
                value: '${_buttonCornerRadius.toInt()}px',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
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
    return ByShowcaseChoiceChip(
      label: label,
      isSelected: isSelected,
      onTap: onTap,
      icon: icon,
    );
  }
}
