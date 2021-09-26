import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:rive/src/generated/shapes/paint/shape_paint_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';

export 'package:rive/src/generated/shapes/paint/shape_paint_base.dart';

/// Generic ShapePaint that abstracts Stroke and Fill. Automatically hooks up
/// parent [Shape] to child [ShapePaintMutator]s.
abstract class ShapePaint extends ShapePaintBase {
  late Paint _paint;
  Paint get paint => _paint;
  ShapePaintMutator? _paintMutator;
  ShapePaintContainer? get shapePaintContainer =>
      parent is ShapePaintContainer ? parent as ShapePaintContainer : null;

  ShapePaint() {
    _paint = makePaint();
  }

  BlendMode get blendMode => _paint.blendMode;
  set blendMode(BlendMode value) => _paint.blendMode = value;

  double get renderOpacity => _paintMutator!.renderOpacity;
  set renderOpacity(double value) => _paintMutator!.renderOpacity = value;

  ShapePaintMutator? get paintMutator => _paintMutator;

  void _changeMutator(ShapePaintMutator? mutator) {
    _paint = makePaint();
    _paintMutator = mutator;
  }

  /// Implementing classes are expected to override this to create a paint
  /// object. This gets called whenever the mutator is changed in order to not
  /// require each mutator to manually reset the paint to some canonical state.
  /// Instead, we simply blow out the old one and make a new one.
  @protected
  Paint makePaint();

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    if (child is ShapePaintMutator) {
      _changeMutator(child as ShapePaintMutator);
      if (shapePaintContainer != null) {
        _initMutator();
      }
    }
  }

  @override
  void parentChanged(ContainerComponent? from, ContainerComponent? to) {
    super.parentChanged(from, to);
    if (shapePaintContainer != null) {
      _initMutator();
    }
  }

  @override
  bool validate() =>
      super.validate() &&
      parent is ShapePaintContainer &&
      _paintMutator != null;

  @override
  void isVisibleChanged(bool from, bool to) {
    shapePaintContainer?.addDirt(ComponentDirt.paint);
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    // Make sure to clean up any references so that they can be garbage
    // collected.
    if (child is ShapePaintMutator &&
        _paintMutator == child as ShapePaintMutator) {
      _changeMutator(null);
    }
  }

  void _initMutator() =>
      _paintMutator?.initializePaintMutator(shapePaintContainer!, paint);

  void draw(Canvas canvas, Path path);
}
