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
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/vehicles.riv',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
