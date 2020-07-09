import 'dart:ui';
import 'package:meta/meta.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';
import 'package:rive/src/generated/shapes/paint/shape_paint_base.dart';
export 'package:rive/src/generated/shapes/paint/shape_paint_base.dart';

abstract class ShapePaint extends ShapePaintBase {
  Paint _paint;
  Paint get paint => _paint;
  ShapePaintMutator _paintMutator;
  ShapePaintContainer _shapePaintContainer;
  ShapePaintContainer get shapePaintContainer => _shapePaintContainer;
  ShapePaint() {
    _paint = makePaint();
  }
  BlendMode get blendMode => _paint.blendMode;
  set blendMode(BlendMode value) => _paint.blendMode = value;
  double get renderOpacity => _paintMutator.renderOpacity;
  set renderOpacity(double value) => _paintMutator.renderOpacity = value;
  Component get timelineParent => _shapePaintContainer as Component;
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
  void isVisibleChanged(bool from, bool to) {
    _shapePaintContainer?.addDirt(ComponentDirt.paint);
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    if (child is ShapePaintMutator &&
        _paintMutator == child as ShapePaintMutator) {
      _changeMutator(null);
    }
  }

  @override
  void parentChanged(ContainerComponent from, ContainerComponent to) {
    super.parentChanged(from, to);
    if (parent is ShapePaintContainer) {
      _shapePaintContainer = parent as ShapePaintContainer;
      _initMutator();
    } else {
      _shapePaintContainer = null;
    }
  }

  void _initMutator() {
    if (_shapePaintContainer != null && _paintMutator != null) {
      _paintMutator.initializePaintMutator(_shapePaintContainer, paint);
    }
  }

  void draw(Canvas canvas, Path path);
}
