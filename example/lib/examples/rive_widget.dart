import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

class ExampleRiveWidget extends StatefulWidget {
  const ExampleRiveWidget({super.key});

  @override
  State<ExampleRiveWidget> createState() => _ExampleRiveWidgetState();
}

class _ExampleRiveWidgetState extends State<ExampleRiveWidget> {
  late File file;
  late RiveWidgetController controller;
  late ViewModelInstance viewModelInstance;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() async {
    file = (await File.asset(
      'assets/rewards.riv',
      // Choose which renderer to use
      riveFactory: RiveExampleApp.getCurrentFactory,
    ))!;
    controller = RiveWidgetController(file);
    // The controller binds automatically at construction (defaults for the
    // main and every global view model slot).
    viewModelInstance = controller.viewModelInstance!;
    setState(() => isInitialized = true);
  }

  @override
  void dispose() {
    // This widget state created the file and controller. The bound view
    // model instance belongs to the controller and is disposed with it.
    file.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return RiveWidget(
      controller: controller,
      fit: Fit.layout,
      layoutScaleFactor: 1 / 3,
    );
  }
}
