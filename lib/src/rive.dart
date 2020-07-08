import 'package:flutter/widgets.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_render_box.dart';
import 'package:rive/src/runtime_artboard.dart';

class Rive extends LeafRenderObjectWidget {
  final Artboard artboard;
  final bool useIntrinsicSize;
  final BoxFit fit;
  final Alignment alignment;

  const Rive({
    @required this.artboard,
    this.useIntrinsicSize = false,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RiveRenderObject()
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..useIntrinsicSize = useIntrinsicSize;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RiveRenderObject renderObject) {
    renderObject
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..useIntrinsicSize = useIntrinsicSize;
  }

  @override
  void didUnmountRenderObject(covariant RiveRenderObject renderObject) {
    renderObject.dispose();
  }
}

class RiveRenderObject extends RiveRenderBox {
  RuntimeArtboard _artboard;
  RuntimeArtboard get artboard => _artboard;
  set artboard(Artboard value) {
    if (_artboard == value) {
      return;
    }
    _artboard?.redraw?.removeListener(scheduleRepaint);
    _artboard = value as RuntimeArtboard;
    _artboard?.redraw?.addListener(scheduleRepaint);
    markNeedsLayout();
  }

  void dispose() {
    _artboard?.redraw?.removeListener(scheduleRepaint);
  }

  @override
  AABB get aabb {
    var width = _artboard.width;
    var height = _artboard.height;
    double minX = -1 * _artboard.originX * width;
    double minY = -1 * _artboard.originY * height;
    return AABB.fromValues(minX, minY, minX + width, minY + height);
  }

  @override
  bool advance(double elapsedSeconds) => _artboard.advance(elapsedSeconds);

  @override
  void beforeDraw(Canvas canvas, Offset offset) {
    canvas.clipRect(offset & size);
  }

  @override
  void draw(Canvas canvas, Mat2D viewTransform) {
    artboard.draw(canvas);
  }
}
