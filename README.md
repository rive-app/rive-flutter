[![Pub Version](https://img.shields.io/pub/v/rive)](https://pub.dev/packages/rive)
![Build Status](https://github.com/rive-app/rive-flutter/actions/workflows/tests.yaml/badge.svg)
![Discord badge](https://img.shields.io/discord/532365473602600965)
![Twitter handle](https://img.shields.io/twitter/follow/rive_app.svg?style=social&label=Follow)

# Rive Flutter

![Rive hero image](https://cdn.rive.app/rive_logo_dark_bg.png)

Rive Flutter is the Flutter runtime for [Rive](https://rive.app).

This library allows you to fully control Rive files in your Flutter apps and games.

## Table of contents

- [Rive Flutter](#rive-flutter)
  - [Table of contents](#table-of-contents)
  - [Overview of Rive](#overview-of-rive)
  - [Build with your agent](#build-with-your-agent)
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

[Rive](https://rive.app) is an agent-native 2D and 3D engine for games, apps, and interactive UI. Use it as your whole engine, or add it to the products you already have. Build with your coding agent through the [Rive CLI](https://rive.app/agents), or draw, rig, and animate by hand with the professional design and animation tools in the [Rive Editor](https://rive.app/editor). Both work on the same files. Open-source runtimes, no royalties or runtime fees. Rive files (`.riv`) play natively on web, mobile, desktop, game engines, consoles, smart TVs, and cars.

For more information, check out the following resources:

- [Homepage](https://rive.app/)
- [General Docs](https://rive.app/docs/)
- [Flutter Docs](https://rive.app/docs/runtimes/flutter/flutter)
- [Rive Community / Support](https://community.rive.app/c/support/)

## Build with your agent

Paste this into Claude Code, Codex, Cursor, or any agent that runs commands on your computer:

```text
Install the Rive CLI from rive.app/cli. Build an animated onboarding screen as a Rive file and add it to my Flutter app with the Rive runtime.
```

Your agent installs the [Rive CLI](https://rive.app/agents), writes the scene, and opens a preview window that rebuilds every time it saves. Keep giving it notes, or open the same file in the [Rive Editor](https://editor.rive.app/) and shape it by hand. Trying it needs no account. Writing the `.riv` that ships in your app needs a free Rive account. Free exports play a short Rive splash screen; [paid plans](https://rive.app/pricing) export without it. See [Getting started with the Rive CLI](https://rive.app/docs/cli/getting-started).

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
| Linux    | ✅               | ✅            |
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

By default, prebuilt native libraries are downloaded and used. If you prefer to build the libraries yourself, use the `--build` flag with the setup script. In the root of your Flutter app:

```bash
flutter clean # Important
flutter pub get
dart run rive_native:setup --verbose --clean --build --platform macos
```

See [Building rive_native](https://rive.app/docs/runtimes/flutter/rive-native#building-rive_native) in the official docs for the required tooling per platform, supported `--platform` values, web specifics, and how to return to the prebuilt libraries.

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
