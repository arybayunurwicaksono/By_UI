import 'package:flutter/material.dart';
import 'by_toast.dart';
import 'by_toast_card.dart';
import 'by_toast_enums.dart';
import 'by_toast_model.dart';
import 'by_toast_morph_dialog.dart';

/// Container widget mounted in the app Overlay to manage and render
/// all active stacked toasts with fluid spatial coordinate transitions.
class ByToastContainer extends StatefulWidget {
  final List<ByToastModel> items;
  final ValueChanged<String> onDismissItem;
  final int maxVisibleItems;
  final double itemSpacing;

  const ByToastContainer({
    super.key,
    required this.items,
    required this.onDismissItem,
    this.maxVisibleItems = 3,
    this.itemSpacing = 10.0,
  });

  @override
  State<ByToastContainer> createState() => ByToastContainerState();
}

class ByToastContainerState extends State<ByToastContainer> {
  late List<ByToastModel> _currentItems;
  final Map<String, double> _itemHeights = {};
  static const double _defaultItemHeight = 60.0;

  // Active morphing modal dialog state
  ByToastModel? _activeDialogItem;
  Rect? _dialogInitialRect;

  @override
  void initState() {
    super.initState();
    _currentItems = List.from(widget.items);
  }

  /// Updates the list of active toast items when new toasts
  /// arrive or old ones are removed.
  void updateItems(List<ByToastModel> newItems) {
    if (mounted) {
      setState(() {
        _currentItems = List.from(newItems);
        // Clean up unneeded height records
        final activeIds = newItems.map((e) => e.id).toSet();
        _itemHeights.removeWhere((id, _) => !activeIds.contains(id));
      });
    }
  }

  void _onHeightMeasured(String id, double height) {
    if (_itemHeights[id] != height) {
      if (mounted) {
        setState(() {
          _itemHeights[id] = height;
        });
      }
    }
  }

  void _onExpandToDialog(String id, Rect initialRect) {
    final itemIndex = _currentItems.indexWhere((e) => e.id == id);
    if (itemIndex != -1) {
      final item = _currentItems[itemIndex];
      setState(() {
        _currentItems.removeAt(itemIndex);
        _activeDialogItem = item;
        _dialogInitialRect = initialRect;
      });
    }
  }

  void _onCloseDialog() {
    if (mounted) {
      setState(() {
        _activeDialogItem = null;
        _dialogInitialRect = null;
      });
      if (_currentItems.isEmpty) {
        ByToast.clear();
      }
    }
  }

  /// Calculates dynamic cumulative offset for an item at [index].
  double _calculateOffset(int index) {
    double totalOffset = 0.0;
    for (int i = 0; i < index; i++) {
      final prevId = _currentItems[i].id;
      final prevHeight = _itemHeights[prevId] ?? _defaultItemHeight;
      totalOffset += prevHeight + widget.itemSpacing;
    }
    return totalOffset;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentItems.isEmpty && _activeDialogItem == null) {
      return const SizedBox.shrink();
    }

    final mediaQuery = MediaQuery.of(context);

    // Calculate Base Anchor Top
    double baseTop = mediaQuery.padding.top + kToolbarHeight + 12.0;
    if (ByToast.appBarKey.currentContext != null) {
      final renderBox =
          ByToast.appBarKey.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final position = renderBox.localToGlobal(Offset.zero);
        baseTop = position.dy + renderBox.size.height + 10.0;
      }
    }

    // Calculate Base Anchor Bottom
    double baseBottom = mediaQuery.padding.bottom + 16.0;
    if (ByToast.bottomBarKey.currentContext != null) {
      final renderBox =
          ByToast.bottomBarKey.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final position = renderBox.localToGlobal(Offset.zero);
        baseBottom = mediaQuery.size.height - position.dy + 12.0;
      }
    }

    return Stack(
      children: [
        // Stacked Toast Cards (rendered from oldest to newest)
        for (int i = _currentItems.length - 1; i >= 0; i--) ...[
          _buildPositionedItem(
            item: _currentItems[i],
            index: i,
            baseTop: baseTop,
            baseBottom: baseBottom,
          ),
        ],

        // Morphing Dialog Overlay
        if (_activeDialogItem != null && _dialogInitialRect != null)
          ByToastMorphDialog(
            item: _activeDialogItem!,
            initialRect: _dialogInitialRect!,
            onClose: _onCloseDialog,
          ),
      ],
    );
  }

  Widget _buildPositionedItem({
    required ByToastModel item,
    required int index,
    required double baseTop,
    required double baseBottom,
  }) {
    final double stackOffset = _calculateOffset(index);
    final double targetOpacity = index >= widget.maxVisibleItems ? 0.0 : 1.0;
    final bool isTop = item.position == ByToastPosition.top;

    return AnimatedPositioned(
      key: ValueKey('pos_${item.id}'),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
      top: isTop ? baseTop + stackOffset : null,
      bottom: !isTop ? baseBottom + stackOffset : null,
      left: item.horizontalMargin,
      right: item.horizontalMargin,
      child: AnimatedOpacity(
        opacity: targetOpacity,
        duration: const Duration(milliseconds: 300),
        child: ByToastCard(
          key: ValueKey('card_${item.id}'),
          item: item,
          index: index,
          onDismiss: () => widget.onDismissItem(item.id),
          onHeightMeasured: (h) => _onHeightMeasured(item.id, h),
          onExpandToDialog: (rect) => _onExpandToDialog(item.id, rect),
        ),
      ),
    );
  }
}

// Backward compatibility aliases
typedef ByNotificationContainer = ByToastContainer;
typedef ByNotificationContainerState = ByToastContainerState;
