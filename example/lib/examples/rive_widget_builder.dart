import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

class ExampleRiveWidgetBuilder extends StatefulWidget {
  const ExampleRiveWidgetBuilder({super.key});

  @override
  State<ExampleRiveWidgetBuilder> createState() =>
      _ExampleRiveWidgetBuilderState();
}

class _ExampleRiveWidgetBuilderState extends State<ExampleRiveWidgetBuilder> {
  late final fileLoader = FileLoader.fromAsset(
    'assets/rewards.riv',
    // Choose which renderer to use
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  @override
  void dispose() {
    // This widget state owns the file loader, dispose it.
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: fileLoader,
      dataBind: DataBind.auto(),
      // Optional `onFailed` callback to handle loading errors
      onFailed: (error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
      },
      // Optional `onLoaded` callback to access the loaded state
      onLoaded: (state) {
        debugPrint('Rive loaded');
      },
      // Optionally specify the controller to create
      // controller: (file) => RiveWidgetController(file),
      builder: (context, state) => switch (state) {
        RiveLoading() => const Center(
            child: Center(child: CircularProgressIndicator()),
          ),
        RiveFailed() => ErrorWidget.withDetails(
            message: state.error.toString(),
            error: FlutterError(state.error.toString()),
          ),
        RiveLoaded() => RiveWidget(
            controller: state.controller,
            fit: Fit.layout,
            layoutScaleFactor: 1 / 3,
          )
      },
    );
  }
}
