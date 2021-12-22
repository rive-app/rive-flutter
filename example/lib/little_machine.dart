import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

/// An example showing how to drive a StateMachine via a trigger input.
class LittleMachine extends StatefulWidget {
  const LittleMachine({Key? key}) : super(key: key);

  @override
  _LittleMachineState createState() => _LittleMachineState();
}

class _LittleMachineState extends State<LittleMachine> {
  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  /// Message that displays when state has changed
  String stateChangeMessage = '';

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _trigger;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/little_machine.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(
          artboard,
          'State Machine 1',
          onStateChange: _onStateChange,
        );
        if (controller != null) {
          artboard.addController(controller);
          _trigger = controller.findInput('Trigger 1');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  /// Do something when the state machine changes state
  void _onStateChange(String stateMachineName, String stateName) => setState(
        () => stateChangeMessage =
            'State Changed in $stateMachineName to $stateName',
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Little Machine'),
      ),
      body: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : GestureDetector(
                onTapDown: (_) => _trigger?.value = true,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Press to activate!',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Rive(
                        artboard: _riveArtboard!,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('$stateChangeMessage'),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    );
  }
}
