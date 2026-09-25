import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../models/app_theme_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';

/// Metadata definition of a single widget property/parameter.
class WidgetParamInfo {
  final String name;
  final String type;
  final String description;
  final String? defaultValue;
  final bool isRequired;

  const WidgetParamInfo({
    required this.name,
    required this.type,
    required this.description,
    this.defaultValue,
    this.isRequired = false,
  });
}

/// Opens a title-less [ByDialog] presenting only the list of widget parameters.
void showWidgetParametersDialog(
  BuildContext context, {
  required List<WidgetParamInfo> parameters,
}) {
  final colors = AppColors.of(context);
  final isDark = AppThemeStore.instance.isDarkMode(context);

  ByDialog.alert(
    context,
    // Dialog murni tanpa judul dan tanpa ikon header (strictly title-less parameter list)
    icon: null,
    title: null,
    message: null,
    buttonText: 'Close',
    buttonColor: AppColors.primary,
    backgroundColor: colors.cardBg,
    textColor: colors.textPrimary,
    border: Border.all(color: colors.border, width: 1.2),
    maxWidth: 440.0,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: parameters.asMap().entries.map((entry) {
        final int index = entry.key;
        final WidgetParamInfo param = entry.value;

        return Container(
          margin: EdgeInsets.only(
            bottom: index == parameters.length - 1 ? 0 : 10,
          ),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : colors.chipBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colors.border,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Parameter name on start, type badge at the END horizontally
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            param.name,
                            style: AppTextStyle.captionBold.copyWith(
                              color: isDark
                                  ? AppColors.cyanAccent
                                  : const Color(0xFF0284C7),
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (param.isRequired) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'REQUIRED',
                              style: AppTextStyle.badge.copyWith(
                                color: AppColors.error,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Type badge aligned horizontally to the END
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : colors.chipSelectedBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      param.type,
                      style: AppTextStyle.badge.copyWith(
                        color: colors.textSecondary,
                        fontSize: 10,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Parameter description in professional English
              Text(
                param.description,
                style: AppTextStyle.caption.copyWith(
                  color: colors.textSecondary,
                  fontSize: 11.5,
                  height: 1.35,
                ),
              ),
              if (param.defaultValue != null) ...[
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Default:',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textMuted,
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        param.defaultValue!,
                        style: AppTextStyle.caption.copyWith(
                          color: isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7),
                          fontSize: 10.5,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      }).toList(),
    ),
  );
}
