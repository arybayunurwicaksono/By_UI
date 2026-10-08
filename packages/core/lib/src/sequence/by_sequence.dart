import 'dart:async';
import 'package:flutter/widgets.dart';
import 'by_sequence_animation.dart';
import 'by_sequence_controller.dart';
import 'by_sequence_item.dart';

/// A sequential, scroll-driven widget animation component for Flutter.
///
/// Reveals a sequence of [children] progressively as the user scrolls,
/// abstracting away manual [ScrollController] and interpolation management.
class BySequence extends StatefulWidget {
  /// The list of widgets to display and animate sequentially.
  final List<Widget> children;

  /// Default animation transformation specification for children.
  final BySequenceAnimation animation;

  /// Duration of non-scrub triggered animations.
  final Duration duration;

  /// Easing curve applied to sequence animation transitions.
  final Curve curve;

  /// Relative viewport trigger position (0.0 = top, 0.5 = middle, 1.0 = bottom).
  ///
  /// Defaults to 0.75 (75% down the viewport).
  final double trigger;

  /// Optional fixed extent (height for vertical, width for horizontal) for each item.
  final double? itemExtent;

  /// Distance in pixels between consecutive items.
  final double spacing;

  /// When `true`, animation progress is tied 1:1 to scroll position (GSAP scrub style).
  /// When `false`, entering the trigger zone starts a one-shot timed animation.
  final bool scrub;

  /// When `true`, scrolling back up reverses the reveal animation.
  /// When `false`, revealed items permanently remain in their completed state.
  final bool reverse;

  /// When `true`, re-entering the trigger zone replays the animation.
  final bool replay;

  /// Whether to maintain the state of revealed widgets. Defaults to `true`.
  final bool maintainState;

  /// Optional external [ScrollController] to attach to.
  final ScrollController? controller;

  /// The scroll and layout direction of the sequence.
  final Axis scrollDirection;

  /// Optional physics for the scrollable container when [shrinkWrap] is `false`.
  final ScrollPhysics? physics;

  /// Padding around the sequence list.
  final EdgeInsetsGeometry? padding;

  /// When `true`, does not create an internal scrollable and sizes itself to its children.
  /// Useful when embedding [BySequence] inside an existing ancestor scrollable.
  final bool shrinkWrap;

  /// Callback fired when overall sequence progress changes (0.0 to 1.0).
  final ValueChanged<double>? onProgress;

  /// Callback fired when an individual child's progress changes.
  final void Function(int index, double progress)? onItemProgress;

  /// Callback fired when an item enters the trigger zone.
  final ValueChanged<int>? onItemEnter;

  /// Callback fired when an item completes its reveal transition.
  final ValueChanged<int>? onItemComplete;

  /// Callback fired when all items in the sequence have completed revealing.
  final VoidCallback? onSequenceComplete;

  /// Optional initial visible fraction of the viewport (e.g. 1.0 for 100% screen, 0.5 for 50%).
  ///
  /// When specified, all items fitting within this fraction of the viewport at the initial
  /// scroll position are fully revealed immediately, while any item extending beyond this
  /// boundary starts completely hidden (0.0 progress/opacity) until the user scrolls.
  final double? initialVisibleFraction;

  /// Optional discrete number of items initially revealed at start (e.g. 1 for Standard, 3 for Extended).
  ///
  /// Items with index < [initialVisibleCount] are fully revealed immediately, while subsequent
  /// items remain completely transparent and reveal strictly one-by-one as the user scrolls.
  final int? initialVisibleCount;

  /// Number of consecutive items grouped together into a batch reveal transition.
  ///
  /// When set to `0` (default), it automatically matches the active animation range limit:
  /// - Standard (40px): batch of 1 item
  /// - Extended (80px): batch of 3 items
  /// - 50% Screen: batch of 5 items
  /// - 100% Screen: batch of full viewport items
  /// When set to `N > 1` (e.g. `5`), items are chunked into fixed groups of `N` and
  /// trigger an animated cascading stagger wave as each batch crosses the viewport trigger line.
  final int groupSize;

  /// Stagger delay applied between items within a group during non-scrub animations.
  ///
  /// Defaults to `const Duration(milliseconds: 70)`.
  final Duration groupStaggerDelay;

