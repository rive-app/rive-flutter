import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/generated/shapes/clipping_shape_base.dart';
export 'package:rive/src/generated/shapes/clipping_shape_base.dart';

enum ClipOp { intersection, difference }

class ClippingShape extends ClippingShapeBase {
  ClipOp get clipOp => ClipOp.values[clipOpValue];
  set clipOp(ClipOp value) => clipOpValue = value.index;
  Mat2D _shapeInverseWorld;
  Mat2D get shapeInverseWorld => _shapeInverseWorld;
  Shape _shape;
  Shape get shape => _shape;
  set shape(Shape value) {
    if (_shape == value) {
      return;
    }
    _shape = value;
    shapeId = value?.id;
  }

  @override
  void clipOpValueChanged(int from, int to) {
    parent?.addDirt(ComponentDirt.clip, recurse: true);
  }

  @override
  void shapeIdChanged(int from, int to) {
    shape = context?.resolve(to);
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    if (shapeId != null) {
      shape = context?.resolve(shapeId);
    }
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    shape?.addDependent(this);
  }

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.worldTransform != 0 &&
        shape != null &&
        !shape.fillInWorld) {
      _shapeInverseWorld ??= Mat2D();
      Mat2D.invert(_shapeInverseWorld, shape.worldTransform);
    }
  }

  @override
  void isVisibleChanged(bool from, bool to) {
    _shape?.addDirt(ComponentDirt.paint);
  }
}
