import 'package:flutter/widgets.dart';

/// A scope widget that automatically listens to [ScrollNotification]s from descendant
/// scrollables and notifies [ByAppBar] when scroll offset exceeds [scrollThreshold].
class ByScrollScope extends StatefulWidget {
  /// The widget subtree containing the scrollable and [ByAppBar].
  final Widget child;

  /// The scroll offset distance in pixels required to trigger the floating transition.
  final double scrollThreshold;

  const ByScrollScope({
    super.key,
    required this.child,
    this.scrollThreshold = 12.0,
  });

  /// Obtains the [ValueNotifier<bool>] scroll notifier from the closest [ByScrollScope] ancestor.
  static ValueNotifier<bool>? maybeOf(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ByScrollScopeInherited>();
    return inherited?.notifier;
  }

  @override
  State<ByScrollScope> createState() => _ByScrollScopeState();
}

class _ByScrollScopeState extends State<ByScrollScope> {
  final ValueNotifier<bool> _isScrolled = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isScrolled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ByScrollScopeInherited(
      notifier: _isScrolled,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0) {
            final isScrolledNow =
                notification.metrics.pixels > widget.scrollThreshold;
            if (_isScrolled.value != isScrolledNow) {
              _isScrolled.value = isScrolledNow;
            }
          }
          return false;
        },
        child: widget.child,
      ),
    );
  }
}

class _ByScrollScopeInherited extends InheritedNotifier<ValueNotifier<bool>> {
  const _ByScrollScopeInherited({
    required ValueNotifier<bool> super.notifier,
    required super.child,
  });
}
