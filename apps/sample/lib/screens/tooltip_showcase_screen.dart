import 'package:by_ui/by_ui.dart';
import 'package:flutter/material.dart';

import '../models/app_theme_store.dart';
import '../theme/app_theme.dart';
import '../widgets/by_code_dialog.dart';
import '../widgets/by_drawer.dart';
import '../widgets/by_dynamic_border_controls.dart';
import '../widgets/by_showcase_choice_chip.dart';
import '../widgets/by_showcase_control_card.dart';
import '../widgets/by_showcase_header.dart';
import '../widgets/by_showcase_integration_banner.dart';
import '../widgets/by_showcase_preset_card.dart';
import '../widgets/by_showcase_preview_card.dart';
import '../widgets/by_showcase_slider_tile.dart';
import '../widgets/widget_params_dialog.dart';

/// Interactive showcase screen for [ByTooltip], [ByPopover], and [ByHoverCard].
///
/// Follows the canonical ByUI Showcase 5-Layer Hierarchy and responsive design
/// standards to guarantee zero layout overflow on small screens (320dp - 360dp).
class TooltipShowcaseScreen extends StatefulWidget {
  const TooltipShowcaseScreen({super.key});

  @override
  State<TooltipShowcaseScreen> createState() => _TooltipShowcaseScreenState();
}

/// Backwards compatibility alias for [TooltipShowcaseScreen].
typedef HoverCardShowcaseScreen = TooltipShowcaseScreen;

class _TooltipShowcaseScreenState extends State<TooltipShowcaseScreen> {
  // GlobalKey for programmatic control of the hero hover card / tooltip
  final GlobalKey<ByTooltipState> _heroCardKey = GlobalKey<ByTooltipState>();

  // 1. Anchoring & Positioning
  ByTooltipAnchor _anchor = ByTooltipAnchor.cursor;
  double _offsetX = 12.0;
  double _offsetY = 12.0;

  // 2. Timing & Delays
  double _openDelayMs = 150.0;
  double _closeDelayMs = 220.0;
  double _animationDurationMs = 240.0;

  // 3. Animation Transition
  ByTooltipAnimation _animationType = ByTooltipAnimation.fadeAndScale;

  // 4. Dynamic Border Pulse
  final ByPulseBorderConfig _pulseBorderConfig = ByPulseBorderConfig(
    enabled: true,
    origin: ByBorderOrigin.topLeft,
    shadowBlur: 10.0,
    shadowWidth: 2.0,
    colorAIndex: 0,
    colorBIndex: 1,
    shadowColorIndex: 0,
  );

  // 5. Mobile Touch Behavior
  ByMobileTrigger _mobileTrigger = ByMobileTrigger.tap;

  // 6. Geometry & Dismissal
  double _cardWidth = 280.0;
  double _borderRadius = 16.0;
  bool _dismissOnTapOutside = true;
  bool _dismissOnEsc = true;
  bool _dismissOnScroll = true;

  // Active preset tracker (-1 if custom)
  int _activePresetIndex = 0;

  void _resetToDefaults() {
    setState(() {
      _anchor = ByTooltipAnchor.cursor;
      _offsetX = 12.0;
      _offsetY = 12.0;
      _openDelayMs = 150.0;
      _closeDelayMs = 220.0;
      _animationDurationMs = 240.0;
      _animationType = ByTooltipAnimation.fadeAndScale;
      _pulseBorderConfig.enabled = true;
      _pulseBorderConfig.origin = ByBorderOrigin.topLeft;
      _mobileTrigger = ByMobileTrigger.tap;
      _cardWidth = 280.0;
      _borderRadius = 16.0;
      _dismissOnTapOutside = true;
      _dismissOnEsc = true;
      _dismissOnScroll = true;
      _activePresetIndex = 0;
    });
  }

