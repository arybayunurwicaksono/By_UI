# ByUI

A modern, highly customizable Flutter UI component library featuring dynamic motion cards, fluid spatial animations, interactive toasts, multi-anchor corner positioning, and shrink-wrap dialogs.

[![pub package](https://img.shields.io/pub/v/by_ui.svg)](https://pub.dev/packages/by_ui)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## Preview

### Dynamic Floating AppBar with Sensor & Cursor Parallax (`ByAppBar`)
<p align="center">
  <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_appbar.gif" width="700" alt="ByAppBar Dynamic Floating & Sensor Parallax" />
</p>

### Cards, Notifications & Dialogs
| Dynamic Motion Card | Stacked Cards | Drag / Tap to Dialog | Standalone Modal Dialog |
| :---: | :---: | :---: | :---: |
| <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_card.gif" width="210" alt="ByCard Dynamic Motion" /> | <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_toast_stacked.gif" width="210" alt="ByToast Stacked Cards" /> | <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_toast_drag.gif" width="210" alt="ByToast Drag to Expand into Dialog" /> | <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_dialog.gif" width="210" alt="ByDialog Standalone Alert and Confirm" /> |

---

## Features

* **ByAppBar (Dynamic Floating, Glassmorphic & Sensor Parallax)**:
  * **Scroll-Driven Floating Transition**: Smoothly animates between static edge-docked mode and floating detached card based on scroll threshold via ancestor `ByScrollScope` or custom `ScrollController`.
  * **Dynamic Sensor & Motion Tilt**: Directional gradient border stroke that shifts with physical device tilt (gyroscope/accelerometer) on mobile, and adapts to mouse cursor hover parallax on desktop & web with cubic hermite smoothstep blending.
  * **Directional Inner Shadow & Glow**: Directional inner ambient sheen (`enableInnerShadow`, `innerShadowOpacity`) with balanced edge-to-edge coverage in resting pose.
  * **Frosted Glassmorphism**: Integrated Gaussian blur filter (`floatingBlurSigma`) and configurable surface opacity (`floatingOpacity`).
  * **Seamless Notch Coverage**: Automatically covers top status bar area when static, and smoothly fades to transparent when floating so background content scrolls underneath.
  * **Zero-Border Default & Complete Customization**: Fully configurable borders, margins, corner radii, elevation, toolbar height, and custom bottom widgets.

* **ByCard (Standard, Gradient & Dynamic Motion Sensor)**:
  * **Zero-Boilerplate Motion (`ByCard.dynamicSensor`)**: Responsive border gradient that shifts dynamically with physical tilt and pointer motion.
    * **Mobile (Android & iOS)**: Reacts to hardware gyroscope / accelerometer sensors with smooth low-pass filtering.
    * **Desktop & Web**: Reacts interactively to cursor hover position, smoothly gliding back to neutral center position when the pointer exits.
    * **Lifecycle Safe**: Automatically initializes and disposes sensor listeners on mount/unmount. No manual stream handling required.
  * **Vibrant Gradient Borders (`ByCard.gradient`)**: Quick setup with `colors` or custom `borderGradient` to frame your content in eye-catching styles.
  * **Standard Solid Cards (`ByCard`)**: Polished cards with solid background, border styling, customizable drop shadows, and corner radius.
  * **Theming**: Unified application-wide styling with `ByCardThemeData` and `ByCardDefaults`.

* **ByToast**:
  * **Multi-Anchor Screen Positioning**: Supports standard mobile positions (`top`, `bottom`) and desktop/web corner anchors (`topRight`, `topLeft`, `bottomRight`, `bottomLeft`).
  * **Surface Opacity Control**: Fine-tune `backgroundOpacity` (0.0 to 1.0) for sleek translucent/glassmorphic cards while keeping foreground text, icons, and buttons at 100% crisp contrast.
  * **Configurable Text Clamping**: Built-in `maxLines` (defaults to 3) and `overflow` (`TextOverflow.ellipsis`) for tidy compact cards, plus optional `titleMaxLines`.
  * **Multi-directional Slide**: Inward slide entrance animations from top, bottom, left, or right with auto-detection for corner anchors.
  * **Rich Animation Styles**: Supports `slideAndFade`, `bounce`, `scaleAndFade`, `slideOnly`, and `fadeOnly`.
  * **Surfaces**: Solid colors, multi-hue linear gradients, thin borders, and customizable drop shadows.
  * **Interactive Gestures**: Swipe to dismiss away from center, or drag towards screen center to expand into a detail modal dialog.
  * **1-Click Presets**: `ByToast.showSuccess`, `ByToast.showError`, `ByToast.showWarning`, `ByToast.showInfo`.

* **Morphing Dialog (Toast-to-Dialog)**:
  * **Dual Interaction**: Tap the message text or pull/drag the toast towards the center of the screen to smoothly expand into a modal dialog.
  * **Smooth Scrollbar & Long Text**: Integrated dedicated `ScrollController` with custom styled scrollbars for long notification details.
  * **Shrink-Wrap Layout**: Dialog dynamically adjusts height to fit content without awkward empty space.
  * **Resilient Surface**: Dialog maintains solid contrast even when the initiating toast uses reduced background opacity.

* **ByDialog**:
  * Standalone modal dialog system sharing ByToast's sleek slate aesthetic.
  * Presets for single-button `ByDialog.alert` and two-button `ByDialog.confirm`.
  * Configurable text clamping (`messageMaxLines`, `titleMaxLines`, `overflow`).
  * Fully customizable barrier colors, gradients, button colors, and entry curves.

---

## Getting Started

Add `by_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  by_ui: ^0.1.4
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

### ByAppBar

#### Dynamic Floating Glassmorphic AppBar with Sensor Parallax

Automatically animates to a floating pill with frosted glass blur upon scroll, while reactive border lighting shifts with device tilt and cursor hover:

```dart
Scaffold(
  extendBodyBehindAppBar: true,
  appBar: ByAppBar(
    isFloatingEnabled: true,
    scrollThreshold: 12.0,
    enableSensor: true,
    enableHoverTilt: true,
    borderGradient: const LinearGradient(
      colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
    ),
    borderWidth: 1.0,
    floatingBlurSigma: 16.0,
    floatingOpacity: 0.84,
    enableInnerShadow: true,
    innerShadowOpacity: 0.8,
    child: Row(
      children: [
        IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        const Text('Dynamic Floating AppBar', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  ),
  body: ListView.builder(
    padding: EdgeInsets.fromLTRB(16, ByAppBar.getContentTopPadding(context), 16, 24),
    itemCount: 50,
    itemBuilder: (_, index) => ListTile(title: Text('Item $index')),
  ),
);
```

### ByCard

#### 1. Dynamic Motion Card (Hardware Sensors on Mobile, Cursor Parallax on Desktop/Web)

Zero boilerplate—automatically handles hardware gyro/accel on mobile and mouse cursor hover on desktop & web:

```dart
ByCard.dynamicSensor(
  colors: const [Color(0xFF38BDF8), Color(0xFF818CF8), Color(0xFFC084FC)],
  borderWidth: 2.0,
  borderRadius: BorderRadius.circular(20),
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text('Dynamic Motion Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      SizedBox(height: 8),
      Text('Border gradient dynamically reacts to phone tilt and cursor movement.'),
    ],
  ),
);
```

#### 2. Gradient Border Card

```dart
ByCard.gradient(
  colors: const [Color(0xFFF43F5E), Color(0xFFFB923C)],
  borderWidth: 1.5,
  borderRadius: BorderRadius.circular(16),
  padding: const EdgeInsets.all(16),
  child: const Text('Card with static linear gradient border'),
);
```

#### 3. Standard Card

```dart
ByCard(
  backgroundColor: const Color(0xFF1E293B),
  borderColor: const Color(0xFF334155),
  borderWidth: 1.0,
  borderRadius: BorderRadius.circular(16),
  padding: const EdgeInsets.all(16),
  child: const Text('Clean solid card surface'),
);
```

---

### ByToast & Morphing Dialog

#### 4. Simple Notification Toast

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

#### 5. Corner Positioning (Desktop & Web)

Ideal for desktop and web layouts where notifications belong in the corner:

```dart
ByToast.show(
  context,
  title: 'Build Finished',
  message: 'Artifacts uploaded to production server.',
  position: ByToastPosition.topRight, // or topLeft, bottomRight, bottomLeft
  backgroundColor: const Color(0xFF0F172A),
  icon: Icons.cloud_done_rounded,
);
```

#### 6. Background Opacity & Text Clamping

Create translucent floating toasts while keeping text crisp and readable:

```dart
ByToast.show(
  context,
  title: 'New Notification',
  message: 'This is a compact notification with a subtle translucent background.',
  backgroundOpacity: 0.85, // 85% opacity on surface, 100% on text/icon
  maxLines: 2,             // Clamped to 2 lines with ellipsis
  overflow: TextOverflow.ellipsis,
  backgroundColor: const Color(0xFF1E1B4B),
);
```

#### 7. 1-Click Presets

```dart
// Success preset
ByToast.showSuccess(
  context,
  message: 'Order #1042 processed successfully.',
);

// Error preset at the bottom
ByToast.showError(
  context,
  message: 'Printer connection timed out.',
  position: ByToastPosition.bottom,
);
```

#### 8. Tap & Drag to Expand into Dialog

Users can tap the message text or drag the toast towards the center of the screen to reveal full scrollable details:

```dart
ByToast.show(
  context,
  title: 'Order Status',
  message: 'Cashier transaction saved. Pull down or tap for breakdown.',
  icon: Icons.receipt_long_rounded,
  detailTitle: 'Transaction #1042 Details',
  detailMessage:
      '• Order ID: #TRX-1042\n'
      '• Cashier: Sarah W.\n'
      '• Items: Double Latte x2, Croissant x1\n'
      '• Total: Rp 78.000\n'
      '• Payment: QRIS Verified\n'
      '• Timestamp: 2026-09-15 14:32:10 WIB\n'
      '• Terminal: POS-01 (Offline Synced)',
  enableTapToExpand: true,
  enableDragToExpand: true,
);
```

---

### ByDialog

#### 9. Standalone Modal Dialogs & Button Customization

```dart
// Confirm Dialog with customized buttons
final confirmed = await ByDialog.confirm(
  context,
  title: 'Void Transaction?',
  message: 'This will reverse ledger balance for transaction #1042.',
  confirmText: 'Void Now',
  cancelText: 'Keep',
  confirmColor: const Color(0xFFEF4444),
  buttonBorderRadius: BorderRadius.circular(16), // Rounded or Pill buttons
  reverseButtonOrder: false,                     // true to place Confirm on the left
  cancelColor: const Color(0xFF1E293B),         // Optional solid fill for Cancel
);

if (confirmed == true) {
  // Handle confirmed action
}
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
