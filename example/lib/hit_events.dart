import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class HitEventExample extends StatelessWidget {
  const HitEventExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hit Events'),
      ),
      body: const Center(
        child: RiveAnimation.asset(
          'assets/cannon.riv',
          fit: BoxFit.cover,
          stateMachines: ['State Machine 1'],
        ),
      ),
    );
  }
}
