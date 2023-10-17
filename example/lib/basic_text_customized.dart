import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';

class BasicTextCustomized extends StatefulWidget {
  const BasicTextCustomized({Key? key}) : super(key: key);

  @override
  State<BasicTextCustomized> createState() => _BasicTextCustomizedState();
}

/// Basic example playing a Rive animation from a packaged asset.
class _BasicTextCustomizedState extends State<BasicTextCustomized>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 10));
  RiveArtboardRenderer? _artboardRenderer;
  List<Artboard> artboards = [];
  late RiveFile file;
  FontAsset? fontAsset;

  randomFont() async {
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
    await fontAsset?.decode(Uint8List.view(res.bodyBytes.buffer));
  }

  addArtboard() async {
    unawaited(randomFont());
    setState(() {
      final artboard = file.mainArtboard.instance();
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
      )!;
      artboard.addController(controller);
      artboards.add(artboard);
      while (artboards.length > 5) {
        artboards.removeAt(0);
      }
      _artboardRenderer = RiveArtboardRenderer(
        fit: BoxFit.cover,
        alignment: Alignment.center,
        artboards: artboards,
      );
    });
  }

  Future<void> _load() async {
    // You need to manage adding the controller to the artboard yourself,
    // unlike with the RiveAnimation widget that handles a lot of this logic
    // for you by simply providing the state machine (or animation) name.
    file = await RiveFile.asset(
      'assets/trans_text.riv',
      loadEmbeddedAssets: false,
      assetLoader: CallbackAssetLoader(
        (asset) async {
          if (asset is FontAsset) {
            setState(() {
              fontAsset = asset;
            });
            return true;
          }
          return false;
        },
      ),
    );
    final artboard = file.mainArtboard.instance();
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    )!;
    artboard.addController(controller);
    artboards.add(artboard);
    unawaited(randomFont());

    setState(
      () => _artboardRenderer = RiveArtboardRenderer(
        fit: BoxFit.cover,
        alignment: Alignment.center,
        artboards: [artboard],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController.repeat();
    _load();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          addArtboard();
        },
        child: Center(
          child: _artboardRenderer == null
              ? const SizedBox()
              : CustomPaint(
                  painter: RiveCustomPainter(
                    _artboardRenderer!,
                    repaint: _animationController,
                  ),
                  child: const SizedBox.expand(), // use all the size available
                ),
        ),
      ),
    );
  }
}

class RiveCustomPainter extends CustomPainter {
  final RiveArtboardRenderer artboardRenderer;

  RiveCustomPainter(this.artboardRenderer, {super.repaint}) {
    _lastTickTime = DateTime.now();
    _elapsedTime = Duration.zero;
  }

  late DateTime _lastTickTime;
  late Duration _elapsedTime;

  void _calculateElapsedTime() {
    final currentTime = DateTime.now();
    _elapsedTime = currentTime.difference(_lastTickTime);
    _lastTickTime = currentTime;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _calculateElapsedTime(); // Calculate elapsed time since last tick.

    // Advance the artboard by the elapsed time.
    artboardRenderer.advance(_elapsedTime.inMicroseconds / 1000000);

    final width = size.width / 3;
    final height = size.height / 2;
    final artboardSize = Size(width, height);

    // First row
    canvas.save();
    artboardRenderer.render(canvas, artboardSize);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// Keeps an `Artboard` instance and renders it to a `Canvas`.
///
/// This is a simplified version of the `RiveAnimation` widget and its
/// RenderObject
///
/// This accounts for the `fit` and `alignment` properties, similar to how
/// `RiveAnimation` works.
class RiveArtboardRenderer {
  final List<Artboard> artboards;
  final BoxFit fit;
  final Alignment alignment;

  RiveArtboardRenderer({
    required this.fit,
    required this.alignment,
    required this.artboards,
  });

  void advance(double dt) {
    for (var artboard in artboards) {
      artboard.advance(dt, nested: true);
    }
  }

  late final aabb =
      AABB.fromValues(0, 0, artboards.first.width, artboards.first.height);

  void render(Canvas canvas, Size size) {
    _paint(canvas, aabb, size);
  }

  final _transform = Mat2D();
  final _center = Mat2D();

  void _paint(Canvas canvas, AABB bounds, Size size) {
    for (var artboard in artboards) {
      _paintArtboard(artboard, canvas, bounds, size);
      bounds = AABB.fromValues(bounds.left - 100, bounds.top - 100,
          bounds.right - 100, bounds.bottom - 100);
    }
  }

  void _paintArtboard(
      Artboard artboard, Canvas canvas, AABB bounds, Size size) {
    final contentWidth = bounds[2] - bounds[0];
    final contentHeight = bounds[3] - bounds[1];

    if (contentWidth == 0 || contentHeight == 0) {
      return;
    }

    final x = -1 * bounds[0] -
        contentWidth / 2.0 -
        (alignment.x * contentWidth / 2.0);
    final y = -1 * bounds[1] -
        contentHeight / 2.0 -
        (alignment.y * contentHeight / 2.0);

    var scaleX = 1.0;
    var scaleY = 1.0;

    canvas.save();

    switch (fit) {
      case BoxFit.fill:
        scaleX = size.width / contentWidth;
        scaleY = size.height / contentHeight;
        break;
      case BoxFit.contain:
        final minScale =
            min(size.width / contentWidth, size.height / contentHeight);
        scaleX = scaleY = minScale;
        break;
      case BoxFit.cover:
        final maxScale =
            max(size.width / contentWidth, size.height / contentHeight);
        scaleX = scaleY = maxScale;
        break;
      case BoxFit.fitHeight:
        final minScale = size.height / contentHeight;
        scaleX = scaleY = minScale;
        break;
      case BoxFit.fitWidth:
        final minScale = size.width / contentWidth;
        scaleX = scaleY = minScale;
        break;
      case BoxFit.none:
        scaleX = scaleY = 1.0;
        break;
      case BoxFit.scaleDown:
        final minScale =
            min(size.width / contentWidth, size.height / contentHeight);
        scaleX = scaleY = minScale < 1.0 ? minScale : 1.0;
        break;
    }

    Mat2D.setIdentity(_transform);
    _transform[4] = size.width / 2.0 + (alignment.x * size.width / 2.0);
    _transform[5] = size.height / 2.0 + (alignment.y * size.height / 2.0);
    Mat2D.scale(_transform, _transform, Vec2D.fromValues(scaleX, scaleY));
    Mat2D.setIdentity(_center);
    _center[4] = x;
    _center[5] = y;
    Mat2D.multiply(_transform, _transform, _center);

    canvas.translate(
      size.width / 2.0 + (alignment.x * size.width / 2.0),
      size.height / 2.0 + (alignment.y * size.height / 2.0),
    );

    canvas.scale(scaleX, scaleY);
    canvas.translate(x, y);

    artboard.draw(canvas);

    canvas.restore();
  }
}
