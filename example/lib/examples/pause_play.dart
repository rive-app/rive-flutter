import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

class ExamplePausePlay extends StatefulWidget {
  const ExamplePausePlay({super.key});

  @override
  State<ExamplePausePlay> createState() => _ExamplePausePlayState();
}

class _ExamplePausePlayState extends State<ExamplePausePlay> {
  final fileLoader = FileLoader.fromAsset(
    'assets/rewards.riv',
    riveFactory: RiveExampleApp.getCurrentFactory,
  );
  late RiveWidgetController controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      controller.active = isPlaying;
    });
  }

  @override
  void dispose() {
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: RiveWidgetBuilder(
            fileLoader: fileLoader,
            dataBind: DataBind.auto(),
            onLoaded: (state) {
              controller = state.controller;
              controller.active = isPlaying;
            },
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: togglePlayPause,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(isPlaying ? 'Pause' : 'Play'),
          ),
        ),
      ],
    );
  }
}
