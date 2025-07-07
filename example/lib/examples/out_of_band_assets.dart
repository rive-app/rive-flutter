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
/// See `out_of_band_assets_cached.dart` for an example of this.
///
/// See: https://rive.app/docs/runtimes/loading-assets
class ExampleOutOfBandAssetLoading extends StatefulWidget {
  const ExampleOutOfBandAssetLoading({Key? key}) : super(key: key);

  @override
  State<ExampleOutOfBandAssetLoading> createState() =>
      _ExampleOutOfBandAssetLoadingState();
}

class _ExampleOutOfBandAssetLoadingState
    extends State<ExampleOutOfBandAssetLoading> {
  var _index = 0;
  void next() => setState(() {
        _index += 1;
      });

  void previous() => setState(() {
        _index -= 1;
      });

  @override
  Widget build(BuildContext context) {
    return Center(
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

  File? _riveImageSampleFile;
  RiveWidgetController? _controller;

  Future<void> _loadFiles() async {
    final imageFile = await File.asset(
      'assets/image_out_of_band.riv',
      riveFactory: Factory.rive,
      assetLoader: (asset, bytes) {
        if (asset is ImageAsset && bytes == null) {
          http.get(Uri.parse('https://picsum.photos/500/500')).then((res) {
            if (mounted) {
              asset.decode(Uint8List.view(res.bodyBytes.buffer));
              setState(() {
                // force rebuild in case the Rive graphic is no longer advancing
              });
            }
          });
          return true; // Tell the runtime not to load the asset automatically
        } else {
          // Tell the runtime to proceed with loading the asset if it exists
          return false;
        }
      },
    );

    setState(() {
      _riveImageSampleFile = imageFile;
      _controller = RiveWidgetController(_riveImageSampleFile!);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _riveImageSampleFile?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_riveImageSampleFile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        _controller == null
            ? const SizedBox()
            : RiveWidget(controller: _controller!),
        const Positioned(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'This example loads a random image dynamically and asynchronously.\n\nHover to zoom.',
              style: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
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

  File? _riveFontSampleFile;
  RiveWidgetController? _controller;

  Future<void> _loadFiles() async {
    final fontFile = await File.asset(
      'assets/acqua_text_out_of_band.riv',
      riveFactory: Factory.rive,
      assetLoader: (asset, bytes) {
        // Replace font assets that are not embedded in the rive file
        if (asset is FontAsset && bytes == null) {
          final urls = [
            'https://cdn.rive.app/runtime/flutter/IndieFlower-Regular.ttf',
            'https://cdn.rive.app/runtime/flutter/comic-neue.ttf',
            'https://cdn.rive.app/runtime/flutter/inter.ttf',
            'https://cdn.rive.app/runtime/flutter/inter-tight.ttf',
            'https://cdn.rive.app/runtime/flutter/josefin-sans.ttf',
            'https://cdn.rive.app/runtime/flutter/send-flowers.ttf',
          ];

          // pick a random url from the list of fonts
          http.get(Uri.parse(urls[Random().nextInt(urls.length)])).then((res) {
            if (mounted) {
              asset.decode(
                Uint8List.view(res.bodyBytes.buffer),
              );
              setState(() {
                // force rebuild in case the Rive graphic is no longer advancing
              });
            }
          });
          return true; // Tell the runtime not to load the asset automatically
        } else {
          // Tell the runtime to proceed with loading the asset if it exists
          return false;
        }
      },
    );

    setState(() {
      _riveFontSampleFile = fontFile;
      _controller = RiveWidgetController(_riveFontSampleFile!);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _riveFontSampleFile?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        _riveFontSampleFile == null
            ? const SizedBox()
            : RiveWidget(
                controller: _controller!,
                fit: Fit.cover,
              ),
        const Positioned(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'This example loads a random font dynamically and asynchronously.\n\nClick to change drink.',
              style: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
