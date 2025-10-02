import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

class ExampleMultiTouch extends StatefulWidget {
  const ExampleMultiTouch({super.key});

  @override
  State<ExampleMultiTouch> createState() => _ExampleMultiTouchState();
}

class _ExampleMultiTouchState extends State<ExampleMultiTouch> {
  FileLoader fileLoader = FileLoader.fromAsset(
    'assets/multitouch.riv',
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  @override
  void dispose() {
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: fileLoader,
      dataBind: DataBind.auto(),
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
