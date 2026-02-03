[![Pub Version](https://img.shields.io/pub/v/rive)](https://pub.dev/packages/rive)
![Build Status](https://github.com/rive-app/rive-flutter/actions/workflows/tests.yaml/badge.svg)
![Discord badge](https://img.shields.io/discord/532365473602600965)
![Twitter handle](https://img.shields.io/twitter/follow/rive_app.svg?style=social&label=Follow)

# Rive Flutter

![Rive hero image](https://cdn.rive.app/rive_logo_dark_bg.png)

Rive Flutter is a runtime library for [Rive](https://rive.app), a real-time interactive design tool.

This library allows you to fully control Rive files in your Flutter apps and games.

## Table of contents

- [Rive Flutter](#rive-flutter)
  - [Table of contents](#table-of-contents)
  - [Overview of Rive](#overview-of-rive)
  - [Getting started](#getting-started)
  - [Choosing a Renderer](#choosing-a-renderer)
    - [Note on the Impeller renderer](#note-on-the-impeller-renderer)
  - [Supported platforms](#supported-platforms)
  - [Awesome Rive](#awesome-rive)
  - [Troubleshooting](#troubleshooting)
  - [Building `rive_native`](#building-rive_native)
  - [Testing](#testing)
  - [Contributing](#contributing)
  - [Issues](#issues)
  - [Rive Flutter Legacy Runtime](#rive-flutter-legacy-runtime)

## Overview of Rive

[Rive](https://rive.app) combines an interactive design tool, a new stateful graphics format, a lightweight multi-platform runtime, and a blazing-fast vector renderer. This end-to-end pipeline guarantees that what you build in the Rive Editor is exactly what ships in your apps, games, and websites.

For more information, check out the following resources:

- [Homepage](https://rive.app/)
- [General Docs](https://rive.app/docs/)
- [Flutter Docs](https://rive.app/docs/runtimes/flutter/flutter)
- [Rive Community / Support](https://community.rive.app/c/support/)

## Getting started

See the [Getting Started with Rive in Flutter](https://rive.app/docs/runtimes/flutter/flutter) documentation.

**Example App**

The `rive` package depends on `rive_native`, and the code on GitHub may reference an unpublished version of `rive_native`. To run the example app, we recommend using the published version from [Pub](https://pub.dev/packages/rive) unless you intend to build the native libraries locally (see [Building `rive_native`](#building-rive_native)).

```bash
dart pub unpack rive        # Unpack the package source code and example app
cd rive/example             # Navigate to the example folder
flutter create .            # Create the platform folders
flutter pub get             # Fetch dependencies
flutter run                 # Run the example app
```

For more information, see the Runtime sections of the Rive help documentation:

- [Artboards](https://rive.app/docs/runtimes/artboards)
- [Layout](https://rive.app/docs/runtimes/layout)
- [State Machine Playback](https://rive.app/docs/runtimes/state-machines)
- [Data Binding](https://rive.app/docs/runtimes/data-binding)
- [Loading Assets](https://rive.app/docs/runtimes/loading-assets)
- [Caching a Rive file](https://rive.app/docs/runtimes/caching-a-rive-file)

## Choosing a Renderer

In Rive Flutter you have the option to choose either the Rive renderer, or the renderer that is used in Flutter (Skia or Impeller).

You choose a desired renderer when creating a Rive `File` object. All graphics that are then created from this `File` instance will use the selected renderer.

```dart
final riveFile = (await File.asset(
  'assets/rewards.riv',
  // Choose which renderer to use
  riveFactory: Factory.rive,
))!;
```

Options:

- `Factory.rive` for the Rive renderer
- `Factoy.flutter` for the Flutter renderer

For more information and additional consideration, see [Specifying a Renderer](https://rive.app/docs/runtimes/flutter/flutter#specifying-a-renderer).

### Note on the Impeller renderer

Starting in Flutter v3.10, [Impeller](https://docs.flutter.dev/perf/impeller) has replaced [Skia](https://skia.org/) to become the default renderer for apps on the iOS platform and may continue to be the default on future platforms over time. As such, there is a possibility of rendering and performance discrepencies when using the Rive Flutter runtime with platforms that use the Impeller renderer that may not have surfaced before. If you encounter any visual or performance errors at runtime compared to expected behavior in the Rive editor, we recommend trying the following steps to triage:

1. Try running the Flutter app with the `--no-enable-impeller` flag to use the Skia renderer. If the visual discrepancy does not show when using Skia, it may be a rendering bug on Impeller. However, before raising a bug with the Flutter team, try the second point below👇

```bash
flutter run --no-enable-impeller
```

2. Try running the Flutter app on the latest master channel. It is possible that visual bugs may be resolved on the latest Flutter commits, but not yet released in the beta or stable channel.
3. If you are still seeing visual discrepancies with just the Impeller renderer on the latest master branch, we recommend raising a detailed issue to the [Flutter Github repo](https://github.com/flutter/flutter) with a reproducible example, and other relevant details that can help the team debug any possible issues that may be present.

## Supported platforms

| Platform | Flutter Renderer | Rive Renderer |
| -------- | ---------------- | ------------- |
| iOS      | ✅               | ✅            |
| Android  | ✅               | ✅            |
| macOS    | ✅               | ✅            |
| Windows  | ✅               | ✅            |
| Linux    | ❌               | ❌            |
| Web      | ✅               | ✅            |

Be sure to read the [platform specific considerations](platform_considerations.md) for the Rive Flutter package.

## Awesome Rive

For even more examples and resources on using Rive at runtime or in other tools, checkout the [awesome-rive](https://github.com/rive-app/awesome-rive) repo.

## Troubleshooting

The required native libraries should be automatically downloaded during the build step (`flutter run` or `flutter build`). If you encounter issues, try the following:

1. Run `flutter clean`
2. Run `flutter pub get`
3. Run `flutter run`

Alternatively, you can manually run the `rive_native` setup script. In the root of your Flutter app, execute:

```bash
dart run rive_native:setup --verbose --clean --platform macos
```

This will clean the `rive_native` setup and download the platform-specific libraries specified with the `--platform` flag. Refer to the **Platform Support** section above for details.

## Building `rive_native`

By default, prebuilt native libraries are downloaded and used. If you prefer to build the libraries yourself, use the `--build` flag with the setup script:

```bash
flutter clean # Important
dart run rive_native:setup --verbose --clean --build --platform macos
```

> **Note**: Building the libraries requires specific tooling on your machine. Additional documentation will be provided soon.

## Testing

Shared libraries are included in the download/build process. If you've done `flutter run` on the native platform, the libraries should already be available.

Otherwise, manually download the prebuilt libraries by doing:

```bash
dart run rive_native:setup --verbose --clean --platform macos
```

Specify the desired `--platform`, options are `macos`, `windows`, and `linux`.

Now you can run `flutter test`.

Optionally build the libraries if desired:

```bash
dart run rive_native:setup --verbose --clean --build --platform macos
```

If you encounter issues using `rive_native` in your tests, please reach out to us for assistance.

## Contributing

We love contributions and all are welcome! 💙

## Issues

- Reach out to us on our [Community](https://community.rive.app/feed)
- File an issue on the [Rive Flutter repository](https://github.com/rive-app/rive-flutter/issues)

## Rive Flutter Legacy Runtime

You can find the old runtime code here: https://github.com/rive-app/rive-flutter-legacy

The last published Pub release for this code is `rive: 0.13.20`.

The majority of the new runtime code now lives in the [rive_native package](https://pub.dev/packages/rive_native).
