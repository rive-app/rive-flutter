// ignore_for_file: sort_unnamed_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:plato/plato.dart';
import 'package:rive/rive.dart';
import 'package:stokanal/core.dart';

const _logr = Logr(false, prefix: 'rive-animation');

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

/// Payload for a RiveAnimation.State
/// This is to avoid unnecessary duplicate RiveAnimationState._init and RiveAnimation.onInit calls
class _RiveAnimationPayload {

  /// Rive controller
  final controllers = <RiveAnimationController>[];

  /// Active artboard
  Artboard? artboard;

  /// Load and init future
  late final Future<void> loadAndInit;

  var _onDisposed = false;

  void onDispose(Widget widget, RiveAnimationState state) {

    _onDisposed = true;

    if (!shortLived) {
      _dispose(state);
      _ShortLivedPayloadCache().dispose(widget); // remove and dispose associated payload
    } else {
      _ShortLivedPayloadCache().removeLoose();
      _logr.log(() => '${_ShortLivedPayloadCache()}');
    }
  }

  var _disposed = false;

  void _dispose(RiveAnimationState? state) {

    if (_disposed) return; // already disposed

    if (state != null && _owner != state) { // only the owner can dispose it
      return;
    }

    _disposed = true;
    controllers.forEach((c) => c.dispose());
    artboard = null;
  }

  final _watch = Watch();

  bool inited = false;

  /// Criteria for a short lived state payload
  /// Short lived payloads are stored to avoid unnecessary duplicate RiveAnimationState._init calls
  bool get shortLived =>
      _watch.millis < 2000;

  bool get loose =>
      _onDisposed && !shortLived;

  /// State that owns this payload
  RiveAnimationState? _owner;

  @override
  String toString() => printr(
    hashCode,
    shortLived ? 'short-lived' : null,
    loose ? 'loose' : null,
    artboard == null ? 'no-artboard' : null,
    inited ? null : 'not-inited',
    _disposed ? 'disposed' : null,
  );
}

class _ShortLivedPayloadCache {

  _ShortLivedPayloadCache._();
  static final _ShortLivedPayloadCache _singleton = _ShortLivedPayloadCache._();
  factory _ShortLivedPayloadCache() => _singleton;

  /// Keep short lived payloads to be reused by a subsequent state rebuilding
  final cache = <Widget, _RiveAnimationPayload>{};

  void push(Widget widget, _RiveAnimationPayload payload) {
    cache[widget]?._dispose(null); // dispose previously set
    cache[widget] = payload; // set this to the map
  }

  int get length => cache.length;

  void dispose(Widget widget) {
    cache.remove(widget)?._dispose(null);
  }

  _RiveAnimationPayload? remove(Widget widget) =>
    cache.remove(widget);

  void removeLoose() {
    cache.removeWhere((w, p) {
      if (p.loose) {
        p._dispose(null);
        return true;
      }
      return false;
    });

    if (length >= 100 && !_excessiveDumped) {
      _excessiveDumped = true;
      _logr.telemeter
        ..log(() => '$this')
        ..dump('Excessive short-lived payloads');
    }
  }

  var _excessiveDumped = false;

  @override
  String toString() => printr(
    'payloads=', cache.length,
    'short-lived=', cache.values.where((p) => p.shortLived).length,
    'loose=', cache.values.where((p) => p.loose).length,
    'creations=', creations,
    'reuses=', reuses,
  );

  int creations = 0;
  int reuses = 0;
}

@visibleForTesting
class RiveAnimationState extends State<RiveAnimation> {

  /// Animation payload
  _RiveAnimationPayload? _payload;

  String get ticker => '${widget.hashCode}:$hashCode';

  /// Loads [RiveFile] and calls [_init]
  Future<bool> _configure({bool forceReload = false}) async {

    assert (mounted, 'expect widget to be mounted at this point');

    final bool reusing;
    var payload = _ShortLivedPayloadCache().remove(widget);
    if (payload != null && !payload._disposed && !forceReload) { // hit a short lived payload, which was not yet disposed
      reusing = true;
      _ShortLivedPayloadCache().reuses++;
    } else {
      reusing = false;
      _ShortLivedPayloadCache().creations++;
      payload = _RiveAnimationPayload(); // create a new payload
      payload.loadAndInit = _loadAndInit(payload); // set load & init future
      _ShortLivedPayloadCache().push(widget, payload); // add only after setting loadAndInit
    }
    payload._owner = this; // reset the owner state
    await payload.loadAndInit; // wait load-and-init future
    _payload = payload;

    if (!payload.inited) {
      throw StateError('expect payload to be inited at this point > $payload');
    }
    if (payload.artboard == null) {
      throw StateError('payload artboard is null > $_payload');
    }

    _logr.log(() => 'CONFIGURE > $ticker >'
        '${forceReload?' forceReload':''}'
        '${reusing?' reusing':''}'
        ' > $payload'
    );

    return true; // always return true
  }


  Future<void> _loadAndInit(_RiveAnimationPayload payload) async {
    assert (mounted, 'expect widget to be mounted at this point');
    // var riveFile = await _loadRiveFile(); // await on loader
    _init(payload, await _loadRiveFile());
    _logr.log(() => 'LOAD-&-INIT > $ticker');
    payload.inited = true;
  }

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

