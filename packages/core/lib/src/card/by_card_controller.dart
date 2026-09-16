import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'by_card_enums.dart';

/// Controller that computes smooth spatial orientation coordinates for [ByCard].
///
/// Converts raw accelerometer vectors, cursor hover coordinates, or manual inputs
/// into normalized `Offset(dx, dy)` values between -1.0 and 1.0, filtered with
/// a low-pass damping algorithm to prevent jitter.
class ByTiltController {
  /// Whether physical hardware sensors are actively streaming.
  final bool enableSensor;

  /// Smoothing factor for the low-pass filter (0.01 = very slow, 1.0 = instant).
  final double damping;

  /// Optional callback invoked whenever the filtered tilt coordinate updates.
  ValueChanged<Offset>? onTiltChanged;

  /// Notifier exposing the filtered, normalized tilt coordinate.
  /// `Offset(0.0, 1.0)` represents an upright portrait position.
  final ValueNotifier<Offset> tiltNotifier;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Timer? _neutralAnimationTimer;
  Offset _targetTilt = const Offset(0.0, 1.0);
  Offset _currentTilt = const Offset(0.0, 1.0);
  ByTiltSource _activeSource = ByTiltSource.none;
  bool _isDisposed = false;

  /// Creates a [ByTiltController].
  ByTiltController({
    this.enableSensor = false,
    this.damping = 0.28,
    this.onTiltChanged,
    Offset initialTilt = const Offset(0.0, 1.0),
  })  : tiltNotifier = ValueNotifier<Offset>(initialTilt),
        _targetTilt = initialTilt,
        _currentTilt = initialTilt {
    if (enableSensor) {
      _startSensorListening();
    }
  }

  /// Currently active source driving the tilt coordinates.
  ByTiltSource get activeSource => _activeSource;

  /// Starts listening to device accelerometer stream with error fallback.
  void _startSensorListening() {
    try {
      _activeSource = ByTiltSource.sensor;
      // Accelerometer: reads gravity vector (absolute spatial tilt in physical world)
      _accelerometerSubscription = accelerometerEventStream(
        samplingPeriod: SensorInterval.uiInterval,
      ).listen(
        (AccelerometerEvent event) {
          if (_isDisposed) return;
          // When lying flat on a table (screen facing up):
          // Z acceleration is dominant (~9.8 m/s^2), while X and Y are near zero (< 1.8 m/s^2).
          final bool isTableFlat =
              event.z.abs() > 7.5 && event.x.abs() < 1.8 && event.y.abs() < 1.8;

          final Offset newTarget;
          if (isTableFlat) {
            // Firm lock on flat table: no direction, neutral balanced glow
            newTarget = Offset.zero;
          } else {
            // In standard mobile coordinate space:
            // Tilting right produces negative reaction force on X, so -event.x yields positive dx (+1.0 = right)
            // Tilting left produces positive reaction force on X, so -event.x yields negative dx (-1.0 = left)
            // Upright portrait produces positive reaction force on Y (+1.0 = bottom)
            final double normalizedX = (-event.x / 9.8).clamp(-1.0, 1.0);
            final double normalizedY = (event.y / 9.8).clamp(-1.0, 1.0);
            newTarget = Offset(normalizedX, normalizedY);
          }

          // Deadband filter: ignore micro sensor noise (< 0.012)
          // When flat on table, ensure we transition cleanly to Offset.zero once and stay there
          if ((newTarget.dx - _targetTilt.dx).abs() > 0.012 ||
              (newTarget.dy - _targetTilt.dy).abs() > 0.012 ||
              (isTableFlat && _targetTilt != Offset.zero)) {
            _targetTilt = newTarget;
            _applyDamping();
          }
        },
        onError: (Object _) {
          _activeSource = ByTiltSource.none;
        },
      );
    } catch (_) {
      _activeSource = ByTiltSource.none;
    }
  }

