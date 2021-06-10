import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:universal_io/io.dart';

enum _Source {
  asset,
  network,
}

/// High level widget that plays an animation from a Rive file. If artboard or
/// animation are not specified, the default artboard and first animation fonund
/// within it are used.
class RiveAnimation extends StatefulWidget {
  final String name;
  final _Source src;
  final String? artboard;
  final List<String> animations;
  final List<String> stateMachines;
  final BoxFit? fit;
  final Alignment? alignment;
  /// Widget displayed while the rive is loading.
  final Widget? placeHolder;

  /// Creates a new RiveAnimation from an asset bundle
  const RiveAnimation.asset(
    this.name, {
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
  }) : src = _Source.asset;

  const RiveAnimation.network(
    this.name, {
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
  }) : src = _Source.network;

  @override
  _RiveAnimationState createState() => _RiveAnimationState();
}

class _RiveAnimationState extends State<RiveAnimation> {
  /// Rive controller
  final _controllers = <RiveAnimationController>[];

  /// Active artboard
  Artboard? _artboard;

  @override
  void initState() {
    super.initState();
    // Load the Rive file from the asset bundle
    switch (widget.src) {
      case _Source.asset:
        _loadAsset();
        break;
      case _Source.network:
        _loadNetwork();
        break;
    }
  }

  /// Loads a Rive file from an asset bundle and configures artboard, animation,
  /// and controller.
  void _loadAsset() {
    rootBundle.load(widget.name).then(
      (data) async {
        _init(data);
      },
    );
  }

  /// Loads a Rive file from an HTTP source and configures artboard, animation,
  /// and controller.
  void _loadNetwork() {
    final client = HttpClient();
    final contents = <int>[];

    client
        .getUrl(Uri.parse(widget.name))
        .then(
          (req) async => req.close(),
        )
        .then(
          (res) => res.listen(
            contents.addAll,
            onDone: () {
              final data = ByteData.view(Uint8List.fromList(contents).buffer);
              _init(data);
            },
          ),
        );
  }

  /// Initializes the artboard, animation, and controller
  void _init(ByteData data) {
    final file = RiveFile.import(data);
    final artboard = widget.artboard != null
        ? file.artboardByName(widget.artboard!)
        : file.mainArtboard;

    if (artboard == null) {
      throw const FormatException('Unable to load artboard');
    }
    if (artboard.animations.isEmpty) {
      throw FormatException('No animations in artboard ${artboard.name}');
    }

    // Create animations
    // If there are no animations or state machines specified, select a default
    // animation
    final animationNames =
        widget.animations.isEmpty && widget.stateMachines.isEmpty
            ? [artboard.animations.first.name]
            : widget.animations;

    animationNames.forEach((name) => artboard
        .addController((_controllers..add(SimpleAnimation(name))).last));

    // Create state machines
    final stateMachineNames = widget.stateMachines;

    stateMachineNames.forEach((name) {
      final controller = StateMachineController.fromArtboard(artboard, name);
      if (controller != null) {
        artboard.addController((_controllers..add(controller)).last);
      }
    });

    setState(() => _artboard = artboard);
  }

  @override
  void dispose() {
    _controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _artboard != null
      ? Rive(
          artboard: _artboard!,
          fit: widget.fit,
          alignment: widget.alignment,
        )
      : widget.placeHolder ?? const SizedBox();
}
