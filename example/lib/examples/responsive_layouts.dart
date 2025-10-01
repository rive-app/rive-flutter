import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

class ExampleResponsiveLayouts extends StatefulWidget {
  const ExampleResponsiveLayouts({super.key});

  @override
  State<ExampleResponsiveLayouts> createState() =>
      _ExampleResponsiveLayoutsState();
}

class _ExampleResponsiveLayoutsState extends State<ExampleResponsiveLayouts> {
  late ViewModelInstance viewModelInstance;

  late final fileLoader = FileLoader.fromAsset(
    'assets/layout_test.riv',
    // Choose which renderer to use
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  @override
  void dispose() {
    // This widget state owns the file loader, dispose it.
    fileLoader.dispose();
    viewModelInstance.dispose();
    super.dispose();
  }

  void _onLoaded(RiveLoaded state) {
    viewModelInstance = state.controller.dataBind(DataBind.auto());
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: fileLoader,
      onLoaded: _onLoaded,
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
            fit: Fit.layout, // pass Fit.layout to use Rive's layout system
            layoutScaleFactor: 1 / 2, // Optionally: scale the layout
          )
      },
    );
  }
}