  /// Normalized stagger ratio (0.0 to 1.0) between items within a group during scrub mode.
  ///
  /// Defaults to `0.05`.
  final double groupStagger;

  /// Optional scroll distance required to reveal each subsequent item or batch.
  ///
  /// When specified (e.g. `40.0` for Standard, `80.0` for Extended):
  /// - If [groupSize] <= 1: items reveal strictly one-by-one as the user scrolls,
  ///   with each item requiring [rangeDistance] of scroll distance to unlock.
  /// - If [groupSize] > 1: each batch of items unlocks when the user has scrolled
  ///   70% of the batch threshold distance, triggering a cascading stagger wave.
  ///
  /// When omitted (`null`), elements trigger naturally based on pure viewport intersection.
  final double? rangeDistance;

  /// Creates a [BySequence] component.
  const BySequence({
    super.key,
    required this.children,
    this.animation = BySequenceAnimation.defaultAnimation,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.trigger = 0.75,
    this.itemExtent,
    this.spacing = 0.0,
    this.scrub = true,
    this.reverse = true,
    this.replay = false,
    this.maintainState = true,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.initialVisibleFraction,
    this.initialVisibleCount,
    this.groupSize = 0,
    this.groupStaggerDelay = const Duration(milliseconds: 70),
    this.groupStagger = 0.05,
    this.rangeDistance,
    this.onProgress,
    this.onItemProgress,
    this.onItemEnter,
    this.onItemComplete,
    this.onSequenceComplete,
  });

  @override
  State<BySequence> createState() => _BySequenceState();
}

class _BySequenceState extends State<BySequence> {
  late BySequenceController _sequenceController;
  ScrollController? _internalScrollController;
  final List<GlobalKey<_BySequenceItemHostState>> _itemKeys = [];

  ScrollController get _effectiveScrollController =>
      widget.controller ?? (_internalScrollController ??= ScrollController());

  @override
  void initState() {
    super.initState();
    _initSequence();
  }

