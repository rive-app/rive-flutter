import 'dart:ui';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/generated/shapes/clipping_shape_base.dart';
export 'package:rive/src/generated/shapes/clipping_shape_base.dart';

class ClippingShape extends ClippingShapeBase {
  final Path clippingPath = Path();
  final List<Shape> _shapes = [];
  PathFillType get fillType => PathFillType.values[fillRule];
  set fillType(PathFillType type) => fillRule = type.index;
  Node _source;
  Node get source => _source;
  set source(Node value) {
    if (_source == value) {
      return;
    }
    _source = value;
    sourceId = value?.id;
  }

  @override
  void fillRuleChanged(int from, int to) {
    parent?.addDirt(ComponentDirt.clip, recurse: true);
    addDirt(ComponentDirt.path);
  }

  @override
  void sourceIdChanged(int from, int to) {
    source = context?.resolve(to);
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    if (sourceId != null) {
      _source = context?.resolve(sourceId);
    }
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    _shapes.clear();
    _source?.forAll((component) {
      if (component is Shape) {
        _shapes.add(component);
        component.pathComposer.addDependent(this);
      }
      return true;
    });
    addDirt(ComponentDirt.path);
  }

  @override
  void onRemoved() {
    super.onRemoved();
    _shapes.clear();
  }

  @override
  void update(int dirt) {
    if (dirt & (ComponentDirt.worldTransform | ComponentDirt.path) != 0 &&
        source != null) {
      clippingPath.reset();
      clippingPath.fillType = fillType;
      for (final shape in _shapes) {
        if (!shape.fillInWorld) {
          clippingPath.addPath(shape.fillPath, Offset.zero,
              matrix4: shape.worldTransform.mat4);
        } else {
          clippingPath.addPath(shape.fillPath, Offset.zero);
        }
      }
    }
  }

  @override
  void isVisibleChanged(bool from, bool to) {
    _source?.addDirt(ComponentDirt.paint);
  }
}
