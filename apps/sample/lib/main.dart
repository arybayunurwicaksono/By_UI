import 'package:flutter/material.dart';
import 'screens/toast_showcase_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ByUISampleApp());
}

class ByUISampleApp extends StatelessWidget {
  const ByUISampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByUI Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          surface: Color(0xFF0F172A),
          onSurface: Colors.white,
        ),
      ),
      home: const ToastShowcaseScreen(),
    );
  }
}
