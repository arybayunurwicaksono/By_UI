import 'by_sequence_range.dart';

/// Configuration for spatial and visual property transformations in [BySequence].
class BySequenceAnimation {
  /// Range for opacity interpolation (typically from 0.0 to 1.0).
  final BySequenceRange? opacity;

  /// Range for horizontal offset translation in pixels.
  final BySequenceRange? translateX;

  /// Range for vertical offset translation in pixels.
  final BySequenceRange? translateY;

  /// Range for scale factor transformation (typically from 0.8 to 1.0).
  final BySequenceRange? scale;

  /// Range for rotation in radians (typically from -0.1 to 0.0).
  final BySequenceRange? rotation;

  /// Creates a custom [BySequenceAnimation] specification.
  const BySequenceAnimation({
    this.opacity,
    this.translateX,
    this.translateY,
    this.scale,
    this.rotation,
  });

  /// Default sequence animation: soft fade-in with 32px upward translation.
  static const BySequenceAnimation defaultAnimation = BySequenceAnimation(
    opacity: BySequenceRange(0.0, 1.0),
    translateY: BySequenceRange(32.0, 0.0),
  );

  /// Fade and deep vertical slide animation.
  static const BySequenceAnimation fadeSlide = BySequenceAnimation(
    opacity: BySequenceRange(0.0, 1.0),
    translateY: BySequenceRange(48.0, 0.0),
  );

  /// Fade and horizontal slide animation from the right.
  static const BySequenceAnimation slideRight = BySequenceAnimation(
    opacity: BySequenceRange(0.0, 1.0),
    translateX: BySequenceRange(60.0, 0.0),
  );

  /// Fade and horizontal slide animation from the left.
  static const BySequenceAnimation slideLeft = BySequenceAnimation(
    opacity: BySequenceRange(0.0, 1.0),
    translateX: BySequenceRange(-60.0, 0.0),
  );

  /// Fade and scale transformation animation.
  static const BySequenceAnimation scaleFade = BySequenceAnimation(
    opacity: BySequenceRange(0.0, 1.0),
    scale: BySequenceRange(0.85, 1.0),
  );

  /// Fade, slight tilt rotation, and subtle upward translation.
  static const BySequenceAnimation rotateFade = BySequenceAnimation(
    opacity: BySequenceRange(0.0, 1.0),
    rotation: BySequenceRange(-0.06, 0.0),
    translateY: BySequenceRange(30.0, 0.0),
  );

  /// Pop-in zoom animation with subtle upward spring.
  static const BySequenceAnimation popFade = BySequenceAnimation(
    opacity: BySequenceRange(0.0, 1.0),
    scale: BySequenceRange(0.78, 1.0),
    translateY: BySequenceRange(24.0, 0.0),
  );

  /// Creates a copy of this animation with replaced fields.
  BySequenceAnimation copyWith({
    BySequenceRange? opacity,
    BySequenceRange? translateX,
    BySequenceRange? translateY,
    BySequenceRange? scale,
    BySequenceRange? rotation,
  }) {
    return BySequenceAnimation(
      opacity: opacity ?? this.opacity,
      translateX: translateX ?? this.translateX,
      translateY: translateY ?? this.translateY,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BySequenceAnimation &&
        other.opacity == opacity &&
        other.translateX == translateX &&
        other.translateY == translateY &&
        other.scale == scale &&
        other.rotation == rotation;
  }

  @override
  int get hashCode => Object.hash(
        opacity,
        translateX,
        translateY,
        scale,
        rotation,
      );
}
