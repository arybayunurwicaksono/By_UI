import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_textstyle.dart';
import '../dashboard/dashboard_screen.dart';
import 'widgets/auth_text_field.dart';

/// Clean modern login screen utilizing ByCard, ByButton, and ByToast with circular morphing.
/// Features a responsive horizontal 6:4 split card with random wallpaper on Desktop/Web,
/// and a vertical card on a vibrant Cyan-Blue gradient on Mobile.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(
    text: 'alex.rivera@byui.dev',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'password123',
  );
  bool _obscurePassword = true;
  bool _rememberMe = true;

  static const List<String> _wallpapers = [
    'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1200&auto=format&fit=crop', // Abstract 3D fluid cyan
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1200&auto=format&fit=crop', // Modern architecture interior
    'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=1200&auto=format&fit=crop', // Tech workspace ambient
    'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?q=80&w=1200&auto=format&fit=crop', // Geometric glass light
    'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?q=80&w=1200&auto=format&fit=crop', // Cyan blue silk gradient
  ];
  late final String _selectedWallpaper;

  @override
  void initState() {
    super.initState();
    _selectedWallpaper = _wallpapers[math.Random().nextInt(_wallpapers.length)];
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoAccount() {
    setState(() {
      _emailController.text = 'alex.rivera@byui.dev';
      _passwordController.text = 'password123';
    });
    ByToast.show(
      context,
      message: 'Demo account Alex Rivera filled automatically',
      icon: Icons.auto_awesome_rounded,
      backgroundColor: AppColors.primaryDark,
    );
  }

  Future<void> _handleLogin() async {
    // Simulate real auth network latency to showcase perfect circle morphing & dynamic border
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    ByToast.show(
      context,
      message: 'Welcome back, Alex!',
      icon: Icons.check_circle_rounded,
      backgroundColor: AppColors.success,
    );

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secondaryAnim) => const DashboardScreen(),
        transitionsBuilder: (context, anim, secondaryAnim, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  /// Reusable input fields & action buttons shared across Mobile & Desktop cards
  Widget _buildFormFields({required bool isDesktop, required bool isCompact}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthTextField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'name@domain.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: isDesktop ? 12 : 14),
        AuthTextField(
          controller: _passwordController,
          label: 'Password',
          hint: '••••••••',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: 10),

        // Remember Me & Forgot Password (Safe responsive layout)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _rememberMe = !_rememberMe;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (val) {
                          setState(() {
                            _rememberMe = val ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Flexible(
                      child: Text(
                        'Remember me',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ByToast.show(
                  context,
                  message: 'Password reset link sent to email',
                  icon: Icons.info_outline_rounded,
                  backgroundColor: AppColors.info,
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                'Forgot password?',
                style: AppTextStyle.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 16 : 20),

        // Primary Action Button: Full Width, Reduced Height (40px), Morphs into Perfect Circle (40x40)
        Center(
          child: ByButton(
            width: double.infinity,
            height: 40.0,
            size: ByButtonSize.small,
            variant: ByButtonVariant.filled,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            borderWidth: 0,
            enableLoadingPulseGlow: false, // Pure border, no shadow blur
            loadingPulseColors: const [Colors.white, AppColors.cyanAccent],
            onPressed: _handleLogin,
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Sign In'),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 1-Click Demo Fill Button (Compact friendly)
        Center(
          child: ByButton(
            variant: ByButtonVariant.ghost,
            size: ByButtonSize.small,
            foregroundColor: AppColors.primaryDark,
            prefix: isCompact
                ? null
                : const Icon(
                    Icons.bolt_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
            onPressed: _fillDemoAccount,
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Fill Demo Account'),
            ),
          ),
        ),
      ],
    );
  }

  /// Procedural gradient fallback when wallpaper image is loading or offline
  Widget _buildFallbackWallpaper() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF0E7490), // Cyan 700
            Color(0xFF1E3A8A), // Blue 900
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.cyanAccent.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.layers_rounded,
                color: AppColors.cyanAccent,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ByUI Pulse',
              style: AppTextStyle.heading.copyWith(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Left-side wallpaper view with bottom gradient overlay and architectural tagline
  Widget _buildWallpaperSide() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22),
        bottomLeft: Radius.circular(22),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // High-res curated image with fallback
          Image.network(
            _selectedWallpaper,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildFallbackWallpaper(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildFallbackWallpaper();
            },
          ),
          // Dark & Cyan subtle gradient overlay from bottom to top for contrast
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Brand Badge and Tagline Quote at the bottom of the wallpaper
          Positioned(
            left: 28,
            right: 28,
            bottom: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.cyanAccent,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'ByUI Pulse v2.0',
                        style: AppTextStyle.badge.copyWith(
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Next-Generation Reactive Design Architecture',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore fluid micro-interactions, dynamic sensor borders, and responsive desktop workspaces.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Right-side form layout on desktop enclosing logo, greeting, and input fields
  Widget _buildDesktopFormSide() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // App Brand Logo Inside Card
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.asset(
                    'assets/images/logo_by_ui_showcase.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.layers_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome Back',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.heading.copyWith(fontSize: 19),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sign in to access your workspace',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // All inputs and action buttons
          _buildFormFields(isDesktop: true, isCompact: false),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDesktop = mediaQuery.size.width >= 900;
    final isCompact = mediaQuery.size.width < 360;

    // Desktop Layout: Horizontal 6:4 Rectangle Card on White Background
    if (isDesktop) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Horizontal 6:4 Split Card with Dynamic Border and Thick Shadow
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 960,
                      minHeight: 540,
                      maxHeight: 580,
                    ),
                    child: ByCard.dynamicSensor(
                      backgroundColor: AppColors.cardSurface,
                      borderGradient: AppColors.cyanBlueGradient,
                      borderWidth: 1.5,
                      borderRadius: BorderRadius.circular(24),
                      padding: EdgeInsets.zero,
                      enableSensor: true,
                      enableHoverTilt: true,
                      shadowGradient: const LinearGradient(
                        colors: [Color(0x2500E5FF), Color(0x252563EB)],
                      ),
                      shadowBlur: 28.0,
                      maxShadowOffset: 8.0,
                      dynamicBorder: const ByDynamicBorder(
                        enabled: true,
                        width: 2.0,
                        shadowBlur: 8.0,
                        shadowWidth: 2.0,
                        shadowColor: Color(0x3300E5FF),
                        duration: Duration(milliseconds: 2000),
                        repeatCount: 1, // Pulse 1 kali saja saat entrance
                        autoStart: true,
                        origin: ByBorderOrigin.topCenter,
                        beamLength: 0.28,
                        colors: AppColors.cyanBlueLaserColors,
                        gradient: AppColors.cyanBlueGradient,
                        sensorResumeDelay: Duration(milliseconds: 200),
                        sensorEntranceDuration: Duration(milliseconds: 400),
                        sensorEntranceCurve: Curves.easeIn,
                      ),
                      child: SizedBox(
                        height: 560,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 60% Wallpaper Kiri
                            Expanded(flex: 6, child: _buildWallpaperSide()),
                            // 40% Form Login Kanan (Branding + Fields + Actions)
                            Expanded(flex: 4, child: _buildDesktopFormSide()),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Copywriting placed outside the card at the bottom of the page
                  Text(
                    'ByUI Component Library • UX Showcase',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Mobile Layout: Vertical Card with White Background & Dark Outside Copywriting
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 14.0 : 20.0,
              vertical: 20.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Brand Logo & Greeting (Outside Card on Mobile)
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/images/logo_by_ui_showcase.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.layers_rounded,
                                color: AppColors.primary,
                                size: 28,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.heading,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sign in to access your ByUI Pulse workspace',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.body,
                  ),
                  const SizedBox(height: 24),

                  // Login Form Card using ByCard.dynamicSensor with 1x pulse handover
                  ByCard.dynamicSensor(
                    backgroundColor: AppColors.cardSurface,
                    borderGradient: AppColors.cyanBlueGradient,
                    borderWidth: 1.5,
                    borderRadius: BorderRadius.circular(20),
                    padding: EdgeInsets.all(isCompact ? 14.0 : 18.0),
                    enableSensor: true,
                    enableHoverTilt: true,
                    shadowGradient: const LinearGradient(
                      colors: [Color(0x1500E5FF), Color(0x152563EB)],
                    ),
                    shadowBlur: 20.0,
                    maxShadowOffset: 6.0,
                    dynamicBorder: const ByDynamicBorder(
                      enabled: true,
                      width: 2.0,
                      shadowBlur: 8.0,
                      shadowWidth: 2.0,
                      shadowColor: Color(0x3300E5FF),
                      duration: Duration(milliseconds: 2000),
                      repeatCount: 1, // Pulse 1 kali saja saat entrance
                      autoStart: true,
                      origin: ByBorderOrigin.topCenter,
                      beamLength: 0.28,
                      colors: AppColors.cyanBlueLaserColors,
                      gradient: AppColors.cyanBlueGradient,
                      sensorResumeDelay: Duration(milliseconds: 200),
                      sensorEntranceDuration: Duration(milliseconds: 400),
                      sensorEntranceCurve: Curves.easeIn,
                    ),
                    child: _buildFormFields(
                      isDesktop: false,
                      isCompact: isCompact,
                    ),
                  ),

                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      'ByUI Component Library • UX Showcase',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
