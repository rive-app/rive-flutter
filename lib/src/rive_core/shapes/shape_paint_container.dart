import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/paint/fill.dart';
import 'package:meta/meta.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke.dart';

abstract class ShapePaintContainer {
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
