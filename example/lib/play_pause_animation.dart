/// Demonstrates how to play and pause a looping animation

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PlayPauseAnimation extends StatefulWidget {
  const PlayPauseAnimation({Key? key}) : super(key: key);

  @override
  State<PlayPauseAnimation> createState() => _PlayPauseAnimationState();
}

class _PlayPauseAnimationState extends State<PlayPauseAnimation> {
  Artboard? _artboard;

  bool get isPlaying => _artboard?.isPlaying ?? true;

  /// Toggles between play and pause on the artboard
  void _togglePlay() {
    if (isPlaying) {
      _artboard?.pause();
    } else {
      _artboard?.play();
    }

    // We call set state to update the Play/Pause Icon. This isn't needed
    // to update Rive.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Example'),
      ),
      body: RiveAnimation.asset(
        'assets/off_road_car.riv',
        animations: const ["idle"],
        fit: BoxFit.cover,
        onInit: (artboard) {
          _artboard = artboard;
        },
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