    _logr.log(() => 'DID-UPDATE-WIDGET > ${oldWidget.hashCode} $ticker');

    super.didUpdateWidget(oldWidget);

    if (widget.name != oldWidget.name ||
        widget.file != oldWidget.file ||
        widget.src != oldWidget.src) {
      _configure(forceReload: true); // Rive file has changed
    } else if (_requiresInit(oldWidget)) {
      _configure(); // Rive file not changed
    }
  }

  /// Determines if new parameters provided to the widget requires
  /// re-initialization of the Rive artboard
  bool _requiresInit(RiveAnimation oldWidget) =>
      widget.artboard != oldWidget.artboard ||
      !listEquals(widget.animations, oldWidget.animations) ||
      !listEquals(widget.controllers, oldWidget.controllers) ||
      !listEquals(widget.stateMachines, oldWidget.stateMachines);

  String _dump(RiveFile file) => Printr.print(
    'file=', file,
    'artboards=', file.artboards.map((a) => a.artboard.name).join(','),
    'main=', file.mainArtboard.name,
    'widget=', widget.artboard,
  );

  /// Initializes the artboard, animations, state machines and controllers
  void _init(_RiveAnimationPayload payload, RiveFile file) {

    /// _init is usually called asynchronously, so this is a good time to
    /// check if the widget is still mounted. If it's not we can get out of
    /// here early.
    assert (mounted, 'expect widget to be mounted at this point');

    // payload.clear();

    final artboard = (widget.artboard != null
            ? file.artboardByName(widget.artboard!)
            : file.mainArtboard)
        ?.instance();

    if (artboard == null) {
      throw StateError('Cannot load the requested artboard > artboard=${widget.artboard} main=${file.mainArtboard} >> ${_dump(file)}');
    }
    if (artboard.animations.isEmpty) {
      throw FormatException('No animations in artboard > ${_dump(file)}');
    }

    // Create animations. If there are no animations, state machines, or
    // controller specified, select a default animation
    final animationNames = widget.animations.isEmpty &&
            widget.stateMachines.isEmpty &&
            widget.controllers.isEmpty &&
            widget.onInit == null
        ? [artboard.animations.first.name]
        : widget.animations;

    var t = animationNames.length;
    for (var i = 0; i < t; i++) {
      var name = animationNames[i];
      artboard.addController((payload.controllers..add(SimpleAnimation(name))).last);
    }
    // animationNames.forEach((name) => artboard
    //     .addController((payload.controllers..add(SimpleAnimation(name))).last));

    // Create state machines
    // final stateMachineNames = widget.stateMachines;

    t = widget.stateMachines.length;
    for (var i = 0; i < t; i++) {
      var name = widget.stateMachines[i];
      final controller = StateMachineController.fromArtboard(artboard, name);
      if (controller != null) {
        artboard.addController((payload.controllers..add(controller)).last);
      }
    }
    // stateMachineNames.forEach((name) {
    //   final controller = StateMachineController.fromArtboard(artboard, name);
    //   if (controller != null) {
    //     artboard.addController((payload.controllers..add(controller)).last);
    //   }
    // });

    // Add any user-created controllers
    t = widget.controllers.length;
    for (var i = 0; i < t; i++) {
      artboard.addController(widget.controllers[i]);
    }
    // widget.controllers.forEach(artboard.addController);

    // setState(() => _artboard = artboard);
    payload.artboard = artboard;

    // Call the onInit callback if provided
    widget.onInit?.call(artboard);
  }

  @override
  void dispose() {
    _payload?.onDispose(widget, this);
    _logr.log(() => 'DISPOSE > $ticker');
    super.dispose();
  }

  bool get _shouldAddHitTesting => _payload!.artboard!.animationControllers.any(
    (controller) =>
        controller is StateMachineController &&
        controller.hitComponents.isNotEmpty,
  );

  // @override
  // Widget build(BuildContext context) => _artboard != null
  //     ? Rive(
  //         artboard: _artboard!,
  //         fit: widget.fit ?? BoxFit.contain,
  //         alignment: widget.alignment ?? Alignment.center,
  //         antialiasing: widget.antialiasing,
  //         useArtboardSize: widget.useArtboardSize,
  //         clipRect: widget.clipRect,
  //         enablePointerEvents: _shouldAddHitTesting,
  //         behavior: widget.behavior,
  //         speedMultiplier: widget.speedMultiplier,
  //         isTouchScrollEnabled: widget.isTouchScrollEnabled,
  //       )
  //     : widget.placeHolder ?? const SizedBox();

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _configure(),
    initialData: false,
    builder: (context, snapshot) {
      if (snapshot.data == true) {
        if (_payload?.artboard == null) {
          throw StateError('payload artboard is null > $_payload');
        }
        return Rive(
          artboard: _payload!.artboard!,
          fit: widget.fit ?? BoxFit.contain,
          alignment: widget.alignment ?? Alignment.center,
          antialiasing: widget.antialiasing,
          useArtboardSize: widget.useArtboardSize,
          clipRect: widget.clipRect,
          enablePointerEvents: _shouldAddHitTesting,
          behavior: widget.behavior,
          speedMultiplier: widget.speedMultiplier,
          isTouchScrollEnabled: widget.isTouchScrollEnabled,
        );
      } else {
        return widget.placeHolder ?? const SizedBox();
      }
    }
  );
}
