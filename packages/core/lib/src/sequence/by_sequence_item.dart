import 'package:flutter/widgets.dart';
import 'by_sequence_animation.dart';

/// A wrapper widget providing per-item animation overrides within a [BySequence].
class BySequenceItem extends StatelessWidget {
  /// The primary widget content to display and animate.
  final Widget child;

  /// Optional custom animation transformation override for this specific item.
  final BySequenceAnimation? animation;

  /// Optional transition duration override when non-scrub mode is active.
  final Duration? duration;

  /// Optional easing curve override for this item.
  final Curve? curve;

  /// Optional relative viewport trigger position (0.0 to 1.0) override for this item.
  final double? trigger;

  /// Optional scrub mode override for this item.
  final bool? scrub;

  /// Creates a [BySequenceItem] configuration wrapper.
  const BySequenceItem({
    super.key,
    required this.child,
    this.animation,
    this.duration,
    this.curve,
    this.trigger,
    this.scrub,
  });

  @override
  Widget build(BuildContext context) => child;
}
