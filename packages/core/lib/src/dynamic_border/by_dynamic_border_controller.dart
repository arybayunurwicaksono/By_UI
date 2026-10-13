import 'package:flutter/foundation.dart';

/// Controller to manually trigger and coordinate [ByDynamicBorder] pulse animations.
class ByDynamicBorderController extends ChangeNotifier {
  bool _isPulsing = false;
  VoidCallback? _pulseAction;
  VoidCallback? _stopAction;
  VoidCallback? _resetAction;

  /// Whether a pulse animation is currently active and traversing the perimeter.
  bool get isPulsing => _isPulsing;

  /// Imperatively triggers one pulse circuit from Point A around the perimeter.
  void pulse() {
    _pulseAction?.call();
  }

  /// Immediately stops the pulse and fades out the beam.
  void stop() {
    _stopAction?.call();
  }

  /// Resets the pulse state back to initial rest.
  void reset() {
    _resetAction?.call();
  }

  /// Internal attachment method linking this controller to the host animation state.
  @internal
  void attach({
    required VoidCallback onPulse,
    required VoidCallback onStop,
    required VoidCallback onReset,
  }) {
    _pulseAction = onPulse;
    _stopAction = onStop;
    _resetAction = onReset;
  }

  /// Internal detachment method when the host widget unmounts.
  @internal
  void detach() {
    _pulseAction = null;
    _stopAction = null;
    _resetAction = null;
    _isPulsing = false;
  }

  /// Internal status updater invoked by host animation lifecycle.
  @internal
  void updatePulsingState(bool pulsing) {
    if (_isPulsing != pulsing) {
      _isPulsing = pulsing;
      notifyListeners();
    }
  }
}
