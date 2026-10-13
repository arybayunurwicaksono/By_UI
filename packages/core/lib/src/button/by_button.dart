import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../dynamic_border/by_dynamic_border.dart';
import '../dynamic_border/by_dynamic_border_controller.dart';
import '../dynamic_border/by_dynamic_border_layer.dart';
import 'by_button_defaults.dart';
import 'by_button_enums.dart';
import 'by_button_style.dart';

/// A flagship, interactive button component combining standard button ergonomics
/// with fluid spatial animations, 3-phase circular pulse loading, auto-async handlers,
/// and state transition border pulses.
class ByButton extends StatefulWidget {
  /// The primary widget content (label, text, badge, or custom composition).
  ///
  /// Strictly accepts any [Widget] rather than constraining callers to strings.
  final Widget child;

  /// Callback when button is tapped.
  ///
  /// Accepts synchronous or asynchronous ([Future]) callbacks.
  /// When returning a [Future], [ByButton] automatically enters circular loading
  /// state and displays the 3-phase pulse spinner until the future completes.
  final FutureOr<void> Function()? onPressed;

  /// Optional callback when button is long-pressed.
  final FutureOr<void> Function()? onLongPress;

  /// Optional widget displayed before the [child] (e.g. leading icon).
  final Widget? prefix;

  /// Optional widget displayed after the [child] (e.g. trailing arrow).
  final Widget? suffix;

  /// Horizontal spacing between [prefix], [child], and [suffix]. Defaults to `8.0px`.
  final double spacing;

  /// Optional floating badge pinned at the corner of the button.
  final Widget? badge;

  /// Alignment of the floating [badge]. Defaults to [Alignment.topRight].
  final Alignment badgeAlignment;

  /// Explicit enabled override. If null, derived from whether [onPressed] is non-null.
  final bool? isEnabled;

  /// Explicit loading override. If true, forces the button into circular loading state.
  final bool? isLoading;

  /// Explicit transactional state (idle, loading, success, error).
  final ByButtonState state;

  /// Duration to display success/error icons before auto-restoring to idle. Defaults to `1000ms`.
  final Duration resultDuration;

  /// Predefined visual variant preset (filled, gradient, outline, ghost).
  final ByButtonVariant variant;

  /// Predefined sizing preset (small, medium, large). Defaults to [ByButtonSize.medium].
  final ByButtonSize size;

  /// Explicit width override. If null, wraps intrinsic content.
  final double? width;

  /// Explicit height override. If null, resolved from [size].
  final double? height;

  /// Explicit corner radius override. If null, resolved from [style] or [size].
  final BorderRadius? borderRadius;

  /// Explicit border stroke width override in logical pixels.
  ///
  /// Acts as the single source of truth for the button's unified border,
  /// controlling the border in standby, the circular loading pulse beam,
  /// and the state transition pulse beam.
  final double? borderWidth;

  /// Explicit border stroke color override.
  final Color? borderColor;

  /// Custom icon color for the success checkmark icon in transactional success state.
  final Color? successIconColor;

  /// Custom icon color for the error cross icon in transactional error state.
  final Color? errorIconColor;

  /// Custom gradient for the success checkmark icon in transactional success state.
  final Gradient? successIconGradient;

  /// Custom gradient for the error cross icon in transactional error state.
  final Gradient? errorIconGradient;

  /// Explicit background surface color override. Overrides [style] or theme defaults.
  final Color? backgroundColor;

  /// Explicit content text and icon color override.
  final Color? foregroundColor;

  /// Comprehensive visual styling for enabled and disabled states.
  final ByButtonStyle? style;

  /// Whether to scale down slightly on press for tactile bounce feedback. Defaults to `true`.
  final bool enablePressScale;

  /// Scale factor applied during press. Defaults to `0.96`.
  final double pressedScale;

  /// Whether to play a border pulse when [isEnabled] transitions. Defaults to `true`.
  final bool enableStateTransitionPulse;

  /// Starting origin of the state transition border pulse. Defaults to [ByBorderOrigin.topLeft].
  final ByBorderOrigin transitionPulseOrigin;

  /// Custom colors for the state transition pulse beam.
  final List<Color>? transitionPulseColors;

  /// Custom colors for the state transition pulse beam when switching to enabled state.
  final List<Color>? enableTransitionPulseColors;

  /// Custom colors for the state transition pulse beam when switching to disabled state.
  final List<Color>? disableTransitionPulseColors;

  /// Optional override for the state transition pulse beam width. Defaults to [borderWidth].
  final double? transitionPulseWidth;

  /// Duration of one complete state transition pulse perimeter circuit. Defaults to `1200ms`.
  final Duration? transitionPulseDuration;

  /// Custom gradient for the state transition pulse beam.
  final Gradient? transitionPulseGradient;

  /// Whether outer glow and shadow are enabled for the state transition pulse. Defaults to `true`.
  final bool enableTransitionPulseGlow;

  /// Custom traveling beam colors for the circular loading pulse spinner.
  final List<Color>? loadingPulseColors;

  /// Custom gradient for the circular loading pulse spinner beam.
  final Gradient? loadingPulseGradient;

