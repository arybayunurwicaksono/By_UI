# Changelog

All notable changes to the `by_ui` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.1.0

### Added
* Initial public release of `by_ui`.
* **ByToast**: Modern notification and toast system.
  * Screen anchor positions: `top` and `bottom`.
  * Multi-directional entrance slide animations (`fromTop`, `fromBottom`, `fromLeft`, `fromRight`).
  * Animation styles: `slideAndFade`, `bounce`, `scaleAndFade`, `slideOnly`, `fadeOnly`.
  * Customizable prefixes (leading icons/widgets), suffixes (trailing actions/widgets), and close buttons.
  * Solid color and linear gradient background surfaces.
  * Swipe-to-dismiss gesture handling with smooth spring physics.
  * Presets: `ByToast.showSuccess`, `ByToast.showError`, `ByToast.showWarning`, `ByToast.showInfo`.
* **ByToast Morphing Dialog**:
  * Dual-interaction morphing: tap message text or drag toast towards screen center.
  * Seamless spatial translation from the toast's dragged position to center.
  * Pure wrap-content natural layout (shrink-wrap) with `AnimatedSize` and auto-scrolling constraints.
  * Two detail modes: Default text breakdown (Option 1) and custom widget builder (Option 2).
* **ByDialog**: Independent modern modal dialog component.
  * Presets: `ByDialog.alert` and `ByDialog.confirm`.
  * Full theme customization: gradients, corner radiuses, outline borders, custom barrier dismissibility, and animation easing.
