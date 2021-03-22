import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

abstract class RiveRenderBox extends RenderBox {
  final Stopwatch _stopwatch = Stopwatch();
  BoxFit _fit = BoxFit.none;
  Alignment _alignment = Alignment.center;
  bool _useArtboardSize = false;

  bool get useArtboardSize => _useArtboardSize;

  set useArtboardSize(bool value) {
    if (_useArtboardSize == value) {
      return;
    }
    _useArtboardSize = value;
    if (parent != null) {
      markNeedsLayoutForSizedByParentChange();
    }
  }

  Size _artboardSize = Size.zero;

  Size get artboardSize => _artboardSize;

  set artboardSize(Size value) {
    if (_artboardSize == value) {
      return;
    }
    _artboardSize = value;
    if (parent != null) {
      markNeedsLayoutForSizedByParentChange();
    }
  }

  BoxFit get fit => _fit;

  set fit(BoxFit value) {
    if (value != _fit) {
      _fit = value;
      markNeedsPaint();
    }
  }

  Alignment get alignment => _alignment;

  set alignment(Alignment value) {
    if (value != _alignment) {
      _alignment = value;
      markNeedsPaint();
    }
  }

  @override
  bool get sizedByParent => !useArtboardSize;

  /// Finds the intrinsic size for the rive render box given the [constraints]
  /// and [sizedByParent].
  ///
  /// The difference between the intrinsic size returned here and the size we
  /// use for [performResize] is that the intrinsics contract does not allow
  /// infinite sizes, i.e. we cannot return biggest constraints.
  /// Consequently, the smallest constraint is returned in case we are
  /// [sizedByParent].
  Size _intrinsicSizeForConstraints(BoxConstraints constraints) {
    if (sizedByParent) {
      return constraints.smallest;
    }

    return constraints
        .constrainSizeAndAttemptToPreserveAspectRatio(artboardSize);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    assert(height >= 0.0);
    // If not sized by parent, this returns the constrained (trying to preserve
    // aspect ratio) artboard size.
    // If sized by parent, this returns 0 (because an infinite width does not
    // make sense as an intrinsic width and is therefore not allowed).
    return _intrinsicSizeForConstraints(
            BoxConstraints.tightForFinite(height: height))
        .width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(height >= 0.0);
    // This is equivalent to the min intrinsic width because we cannot provide
    // any greater intrinsic width beyond which increasing the width never
    // decreases the preferred height.
    // When we have an artboard size, the intrinsic min and max width are
    // obviously equivalent and if sized by parent, we can also only return the
    // smallest width constraint (which is 0 in the case of intrinsic width).
    return _intrinsicSizeForConstraints(
            BoxConstraints.tightForFinite(height: height))
        .width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(width >= 0.0);
    // If not sized by parent, this returns the constrained (trying to preserve
    // aspect ratio) artboard size.
    // If sized by parent, this returns 0 (because an infinite height does not
    // make sense as an intrinsic height and is therefore not allowed).
    return _intrinsicSizeForConstraints(
            BoxConstraints.tightForFinite(width: width))
        .height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(width >= 0.0);
    // This is equivalent to the min intrinsic height because we cannot provide
    // any greater intrinsic height beyond which increasing the height never
    // decreases the preferred width.
    // When we have an artboard size, the intrinsic min and max height are
    // obviously equivalent and if sized by parent, we can also only return the
    // smallest height constraint (which is 0 in the case of intrinsic height).
    return _intrinsicSizeForConstraints(
            BoxConstraints.tightForFinite(width: width))
        .height;
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void performLayout() {
    if (!sizedByParent) {
      // We can use the intrinsic size here because the intrinsic size matches
      // the constrained artboard size when not sized by parent.
      size = _intrinsicSizeForConstraints(constraints);
    }
  }

  @override
  bool hitTestSelf(Offset screenOffset) => true;

  @override
  void detach() {
    _stopwatch.stop();
    super.detach();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _stopwatch.start();
  }

  /// Get the Axis Aligned Bounding Box that encompasses the world space scene
  AABB get aabb;

  void draw(Canvas canvas, Mat2D viewTransform);

  void beforeDraw(Canvas canvas, Offset offset) {}

  void afterDraw(Canvas canvas, Offset offset) {}

  double _elapsedSeconds = 0;

  void _frameCallback(Duration duration) {
    _elapsedSeconds = _stopwatch.elapsedTicks / _stopwatch.frequency;
    _stopwatch.reset();
    _stopwatch.start();
    markNeedsPaint();
  }

  int _frameCallbackId = -1;

  void scheduleRepaint() {
    if (_frameCallbackId != -1) {
      return;
    }
    _frameCallbackId =
        SchedulerBinding.instance?.scheduleFrameCallback(_frameCallback) ?? -1;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _frameCallbackId = -1;
    if (advance(_elapsedSeconds)) {
      scheduleRepaint();
    } else {
      _stopwatch.stop();
    }
    _elapsedSeconds = 0;

    final Canvas canvas = context.canvas;

    AABB bounds = aabb;

    double contentWidth = bounds[2] - bounds[0];
    double contentHeight = bounds[3] - bounds[1];

    if (contentWidth == 0 || contentHeight == 0) {
      return;
    }
    double x = -1 * bounds[0] -
        contentWidth / 2.0 -
        (_alignment.x * contentWidth / 2.0);
    double y = -1 * bounds[1] -
        contentHeight / 2.0 -
        (_alignment.y * contentHeight / 2.0);

    double scaleX = 1.0, scaleY = 1.0;

    canvas.save();
    beforeDraw(canvas, offset);

    switch (_fit) {
      case BoxFit.fill:
        scaleX = size.width / contentWidth;
        scaleY = size.height / contentHeight;
        break;
      case BoxFit.contain:
        double minScale =
            min(size.width / contentWidth, size.height / contentHeight);
        scaleX = scaleY = minScale;
        break;
      case BoxFit.cover:
        double maxScale =
            max(size.width / contentWidth, size.height / contentHeight);
        scaleX = scaleY = maxScale;
        break;
      case BoxFit.fitHeight:
        double minScale = size.height / contentHeight;
        scaleX = scaleY = minScale;
        break;
      case BoxFit.fitWidth:
        double minScale = size.width / contentWidth;
        scaleX = scaleY = minScale;
        break;
      case BoxFit.none:
        scaleX = scaleY = 1.0;
        break;
      case BoxFit.scaleDown:
        double minScale =
            min(size.width / contentWidth, size.height / contentHeight);
        scaleX = scaleY = minScale < 1.0 ? minScale : 1.0;
        break;
    }

    Mat2D transform = Mat2D();
    transform[4] =
        offset.dx + size.width / 2.0 + (_alignment.x * size.width / 2.0);
    transform[5] =
        offset.dy + size.height / 2.0 + (_alignment.y * size.height / 2.0);
    Mat2D.scale(transform, transform, Vec2D.fromValues(scaleX, scaleY));
    Mat2D center = Mat2D();
    center[4] = x;
    center[5] = y;
    Mat2D.multiply(transform, transform, center);

    canvas.translate(
      offset.dx + size.width / 2.0 + (_alignment.x * size.width / 2.0),
      offset.dy + size.height / 2.0 + (_alignment.y * size.height / 2.0),
    );

    canvas.scale(scaleX, scaleY);
    canvas.translate(x, y);

    draw(canvas, transform);

    canvas.restore();
    afterDraw(canvas, offset);
  }

  /// Advance animations, physics, etc by elapsedSeconds, returns true if it
  /// wants to run again.
  bool advance(double elapsedSeconds);
}