  void _initSequence() {
    _sequenceController = BySequenceController(
      itemCount: widget.children.length,
      initialVisibleCount: widget.initialVisibleCount,
      groupSize: widget.groupSize,
      groupStaggerDelay: widget.groupStaggerDelay,
      groupStagger: widget.groupStagger,
      onProgress: widget.onProgress,
      onItemProgress: widget.onItemProgress,
      onItemEnter: widget.onItemEnter,
      onItemComplete: widget.onItemComplete,
      onSequenceComplete: widget.onSequenceComplete,
    );
    _sequenceController.addListener(_onSequenceControllerUpdate);

    _updateItemKeys();

    if (widget.controller != null) {
      widget.controller!.addListener(_onScrollUpdate);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkAllItemPositions();
      }
    });
  }

  void _onSequenceControllerUpdate() {
    if (!mounted) return;
    for (int i = 0; i < _itemKeys.length; i++) {
      _itemKeys[i].currentState?.onBatchStateChanged();
    }
  }

  void _updateItemKeys() {
    _itemKeys.clear();
    for (int i = 0; i < widget.children.length; i++) {
      _itemKeys.add(GlobalKey<_BySequenceItemHostState>());
    }
  }

  @override
  void didUpdateWidget(BySequence oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length ||
        widget.groupSize != oldWidget.groupSize ||
        widget.initialVisibleCount != oldWidget.initialVisibleCount ||
        widget.initialVisibleFraction != oldWidget.initialVisibleFraction) {
      _sequenceController.removeListener(_onSequenceControllerUpdate);
      _sequenceController.dispose();
      _initSequence();
    } else {
      _sequenceController.onProgress = widget.onProgress;
      _sequenceController.onItemProgress = widget.onItemProgress;
      _sequenceController.onItemEnter = widget.onItemEnter;
      _sequenceController.onItemComplete = widget.onItemComplete;
      _sequenceController.onSequenceComplete = widget.onSequenceComplete;
    }

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onScrollUpdate);
      widget.controller?.addListener(_onScrollUpdate);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onScrollUpdate);
    _internalScrollController?.dispose();
    _sequenceController.removeListener(_onSequenceControllerUpdate);
    _sequenceController.dispose();
    super.dispose();
  }

  void _onScrollUpdate() {
    _checkAllItemPositions();
  }

  void _checkAllItemPositions() {
    if (!mounted || widget.children.isEmpty) return;

    for (int i = 0; i < _itemKeys.length; i++) {
      final key = _itemKeys[i];
      key.currentState?.evaluatePosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget content;
    final List<Widget> items = [];

    for (int i = 0; i < widget.children.length; i++) {
      final childWidget = widget.children[i];
      BySequenceAnimation itemAnim = widget.animation;
      Duration itemDuration = widget.duration;
      Curve itemCurve = widget.curve;
      double itemTrigger = widget.trigger;
      bool itemScrub = widget.scrub;

      if (childWidget is BySequenceItem) {
        itemAnim = childWidget.animation ?? itemAnim;
        itemDuration = childWidget.duration ?? itemDuration;
        itemCurve = childWidget.curve ?? itemCurve;
        itemTrigger = childWidget.trigger ?? itemTrigger;
        itemScrub = childWidget.scrub ?? itemScrub;
      }

      final host = _BySequenceItemHost(
        key: _itemKeys[i],
        index: i,
        totalCount: widget.children.length,
        animation: itemAnim,
        duration: itemDuration,
        curve: itemCurve,
        trigger: itemTrigger,
        itemExtent: widget.itemExtent,
        scrub: itemScrub,
        reverse: widget.reverse,
        replay: widget.replay,
        maintainState: widget.maintainState,
        scrollDirection: widget.scrollDirection,
        controller: _sequenceController,
        initialVisibleFraction: widget.initialVisibleFraction,
        initialVisibleCount: widget.initialVisibleCount,
        groupSize: widget.groupSize,
        groupStaggerDelay: widget.groupStaggerDelay,
        groupStagger: widget.groupStagger,
        rangeDistance: widget.rangeDistance,
        child: childWidget,
      );

      items.add(host);

      if (widget.spacing > 0 && i < widget.children.length - 1) {
        items.add(
          widget.scrollDirection == Axis.vertical
              ? SizedBox(height: widget.spacing)
              : SizedBox(width: widget.spacing),
        );
      }
    }

    if (widget.shrinkWrap) {
      content = widget.scrollDirection == Axis.vertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: items,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: items,
            );

      if (widget.padding != null) {
        content = Padding(padding: widget.padding!, child: content);
      }
    } else {
      content = SingleChildScrollView(
        controller: _effectiveScrollController,
        scrollDirection: widget.scrollDirection,
        physics: widget.physics,
        padding: widget.padding,
        child: widget.scrollDirection == Axis.vertical
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items,
              ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkAllItemPositions();
        return false;
      },
      child: content,
    );
  }
}

class _BySequenceItemHost extends StatefulWidget {
  final int index;
  final int totalCount;
  final Widget child;
  final BySequenceAnimation animation;
  final Duration duration;
  final Curve curve;
  final double trigger;
  final double? itemExtent;
  final bool scrub;
  final bool reverse;
  final bool replay;
  final bool maintainState;
  final Axis scrollDirection;
  final BySequenceController controller;
  final double? initialVisibleFraction;
  final int? initialVisibleCount;
  final int groupSize;
  final Duration groupStaggerDelay;
  final double groupStagger;
  final double? rangeDistance;

  const _BySequenceItemHost({
    super.key,
    required this.index,
    required this.totalCount,
    required this.child,
    required this.animation,
    required this.duration,
    required this.curve,
    required this.trigger,
    required this.itemExtent,
    required this.scrub,
    required this.reverse,
    required this.replay,
    required this.maintainState,
    required this.scrollDirection,
    required this.controller,
    this.initialVisibleFraction,
    this.initialVisibleCount,
    this.groupSize = 0,
    this.groupStaggerDelay = const Duration(milliseconds: 70),
    this.groupStagger = 0.05,
    this.rangeDistance,
  });

  @override
  State<_BySequenceItemHost> createState() => _BySequenceItemHostState();
}

