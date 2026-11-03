import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_theme_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';

/// Opens an interactive modal dialog presenting the generated Flutter code
/// snippet matching the current showcase configuration.
void showByCodeDialog(
  BuildContext context, {
  required String componentName,
  required String code,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close Code Dialog',
    barrierColor: Colors.black.withValues(alpha: 0.65),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (ctx, _, _) {
      return SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 640.0,
              maxHeight: 720.0,
            ),
            child: ByCodeDialog(componentName: componentName, code: code),
          ),
        ),
      );
    },
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Modal card displaying a generated Flutter code snippet with copy to clipboard functionality.
class ByCodeDialog extends StatefulWidget {
  final String componentName;
  final String code;

  const ByCodeDialog({
    super.key,
    required this.componentName,
    required this.code,
  });

  @override
  State<ByCodeDialog> createState() => _ByCodeDialogState();
}

class _ByCodeDialogState extends State<ByCodeDialog> {
  bool _isCopied = false;

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _isCopied = true);

    ByToast.showSuccess(
      context,
      title: 'Code Copied',
      message: '${widget.componentName} snippet copied to clipboard!',
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isCopied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = AppThemeStore.instance.isDarkMode(context);

    final dialogBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final dialogBorder = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    const codeBg = Color(0xFF090D16);
    const codeBorder = Color(0xFF1E293B);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: dialogBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: dialogBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header Bar ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 14, 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.cyanAccent],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.componentName,
                      style: AppTextStyle.buttonPrimary.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active Configuration Code',
                          style: AppTextStyle.body.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Ready to paste directly into your Flutter project',
                          style: AppTextStyle.caption.copyWith(
                            color: colors.textMuted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: colors.textMuted,
                      size: 20,
                    ),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFF1E293B)),

            // ── Code Viewport ─────────────────────────────────────────────
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: codeBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: codeBorder, width: 1.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectableText(
                        widget.code,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12.5,
                          height: 1.5,
                          color: Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Footer Action Bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ByButton(
                    variant: ByButtonVariant.ghost,
                    size: ByButtonSize.small,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 10),
                  ByButton(
                    variant: ByButtonVariant.filled,
                    size: ByButtonSize.small,
                    backgroundColor: _isCopied
                        ? AppColors.success
                        : AppColors.primary,
                    prefix: Icon(
                      _isCopied ? Icons.check_rounded : Icons.copy_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    onPressed: _handleCopy,
                    child: Text(_isCopied ? 'Copied!' : 'Copy Code'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
