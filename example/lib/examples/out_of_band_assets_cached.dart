import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// An example showing how to load image or font assets dynamically.
///
/// In this example there is no delay in the assets loading, as they are
/// cached in memory.
///
/// The example also shows how to swap out the assets multiple times by
/// keeping a reference to the asset and swapping it out.
///
/// Note that this swaps out the image/font on the Rive File instance. All
/// artboards created from this file will use the same asset reference. Meaning
/// that if you swap out the image/font on the Rive File instance, all
/// artboards created from this file will use the new asset reference.
///
/// See: https://rive.app/docs/runtimes/loading-assets
class ExampleOutOfBandCachedAssetLoading extends StatefulWidget {
  const ExampleOutOfBandCachedAssetLoading({Key? key}) : super(key: key);

  @override
  State<ExampleOutOfBandCachedAssetLoading> createState() =>
      _ExampleOutOfBandCachedAssetLoadingState();
}

class _ExampleOutOfBandCachedAssetLoadingState
    extends State<ExampleOutOfBandCachedAssetLoading> {
  var _index = 0;
  var _ready = false;
  final _imageCache = <RenderImage>[];
  final _fontCache = <Font>[];

  @override
  void initState() {
    super.initState();
    _warmUpCache();
  }

  /// Create a cache of images and fonts to swap out instantly.
  Future<void> _warmUpCache() async {
    final futures = <Future>[];
    loadImage() async {
      final res = await http.get(Uri.parse('https://picsum.photos/500/500'));
      final body = Uint8List.view(res.bodyBytes.buffer);
      final image = await RiveExampleApp.getCurrentFactory.decodeImage(body);
      if (image != null) {
        _imageCache.add(image);
      }
    }

    loadFont(url) async {
      final res = await http.get(Uri.parse(url));
      final body = Uint8List.view(res.bodyBytes.buffer);
      final font = await RiveExampleApp.getCurrentFactory.decodeFont(body);

      if (font != null) {
        _fontCache.add(font);
      }
    }

    for (var i = 0; i <= 10; i++) {
      futures.add(loadImage());
    }

    for (var url in [
      'https://cdn.rive.app/runtime/flutter/IndieFlower-Regular.ttf',
      'https://cdn.rive.app/runtime/flutter/comic-neue.ttf',
      'https://cdn.rive.app/runtime/flutter/inter.ttf',
      'https://cdn.rive.app/runtime/flutter/inter-tight.ttf',
      'https://cdn.rive.app/runtime/flutter/josefin-sans.ttf',
      'https://cdn.rive.app/runtime/flutter/send-flowers.ttf',
    ]) {
      futures.add(loadFont(url));
    }

    await Future.wait(futures);

    if (mounted) {
      setState(() => _ready = true);
    }
  }

  void next() {
    setState(() => _index += 1);
  }

  void previous() {
    setState(() => _index -= 1);
  }

  @override
  void dispose() {
    for (var image in _imageCache) {
      image.dispose();
    }
    for (var font in _fontCache) {
      font.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Warming up cache. Loading files from network...'),
            ),
            CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ],
        ),
      );
    }

    return Center(
      child: Row(
        children: [
          GestureDetector(
            onTap: previous,
            child: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: (_index % 2 == 0)
                ? _RiveRandomCachedImage(imageCache: _imageCache)
                : _RiveRandomCachedFont(fontCache: _fontCache),
          ),
          GestureDetector(
            onTap: next,
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

class _RiveRandomCachedImage extends StatefulWidget {
  const _RiveRandomCachedImage({
    Key? key,
    required this.imageCache,
  }) : super(key: key);

  final List imageCache;

  @override
  State<_RiveRandomCachedImage> createState() => __RiveRandomCachedImageState();
}

class __RiveRandomCachedImageState extends State<_RiveRandomCachedImage> {
  List get _imageCache => widget.imageCache;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  File? _riveImageSampleFile;
  RiveWidgetController? _controller;
  // A reference to the Rive image. Can be use to swap out the image at any
  // point.
  ImageAsset? _imageAsset;

  Future<void> _loadRiveFile() async {
    final imageFile = await File.asset(
      'assets/image_out_of_band.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
      assetLoader: (asset, bytes) {
        if (asset is ImageAsset) {
          asset.renderImage(_imageCache[Random().nextInt(_imageCache.length)]);
          // Maintain a reference to the image asset
          // so we can swap it out later instantly.
          _imageAsset = asset;
          return true;
        }
        return false;
      },
    );

    if (mounted) {
      setState(() {
        _riveImageSampleFile = imageFile;
        _controller = RiveWidgetController(_riveImageSampleFile!);
      });
    }
  }

  @override
  void dispose() {
    _imageAsset?.dispose();
    _riveImageSampleFile?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              RiveWidget(
                controller: _controller!,
                fit: Fit.cover,
              ),
              const Positioned(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'This example caches images and swaps them out instantly.\n\nHover to zoom.',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              _imageAsset?.renderImage(
                  _imageCache[Random().nextInt(_imageCache.length)]);
              setState(() {
                // force rebuild for Rive widget to update the image
              });
            },
            child: const Text('Random image'),
          ),
        ),
      ],
    );
  }
}

class _RiveRandomCachedFont extends StatefulWidget {
  const _RiveRandomCachedFont({
    Key? key,
    required this.fontCache,
  }) : super(key: key);

  final List fontCache;

  @override
  State<_RiveRandomCachedFont> createState() => __RiveRandomCachedFontState();
}

class __RiveRandomCachedFontState extends State<_RiveRandomCachedFont> {
  List get _fontCache => widget.fontCache;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  File? _riveFontSampleFile;
  RiveWidgetController? _controller;
  final List<FontAsset?> _fontAssets = [];

  Future<void> _loadRiveFile() async {
    final fontFile = await File.asset(
      'assets/acqua_text_out_of_band.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
      assetLoader: (asset, bytes) {
        if (asset is FontAsset) {
          asset.font(_fontCache[Random().nextInt(_fontCache.length)]);
          _fontAssets.add(asset);
          return true;
        }
        return false;
      },
    );

    if (mounted) {
      setState(() {
        _riveFontSampleFile = fontFile;
        _controller = RiveWidgetController(_riveFontSampleFile!);
      });
    }
  }

  @override
  void dispose() {
    for (var element in _fontAssets) {
      element?.dispose();
    }
    _riveFontSampleFile?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              RiveWidget(
                controller: _controller!,
                fit: Fit.cover,
              ),
              const Positioned(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'This example caches fonts and swaps them out instantly.\n\nClick to change drink.',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              for (var element in _fontAssets) {
                element?.font(_fontCache[Random().nextInt(_fontCache.length)]);
                setState(() {
                  // force rebuild for Rive widget to update the image
                });
              }
            },
            child: const Text('Random font'),
          ),
        ),
      ],
    );
  }
}
