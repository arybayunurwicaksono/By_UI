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

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  int _tabIndex = 0;
  int _navIndex = 0;
  bool _isLoadingShimmer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ByUI Example'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Segmented Tab Bar ───────────────────────────────────────────
            const Text(
              'ByTabBar (Liquid Morphing & Dynamic Border):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ByTabBar(
              tabs: const [
                ByTabItem(label: 'Overview', icon: Icons.dashboard_rounded),
                ByTabItem(
                    label: 'Analytics',
                    icon: Icons.analytics_rounded,
                    badge: 'HOT'),
                ByTabItem(label: 'Settings', icon: Icons.settings_rounded),
              ],
              selectedIndex: _tabIndex,
              onTabChanged: (i) => setState(() => _tabIndex = i),
              indicatorColor: const Color(0xFF00F5FF),
              enableLiquidMorphing: true,
              enableSelectionPulse: true,
              dynamicBorderColors: const [Colors.white, Color(0xFF00F5FF)],
            ),
            const SizedBox(height: 24),

            // ── Automated Shimmer Skeleton ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ByAutoShimmer (MVP Skeleton Generator):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton.icon(
                  icon: Icon(_isLoadingShimmer
                      ? Icons.play_arrow_rounded
                      : Icons.refresh_rounded),
                  label: Text(_isLoadingShimmer ? 'Show Content' : 'Reload'),
                  onPressed: () =>
                      setState(() => _isLoadingShimmer = !_isLoadingShimmer),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ByAutoShimmer(
              isLoading: _isLoadingShimmer,
              style: const BySkeletonStyle(
                shimmerGradient: LinearGradient(
                  colors: [
                    Color(0xFF1E293B),
                    Color(0xFF38BDF8),
                    Color(0xFF1E293B),
                  ],
                ),
              ),
              child: Card(
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFF334155)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFF38BDF8),
                        child: Icon(Icons.auto_awesome, color: Colors.white),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Automated Skeleton Layout',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Recursively analyzes widget tree to produce exact bone placeholders.',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Toast & Dialog Buttons ──────────────────────────────────────
            const Text(
              'ByToast & ByDialog Notifications:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
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
            const SizedBox(height: 24),

            // ── ByCard Dynamic Motion Sensor ────────────────────────────────
            const Text(
              'ByCard.dynamicSensor (Motion Tilt & Parallax):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ByCard.dynamicSensor(
              colors: const [
                Color(0xFF38BDF8),
                Color(0xFF818CF8),
                Color(0xFFC084FC),
              ],
              borderWidth: 2.0,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ByCard.dynamicSensor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tilts border gradient with motion on mobile, or tracks cursor on desktop/web.',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── ByButton ───────────────────────────────────────────────────
            const Text(
              'ByButton (Dynamic Border & Auto-Async Loading):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ByButton(
              variant: ByButtonVariant.outline,
              borderWidth: 1.5,
              loadingBorderWidth: 2.0,
              enableStateTransitionPulse: true,
              enableTransitionPulseColors: const [
                Color(0xFF38BDF8),
                Color(0xFF818CF8),
                Color(0xFFC084FC),
              ],
              loadingPulseColors: const [
                Color(0xFF38BDF8),
                Color(0xFF818CF8),
                Color(0xFFC084FC),
              ],
              prefix: const Icon(Icons.bolt_rounded, size: 18),
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 2));
                if (context.mounted) {
                  ByToast.showSuccess(
                    context,
                    message: 'Async task completed with dynamic border!',
                  );
                }
              },
              child: const Text('Outline Button (Tap for Async Loading)'),
            ),
            const SizedBox(height: 24),

            // ── BySequence ─────────────────────────────────────────────────
            const Text(
              'BySequence (Sequential Scroll Reveal):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BySequence(
                  trigger: 0.85,
                  spacing: 10,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: const Text('Sequence Item 1: Initialization'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: const Text('Sequence Item 2: Progressive Reveal'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: const Text('Sequence Item 3: Sequence Complete'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: ByBottomNav(
        items: const [
          ByBottomNavItem(label: 'Feed', icon: Icons.feed_rounded),
          ByBottomNavItem(
              label: 'Explore', icon: Icons.explore_rounded, badgeText: '3'),
          ByBottomNavItem(label: 'Account', icon: Icons.person_rounded),
        ],
        selectedIndex: _navIndex,
        onItemSelected: (i) => setState(() => _navIndex = i),
        activeColor: const Color(0xFF00F5FF),
        enableSelectionPulse: true,
      ),
    );
  }
}
