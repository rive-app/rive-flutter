# Rive [![Pub Version](https://img.shields.io/pub/v/rive)](https://pub.dev/packages/rive)

[Flutter package](https://pub.dev/packages/rive) for the new Rive.

## Create and ship interactive animations to any platform

[Rive](https://rive.app/) is a real-time interactive design and animation tool. Use our collaborative editor to create motion graphics that respond to different states and user inputs. Then load your animations into apps, games, and websites with our lightweight open-source runtimes. 

## Add to pubspec.yaml

```yaml
dependencies:
  rive: ^0.7.9
```

## Examples

### Continuously playing a Looping Animation

Here's a simple example of continuously playing a looping animation.

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
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard _riveArtboard;
  RiveAnimationController _controller;
  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/off_road_car.riv').then(
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
            : Rive(artboard: _riveArtboard),
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

## More Info

For an in-depth tutorial on how to use the runtime, check out [this blog post](https://blog.rive.app/rives-flutter-runtime-part-1/).
