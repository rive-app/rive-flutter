import 'package:flutter/material.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/generated/shapes/paint/stroke_base.dart';
export 'package:rive/src/generated/shapes/paint/stroke_base.dart';

class Stroke extends StrokeBase {
  @override
  Paint makePaint() => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = strokeCap
    ..strokeJoin = strokeJoin
    ..strokeWidth = thickness;
  @override
  String get timelineParentGroup => 'strokes';
  StrokeCap get strokeCap => StrokeCap.values[cap];
  set strokeCap(StrokeCap value) => cap = value.index;
  StrokeJoin get strokeJoin => StrokeJoin.values[join];
  set strokeJoin(StrokeJoin value) => join = value.index;
  @override
  void capChanged(int from, int to) {
    paint.strokeCap = StrokeCap.values[to];
    parent?.addDirt(ComponentDirt.paint);
  }

  @override
  void joinChanged(int from, int to) {
    paint.strokeJoin = StrokeJoin.values[to];
    parent?.addDirt(ComponentDirt.paint);
  }

  @override
  void thicknessChanged(double from, double to) {
    paint.strokeWidth = to;
    parent?.addDirt(ComponentDirt.paint);
  }

  @override
  void transformAffectsStrokeChanged(bool from, bool to) {
    var parentShape = parent;
    if (parentShape is Shape) {
      parentShape.transformAffectsStrokeChanged();
    }
  }

  @override
  void update(int dirt) {}
  @override
  void draw(Canvas canvas, Path path) {
    if (!isVisible) {
      return;
    }
    canvas.drawPath(path, paint);
  }
}