class _BySequenceItemHostState extends State<_BySequenceItemHost>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<double> _progressNotifier;
  AnimationController? _animController;
  Animation<double>? _curvedAnim;
  Timer? _staggerTimer;
  bool _hasTriggered = false;
  bool _isInitiallyRevealed = false;
  bool _initialClassificationDone = false;

  @override
  void initState() {
    super.initState();
    final isInitial = widget.initialVisibleCount != null
        ? widget.index < widget.initialVisibleCount!
        : widget.index == 0;
    final initialProgress = isInitial ? 1.0 : 0.0;
    _progressNotifier = ValueNotifier<double>(initialProgress);

    _animController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _curvedAnim = CurvedAnimation(
      parent: _animController!,
      curve: widget.curve,
    );
    _animController!.addListener(() {
      final val = _curvedAnim!.value;
      _progressNotifier.value = val;
      widget.controller.updateItemProgress(widget.index, val);
    });
    if (isInitial) {
      _animController!.value = 1.0;
      _hasTriggered = true;
    }
  }

  @override
  void didUpdateWidget(_BySequenceItemHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialVisibleFraction != oldWidget.initialVisibleFraction ||
        widget.initialVisibleCount != oldWidget.initialVisibleCount ||
        widget.groupSize != oldWidget.groupSize) {
      _initialClassificationDone = false;
      _isInitiallyRevealed = false;
    }
  }

  @override
  void dispose() {
    _staggerTimer?.cancel();
    _animController?.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  void evaluatePosition() {
    if (!mounted) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;

    final scrollable = Scrollable.maybeOf(context);
    final ancestorBox = scrollable?.context.findRenderObject() as RenderBox?;

    final globalOffset = box.localToGlobal(Offset.zero, ancestor: ancestorBox);
    final isVertical = widget.scrollDirection == Axis.vertical;

    final itemPos = isVertical ? globalOffset.dy : globalOffset.dx;
    final itemExtent =
        widget.itemExtent ?? (isVertical ? box.size.height : box.size.width);

    final viewportLength = ancestorBox != null
        ? (isVertical ? ancestorBox.size.height : ancestorBox.size.width)
        : (isVertical
            ? MediaQuery.sizeOf(context).height
            : MediaQuery.sizeOf(context).width);

    if (viewportLength <= 0) return;

    // Viewport trigger line coordinate
    final double effectiveTriggerCoord = viewportLength * widget.trigger;

    final scrollPixels =
        (scrollable != null && scrollable.position.haveDimensions)
            ? scrollable.position.pixels
            : 0.0;
    final currentScroll = scrollPixels.clamp(0.0, double.infinity);
    final isAtBottom = scrollable != null &&
        scrollable.position.haveDimensions &&
        scrollable.position.maxScrollExtent > 0 &&
        scrollPixels >= scrollable.position.maxScrollExtent - 20.0;
    final unScrolledItemPos = itemPos + currentScroll;

    // Register item metrics with the sequence controller
    widget.controller.registerItemMetrics(
      widget.index,
      unScrolledItemPos,
      itemExtent,
    );

    // Classify which items belong to the initial screen viewport
    if (!_initialClassificationDone) {
      _initialClassificationDone = true;
      if (widget.initialVisibleCount != null) {
        if (widget.index < widget.initialVisibleCount!) {
          _isInitiallyRevealed = true;
        }
      } else if (widget.initialVisibleFraction != null) {
        final initialBoundary = viewportLength * widget.initialVisibleFraction!;
        if (unScrolledItemPos + itemExtent <= initialBoundary + 10.0) {
          _isInitiallyRevealed = true;
        }
      } else if (widget.index == 0) {
        _isInitiallyRevealed = true;
      }

      if (!_isInitiallyRevealed) {
        widget.controller.registerFirstHiddenIndex(widget.index);
      }
    }

    // Items that belong to the initial viewport reveal remain permanently at 1.0 (fully visible)
    if (_isInitiallyRevealed) {
      if (!_hasTriggered) {
        _hasTriggered = true;
        _animController?.value = 1.0;
      }
      _updateProgress(1.0);
      return;
    }

    final startIndex =
        widget.initialVisibleCount ?? widget.controller.startIndex;

    final effectiveGroupSize =
        widget.controller.getEffectiveGroupSize(startIndex);

    // Items outside the initial reveal set remain completely hidden at 0.0 until user scrolls
    if (currentScroll <= 0.001) {
      if (!_hasTriggered) {
        _animController?.value = 0.0;
        _updateProgress(0.0);
        return;
      } else if (widget.reverse) {
        _hasTriggered = false;
        _staggerTimer?.cancel();
        _staggerTimer = null;
        if (effectiveGroupSize > 1) {
          final groupFirstIndex =
              widget.controller.getGroupFirstIndex(widget.index, startIndex);
          widget.controller.unTriggerBatch(groupFirstIndex);
        }
        _animController?.value = 0.0;
        _updateProgress(0.0);
        return;
      }
      return;
    }

    final pacingStep = widget.rangeDistance ??
        (widget.initialVisibleFraction != null
            ? viewportLength * widget.initialVisibleFraction!
            : null);

    // MODE 1: GSAP Batched Stagger Wave (effectiveGroupSize > 1)
    if (effectiveGroupSize > 1) {
      final groupFirstIndex =
          widget.controller.getGroupFirstIndex(widget.index, startIndex);
      final isLead = widget.index == groupFirstIndex;

      bool isEntering;
      if (pacingStep != null && pacingStep > 0) {
        final batchIndex = (groupFirstIndex - startIndex) ~/ effectiveGroupSize;
        final prevBatchBottom = widget.controller.getPreviousBatchBottom(
          batchIndex,
          startIndex,
          effectiveGroupSize,
        );

        final double requiredBatchScroll;
        if (widget.rangeDistance != null && widget.rangeDistance! > 0) {
          requiredBatchScroll = (batchIndex + 0.70) * widget.rangeDistance!;
        } else if (prevBatchBottom > 0) {
          requiredBatchScroll = prevBatchBottom * 0.70;
        } else {
          requiredBatchScroll = (batchIndex + 0.70) * pacingStep;
        }

        isEntering = (currentScroll >= requiredBatchScroll || isAtBottom) &&
            itemPos <= effectiveTriggerCoord;

        // The lead of the batch monitors whether it crosses the viewport trigger line
        if (isLead) {
          if (isEntering) {
            widget.controller.triggerBatch(groupFirstIndex);
          } else if (widget.reverse) {
            widget.controller.unTriggerBatch(groupFirstIndex);
          }
        } else {
          if (isEntering) {
            widget.controller.triggerBatch(groupFirstIndex);
          } else if (widget.reverse && currentScroll < requiredBatchScroll) {
            widget.controller.unTriggerBatch(groupFirstIndex);
          }
        }
      } else {
        isEntering = itemPos <= effectiveTriggerCoord;
        if (isLead) {
          if (isEntering) {
            widget.controller.triggerBatch(groupFirstIndex);
          } else if (widget.reverse) {
            widget.controller.unTriggerBatch(groupFirstIndex);
          }
        } else {
          if (isEntering) {
            widget.controller.triggerBatch(groupFirstIndex);
          }
        }
      }

      onBatchStateChanged();
      return;
    }

    // MODE 2: Individual Item (effectiveGroupSize <= 1)
    if (widget.scrub) {
      double clamped;
      if (widget.rangeDistance != null && widget.rangeDistance! > 0) {
        final relIndex = widget.index - startIndex;
        final startScroll = relIndex * widget.rangeDistance!;
        final endScroll = startScroll + widget.rangeDistance!;

        if (currentScroll <= startScroll && !isAtBottom) {
          clamped = 0.0;
        } else if (currentScroll >= endScroll || isAtBottom) {
          clamped = itemPos <= effectiveTriggerCoord ? 1.0 : 0.0;
        } else {
          final scrollRatio =
              (currentScroll - startScroll) / (endScroll - startScroll);
          clamped = itemPos <= effectiveTriggerCoord ? scrollRatio : 0.0;
        }
      } else {
        // 1:1 Continuous Viewport Scrub
        final scrubWindow =
            (itemExtent > 0 ? itemExtent : 140.0).clamp(60.0, 350.0);
        final startCoord = effectiveTriggerCoord;
        final endCoord = startCoord - scrubWindow;

        if (itemPos >= startCoord) {
          clamped = 0.0;
        } else if (itemPos <= endCoord) {
          clamped = 1.0;
        } else {
          clamped = (startCoord - itemPos) / (startCoord - endCoord);
        }
      }

      _applyScrubProgress(clamped);
      return;
    }

    // MODE 3: Individual Item One-Shot Trigger (!widget.scrub)
    bool isTriggered;
    if (widget.rangeDistance != null && widget.rangeDistance! > 0) {
      final relIndex = widget.index - startIndex;
      final requiredScroll = (relIndex + 0.50) * widget.rangeDistance!;
      isTriggered = (currentScroll >= requiredScroll || isAtBottom) &&
          itemPos <= effectiveTriggerCoord;
    } else {
      isTriggered = itemPos <= effectiveTriggerCoord;
    }
    _applyNonScrubTrigger(isTriggered, 0);
  }

  void onBatchStateChanged() {
    if (!mounted || _isInitiallyRevealed) return;
    final startIndex =
        widget.initialVisibleCount ?? widget.controller.startIndex;
    final effectiveGroupSize =
        widget.controller.getEffectiveGroupSize(startIndex);
    if (effectiveGroupSize <= 1) return;

    final groupFirstIndex =
        widget.controller.getGroupFirstIndex(widget.index, startIndex);
    final k = (widget.index - startIndex) % effectiveGroupSize;
    final isBatchActive = widget.controller.isBatchTriggered(groupFirstIndex);

    if (isBatchActive) {
      if (!_hasTriggered || widget.replay) {
        _hasTriggered = true;
        _staggerTimer?.cancel();
        if (k == 0 || widget.groupStaggerDelay == Duration.zero) {
          _animController?.forward();
        } else {
          _staggerTimer = Timer(widget.groupStaggerDelay * k, () {
            if (mounted && _hasTriggered) {
              _animController?.forward();
            }
          });
        }
      }
    } else if (widget.reverse && _hasTriggered) {
      _hasTriggered = false;
      _staggerTimer?.cancel();
      _staggerTimer = null;
      _animController?.reverse();
    }
  }

  void _applyScrubProgress(double clamped) {
    final targetProgress = widget.curve.transform(clamped.clamp(0.0, 1.0));
    _animController?.value = targetProgress;

    if (widget.reverse) {
      _updateProgress(targetProgress);
    } else {
      if (targetProgress > _progressNotifier.value) {
        _updateProgress(targetProgress);
      }
    }
  }

  void _applyNonScrubTrigger(bool isTriggered, int k) {
    if (isTriggered) {
      if (!_hasTriggered || widget.replay) {
        _hasTriggered = true;
        _staggerTimer?.cancel();
        if (k == 0 || widget.groupStaggerDelay == Duration.zero) {
          _animController?.forward();
        } else {
          _staggerTimer = Timer(widget.groupStaggerDelay * k, () {
            if (mounted && _hasTriggered) {
              _animController?.forward();
            }
          });
        }
      }
    } else if (widget.reverse && _hasTriggered) {
      _hasTriggered = false;
      _staggerTimer?.cancel();
      _staggerTimer = null;
      _animController?.reverse();
    }
  }

  void _updateProgress(double val) {
    if ((_progressNotifier.value - val).abs() < 0.001) return;
    _progressNotifier.value = val;
    widget.controller.updateItemProgress(widget.index, val);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _progressNotifier,
      builder: (context, progress, _) {
        final anim = widget.animation;

        final opacityVal =
            (anim.opacity?.lerp(progress) ?? 1.0).clamp(0.0, 1.0);
        final transX = anim.translateX?.lerp(progress) ?? 0.0;
        final transY = anim.translateY?.lerp(progress) ?? 0.0;
        final scaleVal = anim.scale?.lerp(progress) ?? 1.0;
        final rotationVal = anim.rotation?.lerp(progress) ?? 0.0;

        Widget content = widget.child;

        // Apply transformations
        if (transX != 0.0 ||
            transY != 0.0 ||
            scaleVal != 1.0 ||
            rotationVal != 0.0) {
          final transform = Matrix4.identity()
            ..setTranslationRaw(transX, transY, 0.0)
            ..multiply(Matrix4.diagonal3Values(scaleVal, scaleVal, 1.0))
            ..rotateZ(rotationVal);

          content = Transform(
            transform: transform,
            alignment: Alignment.center,
            child: content,
          );
        }

        if (opacityVal < 1.0) {
          content = Opacity(
            opacity: opacityVal,
            child: content,
          );
        }

        // Layout stability: do not unmount widget; isolate repaint boundary
        return RepaintBoundary(
          child: content,
        );
      },
    );
  }
}
