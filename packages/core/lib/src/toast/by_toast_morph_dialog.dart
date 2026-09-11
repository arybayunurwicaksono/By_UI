import 'dart:math';
import 'package:flutter/material.dart';
import 'by_toast_model.dart';

/// Modal dialog presented when a ByToast is dragged inward to the center of the screen.
/// Features a smooth morphing transition from the toast card into a centered dialog.
class ByToastMorphDialog extends StatefulWidget {
  final ByToastModel item;
  final Rect initialRect;
  final VoidCallback onClose;

  const ByToastMorphDialog({
    super.key,
    required this.item,
    required this.initialRect,
    required this.onClose,
  });

  @override
  State<ByToastMorphDialog> createState() => _ByToastMorphDialogState();
}

class _ByToastMorphDialogState extends State<ByToastMorphDialog>
    with TickerProviderStateMixin {
  late AnimationController _enterController;
  late AnimationController _exitController;
  late Animation<double> _enterAnim;
  late Animation<double> _exitFadeAnim;
  late Animation<double> _exitScaleAnim;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      vsync: this,
      duration: widget.item.dialogAnimationDuration,
    );

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _enterAnim = CurvedAnimation(
      parent: _enterController,
      curve: widget.item.dialogEnterCurve,
    );

    _exitFadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: widget.item.dialogExitCurve,
      ),
    );

    _exitScaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: widget.item.dialogExitCurve,
      ),
    );

    _enterController.forward();
  }

  Future<void> _closeDialog() async {
    if (_isClosing) return;
    if (!mounted) return;
    setState(() => _isClosing = true);

    await _exitController.forward();
    if (mounted) {
      widget.onClose();
    }
  }

  @override
  void dispose() {
    _enterController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final item = widget.item;

    final double targetWidth = min(screenSize.width - 36.0, 420.0);
    final double maxDialogHeight = min(screenSize.height * 0.82, 580.0);

    // Initial offset from screen center to the toast's location
    final Offset screenCenter = Offset(
      screenSize.width / 2,
      screenSize.height / 2,
    );
    final Offset initialOffset = widget.initialRect.center - screenCenter;

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: Listenable.merge([_enterController, _exitController]),
        builder: (context, _) {
          // If closing, apply exit fade & scale
          final double opacity =
              _isClosing ? _exitFadeAnim.value : _enterAnim.value;
          final double scale = _isClosing
              ? _exitScaleAnim.value
              : (0.92 + (0.08 * _enterAnim.value));

          // Translation offset: glide from toast position to screen center
          final Offset currentOffset = _isClosing
              ? Offset.zero
              : Offset.lerp(initialOffset, Offset.zero, _enterAnim.value)!;

          // Interpolate border radius from toast (14px) to dialog (22px)
          final double currentRadius =
              _isClosing ? 22.0 : (14.0 + (8.0 * _enterAnim.value));

          return Stack(
            children: [
              // Dark Backdrop Scrim
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeDialog,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.65 * opacity),
                  ),
                ),
              ),

              // Expandable Centered Dialog Card
              Positioned.fill(
                child: Center(
                  child: Transform.translate(
                    offset: currentOffset,
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.center,
                          child: Container(
                            width: targetWidth,
                            height: item.dialogHeight,
                            constraints: BoxConstraints(
                              maxHeight: maxDialogHeight,
                            ),
                            decoration: BoxDecoration(
                              color: item.gradient == null
                                  ? item.backgroundColor
                                  : null,
                              gradient: item.gradient,
                              borderRadius: BorderRadius.circular(
                                currentRadius,
                              ),
                              border: item.border ??
                                  Border.all(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    width: 1,
                                  ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 28,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                currentRadius,
                              ),
                              child: _buildDialogContent(context, item),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Full dialog content: Custom Builder (Option 2) or Default Dialog (Option 1)
  Widget _buildDialogContent(BuildContext context, ByToastModel item) {
    if (item.detailBuilder != null) {
      return item.detailBuilder!(context);
    }

    // Default Dialog (Option 1): Header with icon + title + 'X' close button, scrollable body
    final String title =
        item.detailTitle ?? item.title ?? 'Notification Details';
    final String detailBody = item.detailMessage ?? item.message;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Title + Close Button ('X')
          Row(
            children: [
              if (item.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (item.iconColor ?? item.textColor).withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: item.iconColor ?? item.textColor,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: item.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // Close Button ('X')
              Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const Key('by_toast_dialog_close'),
                  borderRadius: BorderRadius.circular(20),
                  onTap: _closeDialog,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: item.textColor.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(color: item.textColor.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 14),

          // Scrollable Detail Message Body
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                detailBody,
                style: TextStyle(
                  color: item.textColor.withValues(alpha: 0.9),
                  fontSize: 14,
                  height: 1.55,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
