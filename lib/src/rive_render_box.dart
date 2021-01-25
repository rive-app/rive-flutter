import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

abstract class RiveRenderBox extends RenderBox {
  final Stopwatch _stopwatch = Stopwatch();
  BoxFit _fit;
  Alignment _alignment;
  bool _useIntrinsicSize = false;

  bool get useIntrinsicSize => _useIntrinsicSize;
  set useIntrinsicSize(bool value) {
    if (_useIntrinsicSize == value) {
      return;
    }
    _useIntrinsicSize = value;
    if (parent != null) {
      markNeedsLayoutForSizedByParentChange();
    }
  }

  Size _intrinsicSize;
  Size get intrinsicSize => _intrinsicSize;
  set intrinsicSize(Size value) {
    if (_intrinsicSize == value) {
      return;
    }
    _intrinsicSize = value;
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
  bool get sizedByParent => !_useIntrinsicSize || _intrinsicSize == null;

  @override
  void performLayout() {
    if (!sizedByParent) {
      size = constraints
        .constrainSizeAndAttemptToPreserveAspectRatio(_intrinsicSize);
    }
  }

  @override
  bool hitTestSelf(Offset screenOffset) => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void detach() {
    _stopwatch.stop();
    super.detach();
  }

  @override
  void attach(PipelineOwner owner) {
    _stopwatch.start();
    super.attach(owner);
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

  int _frameCallbackId;
  void scheduleRepaint() {
    if (_frameCallbackId != null) {
      return;
    }
    _frameCallbackId =
        SchedulerBinding.instance.scheduleFrameCallback(_frameCallback);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _frameCallbackId = null;
    if (advance(_elapsedSeconds)) {
      scheduleRepaint();
    } else {
      _stopwatch.stop();
    }
    _elapsedSeconds = 0;

    final Canvas canvas = context.canvas;

    AABB bounds = aabb;
    if (bounds != null) {
      double contentWidth = bounds[2] - bounds[0];
      double contentHeight = bounds[3] - bounds[1];
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
  }

  /// Advance animations, physics, etc by elapsedSeconds, returns true if it
  /// wants to run again.
  bool advance(double elapsedSeconds);
}