  /// Explicit border stroke width override during circular loading state in logical pixels.
  ///
  /// Governs the circular loading pulse spinner width independently from the idle [borderWidth].
  /// If omitted (null), automatically falls back to [loadingPulseWidth], then [dynamicBorder.width],
  /// then inherits the idle [borderWidth] when greater than 0.0, or defaults to 2.5px.
  final double? loadingBorderWidth;

  /// Optional override for the loading circular pulse spinner width. Defaults to [loadingBorderWidth] or [borderWidth].
  final double? loadingPulseWidth;

  /// Duration of one perimeter circuit for the loading pulse spinner. Defaults to `1400ms`.
  final Duration? loadingPulseDuration;

  /// Whether outer glow and shadow are enabled for the loading pulse spinner. Defaults to `true`.
  final bool enableLoadingPulseGlow;

  /// Whether to play periodic ambient CTA border pulses. Defaults to `false`.
  final bool enableAmbientPulse;

  /// Interval between ambient pulses when [enableAmbientPulse] is true. Defaults to 5 seconds.
  final Duration ambientPulseInterval;

  /// Whether to display a high-tech surface shimmer sheen pass. Defaults to `false`.
  final bool enableShimmer;

  /// Duration for the width shrink/expand morph animation. Defaults to `300ms`.
  final Duration morphDuration;

  /// Curve for the morph animation. Defaults to [Curves.easeInOutCubic].
  final Curve morphCurve;

  /// Optional custom dynamic border configuration for the circular loading progress indicator.
  final ByDynamicBorder? loadingPulseConfig;

  /// Optional custom dynamic border configuration for state transition pulses.
  final ByDynamicBorder? stateTransitionPulseConfig;

  /// Optional primary dynamic pulse border configuration.
  ///
  /// Governs the button's unified dynamic border behavior across all states:
  /// - In standby: traverses the perimeter periodically if [ByDynamicBorder.periodicInterval] is set,
  ///   or manually when triggered via [ByDynamicBorder.controller].
  /// - In loading: adapts to the morphed circular geometry and loops continuously as the active progress indicator.
  /// - On state transition: sweeps when enabled state toggles.
  final ByDynamicBorder? dynamicBorder;