  /// Updates tilt from mouse or pointer hover coordinates within the card boundary.
  void updateHoverPosition(Offset localPosition, Size cardSize) {
    if (_isDisposed || cardSize.isEmpty) return;
    _neutralAnimationTimer?.cancel();
    _neutralAnimationTimer = null;
    _activeSource = ByTiltSource.hover;

    // Map [0, width] to [-1.0, 1.0], [0, height] to [-1.0, 1.0]
    final double nx =
        ((localPosition.dx / cardSize.width) * 2.0 - 1.0).clamp(-1.0, 1.0);
    final double ny =
        ((localPosition.dy / cardSize.height) * 2.0 - 1.0).clamp(-1.0, 1.0);

    _targetTilt = Offset(nx, ny);
    _applyDamping();
  }

  /// Explicitly sets the manual tilt coordinate (e.g. from a slider or testing suite).
  void setManualTilt(Offset tilt) {
    if (_isDisposed) return;
    _neutralAnimationTimer?.cancel();
    _neutralAnimationTimer = null;
    _activeSource = ByTiltSource.manual;
    _targetTilt = Offset(
      tilt.dx.clamp(-1.0, 1.0),
      tilt.dy.clamp(-1.0, 1.0),
    );
    _applyDamping(immediate: true);
  }

  /// Smoothly animates the tilt coordinate back to the neutral state ([Offset.zero])
  /// over [duration] using [curve].
  void smoothResetToNeutral({
    Duration duration = const Duration(milliseconds: 220),
    Curve curve = Curves.easeOutCubic,
  }) {
    if (_isDisposed) return;
    _neutralAnimationTimer?.cancel();

    final Offset startTilt = _currentTilt;
    if (startTilt == Offset.zero) {
      _targetTilt = Offset.zero;
      return;
    }

    final int totalSteps = (duration.inMilliseconds / 16).ceil().clamp(6, 30);
    int currentStep = 0;

    _activeSource = ByTiltSource.hover;
    _targetTilt = Offset.zero;

    _neutralAnimationTimer =
        Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      currentStep++;
      final double progress = (currentStep / totalSteps).clamp(0.0, 1.0);
      final double curvedProgress = curve.transform(progress);

      _currentTilt =
          Offset.lerp(startTilt, Offset.zero, curvedProgress) ?? Offset.zero;
      tiltNotifier.value = _currentTilt;
      onTiltChanged?.call(_currentTilt);

      if (progress >= 1.0) {
        timer.cancel();
        _neutralAnimationTimer = null;
      }
    });
  }

  /// Resets the tilt coordinate back to the neutral position ([target], defaults to [Offset.zero]).
  void resetToNeutral([Offset target = Offset.zero]) {
    if (_isDisposed) return;
    _neutralAnimationTimer?.cancel();
    _neutralAnimationTimer = null;
    _targetTilt = target;
    _applyDamping(immediate: true);
  }

  /// Low-pass filter interpolation step to ensure fluid 60/120 FPS motion.
  void _applyDamping({bool immediate = false}) {
    if (_isDisposed) return;
    if (immediate) {
      _currentTilt = _targetTilt;
    } else {
      _currentTilt =
          Offset.lerp(_currentTilt, _targetTilt, damping) ?? _targetTilt;
      // Snap to target if very close to prevent endless micro-updates
      if ((_currentTilt.dx - _targetTilt.dx).abs() < 0.005 &&
          (_currentTilt.dy - _targetTilt.dy).abs() < 0.005) {
        _currentTilt = _targetTilt;
      }
    }
    tiltNotifier.value = _currentTilt;
    onTiltChanged?.call(_currentTilt);
  }

  /// Disposes internal subscriptions and notifiers.
  void dispose() {
    _isDisposed = true;
    _neutralAnimationTimer?.cancel();
    _neutralAnimationTimer = null;
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    tiltNotifier.dispose();
  }
}
