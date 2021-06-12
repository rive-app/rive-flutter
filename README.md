# Rive [![Pub Version](https://img.shields.io/pub/v/rive)](https://pub.dev/packages/rive)

Runtime docs are available in [Rive's help center](https://help.rive.app/runtimes/quick-start).

[Rive](https://rive.app/) is a real-time interactive design and animation tool. Use our collaborative editor to create motion graphics that respond to different states and user inputs. Then load your animations into apps, games, and websites with our lightweight open-source runtimes. 

## Add to pubspec.yaml

```yaml
dependencies:
  rive: ^0.7.17
```

## Quick Start

Play an animation from a Rive file over HTTP:

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

For more info on using the Rive package, check out the [runtime help center docs](https://help.rive.app/runtimes).

## Examples

### Controlling animation playback

Here's a simple example of showing how to control animation playback using the `Rive` widget and `RiveAnimationController`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Artboard? _riveArtboard;
  RiveAnimationController? _controller;

  /// Toggles playing/pausing the animation
  void _togglePlay() {
    if (_controller != null) {
      setState(() => _controller!.isActive = !_controller!.isActive);
    }
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/truck.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(_controller = SimpleAnimation('idle'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : Rive(artboard: _riveArtboard!),
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

Check out the full [example](example).

### Playing a one-shot animation

Rive's ```SimpleAnimation``` will automatically play a looping or ping-pong animation repeatedly, but will play a one-shot animation only once. To determine when a one-shot has completed playing, subscribe to the controller's ```isActiveChanged``` listenable:

```dart
// Listen for changes to the controller to know when an animation has
// started or stopped playing
_controller.isActiveChanged.addListener(() {
  if (_controller.isActive) {
    print('Animation started playing');
  } else {
    print('Animation stopped playing');
  }
}
```

## Antialiasing

If you want to disable antialiasing (usually for performance reasons), you can set `antialiasing` to `false` on the `Rive` and `RiveAnimation` widgets.