  void _applyPreset(int index) {
    setState(() {
      _activePresetIndex = index;
      switch (index) {
        case 0: // User Profile Card
          _anchor = ByTooltipAnchor.cursor;
          _cardWidth = 280.0;
          _borderRadius = 16.0;
          _animationType = ByTooltipAnimation.fadeAndScale;
          _mobileTrigger = ByMobileTrigger.tap;
          _pulseBorderConfig.enabled = false;
          break;
        case 1: // Repost Menu Options
          _anchor = ByTooltipAnchor.target;
          _cardWidth = 220.0;
          _borderRadius = 14.0;
          _animationType = ByTooltipAnimation.slideAndFade;
          _mobileTrigger = ByMobileTrigger.tap;
          _pulseBorderConfig.enabled = false;
          break;
        case 2: // Compact Tooltip
          _anchor = ByTooltipAnchor.target;
          _cardWidth = 210.0;
          _borderRadius = 12.0;
          _animationType = ByTooltipAnimation.fadeOnly;
          _mobileTrigger = ByMobileTrigger.tap;
          _pulseBorderConfig.enabled = false;
          break;
        case 3: // Neon Pulse Beam
          _anchor = ByTooltipAnchor.target;
          _cardWidth = 280.0;
          _borderRadius = 18.0;
          _animationType = ByTooltipAnimation.bounce;
          _mobileTrigger = ByMobileTrigger.tap;
          _pulseBorderConfig.enabled = true;
          _pulseBorderConfig.origin = ByBorderOrigin.topLeft;
          break;
        case 4: // Mobile Long Press
          _anchor = ByTooltipAnchor.target;
          _cardWidth = 260.0;
          _borderRadius = 14.0;
          _animationType = ByTooltipAnimation.fadeAndScale;
          _mobileTrigger = ByMobileTrigger.longPress;
          _pulseBorderConfig.enabled = false;
          break;
      }
    });
  }

  void _showParamsDialog(BuildContext context) {
    showWidgetParametersDialog(
      context,
      howToTry:
          'Hover your mouse cursor over target triggers on Desktop/Web to view the floating tooltip emerge at pointer coordinates. On touch devices, tap or long-press according to the active mobileTrigger setting.',
      howToTryIcon: Icons.mouse_rounded,
      parameters: const [
        WidgetParamInfo(
          name: 'anchor',
          type: 'ByTooltipAnchor',
          defaultValue: 'ByTooltipAnchor.cursor',
          description:
              'Specifies whether the tooltip anchors to real-time cursor coordinates or target widget bounds.',
        ),
        WidgetParamInfo(
          name: 'mobileTrigger',
          type: 'ByMobileTrigger',
          defaultValue: 'ByMobileTrigger.tap',
          description:
              'Defines touch activation mode on mobile/touch screens (tap, longPress, or none).',
        ),
        WidgetParamInfo(
          name: 'builder',
          type: 'WidgetBuilder',
          defaultValue: 'required',
          description:
              'Builder callback providing the customizable tooltip content layout.',
        ),
        WidgetParamInfo(
          name: 'dynamicBorder',
          type: 'ByDynamicBorder?',
          defaultValue: 'null',
          description:
              'Optional traveling laser pulse border running along the perimeter.',
        ),
        WidgetParamInfo(
          name: 'openDelay',
          type: 'Duration',
          defaultValue: '150ms',
          description:
              'Debounce duration before opening to prevent jitter during fast sweeps.',
        ),
        WidgetParamInfo(
          name: 'closeDelay',
          type: 'Duration',
          defaultValue: '220ms',
          description:
              'Grace period before closing allowing cursor to move into card.',
        ),
        WidgetParamInfo(
          name: 'isInteractive',
          type: 'bool',
          defaultValue: 'true',
          description:
              'Whether moving pointer into card keeps it open and clickable.',
        ),
        WidgetParamInfo(
          name: 'dismissOnTapOutside',
          type: 'bool',
          defaultValue: 'true',
          description:
              'Whether tapping anywhere outside the card dismisses it immediately.',
        ),
        WidgetParamInfo(
          name: 'dismissOnScroll',
          type: 'bool',
          defaultValue: 'true',
          description:
              'Whether scrolling the page immediately dismisses the card.',
        ),
        WidgetParamInfo(
          name: 'dismissOnEsc',
          type: 'bool',
          defaultValue: 'true',
          description:
              'Whether pressing the Escape key dismisses the card on desktop.',
        ),
      ],
    );
  }

