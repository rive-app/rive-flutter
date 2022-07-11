import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
T? _ambiguate<T>(T? value) => value;

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

  // Override this to false if you don't want the local offset applied to the
  // view transform passed to the draw method.
  bool get offsetViewTransform => true;

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
    _frameCallbackId = _ambiguate(SchedulerBinding.instance)
            ?.scheduleFrameCallback(_frameCallback) ??
        -1;
  }

  /// Override this if you want to do custom viewTransform alignment. This will
  /// be called after advancing. Return true to prevent regular paint.
  bool customPaint(PaintingContext context, Offset offset) => false;

  Vec2D globalToArtboard(Offset globalPosition) {
    var local = globalToLocal(globalPosition);
    var alignArtboard = computeAlignment();
    var localToArtboard = Mat2D();
    var localAsVec = Vec2D.fromValues(local.dx, local.dy);
    if (!Mat2D.invert(localToArtboard, alignArtboard)) {
      return localAsVec;
    }
    return Vec2D.transformMat2D(Vec2D(), localAsVec, localToArtboard);
  }

  Mat2D computeAlignment([Offset offset = Offset.zero]) {
    AABB frame = AABB.fromValues(
        offset.dx, offset.dy, offset.dx + size.width, offset.dy + size.height);
    AABB content = aabb;

    double contentWidth = content[2] - content[0];
    double contentHeight = content[3] - content[1];

    if (contentWidth == 0 || contentHeight == 0) {
      return Mat2D();
    }

    double x = -1 * content[0] -
        contentWidth / 2.0 -
        (_alignment.x * contentWidth / 2.0);
    double y = -1 * content[1] -
        contentHeight / 2.0 -
        (_alignment.y * contentHeight / 2.0);

    double scaleX = 1.0, scaleY = 1.0;

    switch (_fit) {
      case BoxFit.fill:
        scaleX = frame.width / contentWidth;
        scaleY = frame.height / contentHeight;
        break;
      case BoxFit.contain:
        double minScale =
            min(frame.width / contentWidth, frame.height / contentHeight);
        scaleX = scaleY = minScale;
        break;
      case BoxFit.cover:
        double maxScale =
            max(frame.width / contentWidth, frame.height / contentHeight);
        scaleX = scaleY = maxScale;
        break;
      case BoxFit.fitHeight:
        double minScale = frame.height / contentHeight;
        scaleX = scaleY = minScale;
        break;
      case BoxFit.fitWidth:
        double minScale = frame.width / contentWidth;
        scaleX = scaleY = minScale;
        break;
      case BoxFit.none:
        scaleX = scaleY = 1.0;
        break;
      case BoxFit.scaleDown:
        double minScale =
            min(frame.width / contentWidth, frame.height / contentHeight);
        scaleX = scaleY = minScale < 1.0 ? minScale : 1.0;
        break;
    }

    Mat2D transform = Mat2D();

    transform[4] = frame.width / 2.0 + (_alignment.x * frame.width / 2.0);
    transform[5] = frame.height / 2.0 + (_alignment.y * frame.height / 2.0);
    if (offsetViewTransform) {
      transform[4] += offset.dx;
      transform[5] += offset.dy;
    }
    Mat2D.scale(transform, transform, Vec2D.fromValues(scaleX, scaleY));
    Mat2D center = Mat2D();
    center[4] = x;
    center[5] = y;
    Mat2D.multiply(transform, transform, center);
    return transform;
  }

  @protected
  @override
  void paint(PaintingContext context, Offset offset) {
    _frameCallbackId = -1;
    if (advance(_elapsedSeconds)) {
      scheduleRepaint();
    } else {
      _stopwatch.stop();
    }
    _elapsedSeconds = 0;

    if (customPaint(context, offset)) {
      return;
    }

    final Canvas canvas = context.canvas;

    canvas.save();
    beforeDraw(canvas, offset);

    var transform = computeAlignment(offset);

    draw(canvas, transform);

    canvas.restore();
    afterDraw(canvas, offset);
  }

  /// Advance animations, physics, etc by elapsedSeconds, returns true if it
  /// wants to run again.
  bool advance(double elapsedSeconds);
}
