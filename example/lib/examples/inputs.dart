import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// We strongly recommend using Data Binding instead of Rive Inputs for better
/// runtime control. See: https://rive.app/docs/runtimes/data-binding
///
/// An example showing how to drive a StateMachine via one numeric input.
/// Triggers and boolean inputs can be driven in a similar way.
///
/// See: https://rive.app/docs/runtimes/inputs
class ExampleInputs extends StatefulWidget {
  const ExampleInputs({Key? key}) : super(key: key);

  @override
  State<ExampleInputs> createState() => _ExampleInputsState();
}

class _ExampleInputsState extends State<ExampleInputs> {
  File? _riveFile;
  RiveWidgetController? _controller;
  NumberInput? _levelInput;

  Future<void> _loadRiveFile() async {
    _riveFile = await File.asset(
      'assets/skills.riv',
      riveFactory: Factory.rive,
    );
    // You can access nested inputs by providing an optional path to the input
    _controller = RiveWidgetController(_riveFile!);
    _levelInput = _controller?.stateMachine.number('Level', path: null);
    /* EXAMPLE BOOLEAN INPUT API */
    // var boolInput = _controller?.stateMachine.boolean('some_bool');
    // boolInput?.value = true;
    /* EXAMPLE TRIGGER INPUT API */
    // var triggerInput = _controller?.stateMachine.trigger('some_trigger');
    // triggerInput?.fire();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  @override
  void dispose() {
    _levelInput?.dispose();
    _controller?.dispose();
    _riveFile?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _riveFile == null
          ? const SizedBox()
          : Stack(
              children: [
                Positioned.fill(
                  child: RiveWidget(
                    controller: _controller!,
                  ),
                ),
                Positioned.fill(
                  bottom: 32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: const Text('Beginner'),
                        onPressed: () => _levelInput?.value = 0,
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        child: const Text('Intermediate'),
                        onPressed: () => _levelInput?.value = 1,
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        child: const Text('Expert'),
                        onPressed: () => _levelInput?.value = 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
