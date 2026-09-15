import 'package:flutter/material.dart';
import 'models/app_theme_store.dart';
import 'screens/toast_showcase_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/web_mobile_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ByUISampleApp());
}

class ByUISampleApp extends StatelessWidget {
  const ByUISampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeStore.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'ByUI Showcase',
          debugShowCheckedModeBanner: false,
          themeMode: AppThemeStore.instance.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: (context, child) {
            return WebMobileLayout(
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const ToastShowcaseScreen(),
        );
      },
    );
  }
}
