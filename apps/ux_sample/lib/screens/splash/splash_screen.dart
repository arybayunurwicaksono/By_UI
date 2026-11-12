import 'dart:async';
import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_textstyle.dart';
import '../auth/login_screen.dart';

/// Splash screen showcasing ByUI brand logo with flowing dynamic border beam.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        _navigateToLogin();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secondaryAnim) => const LoginScreen(),
        transitionsBuilder: (context, anim, secondaryAnim, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isCompact = mediaQuery.size.width < 360;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 16.0 : 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Version Badge
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            'ByUI v${ByUI.version}',
                            style: AppTextStyle.badge.copyWith(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ),

                      // Center Brand Identity with Traveling Dynamic Border Beam
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ByDynamicBorderLayer(
                            config: const ByDynamicBorder(
                              enabled: true,
                              width: 2.5,
                              shadowBlur: 10.0,
                              duration: Duration(milliseconds: 2200),
                              gradient: LinearGradient(
                                colors: AppColors.laserColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: isCompact ? 110 : 130,
                              height: isCompact ? 110 : 130,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/logo_by_ui_showcase.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.primaryLight,
                                      child: const Icon(
                                        Icons.layers_rounded,
                                        size: 48,
                                        color: AppColors.primary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'ByUI Pulse',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.display,
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'End-to-End By_UI Component Journey',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Bottom Enter Action (Manual fallback if timer not waited)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: ByButton(
                          width: double.infinity,
                          variant: ByButtonVariant.filled,
                          size: ByButtonSize.large,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          borderWidth: 0,
                          suffix: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: _navigateToLogin,
                          child: const Text('Get Started'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
