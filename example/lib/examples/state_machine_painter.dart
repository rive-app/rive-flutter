import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive_example/main.dart' show RiveExampleApp;

/// This is an alternative controller (painter) to use instead of the
/// [RiveWidgetController].
///
/// This painter is used to paint/advance a state machine. Functionally it's
/// very similar to the [RiveWidgetController], which we recommend using for
/// most use cases.
class ExampleStateMachinePainter extends StatefulWidget {
  const ExampleStateMachinePainter({super.key});

  @override
  State<ExampleStateMachinePainter> createState() =>
      _ExampleStateMachinePainterState();
}

class _ExampleStateMachinePainterState
    extends State<ExampleStateMachinePainter> {
  late rive.File file;
  rive.Artboard? artboard;
  rive.ViewModelInstance? viewModelInstance;
  late rive.StateMachinePainter painter;

  @override
  void initState() {
    super.initState();
    init();
  }

  void _withStateMachine(rive.StateMachine stateMachine) {
    stateMachine.bindViewModelInstance(viewModelInstance!);
  }

  void init() async {
    file = (await rive.File.asset(
      'assets/rewards.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
    ))!;
    painter = rive.StateMachinePainter(withStateMachine: _withStateMachine);
    artboard = file.defaultArtboard();
    viewModelInstance =
        file.defaultArtboardViewModel(artboard!)!.createDefaultInstance();
    setState(() {});
  }

  @override
  void dispose() {
    painter.dispose();
    artboard?.dispose();
    viewModelInstance?.dispose();
    file.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (artboard == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return rive.RiveArtboardWidget(
      artboard: artboard!,
      painter: painter,
    );
  }
}
