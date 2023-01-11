[![Pub Version](https://img.shields.io/pub/v/rive)](https://pub.dev/packages/rive)
![Build Status](https://github.com/rive-app/rive-flutter/actions/workflows/tests.yaml/badge.svg)
![Discord badge](https://img.shields.io/discord/532365473602600965)
![Twitter handle](https://img.shields.io/twitter/follow/rive_app.svg?style=social&label=Follow)

# Rive Flutter

![Rive hero image](https://rive-app.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fff44ed5f-1eea-4154-81ef-84547e61c3fd%2Frive_notion.png?table=block&id=f198cab2-c0bc-4ce8-970c-42220379bcf3&spaceId=9c949665-9ad9-445f-b9c4-5ee204f8b60c&width=2000&userId=&cache=v2)

Rive Flutter is a runtime library for [Rive](https://rive.app), a real-time interactive design and animation tool.

This library allows you to fully control Rive files with a high-level API for simple interactions and animations, as well as a low-level API for creating custom render loops for multiple artboards, animations, and state machines in a single canvas.

## Table of contents

- :star: [Rive Overview](#rive-overview)
- 🚀 [Getting Started & API docs](#getting-started)
- :mag: [Supported Platforms](#supported-platforms)
- :books: [Examples](#examples)
- 👨‍💻 [Contributing](#contributing)
- :question: [Issues](#issues)

## Overview of Rive

[Rive](https://rive.app) is a powerful tool that helps teams create and run interactive animations for apps, games, and websites. Designers and developers can use the collaborative editor to create motion graphics that respond to different states and user inputs, and then use the lightweight open-source runtime libraries, like Rive Flutter, to load their animations into their projects.

For more information, check out the following resources:

:house_with_garden: [Homepage](https://rive.app/)

:blue_book: [General help docs](https://help.rive.app/)

🛠 [Learning Rive](https://rive.app/learn-rive)

## Getting Started

To get started with Rive Flutter, check out the following resources:
- [Getting Started with Rive in Flutter](https://help.rive.app/runtimes/overview/flutter)

- [Alternative Widget Setup](https://help.rive.app/runtimes/overview/flutter/alternative-widget-setup)

For additional help, see the Runtime sections of the Rive help documentation, such as:
- [Animation Playback](https://help.rive.app/runtimes/playback)
- [State Machines](https://help.rive.app/runtimes/state-machines)

## Supported Platforms

Be sure to read the [platform specific considerations](platform_considerations.md) for the Rive Flutter package.

## Examples

To see some examples of what you can do with Rive Flutter, check out the following projects:

- [Demo app](https://github.com/rive-app/rive-flutter/tree/master/example)
- [Find the Dog (game)](https://github.com/rive-app/find-the-dog)

Here is an example of how to play an animation from a Rive file retrieved over HTTP:

```dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MaterialApp(home: SimpleAnimation()));
}

class SimpleAnimation extends StatelessWidget {
  const SimpleAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/vehicles.riv',
        ),
      ),
    );
  }
}
```

To play an animation from an asset bundle, use:

```dart
RiveAnimation.asset('assets/truck.riv');
```

Control playing and pausing a looping animation:

```dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MaterialApp(home: PlayPauseAnimation()));
}

class PlayPauseAnimation extends StatefulWidget {
  const PlayPauseAnimation({Key? key}) : super(key: key);

  @override
  _PlayPauseAnimationState createState() => _PlayPauseAnimationState();
}

class _PlayPauseAnimationState extends State<PlayPauseAnimation> {
  // Controller for playback
  late RiveAnimationController _controller;

  // Toggles between play and pause animation states
  void _togglePlay() =>
      setState(() => _controller.isActive = !_controller.isActive);

  /// Tracks if the animation is playing by whether controller is running
  bool get isPlaying => _controller.isActive;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('idle');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/vehicles.riv',
          controllers: [_controller],
          // Update the play state when the widget's initialized
          onInit: (_) => setState(() {}),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        tooltip: isPlaying ? 'Pause' : 'Play',
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
```

Play a one-shot animation repeatedly on demand

```dart
/// Demonstrates playing a one-shot animation on demand

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MaterialApp(home: PlayOneShotAnimation()));
}

class PlayOneShotAnimation extends StatefulWidget {
  const PlayOneShotAnimation({Key? key}) : super(key: key);

  @override
  _PlayOneShotAnimationState createState() => _PlayOneShotAnimationState();
}

class _PlayOneShotAnimationState extends State<PlayOneShotAnimation> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Is the animation currently playing?
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      'bounce',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One-Shot Example'),
      ),
      body: Center(
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/vehicles.riv',
          animations: const ['idle', 'curves'],
          controllers: [_controller],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // disable the button while playing the animation
        onPressed: () => _isPlaying ? null : _controller.isActive = true,
        tooltip: 'Play',
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
```

## Contributing

We love contributions and all are welcome! 💙

## Issues

Have an issue with using the runtime, or want to suggest a feature/API to help make your development life better? Log an issue in our [issues](https://github.com/rive-app/flutter/issues) tab! You can also browse older issues and discussion threads there to see solutions that may have worked for common problems.