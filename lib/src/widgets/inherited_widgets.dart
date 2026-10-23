import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:rive_native/rive_deferred.dart' as rive_deferred;
import 'package:rive_native/rive_native.dart' as rive;

abstract class SharedTexturePainter {
  int get sharedDrawOrder;

  /// The factory the painted content was made with, so the shared paint
  /// pass can attach its recording session. Null when there is none.
  rive.Factory? get riveFactory => null;

  /// Advance by [elapsedSeconds] since the last shared-texture frame. Return
  /// `true` if the painter wants the shared ticker to keep advancing
  /// (animation still running), `false` if the painter is settled. The shared
  /// ticker stops when every painter reports `false`.
  bool advanceSharedTexture(double elapsedSeconds);

  /// Whether the last [advanceSharedTexture] changed what this painter draws.
  /// A pass draws only when this is true for at least one painter.
  bool get needsSharedPaint => true;

  /// Paint the current state into the shared [texture]. Does not advance.
  void paintIntoSharedTexture(rive.RenderTexture texture);
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
class SharedRenderTexture {
  final rive.RenderTexture texture;
  double devicePixelRatio;

  Color get backgroundColor => _backgroundColor;
  Color _backgroundColor;
  set backgroundColor(Color value) {
    if (_backgroundColor == value) {
      return;
    }
    _backgroundColor = value;
    schedulePaint();
  }

  /// When the shared texture is redrawn. With
  /// [rive.DrawOptimization.drawWhenChanged] a pass draws only when one of
  /// its painters changed, and then redraws every painter.
  rive.DrawOptimization get drawOptimization => _drawOptimization;
  rive.DrawOptimization _drawOptimization;
  set drawOptimization(rive.DrawOptimization value) {
    if (_drawOptimization == value) {
      return;
    }
    _drawOptimization = value;
    schedulePaint();
  }

  final List<SharedTexturePainter> painters = [];
  // Attach sequence per painter: the tie-break for equal [sharedDrawOrder]s.
  // List.sort makes no stability guarantee, so without an explicit tie-break
  // a re-sort could shuffle painters sharing a draw order (every painter
  // defaults to 1). Attach order follows widget-tree order, matching how
  // Flutter stacks siblings by default.
  final Map<SharedTexturePainter, int> _attachSequence = {};
  int _nextAttachSequence = 0;
  final GlobalKey panelKey;
  bool _ownsTexture = false;
  bool _disposed = false;

  SharedRenderTexture({
    required this.texture,
    required this.devicePixelRatio,
    required Color backgroundColor,
    required this.panelKey,
    rive.DrawOptimization drawOptimization =
        rive.DrawOptimization.drawWhenChanged,
  })  : _backgroundColor = backgroundColor,
        _drawOptimization = drawOptimization {
    texture.addTextureChangedListener(_onTextureChanged);
  }

  // Redraw the painters when the texture is recreated, so the new texture has
  // content before it's shown. Draw straight away when we're called outside a
  // frame.
  void _onTextureChanged() {
    _forceDraw = true;
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks) {
      _paintShared(0);
    } else {
      schedulePaint();
    }
  }

