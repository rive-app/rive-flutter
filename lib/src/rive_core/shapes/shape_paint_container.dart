import 'package:meta/meta.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

import 'package:rive/src/rive_core/shapes/paint/fill.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke.dart';

/// An abstraction to give a common interface to any component that can contain
/// fills and strokes.
abstract class ShapePaintContainer {
  final Set<Fill> fills = {};

  final Set<Stroke> strokes = {};

  /// Called whenever a new paint mutator is added/removed from the shape paints
  /// (for example a linear gradient is added to a stroke).
  void onPaintMutatorChanged(ShapePaintMutator mutator);

  /// Called when a fill is added or removed.
  @protected
  void onFillsChanged();

  /// Called when a stroke is added or remoevd.
  @protected
  void onStrokesChanged();

  /// Called whenever the compound path for this shape is changed so that the
  /// effects can be invalidated on all the strokes.
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

  /// These usually gets auto implemented as this mixin is meant to be added to
  /// a ComponentBase. This way the implementor doesn't need to cast
  /// ShapePaintContainer to ContainerComponent/Shape/Artboard/etc.
  bool addDirt(int value, {bool recurse = false});

  bool addDependent(Component dependent, {Component? via});
  void appendChild(Component child);
  Mat2D get worldTransform;
  Vec2D get worldTranslation;
}
