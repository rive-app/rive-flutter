import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class StateMachineAction extends StatefulWidget {
  const StateMachineAction({Key? key}) : super(key: key);

  @override
  _StateMachineActionState createState() => _StateMachineActionState();
}

class _StateMachineActionState extends State<StateMachineAction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Light Switch'),
      ),
      body: const Center(
        child: RiveAnimation.asset(
          'assets/light_switch.riv',
          fit: BoxFit.contain,
          stateMachines: ['Switch'],
        ),
      ),
    );
  }
}
