import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// This is an alternative controller (painter) to use instead of the
/// [RiveWidgetController].
///
/// This painter is used to paint/advance a state machine. Functionally it's
/// very similar to the [RiveWidgetController], which we recommend using for
/// most use cases.
class ExampleSingleAnimationPainter extends StatefulWidget {
  const ExampleSingleAnimationPainter({super.key});

  @override
  State<ExampleSingleAnimationPainter> createState() =>
      _ExampleSingleAnimationPainterState();
}

class _ExampleSingleAnimationPainterState
    extends State<ExampleSingleAnimationPainter> {
  late File file;
  Artboard? artboard;
  late SingleAnimationPainter painter;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    file = (await File.asset(
      'assets/off_road_car.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
    ))!;
    painter = SingleAnimationPainter('idle');
    artboard = file.defaultArtboard();
    setState(() {});
  }

  @override
  void dispose() {
    painter.dispose();
    artboard?.dispose();
    file.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (artboard == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return RiveArtboardWidget(
      artboard: artboard!,
      painter: painter,
    );
  }
}
