import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// An example showing how to drive a StateMachine via one numeric input.
class AnimationCarousel extends StatefulWidget {
  const AnimationCarousel({Key? key}) : super(key: key);

  @override
  State<AnimationCarousel> createState() => _AnimationCarouselState();
}

class _AnimationCarouselState extends State<AnimationCarousel> {
  final riveAnimations = [
    const RiveCustomAnimationData(
      name: 'assets/liquid_download.riv',
    ),
    const RiveCustomAnimationData(
      name: 'assets/little_machine.riv',
      stateMachines: ['State Machine 1'],
    ),
    const RiveCustomAnimationData(
      name: 'assets/off_road_car.riv',
    ),
    const RiveCustomAnimationData(
      name: 'assets/rocket.riv',
      stateMachines: ['Button'],
      animations: ['Roll_over'],
    ),
    const RiveCustomAnimationData(
      name: 'assets/skills.riv',
      stateMachines: ['Designer\'s Test'],
    ),
    // not a pretty out of the box example
    const RiveCustomAnimationData(
      name: 'assets/light_switch.riv',
      stateMachines: ['Switch'],
    ),
    // v6.0 file,
    // 'assets/teeny_tiny.riv',
    // const RiveCustomAnimationData(name: 'assets/teeny_tiny.riv'),
  ];

  var _index = 0;
  void next() {
    setState(() {
      _index += 1;
    });
  }

  void previous() {
    setState(() {
      _index -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final indexToShow = _index % riveAnimations.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Carousel'),
      ),
      body: Center(
        child: Row(
          children: [
            GestureDetector(
              onTap: previous,
              child: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: RiveAnimation.asset(
                riveAnimations[indexToShow].name,
                animations: riveAnimations[indexToShow].animations,
                stateMachines: riveAnimations[indexToShow].stateMachines,
              ),
            ),
            GestureDetector(
              onTap: next,
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class RiveCustomAnimationData {
  final String name;
  final List<String> animations;
  final List<String> stateMachines;

  const RiveCustomAnimationData({
    required this.name,
    this.animations = const [],
    this.stateMachines = const [],
  });
}