  /// Create a user-owned [SharedRenderTexture] with its own underlying native
  /// texture. Use [RiveSurface] to place it in the widget tree, and pass this
  /// instance to [RiveWidget.sharedTexture] to attach painters from anywhere
  /// in the tree.
  ///
  /// Call [dispose] when you're done with it to release the native texture.
  factory SharedRenderTexture.create({
    Color backgroundColor = const Color(0x00000000),
    double devicePixelRatio = 1.0,
    rive.DrawOptimization drawOptimization =
        rive.DrawOptimization.drawWhenChanged,
  }) {
    return SharedRenderTexture(
      texture: rive.RiveNative.instance.makeRenderTexture(),
      devicePixelRatio: devicePixelRatio,
      backgroundColor: backgroundColor,
      panelKey: GlobalKey(),
      drawOptimization: drawOptimization,
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
    _attachSequence.clear();
    texture.removeTextureChangedListener(_onTextureChanged);
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
  double _prevTickerElapsedInSeconds = 0;
  bool _scheduled = false;

  /// Whether the next pass draws even when no painter changed: the painter
  /// set, their order or the texture changed, or a paint was requested.
  bool _forceDraw = true;

  void _onTick(Duration duration) {
    final double tickerElapsedInSeconds =
        duration.inMicroseconds.toDouble() / Duration.microsecondsPerSecond;
    final double elapsedSeconds =
        tickerElapsedInSeconds - _prevTickerElapsedInSeconds;
    _prevTickerElapsedInSeconds = tickerElapsedInSeconds;
    // Draw post-frame, not here: the ticker runs before layout, so painting now
    // would use last frame's transforms and the content lags the panel.
    _schedulePaintPass(elapsedSeconds);
  }

  /// Start the shared ticker if it isn't already running. Painters call this
  /// when they need a redraw (state machine input change, pointer event, new
  /// painter joining, etc.).
  void startTicker() {
    if (_disposed) return;
    _ticker ??= Ticker(_onTick);
    if (_ticker!.isActive) return;
    _prevTickerElapsedInSeconds = 0;
    _ticker!.start();
  }

  /// Stop the shared ticker. Called automatically by [_paintShared] when no
  /// painter reports `shouldAdvance == true`.
  void stopTicker() {
    _prevTickerElapsedInSeconds = 0;
    _ticker?.stop();
  }

  /// Attach the painters' recording session - a sessionless texture draws
  /// nothing on native. Runs every pass: the texture dedupes by session
  /// address and drops that cache on recreation, so the re-attach is what
  /// makes recreation self-healing.
  void _ensureDeferredSession() {
    for (final painter in painters) {
      final factory = painter.riveFactory;
      if (factory == null ||
          !rive_deferred.deferredAutoAttach(factory) ||
          // Bound sessions (web's per-file) cannot serve a shared texture.
          rive_deferred.deferredBoundToOneTexture(factory)) {
        continue;
      }
      texture.useDeferredSession(factory);
      return;
    }
  }

  /// Paint the shared render texture. [elapsedSeconds] is the time this pass
  /// ticked; time banked by earlier gated passes is added here, so a pause
  /// drops only its own tick.
  void _paintShared(double elapsedSeconds) {
    if (_disposed) return;
    if (painters.isEmpty) {
      // Nothing to draw — skip the clear/flush so a stale post-frame callback
      // (e.g. one queued before the last painter detached) cannot momentarily
      // blank the shared texture.
      _bankedElapsed = 0;
      stopTicker();
      return;
    }
    // Attach first: canAcceptDeferredFrame reads the attached session.
    _ensureDeferredSession();
    if (texture.deferredPaused) {
      // Nothing may record while paused, and paused time is dropped, not
      // banked: a pause can span seconds (iOS backgrounding), and banking it
      // would fast-forward the animation by the whole span on resume
      // instead of freezing it. Keep ticking to notice the resume. Time
      // banked before the pause is kept: that frame was gated, not paused,
      // and still owes its advance.
      startTicker();
      return;
    }
    if (!texture.canAcceptDeferredFrame) {
      // The replay worker is behind (a recorded frame can never be
      // dropped). Bank the time and retry so pacing changes cadence, never
      // animation speed.
      _bankedElapsed += elapsedSeconds;
      startTicker();
      return;
    }
    elapsedSeconds += _bankedElapsed;
    _bankedElapsed = 0;
    // Advance before clearing so the draw decision sees this frame's
    // changes.
    var anyShouldAdvance = false;
    for (final painter in painters) {
      if (painter.advanceSharedTexture(elapsedSeconds)) {
        anyShouldAdvance = true;
      }
    }
    // Checked once every painter advanced: a later advance can change an
    // earlier painter's artboard (a shared view model instance).
    final draw = _forceDraw ||
        _drawOptimization == rive.DrawOptimization.alwaysDraw ||
        painters.any((painter) => painter.needsSharedPaint);
    if (!draw) {
      // The texture keeps showing the last pass.
      if (anyShouldAdvance) {
        startTicker();
      } else {
        stopTicker();
      }
      return;
    }
    if (!texture.clear(backgroundColor)) {
      // A failed clear can be permanent (refused context, no session): stop
      // rather than spin. Recreation repaints via the texture-changed
      // listener. The painters already advanced, so nothing is banked.
      stopTicker();
      return;
    }
    // Cleared first so a request raised while painting survives.
    _forceDraw = false;
    for (final painter in painters) {
      painter.paintIntoSharedTexture(texture);
    }
    texture.flush(devicePixelRatio);
    if (anyShouldAdvance) {
      startTicker();
    } else {
      stopTicker();
    }
  }

  // Elapsed accumulated for the next coalesced pass, so no tick's delta is lost
  // when requests coalesce.
  /// Time from passes the gates skipped, replayed by the next pass that
  /// advances. Separate from the ticker's own accumulator so a paused pass can
  /// drop its tick without dropping this.
  double _bankedElapsed = 0;

  /// Time ticked since the last pass ran, coalesced across ticks.
  double _tickElapsed = 0;

  /// Schedules a paint for after this frame's layout (so painters read the same
  /// transforms the panel composites against). Ticker and one-shot requests
  /// both funnel through here, coalesced into a single post-frame pass.
  void _schedulePaintPass(double elapsedSeconds) {
    if (_disposed) {
      return;
    }
    _tickElapsed += elapsedSeconds;
    if (_scheduled) {
      return;
    }
    _scheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      final elapsed = _tickElapsed;
      _tickElapsed = 0;
      _paintShared(elapsed);
    });
  }

