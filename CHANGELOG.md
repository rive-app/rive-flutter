## 0.7.28

* Ability to disable clipping on artboards. [`#161`](https://github.com/rive-app/rive-flutter/pull/161)

## 0.7.27

* Adds support for translation, scale, and rotation constraints. 

## 0.7.26

* Adds support for distance constraints. [`#158`](https://github.com/rive-app/rive-flutter/pull/158)

## 0.7.25

* Fixes an issue with bones bound to paths which are also constrained via IK. [`#157`](https://github.com/rive-app/rive-flutter/pull/157)

## 0.7.24

* Support for distance constraints in Flutter. [`#156`](https://github.com/rive-app/rive-flutter/pull/156)

## 0.7.23

* Support for IK constraints in Flutter. [`#153`](https://github.com/rive-app/rive-flutter/pull/153)

## 0.7.22

* Stroke don't draw when their thickness is 0.

## 0.7.21

* Adds onStateChange callback to state machine controllers

## 0.7.20

* Quick start fixes in README.md

## 0.7.19

* BREAKING CHANGE: onInit callback now takes an artboard as a parameter
* Adds simple state machine example

## 0.7.18

* Adds ability to pass controllers into RiveAnimation widgets
* Adds autoplay option to SimpleAnimation controller
* Adds one-shot animation contoller
* Updates examples

## 0.7.17

* Exposes antialiasing option in Rive and RiveAnimation widgets.

## 0.7.16

* Fixes broken build issue in 0.7.15

## 0.7.15

* Adds linear animation and state machine getters to RuntimeArtboard.
* RiveAnimation now takes lists of animation and state machine names and plays all of them.
* NOTE: this build is broken

## 0.7.14

* Fixed an issue with State Machine exit time and one shot animations.

## 0.7.13

* Fixed an issue with inputs not hooking up to 1D blend states at load time.

## 0.7.12

* Support for artboard instancing!
* Fixes an issue with 100% exit time not working on loops.

## 0.7.11

* Adds `RiveAnimation` high level widget.
* Fixes tests and add automated testing on push.
* Updates README.

## 0.7.10

* Transitions from Any state will correctly mix from the last active state to the incoming one.

## 0.7.9

* Better error reporting when loading files. Based on feedback from https://github.com/rive-app/rive-flutter/issues/96.
* Clamp between 0% and 100% when using an additive blend state.

## 0.7.8

* Blend states! Support for 1D and Additive blend states.

## 0.7.7

* Updates dependency versions

## 0.7.6

* Fixing an issue with StateMachine changes not being applied on the first frame after playing.

## 0.7.5

* Fixing an issue with StateMachine exitTime from states with animations that have a work area enabled.

## 0.7.4

* Fixing race condition that could occur when importing StateMachineInputs.

## 0.7.3

* Adding support for Rectangle corner radius properties and animation.
* Trigger inputs reset between state changes to avoid multi-firing state changes when a trigger is fired.

## 0.7.2

* Breaking change! StateMachineInput has been renamed to SMIInput to follow conventions in other runtimes and clearly disambiguate between core.StateMachineInput (the backing type in Rive's core system, which is not explicitly exposed to this runtime) and the input instances which should be used by controllers in the Flutter ecosystem.
* New examples showing use of number, boolean, and trigger inputs.

## 0.7.1

* Fixes an issue with hold keyframes not loading properly.

## 0.7.0

* Added support for exit time in the State Machine.
* Loading of Rive files has changed to better support NNBD. This is a breaking change. Rive file's must now be imported from binary data as follows: `final file = RiveFile.import(data);` Please see the examples for sample implementations.

## 0.7.0-nullsafety.0

* NNBD support.
* State Machine runtime support.
* New binary format 7.0 with improved flexibility which is not compatible with 6.0 files. The Rive editor will be able to export both format 6.0 and 7.0, but please note that 6.0 is now deprecated and all new improvements and bug fixes to the format will be done on 7.0.

## 0.6.8

* Adds support for Flutter's `getMinIntrinsicWidth` (max, height, etc.), e.g. for `IntrinsicWidth`
  and `IntrinsicHeight` usage.
* Renames `Rive.useIntrinsicSize` to `Rive.useArtboardSize` by deprecating the former. The
  motivation for this is avoiding ambiguity with Flutter's intrinsics contract.
* Fixes issue #28 where the last frame of a one-shot animation isn't displayed.

## 0.6.7

* Adds support for Rive.useIntrinsicSize to allow Rive widgets to be self sized by their artboard. Set useIntrinsicSize to false when you want the widget to try to occupy the entire space provided by the parent.

## 0.6.6+1

* Fixes a crashing issue introduced in 0.6.6.

## 0.6.6

* Adds getters for start/endTime and reset() in LinearAnimationInstance
* Fixes an issue with artboard background gradients when rendering with non-default origin values.
* Fixes an issue with trim paths across open paths.

## 0.6.5

* Fixing issue with older minor versions crashing when newer minor files included objects with unknown keys. The runtime can now read beyond those.
* Shapes and paths hidden in the editor will not show up at runtime. 
* Runtime header now exposes Rive project id.

## 0.6.4

* Adding support for parametric polygon and star shapes.
* Fixes to trim paths that wrap around the entire shape.
* Expose mix value in SimpleAnimation, allows for mixing multiple animations together.
  
## 0.6.3

* Added support for parametric path origins.
* Fixes for rendering artboards with non-zero origin values.

## 0.6.2+3

* Added Artboard tests.
* Added animationByName(String) function to Artboard.

## 0.6.2+2

* Added RiveFile tests.
* Added artboardByName(String) function to RiveFile.

## 0.6.2+1

* Added default noop implementation to `onActivate`, `onDeactivate`, and `dispose`
  in `RiveAnimationController`, which removes the need for noop overrides in subclasses
  like `SimpleAnimation`.

## 0.6.2

* Exposed major and minor runtime version (issue #15) via riveVersion.
* Exposed major and minor version of loaded files via RiveFile().version.
* SimpleAnimation exposes the underlying LinearAnimationInstance.
* Export Loop enum such that it is available to users of the package.
* Fixed start point of LinearAnimationInstance when using a work area (custom start/end).

## 0.6.1

* Bumping all runtimes to 0.6.1 to match (no functional changes in the Flutter one).

## 0.6.0+1

* Fixing a mixing issue with double keyframes.

## 0.6.0

* Adding a ToC to files indicating included core properties and their backing field types so that they may be skipped by runtimes that do not understand those properties. This will allow newer minor version files to be read by older minor version runtimes.
* New clipping system allowing for recursive shapes to be included as sources by selecting a node for clipping.
* New draw order system using draw targets.

## 0.5.2

* Adding trim paths.

## 0.5.1

* Bumping version number to match the runtime file version (5.1).
* Adding support for bones.
* Adding support for bone binding (deformation).

## 0.0.7

* Adding support for clipping with Rive format version 5.

## 0.0.6

* Adding support for version 4 with first cut of bones.

## 0.0.5

* Updating format to only use unsigned integers to overcome a dart2js weakness with signed integers on the web.

## 0.0.4

* Fundamental changes to runtime format enabling smaller file sizes. Format bumps to version 3.0 as it breaks backwards compatibility.

## 0.0.3

* Support shorter string encoding. Format bumps to version 2.0 as it breaks backwards compatibility.

## 0.0.1+3

* Fixing up ```flutter analyze``` issues thanks to @creativecreatorormaybenot.

## 0.0.1+2

* Updating meta dependency to one that is compatible with Flutter 😶

## 0.0.1

* Loading Rive 2 files.
* Use a Rive widget to display them.
* Drive animations with SimpleAnimation or make your own from RiveAnimationController.
