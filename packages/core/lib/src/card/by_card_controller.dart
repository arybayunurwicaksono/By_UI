import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'by_card_enums.dart';

/// Controller that computes smooth spatial orientation coordinates for [ByCard].
///
/// Converts raw accelerometer vectors, cursor hover coordinates, or manual inputs
/// into normalized `Offset(dx, dy)` values between -1.0 and 1.0, filtered with
/// a continuous vsync frame interpolation loop and low-pass damping algorithm to
/// eliminate jitter and stuttering across high-refresh displays.
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
  Ticker? _ticker;
  Duration? _lastFrameTime;

  Offset _targetTilt = const Offset(0.0, 1.0);
  Offset _currentTilt = const Offset(0.0, 1.0);
  Offset _filteredSensorTarget = const Offset(0.0, 1.0);
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
        _currentTilt = initialTilt,
        _filteredSensorTarget = initialTilt {
    _initTicker();
    if (enableSensor) {
      _startSensorListening();
    }
  }

  /// Currently active source driving the tilt coordinates.
  ByTiltSource get activeSource => _activeSource;

  void _initTicker() {
    try {
      _ticker = Ticker(_onTick);
    } catch (_) {
      // In headless unit-test environments without SchedulerBinding
      _ticker = null;
    }
  }

  void _wakeTicker() {
    if (_isDisposed) return;
    if (_ticker != null) {
      if (!_ticker!.isTicking) {
        _lastFrameTime = null;
        _ticker!.start();
      }
    } else {
      _applyDampingFallback();
    }
  }

  void _onTick(Duration elapsed) {
    if (_isDisposed) return;
    final Duration? last = _lastFrameTime;
    _lastFrameTime = elapsed;

    final double dt;
    if (last == null) {
      dt = 1.0 / 60.0;
    } else {
      final double deltaSec = (elapsed - last).inMicroseconds / 1000000.0;
      dt = deltaSec.clamp(0.001, 0.05);
    }

    final double distance = (_targetTilt - _currentTilt).distance;
    if (distance < 0.0008) {
      if (_currentTilt != _targetTilt) {
        _currentTilt = _targetTilt;
        tiltNotifier.value = _currentTilt;
        onTiltChanged?.call(_currentTilt);
      }
      _ticker?.stop();
      _lastFrameTime = null;
      return;
    }

    // Frame-rate independent exponential damping:
    final double clampedDamping = damping.clamp(0.05, 0.95);
    final double decayRate = -math.log(1.0 - clampedDamping) * 60.0;
    final double factor = (1.0 - math.exp(-decayRate * dt)).clamp(0.0, 1.0);

    _currentTilt =
        Offset.lerp(_currentTilt, _targetTilt, factor) ?? _targetTilt;
    tiltNotifier.value = _currentTilt;
    onTiltChanged?.call(_currentTilt);
  }

  void _applyDampingFallback() {
    if (_isDisposed) return;
    _currentTilt =
        Offset.lerp(_currentTilt, _targetTilt, damping) ?? _targetTilt;
    if ((_currentTilt.dx - _targetTilt.dx).abs() < 0.005 &&
        (_currentTilt.dy - _targetTilt.dy).abs() < 0.005) {
      _currentTilt = _targetTilt;
    }
    tiltNotifier.value = _currentTilt;
    onTiltChanged?.call(_currentTilt);
  }

  /// Starts listening to device accelerometer stream with error fallback.
  void _startSensorListening() {
    try {
      _activeSource = ByTiltSource.sensor;
      // High-refresh gameInterval (~50-60 Hz) provides responsive sensor events
      _accelerometerSubscription = accelerometerEventStream(
        samplingPeriod: SensorInterval.gameInterval,
      ).listen(
        (AccelerometerEvent event) {
          if (_isDisposed) return;

          // In standard mobile coordinate space:
          // Tilting right produces negative reaction force on X, so -event.x yields positive dx (+1.0 = right)
          // Tilting left produces positive reaction force on X, so -event.x yields negative dx (-1.0 = left)
          // Upright portrait produces positive reaction force on Y (+1.0 = bottom)
          final double rawX = (-event.x / 9.8).clamp(-1.0, 1.0);
          final double rawY = (event.y / 9.8).clamp(-1.0, 1.0);
          final double hMag = math.sqrt(rawX * rawX + rawY * rawY);

          final Offset newTarget;
          if (hMag < 0.03) {
            // Firm lock when flat on a table: neutral balanced glow
            newTarget = Offset.zero;
          } else {
            // Smooth continuous transition from resting deadzone into full sensor tracking
            final double t = ((hMag - 0.03) / 0.07).clamp(0.0, 1.0);
            final double smoothScale = t * t * (3.0 - 2.0 * t);
            final double scale =
                (smoothScale * (hMag / (hMag + 0.0001))).clamp(0.0, 1.0);
            newTarget = Offset(rawX * scale, rawY * scale);
          }

          // Low-pass filter on incoming sensor stream to reject high-frequency MEMS noise
          _filteredSensorTarget =
              Offset.lerp(_filteredSensorTarget, newTarget, 0.45) ?? newTarget;
          _targetTilt = _filteredSensorTarget;
          _wakeTicker();
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
    _wakeTicker();
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
    _filteredSensorTarget = _targetTilt;
    _currentTilt = _targetTilt;
    _ticker?.stop();
    _lastFrameTime = null;
    tiltNotifier.value = _currentTilt;
    onTiltChanged?.call(_currentTilt);
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
      _filteredSensorTarget = Offset.zero;
      return;
    }

    final int totalSteps = (duration.inMilliseconds / 16).ceil().clamp(2, 30);
    int currentStep = 0;

    _activeSource = ByTiltSource.hover;
    _targetTilt = Offset.zero;
    _filteredSensorTarget = Offset.zero;

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
    _filteredSensorTarget = target;
    _currentTilt = target;
    _ticker?.stop();
    _lastFrameTime = null;
    tiltNotifier.value = _currentTilt;
    onTiltChanged?.call(_currentTilt);
  }

  /// Disposes internal subscriptions, tickers, and notifiers.
  void dispose() {
    _isDisposed = true;
    _neutralAnimationTimer?.cancel();
    _neutralAnimationTimer = null;
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    tiltNotifier.dispose();
  }
}
