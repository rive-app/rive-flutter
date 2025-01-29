import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

/// Specifies whether a source is from an asset bundle or http
enum _Source {
  asset,
  network,
  file,
  direct,
}

/// The callback signature for onInit
typedef OnInitCallback = void Function(Artboard);

/// High level widget that plays an animation from a Rive file. If artboard or
/// animation are not specified, the default artboard and first animation found
/// within it are used.
class RiveAnimation extends StatefulWidget {
  /// The asset name or url
  final String? name;

  /// The Rive File object
  final RiveFile? file;

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

  /// {@macro Rive.useArtboardSize}
  final bool useArtboardSize;

  /// {@macro Rive.clipRect}
  final Rect? clipRect;

  /// Controllers for instanced animations and state machines; use this
  /// to directly control animation states instead of passing names.
  final List<RiveAnimationController> controllers;

  /// Callback fired when [RiveAnimation] has initialized
  final OnInitCallback? onInit;

  /// Headers for network requests
  final Map<String, String>? headers;

  /// {@macro Rive.behavior}
  final RiveHitTestBehavior behavior;

  /// Rive object generator to override built-in types and methods to, for
  /// example, interject custom rendering functionality interleaved with Rive
  /// rendering.
  final ObjectGenerator? objectGenerator;

  /// A multiplier for controlling the speed of the Rive animation playback.
  ///
  /// Default `1.0`.
  final double speedMultiplier;

  /// For Rive Listeners, allows scrolling behavior to still occur on Rive
  /// widgets when a touch/drag action is performed on touch-enabled devices.
  /// Otherwise, scroll behavior may be prevented on touch/drag actions on the
  /// widget by default.
  ///
  /// Default `false`.
  final bool isTouchScrollEnabled;

  /// Creates a new [RiveAnimation] from an asset bundle.
  ///
  /// *Example:*
  /// ```dart
  /// return RiveAnimation.asset('assets/truck.riv');
  /// ```
  const RiveAnimation.asset(
    String asset, {
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
    this.useArtboardSize = false,
    this.clipRect,
    this.controllers = const [],
    this.onInit,
    this.behavior = RiveHitTestBehavior.opaque,
    this.objectGenerator,
    this.speedMultiplier = 1,
    this.isTouchScrollEnabled = false,
    Key? key,
  })  : name = asset,
        file = null,
        headers = null,
        src = _Source.asset,
        super(key: key);

  /// Creates a new [RiveAnimation] from a URL over HTTP
  ///
  /// *Example:*
  /// ```dart
  /// return RiveAnimation.network('https://cdn.rive.app/animations/vehicles.riv');
  /// ```
  const RiveAnimation.network(
    String url, {
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
    this.useArtboardSize = false,
    this.clipRect,
    this.controllers = const [],
    this.onInit,
    this.headers,
    this.behavior = RiveHitTestBehavior.opaque,
    this.objectGenerator,
    this.speedMultiplier = 1,
    this.isTouchScrollEnabled = false,
    Key? key,
  })  : name = url,
        file = null,
        src = _Source.network,
        super(key: key);

  /// Creates a new [RiveAnimation] from a local .riv file
  ///
  /// *Example:*
  /// ```dart
  /// return RiveAnimation.file('path/to/local/file.riv');
  /// ```
  const RiveAnimation.file(
    String path, {
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
    this.useArtboardSize = false,
    this.clipRect,
    this.controllers = const [],
    this.onInit,
    this.behavior = RiveHitTestBehavior.opaque,
    this.objectGenerator,
    this.speedMultiplier = 1,
    this.isTouchScrollEnabled = false,
    Key? key,
  })  : name = path,
        file = null,
        headers = null,
        src = _Source.file,
        super(key: key);

  /// Creates a new [RiveAnimation] from a direct [RiveFile] object
  ///
  /// *Example:*
  /// ```dart
  /// final riveFile = await RiveFile.asset('assets/truck.riv');
  /// ...
  /// return RiveAnimation.direct(riveFile);
  /// ```
  const RiveAnimation.direct(
    RiveFile this.file, {
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
    this.useArtboardSize = false,
    this.clipRect,
    this.controllers = const [],
    this.onInit,
    this.speedMultiplier = 1,
    this.isTouchScrollEnabled = false,
    Key? key,
    this.behavior = RiveHitTestBehavior.opaque,
  })  : name = null,
        headers = null,
        objectGenerator = null,
        src = _Source.direct,
        super(key: key);

