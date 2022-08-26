import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// An example showing how to drive a StateMachine via one numeric input.
class AnimationCarousel extends StatefulWidget {
  const AnimationCarousel({Key? key}) : super(key: key);

  @override
  _AnimationCarouselState createState() => _AnimationCarouselState();
}

class _AnimationCarouselState extends State<AnimationCarousel> {
  final riveFiles = [
    'assets/liquid_download.riv',
    'assets/little_machine.riv',
    'assets/off_road_car.riv',
    'assets/rocket.riv',
    'assets/skills.riv',
    // not a pretty out of the box example
    'assets/light_switch.riv',
    // v6.0 file,
    // 'assets/teeny_tiny.riv',
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
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Animation Carousel'),
      ),
      body: Center(
          child: Row(children: [
        GestureDetector(
            onTap: previous,
            child: const Icon(
              Icons.arrow_back,
            )),
        Expanded(
            child: RiveAnimation.asset(
          riveFiles[_index % riveFiles.length],
        )),
        GestureDetector(
            onTap: next,
            child: const Icon(
              Icons.arrow_forward,
            )),
      ])),
    );
  }
}
