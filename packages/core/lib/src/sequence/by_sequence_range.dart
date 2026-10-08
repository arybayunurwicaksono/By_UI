import 'dart:ui' show lerpDouble;

/// Defines a numerical range between [start] and [end] for [BySequence] animations.
class BySequenceRange {
  /// The beginning value of the range (when progress is 0.0).
  final double start;

  /// The final value of the range (when progress is 1.0).
  final double end;

  /// Creates a new [BySequenceRange] with [start] and [end] coordinates.
  const BySequenceRange(this.start, this.end);

  /// Linearly interpolates between [start] and [end] based on normalized progress [t] (0.0 to 1.0).
  double lerp(double t) {
    return lerpDouble(start, end, t) ?? (start + (end - start) * t);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BySequenceRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'BySequenceRange($start, $end)';
}
