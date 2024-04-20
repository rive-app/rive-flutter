import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveAudioExample extends StatelessWidget {
  const RiveAudioExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive Audio'),
      ),
      body: const RiveAnimation.asset(
        "assets/lip-sync.riv",
        artboard: 'Lip_sync_2',
        stateMachines: ['State Machine 1'],
      ),
    );
  }
}
