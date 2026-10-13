import 'dart:async';
import 'package:flutter/material.dart';
import 'by_dynamic_border.dart';
import 'by_dynamic_border_painter.dart';

/// Manages the animation lifecycle and renders [ByDynamicBorderPainter]
/// layered above or around a host component.
class ByDynamicBorderLayer extends StatefulWidget {
  /// The dynamic border configuration.
  final ByDynamicBorder config;

  /// Corner radius of the host widget.
  final BorderRadius borderRadius;

  /// Optional child wrapped by this border layer.
  final Widget? child;

  /// Callback fired when a pulse circuit begins traversing.
  final VoidCallback? onPulseStart;

  /// Callback fired when the pulse circuit finishes its cycles and dissipates.
  final VoidCallback? onPulseComplete;

  const ByDynamicBorderLayer({
    super.key,
    required this.config,
    required this.borderRadius,
    this.child,
    this.onPulseStart,
    this.onPulseComplete,
  });

  @override
  State<ByDynamicBorderLayer> createState() => _ByDynamicBorderLayerState();
}

class _ByDynamicBorderLayerState extends State<ByDynamicBorderLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _periodicTimer;
  int _completedCycles = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: widget.config.duration,
    );

    _pulseController.addStatusListener(_handleStatusChange);
    _attachController();

    if (widget.config.enabled && widget.config.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _startPulse();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant ByDynamicBorderLayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.config.duration != oldWidget.config.duration) {
      _pulseController.duration = widget.config.duration;
    }

    if (widget.config.controller != oldWidget.config.controller) {
      oldWidget.config.controller?.detach();
      _attachController();
    }

    // If switching from periodic rest to continuous looping or zero interval, start immediately
    if (widget.config.enabled &&
        (widget.config.repeatCount == null &&
                oldWidget.config.repeatCount != null ||
            (widget.config.periodicInterval == null ||
                    widget.config.periodicInterval == Duration.zero) &&
                oldWidget.config.periodicInterval != null &&
                oldWidget.config.periodicInterval! > Duration.zero)) {
      if (_periodicTimer != null && _periodicTimer!.isActive) {
        _periodicTimer?.cancel();
        _periodicTimer = null;
        if (!_pulseController.isAnimating) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted &&
                widget.config.enabled &&
                !_pulseController.isAnimating) {
              widget.onPulseStart?.call();
              _pulseController.forward(from: 0.0);
            }
          });
        }
      }
    }

    // If returning to periodic standby mode after one-shot transition pulse, schedule periodic timer
    if (widget.config.enabled &&
        widget.config.repeatCount == null &&
        oldWidget.config.repeatCount != null &&
        widget.config.periodicInterval != null &&
        widget.config.periodicInterval! > Duration.zero) {
      if (_periodicTimer == null && !_pulseController.isAnimating) {
        _periodicTimer = Timer(widget.config.periodicInterval!, () {
          if (mounted && widget.config.enabled) {
            widget.config.controller?.updatePulsingState(true);
            widget.onPulseStart?.call();
            _pulseController.forward(from: 0.0);
          }
        });
      }
    }

    if (!widget.config.enabled && oldWidget.config.enabled) {
      _stopPulse();
    } else if (widget.config.enabled &&
        !oldWidget.config.enabled &&
        widget.config.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.config.enabled) {
          _startPulse();
        }
      });
    }
  }

  void _attachController() {
    widget.config.controller?.attach(
      onPulse: _startPulse,
      onStop: _stopPulse,
      onReset: _resetPulse,
    );
  }

  void _handleStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _completedCycles++;
      final int? repeat = widget.config.repeatCount;
      if (repeat == null || _completedCycles < repeat) {
        if (widget.config.periodicInterval != null &&
            widget.config.periodicInterval! > Duration.zero) {
          widget.config.controller?.updatePulsingState(false);
          widget.onPulseComplete?.call();
          _periodicTimer?.cancel();
          _periodicTimer = Timer(widget.config.periodicInterval!, () {
            if (mounted && widget.config.enabled) {
              widget.config.controller?.updatePulsingState(true);
              widget.onPulseStart?.call();
              _pulseController.forward(from: 0.0);
            }
          });
        } else {
          _pulseController.forward(from: 0.0);
        }
      } else {
        widget.config.controller?.updatePulsingState(false);
        widget.config.onComplete?.call();
        widget.onPulseComplete?.call();
      }
    }
  }

  void _startPulse() {
    if (!mounted || !widget.config.enabled) return;
    _periodicTimer?.cancel();
    _completedCycles = 0;
    widget.onPulseStart?.call();
    widget.config.controller?.updatePulsingState(true);
    _pulseController.forward(from: 0.0);
  }

  void _stopPulse() {
    if (!mounted) return;
    _periodicTimer?.cancel();
    widget.config.controller?.updatePulsingState(false);
    _pulseController.stop();
  }

  void _resetPulse() {
    if (!mounted) return;
    _periodicTimer?.cancel();
    widget.config.controller?.updatePulsingState(false);
    _pulseController.reset();
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    widget.config.controller?.detach();
    _pulseController.removeStatusListener(_handleStatusChange);
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget borderPainter = IgnorePointer(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) {
          return CustomPaint(
            painter: ByDynamicBorderPainter(
              config: widget.config,
              borderRadius: widget.borderRadius,
              progress: _pulseController.value,
            ),
          );
        },
      ),
    );

    if (widget.child == null) {
      return borderPainter;
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child!,
        Positioned.fill(child: borderPainter),
      ],
    );
  }
}
