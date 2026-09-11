# ByUI

A modern, highly customizable Flutter UI component library featuring fluid spatial animations, interactive toasts, and shrink-wrap dialogs.

[![pub package](https://img.shields.io/pub/v/by_ui.svg)](https://pub.dev/packages/by_ui)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## Features

* **ByToast**:
  * **Top & Bottom Screen Anchors**: Anchor to top app bar or bottom bar seamlessly.
  * **Multi-directional Slide**: Entrance animations from top, bottom, left, or right.
  * **Rich Animations**: Supports `slideAndFade`, `bounce`, `scaleAndFade`, `slideOnly`, and `fadeOnly`.
  * **Surfaces**: Solid colors, multi-hue linear gradients, and customizable borders/shadows.
  * **Interactive Gestures**: Swipe to dismiss away from center, or drag towards screen center to expand into a modal dialog.
  * **1-Click Presets**: `ByToast.showSuccess`, `ByToast.showError`, `ByToast.showWarning`, `ByToast.showInfo`.

* **Morphing Dialog (Toast-to-Dialog)**:
  * **Dual Interaction**: Tap the message text or pull/drag the toast towards the center of the screen to open an expanded detail dialog.
  * **Natural Shrink-Wrap**: Dialog dynamically adjusts height to fit content without awkward blank space.
  * **Interactive Physics**: If pulled slightly and released, it springs back smoothly.

* **ByDialog**:
  * Standalone modal dialog system matching ByToast styling.
  * Presets for single-button `ByDialog.alert` and two-button `ByDialog.confirm`.
  * Fully customizable barrier colors, gradients, button colors, and entry curves.

---

## Getting Started

Add `by_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  by_ui: ^0.1.0
```

Or run:

```bash
flutter pub add by_ui
```

Import the package in your Dart code:

```dart
import 'package:by_ui/by_ui.dart';
```

---

## Usage

### 1. Simple Notification Toast

```dart
ByToast.show(
  context,
  message: 'Payment received successfully!',
  icon: Icons.check_circle_rounded,
  backgroundColor: const Color(0xFF10B981),
  position: ByToastPosition.top,
  slideDirection: ByToastSlideDirection.fromTop,
  animationType: ByToastAnimationType.bounce,
);
```

### 2. Preset Toasts

```dart
// Success preset
ByToast.showSuccess(
  context,
  message: 'Order #1042 processed successfully.',
);

// Error preset
ByToast.showError(
  context,
  message: 'Printer connection timed out.',
  position: ByToastPosition.bottom,
);
```

### 3. Tap & Drag to Expand into Dialog

Users can tap the message text or drag the toast towards the center of the screen to reveal full details:

```dart
ByToast.show(
  context,
  title: 'Order Status',
  message: 'Cashier transaction saved. Pull down or tap for breakdown.',
  icon: Icons.receipt_long_rounded,
  detailTitle: 'Transaction #1042 Details',
  detailMessage:
      '• Order ID: #TRX-1042\n'
      '• Items: Double Latte x2, Croissant x1\n'
      '• Total: Rp 78.000\n'
      '• Payment: QRIS Verified',
  enableTapToExpand: true,
  enableDragToExpand: true,
);
```

### 4. Standalone Modal Dialogs

```dart
// Confirm Dialog
final confirmed = await ByDialog.confirm(
  context,
  title: 'Void Transaction?',
  message: 'This will reverse ledger balance for transaction #1042.',
  confirmText: 'Void Now',
  cancelText: 'Cancel',
  confirmColor: const Color(0xFFEF4444),
);

if (confirmed == true) {
  // Handle confirm action
}
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
