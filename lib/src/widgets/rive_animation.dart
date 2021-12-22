import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

/// Specifies whether a source is from an asset bundle or http
enum _Source {
  asset,
  network,
  file,
}

/// The callback signature for onInit
typedef OnInitCallback = void Function(Artboard);

/// High level widget that plays an animation from a Rive file. If artboard or
/// animation are not specified, the default artboard and first animation fonund
/// within it are used.
class RiveAnimation extends StatefulWidget {
  /// The asset name or url
  final String name;

  /// The type of source used to retrieve the asset
  final _Source src;

  /// The name of the artboard to use; default artboard if not specified
  final String? artboard;

  /// List of animations to play; default animation if not specified
  final List<String> animations;

  /// List of state machines to play; none will play if not specified
  final List<String> stateMachines;

  /// Fit for the animation in the widget
  final BoxFit? fit;

  /// Alignment for the animation in the widget
  final Alignment? alignment;

  /// Widget displayed while the rive is loading
  final Widget? placeHolder;

  /// Enable/disable antialiasing when rendering
  final bool antialiasing;

  /// Controllers for instanced animations and state machines; use this
  /// to directly control animation states instead of passing names.
  final List<RiveAnimationController> controllers;

  /// Callback fired when Riveanimation has initialized
  final OnInitCallback? onInit;

  /// Creates a new RiveAnimation from an asset bundle
  const RiveAnimation.asset(
    this.name, {
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
    this.controllers = const [],
    this.onInit,
  }) : src = _Source.asset;

  const RiveAnimation.network(
    this.name, {
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
    this.controllers = const [],
    this.onInit,
  }) : src = _Source.network;

  const RiveAnimation.file(
    this.name, {
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
    this.controllers = const [],
    this.onInit,
  }) : src = _Source.file;

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

    if (widget.src == _Source.asset) {
      RiveFile.asset(widget.name).then(_init);
    } else if (widget.src == _Source.network) {
      RiveFile.network(widget.name).then(_init);
    } else if (widget.src == _Source.file) {
      RiveFile.file(widget.name).then(_init);
    }
  }

  /// Initializes the artboard, animations, state machines and controllers
  void _init(RiveFile file) {
    if (!mounted) {
      /// _init is usually called asynchronously, so this is a good time to
      /// check if the widget is still mounted. If it's not we can get out of
      /// here early.
      return;
    }
    final artboard = (widget.artboard != null
            ? file.artboardByName(widget.artboard!)
            : file.mainArtboard)
        ?.instance();

    if (artboard == null) {
      throw const FormatException('Unable to load artboard');
    }
    if (artboard.animations.isEmpty) {
      throw FormatException('No animations in artboard ${artboard.name}');
    }

    // Create animations If there are no animations, state machines, or
    // controller specified, select a default animation
    final animationNames = widget.animations.isEmpty &&
            widget.stateMachines.isEmpty &&
            widget.controllers.isEmpty
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

    // Add any user-created contollers
    widget.controllers.forEach(artboard.addController);

    setState(() => _artboard = artboard);

    // Call the onInit callback if provided
    widget.onInit?.call(_artboard!);
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
