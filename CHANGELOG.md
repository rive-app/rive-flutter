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
