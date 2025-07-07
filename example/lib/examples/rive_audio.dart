import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart';

/// An example showing Rive Audio working with the Rive Widget.
///
/// There is nothing special that needs to be done to get audio working at
/// runtime.
///
/// See: https://rive.app/docs/editor/events/audio-events
class ExampleRiveAudio extends StatefulWidget {
  const ExampleRiveAudio({super.key});

  @override
  State<ExampleRiveAudio> createState() => _ExampleRiveAudioState();
}

class _ExampleRiveAudioState extends State<ExampleRiveAudio> {
  late final fileLoader = FileLoader.fromAsset('assets/lip-sync.riv',
      riveFactory: RiveExampleApp.getCurrentFactory);

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
      artboardSelector: ArtboardSelector.byName('Lip_sync_2'),
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
