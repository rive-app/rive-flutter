## 0.14.0-dev.3

Bumps to `rive_native: 0.0.6`

- Updates the Rive C++ runtime and renderer for the latest bug fixes and performance improvements.

### Fixes

- A dual mutex deadlock on iOS/macOS during window/texture resizing under certain conditions.
- An issue where the Rive Renderer requests a repaint on a disposed render object.

## 0.14.0-dev.2

### Fixes

- Fixed a crash on iOS for the Flutter renderer on cleanup.

## 0.14.0-dev.1

This is a significant update for Rive Flutter. We've completely removed all of the Dart code that was used for the Rive runtime and replaced it with our underlying [C++ Runtime](https://github.com/rive-app/rive-runtime).

This has resulted in significant changes to the underlying API.

Please see the [migration guide](https://rive.app/docs/runtimes/flutter/migration-guide), [Rive Flutter documentation](https://rive.app/docs/runtimes/flutter/flutter), and the updated example app for more information.

The core runtime code is now in [rive_native](https://pub.dev/packages/rive_native). This release uses `v0.0.4` of that package.

### What's New in 0.14.0

This release of Rive Flutter adds:

- The [Rive Renderer](https://rive.app/renderer)
- Support for [Data Binding](https://rive.app/docs/editor/data-binding/overview)
- Support for [Layouts](https://rive.app/docs/editor/layouts/layouts-overview)
- Support for [Scrolling](https://rive.app/docs/editor/layouts/scrolling)
- Support for N-[Slicing](https://rive.app/docs/editor/layouts/n-slicing)
- Support for [Vector Feathering](https://rive.app/blog/introducing-vector-feathering)
- All other features added to Rive that did not make it to the previous versions of Rive Flutter
- Includes the latest fixes and improvements for the Rive C++ runtime
- Adds prebuilt libraries, with the ability to build manually. See the [rive_native](https://pub.dev/packages/rive_native) package for more information
- Removes the `rive_common` package and replaces it with `rive_native`

Now that Rive Flutter makes use of the core Rive C++ runtime, you can expect new Rive features to be supported sooner for Rive Flutter.

**Note:** All your Rive graphics will still look and function the same as they did before.

## Requirements

### Dart and Flutter Versions

This release bumps to these versions:

```yaml
sdk: ">=3.5.0 <4.0.0"
flutter: ">=3.3.0"
```

## 0.13.20

- Fix: Windows/Linux building. Undefined symbol `hb_style_get_value`, see issue [437](https://github.com/rive-app/rive-flutter/issues/437)

## 0.13.19

- Adds the `isTouchScrollEnabled` property to `RiveAnimation` and `Rive` widgets. When `true` allows scrolling behavior to occur on Rive widgets when a touch/drag action is performed on touch-enabled devices. Defauls to `false`, which means Rive will "absorb" the pointer down event and a scroll cannot be triggered if the touch occured within a Rive Listener area. Setting to `true` will impact Rive's capability to handle multiple gestures simultaneously.
- Bump to latest `rive_common`, v0.4.14.

## 0.13.18

- Bump to latest `rive_common`, v0.4.13. Resolves [issues building rive_common downstream](https://github.com/rive-app/rive-flutter/issues/354#issuecomment-2491004291).

## 0.13.17

- Expose `speedMultiplier` on the `RiveAnimation` and `Rive` widgets. With this you can adjust the playback speed of an animation or state machine. Thanks [tguerin](https://github.com/tguerin) for the contribution. See [423](https://github.com/rive-app/rive-flutter/pull/423)

## 0.13.16

- Avoid audio init on empty assets. See PR [431](https://github.com/rive-app/rive-flutter/pull/431).

## 0.13.15

- Fix audio crashing iOS
- Add new text resizing and layout features. Resolves [422](https://github.com/rive-app/rive-flutter/issues/422).

## 0.13.14

- Reduce audio polling and unneeded runtime calculations around audio. Resolves issue [411](https://github.com/rive-app/rive-flutter/issues/411)

## 0.13.13

- Update Android `minSdkVersion` from 16 to 19
- Update `kotlin_version` from '1.6.10' to '1.7.10'
- Specify the Android NDK version Rive should use by setting `rive.ndk.version` in `gradle.properties`. For example: `rive.ndk.version=26.3.11579264`. See issue [398](https://github.com/rive-app/rive-flutter/issues/398).
- Expand supported `web` package range to `web: ">=0.5.1 <2.0.0"`. Resolves issues [413](https://github.com/rive-app/rive-flutter/issues/413) and [415](https://github.com/rive-app/rive-flutter/issues/415).
- Fix iOS audio issue, see [416](https://github.com/rive-app/rive-flutter/issues/416)
- Various other fixes and improvements to support new Editor features

## 0.13.12

- Fix [410](https://github.com/rive-app/rive-flutter/issues/410) Rive not compatible with Flutter web.

## 0.13.11

- Add `applyWorkaroundToRiveOnOldAndroidVersions`. Experimental workaround when loading native libraries on Android 6 (see [this issue](https://github.com/rive-app/rive-flutter/issues/403)). The method should be called before using any Rive APIs.

## 0.13.10

- Fix [408](https://github.com/rive-app/rive-flutter/issues/408) and [409](https://github.com/rive-app/rive-flutter/issues/409), Rive never reaching a settled state when the widget is not visible (paint method not called).

## 0.13.9

- Preperation for data binding ([databinding](https://github.com/rive-app/rive-flutter/commit/6ceb7a544e7124d303259f7d032641e5b38f7fc1), [data binding data context](https://github.com/rive-app/rive-flutter/commit/6d002300a6f0fd19f6dacac58a499ccc903a214d), [databinding add boolean](https://github.com/rive-app/rive-flutter/commit/90b8c81f0e496502b70db4d550341f5acabbbea6)).
- Layout fixes and improvements ([animations for layouts](https://github.com/rive-app/rive-flutter/commit/8068e48eb2faa2a13eab1ba858b4e0737cf0265b), [layout UX fixes](https://github.com/rive-app/rive-flutter/commit/21bd3765ddc3ef8c3b1f0199f75eae21434cf52b)).
- Android example project [fix](https://github.com/rive-app/rive-flutter/commit/9951f912df4c6f0574f57d5a152cd36e6ad2d7e0).

## 0.13.8

- Add `key` property to `Rive` widget.
- Nested linear animations report events up to parent artboards. Previously, only nested state machines could report events so that listeners in parent artboards could listen for them.

## 0.13.7

- Add `getComponentWhereOrNull` on `Artboard`, to find a component that matches the given predicate. This can be used instead of `forEachComponent` as it allows exiting early.

## 0.13.6

- Add `getBoolInput(name, path)`, `getTriggerInput(name, path)`, and `getNumberInput(name, path` on `Artboard` to set nested inputs (inputs on nested artboards), see [the documentation](https://rive.app/community/doc/state-machines/docxeznG7iiK#nested-inputs).

## 0.13.5

- Migrates to `dart:js_interop` and `package:web` APIs.
- DEPRECATED: `RiveFile.initializeText` - use `RiveFile.initialize` instead. This now initializes the Rive audio, text, and layout engine. Call `await RiveFile.initialize()` before doing `RiveFile.import`. `RiveFile.asset`, `RiveFile.network`, and `RiveFile.file` will call initialize automatically if it has not been initialized. Alternatively, you can also call `unawaited(RiveFile.initialize());` in the `main` method on app start to make the first graphic load faster.

## 0.13.4

- Fixed an issue with [TickerMode](https://api.flutter.dev/flutter/widgets/TickerMode-class.html) value not pausing a Rive graphic. Thanks to 'jaggernod' for the [contribution](https://github.com/rive-app/rive-flutter/pull/380).
- Bump rive_common to pick up the Privacy manifest for iOS & macOS runtimes

## 0.13.2

- DEPRECATED: `Extension` and `Type` enum on `FileAsset`. You can create a custom maintained version, see example: https://gist.github.com/HayesGordon/5d37d3fb26f54b2c231760c2c8685963
- BREAKING: Removal of previously deprecated methods `assetResolver` on `RiveFile.network` and class `NetworkAssetResolver`
- Add Audio out-of-band, with examples.
- Support for asset audio volume.
- Fixed an issue with audio decoder in web build.
- Adds `play()`/`pause()` and `isPlaying` to an `Artboard`. This completely stops the artboard from playing (including nested artboards) and stops/starts the animation ticker. Pausing an artboard can be used to reduce resources used for Rive graphics that aren't visible on screen.
- Adds `getBoolInput`, `getTriggerInput`, `getNumberInput`, and `triggerInput` on `StateMachineController` to easily retrieve state machine inputs and fire triggers. This can be used instead of `findInput` and `findSMI`, to easily retrieve an `SMIBool`, `SMINumber`, and `SMITrigger` to manipulate a Rive state machine.

## 0.13.1

- Fixed an issue causing crashes on 32 bit devices

## 0.13.0

- Adds support for Audio.
- Object Generator adds the ability to override built-in objects with custom objects.
- Fix [[355](https://github.com/rive-app/rive-flutter/issues/355)] to ensure the Rive render object is attached before handling pointer events.

## 0.12.4

- Adds `behavior` argument to `RiveAnimation` and `Rive`. An enum `RiveHitTestBehavior` specifies how to handle hit testing on an animation. Default is `RiveHitTestBehavior.opaque` - consuming all hit events for the artboard bounds.
- Collapsed nested artboards don't listen to pointer events anymore
- Constraints pointing to collapsed targets are not applied

## 0.12.3

- Support for Nested Inputs and Nested Events. See the docs on [Nested Artboards](https://rive.app/community/doc/nested-artboards/docL5SnBgUng).

## 0.12.2

- Fixes an issue when importing interpolators.
- Increase HTTP dependency range.

## 0.12.1

- Elastic easing.

## 0.12.0

- BREAKING: Changes to `assetLoader` in `RiveFile`. See the Rive docs on [Loading Assets](https://rive.app/community/doc/loading-assets/doct4wVHGPgC) for updated examples.

## 0.11.17

- Timeline based events with new example showing how to play audio when an event fires.
- More events examples: open url, star rating.

## 0.11.16

- Updates to text engine to support newer version of clang on Windows.

## 0.11.15

- New event system! Listen to events reported by a StateMachine via StateMachineController.addEventListener.
- Fixes an issue with animations not playing back correctly when a work area is defined.

## 0.11.14

- Refactor how hit testing is performed in `RiveAnimation` and `Rive` widgets. Pointer events (listeners) can now be enabled on the `Rive` widget by setting `enablePointerEvents` to `true` (default is false).
- Change in how animations advance when using `RiveAnimation` and `Rive` widgets. Now using `Ticker`, which will allow Rive animations to respect `timeDilation` and `TickerMode`. Resolves [187](https://github.com/rive-app/rive-flutter/issues/187), [254](https://github.com/rive-app/rive-flutter/issues/254), [307](https://github.com/rive-app/rive-flutter/issues/307), and [328](https://github.com/rive-app/rive-flutter/issues/328)
- Support for line spacing.

## 0.11.13

- Initializes Rive's text engine only when necessary when calling any of `RiveFile.asset`, `RiveFile.network`, or `RiveFile.file`.
- You'll need to manually call `RiveFile.initializeText` when calling `RiveFile.import` directly to use text features. You can optionally only call this if you know the file needs the text engine, or you can determine if it needs it by calling `RiveFile.needsTextRuntime`.

## 0.11.12

- Fixes a memory leak in the text engine.

## 0.11.11

- Fixes an issue with text clipping when baseline is aligned to origin.

## 0.11.10

- Fixes an issue with the origin on the TransformConstraint affecting non-text objects.

## 0.11.9

- Fix [335](https://github.com/rive-app/rive-flutter/issues/335) \_debugDisposed issue
- Fix issue showing text when the default font is not available at `assets/fonts/Inter-Regular.ttf` ([338](https://github.com/rive-app/rive-flutter/issues/338)). We will set first valid font we encounter in a rive file as default font instead.

## 0.11.8

- Fix text origin changing updating text offset.

## 0.11.7

- Fix for gradients on text.

## 0.11.6

- Follow path constraint.
- Expose `useArtboardSize` in `RiveAnimation` widget. Which is a boolean that determines whether to use the inherent size of the artboard, i.e. the absolute size defined by the artboard, or size the widget based on the available constraints only (sized by parent).
- Add `clipRect` to `RiveAnimation` and `Rive` widgets. Forces the artboard to clip with the provided Rect.
- Fixed `Rive` widget always applying a clip, regardless of `Artboard.clip` value (set in the Editor).
- Support for run targeting with text modifiers.
- Transform constraint can target text origin.

## 0.11.5

- Resolve assets, such as images and fonts, manually. This allows for swapping out image/font assets at runtime, instead of using the embedded versions. See `RiveFile` and `CallbackAssetLoader`.
- Update `http` package to v1.1.0
- Fix [[331](https://github.com/rive-app/rive-flutter/issues/331)] - external control on a Joystick not applied

Deprecated:

- `assetResolver` parameter on `RiveFile.network` and `RiveFile.import`. Use `assetLoader` instead - see `CallbackAssetLoader`.
- `NetworkAssetResolver`, use `CallbackAssetLoader` instead.

## 0.11.4

- Adds interpolation on states feature.

## 0.11.3

- Bumps rive_common to add Android namespace to support Gradle 8 (issue [312](https://github.com/rive-app/rive-flutter/issues/312)).

## 0.11.2

- Add parameter to specify headers on `RiveAnimation.network` widget, and `RiveFile.network`.

## 0.11.1

- Joysticks with custom handle sources.

## 0.11.0

- Joysticks!
- Bumping to latest rive_common with some changes to AABB math api.
- Bumping Dart SDK requirements.

## 0.10.4

- Support for Solos.

## 0.10.3

- Fixes animations with negative speed to play from the end with ping pong and one shot animations.
- Update runtime to consider speed on animation states when playing state machines.
- Fix edge case with spilled time, by clearing spilled time after an advance cycle.

## 0.10.2

- Performance improvement: No longer drawing components with an opacity of 0.
- Updated example, see "Skinning Demo".
- Support for negative speeds on linear animations when played back in state machines.
- Support for overriding speed on animation states.

## 0.10.1

- Fix [[277](https://github.com/rive-app/rive-flutter/issues/277)] and [[278](https://github.com/rive-app/rive-flutter/issues/278)] that resulted in `onInit` being called with each `setState` - thank you [xuelongqy](https://github.com/xuelongqy).

## 0.10.0

- Text support
- Initialise `RiveAnimation` directly: `RiveAnimation.direct(riveFile)`

## 0.9.1

- Support for Nested Inputs.
- Updated corner radius logic (matches new editor changes).

## 0.9.0

- Support for Listeners.
- Fixes for Flutter 3.0 warnings.
- Initial support for NestedStateMachine

## 0.8.4

- Mesh deform support for image assets, including bone binding and skin deformation.
- Fixed an issue with references to missing assets.
- Fixed some warnings.

## 0.8.1

- Support for raster assets!

## 0.7.33

- Fixes issue with nested artboard opacity not updating in sync with the artboard. ['#185](https://github.com/rive-app/rive-flutter/pull/185)

## 0.7.32

- Fixing issues reported by pub.dev ['#180](https://github.com/rive-app/rive-flutter/pull/180)

## 0.7.31

- API Improvements. [`#177`](https://github.com/rive-app/rive-flutter/pull/177)
- Option to frame origin, same as C++ runtime.
- RiveScene renderer and controller for making custom Rive vignettes of Rive content with multiple artboards, custom camera movement, etc.
- New StateMachineController.findSMI to find any StateMachineInput (fixes issue with findInput that cannot distinguish between Boolean and Trigger inputs).

## 0.7.30

Fix for setState being called while mounted in RiveAnimation. [`#172`](https://github.com/rive-app/rive-flutter/pull/172)

## 0.7.29

- Runtime support for Nested Artboards, a new Rive feature launching soon. [`#171`](https://github.com/rive-app/rive-flutter/pull/171)

## 0.7.28

- Ability to disable clipping on artboards. [`#161`](https://github.com/rive-app/rive-flutter/pull/161)

## 0.7.27

- Adds support for translation, scale, and rotation constraints.

## 0.7.26

- Adds support for distance constraints. [`#158`](https://github.com/rive-app/rive-flutter/pull/158)

## 0.7.25

- Fixes an issue with bones bound to paths which are also constrained via IK. [`#157`](https://github.com/rive-app/rive-flutter/pull/157)

## 0.7.24

- Support for distance constraints in Flutter. [`#156`](https://github.com/rive-app/rive-flutter/pull/156)

## 0.7.23

- Support for IK constraints in Flutter. [`#153`](https://github.com/rive-app/rive-flutter/pull/153)

## 0.7.22 - (2021-06-22)

- Stroke don't draw when their thickness is 0.

## 0.7.21 - (2021-06-21)

- Adds onStateChange callback to state machine controllers

## 0.7.20 - (2021-06-19)

- Quick start fixes in README.md

## 0.7.19 - (2021-06-18)

- BREAKING CHANGE: onInit callback now takes an artboard as a parameter
- Adds simple state machine example

## 0.7.18 - (2021-06-14)

- Adds ability to pass controllers into RiveAnimation widgets
- Adds autoplay option to SimpleAnimation controller
- Adds one-shot animation controller
- Updates examples

## 0.7.17 - (2021-06-11)

- Exposes antialiasing option in Rive and RiveAnimation widgets.

## 0.7.16 - (2021-06-11)

- Fixes broken build issue in 0.7.15

## 0.7.15 - (2021-06-10)

- Adds linear animation and state machine getters to RuntimeArtboard.
- RiveAnimation now takes lists of animation and state machine names and plays all of them.
- NOTE: this build is broken

## 0.7.14 - (2021-06-10)

- Fixed an issue with State Machine exit time and one shot animations.

## 0.7.13 - (2021-06-09)

- Fixed an issue with inputs not hooking up to 1D blend states at load time.

## 0.7.12 - (2021-06-02)

- Support for artboard instancing!
- Fixes an issue with 100% exit time not working on loops.

## 0.7.11 - (2021-05-28)

- Adds `RiveAnimation` high level widget.
- Fixes tests and add automated testing on push.
- Updates README.

## 0.7.10 - (2021-05-18)

- Transitions from Any state will correctly mix from the last active state to the incoming one.

## 0.7.9 - (2021-05-08)

- Better error reporting when loading files. Based on feedback from https://github.com/rive-app/rive-flutter/issues/96.
- Clamp between 0% and 100% when using an additive blend state.

## 0.7.8 - (2021-05-07)

- Blend states! Support for 1D and Additive blend states.

## 0.7.7 - (2021-05-04)

- Updates dependency versions

## 0.7.6 - (2021-05-04)

- Fixing an issue with StateMachine changes not being applied on the first frame after playing.

## 0.7.5 - (2021-04-30)

- Fixing an issue with StateMachine exitTime from states with animations that have a work area enabled.

## 0.7.4 - (2021-04-29)

- Fixing race condition that could occur when importing StateMachineInputs.

## 0.7.3 - (2021-04-19)

- Adding support for Rectangle corner radius properties and animation.
- Trigger inputs reset between state changes to avoid multi-firing state changes when a trigger is fired.

## 0.7.2 - (2021-04-12)

- Breaking change! StateMachineInput has been renamed to SMIInput to follow conventions in other runtimes and clearly disambiguate between core.StateMachineInput (the backing type in Rive's core system, which is not explicitly exposed to this runtime) and the input instances which should be used by controllers in the Flutter ecosystem.
- New examples showing use of number, boolean, and trigger inputs.

## 0.7.1 - (2021-04-06)

- Fixes an issue with hold keyframes not loading properly.

## 0.7.0 - (2021-03-31)

- Added support for exit time in the State Machine.
- Loading of Rive files has changed to better support NNBD. This is a breaking change. Rive file's must now be imported from binary data as follows: `final file = RiveFile.import(data);` Please see the examples for sample implementations.

## 0.7.0-nullsafety.0 - (2021-03-29)

- NNBD support.
- State Machine runtime support.
- New binary format 7.0 with improved flexibility which is not compatible with 6.0 files. The Rive editor will be able to export both format 6.0 and 7.0, but please note that 6.0 is now deprecated and all new improvements and bug fixes to the format will be done on 7.0.

## 0.6.8 - (2021-02-12)

- Adds support for Flutter's `getMinIntrinsicWidth` (max, height, etc.), e.g. for `IntrinsicWidth`
  and `IntrinsicHeight` usage.
- Renames `Rive.useIntrinsicSize` to `Rive.useArtboardSize` by deprecating the former. The
  motivation for this is avoiding ambiguity with Flutter's intrinsics contract.
- Fixes issue #28 where the last frame of a one-shot animation isn't displayed.

## 0.6.7 - (2021-01-23)

- Adds support for Rive.useIntrinsicSize to allow Rive widgets to be self sized by their artboard. Set useIntrinsicSize to false when you want the widget to try to occupy the entire space provided by the parent.

## 0.6.6+1 - (2021-01-18)

- Fixes a crashing issue introduced in 0.6.6.

## 0.6.6 - (2021-01-18)

- Adds getters for start/endTime and reset() in LinearAnimationInstance
- Fixes an issue with artboard background gradients when rendering with non-default origin values.
- Fixes an issue with trim paths across open paths.

## 0.6.5 - (2020-12-22)

- Fixing issue with older minor versions crashing when newer minor files included objects with unknown keys. The runtime can now read beyond those.
- Shapes and paths hidden in the editor will not show up at runtime.
- Runtime header now exposes Rive project id.

## 0.6.4 - (2020-12-11)

- Adding support for parametric polygon and star shapes.
- Fixes to trim paths that wrap around the entire shape.
- Expose mix value in SimpleAnimation, allows for mixing multiple animations together.

## 0.6.3 - (2020-11-17)

- Added support for parametric path origins.
- Fixes for rendering artboards with non-zero origin values.

## 0.6.2+3 - (2020-11-11)

- Added Artboard tests.
- Added animationByName(String) function to Artboard.

## 0.6.2+2 - (2020-11-11)

- Added RiveFile tests.
- Added artboardByName(String) function to RiveFile.

## 0.6.2+1 - (2020-11-06)

- Added default noop implementation to `onActivate`, `onDeactivate`, and `dispose`
  in `RiveAnimationController`, which removes the need for noop overrides in subclasses
  like `SimpleAnimation`.

## 0.6.2 - (2020-10-02)

- Exposed major and minor runtime version (issue #15) via riveVersion.
- Exposed major and minor version of loaded files via RiveFile().version.
- SimpleAnimation exposes the underlying LinearAnimationInstance.
- Export Loop enum such that it is available to users of the package.
- Fixed start point of LinearAnimationInstance when using a work area (custom start/end).

## 0.6.1 - (2020-09-30)

- Bumping all runtimes to 0.6.1 to match (no functional changes in the Flutter one).

## 0.6.0+1 - (2020-09-30)

- Fixing a mixing issue with double keyframes.

## 0.6.0 - (2020-09-28)

- Adding a ToC to files indicating included core properties and their backing field types so that they may be skipped by runtimes that do not understand those properties. This will allow newer minor version files to be read by older minor version runtimes.
- New clipping system allowing for recursive shapes to be included as sources by selecting a node for clipping.
- New draw order system using draw targets.

## 0.5.2 - (2020-08-28)

- Adding trim paths.

## 0.5.1 - (2020-08-26)

- Bumping version number to match the runtime file version (5.1).
- Adding support for bones.
- Adding support for bone binding (deformation).

## 0.0.7 - (2020-08-15)

- Adding support for clipping with Rive format version 5.

## 0.0.6 - (2020-08-12)

- Adding support for version 4 with first cut of bones.

## 0.0.5 - (2020-08-07)

- Updating format to only use unsigned integers to overcome a dart2js weakness with signed integers on the web.

## 0.0.4 - (2020-07-28)

- Fundamental changes to runtime format enabling smaller file sizes. Format bumps to version 3.0 as it breaks backwards compatibility.

## 0.0.3 - (2020-07-19)

- Support shorter string encoding. Format bumps to version 2.0 as it breaks backwards compatibility.

## 0.0.1+3 - (2020-07-09)

- Fixing up `flutter analyze` issues thanks to @creativecreatorormaybenot.

## 0.0.1+2 - (2020-07-08)

- Updating meta dependency to one that is compatible with Flutter 😶

## 0.0.1 - (2020-07-08)

- Loading Rive 2 files.
- Use a Rive widget to display them.
- Drive animations with SimpleAnimation or make your own from RiveAnimationController.
