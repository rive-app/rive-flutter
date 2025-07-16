// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/colors.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Example using Rive data binding images at runtime.
///
/// See: https://rive.app/docs/runtimes/data-binding
class ExampleDataBindingImages extends StatefulWidget {
  const ExampleDataBindingImages({super.key});

  @override
  State<ExampleDataBindingImages> createState() =>
      _ExampleDataBindingImagesState();
}

class _ExampleDataBindingImagesState extends State<ExampleDataBindingImages> {
  late ViewModelInstance viewModelInstance;
  late ViewModelInstanceAssetImage imageProperty;

  FileLoader fileLoader = FileLoader.fromAsset(
    'assets/ball_elements.riv',
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  int selectedImageIndex = 0;
  final Map<String, Uint8List> _imageCache = {};

  final List<String> images = [
    'Basketball.webp',
    'Beach ball.webp',
    'Coffee.webp',
    'Cola.webp',
    'Cookie.webp',
    'Donut.webp',
    'Earth.webp',
    'Egg.webp',
    'Football.webp',
    'Paper.webp',
    'Pizza.webp',
    'Vinyl record.webp',
  ];

  @override
  void initState() {
    super.initState();
    _loadAllImages();
  }

  Future<void> _loadAllImages() async {
    for (String imageName in images) {
      try {
        final bytes = await loadBundleAsset(imageName);
        _imageCache[imageName] = bytes;
      } catch (e) {
        debugPrint('Failed to load image: $imageName - $e');
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<Uint8List> loadBundleAsset(String name) async {
    final ByteData data = await rootBundle.load('assets/images/$name');
    return data.buffer.asUint8List();
  }

  Future<void> _swapImage(int index) async {
    if (index >= 0 && index < images.length) {
      final imageName = images[index];
      final cachedBytes = _imageCache[imageName];

      if (cachedBytes != null) {
        final renderImage =
            await RiveExampleApp.getCurrentFactory.decodeImage(cachedBytes);
        if (renderImage != null) {
          imageProperty.value = renderImage;
          setState(() {
            selectedImageIndex = index;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    fileLoader.dispose();
    imageProperty.dispose();
    super.dispose();
  }

  Widget _buildImageCarousel() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedImageIndex;
          final imageName = images[index];
          final cachedBytes = _imageCache[imageName];

          return GestureDetector(
            onTap: () => _swapImage(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey[300]!,
                  width: isSelected ? 1.5 : 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: cachedBytes != null
                    ? Image.memory(
                        cachedBytes,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text('Tap the image!!'),
          ),
        ),
        Expanded(
          child: RiveWidgetBuilder(
            fileLoader: fileLoader,
            dataBind: DataBind.auto(),
            onLoaded: (state) {
              viewModelInstance = state.viewModelInstance!;
              imageProperty = viewModelInstance.image('ball_image')!;
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              imageProperty.value = null;
              setState(() {});
            },
            child: const Text('Clear image'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Select an image'),
        ),
        _buildImageCarousel(),
      ],
    );
  }
}
