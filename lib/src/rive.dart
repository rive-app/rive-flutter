import 'package:flutter/widgets.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_render_box.dart';
import 'package:rive/src/runtime_artboard.dart';

class Rive extends LeafRenderObjectWidget {
  /// Artboard used for drawing
  final Artboard artboard;

  /// Determines whether to use the inherent size of the [artboard], i.e. the
  /// absolute size defined by the artboard, or size the widget based on the
  /// available constraints only (sized by parent).
  ///
  /// Defaults to `false`, i.e. defaults to sizing based on the available
  /// constraints instead of the artboard size.
  ///
  /// When `true`, the artboard size is constrained by the parent constraints.
  /// Using the artboard size has the benefit that the widget now has an
  /// *intrinsic* size.
  ///
  /// When `false`, the intrinsic size is `(0, 0)` because
  /// there is no size intrinsically - it only comes from the parent
  /// constraints. Consequently, if you intend to use the widget in the subtree
  /// of an [IntrinsicWidth] or [IntrinsicHeight] widget or intend to directly
  /// obtain the [RenderBox.getMinIntrinsicWidth] et al., you will want to set
  /// this to `true`.
  final bool useArtboardSize;

  /// Fit for the rendering artboard
  final BoxFit fit;

  /// Alignment for the rendering artboard
  final Alignment alignment;

  /// Enables/disables antialiasing
  final bool antialiasing;

  const Rive({
    required this.artboard,
    this.useArtboardSize = false,
    this.antialiasing = true,
    BoxFit? fit,
    Alignment? alignment,
  })  : fit = fit ?? BoxFit.contain,
        alignment = alignment ?? Alignment.center;

  @override
  RenderObject createRenderObject(BuildContext context) {
    // Doing this here and not in constructor so it can remain const
    artboard.antialiasing = antialiasing;
    return RiveRenderObject(artboard as RuntimeArtboard)
      ..fit = fit
      ..alignment = alignment
      ..artboardSize = Size(artboard.width, artboard.height)
      ..useArtboardSize = useArtboardSize;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RiveRenderObject renderObject) {
    artboard.antialiasing = antialiasing;
    renderObject
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..artboardSize = Size(artboard.width, artboard.height)
      ..useArtboardSize = useArtboardSize;
  }
}

class RiveRenderObject extends RiveRenderBox {
  RuntimeArtboard _artboard;
  RiveRenderObject(this._artboard) {
    _artboard.redraw.addListener(scheduleRepaint);
  }

  RuntimeArtboard get artboard => _artboard;

  set artboard(Artboard value) {
    if (_artboard == value) {
      return;
    }
    _artboard.redraw.removeListener(scheduleRepaint);
    _artboard = value as RuntimeArtboard;
    _artboard.redraw.addListener(scheduleRepaint);
    markNeedsLayout();
  }

  @override
  void dispose() {
    super.dispose();
    _artboard.redraw.removeListener(scheduleRepaint);
  }

  @override
  AABB get aabb {
    var width = _artboard.width;
    var height = _artboard.height;
    return AABB.fromValues(0, 0, width, height);
  }

  @override
  bool advance(double elapsedSeconds) =>
      _artboard.advance(elapsedSeconds, nested: true);

  @override
  void beforeDraw(Canvas canvas, Offset offset) {
    canvas.clipRect(offset & size);
  }

  @override
  void draw(Canvas canvas, Mat2D viewTransform) {
    canvas.transform(viewTransform.mat4);
    artboard.draw(canvas);
  }
}
