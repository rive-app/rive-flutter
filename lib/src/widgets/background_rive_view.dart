import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:rive/src/painters/background_widget_controller.dart';

/// A Flutter widget that composites Rive content rendered by a C++ background
/// thread.
///
/// Unlike [RiveWidget], this widget never calls `advanceAndApply` or
/// `draw` on the Flutter UI thread. Instead it:
///
/// 1. Calls [BackgroundRiveWidgetController.initialize] with the physical pixel
///    size of its layout slot.
/// 2. Starts a [Ticker] that calls [BackgroundRiveWidgetController.advance]
///    each frame, posting elapsed time to the background thread.
/// 3. Composites the GPU texture written by the background thread via Flutter's
///    [Texture] widget — a ~zero-cost blit.
///
/// ## Snapshot and event polling
///
/// [BackgroundRiveView] does not poll snapshots or events internally. The
/// caller (e.g., `CharacterRig`) should call
/// [BackgroundRiveWidgetController.acquireSnapshot] and
/// [BackgroundRiveWidgetController.pollEvents] from their own per-frame logic
/// (e.g., registered via `addPostFrameCallback` or a separate ticker).
///
/// ## Platform support
///
/// Background rendering requires Metal (iOS / macOS). On other platforms
/// [BackgroundRiveWidgetController.initialize] returns false and this widget
/// shows a transparent box.
class BackgroundRiveView extends StatefulWidget {
  const BackgroundRiveView({
    super.key,
    required this.controller,
    this.freeze = false,
  });

  /// The controller that manages the background thread and ViewModel inputs.
  final BackgroundRiveWidgetController controller;

  /// When true, Flutter will not request new frames from the texture even when
  /// the texture changes. Useful for pausing the animation without disposing.
  final bool freeze;

  @override
  State<BackgroundRiveView> createState() => _BackgroundRiveViewState();
}

class _BackgroundRiveViewState extends State<BackgroundRiveView>
    with SingleTickerProviderStateMixin {
  Ticker? _ticker;

  /// True once [BackgroundRiveWidgetController.initialize] has succeeded.
  bool _initialized = false;

  /// Elapsed seconds between the last two ticker callbacks. Updated in
  /// [_onTick] and posted to [BackgroundRiveWidgetController.advance].
  double _elapsedSeconds = 0;
  Duration _prevDuration = Duration.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-initialize if the device pixel ratio changed and we haven't started.
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

  void _tryInitialize() {
    if (!mounted || _initialized) return;

    final renderBox = context.findRenderObject();
    if (renderBox is! RenderBox || !renderBox.hasSize) {
      // Layout hasn't run yet; retry next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryInitialize());
      return;
    }

    final dpr = MediaQuery.devicePixelRatioOf(context);
    final logicalSize = renderBox.size;
    final physicalWidth = (logicalSize.width * dpr).round();
    final physicalHeight = (logicalSize.height * dpr).round();

    if (physicalWidth <= 0 || physicalHeight <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryInitialize());
      return;
    }

    final success = widget.controller.initialize(
      width: physicalWidth,
      height: physicalHeight,
    );

    if (!success) return; // Non-Metal platform or Phase 2 not yet available.

    _initialized = true;

    _ticker = createTicker(_onTick)..start();

    setState(() {}); // Rebuild to show the Texture widget.
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _prevDuration;
    _prevDuration = elapsed;
    _elapsedSeconds = dt.inMicroseconds / Duration.microsecondsPerSecond;

    widget.controller.advance(_elapsedSeconds);

    // Request a repaint so Flutter composites the latest background texture.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const SizedBox.expand();
    }
    return Texture(
      textureId: widget.controller.textureId,
      freeze: widget.freeze,
    );
  }
}
