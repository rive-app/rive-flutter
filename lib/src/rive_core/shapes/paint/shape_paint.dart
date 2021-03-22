import 'dart:ui';
import 'package:meta/meta.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';
import 'package:rive/src/generated/shapes/paint/shape_paint_base.dart';
export 'package:rive/src/generated/shapes/paint/shape_paint_base.dart';

abstract class ShapePaint extends ShapePaintBase {
  late Paint _paint;
  Paint get paint => _paint;
  ShapePaintMutator _paintMutator = ShapePaintMutator.unknown;
  ShapePaintContainer get shapePaintContainer => parent as ShapePaintContainer;
  ShapePaint() {
    _paint = makePaint();
  }
  BlendMode get blendMode => _paint.blendMode;
  set blendMode(BlendMode value) => _paint.blendMode = value;
  double get renderOpacity => _paintMutator.renderOpacity;
  set renderOpacity(double value) => _paintMutator.renderOpacity = value;
  ShapePaintMutator get paintMutator => _paintMutator;
  void _changeMutator(ShapePaintMutator mutator) {
    _paint = makePaint();
    _paintMutator = mutator;
  }

  @protected
  Paint makePaint();
  @override
  void childAdded(Component child) {
    super.childAdded(child);
    if (child is ShapePaintMutator) {
      _changeMutator(child as ShapePaintMutator);
      _initMutator();
    }
  }

  @override
  bool validate() =>
      super.validate() &&
      parent is ShapePaintContainer &&
      _paintMutator != ShapePaintMutator.unknown;
  @override
  void isVisibleChanged(bool from, bool to) {
    if (hasValidated) {
      shapePaintContainer.addDirt(ComponentDirt.paint);
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    if (child is ShapePaintMutator &&
        _paintMutator == child as ShapePaintMutator) {
      _changeMutator(ShapePaintMutator.unknown);
    }
  }

  void _initMutator() {
    if (hasValidated) {
      _paintMutator.initializePaintMutator(shapePaintContainer, paint);
    }
  }

  void draw(Canvas canvas, Path path);
}
