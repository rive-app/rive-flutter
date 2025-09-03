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

  SharedRenderTexture({
    required this.texture,
    required this.devicePixelRatio,
    required this.backgroundColor,
    required this.panelKey,
  });

  /// Paint the shared render texture.
  void _paintShared(_) {
    texture.clear(backgroundColor);
    for (final painter in painters) {
      painter.paintIntoSharedTexture(texture);
    }
    texture.flush(devicePixelRatio);

    _scheduled = false;
  }

  bool _scheduled = false;

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
