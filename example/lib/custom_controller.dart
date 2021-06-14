/// Demonstrates how to create a custom controller to change the speed of an
/// animation

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SpeedyAnimation extends StatelessWidget {
  const SpeedyAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Controller'),
      ),
      body: Center(
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/vehicles.riv',
          fit: BoxFit.cover,
          animations: const ['idle'],
          controllers: [SpeedController('curves', speedMultiplier: 3)],
        ),
      ),
    );
  }
}

class SpeedController extends SimpleAnimation {
  final double speedMultiplier;

  /// Stops the animation on the next apply
  bool _stopOnNextApply = false;

  SpeedController(
    String animationName, {
    double mix = 1,
    this.speedMultiplier = 1,
  }) : super(
          animationName,
          mix: mix,
        );

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (_stopOnNextApply || instance == null) {
      isActive = false;
    }

    instance!.animation.apply(instance!.time, coreContext: artboard, mix: mix);
    if (!instance!.advance(elapsedSeconds * speedMultiplier)) {
      _stopOnNextApply = true;
    }
  }

  @override
  void onActivate() => _stopOnNextApply = false;
}
