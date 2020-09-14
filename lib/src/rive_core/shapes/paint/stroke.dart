import 'package:flutter/material.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke_effect.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';
import 'package:rive/src/generated/shapes/paint/stroke_base.dart';
export 'package:rive/src/generated/shapes/paint/stroke_base.dart';

class Stroke extends StrokeBase {
  StrokeEffect _effect;
  StrokeEffect get effect => _effect;
  // ignore: use_setters_to_change_properties
  void addStrokeEffect(StrokeEffect effect) {
    _effect = effect;
  }

  void removeStrokeEffect(StrokeEffect effect) {
    if (effect == _effect) {
      _effect = null;
    }
  }

  @override
  Paint makePaint() => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = strokeCap
    ..strokeJoin = strokeJoin
    ..strokeWidth = thickness;
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
      parentShape.paintChanged();
    }
  }

  @override
  void update(int dirt) {}
  @override
  void onAdded() {
    super.onAdded();
    if (parent is ShapePaintContainer) {
      (parent as ShapePaintContainer).addStroke(this);
    }
  }

  void invalidateEffects() {
    _effect?.invalidateEffect();
  }

  @override
  void draw(Canvas canvas, Path path) {
    if (!isVisible) {
      return;
    }
    canvas.drawPath(_effect?.effectPath(path) ?? path, paint);
  }
}
