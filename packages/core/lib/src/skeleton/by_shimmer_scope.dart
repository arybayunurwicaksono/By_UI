import 'package:flutter/material.dart';
import 'by_skeleton_style.dart';

/// An ambient ancestor scope that coordinates a single synchronized animation clock
/// across multiple [ByAutoShimmer] and [ByBone] widgets.
///
/// Wrapping lists, grids, or whole screens with [ByShimmerScope] prevents "ticker storms"
/// and ensures all loading skeletons shimmer in uniform phase.
class ByShimmerScope extends StatefulWidget {
  /// The widget subtree containing skeletons.
  final Widget child;

  /// Duration for one complete left-to-right sweep across the bones.
  final Duration duration;

  /// Animation pacing curve.
  final Curve curve;

  /// Whether the shimmer animation is currently ticking.
  final bool enabled;

  /// Direction of the sweeping animated light highlight.
  final ByShimmerDirection direction;

  /// Ratio multiplier for the shimmer sweep beam width. Defaults to 1.5.
  final double shimmerWaveWidth;

  /// Creates a [ByShimmerScope].
  const ByShimmerScope({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeInOutSine,
    this.enabled = true,
    this.direction = ByShimmerDirection.ltr,
    this.shimmerWaveWidth = 1.5,
  });

  /// Finds the nearest [ByShimmerScopeState] in the widget tree, if one exists.
  static ByShimmerScopeState? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ByShimmerScopeInherited>();
    return scope?.state;
  }

  /// Finds the nearest [ByShimmerScopeState] in the widget tree.
  static ByShimmerScopeState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'No ByShimmerScope found in the current context.');
    return state!;
  }

  @override
  State<ByShimmerScope> createState() => ByShimmerScopeState();
}

/// The state associated with a [ByShimmerScope], exposing the centralized animation value.
class ByShimmerScopeState extends State<ByShimmerScope>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  /// The current normalized phase of the shimmer sweep (0.0 to 1.0).
  double get phase => _animation.value;

  /// Direction of the sweeping animated light highlight.
  ByShimmerDirection get direction => widget.direction;

  /// Ratio multiplier for the shimmer sweep beam width.
  double get shimmerWaveWidth => widget.shimmerWaveWidth;

  /// Listenable ticker for listening without rebuilds.
  Animation<double> get animation => _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ByShimmerScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.curve != oldWidget.curve) {
      _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    }
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _ByShimmerScopeInherited(
          state: this,
          phase: _animation.value,
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}

class _ByShimmerScopeInherited extends InheritedWidget {
  final ByShimmerScopeState state;
  final double phase;

  const _ByShimmerScopeInherited({
    required this.state,
    required this.phase,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _ByShimmerScopeInherited oldWidget) {
    return oldWidget.phase != phase;
  }
}
