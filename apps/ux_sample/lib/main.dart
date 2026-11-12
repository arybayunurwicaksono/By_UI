import 'package:by_ui/by_ui.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure ByToast to dynamically adapt across viewport form factors:
  // - Web / Desktop (width >= 768): Anchors at the bottom-right corner with compact width (max 400px).
  // - Mobile (width < 768): Anchors at the top with full width between horizontal margins.
  ByToast.defaultPositionResolver = (context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 768 ? ByToastPosition.bottomRight : ByToastPosition.top;
  };

  runApp(const UxSampleApp());
}
