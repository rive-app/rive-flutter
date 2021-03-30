import 'package:flutter/material.dart';
import 'package:rive_example/example_animation.dart';
import 'package:rive_example/example_state_machine.dart';

void main() => runApp(MaterialApp(
      title: 'Navigation Basics',
      home: Home(),
    ));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive Examples'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Animation'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ExampleAnimation(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('State Machine'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ExampleStateMachine(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
