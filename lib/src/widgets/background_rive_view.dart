import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:rive/src/painters/background_widget_controller_stub.dart'
    if (dart.library.ffi) 'package:rive/src/painters/background_widget_controller.dart';

/// A Flutter widget that composites Rive content rendered by a C++ background
/// thread.
///
/// Unlike [RiveWidget], this widget never calls `advanceAndApply` or `draw`
/// on the Flutter UI thread. Instead it:
///
/// 1. After first layout, calls [BackgroundRiveWidgetController.initialize]
///    to start the native [ThreadedScene] and register a Flutter GPU texture.
/// 2. Runs a [Ticker] that calls [controller.advance] each frame, posting
///    elapsed time to the background thread (non-blocking).
/// 3. Composites the texture written by the background thread via Flutter's
///    [Texture] widget — a ~zero-cost GPU blit with no pixel copy.
///
/// ## Snapshot and event polling
///
/// This widget does not poll snapshots or events internally. The caller (e.g.
/// `CharacterRig`) should call [controller.acquireSnapshot] and
/// [controller.pollEvents] from its own per-frame logic, typically from an
/// [addPostFrameCallback] registered in the enclosing widget's state.
///
/// ## Platform support
///
/// Background rendering requires Metal (iOS / macOS). On other platforms
/// [BackgroundRiveWidgetController.initialize] returns false and this widget
/// shows a transparent [SizedBox].
class BackgroundRiveView extends StatefulWidget {
  const BackgroundRiveView({
    super.key,
    required this.controller,
    this.freeze = false,
  });

  /// The controller that owns the background thread and ViewModel interactions.
  final BackgroundRiveWidgetController controller;

  /// When true, Flutter will not request new frames from the texture even when
  /// the GPU content changes. Useful for pausing without disposing.
  final bool freeze;

  @override
  State<BackgroundRiveView> createState() => _BackgroundRiveViewState();
}

class _BackgroundRiveViewState extends State<BackgroundRiveView>
    with SingleTickerProviderStateMixin {
  Ticker? _ticker;
  bool _initialized = false;
  Duration _prevDuration = Duration.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryInitialize());
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _ticker = null;
    super.dispose();
  }

  Future<void> _tryInitialize() async {
    if (!mounted || _initialized) return;

    final renderBox = context.findRenderObject();
    if (renderBox is! RenderBox || !renderBox.hasSize) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryInitialize());
      return;
    }

    final size = renderBox.size;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final w = (size.width * dpr).round();
    final h = (size.height * dpr).round();

    if (w <= 0 || h <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryInitialize());
      return;
    }

    final success = await widget.controller.initialize(
      width: w,
      height: h,
      devicePixelRatio: dpr,
    );

    if (!mounted || !success) return;

    _initialized = true;
    _ticker = createTicker(_onTick)..start();
    setState(() {});
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _prevDuration;
    _prevDuration = elapsed;
    final elapsedSeconds =
        dt.inMicroseconds / Duration.microsecondsPerSecond;

    widget.controller.advance(elapsedSeconds);
    setState(() {}); // trigger repaint to composite the latest GPU texture
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const SizedBox.expand();
    }
    return Texture(
      textureId: widget.controller.renderTexture.textureId,
      freeze: widget.freeze,
    );
  }
}
