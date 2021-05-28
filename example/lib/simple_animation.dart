import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SimpleAnimation extends StatelessWidget {
  const SimpleAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Animation'),
      ),
      body: const Center(
        // child: RiveAnimation.asset('assets/off_road_car.riv'),
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/truck.riv',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
