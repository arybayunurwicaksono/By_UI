import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyle.dart';

/// Clean, responsive search bar with instant clear button and subtle ambient shadow.
class DashboardSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const DashboardSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1.0),
            child: Icon(
              Icons.search_rounded,
              size: 18.5,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlignVertical: TextAlignVertical.center,
              style: AppTextStyle.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
                height: 1.15,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.only(bottom: 2.5),
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: AppTextStyle.body.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13.5,
                  height: 1.15,
                ),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
                splashRadius: 16,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                  onClear?.call();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
