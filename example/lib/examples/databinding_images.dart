import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Example using Rive data binding images at runtime.
///
/// See: https://rive.app/docs/dart/data-binding
class ExampleDataBindingImages extends StatefulWidget {
  const ExampleDataBindingImages({super.key});

  @override
  State<ExampleDataBindingImages> createState() => _ExampleBasicState();
}

class _ExampleBasicState extends State<ExampleDataBindingImages> {
  late ViewModelInstance viewModelInstance;
  FileLoader fileLoader = FileLoader.fromAsset(
    'assets/databinding_images.riv',
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  Future<Uint8List> loadBundleAsset(int index) async {
    final ByteData data =
        await rootBundle.load('assets/images/databound_image_$index.jpg');
    return data.buffer.asUint8List();
  }

  Future<void> _clearImage() async {
    final imageProperty = viewModelInstance.image('bound_image')!;
    imageProperty.value = null;
    setState(() {});
  }

  Future<void> _swapImage(int index) async {
    final imageProperty = viewModelInstance.image('bound_image')!;
    final bytes = await loadBundleAsset(index);
    final renderImage =
        await RiveExampleApp.getCurrentFactory.decodeImage(bytes);
    if (renderImage != null) {
      imageProperty.value = renderImage;
    }
    setState(() {});
  }

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
          child: RiveWidgetBuilder(
            fileLoader: fileLoader,
            dataBind: DataBind.auto(),
            onLoaded: (state) {
              viewModelInstance = state.viewModelInstance!;
            },
            builder: (context, state) => switch (state) {
              RiveLoading() => const Center(child: CircularProgressIndicator()),
              RiveFailed() => ErrorWidget.withDetails(
                  message: state.error.toString(),
                  error: FlutterError(state.error.toString()),
                ),
              RiveLoaded() => RiveWidget(controller: state.controller),
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _clearImage,
                child: const Text('Clear image'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _swapImage(1);
                },
                child: const Text('Swap image 1'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _swapImage(2);
                },
                child: const Text('Swap image 2'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
