import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// An example showing how to drive a StateMachine via one numeric input.
class ArtboardNestedInputs extends StatefulWidget {
  const ArtboardNestedInputs({Key? key}) : super(key: key);

  @override
  State<ArtboardNestedInputs> createState() => _ArtboardNestedInputsState();
}

class _ArtboardNestedInputsState extends State<ArtboardNestedInputs> {
  Artboard? _riveArtboard;
  SMIBool? _circleOuterState;
  SMIBool? _circleInnerState;

  @override
  void initState() {
    super.initState();

    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    final file = await RiveFile.asset('assets/runtime_nested_inputs.riv');

    // The artboard is the root of the animation and gets drawn in the
    // Rive widget.
    final artboard = file.artboardByName("MainArtboard")!.instance();
    var controller =
        StateMachineController.fromArtboard(artboard, 'MainStateMachine');
    // Get the nested input CircleOuterState in the nested artboard CircleOuter
    _circleOuterState =
        artboard.getBoolInput("CircleOuterState", "CircleOuter");
    // Get the nested input CircleInnerState at the nested artboard path
    // -> CircleOuter
    //    -> CircleInner
    _circleInnerState =
        artboard.getBoolInput("CircleInnerState", "CircleOuter/CircleInner");
    if (controller != null) {
      artboard.addController(controller);
    }
    setState(() => _riveArtboard = artboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nested Inputs'),
      ),
      body: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : Stack(
                children: [
                  Positioned.fill(
                    child: Rive(
                      artboard: _riveArtboard!,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned.fill(
                    bottom: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: const Text('Outer Circle'),
                          onPressed: () {
                            if (_circleOuterState != null) {
                              _circleOuterState!.value =
                                  !_circleOuterState!.value;
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          child: const Text('Inner Circle'),
                          onPressed: () {
                            if (_circleInnerState != null) {
                              _circleInnerState!.value =
                                  !_circleInnerState!.value;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
