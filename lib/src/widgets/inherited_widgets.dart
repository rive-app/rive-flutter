import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:rive_native/rive_native.dart' as rive;
import 'package:meta/meta.dart';

/// **EXPERIMENTAL**: This API may change or be removed in a future release.
@experimental
abstract class SharedTexturePainter {
  int get sharedDrawOrder;
  void paintIntoSharedTexture(rive.RenderTexture texture);
}

/// **EXPERIMENTAL**: This API may change or be removed in a future release.
@experimental
class SharedRenderTexture {
  final rive.RenderTexture texture;
  final double devicePixelRatio;
  final Color backgroundColor;
  final List<SharedTexturePainter> painters = [];
  final GlobalKey panelKey;

  bool _dirty = true;
  bool _scheduled = false;

  /// When true, [_paintShared] skips the clear→paint→flush cycle if no
  /// painter called [markDirty] since the last flush. When false (default),
  /// every scheduled paint runs the full cycle — identical to upstream.
  bool dirtyTrackingEnabled = false;

  /// When > 0 and [dirtyTrackingEnabled] is true, the render object's
  /// ticker automatically calls [markDirty] after this many seconds of
  /// accumulated frame time, so the state machine advances at the desired
  /// rate without being called every frame.
  double advanceInterval = 0;

  SharedRenderTexture({
    required this.texture,
    required this.devicePixelRatio,
    required this.backgroundColor,
    required this.panelKey,
  });

  /// Mark the texture as needing a repaint on the next scheduled frame.
  void markDirty() {
    _dirty = true;
  }

  /// Paint the shared render texture.
  ///
  /// When [dirtyTrackingEnabled] is true and the texture is clean, the entire
  /// clear→paint→flush cycle is skipped. The render-object ticker stays alive
  /// independently and calls [markDirty] when [advanceInterval] elapses, so
  /// the state machine still advances at the desired rate.
  void _paintShared(_) {
    _scheduled = false;
    if (dirtyTrackingEnabled && !_dirty) return;

    texture.clear(backgroundColor);
    for (final painter in painters) {
      painter.paintIntoSharedTexture(texture);
    }
    texture.flush(devicePixelRatio);
    _dirty = false;
  }

  /// Schedule a paint of the shared render texture.
  void schedulePaint() {
    if (_scheduled) {
      return;
    }
    _scheduled = true;
    SchedulerBinding.instance.addPostFrameCallback(_paintShared);
  }

  /// Add a painter to the shared render texture.
  void addPainter(SharedTexturePainter painter) {
    painters.add(painter);
    painters.sort((a, b) => a.sharedDrawOrder.compareTo(b.sharedDrawOrder));
    markDirty();
  }

  /// Remove a painter from the shared render texture.
  void removePainter(SharedTexturePainter painter) {
    painters.remove(painter);
    markDirty();
  }
}

/// Inherited widget that will pass the background render texture down the tree
///
/// **EXPERIMENTAL**: This API may change or be removed in a future release.
@experimental
class RiveSharedTexture extends InheritedWidget {
  late final SharedRenderTexture? texture;

  RiveSharedTexture({
    required super.child,
    required rive.RenderTexture? texture,
    required double devicePixelRatio,
    required Color backgroundColor,
    required GlobalKey panelKey,
    super.key,
  }) {
    this.texture = texture != null
        ? SharedRenderTexture(
            texture: texture,
            devicePixelRatio: devicePixelRatio,
            backgroundColor: backgroundColor,
            panelKey: panelKey,
          )
        : null;
  }

  static SharedRenderTexture? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RiveSharedTexture>()?.texture;

  static SharedRenderTexture? find(BuildContext context) =>
      context.findAncestorWidgetOfExactType<RiveSharedTexture>()?.texture;

  @override
  bool updateShouldNotify(RiveSharedTexture old) => texture != old.texture;
}
