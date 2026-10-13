<p align="center">
  <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/logo_by_ui.jpg" width="400" alt="ByUI Logo" />
</p>

# ByUI — Modern Flutter UI Component Library

A modern, highly customizable Flutter UI component library featuring dynamic border buttons, sequential scroll-driven animations, dynamic motion cards, fluid spatial animations, interactive toasts with desktop/web multi-corner anchors, gesture-driven morphing dialogs, and standalone modal systems.

[![pub package](https://img.shields.io/pub/v/by_ui.svg)](https://pub.dev/packages/by_ui)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/arybayunurwicaksono/By_UI/pulls)

---

## 🎬 Preview

### Dynamic Border Beam & State Transitions (`ByButton`)
<p align="center">
  <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_button.gif" width="700" alt="ByButton Dynamic Perimeter Pulse & State Transition" />
</p>

### Sequential Scroll-Driven Animations (`BySequence`)
<p align="center">
  <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_sequence.gif" width="700" alt="BySequence Scroll Reveal and Scrubbing" />
</p>

### Dynamic Floating AppBar with Sensor & Cursor Parallax (`ByAppBar`)
<p align="center">
  <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_appbar.gif" width="700" alt="ByAppBar Dynamic Floating & Sensor Parallax" />
</p>

### Cards, Notifications & Dialogs
| Dynamic Motion Card | Stacked Cards | Drag / Tap to Dialog | Standalone Modal Dialog |
| :---: | :---: | :---: | :---: |
| <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_card.gif" width="210" alt="ByCard Dynamic Motion" /> | <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_toast_stacked.gif" width="210" alt="ByToast Stacked Cards" /> | <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_toast_drag.gif" width="210" alt="ByToast Drag to Expand into Dialog" /> | <img src="https://raw.githubusercontent.com/arybayunurwicaksono/By_UI/main/doc/preview/by_dialog.gif" width="210" alt="ByDialog Standalone Alert and Confirm" /> |

---

## ✨ Highlights

* 🔘 **ByButton (Flagship Interactive Button & Dynamic Border Pulse)**:
  * **Dynamic Perimeter Beam Sweep (`ByDynamicBorderLayer`)**: High-energy gradient beam that traces the continuous rounded perimeter and corner curves of the button.
  * **State-Transition Energy Pulse**: Automatically triggers a vibrant border pulse when transitioning from disabled to enabled mode (`enableTransitionPulseColors`).
  * **Autonomous Async State**: Passing a `Future Function()` to `onPressed` automatically engages the loading state with a 3-phase circular pulse spinner.
  * **Zero Content Shift**: Maintains button geometry during loading state to prevent layout jank and abrupt size shifts.
  * **Independent Border Widths**: Independent tuning for resting border (`borderWidth`) versus loading border (`loadingBorderWidth`).
  * **4 Visual Variants**: `filled`, `gradient`, `outline`, and `ghost`.
  * **5 Size Presets**: `xs`, `sm`, `md`, `lg`, and `xl` with customizable padding, font sizes, and corner radiuses.

* 🎞️ **BySequence (Sequential Scroll-Driven Animations)**:
  * **Zero-Boilerplate Scroll Reveal**: Progressively reveals children sequentially as the user scrolls without manual controllers or interpolators.
  * **GSAP-Inspired Motion Engine**: 1:1 continuous scrubbing (`scrub: true`), dynamic batch pacing (`ScrollTrigger.batch`), trigger threshold lines, and viewport gating.
  * **Composability**: Overrides via `BySequenceItem`, multi-property `BySequenceAnimation`, and headless observation with `BySequenceController`.

* 🧭 **ByAppBar (Dynamic Floating & Sensor Parallax)**:
  * **Scroll-Driven Floating Transition**: Smoothly animates from edge-docked top navigation to detached frosted floating card based on scroll threshold via ancestor `ByScrollScope` or custom `ScrollController`.
  * **Dynamic Sensor & Motion Tilt**: Directional gradient border stroke that shifts with physical device tilt (gyroscope/accelerometer) on mobile, and adapts to mouse cursor hover parallax on desktop & web with cubic hermite smoothstep blending.
  * **Directional Inner Shadow & Glow**: Optional directional inner ambient sheen (`enableInnerShadow`, `innerShadowOpacity`) with balanced edge-to-edge coverage in resting pose.
  * **Status Bar & Notch Coverage**: Automatically covers top safe area when static, and smoothly fades to transparent when floating so background content scrolls underneath.
  * **Zero-Border Default & Complete Customization**: Fully configurable borders, margins, blur sigma (`floatingBlurSigma`), surface opacity, and custom bottom widgets.

* 🎴 **ByCard (Dynamic Motion & Gradient Surfaces)**:
  * **Zero-Boilerplate Sensor Motion (`ByCard.dynamicSensor`)**: Responsive border gradient shifts with device gyroscope/accelerometer motion on mobile, and seamlessly switches to mouse cursor hover parallax on desktop & web with smooth spring return to neutral.
  * **Lifecycle-Safe Stream Handling**: Automatically subscribes to hardware sensors when mounted and disposes on unmount without user state management boilerplate.
  * **Shorthand & Standard Variants**: `ByCard.dynamicSensor` for interactive motion, `ByCard.gradient` for stylized borders, and standard `ByCard` for solid surfaces.

* 🔔 **ByToast**:
  * **Multi-Anchor Positioning**: Supports mobile standard anchors (`top`, `bottom`) and 4-corner desktop/web anchors (`topRight`, `topLeft`, `bottomRight`, `bottomLeft`).
  * **Background Opacity Control**: Fine-tune card surface transparency (0.0 to 1.0) while keeping foreground icons, text, and actions 100% crisp.
  * **Configurable Text Clamping**: Built-in `maxLines` (defaults to 3) and `overflow` (`TextOverflow.ellipsis`) with optional `titleMaxLines`.
  * **Spatial Gestures**: Swipe away to dismiss, or drag towards screen center to morph into a detailed dialog.
  * **1-Click Presets**: `ByToast.showSuccess`, `ByToast.showError`, `ByToast.showWarning`, `ByToast.showInfo`.

* 🔄 **Morphing Dialog (Toast-to-Dialog)**:
  * Seamless spatial morphing from toast notification to a centered modal dialog upon tap or inward drag.
  * Dedicated scrollbar with custom scroll styling for long notification details.
  * Shrink-wrap layout with smooth spring bounce animation.
  * Independent solid surface rendering regardless of initiating toast opacity.

* 💬 **ByDialog**:
  * Standalone modern modal dialogs sharing ByToast's obsidian and sleek styling.
  * Presets for single-button `ByDialog.alert` and two-button `ByDialog.confirm`.
  * Flexible text truncation controls (`messageMaxLines`, `titleMaxLines`).

* 🎨 **Interactive Sample Showcase (`apps/sample`)**:
  * Complete interactive playground to test live animations, corner anchors, opacity sliders, and colors.
  * Centralized theming architecture with instant dark/light/system theme switching.
  * Live **Active Configuration Preview** cards displaying current parameters in real-time.

---

## 📁 Repository Structure

This repository is organized as a Flutter monorepo:

```
By_UI/
├── packages/
│   └── core/           # The published Flutter package (by_ui on pub.dev)
│       ├── example/    # Minimal runnable package example
│       ├── lib/        # Core library source code
│       ├── test/       # Comprehensive unit & widget test suite
│       ├── CHANGELOG.md
│       ├── LICENSE
│       ├── README.md
│       └── pubspec.yaml
├── apps/
│   └── sample/         # Full-featured interactive showcase & playground application
│       ├── lib/        # Showcase screens (Button, Sequence, Toast, Dialog, AppBar, Card, Theme tokens)
│       └── test/       # Showcase widget test suite
```

---

## 🚀 Quick Start

### Using the Package in your Flutter App

Add `by_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  by_ui: ^0.1.7
```

Or run:

```bash
flutter pub add by_ui
```

```dart
import 'package:by_ui/by_ui.dart';

// 1. Interactive Button with Dynamic Border Pulse & Auto-Async Loading
ByButton(
  variant: ByButtonVariant.outline,
  borderWidth: 1.5,
  loadingBorderWidth: 2.0,
  loadingPulseColors: const [
    Color(0xFF38BDF8),
    Color(0xFF818CF8),
    Color(0xFFC084FC),
  ],
  prefix: const Icon(Icons.bolt_rounded, size: 18),
  onPressed: () async {
    await Future.delayed(const Duration(seconds: 2));
  },
  child: const Text('Dynamic Pulse Button'),
);

// 2. Sequential Scroll-Driven Animations
BySequence(
  scrub: true,
  trigger: 0.85,
  spacing: 12.0,
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
);

// 3. Dynamic Floating Glassmorphic AppBar with Sensor Parallax
Scaffold(
  extendBodyBehindAppBar: true,
  appBar: ByAppBar(
    isFloatingEnabled: true,
    enableSensor: true,
    enableHoverTilt: true,
    borderGradient: const LinearGradient(
      colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
    ),
    borderWidth: 1.0,
    floatingBlurSigma: 16.0,
    child: const Text('My Floating AppBar'),
  ),
  body: ListView(...),
);

// 4. Dynamic Motion Card (Device tilt on mobile, cursor parallax on desktop/web)
ByCard.dynamicSensor(
  colors: const [Color(0xFF38BDF8), Color(0xFF818CF8), Color(0xFFC084FC)],
  borderWidth: 2.0,
  borderRadius: BorderRadius.circular(20),
  padding: const EdgeInsets.all(20),
  child: const Text('Dynamic Motion Card'),
);

// 5. Show a success notification
ByToast.showSuccess(
  context,
  message: 'Transaction saved successfully.',
);

// 6. Show a corner toast with opacity control (desktop/web)
ByToast.show(
  context,
  title: 'Build Finished',
  message: 'Artifacts uploaded to production server.',
  position: ByToastPosition.topRight,
  backgroundOpacity: 0.85,
  icon: Icons.cloud_done_rounded,
);
```

---

## 🎮 Running the Showcase Playground

To experience all features, spatial physics, and customize configurations live:

```bash
# 1. Clone the repository
git clone https://github.com/arybayunurwicaksono/By_UI.git
cd By_UI

# 2. Run the interactive sample app
cd apps/sample
flutter pub get
flutter run
```

---

## 🧪 Testing & Validation

All packages are thoroughly tested:

```bash
# Test the core package
cd packages/core
flutter test

# Test the sample showcase app
cd ../../apps/sample
flutter test
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](packages/core/LICENSE) file for details.
