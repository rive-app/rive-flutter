import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// We strongly recommend using Data Binding instead of updating text runs
/// manually. See: https://rive.app/docs/runtimes/data-binding
///
/// An example showing how to read and update text runs at runtime.
/// See: https://rive.app/docs/runtimes/text
class ExampleTextRuns extends StatefulWidget {
  const ExampleTextRuns({super.key});

  @override
  State<ExampleTextRuns> createState() => _ExampleTextRunsState();
}

class _ExampleTextRunsState extends State<ExampleTextRuns> {
  File? _riveFile;
  RiveWidgetController? _controller;

  Future<void> _init() async {
    _riveFile = await File.asset(
      'assets/electrified_button_nested_text.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
      assetLoader: (asset, bytes) {
        if (asset is FontAsset) {
          _loadFont(asset);
          return true;
        }
        return false;
      },
    );
    _controller = RiveWidgetController(
      _riveFile!,
      artboardSelector: ArtboardSelector.byName('Button'),
      stateMachineSelector: StateMachineSelector.byName('button'),
    );

    // Read/update text runs
    // You can access nested text runs by providing an optional path
    final initialText =
        _controller?.artboard.getText('button_text', path: null);
    debugPrint('Initial text: $initialText');
    _controller?.artboard.setText('button_text', 'Hello, world!');
    final updatedText = _controller?.artboard.getText('button_text');
    debugPrint('Updated text: $updatedText');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _riveFile?.dispose();
    super.dispose();
  }

  // This example has the font asset external from the Rive file, and we're
  // loading it manually. If you embedded the font in the Rive file, you can
  // skip this step.
  //
  // See: https://rive.app/docs/runtimes/loading-assets
  Future<void> _loadFont(FontAsset asset) async {
    final bytes = await rootBundle.load('assets/fonts/Inter-Regular.ttf');
    final font = await RiveExampleApp.getCurrentFactory
        .decodeFont(bytes.buffer.asUint8List());
    if (font != null && mounted) {
      asset.font(font);
      font.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _riveFile == null
          ? const SizedBox()
          : RiveWidget(controller: _controller!),
    );
  }
}