  void _showCodeSnippetDialog(BuildContext context) {
    const code = '''ByTooltip(
  anchor: ByTooltipAnchor.cursor,
  mobileTrigger: ByMobileTrigger.tap,
  offset: const Offset(12, 12),
  width: 280,
  borderRadius: BorderRadius.circular(16),
  dynamicBorder: const ByDynamicBorder(
    enabled: true,
    colors: [Colors.cyan, Colors.indigo],
    origin: ByBorderOrigin.topLeft,
  ),
  builder: (context) => Container(
    padding: const EdgeInsets.all(14),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('User Profile Preview', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Tooltip positioned at exact cursor coordinates.'),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => ByTooltipScope.close(context),
          child: const Text('Close'),
        ),
      ],
    ),
  ),
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('Hover or Tap Me'),
  ),
);''';

    showByCodeDialog(context, componentName: 'ByTooltip', code: code);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        final bool isDark = AppThemeStore.instance.isDarkMode(context);
        final AppColorPalette colors = AppColors.of(context);

        return ByScrollScope(
          child: Scaffold(
            backgroundColor: colors.scaffoldBg,
            extendBodyBehindAppBar: true,
            appBar: ByAppBar(
              child: ByShowcaseHeader(
                componentName: 'ByTooltip',
                onReset: _resetToDefaults,
                onOpenParams: () => _showParamsDialog(context),
                onViewCode: () => _showCodeSnippetDialog(context),
              ),
            ),
            drawer: const ByDrawer(activeComponent: 'ByTooltip'),
            body: ListView(
              padding: EdgeInsets.fromLTRB(
                12,
                ByAppBar.getContentTopPadding(context, extra: 10),
                12,
                24,
              ),
              children: [
                // ── LAYER 1: Active Configuration Preview ──────────────────
                _buildLayer1PreviewCard(),
                const SizedBox(height: 14),

                // ── LAYER 2: Preset Example Card ───────────────────────────
                _buildLayer2PresetCard(),
                const SizedBox(height: 14),

                // ── LAYER 3: Integrated with ByDynamicBorder ───────────────
                const ByShowcaseIntegrationBanner(
                  componentName: 'ByDynamicBorder',
                  description:
                      'ByTooltip seamlessly integrates ByDynamicBorder for perimeter laser sweeps on emergence.',
                ),
                const SizedBox(height: 14),

                // ── LAYER 4: Standalone Widget Display (Hero Live Preview) ─
                _buildLayer4InteractivePreview(colors, isDark),
                const SizedBox(height: 14),

                // ── LAYER 5: Numbered Setup Sections ───────────────────────
                _buildLayer5ControlCards(colors),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── LAYER 1: Active Configuration Preview ─────────────────────────
  Widget _buildLayer1PreviewCard() {
    return ByShowcasePreviewCard(
      icon: Icons.chat_bubble_outline_rounded,
      subtitle: 'Interactive Contextual Tooltip & Hover Card',
      description:
          'Spatial floating overlay component: displays rich, interactive tooltips and popovers across mobile, desktop, and web with dynamic laser border integration.',
      metrics: [
        ByMetricBadge(
          label: 'Anchor',
          value: _anchor == ByTooltipAnchor.cursor ? 'Cursor' : 'Target',
        ),
        ByMetricBadge(label: 'Anim', value: _animationType.name),
        ByMetricBadge(label: 'Width', value: '${_cardWidth.toInt()}px'),
        ByMetricBadge(label: 'Touch', value: _mobileTrigger.name.toUpperCase()),
        ByMetricBadge(
          label: 'Pulse',
          value: _pulseBorderConfig.enabled ? 'ON' : 'OFF',
        ),
      ],
    );
  }

  // ── LAYER 2: Preset Example Card ───────────────────────────────────────
  Widget _buildLayer2PresetCard() {
    return ByShowcasePresetCard(
      presets: [
        ByShowcasePresetItem(
          label: 'User Profile Card',
          themeColor: AppColors.primary,
          isSelected: _activePresetIndex == 0,
          onTap: () => _applyPreset(0),
        ),
        ByShowcasePresetItem(
          label: 'Repost Menu Options',
          themeColor: AppColors.success,
          isSelected: _activePresetIndex == 1,
          onTap: () => _applyPreset(1),
        ),
        ByShowcasePresetItem(
          label: 'Compact Tooltip',
          themeColor: AppColors.cyanAccent,
          isSelected: _activePresetIndex == 2,
          onTap: () => _applyPreset(2),
        ),
        ByShowcasePresetItem(
          label: 'Neon Pulse Beam',
          themeColor: AppColors.primaryAccent,
          isSelected: _activePresetIndex == 3,
          onTap: () => _applyPreset(3),
        ),
        ByShowcasePresetItem(
          label: 'Mobile Long Press',
          themeColor: const Color(0xFFF59E0B),
          isSelected: _activePresetIndex == 4,
          onTap: () => _applyPreset(4),
        ),
      ],
    );
  }

  // ── LAYER 4: Standalone Widget Display (Hero Live Preview) ───────────────
  Widget _buildLayer4InteractivePreview(AppColorPalette colors, bool isDark) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Standard ByUI Header: Icon + Section Title + Trigger Mode Badge
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.touch_app_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'INTERACTIVE PREVIEW',
                            style: AppTextStyle.sectionHeader.copyWith(
                              color: colors.textPrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _mobileTrigger == ByMobileTrigger.longPress
                          ? 'HOLD 300MS'
                          : 'TAP / HOVER',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 1. Hero Active Target (Bound to Layer 5 Controls & Active Preset)
              _buildHeroActiveTarget(colors, isDark),

              const SizedBox(height: 14),
              Divider(color: colors.borderSubtle, height: 1),
              const SizedBox(height: 12),

              // 2. Contextual Quick Targets (Symmetric, text-only pills in responsive Wrap)
              Text(
                'COMMON TOOLTIP USE CASES',
                style: AppTextStyle.fieldLabel.copyWith(
                  color: colors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              _buildContextualQuickTargets(colors, isDark),
            ],
          ),
        ),
      ),
    );
  }

  /// Full-width responsive hero target bound to all active Layer 5 parameters.
  Widget _buildHeroActiveTarget(AppColorPalette colors, bool isDark) {
    return ByTooltip(
      key: _heroCardKey,
      anchor: _anchor,
      offset: Offset(_offsetX, _offsetY),
      openDelay: Duration(milliseconds: _openDelayMs.toInt()),
      closeDelay: Duration(milliseconds: _closeDelayMs.toInt()),
      animationDuration: Duration(milliseconds: _animationDurationMs.toInt()),
      animationType: _animationType,
      width: _cardWidth,
      borderRadius: BorderRadius.circular(_borderRadius),
      backgroundColor: colors.cardBg,
      border: Border.all(color: colors.border),
      dynamicBorder: _pulseBorderConfig.enabled
          ? ByDynamicBorder(
              enabled: true,
              origin: _pulseBorderConfig.origin,
              width: _pulseBorderConfig.shadowWidth,
              shadowBlur: _pulseBorderConfig.shadowBlur,
              colors: [
                AppColors
                    .toastThemePresets[_pulseBorderConfig.colorAIndex]
                    .color,
                AppColors
                    .toastThemePresets[_pulseBorderConfig.colorBIndex]
                    .color,
              ],
            )
          : null,
      mobileTrigger: _mobileTrigger,
      dismissOnTapOutside: _dismissOnTapOutside,
      dismissOnEsc: _dismissOnEsc,
      dismissOnScroll: _dismissOnScroll,
      builder: (context) => _buildLiveCardContent(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.5),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.touch_app_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _mobileTrigger == ByMobileTrigger.longPress
                    ? 'Long Press or Hover Me (Active Setup)'
                    : 'Hover or Tap Me (Active Setup)',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Symmetrical, text-only contextual triggers arranged horizontally in a balanced [Row].
  Widget _buildContextualQuickTargets(AppColorPalette colors, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildSymmetricTrigger(
            label: 'User Profile',
            accentColor: AppColors.primary,
            colors: colors,
            builder: (context) => _buildProfilePreviewLayout(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSymmetricTrigger(
            label: 'Action Menu',
            accentColor: AppColors.success,
            colors: colors,
            builder: (context) => _buildRepostMenuLayout(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSymmetricTrigger(
            label: 'Info Tooltip',
            accentColor: AppColors.cyanAccent,
            colors: colors,
            builder: (context) => _buildVerifiedTooltipLayout(context),
          ),
        ),
      ],
    );
  }

  /// Helper building balanced, symmetric, text-only pill triggers.
  Widget _buildSymmetricTrigger({
    required String label,
    required Color accentColor,
    required AppColorPalette colors,
    required WidgetBuilder builder,
  }) {
    return ByTooltip(
      width: 260,
      borderRadius: BorderRadius.circular(14),
      mobileTrigger: _mobileTrigger,
      backgroundColor: colors.cardBg,
      border: Border.all(color: colors.border),
      builder: builder,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: accentColor.withValues(alpha: 0.35)),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: AppTextStyle.pillButton.copyWith(color: accentColor),
          ),
        ),
      ),
    );
  }

  // ── CARD CONTENT BUILDERS (FULLY THEME ADAPTIVE) ──────────────────────────

  /// Content for the Hero Active Tooltip.
  Widget _buildLiveCardContent(BuildContext context) {
    final colors = AppColors.of(context);

    // If an active preset is selected, render the preset-specific card layout
    if (_activePresetIndex == 0) {
      return _buildProfilePreviewLayout(context);
    } else if (_activePresetIndex == 1) {
      return _buildRepostMenuLayout(context);
    } else if (_activePresetIndex == 2) {
      return _buildVerifiedTooltipLayout(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.cyanAccent,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Tooltip Preview',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Interactive Overlay Bridge',
                      style: TextStyle(color: colors.textMuted, fontSize: 10.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: colors.textMuted,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => ByTooltipScope.close(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Emerges at (${_offsetX.toInt()}, ${_offsetY.toInt()}) relative to ${_anchor == ByTooltipAnchor.cursor ? 'pointer position' : 'target bounds'}. Move cursor inside to keep alive.',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 6,
            children: [
              TextButton(
                onPressed: () => ByTooltipScope.close(context),
                style: TextButton.styleFrom(
                  foregroundColor: colors.textSecondary,
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Dismiss', style: TextStyle(fontSize: 11.5)),
              ),
              ElevatedButton(
                onPressed: () {
                  ByTooltipScope.close(context);
                  ByToast.showSuccess(
                    context,
                    title: 'Action Triggered',
                    message: 'Clicked inside ByTooltip successfully!',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Confirm', style: TextStyle(fontSize: 11.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Profile preview popover layout.
  Widget _buildProfilePreviewLayout(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Sarah Connor',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.cyanAccent,
                          size: 14,
                        ),
                      ],
                    ),
                    Text(
                      '@sarah_ux',
                      style: TextStyle(color: colors.textMuted, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Lead Systems Architect specializing in spatial micro-interactions and Flutter design systems.',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1,420 ',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5,
                    ),
                  ),
                  Text(
                    'Following',
                    style: TextStyle(color: colors.textMuted, fontSize: 11),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '18.4K ',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5,
                    ),
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(color: colors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                ByTooltipScope.close(context);
                ByToast.showSuccess(
                  context,
                  title: 'Followed',
                  message: 'Now following @sarah_ux!',
                );
              },
              child: const Text('Follow', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  /// Repost action menu popover layout.
  Widget _buildRepostMenuLayout(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = colors.isDark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            hoverColor: AppColors.primary.withValues(
              alpha: isDark ? 0.12 : 0.06,
            ),
            onTap: () {
              ByTooltipScope.close(context);
              ByToast.showSuccess(
                context,
                title: 'Reposted',
                message: 'Post successfully shared to your feed!',
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.repeat_rounded,
                    color: colors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Repost',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Instantly share to feed',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: colors.borderSubtle, height: 1),
          InkWell(
            hoverColor: AppColors.primary.withValues(
              alpha: isDark ? 0.12 : 0.06,
            ),
            onTap: () {
              ByTooltipScope.close(context);
              ByToast.showInfo(
                context,
                title: 'Quote Draft',
                message: 'Quote draft composer opened.',
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    color: colors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Repost with quotes',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Add your thoughts',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Verified tooltip popover layout.
  Widget _buildVerifiedTooltipLayout(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_rounded,
            color: AppColors.cyanAccent,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Verified ByUI core component creator.',
              style: TextStyle(color: colors.textPrimary, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }

  // ── LAYER 5: Standardized Setup Sections ───────────────────────────
  Widget _buildLayer5ControlCards(AppColorPalette colors) {
    return Column(
      children: [
        // Section 1: Anchoring & Position
        ByShowcaseControlCard(
          title: '1. ANCHORING & OFFSET',
          icon: Icons.my_location_rounded,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ByShowcaseChoiceChip(
                    label: 'Cursor Anchor',
                    isSelected: _anchor == ByTooltipAnchor.cursor,
                    onTap: () => setState(() {
                      _anchor = ByTooltipAnchor.cursor;
                      _activePresetIndex = -1;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ByShowcaseChoiceChip(
                    label: 'Target Anchor',
                    isSelected: _anchor == ByTooltipAnchor.target,
                    onTap: () => setState(() {
                      _anchor = ByTooltipAnchor.target;
                      _activePresetIndex = -1;
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ByShowcaseSliderTile(
              label: 'Offset X (px)',
              value: _offsetX,
              min: 0.0,
              max: 40.0,
              divisions: 20,
              onChanged: (val) => setState(() {
                _offsetX = val;
                _activePresetIndex = -1;
              }),
            ),
            ByShowcaseSliderTile(
              label: 'Offset Y (px)',
              value: _offsetY,
              min: 0.0,
              max: 40.0,
              divisions: 20,
              onChanged: (val) => setState(() {
                _offsetY = val;
                _activePresetIndex = -1;
              }),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Section 2: Timing & Delays
        ByShowcaseControlCard(
          title: '2. TIMING & HOVER BRIDGE',
          icon: Icons.timer_rounded,
          children: [
            ByShowcaseSliderTile(
              label: 'Open Delay (ms)',
              value: _openDelayMs,
              min: 0.0,
              max: 500.0,
              divisions: 25,
              onChanged: (val) => setState(() {
                _openDelayMs = val;
                _activePresetIndex = -1;
              }),
            ),
            ByShowcaseSliderTile(
              label: 'Close Delay / Grace Period (ms)',
              value: _closeDelayMs,
              min: 50.0,
              max: 600.0,
              divisions: 22,
              onChanged: (val) => setState(() {
                _closeDelayMs = val;
                _activePresetIndex = -1;
              }),
            ),
            ByShowcaseSliderTile(
              label: 'Animation Duration (ms)',
              value: _animationDurationMs,
              min: 100.0,
              max: 600.0,
              divisions: 20,
              onChanged: (val) => setState(() {
                _animationDurationMs = val;
                _activePresetIndex = -1;
              }),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Section 3: Transition Animations
        ByShowcaseControlCard(
          title: '3. TRANSITION ANIMATIONS',
          icon: Icons.animation_rounded,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ByShowcaseChoiceChip(
                    label: 'Fade & Scale',
                    isSelected:
                        _animationType == ByTooltipAnimation.fadeAndScale,
                    onTap: () => setState(() {
                      _animationType = ByTooltipAnimation.fadeAndScale;
                      _activePresetIndex = -1;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ByShowcaseChoiceChip(
                    label: 'Slide & Fade',
                    isSelected:
                        _animationType == ByTooltipAnimation.slideAndFade,
                    onTap: () => setState(() {
                      _animationType = ByTooltipAnimation.slideAndFade;
                      _activePresetIndex = -1;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ByShowcaseChoiceChip(
                    label: 'Fade Only',
                    isSelected: _animationType == ByTooltipAnimation.fadeOnly,
                    onTap: () => setState(() {
                      _animationType = ByTooltipAnimation.fadeOnly;
                      _activePresetIndex = -1;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ByShowcaseChoiceChip(
                    label: 'Bounce',
                    isSelected: _animationType == ByTooltipAnimation.bounce,
                    onTap: () => setState(() {
                      _animationType = ByTooltipAnimation.bounce;
                      _activePresetIndex = -1;
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Section 4: Dynamic Border Pulse
        ByDynamicBorderControls(
          title: '4. PULSE DYNAMIC BORDER (ONE-SHOT TRAVELING BEAM)',
          config: _pulseBorderConfig,
          onChanged: () => setState(() {
            _activePresetIndex = -1;
          }),
          actionButton: ByButton(
            width: double.infinity,
            variant: ByButtonVariant.filled,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            borderWidth: 0.0,
            prefix: const Icon(Icons.bolt_rounded, size: 20),
            onPressed: () {
              setState(() {
                _pulseBorderConfig.enabled = true;
                _activePresetIndex = -1;
              });
              _heroCardKey.currentState?.show();
            },
            child: const Text('Open Tooltip with Pulse Border'),
          ),
        ),
        const SizedBox(height: 12),

        // Section 5: Mobile Touch Behavior
        ByShowcaseControlCard(
          title: '5. MOBILE TOUCH BEHAVIORS',
          icon: Icons.touch_app_rounded,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ByShowcaseChoiceChip(
                    label: 'Tap to Toggle (Default)',
                    isSelected: _mobileTrigger == ByMobileTrigger.tap,
                    onTap: () => setState(() {
                      _mobileTrigger = ByMobileTrigger.tap;
                      _activePresetIndex = -1;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ByShowcaseChoiceChip(
                    label: 'Long Press (Hold ~300ms)',
                    isSelected: _mobileTrigger == ByMobileTrigger.longPress,
                    onTap: () => setState(() {
                      _mobileTrigger = ByMobileTrigger.longPress;
                      _activePresetIndex = -1;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ByShowcaseChoiceChip(
                    label: 'Disabled on Touch',
                    isSelected: _mobileTrigger == ByMobileTrigger.none,
                    onTap: () => setState(() {
                      _mobileTrigger = ByMobileTrigger.none;
                      _activePresetIndex = -1;
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Configures how touch devices (smartphones/tablets) trigger the tooltip card when mouse hover is unavailable.',
              style: TextStyle(
                fontSize: 11,
                color: colors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Section 6: Dimensions & Dismissal
        ByShowcaseControlCard(
          title: '6. DIMENSIONS & DISMISSAL BEHAVIORS',
          icon: Icons.aspect_ratio_rounded,
          children: [
            ByShowcaseSliderTile(
              label: 'Width (px)',
              value: _cardWidth,
              min: 180.0,
              max: 400.0,
              divisions: 22,
              onChanged: (val) => setState(() {
                _cardWidth = val;
                _activePresetIndex = -1;
              }),
            ),
            ByShowcaseSliderTile(
              label: 'Border Radius (px)',
              value: _borderRadius,
              min: 6.0,
              max: 28.0,
              divisions: 22,
              onChanged: (val) => setState(() {
                _borderRadius = val;
                _activePresetIndex = -1;
              }),
            ),
            const SizedBox(height: 8),
            ByShowcaseSwitchTile(
              title: 'Dismiss on Tap Outside',
              subtitle: 'Closes card when tapping outside the surface',
              value: _dismissOnTapOutside,
              onChanged: (val) => setState(() => _dismissOnTapOutside = val),
            ),
            const SizedBox(height: 8),
            ByShowcaseSwitchTile(
              title: 'Dismiss on Escape Key (Desktop/Web)',
              subtitle: 'Closes card when user hits Esc key',
              value: _dismissOnEsc,
              onChanged: (val) => setState(() => _dismissOnEsc = val),
            ),
            const SizedBox(height: 8),
            ByShowcaseSwitchTile(
              title: 'Dismiss on Page Scroll',
              subtitle: 'Closes card as soon as scroll starts',
              value: _dismissOnScroll,
              onChanged: (val) => setState(() => _dismissOnScroll = val),
            ),
          ],
        ),
      ],
    );
  }
}
