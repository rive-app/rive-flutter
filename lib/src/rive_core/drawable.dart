import 'dart:ui';

import 'package:rive/src/generated/drawable_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/component_flags.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/draw_rules.dart';
import 'package:rive/src/rive_core/shapes/clipping_shape.dart';
import 'package:rive/src/rive_core/transform_component.dart';

export 'package:rive/src/generated/drawable_base.dart';

abstract class Drawable extends DrawableBase {
  /// Flattened rules inherited from parents (or self) so we don't have to look
  /// up the tree when re-sorting.
  DrawRules? flattenedDrawRules;

  /// The previous drawable in the draw order.
  Drawable? prev;

  /// The next drawable in the draw order.
  Drawable? next;

  @override
  void buildDrawOrder(
      List<Drawable> drawables, DrawRules? rules, List<DrawRules> allRules) {
    flattenedDrawRules = drawRules ?? rules;

    drawables.add(this);

    super.buildDrawOrder(drawables, rules, allRules);
  }

  /// Draw the contents of this drawable component in world transform space.
  void draw(Canvas canvas);

  BlendMode get blendMode => BlendMode.values[blendModeValue];
  set blendMode(BlendMode value) => blendModeValue = value.index;

  @override
  void blendModeValueChanged(int from, int to) {}

  List<ClippingShape> _clippingShapes = [];

  bool clip(Canvas canvas) {
    if (_clippingShapes.isEmpty) {
      return false;
    }
    canvas.save();
    for (final clip in _clippingShapes) {
      if (!clip.isVisible) {
        continue;
      }
      canvas.clipPath(clip.clippingPath);
    }
    return true;
  }

  @override
  void parentChanged(ContainerComponent? from, ContainerComponent? to) {
    super.parentChanged(from, to);
    // Make sure we re-compute clipping shapes when we change parents. Issue
    // #1586
    addDirt(ComponentDirt.clip);
  }

  @override
  void update(int dirt) {
    super.update(dirt);
    if (dirt & ComponentDirt.clip != 0) {
      // Find clip in parents.
      List<ClippingShape> clippingShapes = [];
      for (ContainerComponent? p = this; p != null; p = p.parent) {
        if (p is TransformComponent) {
          if (p.clippingShapes.isNotEmpty) {
            clippingShapes.addAll(p.clippingShapes);
          }
        }
      }
      _clippingShapes = clippingShapes;
    }
  }

  // When drawable flags change, repaint.
  @override
  void drawableFlagsChanged(int from, int to) => addDirt(ComponentDirt.paint);

  bool get isHidden => (drawableFlags & ComponentFlags.hidden) != 0;
}
