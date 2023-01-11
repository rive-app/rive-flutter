import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Basic example playing a Rive animation from a packaged asset.
class SimpleAssetAnimation extends StatelessWidget {
  const SimpleAssetAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Animation'),
      ),
      body: const Center(
        child: RiveAnimation.asset(
          'assets/off_road_car.riv',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