  /// Creates a standard filled [ByButton].
  const ByButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.prefix,
    this.suffix,
    this.spacing = 8.0,
    this.badge,
    this.badgeAlignment = Alignment.topRight,
    this.isEnabled,
    this.isLoading,
    this.state = ByButtonState.idle,
    this.resultDuration = const Duration(milliseconds: 1000),
    this.variant = ByButtonVariant.filled,
    this.size = ByButtonSize.medium,
    this.width,
    this.height,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.successIconColor,
    this.errorIconColor,
    this.successIconGradient,
    this.errorIconGradient,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
    this.enablePressScale = true,
    this.pressedScale = 0.96,
    this.enableStateTransitionPulse = true,
    this.transitionPulseOrigin = ByBorderOrigin.topLeft,
    this.transitionPulseColors,
    this.transitionPulseGradient,
    this.enableTransitionPulseColors,
    this.disableTransitionPulseColors,
    this.transitionPulseWidth,
    this.transitionPulseDuration,
    this.enableTransitionPulseGlow = true,
    this.loadingPulseColors,
    this.loadingPulseGradient,
    this.loadingBorderWidth,
    this.loadingPulseWidth,
    this.loadingPulseDuration,
    this.enableLoadingPulseGlow = true,
    this.enableAmbientPulse = false,
    this.ambientPulseInterval = const Duration(seconds: 5),
    this.enableShimmer = false,
    this.morphDuration = const Duration(milliseconds: 300),
    this.morphCurve = Curves.easeInOutCubic,
    this.loadingPulseConfig,
    this.stateTransitionPulseConfig,
    this.dynamicBorder,
  });

  /// Factory constructor for a high-tech vibrant gradient [ByButton].
  const ByButton.gradient({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.prefix,
    this.suffix,
    this.spacing = 8.0,
    this.badge,
    this.badgeAlignment = Alignment.topRight,
    this.isEnabled,
    this.isLoading,
    this.state = ByButtonState.idle,
    this.resultDuration = const Duration(milliseconds: 1000),
    this.size = ByButtonSize.medium,
    this.width,
    this.height,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.successIconColor,
    this.errorIconColor,
    this.successIconGradient,
    this.errorIconGradient,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
    this.enablePressScale = true,
    this.pressedScale = 0.96,
    this.enableStateTransitionPulse = true,
    this.transitionPulseOrigin = ByBorderOrigin.topLeft,
    this.transitionPulseColors,
    this.transitionPulseGradient,
    this.enableTransitionPulseColors,
    this.disableTransitionPulseColors,
    this.transitionPulseWidth,
    this.transitionPulseDuration,
    this.enableTransitionPulseGlow = true,
    this.loadingPulseColors,
    this.loadingPulseGradient,
    this.loadingBorderWidth,
    this.loadingPulseWidth,
    this.loadingPulseDuration,
    this.enableLoadingPulseGlow = true,
    this.enableAmbientPulse = false,
    this.ambientPulseInterval = const Duration(seconds: 5),
    this.enableShimmer = false,
    this.morphDuration = const Duration(milliseconds: 300),
    this.morphCurve = Curves.easeInOutCubic,
    this.loadingPulseConfig,
    this.stateTransitionPulseConfig,
    this.dynamicBorder,
  }) : variant = ByButtonVariant.gradient;

  /// Factory constructor for an outline bordered [ByButton].
  const ByButton.outline({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.prefix,
    this.suffix,
    this.spacing = 8.0,
    this.badge,
    this.badgeAlignment = Alignment.topRight,
    this.isEnabled,
    this.isLoading,
    this.state = ByButtonState.idle,
    this.resultDuration = const Duration(milliseconds: 1000),
    this.size = ByButtonSize.medium,
    this.width,
    this.height,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.successIconColor,
    this.errorIconColor,
    this.successIconGradient,
    this.errorIconGradient,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
    this.enablePressScale = true,
    this.pressedScale = 0.96,
    this.enableStateTransitionPulse = true,
    this.transitionPulseOrigin = ByBorderOrigin.topLeft,
    this.transitionPulseColors,
    this.transitionPulseGradient,
    this.enableTransitionPulseColors,
    this.disableTransitionPulseColors,
    this.transitionPulseWidth,
    this.transitionPulseDuration,
    this.enableTransitionPulseGlow = true,
    this.loadingPulseColors,
    this.loadingPulseGradient,
    this.loadingBorderWidth,
    this.loadingPulseWidth,
    this.loadingPulseDuration,
    this.enableLoadingPulseGlow = true,
    this.enableAmbientPulse = false,
    this.ambientPulseInterval = const Duration(seconds: 5),
    this.enableShimmer = false,
    this.morphDuration = const Duration(milliseconds: 300),
    this.morphCurve = Curves.easeInOutCubic,
    this.loadingPulseConfig,
    this.stateTransitionPulseConfig,
    this.dynamicBorder,
  }) : variant = ByButtonVariant.outline;

  /// Factory constructor for a minimal borderless ghost [ByButton].
  const ByButton.ghost({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.prefix,
    this.suffix,
    this.spacing = 8.0,
    this.badge,
    this.badgeAlignment = Alignment.topRight,
    this.isEnabled,
    this.isLoading,
    this.state = ByButtonState.idle,
    this.resultDuration = const Duration(milliseconds: 1000),
    this.size = ByButtonSize.medium,
    this.width,
    this.height,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.successIconColor,
    this.errorIconColor,
    this.successIconGradient,
    this.errorIconGradient,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
    this.enablePressScale = true,
    this.pressedScale = 0.96,
    this.enableStateTransitionPulse = true,
    this.transitionPulseOrigin = ByBorderOrigin.topLeft,
    this.transitionPulseColors,
    this.transitionPulseGradient,
    this.enableTransitionPulseColors,
    this.disableTransitionPulseColors,
    this.transitionPulseWidth,
    this.transitionPulseDuration,
    this.enableTransitionPulseGlow = true,
    this.loadingPulseColors,
    this.loadingPulseGradient,
    this.loadingBorderWidth,
    this.loadingPulseWidth,
    this.loadingPulseDuration,
    this.enableLoadingPulseGlow = true,
    this.enableAmbientPulse = false,
    this.ambientPulseInterval = const Duration(seconds: 5),
    this.enableShimmer = false,
    this.morphDuration = const Duration(milliseconds: 300),
    this.morphCurve = Curves.easeInOutCubic,
    this.loadingPulseConfig,
    this.stateTransitionPulseConfig,
    this.dynamicBorder,
  }) : variant = ByButtonVariant.ghost;

  @override
  State<ByButton> createState() => _ByButtonState();
}

class _ByButtonState extends State<ByButton> with TickerProviderStateMixin {
  final GlobalKey _measureKey = GlobalKey();
  double _measuredNormalWidth = 0.0;

  // Animation controllers
  late AnimationController _morphController;
  late Animation<double> _morphAnimation;

  late AnimationController _pressController;
  late Animation<double> _pressScaleAnimation;

  late AnimationController _shimmerController;
  late AnimationController _resultScaleController;

  late AnimationController _staticBorderController;
  Timer? _staticBorderResumeTimer;

  // Pulse controllers for border interactions
  late ByDynamicBorderController _statePulseController;
  late ByDynamicBorderController _ambientPulseController;
  ByDynamicBorderController? _internalDynamicBorderController;

  // Internal transaction tracking
  bool _internalLoading = false;
  ByButtonState _activeState = ByButtonState.idle;
  Timer? _resultTimer;
  Timer? _ambientTimer;
  bool _isTransitionPulsing = false;

  // State pulse appearance cache
  List<Color> _currentStatePulseColors =
      ByButtonDefaults.enableTransitionPulseColors;

  ByDynamicBorderController get _effectivePulseController =>
      widget.dynamicBorder?.controller ??
      (_internalDynamicBorderController ??= ByDynamicBorderController());

