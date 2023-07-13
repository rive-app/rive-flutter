import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;

/// An example showing how to load image or font assets dynamically.
///
/// In this example you'll note that there is a delay in the assets
/// loading/refreshing when you tap the back/forward buttons.
/// This is because the assets are being loaded asynchronously.
/// If you want to avoid this delay you can cache the assets in memory
/// and provide them instantly.
///
/// See `custom_cached_asset_loading.dart` for an example of this.
class CustomAssetLoading extends StatefulWidget {
  const CustomAssetLoading({Key? key}) : super(key: key);

  @override
  State<CustomAssetLoading> createState() => _CustomAssetLoadingState();
}

class _CustomAssetLoadingState extends State<CustomAssetLoading> {
  var _index = 0;
  void next() => setState(() {
        _index += 1;
      });

  void previous() => setState(() {
        _index -= 1;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Asset Loading'),
      ),
      body: Center(
        child: Row(
          children: [
            GestureDetector(
              onTap: previous,
              child: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: (_index % 2 == 0)
                  ? const _RiveRandomImage()
                  : const _RiveRandomFont(),
            ),
            GestureDetector(
              onTap: next,
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loads a random image as an asset.
class _RiveRandomImage extends StatefulWidget {
  const _RiveRandomImage();

  @override
  State<_RiveRandomImage> createState() => _RiveRandomImageState();
}

class _RiveRandomImageState extends State<_RiveRandomImage> {
  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  RiveFile? _riveImageSampleFile;

  Future<void> _loadFiles() async {
    final imageFile = await RiveFile.asset(
      'assets/asset.riv',
      loadEmbeddedAssets: false,
      assetLoader: CallbackAssetLoader(
        (asset) async {
          final res =
              await http.get(Uri.parse('https://picsum.photos/1000/1000'));
          await asset.decode(Uint8List.view(res.bodyBytes.buffer));
          return true;
        },
      ),
    );

    setState(() {
      _riveImageSampleFile = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_riveImageSampleFile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RiveAnimation.direct(
      _riveImageSampleFile!,
      fit: BoxFit.cover,
    );
  }
}

/// Loads a random font as an asset.
class _RiveRandomFont extends StatefulWidget {
  const _RiveRandomFont();

  @override
  State<_RiveRandomFont> createState() => _RiveRandomFontState();
}

class _RiveRandomFontState extends State<_RiveRandomFont> {
  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  RiveFile? _riveFontSampleFile;

  Future<void> _loadFiles() async {
    final fontFile = await RiveFile.asset(
      'assets/sampletext.riv',
      loadEmbeddedAssets: false, // disable loading embedded assets.
      assetLoader: CallbackAssetLoader(
        (asset) async {
          final urls = [
            'https://cdn.rive.app/runtime/flutter/IndieFlower-Regular.ttf',
            'https://cdn.rive.app/runtime/flutter/comic-neue.ttf',
            'https://cdn.rive.app/runtime/flutter/inter.ttf',
            'https://cdn.rive.app/runtime/flutter/inter-tight.ttf',
            'https://cdn.rive.app/runtime/flutter/josefin-sans.ttf',
            'https://cdn.rive.app/runtime/flutter/send-flowers.ttf',
          ];

          final res = await http.get(
            // pick a random url from the list of fonts
            Uri.parse(urls[Random().nextInt(urls.length)]),
          );
          await asset.decode(Uint8List.view(res.bodyBytes.buffer));
          return true;
        },
      ),
    );

    setState(() {
      _riveFontSampleFile = fontFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_riveFontSampleFile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RiveAnimation.direct(
      _riveFontSampleFile!,
      fit: BoxFit.cover,
    );
  }
}
