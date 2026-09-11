import 'package:flutter/material.dart';
import 'package:by_ui/by_ui.dart';

void main() {
  runApp(const ByUIExampleApp());
}

class ByUIExampleApp extends StatelessWidget {
  const ByUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByUI Example',
      theme: ThemeData.dark(),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ByUI Example'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.notifications_active_rounded),
                label: const Text('Show Success Toast'),
                onPressed: () {
                  ByToast.showSuccess(
                    context,
                    message: 'Action completed successfully!',
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('Show Expandable Toast (Tap/Drag to Dialog)'),
                onPressed: () {
                  ByToast.show(
                    context,
                    title: 'Order Status',
                    message: 'Receipt ready. Tap or drag down to view details.',
                    icon: Icons.receipt_long_rounded,
                    detailTitle: 'Transaction #1042',
                    detailMessage: '• Item 1: Double Espresso x2\n'
                        '• Item 2: Butter Croissant x1\n'
                        '• Total: Rp 78.000\n'
                        '• Status: Paid via QRIS',
                    enableTapToExpand: true,
                    enableDragToExpand: true,
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.help_outline_rounded),
                label: const Text('Show Confirm Dialog'),
                onPressed: () async {
                  final result = await ByDialog.confirm(
                    context,
                    title: 'Void Transaction?',
                    message: 'Are you sure you want to cancel this order?',
                    confirmText: 'Void Order',
                    cancelText: 'Keep Order',
                    confirmColor: const Color(0xFFEF4444),
                  );

                  if (context.mounted) {
                    ByToast.show(
                      context,
                      message: result ? 'Order voided.' : 'Action cancelled.',
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
