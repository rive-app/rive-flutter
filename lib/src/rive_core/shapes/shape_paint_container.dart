import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/paint/fill.dart';
import 'package:meta/meta.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke.dart';

class _UnknownShapePaintContainer extends ShapePaintContainer {
  UnsupportedError get _error =>
      UnsupportedError('Not expected to use the UnknownShapeContainer.');
  @override
  bool addDependent(Component dependent) =>
      throw UnsupportedError('Not expected to use the UnknownShapeContainer.');
  @override
  bool addDirt(int value, {bool recurse = false}) => throw _error;
  @override
  void appendChild(Component child) => throw _error;
  @override
  void onFillsChanged() => throw _error;
  @override
  void onPaintMutatorChanged(ShapePaintMutator mutator) => throw _error;
  @override
  void onStrokesChanged() => throw _error;
  @override
  Mat2D get worldTransform => throw _error;
  @override
  Vec2D get worldTranslation => throw _error;
}

abstract class ShapePaintContainer {
  static final ShapePaintContainer unknown = _UnknownShapePaintContainer();
  final Set<Fill> fills = {};
  final Set<Stroke> strokes = {};
  void onPaintMutatorChanged(ShapePaintMutator mutator);
  @protected
  void onFillsChanged();
  @protected
  void onStrokesChanged();
  void invalidateStrokeEffects() {
    for (final stroke in strokes) {
      stroke.invalidateEffects();
    }
  }

  bool addFill(Fill fill) {
    if (fills.add(fill)) {
      onFillsChanged();
      return true;
    }
    return false;
  }

  bool removeFill(Fill fill) {
    if (fills.remove(fill)) {
      onFillsChanged();
      return true;
    }
    return false;
  }

  bool addStroke(Stroke stroke) {
    if (strokes.add(stroke)) {
      onStrokesChanged();
      return true;
    }
    return false;
  }

  bool removeStroke(Stroke stroke) {
    if (strokes.remove(stroke)) {
      onStrokesChanged();
      return true;
    }
    return false;
  }

  bool addDirt(int value, {bool recurse = false});
  bool addDependent(Component dependent);
  void appendChild(Component child);
  Mat2D get worldTransform;
  Vec2D get worldTranslation;
}
