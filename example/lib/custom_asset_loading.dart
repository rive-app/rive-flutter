import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;

/// An example showing how to load image or font assets dynamically
class CustomAssetLoading extends StatefulWidget {
  const CustomAssetLoading({Key? key}) : super(key: key);

  @override
  State<CustomAssetLoading> createState() => _CustomAssetLoadingState();
}

class _CustomAssetLoadingState extends State<CustomAssetLoading> {
  var _index = 0;
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
              child: (_index % 2 == 0)
                  ? RiveAnimation.asset(
                      'assets/asset.riv',
                      fit: BoxFit.cover,
                      importEmbeddedAssets: false,
                      assetLoader: CallbackAssetLoader(
                        (asset) async {
                          final res = await http.get(
                              Uri.parse('https://picsum.photos/1000/1000'));
                          await asset
                              .decode(Uint8List.view(res.bodyBytes.buffer));
                          return true;
                        },
                      ),
                    )
                  : RiveAnimation.asset(
                      'assets/sampletext.riv',
                      fit: BoxFit.cover,
                      importEmbeddedAssets: false,
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

                          final res = await http.get(Uri.parse(
                            urls[Random().nextInt(
                              urls.length,
                            )],
                          ));
                          await asset
                              .decode(Uint8List.view(res.bodyBytes.buffer));
                          return true;
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
