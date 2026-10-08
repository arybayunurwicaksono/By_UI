import 'package:flutter/foundation.dart';

/// Controller that manages and observes progress across items within a [BySequence].
class BySequenceController extends ChangeNotifier {
  final int itemCount;
  final List<double> _itemProgress;
  final List<bool> _itemEntered;
  final List<bool> _itemCompleted;
  final List<double> _itemOffsets;
  final List<double> _itemExtents;
  double _globalProgress = 0.0;
  bool _isSequenceCompleted = false;
  int _firstHiddenIndex = -1;

  /// Callback fired when overall sequence progress updates (0.0 to 1.0).
  ValueChanged<double>? onProgress;

  /// Callback fired when an individual item's progress updates.
  void Function(int index, double progress)? onItemProgress;

  /// Callback fired when an item enters the trigger zone (progress > 0.0).
  ValueChanged<int>? onItemEnter;

  /// Callback fired when an item completes its transition (progress == 1.0).
  ValueChanged<int>? onItemComplete;

  /// Optional number of initial items visible by default.
  final int? initialVisibleCount;

  /// Number of consecutive items grouped together into a batch reveal transition.
  /// When `0`, automatically adapts to match the active animation range limit.
  final int groupSize;

  /// Stagger delay applied between items within a group during non-scrub animations.
  final Duration groupStaggerDelay;

  /// Normalized stagger ratio between items within a group during scrub mode.
  final double groupStagger;

  final Set<int> _triggeredBatches = <int>{};

  VoidCallback? onSequenceComplete;

  /// Creates a [BySequenceController] for [itemCount] children.
  BySequenceController({
    required this.itemCount,
    this.initialVisibleCount,
    this.groupSize = 0,
    this.groupStaggerDelay = const Duration(milliseconds: 70),
    this.groupStagger = 0.05,
    this.onProgress,
    this.onItemProgress,
    this.onItemEnter,
    this.onItemComplete,
    this.onSequenceComplete,
  })  : _itemProgress = List<double>.filled(itemCount, 0.0),
        _itemEntered = List<bool>.filled(itemCount, false),
        _itemCompleted = List<bool>.filled(itemCount, false),
        _itemOffsets = List<double>.filled(itemCount, -1.0),
        _itemExtents = List<double>.filled(itemCount, 140.0) {
    final count = initialVisibleCount ?? (itemCount > 0 ? 1 : 0);
    for (int i = 0; i < count && i < itemCount; i++) {
      updateItemProgress(i, 1.0);
    }
  }

  /// Resolves the effective batch group size.
  ///
  /// When [groupSize] is set to `0` (or <= 0), it automatically matches the active
  /// animation range limit:
  /// - If [initialVisibleCount] is set (e.g. 1, 3, 5), returns [initialVisibleCount].
  /// - If [startIndex] > 0 (e.g. full-screen initial visible count), returns [startIndex].
  /// - Otherwise falls back to 1.
  /// When [groupSize] > 0, returns [groupSize].
  int getEffectiveGroupSize(int startIndex) {
    if (groupSize > 0) return groupSize;
    if (initialVisibleCount != null && initialVisibleCount! > 0) {
      return initialVisibleCount!;
    }
    if (startIndex > 0) {
      return startIndex;
    }
    return 1;
  }

  /// Returns the index of the first item in the group to which [index] belongs.
  int getGroupFirstIndex(int index, int startIndex) {
    if (index < startIndex) return index;
    final effGroupSize = getEffectiveGroupSize(startIndex);
    if (effGroupSize <= 1) return index;
    final rel = index - startIndex;
    final gIdx = rel ~/ effGroupSize;
    return startIndex + gIdx * effGroupSize;
  }

  /// Checks whether the batch starting at [groupFirstIndex] has been triggered into view.
  bool isBatchTriggered(int groupFirstIndex) =>
      _triggeredBatches.contains(groupFirstIndex);

  /// Triggers the entrance animation for the batch starting at [groupFirstIndex].
  void triggerBatch(int groupFirstIndex) {
    if (_triggeredBatches.add(groupFirstIndex)) {
      notifyListeners();
    }
  }

  /// Untriggers (reverses) the batch starting at [groupFirstIndex].
  void unTriggerBatch(int groupFirstIndex) {
    if (_triggeredBatches.remove(groupFirstIndex)) {
      notifyListeners();
    }
  }

  /// The first index that must be progressively revealed via scrolling.
  int get startIndex =>
      initialVisibleCount ??
      (_firstHiddenIndex >= 0 ? _firstHiddenIndex : (itemCount > 0 ? 1 : 0));

