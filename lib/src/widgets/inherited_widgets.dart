import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:rive_native/rive_native.dart' as rive;
import 'package:meta/meta.dart';

/// **EXPERIMENTAL**: This API may change or be removed in a future release.
@experimental
abstract class SharedTexturePainter {
  int get sharedDrawOrder;

  /// Paint into the shared [texture] using [elapsedSeconds] since the last
  /// shared-texture frame. Return `true` if the painter wants the shared
  /// ticker to keep advancing (animation still running), `false` if the
  /// painter is settled. The shared ticker stops when every painter reports
  /// `false`.
  bool paintIntoSharedTexture(rive.RenderTexture texture, double elapsedSeconds);
}

/// A shared render texture that multiple Rive painters can draw into.
///
/// Construct one externally with [SharedRenderTexture.create] to share a
/// single native texture across [RiveWidget]s that aren't ancestor/descendant
/// of each other (siblings, separate subtrees, across routes via a
/// Provider/Riverpod, etc.). Place the texture in the widget tree using
/// [RiveSurface] and attach painters by passing this instance to
/// [RiveWidget.sharedTexture].
///
/// The caller is responsible for [dispose]ing instances created via
/// [SharedRenderTexture.create].
///
/// **EXPERIMENTAL**: This API may change or be removed in a future release.
@experimental
class SharedRenderTexture {
  final rive.RenderTexture texture;
  double devicePixelRatio;
  Color backgroundColor;
  final List<SharedTexturePainter> painters = [];
  final GlobalKey panelKey;
  bool _ownsTexture = false;
  bool _disposed = false;

  SharedRenderTexture({
    required this.texture,
    required this.devicePixelRatio,
    required this.backgroundColor,
    required this.panelKey,
  });

  /// Create a user-owned [SharedRenderTexture] with its own underlying native
  /// texture. Use [RiveSurface] to place it in the widget tree, and pass this
  /// instance to [RiveWidget.sharedTexture] to attach painters from anywhere
  /// in the tree.
  ///
  /// Call [dispose] when you're done with it to release the native texture.
  factory SharedRenderTexture.create({
    Color backgroundColor = const Color(0x00000000),
    double devicePixelRatio = 1.0,
  }) {
    return SharedRenderTexture(
      texture: rive.RiveNative.instance.makeRenderTexture(),
      devicePixelRatio: devicePixelRatio,
      backgroundColor: backgroundColor,
      panelKey: GlobalKey(),
    ).._ownsTexture = true;
  }

  bool get isDisposed => _disposed;

  /// Whether the shared ticker is currently running.
  bool get isTickerActive => _ticker?.isActive ?? false;

  /// Release the underlying native texture. Only valid for instances created
  /// via [SharedRenderTexture.create]; instances constructed with an external
  /// [texture] should be disposed by whoever owns that texture.
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _ticker?.dispose();
    _ticker = null;
    painters.clear();
    if (_ownsTexture) {
      texture.dispose();
    }
  }

  // A single ticker drives every painter sharing this texture. Per-widget
  // tickers used to share the same paint pass, which meant one active painter
  // would re-call `advance` on settled siblings and accidentally revive their
  // tickers. Centralizing the ticker here means the loop stops as soon as no
  // painter still wants to advance.
  Ticker? _ticker;
  double _elapsedSeconds = 0;
  double _prevTickerElapsedInSeconds = 0;
  bool _scheduled = false;

  void _onTick(Duration duration) {
    final double tickerElapsedInSeconds =
        duration.inMicroseconds.toDouble() / Duration.microsecondsPerSecond;
    _elapsedSeconds = tickerElapsedInSeconds - _prevTickerElapsedInSeconds;
    _prevTickerElapsedInSeconds = tickerElapsedInSeconds;
    _paintShared(_elapsedSeconds);
  }

  /// Start the shared ticker if it isn't already running. Painters call this
  /// when they need a redraw (state machine input change, pointer event, new
  /// painter joining, etc.).
  void startTicker() {
    if (_disposed) return;
    _ticker ??= Ticker(_onTick);
    if (_ticker!.isActive) return;
    _elapsedSeconds = 0;
    _prevTickerElapsedInSeconds = 0;
    _ticker!.start();
  }

  /// Stop the shared ticker. Called automatically by [_paintShared] when no
  /// painter reports `shouldAdvance == true`.
  void stopTicker() {
    _elapsedSeconds = 0;
    _prevTickerElapsedInSeconds = 0;
    _ticker?.stop();
  }

  /// Paint the shared render texture.
  void _paintShared(double elapsedSeconds) {
    if (_disposed) return;
    if (painters.isEmpty) {
      // Nothing to draw — skip the clear/flush so a stale post-frame callback
      // (e.g. one queued before the last painter detached) cannot momentarily
      // blank the shared texture.
      stopTicker();
      return;
    }
    texture.clear(backgroundColor);
    bool anyShouldAdvance = false;
    for (final painter in painters) {
      if (painter.paintIntoSharedTexture(texture, elapsedSeconds)) {
        anyShouldAdvance = true;
      }
    }
    texture.flush(devicePixelRatio);
    if (anyShouldAdvance) {
      startTicker();
    } else {
      stopTicker();
    }
  }

  /// Schedule a one-shot paint of the shared render texture. Used when the
  /// scene visually needs to update but the ticker is idle — e.g. a painter
  /// scrolled or was just attached. Skipped if the ticker is already running
  /// since the next tick will redraw anyway.
  void schedulePaint() {
    if (_disposed || _scheduled || isTickerActive) {
      return;
    }
    _scheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      _paintShared(0);
    });
  }

  /// Add a painter to the shared render texture.
  void addPainter(SharedTexturePainter painter) {
    if (painters.contains(painter)) {
      return;
    }
    painters.add(painter);
    painters.sort((a, b) => a.sharedDrawOrder.compareTo(b.sharedDrawOrder));
    // Kick the ticker so the newly added painter shows up. _paintShared will
    // stop it again on the next pass if every painter is already settled.
    startTicker();
  }

  /// Remove a painter from the shared render texture.
  void removePainter(SharedTexturePainter painter) {
    if (!painters.remove(painter)) return;
    if (painters.isEmpty) {
      // Leave the last paint visible — clearing here would blank the texture
      // before whatever replaces this panel can render.
      stopTicker();
      return;
    }
    // The texture still holds the removed painter's last draw; kick a pass to
    // redraw without it.
    startTicker();
  }
}

/// Inherited widget that will pass the background render texture down the tree
///
/// **EXPERIMENTAL**: This API may change or be removed in a future release.
@experimental
class RiveSharedTexture extends InheritedWidget {
  final SharedRenderTexture? texture;

  const RiveSharedTexture({
    required super.child,
    required this.texture,
    super.key,
  });

  static SharedRenderTexture? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RiveSharedTexture>()?.texture;

  static SharedRenderTexture? find(BuildContext context) =>
      context.findAncestorWidgetOfExactType<RiveSharedTexture>()?.texture;

  @override
  bool updateShouldNotify(RiveSharedTexture old) =>
      !identical(texture, old.texture);
}
