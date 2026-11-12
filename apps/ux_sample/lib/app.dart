import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/app_colors.dart';

/// Root application widget for the ByUI UX Sample with Cyan branding.
class UxSampleApp extends StatelessWidget {
  const UxSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByUI Pulse UX Sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.scaffoldBg,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primaryAccent,
          surface: Colors.white,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
