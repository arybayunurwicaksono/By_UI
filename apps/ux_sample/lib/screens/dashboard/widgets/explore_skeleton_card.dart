import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../../theme/app_colors.dart';

/// Skeleton placeholder card for explore feed posts utilizing [ByAutoShimmer] and [ByBone].
class ExploreSkeletonCard extends StatelessWidget {
  final bool isLoading;

  const ExploreSkeletonCard({super.key, this.isLoading = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ByAutoShimmer(
        isLoading: isLoading,
        borderRadius: BorderRadius.circular(18),
        enableDynamicBorderPulse: true,
        enableLaserReveal: true,
        laserColors: AppColors.laserColors,
        backgroundColor: Colors.white,
        borderColor: AppColors.cardBorder,
        borderWidth: 1.0,
        padding: const EdgeInsets.all(16.0),
        skeletonBuilder: (context) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Author header skeleton
              Row(
                children: [
                  ByBone.circular(size: 40),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ByBone.text(width: 130, height: 14),
                        SizedBox(height: 6),
                        ByBone.text(width: 85, height: 11),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              // 2. Post caption text lines
              ByBone.text(width: double.infinity, height: 13),
              SizedBox(height: 6),
              ByBone.text(width: 220, height: 13),

              SizedBox(height: 14),

              // 3. Post media banner block
              ByBone.rect(
                width: double.infinity,
                height: 140,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),

              SizedBox(height: 14),

              // 4. Action pills skeleton
              Row(
                children: [
                  ByBone.rect(
                    width: 54,
                    height: 26,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  SizedBox(width: 10),
                  ByBone.rect(
                    width: 54,
                    height: 26,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  SizedBox(width: 10),
                  ByBone.rect(
                    width: 54,
                    height: 26,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  Spacer(),
                  ByBone.circular(size: 24),
                ],
              ),
            ],
          );
        },
        child: const SizedBox.shrink(),
      ),
    );
  }
}
