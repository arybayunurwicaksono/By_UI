# ByUI — Modern Flutter UI Component Library

A modern, highly customizable Flutter UI component library featuring fluid spatial animations, interactive toasts with desktop/web multi-corner anchors, gesture-driven morphing dialogs, and standalone modal systems.

[![pub package](https://img.shields.io/pub/v/by_ui.svg)](https://pub.dev/packages/by_ui)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/arybayunurwicaksono/By_UI/pulls)

---

## ✨ Highlights

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
│       ├── lib/        # Showcase screens (Toast, Dialog, Drawer, Theme tokens)
│       └── test/       # Showcase widget test suite
└── rules.md            # Development standards, styling conventions & workflow rules
```

---

## 🚀 Quick Start

### Using the Package in your Flutter App

Add `by_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  by_ui: ^0.1.1
```

Or run:

```bash
flutter pub add by_ui
```

```dart
import 'package:by_ui/by_ui.dart';

// Show a success notification
ByToast.showSuccess(
  context,
  message: 'Transaction saved successfully.',
);

// Show a corner toast with opacity control (desktop/web)
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

## 📜 Development Guidelines

Please refer to [**`rules.md`**](rules.md) for architectural guidelines, theming conventions (`apps/sample/lib/theme`), testing protocols, and Git workflows.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](packages/core/LICENSE) file for details.
