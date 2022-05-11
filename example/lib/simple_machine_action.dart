import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class StateMachineAction extends StatefulWidget {
  const StateMachineAction({Key? key}) : super(key: key);

  @override
  _StateMachineActionState createState() => _StateMachineActionState();
}

class _StateMachineActionState extends State<StateMachineAction> {
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'Switch');
    artboard.addController(controller!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Light Switch'),
      ),
      body: Center(
        child: RiveAnimation.asset(
          'assets/light_switch.riv',
          fit: BoxFit.contain,
          onInit: _onRiveInit,
        ),
      ),
    );
  }
}
