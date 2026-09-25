import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable toolbar header widget placed inside [ByAppBar] across all showcase screens.
///
/// Implements the uniform ByUI branding, hamburger drawer trigger, and uniform
/// Reset and Help action buttons according to Rules Section 6.1.
class ByShowcaseHeader extends StatelessWidget {
  /// The component name displayed inside the signature gradient brand pill.
  final String? componentName;

  /// The suffix title text (defaults to 'Showcase').
  final String titleSuffix;

  /// Callback executed when tapping the 'Reset to Defaults' action button.
  final VoidCallback? onReset;

  /// Callback executed when tapping the 'Widget Parameters' documentation action button.
  final VoidCallback? onOpenParams;

  /// Optional extra action widgets placed before the default Reset and Help buttons.
  final List<Widget>? extraActions;

  /// Optional leading widget overriding the default drawer hamburger button.
  final Widget? leading;

  /// Whether to automatically imply the leading drawer trigger.
  final bool automaticallyImplyLeading;

  /// Whether to center the title row horizontally. Defaults to false.
  final bool? centerTitle;

  /// Optional gradient overriding the default brand badge gradient ([AppColors.primary, AppColors.primaryAccent]).
  final Gradient? pillGradient;

  /// Optional action icon color overriding the default [AppColors.primary].
  final Color? actionColor;

  const ByShowcaseHeader({
    super.key,
    this.componentName,
    this.titleSuffix = 'Showcase',
    this.onReset,
    this.onOpenParams,
    this.extraActions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle,
    this.pillGradient,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final Gradient effectivePillGradient = pillGradient ??
        const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryAccent],
        );
    final Color effectiveActionColor = actionColor ?? AppColors.primary;
    final bool isCentered = centerTitle ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
            children: [
              // 1. Leading Drawer Trigger
              leading ??
                  (automaticallyImplyLeading
                      ? Builder(
                          builder: (ctx) => IconButton(
                            icon: Icon(
                              AppIcons.menu,
                              color: colors.textPrimary,
                            ),
                            onPressed: () => Scaffold.of(ctx).openDrawer(),
                          ),
                        )
                      : const SizedBox(width: 12)),

              const SizedBox(width: 4),

              // 2. Signature Gradient Brand Badge Pill & Suffix Title
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    if (componentName != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          gradient: effectivePillGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          componentName!,
                          style: AppTextStyle.buttonPrimary.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        titleSuffix,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: colors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Action Buttons (Uniform Rule 6.1)
              ...?extraActions,
              if (onReset != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Reset to Defaults',
                  icon: Icon(AppIcons.reset, color: effectiveActionColor),
                  onPressed: onReset,
                ),
              if (onOpenParams != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Widget Parameters',
                  icon: Icon(AppIcons.help, color: effectiveActionColor),
                  onPressed: onOpenParams,
                ),
              const SizedBox(width: 4),
            ],
          ),
        );
  }
}
