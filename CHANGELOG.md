## [0.7.14] - 2021-06-10 11:57:35
- Fixed an issue with State Machine exit time and one shot animations.

## [0.7.13] - 2021-06-09 19:29:20
- Fixed an issue with inputs not hooking up to 1D blend states at load time.

## [0.7.12] - 2021-06-02 14:35:44
- Support for artboard instancing!
- Fixes an issue with 100% exit time not working on loops.

## [0.7.11] - 2021-05-28 18:00:00
- Adds `RiveAnimation` high level widget.
- Fixes tests and add automated testing on push.
- Updates README.

## [0.7.10] - 2021-05-18 11:36:34
- Transitions from Any state will correctly mix from the last active state to the incoming one.

## [0.7.9] - 2021-05-08 12:48:50
- Better error reporting when loading files. Based on feedback from https://github.com/rive-app/rive-flutter/issues/96.
- Clamp between 0% and 100% when using an additive blend state.

## [0.7.8] - 2021-05-07 19:42:34
- Blend states! Support for 1D and Additive blend states.
## [0.7.7] - 2021-05-04 16:00:00
- Updates dependency versions

## [0.7.6] - 2021-05-04 13:50:16
- Fixing an issue with StateMachine changes not being applied on the first frame after playing.

## [0.7.5] - 2021-04-30 14:43:29
- Fixing an issue with StateMachine exitTime from states with animations that have a work area enabled.

## [0.7.4] - 2021-04-29 15:50:07
- Fixing race condition that could occur when importing StateMachineInputs.

## [0.7.3] - 2021-04-19 16:53:18
- Adding support for Rectangle corner radius properties and animation.
- Trigger inputs reset between state changes to avoid multi-firing state changes when a trigger is fired.

## [0.7.2] - 2021-04-12 16:57:54
- Breaking change! StateMachineInput has been renamed to SMIInput to follow conventions in other runtimes and clearly disambiguate between core.StateMachineInput (the backing type in Rive's core system, which is not explicitly exposed to this runtime) and the input instances which should be used by controllers in the Flutter ecosystem.
- New examples showing use of number, boolean, and trigger inputs.

## [0.7.1] - 2021-04-06 16:19:04
- Fixes an issue with hold keyframes not loading properly.

## [0.7.0] - 2021-03-31 16:16:39
- Added support for exit time in the State Machine.
- Loading of Rive files has changed to better support NNBD. This is a breaking change. Rive file's must now be imported from binary data as follows: `final file = RiveFile.import(data);` Please see the examples for sample implementations.
## [0.7.0-nullsafety.0] - 2021-03-29 16:58:23

- NNBD support.
- State Machine runtime support.
- New binary format 7.0 with improved flexibility which is not compatible with 6.0 files. The Rive editor will be able to export both format 6.0 and 7.0, but please note that 6.0 is now deprecated and all new improvements and bug fixes to the format will be done on 7.0.

## [0.6.8] - 2021-02-12 11:11:11

- Adds support for Flutter's `getMinIntrinsicWidth` (max, height, etc.), e.g. for `IntrinsicWidth`
  and `IntrinsicHeight` usage.
- Renames `Rive.useIntrinsicSize` to `Rive.useArtboardSize` by deprecating the former. The
  motivation for this is avoiding ambiguity with Flutter's intrinsics contract.
- Fixes issue #28 where the last frame of a one-shot animation isn't displayed.

## [0.6.7] - 2021-01-23 11:11:02

- Adds support for Rive.useIntrinsicSize to allow Rive widgets to be self sized by their artboard. Set useIntrinsicSize to false when you want the widget to try to occupy the entire space provided by the parent.

## [0.6.6+1] - 2021-01-18 17:06:17

- Fixes a crashing issue introduced in 0.6.6.

## [0.6.6] - 2021-01-18 16:40:10

- Adds getters for start/endTime and reset() in LinearAnimationInstance
- Fixes an issue with artboard background gradients when rendering with non-default origin values.
- Fixes an issue with trim paths across open paths.

## [0.6.5] - 2020-12-22 16:49:39

- Fixing issue with older minor versions crashing when newer minor files included objects with unknown keys. The runtime can now read beyond those.
- Shapes and paths hidden in the editor will not show up at runtime. 
- Runtime header now exposes Rive project id.

## [0.6.4] - 2020-12-11 15:43:01

- Adding support for parametric polygon and star shapes.
- Fixes to trim paths that wrap around the entire shape.
- Expose mix value in SimpleAnimation, allows for mixing multiple animations together.
  
## [0.6.3] - 2020-11-17 16:02:47

- Added support for parametric path origins.
- Fixes for rendering artboards with non-zero origin values.

## [0.6.2+3] - 2020-11-11 12:13:00

- Added Artboard tests.
- Added animationByName(String) function to Artboard.

## [0.6.2+2] - 2020-11-11 12:13:00

- Added RiveFile tests.
- Added artboardByName(String) function to RiveFile.

## [0.6.2+1] - 2020-11-06 12:00:00

- Added default noop implementation to `onActivate`, `onDeactivate`, and `dispose`
  in `RiveAnimationController`, which removes the need for noop overrides in subclasses
  like `SimpleAnimation`.

## [0.6.2] - 2020-10-02 15:45:10

- Exposed major and minor runtime version (issue #15) via riveVersion.
- Exposed major and minor version of loaded files via RiveFile().version.
- SimpleAnimation exposes the underlying LinearAnimationInstance.
- Export Loop enum such that it is available to users of the package.
- Fixed start point of LinearAnimationInstance when using a work area (custom start/end).

## [0.6.1] - 2020-09-30 12:21:32

- Bumping all runtimes to 0.6.1 to match (no functional changes in the Flutter one).

## [0.6.0+1] - 2020-09-30 11:55:07

- Fixing a mixing issue with double keyframes.

## [0.6.0] - 2020-09-28 16:22:43

- Adding a ToC to files indicating included core properties and their backing field types so that they may be skipped by runtimes that do not understand those properties. This will allow newer minor version files to be read by older minor version runtimes.
- New clipping system allowing for recursive shapes to be included as sources by selecting a node for clipping.
- New draw order system using draw targets.

## [0.5.2] - 2020-08-28 18:24:45

- Adding trim paths.

## [0.5.1] - 2020-08-26 18:09:13

- Bumping version number to match the runtime file version (5.1).
- Adding support for bones.
- Adding support for bone binding (deformation).

## [0.0.7] - 2020-08-15 15:53:17

- Adding support for clipping with Rive format version 5.

## [0.0.6] - 2020-08-12 18:09:07

- Adding support for version 4 with first cut of bones.

## [0.0.5] - 2020-08-07 20:05:18

- Updating format to only use unsigned integers to overcome a dart2js weakness with signed integers on the web.

## [0.0.4] - 2020-07-28 18:35:44

- Fundamental changes to runtime format enabling smaller file sizes. Format bumps to version 3.0 as it breaks backwards compatibility.

## [0.0.3] - 2020-07-19 18:18:50

- Support shorter string encoding. Format bumps to version 2.0 as it breaks backwards compatibility.

## [0.0.1+3] - 2020-07-09 11:13:22

- Fixing up ```flutter analyze``` issues thanks to @creativecreatorormaybenot.

## [0.0.1+2] - 2020-07-08 16:47:10

- Updating meta dependency to one that is compatible with Flutter 😶


## [0.0.1] - 2020-07-08 16:29:36

- Loading Rive 2 files.
- Use a Rive widget to display them.
- Drive animations with SimpleAnimation or make your own from RiveAnimationController.
