import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

class ExampleNetworkAsset extends StatefulWidget {
  const ExampleNetworkAsset({super.key});

  @override
  State<ExampleNetworkAsset> createState() => _ExampleNetworkAssetState();
}

class _ExampleNetworkAssetState extends State<ExampleNetworkAsset> {
  late final fileLoader = FileLoader.fromUrl(
    'https://cdn.rive.app/animations/vehicles.riv',
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
