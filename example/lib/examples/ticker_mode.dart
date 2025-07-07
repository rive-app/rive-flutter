import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

class ExampleTickerMode extends StatefulWidget {
  const ExampleTickerMode({super.key});

  @override
  State<ExampleTickerMode> createState() => _ExampleTickerModeState();
}

class _ExampleTickerModeState extends State<ExampleTickerMode> {
  FileLoader fileLoader = FileLoader.fromAsset(
    'assets/little_machine.riv',
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  var tickerMode = false;

  @override
  void dispose() {
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TickerMode(
            enabled: tickerMode,
            child: RiveWidgetBuilder(
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
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: tickerMode
                ? const Text('Ticker mode enabled')
                : const Text('Ticker mode disabled')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                tickerMode = !tickerMode;
              });
            },
            child: const Text('Toggle ticker mode'),
          ),
        )
      ],
    );
  }
}
