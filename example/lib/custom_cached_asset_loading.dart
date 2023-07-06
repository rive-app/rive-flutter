import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;

/// An example showing how to load image or font assets dynamically
class CustomCachedAssetLoading extends StatefulWidget {
  const CustomCachedAssetLoading({Key? key}) : super(key: key);

  @override
  State<CustomCachedAssetLoading> createState() =>
      _CustomCachedAssetLoadingState();
}

class _CustomCachedAssetLoadingState extends State<CustomCachedAssetLoading> {
  var _index = 0;
  var _ready = false;
  final _imageCache = [];
  final _fontCache = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _warmUpCache();
    });
  }

  _warmUpCache() async {
    final futures = <Future>[];
    loadImage() async {
      final res = await http.get(Uri.parse('https://picsum.photos/1000/1000'));
      final body = Uint8List.view(res.bodyBytes.buffer);
      final image = await ImageAsset.parseBytes(body);
      if (image != null) {
        _imageCache.add(image);
      }
    }

    loadFont(url) async {
      final res = await http.get(Uri.parse(url));
      final body = Uint8List.view(res.bodyBytes.buffer);
      final font = await FontAsset.parseBytes(body);

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

    setState(() {
      _ready = true;
    });
  }

  void next() {
    setState(() {
      _index += 1;
    });
  }

  void previous() {
    setState(() {
      _index -= 1;
    });
  }

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
              child: (!_ready)
                  ? const Center(child: Text('warming up cache'))
                  : (_index % 2 == 0)
                      ? RiveAnimation.asset(
                          'assets/asset.riv',
                          fit: BoxFit.cover,
                          importEmbeddedAssets: false,
                          assetLoader: CallbackAssetLoader(
                            (asset) async {
                              if (asset is ImageAsset) {
                                asset.image = _imageCache[
                                    Random().nextInt(_imageCache.length)];
                                return true;
                              }
                              return false;
                            },
                          ),
                        )
                      : RiveAnimation.asset(
                          'assets/sampletext.riv',
                          fit: BoxFit.cover,
                          importEmbeddedAssets: false,
                          assetLoader: CallbackAssetLoader(
                            (asset) async {
                              if (asset is FontAsset) {
                                asset.font = _fontCache[
                                    Random().nextInt(_fontCache.length)];
                                return true;
                              }
                              return false;
                            },
                          ),
                        ),
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
