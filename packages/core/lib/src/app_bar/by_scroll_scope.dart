import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A scope widget that automatically listens to [ScrollNotification]s from descendant
/// scrollables and notifies [ByAppBar] when scroll offset exceeds [scrollThreshold]
/// and coordinates auto-hide / show transitions based on scroll direction.
class ByScrollScope extends StatefulWidget {
  /// The widget subtree containing the scrollable and [ByAppBar].
  final Widget child;

  /// The scroll offset distance in pixels required to trigger the floating transition.
  final double scrollThreshold;

  /// The accumulated scroll delta required to trigger auto-hiding or showing [ByAppBar].
  final double autoHideThreshold;

  const ByScrollScope({
    super.key,
    required this.child,
    this.scrollThreshold = 12.0,
    this.autoHideThreshold = 10.0,
  });

  /// Obtains the [ValueNotifier<bool>] scroll notifier from the closest [ByScrollScope] ancestor.
  ///
  /// The notifier emits `true` when scroll offset exceeds [scrollThreshold].
  static ValueNotifier<bool>? maybeOf(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ByScrollScopeInherited>();
    return inherited?.isScrolledNotifier;
  }

  /// Obtains the [ValueNotifier<bool>] visibility notifier from the closest [ByScrollScope] ancestor.
  ///
  /// The notifier emits `false` when user scrolls down past [autoHideThreshold],
  /// and `true` when user scrolls up or returns to top.
  static ValueNotifier<bool>? maybeVisibilityOf(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ByScrollScopeInherited>();
    return inherited?.isVisibleNotifier;
  }

  @override
  State<ByScrollScope> createState() => _ByScrollScopeState();
}

class _ByScrollScopeState extends State<ByScrollScope> {
  final ValueNotifier<bool> _isScrolled = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isAppBarVisible = ValueNotifier<bool>(true);

  double _accumulatedDelta = 0.0;

  @override
  void dispose() {
    _isScrolled.dispose();
    _isAppBarVisible.dispose();
    super.dispose();
  }

  void _handleNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      final pixels = notification.metrics.pixels;
      final isScrolledNow = pixels > widget.scrollThreshold;
      if (_isScrolled.value != isScrolledNow) {
        _isScrolled.value = isScrolledNow;
      }

      // Auto-hide on scroll direction tracking
      if (pixels <= widget.scrollThreshold) {
        // At or near top: always show app bar
        _accumulatedDelta = 0.0;
        if (!_isAppBarVisible.value) {
          _isAppBarVisible.value = true;
        }
      } else if (notification is ScrollUpdateNotification &&
          notification.scrollDelta != null) {
        final delta = notification.scrollDelta!;
        if (delta > 0) {
          // Scrolling down (content moving up)
          if (_accumulatedDelta < 0) _accumulatedDelta = 0;
          _accumulatedDelta += delta;
          if (_accumulatedDelta >= widget.autoHideThreshold &&
              _isAppBarVisible.value) {
            _isAppBarVisible.value = false;
          }
        } else if (delta < 0) {
          // Scrolling up (content moving down)
          if (_accumulatedDelta > 0) _accumulatedDelta = 0;
          _accumulatedDelta += delta;
          if (_accumulatedDelta <= -widget.autoHideThreshold &&
              !_isAppBarVisible.value) {
            _isAppBarVisible.value = true;
          }
        }
      } else if (notification is UserScrollNotification) {
        // Immediate responsive reveal when gesture flips upward
        if (notification.direction == ScrollDirection.forward &&
            !_isAppBarVisible.value) {
          _accumulatedDelta = 0.0;
          _isAppBarVisible.value = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ByScrollScopeInherited(
      isScrolledNotifier: _isScrolled,
      isVisibleNotifier: _isAppBarVisible,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleNotification(notification);
          return false;
        },
        child: widget.child,
      ),
    );
  }
}

class _ByScrollScopeInherited extends InheritedWidget {
  final ValueNotifier<bool> isScrolledNotifier;
  final ValueNotifier<bool> isVisibleNotifier;

  const _ByScrollScopeInherited({
    required this.isScrolledNotifier,
    required this.isVisibleNotifier,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _ByScrollScopeInherited oldWidget) {
    return isScrolledNotifier != oldWidget.isScrolledNotifier ||
        isVisibleNotifier != oldWidget.isVisibleNotifier;
  }
}