  bool get _effectiveEnabled => widget.isEnabled ?? (widget.onPressed != null);

  bool get _isMorphedOrLoading {
    if (widget.isLoading == true) {
      return true;
    }
    if (_internalLoading) {
      return true;
    }
    if (widget.state != ByButtonState.idle) {
      return true;
    }
    if (_activeState != ByButtonState.idle) {
      return true;
    }
    return false;
  }

  ByButtonState get _effectiveState {
    if (widget.state != ByButtonState.idle) {
      return widget.state;
    }
    if (widget.isLoading == true) {
      return ByButtonState.loading;
    }
    return _activeState;
  }

  @override
  void initState() {
    super.initState();
    _activeState = widget.state;

    // Morph animation controller (rectangle <-> circle)
    _morphController = AnimationController(
      vsync: this,
      duration: widget.morphDuration,
    );
    _morphAnimation = CurvedAnimation(
      parent: _morphController,
      curve: widget.morphCurve,
    );

    // Tactile press scale controller
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pressScaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressedScale,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutBack,
    ));

    // Surface shimmer controller
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.enableShimmer) {
      _shimmerController.repeat();
    }

    // Result icon elastic scale controller
    _resultScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    final bool hasActivePulse = (widget.dynamicBorder != null &&
            widget.dynamicBorder!.enabled &&
            widget.dynamicBorder!.autoStart) ||
        _isMorphedOrLoading;

    _staticBorderController = AnimationController(
      vsync: this,
      duration: widget.dynamicBorder?.sensorEntranceDuration ??
          const Duration(milliseconds: 300),
      value: hasActivePulse ? 0.0 : 1.0,
    );

    _statePulseController = ByDynamicBorderController();
    _ambientPulseController = ByDynamicBorderController();

    if (_isMorphedOrLoading) {
      _morphController.value = 1.0;
      _resultScaleController.value = 1.0;
    }

    _startAmbientTimerIfNeeded();

    WidgetsBinding.instance.addPostFrameCallback((_) => _captureNaturalWidth());
  }

  void _handlePulseStart() {
    _staticBorderResumeTimer?.cancel();
    if (_staticBorderController.value > 0.0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _staticBorderController.value > 0.0) {
          _staticBorderController.value = 0.0;
        }
      });
    }
  }

  void _handlePulseComplete() {
    if (_isTransitionPulsing) {
      if (mounted) {
        setState(() {
          _isTransitionPulsing = false;
        });
      }
    }
    _staticBorderResumeTimer?.cancel();
    if (_isMorphedOrLoading) {
      return;
    }

    final Duration delay = widget.dynamicBorder?.sensorResumeDelay ??
        const Duration(milliseconds: 200);
    _staticBorderResumeTimer = Timer(delay, () {
      if (mounted && !_isMorphedOrLoading) {
        final Curve curve =
            widget.dynamicBorder?.sensorEntranceCurve ?? Curves.easeIn;
        _staticBorderController.animateTo(1.0, curve: curve);
      }
    });
  }

  void _captureNaturalWidth() {
    if (!mounted) {
      return;
    }
    final renderBox =
        _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize && renderBox.size.width > 0) {
      if (_morphController.value == 0.0) {
        _measuredNormalWidth = renderBox.size.width;
      }
    }
  }

  @override
  void didUpdateWidget(covariant ByButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update morph duration if changed
    if (widget.morphDuration != oldWidget.morphDuration) {
      _morphController.duration = widget.morphDuration;
    }

    if (widget.dynamicBorder?.sensorEntranceDuration !=
        oldWidget.dynamicBorder?.sensorEntranceDuration) {
      _staticBorderController.duration =
          widget.dynamicBorder?.sensorEntranceDuration ??
              const Duration(milliseconds: 300);
    }

    // Handle isEnabled state transition pulse
    final oldEnabled = oldWidget.isEnabled ?? (oldWidget.onPressed != null);
    final newEnabled = _effectiveEnabled;
    if (oldEnabled != newEnabled && widget.enableStateTransitionPulse) {
      _triggerStateTransitionPulse(newEnabled);
    }

    // Handle shimmer toggle
    if (widget.enableShimmer != oldWidget.enableShimmer) {
      if (widget.enableShimmer) {
        _shimmerController.repeat();
      } else {
        _shimmerController.stop();
      }
    }

    // Handle ambient pulse schedule changes
    if (widget.enableAmbientPulse != oldWidget.enableAmbientPulse ||
        widget.ambientPulseInterval != oldWidget.ambientPulseInterval) {
      _startAmbientTimerIfNeeded();
    }

    // Handle external state / isLoading changes
    final oldMorphed = (oldWidget.isLoading == true) ||
        (oldWidget.state != ByButtonState.idle);
    final newMorphed = _isMorphedOrLoading;
    if (oldMorphed != newMorphed) {
      if (newMorphed) {
        _handlePulseStart();
        _captureNaturalWidth();
        _morphController.forward();
        _resultScaleController.forward();
      } else {
        _morphController.reverse().then((_) {
          if (mounted && !_isMorphedOrLoading) {
            _handlePulseComplete();
          }
        });
        _resultScaleController.reverse();
      }
    }
  }

  void _triggerStateTransitionPulse(bool enabled) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final defaultColors = [
      onSurface,
      onSurface.withValues(alpha: 0.7),
    ];

    final resolvedColors = (enabled
            ? widget.enableTransitionPulseColors
            : widget.disableTransitionPulseColors) ??
        widget.transitionPulseColors ??
        (enabled
            ? defaultColors
            : ByButtonDefaults.disableTransitionPulseColors);

    setState(() {
      _isTransitionPulsing = true;
      _currentStatePulseColors =
          resolvedColors.isNotEmpty ? resolvedColors : defaultColors;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _handlePulseStart();
        _effectivePulseController.pulse();
      }
    });
  }

  void _startAmbientTimerIfNeeded() {
    _ambientTimer?.cancel();
    if (widget.enableAmbientPulse && _effectiveEnabled) {
      _ambientTimer = Timer.periodic(widget.ambientPulseInterval, (_) {
        if (mounted && _effectiveEnabled && !_isMorphedOrLoading) {
          _ambientPulseController.pulse();
        }
      });
    }
  }

  void _scheduleResultRestore() {
    _resultTimer?.cancel();
    _resultTimer = Timer(widget.resultDuration, () {
      if (mounted) {
        setState(() {
          _activeState = ByButtonState.idle;
          _internalLoading = false;
        });
        _resultScaleController.reverse();
        _morphController.reverse().then((_) {
          if (mounted && !_isMorphedOrLoading) {
            _handlePulseComplete();
          }
        });
      }
    });
  }

  Future<void> _handleTap() async {
    if (!_effectiveEnabled || _isMorphedOrLoading) {
      return;
    }
    if (widget.onPressed == null) {
      return;
    }

    final result = widget.onPressed!();
    if (result is Future) {
      _captureNaturalWidth();
      _handlePulseStart();
      setState(() {
        _internalLoading = true;
        _activeState = ByButtonState.loading;
      });
      _morphController.forward();

      try {
        await result;
        if (!mounted) {
          return;
        }
        _effectivePulseController.stop();
        setState(() {
          _internalLoading = false;
          _activeState = ByButtonState.success;
        });
        _resultScaleController.forward(from: 0.0);
        _scheduleResultRestore();
      } catch (_) {
        if (!mounted) {
          return;
        }
        _effectivePulseController.stop();
        setState(() {
          _internalLoading = false;
          _activeState = ByButtonState.error;
        });
        _resultScaleController.forward(from: 0.0);
        _scheduleResultRestore();
      }
    }
  }

  void _handleTapDown(TapDownDetails _) {
    if (!_effectiveEnabled || _isMorphedOrLoading || !widget.enablePressScale) {
      return;
    }
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    if (!widget.enablePressScale) {
      return;
    }
    _pressController.reverse();
  }

  void _handleTapCancel() {
    if (!widget.enablePressScale) {
      return;
    }
    _pressController.reverse();
  }

  @override
  void dispose() {
    _morphController.dispose();
    _pressController.dispose();
    _shimmerController.dispose();
    _resultScaleController.dispose();
    _staticBorderController.dispose();
    _statePulseController.dispose();
    _ambientPulseController.dispose();
    _internalDynamicBorderController?.dispose();
    _staticBorderResumeTimer?.cancel();
    _resultTimer?.cancel();
    _ambientTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Resolve explicit styles with priority over presets
    final customStyleWithOverrides =
        (widget.style ?? const ByButtonStyle()).copyWith(
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      borderRadius: widget.borderRadius,
      borderWidth: widget.borderWidth,
      loadingBorderWidth: widget.loadingBorderWidth,
      borderColor: widget.borderColor,
    );

    final resolvedStyle = ByButtonDefaults.resolve(
      context: context,
      variant: widget.variant,
      size: widget.size,
      customStyle: customStyleWithOverrides,
    );

    final isEnabled = _effectiveEnabled;
    final resolvedHeight =
        widget.height ?? ByButtonDefaults.heightFor(widget.size);
    final normalRadius = widget.borderRadius ??
        resolvedStyle.borderRadius ??
        ByButtonDefaults.borderRadiusFor(widget.size);
    final normalRadiusVal = normalRadius.topLeft.x;
    final circleRadiusVal = resolvedHeight / 2.0;

    // Resolved colors based on enabled state
    final effectiveBg = isEnabled
        ? resolvedStyle.backgroundColor
        : resolvedStyle.disabledBackgroundColor;
    final effectiveGradient = isEnabled
        ? resolvedStyle.backgroundGradient
        : resolvedStyle.disabledBackgroundGradient;
    final effectiveFg = isEnabled
        ? (resolvedStyle.foregroundColor ?? Colors.white)
        : (resolvedStyle.disabledForegroundColor ?? Colors.grey);
    final effectiveBorderColor = widget.borderColor ??
        (isEnabled
            ? resolvedStyle.borderColor
            : resolvedStyle.disabledBorderColor);
    final effectiveBorderWidth = widget.borderWidth ??
        (isEnabled
            ? (resolvedStyle.borderWidth ?? ByButtonDefaults.defaultBorderWidth)
            : (resolvedStyle.disabledBorderWidth ?? 1.0));

    // Resolve loading border width with intelligent fallback cascade:
    // 1. Explicit widget.loadingBorderWidth ?? widget.loadingPulseWidth
    // 2. Explicit widget.dynamicBorder?.width
    // 3. If unset, inherit idle border width when set and > 0 (widget.borderWidth or resolvedStyle.borderWidth)
    // 4. If idle border is empty/zero/null, fallback to ByButtonDefaults.defaultPulseWidth (2.5px)
    final double? explicitLoadingWidth =
        widget.loadingBorderWidth ?? widget.loadingPulseWidth;
    final double effectiveLoadingBorderWidth = explicitLoadingWidth ??
        widget.dynamicBorder?.width ??
        (widget.borderWidth != null && widget.borderWidth! > 0.0
            ? widget.borderWidth!
            : (resolvedStyle.borderWidth != null &&
                    resolvedStyle.borderWidth! > 0.0
                ? resolvedStyle.borderWidth!
                : ByButtonDefaults.defaultPulseWidth));

    final double effectiveTransitionPulseWidth = widget.transitionPulseWidth ??
        widget.dynamicBorder?.width ??
        (widget.borderWidth != null && widget.borderWidth! > 0.0
            ? widget.borderWidth!
            : ByButtonDefaults.defaultPulseWidth);

    final double pulseWidth = widget.dynamicBorder?.width ??
        (widget.borderWidth != null && widget.borderWidth! > 0.0
            ? widget.borderWidth!
            : ByButtonDefaults.defaultPulseWidth);
    final effectiveShadows =
        isEnabled ? resolvedStyle.shadows : resolvedStyle.disabledShadows;
    final effectiveCursor = isEnabled
        ? (resolvedStyle.enabledCursor ?? SystemMouseCursors.click)
        : (resolvedStyle.disabledCursor ?? SystemMouseCursors.forbidden);
    final effectiveIconColor = isEnabled
        ? (resolvedStyle.iconColor ?? effectiveFg)
        : (resolvedStyle.disabledIconColor ?? effectiveFg);

    final resolvedPadding =
        resolvedStyle.padding ?? ByButtonDefaults.paddingFor(widget.size);

    return MouseRegion(
      cursor: effectiveCursor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _handleTap,
        onLongPress: isEnabled ? widget.onLongPress : null,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _morphAnimation,
            _pressScaleAnimation,
            _shimmerController,
            _resultScaleController,
            _staticBorderController,
          ]),
          builder: (context, _) {
            final morphProgress = _morphAnimation.value;
            final currentRadiusVal =
                lerpDouble(normalRadiusVal, circleRadiusVal, morphProgress)!;
            final currentBorderRadius = BorderRadius.circular(currentRadiusVal);

            // Modulate static border alpha: strictly 0.0 during loading/morph or pulse traversal
            final double borderAlpha = _isMorphedOrLoading
                ? 0.0
                : (effectiveBorderColor != null
                    ? (effectiveBorderColor.a * _staticBorderController.value)
                        .clamp(0.0, 1.0)
                    : 1.0);

            // Button body (surface background, shape, shadows, and content)
            Widget buttonBody = AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              height: resolvedHeight,
              decoration: BoxDecoration(
                color: effectiveGradient == null ? effectiveBg : null,
                gradient: effectiveGradient,
                borderRadius: currentBorderRadius,
                border: effectiveBorderWidth > 0 && effectiveBorderColor != null
                    ? Border.all(
                        color: effectiveBorderColor.withValues(
                          alpha: borderAlpha,
                        ),
                        width: effectiveBorderWidth,
                      )
                    : null,
                boxShadow: morphProgress < 0.5 ? effectiveShadows : null,
              ),
              child: ClipRRect(
                borderRadius: currentBorderRadius,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Surface Shimmer Pass (if enabled)
                    if (widget.enableShimmer &&
                        isEnabled &&
                        morphProgress < 0.2)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ByShimmerPainter(
                            progress: _shimmerController.value,
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                      ),

                    // Unmorphed Content with Overflow Isolation
                    Opacity(
                      opacity: (1.0 - morphProgress * 2.8).clamp(0.0, 1.0),
                      child: Offstage(
                        offstage: morphProgress >= 0.35,
                        child: ClipRect(
                          child: OverflowBox(
                            minWidth: 0.0,
                            maxWidth: double.infinity,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: resolvedPadding,
                              child: IconTheme(
                                data: IconThemeData(
                                  color: effectiveIconColor,
                                  size: resolvedStyle.iconSize ??
                                      ByButtonDefaults.iconSizeFor(widget.size),
                                ),
                                child: DefaultTextStyle(
                                  style:
                                      ByButtonDefaults.textStyleFor(widget.size)
                                          .copyWith(color: effectiveFg),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (widget.prefix != null) ...[
                                        widget.prefix!,
                                        SizedBox(width: widget.spacing),
                                      ],
                                      widget.child,
                                      if (widget.suffix != null) ...[
                                        SizedBox(width: widget.spacing),
                                        widget.suffix!,
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Morphed Circular Result Content (Success Check or Error Cross)
                    if (morphProgress > 0.3 &&
                        _effectiveState != ByButtonState.loading)
                      Opacity(
                        opacity: ((morphProgress - 0.3) / 0.7).clamp(0.0, 1.0),
                        child: SizedBox(
                          width: resolvedHeight,
                          height: resolvedHeight,
                          child: _buildMorphedResultIcon(
                            resolvedHeight: resolvedHeight,
                            effectiveFg: effectiveFg,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );

            // Dynamic border configuration resolved for outer perimeter layer
            ByDynamicBorder? effectiveDynamicBorder;

            if (widget.dynamicBorder != null) {
              if (_effectiveState == ByButtonState.loading) {
                effectiveDynamicBorder = widget.dynamicBorder!.copyWith(
                  enabled: true,
                  autoStart: true,
                  repeatCount: null,
                  periodicInterval: Duration.zero,
                  origin: ByBorderOrigin.topLeft,
                  colors:
                      widget.loadingPulseColors ?? widget.dynamicBorder!.colors,
                  gradient: widget.loadingPulseGradient ??
                      widget.dynamicBorder!.gradient,
                  width: effectiveLoadingBorderWidth,
                  controller: _effectivePulseController,
                );
              } else if (_isTransitionPulsing) {
                effectiveDynamicBorder = widget.dynamicBorder!.copyWith(
                  enabled: true,
                  autoStart: true,
                  repeatCount: 1,
                  periodicInterval: null,
                  origin: widget.transitionPulseOrigin,
                  colors: _currentStatePulseColors,
                  gradient: widget.transitionPulseGradient,
                  width: effectiveTransitionPulseWidth,
                  duration: widget.transitionPulseDuration ??
                      widget.dynamicBorder!.duration,
                  controller: _effectivePulseController,
                );
              } else if (_effectiveState == ByButtonState.success ||
                  _effectiveState == ByButtonState.error) {
                effectiveDynamicBorder = null;
              } else if (isEnabled) {
                effectiveDynamicBorder = widget.dynamicBorder!.copyWith(
                  enabled: widget.dynamicBorder!.enabled,
                  width: pulseWidth,
                  controller: _effectivePulseController,
                );
              } else {
                effectiveDynamicBorder = widget.dynamicBorder!.copyWith(
                  enabled: widget.dynamicBorder!.enabled,
                  periodicInterval: null,
                  autoStart: false,
                  width: pulseWidth,
                  controller: _effectivePulseController,
                );
              }
            } else if (_effectiveState == ByButtonState.loading) {
              effectiveDynamicBorder = widget.loadingPulseConfig ??
                  ByDynamicBorder(
                    origin: ByBorderOrigin.topLeft,
                    colors: widget.loadingPulseColors ??
                        (effectiveBorderColor != null
                            ? [
                                effectiveBorderColor,
                                effectiveBorderColor.withValues(alpha: 0.7),
                              ]
                            : ByButtonDefaults.defaultLoadingPulseColors),
                    gradient: widget.loadingPulseGradient,
                    duration: widget.loadingPulseDuration ??
                        const Duration(milliseconds: 1400),
                    beamLength: 0.30,
                    width: effectiveLoadingBorderWidth,
                    shadowBlur: widget.enableLoadingPulseGlow
                        ? ByButtonDefaults.defaultPulseShadowBlur
                        : 0.0,
                    shadowWidth: widget.enableLoadingPulseGlow
                        ? ByButtonDefaults.defaultPulseShadowWidth
                        : 0.0,
                    repeatCount: null,
                    autoStart: true,
                    controller: _effectivePulseController,
                  );
            } else if (_isTransitionPulsing &&
                widget.enableStateTransitionPulse) {
              effectiveDynamicBorder = widget.stateTransitionPulseConfig ??
                  ByDynamicBorder(
                    origin: widget.transitionPulseOrigin,
                    colors: _currentStatePulseColors,
                    gradient: widget.transitionPulseGradient,
                    duration: widget.transitionPulseDuration ??
                        const Duration(milliseconds: 1200),
                    beamLength: 0.30,
                    width: effectiveTransitionPulseWidth,
                    shadowBlur: widget.enableTransitionPulseGlow
                        ? ByButtonDefaults.defaultPulseShadowBlur
                        : 0.0,
                    shadowWidth: widget.enableTransitionPulseGlow
                        ? ByButtonDefaults.defaultPulseShadowWidth
                        : 0.0,
                    repeatCount: 1,
                    autoStart: true,
                    controller: _effectivePulseController,
                  );
            } else if (widget.enableAmbientPulse &&
                isEnabled &&
                !_isMorphedOrLoading) {
              effectiveDynamicBorder = ByDynamicBorder(
                origin: ByBorderOrigin.topCenter,
                colors: const [Color(0xFF38BDF8), Color(0xFF818CF8)],
                duration: const Duration(milliseconds: 1600),
                beamLength: 0.32,
                width: pulseWidth,
                shadowBlur: ByButtonDefaults.defaultPulseShadowBlur,
                shadowWidth: ByButtonDefaults.defaultPulseShadowWidth,
                repeatCount: 1,
                autoStart: false,
                controller: _ambientPulseController,
              );
            }

            // Layer ByDynamicBorderLayer directly around buttonBody on exact outer perimeter
            Widget layeredButton = buttonBody;
            if (effectiveDynamicBorder != null) {
              layeredButton = ByDynamicBorderLayer(
                config: effectiveDynamicBorder,
                borderRadius: currentBorderRadius,
                onPulseStart: _handlePulseStart,
                onPulseComplete: _handlePulseComplete,
                child: buttonBody,
              );
            }

            // Tactile scale transform
            Widget transformed = Transform.scale(
              scale: _pressScaleAnimation.value,
              child: layeredButton,
            );

            // Continuous Synchronized Width Interpolation
            Widget layout;
            if (widget.width != null) {
              if (widget.width!.isFinite) {
                final currentWidth =
                    lerpDouble(widget.width!, resolvedHeight, morphProgress)!;
                layout = SizedBox(
                  width: currentWidth,
                  height: resolvedHeight,
                  child: transformed,
                );
              } else {
                // Non-finite width, e.g. double.infinity
                if (morphProgress > 0.0) {
                  final baseWidth =
                      _measuredNormalWidth > 0 ? _measuredNormalWidth : 200.0;
                  final currentWidth =
                      lerpDouble(baseWidth, resolvedHeight, morphProgress)!;
                  layout = SizedBox(
                    width: currentWidth,
                    height: resolvedHeight,
                    child: transformed,
                  );
                } else {
                  layout = SizedBox(
                    key: _measureKey,
                    width: widget.width,
                    height: resolvedHeight,
                    child: transformed,
                  );
                }
              }
            } else {
              // Wrap content: interpolate continuously from natural measured width to resolvedHeight
              if (morphProgress > 0.0) {
                final baseWidth =
                    _measuredNormalWidth > 0 ? _measuredNormalWidth : 160.0;
                final currentWidth =
                    lerpDouble(baseWidth, resolvedHeight, morphProgress)!;
                layout = SizedBox(
                  width: currentWidth,
                  height: resolvedHeight,
                  child: transformed,
                );
              } else {
                layout = Container(
                  key: _measureKey,
                  child: transformed,
                );
              }
            }

            // Optional Floating Badge
            if (widget.badge != null) {
              return Stack(
                clipBehavior: Clip.none,
                alignment: widget.badgeAlignment,
                children: [
                  layout,
                  Positioned(
                    top: widget.badgeAlignment == Alignment.topRight ||
                            widget.badgeAlignment == Alignment.topLeft
                        ? -4.0
                        : null,
                    bottom: widget.badgeAlignment == Alignment.bottomRight ||
                            widget.badgeAlignment == Alignment.bottomLeft
                        ? -4.0
                        : null,
                    right: widget.badgeAlignment == Alignment.topRight ||
                            widget.badgeAlignment == Alignment.bottomRight
                        ? -4.0
                        : null,
                    left: widget.badgeAlignment == Alignment.topLeft ||
                            widget.badgeAlignment == Alignment.bottomLeft
                        ? -4.0
                        : null,
                    child: widget.badge!,
                  ),
                ],
              );
            }

            return layout;
          },
        ),
      ),
    );
  }

  Widget _buildMorphedResultIcon({
    required double resolvedHeight,
    required Color effectiveFg,
  }) {
    final state = _effectiveState;

    switch (state) {
      case ByButtonState.success:
        Widget icon = Icon(
          Icons.check_rounded,
          color: widget.successIconGradient != null
              ? Colors.white
              : (widget.successIconColor ?? effectiveFg),
          size: resolvedHeight * 0.52,
        );
        if (widget.successIconGradient != null) {
          icon = ShaderMask(
            shaderCallback: (bounds) =>
                widget.successIconGradient!.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: icon,
          );
        }
        return Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _resultScaleController,
              curve: Curves.elasticOut,
            ),
            child: icon,
          ),
        );

      case ByButtonState.error:
        Widget icon = Icon(
          Icons.close_rounded,
          color: widget.errorIconGradient != null
              ? Colors.white
              : (widget.errorIconColor ?? effectiveFg),
          size: resolvedHeight * 0.52,
        );
        if (widget.errorIconGradient != null) {
          icon = ShaderMask(
            shaderCallback: (bounds) =>
                widget.errorIconGradient!.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: icon,
          );
        }
        return Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _resultScaleController,
              curve: Curves.elasticOut,
            ),
            child: icon,
          ),
        );

      case ByButtonState.loading:
      case ByButtonState.idle:
        return const SizedBox.shrink();
    }
  }
}

/// Custom painter for surface shimmer sheen effect.
class _ByShimmerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ByShimmerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double diagonal = width + height;
    final double currentOffset = -height + (progress * (diagonal + height));

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          color,
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(currentOffset, 0, height * 1.5, height));

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
  }

  @override
  bool shouldRepaint(covariant _ByShimmerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
