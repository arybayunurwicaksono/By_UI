import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
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
  ByDialog.alert(
    context,
    // Dialog murni tanpa judul dan tanpa ikon header (strictly title-less parameter list)
    icon: null,
    title: null,
    message: null,
    buttonText: 'Close',
    buttonColor: AppColors.primary,
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
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
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
                              color: AppColors.cyanAccent,
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
                              color: AppColors.error.withValues(alpha: 0.2),
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
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      param.type,
                      style: AppTextStyle.badge.copyWith(
                        color: const Color(0xFFE2E8F0),
                        fontSize: 10,
                        fontFamily: 'monospace',
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
                  color: const Color(0xFF94A3B8),
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
                        color: const Color(0xFF64748B),
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        param.defaultValue!,
                        style: AppTextStyle.caption.copyWith(
                          color: const Color(0xFF38BDF8),
                          fontSize: 10.5,
                          fontFamily: 'monospace',
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
