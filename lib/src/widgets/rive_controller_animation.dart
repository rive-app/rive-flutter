import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';
import 'package:rive/src/rive_core/artboard.dart';

enum _Source {
  asset,
  network,
}

/// High level widget that plays an animation from a Rive file. If artboard or
/// animation are not specified, the default artboard and first animation fonund
/// within it are used.
class RiveControllerAnimation extends StatefulWidget {
  /// The asset name or url
  final String name;

  /// The type of source used to retrieve the asset
  final _Source src;

  /// The name of the artboard to use; default artboard if not specified
  final String? artboard;

  /// List of Rive controllers to attach
  final List<RiveAnimationController> controllers;

  /// Fit for the animation in the widget
  final BoxFit? fit;

  /// Alignment for the animation in the widget
  final Alignment? alignment;

  /// Enable/disable antialiasing when rendering
  final bool antialiasing;

  /// Widget displayed while the rive is loading
  final Widget? placeHolder;

  /// Creates a new RiveControllerAnimation from an asset bundle
  const RiveControllerAnimation.asset(
    this.name, {
    this.artboard,
    this.controllers = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
  }) : src = _Source.asset;

  const RiveControllerAnimation.network(
    this.name, {
    this.artboard,
    this.controllers = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
  }) : src = _Source.network;

  @override
  _RiveControllerAnimationState createState() =>
      _RiveControllerAnimationState();
}

class _RiveControllerAnimationState extends State<RiveControllerAnimation> {
  /// Rive controller
  final _controllers = <RiveAnimationController>[];

  /// Active artboard
  Artboard? _artboard;

  @override
  void initState() {
    super.initState();

    if (widget.src == _Source.asset) {
      RiveFile.asset(widget.name).then(_init);
    } else if (widget.src == _Source.network) {
      RiveFile.network(widget.name).then(_init);
    }
  }

  /// Initializes the artboard, animation, and controller
  void _init(RiveFile file) {
    final artboard = widget.artboard != null
        ? file.artboardByName(widget.artboard!)
        : file.mainArtboard;

    if (artboard == null) {
      throw const FormatException('Unable to load artboard');
    }
    if (artboard.animations.isEmpty) {
      throw FormatException('No animations in artboard ${artboard.name}');
    }

    // Attach each controller to the artboard
    widget.controllers.forEach(artboard.addController);
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
          antialiasing: widget.antialiasing,
        )
      : widget.placeHolder ?? const SizedBox();
}
