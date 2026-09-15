# Changelog

All notable changes to the `by_ui` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.1.2

### Added
* **ByDialog**:
  * Comprehensive button customization in `ByDialog.confirm`:
    * `buttonBorderRadius`: Customizable button corner radius.
    * `reverseButtonOrder`: Option to reverse button positions (Confirm left, Cancel right).
    * `cancelColor`: Option to convert cancel button into a solid filled button.
    * `cancelBorderColor` and `cancelTextColor`: Fine-grained negative button color tuning.
    * `confirmTextColor`: Customizable positive button text color.
    * `onConfirm` and `onCancel`: Direct lifecycle callbacks before modal dismiss.
  * Added `buttonTextColor` and `buttonBorderRadius` customization in `ByDialog.alert` and all presets (`success`, `error`, `warning`, `info`).
* **Documentation & Media**:
  * Added visual animated GIF previews for stacked cards, drag-to-dialog, and standalone modal dialogs.

## 0.1.1

### Added
* **ByToast**:
  * Multi-anchor desktop & web corner positioning (`topLeft`, `topRight`, `bottomLeft`, `bottomRight`) alongside full-width `top` and `bottom`, with intelligent auto slide directions and per-anchor stack offsets.
  * Configurable background surface opacity (`backgroundOpacity`) for solid and gradient surfaces while keeping foreground text and icons at 100% clarity.
  * Configurable text truncation controls (`maxLines` defaults to 3, `overflow` defaults to `TextOverflow.ellipsis`).
  * Configurable title truncation options (`titleMaxLines` and `titleOverflow`).
  * Intelligent tap-to-expand fallback allowing standard toasts with long text to seamlessly morph into dialog view.
* **ByToastMorphDialog**:
  * Integrated dedicated `ScrollController` with custom scrollbar styling for long notification details.
  * Layout enhancements with edge-to-edge content scrolling and polished dividers.
* **ByDialog**:
  * Added text truncation controls (`messageMaxLines`, `messageOverflow`, `titleMaxLines`, `titleOverflow`) across `alert`, `confirm`, and presets (`success`, `error`, `warning`, `info`).

### Fixed
* Fixed toast tap gesture detection when expanding messages into dialogs without custom `onTap` handlers.
* Fixed scroll controller disposal and viewport constraints in `ByToastMorphDialog`.

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