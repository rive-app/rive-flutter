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

  /// Release the underlying native texture. Only valid for instances created
  /// via [SharedRenderTexture.create]; instances constructed with an external
  /// [texture] should be disposed by whoever owns that texture.
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    painters.clear();
    if (_ownsTexture) {
      texture.dispose();
    }
  }

  /// Paint the shared render texture.
  void _paintShared(_) {
    _scheduled = false;
    if (_disposed || painters.isEmpty) {
      // Nothing to draw — skip the clear/flush so a stale post-frame callback
      // (e.g. one queued before the last painter detached) cannot momentarily
      // blank the shared texture.
      return;
    }
    texture.clear(backgroundColor);
    for (final painter in painters) {
      painter.paintIntoSharedTexture(texture);
    }
    texture.flush(devicePixelRatio);
  }

  bool _scheduled = false;

  /// Schedule a paint of the shared render texture.
  void schedulePaint() {
    if (_scheduled || _disposed) {
      return;
    }
    _scheduled = true;
    SchedulerBinding.instance.addPostFrameCallback(_paintShared);
  }

  /// Add a painter to the shared render texture.
  void addPainter(SharedTexturePainter painter) {
    if (painters.contains(painter)) {
      return;
    }
    painters.add(painter);
    painters.sort((a, b) => a.sharedDrawOrder.compareTo(b.sharedDrawOrder));
  }

  /// Remove a painter from the shared render texture.
  void removePainter(SharedTexturePainter painter) {
    painters.remove(painter);
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
