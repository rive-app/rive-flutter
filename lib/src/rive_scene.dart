import 'package:flutter/widgets.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_render_box.dart';

/// An abstraction for controlling the composition and rendering of a Rive
/// scene.
abstract class RiveSceneController {
  /// Whether the draw callback's view transform should be translated by the
  /// rendering widgets local offset.
  bool get offsetViewTransform => false;

  /// SceneController uses this to notify that it needs to be re-drawn.
  ChangeNotifier get redraw;

  // Tells the Scene how to align the area nesessary to display the contents.
  Size get size;

  /// Called by the scene, return true to keep advancing or false to stop.
  bool advance(double elapsedSeconds);

  /// Called by the scene to draw the contents.
  void draw(Canvas canvas, Mat2D viewTransform);
}

/// A widget that interfaces with a RiveSceneController to compose and render a
/// scene of Rive artboards.
class RiveScene extends LeafRenderObjectWidget {
  /// The controller for the Rive scene.
  final RiveSceneController controller;

  /// Fit for the rendering artboard
  final BoxFit fit;

  /// Alignment for the rendering artboard
  final Alignment alignment;

  const RiveScene({
    required this.controller,
    BoxFit? fit,
    Alignment? alignment,
    Key? key,
  })  : fit = fit ?? BoxFit.contain,
        alignment = alignment ?? Alignment.center,
        super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RiveSceneRenderObject(controller)
      ..fit = fit
      ..alignment = alignment;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RiveSceneRenderObject renderObject) {
    renderObject
      ..controller = controller
      ..fit = fit
      ..alignment = alignment;
  }
}

class RiveSceneRenderObject extends RiveRenderBox {
  RiveSceneController _controller;
  RiveSceneRenderObject(this._controller) {
    _controller.redraw.addListener(scheduleRepaint);
  }

  RiveSceneController get controller => _controller;

  set controller(RiveSceneController value) {
    if (_controller == value) {
      return;
    }
    _controller.redraw.removeListener(scheduleRepaint);
    _controller = value;
    _controller.redraw.addListener(scheduleRepaint);
    markNeedsLayout();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.redraw.removeListener(scheduleRepaint);
  }

  @override
  AABB get aabb {
    var width = _controller.size.width;
    var height = _controller.size.height;
    return AABB.fromValues(0, 0, width, height);
  }

  @override
  bool advance(double elapsedSeconds) => _controller.advance(elapsedSeconds);

  @override
  void beforeDraw(Canvas canvas, Offset offset) {
    canvas.clipRect(offset & size);
  }

  @override
  void draw(Canvas canvas, Mat2D viewTransform) {
    _controller.draw(canvas, viewTransform);
  }

  @override
  bool get offsetViewTransform => _controller.offsetViewTransform;
}
