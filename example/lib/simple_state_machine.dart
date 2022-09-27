import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SimpleStateMachine extends StatefulWidget {
  const SimpleStateMachine({Key? key}) : super(key: key);

  @override
  _SimpleStateMachineState createState() => _SimpleStateMachineState();
}

class _SimpleStateMachineState extends State<SimpleStateMachine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Animation'),
      ),
      body: Center(
        child: ListView(
          children: const [
            SizedBox(
              width: 500,
              height: 500,
              child: RiveAnimation.asset(
                'assets/simple.riv',
                stateMachines: ["State Machine 1"],
              ),
            ),
            SizedBox(height: 2000, width: 500, child: Text("hi")),
            SizedBox(height: 2000, width: 500, child: Text("bye"))
          ],
        ),
      ),
    );
  }
}