  /// Schedule a one-shot paint of the shared render texture. Used when the
  /// scene visually needs to update — e.g. a painter scrolled, resized, or was
  /// just attached.
  void schedulePaint() {
    _forceDraw = true;
    _schedulePaintPass(0);
    // The pass runs post-frame, so a request while idle needs a frame.
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  void _sortPainters() {
    painters.sort((a, b) {
      final byDrawOrder = a.sharedDrawOrder.compareTo(b.sharedDrawOrder);
      if (byDrawOrder != 0) {
        return byDrawOrder;
      }
      return _attachSequence[a]!.compareTo(_attachSequence[b]!);
    });
  }

  /// Re-sort [painters] and repaint. Painters must call this when their
  /// [SharedTexturePainter.sharedDrawOrder] changes while attached — the list
  /// is otherwise only sorted when a painter is added.
  void painterOrderChanged() {
    if (_disposed) {
      return;
    }
    _sortPainters();
    schedulePaint();
  }

  /// Add a painter to the shared render texture.
  void addPainter(SharedTexturePainter painter) {
    if (painters.contains(painter)) {
      return;
    }
    _attachSequence[painter] = _nextAttachSequence++;
    painters.add(painter);
    _sortPainters();
    _forceDraw = true;
    // Kick the ticker so the newly added painter shows up. _paintShared will
    // stop it again on the next pass if every painter is already settled.
    startTicker();
  }

  /// Remove a painter from the shared render texture.
  void removePainter(SharedTexturePainter painter) {
    if (!painters.remove(painter)) return;
    _attachSequence.remove(painter);
    if (painters.isEmpty) {
      // Leave the last paint visible — clearing here would blank the texture
      // before whatever replaces this panel can render.
      stopTicker();
      return;
    }
    // The texture still holds the removed painter's last draw; kick a pass to
    // redraw without it.
    _forceDraw = true;
    startTicker();
  }
}

/// Inherited widget that will pass the background render texture down the tree
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
