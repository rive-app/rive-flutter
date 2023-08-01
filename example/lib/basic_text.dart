import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Basic example playing a Rive animation from a packaged asset.
class BasicText extends StatelessWidget {
  const BasicText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Text'),
      ),
      body: const Center(
        child: RiveAnimation.asset(
          'assets/text_flutter.riv',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
