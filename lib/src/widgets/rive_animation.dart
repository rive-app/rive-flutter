import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/widgets/artboard_provider/artboard_provider.dart';
import 'package:rive/src/widgets/artboard_provider/asset_artboard_provider.dart';

/// A [Widget] that displays the [Rive] animation.
class RiveAnimation extends StatefulWidget {
  /// An [Alignment] that determines how to align this animation
  /// within its bounds.
  ///
  /// By default, equals to [Alignment.center].
  final Alignment alignment;

  /// An [ArtboardProvider] needed to load the animation from different sources.
  final ArtboardProvider artboardProvider;

  /// A name of the [Artboard] to display the animation.
  ///
  /// By default, loads the main [Artboard].
  final String artboardName;

  /// A [RiveAnimationController] to control the animation's playback.
  final RiveAnimationController controller;

  /// A [BoxFit] that determines how to inscribe this animation into the space
  /// allocated during layout.
  ///
  /// By default, equals to [BoxFit.contain].
  final BoxFit fit;

  /// A [WidgetBuilder] that determines the widget to display while the
  /// animation is still loading.
  ///
  /// By default, builds an empty [SizedBox].
  final WidgetBuilder loadingBuilder;

  /// A flag that determines whether to use the absolute size defined by the
  /// artboard, or size the widget based on the available constraints only.
  ///
  /// By default, equals to `false`.
  final bool useArtboardSize;

  /// Creates a new [RiveAnimation] widget that displays the animation obtained
  /// using the given [artboardProvider]. See [ArtboardProvider] for more info.
  ///
  /// The [artboardProvider] must not be null.
  ///
  /// Specify the [artboardName] to load the specific [Artboard] to display
  /// the animation.
  ///
  /// Specify the [controller] to be able to control the animation playback.
  ///
  /// Specify the [loadingBuilder] to determine the [Widget] to display when the
  /// animation is still loading.
  ///
  /// Specify the [alignment] to determine how to align this animation
  /// within the available space.
  ///
  /// Specify the [fit] to determine how this animation should be inscribed
  /// within the available space.
  ///
  /// Specify the [useArtboardSize] to determine whether to use the absolute
  /// size defined by the [Artboard], or the available space defined by the
  /// parent constraints.
  ///
  /// See [RiveAnimation.asset] to load the animation from assets.
  const RiveAnimation({
    @required this.artboardProvider,
    Key key,
    this.artboardName,
    this.controller,
    this.loadingBuilder,
    Alignment alignment,
    BoxFit fit,
    bool useArtboardSize,
  })  : assert(artboardProvider != null),
        alignment = alignment ?? Alignment.center,
        fit = fit ?? BoxFit.contain,
        useArtboardSize = useArtboardSize ?? false,
        super(key: key);

  /// Creates a new [RiveAnimation] widget that displays the animation obtained
  /// from the assets using the given [assetName].
  ///
  /// The [assetName] must not be `null`.
  ///
  /// Specify the [artboardName] to load the specific [Artboard] to display
  /// the animation.
  ///
  /// Specify the [controller] to be able to control the animation playback.
  ///
  /// Specify the [loadingBuilder] to determine the [Widget] to display when the
  /// animation is still loading.
  ///
  /// Specify the [alignment] to determine how to align this animation
  /// within the available space.
  ///
  /// Specify the [fit] to determine how this animation should be inscribed
  /// within the available space.
  ///
  /// Specify the [useArtboardSize] to determine whether to use the absolute
  /// size defined by the [Artboard], or the available space defined by the
  /// parent constraints.
  RiveAnimation.asset(
    String assetName, {
    Key key,
    String artboardName,
    RiveAnimationController controller,
    WidgetBuilder loadingBuilder,
    AssetBundle bundle,
    Alignment alignment,
    BoxFit fit,
    bool useArtboardSize,
  }) : this(
          key: key,
          artboardProvider: AssetArtboardProvider(
            assetName: assetName,
            bundle: bundle,
          ),
          artboardName: artboardName,
          loadingBuilder: loadingBuilder,
          controller: controller,
          alignment: alignment,
          fit: fit,
          useArtboardSize: useArtboardSize,
        );

  @override
  _RiveAnimationState createState() => _RiveAnimationState();
}

class _RiveAnimationState extends State<RiveAnimation> {
  /// An [Artboard] to display the animation.
  Artboard _artboard;

  /// Indicates whether the animation is loading.
  bool get _isAnimationLoading => _artboard == null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isAnimationLoading
        ? (widget.loadingBuilder?.call(context) ?? const SizedBox())
        : Rive(
            artboard: _artboard,
            fit: widget.fit,
            alignment: widget.alignment,
            useArtboardSize: widget.useArtboardSize,
          );
  }

  /// Loads the animation using the [widget.artboardProvider].
  ///
  /// If the [widget.controller] is not `null`, adds it
  /// to the obtained [artboard].
  FutureOr<void> _loadAnimation() async {
    final artboard = await widget.artboardProvider.load(
      artboardName: widget.artboardName,
    );

    if (widget.controller != null) {
      artboard.addController(widget.controller);
    }

    setState(() {
      _artboard = artboard;
    });
  }
}
