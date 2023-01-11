import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Basic example playing a Rive animation from a network asset.
class SimpleNetworkAnimation extends StatelessWidget {
  const SimpleNetworkAnimation({Key? key}) : super(key: key);

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
          placeHolder: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
