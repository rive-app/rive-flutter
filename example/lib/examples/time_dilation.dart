import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

class ExampleTimeDilation extends StatefulWidget {
  const ExampleTimeDilation({super.key});

  @override
  State<ExampleTimeDilation> createState() => _ExampleTimeDilationState();
}

class _ExampleTimeDilationState extends State<ExampleTimeDilation> {
  FileLoader fileLoader = FileLoader.fromAsset(
    'assets/little_machine.riv',
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  @override
  void dispose() {
    fileLoader.dispose();
    timeDilation = 1; // reset time dilation to normal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 5; // 5x slower than normal
    return RiveWidgetBuilder(
      fileLoader: fileLoader,
      builder: (context, state) => switch (state) {
        RiveLoading() => const Center(
            child: Center(child: CircularProgressIndicator()),
          ),
        RiveFailed() => ErrorWidget.withDetails(
            message: state.error.toString(),
            error: FlutterError(state.error.toString()),
          ),
        RiveLoaded() => RiveWidget(controller: state.controller)
      },
    );
  }
}
