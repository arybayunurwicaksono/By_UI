# Changelog

All notable changes to the `by_ui` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.1.4

### Added
* **ByAppBar**:
  * New dynamic floating and glassmorphic app bar component family.
  * **Scroll-Driven Floating Transition**: Smoothly animates between static edge-docked state and floating detached pill based on scroll distance threshold via ancestor `ByScrollScope` or custom `ScrollController`.
  * **Frosted Glassmorphism**: Integrated Gaussian blur filter (`floatingBlurSigma`) and configurable surface opacity (`floatingOpacity`).
  * **Dynamic Sensor & Motion Tilt**:
    * Directional gradient border stroke matching physical gyroscope/accelerometer tilt on mobile (Android / iOS).
    * Mouse cursor hover parallax tracking on desktop and web with automatic smooth return to resting pose.
    * Spatial directional glow and dynamic shadow projection (`shadowGradient`, `shadowBlur`, `maxShadowOffset`).
    * **Ultra-Smooth Hermite Cubic Interpolation**: Smoothstep blending between resting alignment and physical tilt vector, eliminating abrupt jumps and stutter when rotating or tilting mobile devices.
    * **High-Refresh Physics Engine**: Game interval hardware sampling (~50-60 Hz) and per-frame `Ticker` interpolation in `ByTiltController`.
    * **Inner Shadow & Ambient Glow Control**: Added `enableInnerShadow` (defaults to `false`) and `innerShadowOpacity` multiplier (with `enableInnerGlow` and `innerGlowOpacity` synonyms for `ByCard` API symmetry).
    * **Even Neutral Resting Glow**: Even, balanced edge-to-edge linear gradient ambient sheen in neutral resting pose (`magnitude < 0.08`), eliminating circular hot-spots.
  * **Notch & Status Bar Handling**:
    * Seamlessly covers the status bar/notch area with a solid background when static at the top (`!isFloating`).
    * Smoothly transitions notch coverage to transparent when floating so background content scrolls elegantly behind the floating pill.
  * **Zero-Border Default & Complete Customization**:
    * Border defaults to 0.0 (clean edge by default).
    * Full control over borders, linear gradients, margins, corner radii, elevation, toolbar height, and custom bottom widgets (e.g. `TabBar`).
    * Convenient static helper `getContentTopPadding(context)` for clean `extendBodyBehindAppBar` integration on `Scaffold`.
* **ByCard**:
  * Added dynamic inner sheen / luminous glow support (`enableInnerGlow`, `innerGlowOpacity`, `innerGlowBlur`) in `ByCard` and `ByCardPainter` reacting to directional lighting.
  * Refined neutral pose inner glow to use balanced linear gradient across the card when resting flat.
* **ByToast**:
  * Added typography font size customization with `textSize` and `titleSize` across `ByToast`, `ByToastModel`, `ByToastCard`, and all preset methods (`showSuccess`, `showError`, `showWarning`, `showInfo`).
* **Documentation & Media**:
  * Added animated preview GIF for `ByAppBar` dynamic floating motion and gradient border parallax (`ByAppBar.gif`).
  * Added interactive inner shadow toggle and opacity slider controls to `AppBarShowcaseScreen`.

## 0.1.3

### Added
* **ByCard**:
  * New versatile card widget family featuring sleek styling, configurable padding, borders, corner radii, and drop shadows.
  * **Card Variants & Constructors**:
    * `ByCard`: Standard card with solid or custom background styling, customizable border width, and border color.
    * `ByCard.gradient`: Shorthand constructor for cards with vibrant linear gradient borders (`colors`, `borderGradient`, `borderWidth`).
    * `ByCard.dynamicSensor`: Zero-boilerplate dynamic motion card with responsive border gradient tracking:
      * **Mobile (Android / iOS)**: Automatically responds to hardware device motion using gyroscope/accelerometer tilt with smooth low-pass filtering.
      * **Desktop & Web**: Seamlessly adapts to mouse cursor hover tracking with fluid spring glide back to neutral center position when the pointer exits.
  * **Lifecycle-Safe Tilt Management**: Built-in `ByTiltController` handles hardware stream subscriptions and listeners lazily on mount and disposes automatically on unmount without user boilerplate.
  * **Configurable Motion Settings**: Custom `sensorSensitivity`, `maxSensorTilt`, `hoverSensitivity`, and `neutralAlignment`.
  * **Theming & Design Tokens**: `ByCardThemeData` and `ByCardDefaults` for unified application-wide card styling.
* **BySelectOption**:
  * Reusable model and UI component for selectable options with active indicator, title, subtitle, icon, and badge support.
* **Documentation & Media**:
  * Added animated preview GIF for `ByCard` dynamic motion border gradient.

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