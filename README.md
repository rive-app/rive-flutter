[![Pub Version](https://img.shields.io/pub/v/rive)](https://pub.dev/packages/rive)
![Build Status](https://github.com/rive-app/rive-flutter/actions/workflows/tests.yaml/badge.svg)
![Discord badge](https://img.shields.io/discord/532365473602600965)
![Twitter handle](https://img.shields.io/twitter/follow/rive_app.svg?style=social&label=Follow)

# Rive Flutter

![Rive hero image](https://cdn.rive.app/rive_logo_dark_bg.png)

Rive Flutter is a runtime library for [Rive](https://rive.app), a real-time interactive design and animation tool.

This library allows you to fully control Rive files with a high-level API for simple interactions and animations, as well as a low-level API for creating custom render loops for multiple artboards, animations, and state machines in a single canvas.

## Table of contents

- [Rive Flutter](#rive-flutter)
  - [Table of contents](#table-of-contents)
  - [Overview of Rive](#overview-of-rive)
  - [Getting started](#getting-started)
  - [Choosing a Renderer](#choosing-a-renderer)
    - [Note on the Impeller renderer](#note-on-the-impeller-renderer)
  - [Supported platforms](#supported-platforms)
  - [Awesome Rive](#awesome-rive)
  - [Contributing](#contributing)
  - [Issues](#issues)

## Overview of Rive

[Rive](https://rive.app) is a powerful tool that helps teams create and run interactive animations for apps, games, and websites. Designers and developers can use the collaborative editor to create motion graphics that respond to different states and user inputs, and then use the lightweight open-source runtime libraries, like Rive Flutter, to load their animations into their projects.

For more information, check out the following resources:

:house_with_garden: [Homepage](https://rive.app/)

:blue_book: [General help docs](https://rive.app/community/doc/introduction/docvphVOrBbl)

🛠 [Rive Forums](https://rive.app/community/forums/home)

## Getting started

To get started with Rive Flutter, check out the following resources:

- [Getting Started with Rive in Flutter](https://rive.app/community/doc/flutter/docqzmYRZmvF)

For more information, see the Runtime sections of the Rive help documentation:

- [Animation Playback](https://rive.app/community/doc/animation-playback/docDKKxsr7ko)
- [Layout](https://rive.app/community/doc/layout/docBl81zd1GB)
- [State Machines](https://rive.app/community/doc/state-machines/docxeznG7iiK)
- [Rive Text](https://rive.app/community/doc/text/docn2E6y1lXo)
- [Rive Events](https://rive.app/community/doc/rive-events/docbOnaeffgr)
- [Loading Assets](https://rive.app/community/doc/loading-assets/doct4wVHGPgC)

More advanced usage:

- [Caching a RiveFile](https://rive.app/community/doc/caching-a-rive-file/docrLMDw15AJ)
- [Alternative Widget Setup](https://rive.app/community/doc/alternative-widget-setup/docNlDD0H0rp)
- [Custom Rive RenderObject](https://rive.app/community/doc/custom-rive-renderobject/docnbX5AnjkW)
- [Custom Painter](https://rive.app/community/doc/custom-rive-renderobject/docnbX5AnjkW)

## Choosing a Renderer

For more information see: https://rive.app/community/doc/overview/docD20dU9Rod

### Note on the Impeller renderer

Starting in Flutter v3.10, [Impeller](https://docs.flutter.dev/perf/impeller) has replaced [Skia](https://skia.org/) to become the default renderer for apps on the iOS platform and may continue to be the default on future platforms over time. As such, there is a possibility of rendering and [performance discrepancies](https://github.com/flutter/flutter/issues/134432) when using the Rive Flutter runtime with platforms that use the Impeller renderer that may not have surfaced before. If you encounter any visual or performance errors at runtime compared to expected behavior in the Rive editor, we recommend trying the following steps to triage:

1. Try running the Flutter app with the `--no-enable-impeller` flag to use the Skia renderer. If the visual discrepancy does not show when using Skia, it may be a rendering bug on Impeller. However, before raising a bug with the Flutter team, try the second point below👇
```bash
flutter run --no-enable-impeller
```
2. Try running the Flutter app on the latest master channel. It is possible that visual bugs may be resolved on the latest Flutter commits, but not yet released in the beta or stable channel.
3. If you are still seeing visual discrepancies with just the Impeller renderer on the latest master branch, we recommend raising a detailed issue to the [Flutter Github repo](https://github.com/flutter/flutter) with a reproducible example, and other relevant details that can help the team debug any possible issues that may be present.

## Supported platforms

Be sure to read the [platform specific considerations](platform_considerations.md) for the Rive Flutter package.

## Awesome Rive

For even more examples and resources on using Rive at runtime or in other tools, checkout the [awesome-rive](https://github.com/rive-app/awesome-rive) repo.

## Contributing

We love contributions and all are welcome! 💙

## Issues

Have an issue with using the runtime, or want to suggest a feature/API to help make your development life better? Log an issue in our [issues](https://github.com/rive-app/flutter/issues) tab! You can also browse older issues and discussion threads there to see solutions that may have worked for common problems.