  /// Registers the first index that was NOT revealed at initial state.
  void registerFirstHiddenIndex(int index) {
    if (_firstHiddenIndex == -1 || index < _firstHiddenIndex) {
      _firstHiddenIndex = index;
    }
  }

  /// Registers layout metrics (unscrolled offset and extent) of item at [index].
  void registerItemMetrics(int index, double offset, double extent) {
    if (index < 0 || index >= itemCount) return;
    _itemOffsets[index] = offset;
    if (extent > 0) {
      _itemExtents[index] = extent;
    }
  }

  /// Returns the physical bottom offset of the batch immediately preceding [batchIndex].
  ///
  /// - For progressive batch 0 (the first scrolled batch): returns bottom of the initial
  ///   batch (item at `startIndex - 1`).
  /// - For subsequent batches (batchIndex >= 1): returns bottom of batch `batchIndex - 1`.
  double getPreviousBatchBottom(
    int batchIndex,
    int startIndex,
    int effectiveGroupSize,
  ) {
    if (batchIndex <= 0) {
      final lastIdx = startIndex - 1;
      if (lastIdx >= 0 &&
          lastIdx < _itemOffsets.length &&
          _itemOffsets[lastIdx] >= 0) {
        return _itemOffsets[lastIdx] + _itemExtents[lastIdx];
      }
      return 0.0;
    }
    final lastIdx = (startIndex + batchIndex * effectiveGroupSize - 1)
        .clamp(0, itemCount - 1);
    if (lastIdx >= 0 &&
        lastIdx < _itemOffsets.length &&
        _itemOffsets[lastIdx] >= 0) {
      return _itemOffsets[lastIdx] + _itemExtents[lastIdx];
    }
    return 0.0;
  }

  /// List of current progress values (0.0 to 1.0) for each item in the sequence.
  List<double> get itemProgress => List<double>.unmodifiable(_itemProgress);

  /// Current overall sequence progress (0.0 when start, 1.0 when all items revealed).
  double get globalProgress => _globalProgress;

  /// Retrieves progress for a specific child [index].
  double getProgressAt(int index) {
    if (index < 0 || index >= _itemProgress.length) return 0.0;
    return _itemProgress[index];
  }

  /// Updates progress for child at [index]. Clamps value to 0.0 - 1.0.
  void updateItemProgress(int index, double progress) {
    if (index < 0 || index >= _itemProgress.length) return;

    final clamped = progress.clamp(0.0, 1.0);
    if ((_itemProgress[index] - clamped).abs() < 0.001) return;

    _itemProgress[index] = clamped;

    // Trigger onItemEnter
    if (clamped > 0.0 && !_itemEntered[index]) {
      _itemEntered[index] = true;
      onItemEnter?.call(index);
    } else if (clamped == 0.0 && _itemEntered[index]) {
      _itemEntered[index] = false;
    }

    // Trigger onItemComplete
    if (clamped >= 1.0 && !_itemCompleted[index]) {
      _itemCompleted[index] = true;
      onItemComplete?.call(index);
    } else if (clamped < 1.0 && _itemCompleted[index]) {
      _itemCompleted[index] = false;
    }

    onItemProgress?.call(index, clamped);
    _recalculateGlobalProgress();
    notifyListeners();
  }

  void _recalculateGlobalProgress() {
    if (_itemProgress.isEmpty) {
      _globalProgress = 0.0;
      return;
    }

    final total = _itemProgress.fold<double>(0.0, (sum, val) => sum + val);
    final newGlobal = total / _itemProgress.length;

    if ((_globalProgress - newGlobal).abs() > 0.001) {
      _globalProgress = newGlobal;
      onProgress?.call(_globalProgress);

      if (_globalProgress >= 0.999 && !_isSequenceCompleted) {
        _isSequenceCompleted = true;
        onSequenceComplete?.call();
      } else if (_globalProgress < 0.999 && _isSequenceCompleted) {
        _isSequenceCompleted = false;
      }
    }
  }

  /// Resets all progress back to pristine initial state.
  void reset() {
    _triggeredBatches.clear();
    final count = initialVisibleCount ?? (itemCount > 0 ? 1 : 0);
    for (int i = 0; i < _itemProgress.length; i++) {
      _itemProgress[i] = i < count ? 1.0 : 0.0;
      _itemEntered[i] = i < count;
      _itemCompleted[i] = i < count;
    }
    _isSequenceCompleted = false;
    _recalculateGlobalProgress();
    notifyListeners();
  }
}