  @override
  RiveAnimationState createState() => RiveAnimationState();
}

@visibleForTesting
class RiveAnimationState extends State<RiveAnimation> {
  /// Rive controller
  final _controllers = <RiveAnimationController>[];

  /// Active artboard
  Artboard? _artboard;

  /// Active Rive file loaded in memory.
  RiveFile? _riveFile;

  @override
  void initState() {
    super.initState();
    _configure();
  }

  /// Loads [RiveFile] and calls [_init]
  Future<void> _configure() async {
    if (!mounted) return;

    _init(await _loadRiveFile());
  }

  /// STOKANAL-FORK-EDIT: start
  /// This is a workaround to allow for embedded Rive animations. It hacks the Flutter State flow.
  // @override
  // RiveAnimation get widget => _widget??super.widget;
  // RiveAnimation? _widget;
  // @override
  // bool get mounted => (_widget != null) ? true : super.mounted;
  // @override
  // void setState(VoidCallback fn) => (_widget != null) ? fn() : super.setState(fn);
  // Future<void> init(RiveAnimation widget) async {
  //   _widget = widget;
  //   initState();
  // }
  /// STOKANAL-FORK-EDIT: end

  /// Loads the correct Rive file depending on [widget.src]
  Future<RiveFile> _loadRiveFile() {
    switch (widget.src) {
      case _Source.asset:
        return RiveFile.asset(
          widget.name!,
          objectGenerator: widget.objectGenerator,
        );
      case _Source.network:
        return RiveFile.network(
          widget.name!,
          headers: widget.headers,
          objectGenerator: widget.objectGenerator,
        );
      case _Source.file:
        return RiveFile.file(
          widget.name!,
          objectGenerator: widget.objectGenerator,
        );
      case _Source.direct:
        return Future.value(
          widget.file!,
        );
    }
  }

  @override
  void didUpdateWidget(covariant RiveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.name != oldWidget.name ||
        widget.file != oldWidget.file ||
        widget.src != oldWidget.src) {
      _configure(); // Rife file has changed
    } else if (_requiresInit(oldWidget)) {
      if (_riveFile == null) {
        _configure(); // Rife file not yet loaded
      } else {
        _init(_riveFile!);
      }
    }
  }

  /// Determines if new parameters provided to the widget requires
  /// re-initialization of the Rive artboard
  bool _requiresInit(RiveAnimation oldWidget) =>
      widget.artboard != oldWidget.artboard ||
      !listEquals(widget.animations, oldWidget.animations) ||
      !listEquals(widget.controllers, oldWidget.controllers) ||
      !listEquals(widget.stateMachines, oldWidget.stateMachines);

  /// Initializes the artboard, animations, state machines and controllers
  void _init(RiveFile file) {
    _riveFile = file;

    if (!mounted) {
      /// _init is usually called asynchronously, so this is a good time to
      /// check if the widget is still mounted. If it's not we can get out of
      /// here early.
      return;
    }

    // Clear current local controllers.
    // _controllers.forEach((c) {
    for (final c in _controllers) {
      c.dispose();
    }//);
    _controllers.clear();

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

    // Create animations. If there are no animations, state machines, or
    // controller specified, select a default animation
    final animationNames = widget.animations.isEmpty &&
            widget.stateMachines.isEmpty &&
            widget.controllers.isEmpty &&
            widget.onInit == null
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

    // Add any user-created controllers
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

  bool get _shouldAddHitTesting => _artboard!.animationControllers.any(
        (controller) =>
            controller is StateMachineController &&
            controller.hitComponents.isNotEmpty,
      );

  @override
  Widget build(BuildContext context) => _artboard != null
      ? Rive(
          artboard: _artboard!,
          fit: widget.fit ?? BoxFit.contain,
          alignment: widget.alignment ?? Alignment.center,
          antialiasing: widget.antialiasing,
          useArtboardSize: widget.useArtboardSize,
          clipRect: widget.clipRect,
          enablePointerEvents: _shouldAddHitTesting,
          behavior: widget.behavior,
          speedMultiplier: widget.speedMultiplier,
          isTouchScrollEnabled: widget.isTouchScrollEnabled,
        )
      : widget.placeHolder ?? const SizedBox();
}
