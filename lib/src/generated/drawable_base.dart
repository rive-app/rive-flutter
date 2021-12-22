/// Core automatically generated lib/src/generated/drawable_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/node.dart';

abstract class DrawableBase extends Node {
  static const int typeKey = 13;
  @override
  int get coreType => DrawableBase.typeKey;
  @override
  Set<int> get coreTypes => {
        DrawableBase.typeKey,
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// BlendModeValue field with key 23.
  static const int blendModeValueInitialValue = 3;
  int _blendModeValue = blendModeValueInitialValue;
  static const int blendModeValuePropertyKey = 23;
  int get blendModeValue => _blendModeValue;

  /// Change the [_blendModeValue] field value.
  /// [blendModeValueChanged] will be invoked only if the field's value has
  /// changed.
  set blendModeValue(int value) {
    if (_blendModeValue == value) {
      return;
    }
    int from = _blendModeValue;
    _blendModeValue = value;
    if (hasValidated) {
      blendModeValueChanged(from, value);
    }
  }

  void blendModeValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// DrawableFlags field with key 129.
  static const int drawableFlagsInitialValue = 0;
  int _drawableFlags = drawableFlagsInitialValue;
  static const int drawableFlagsPropertyKey = 129;
  int get drawableFlags => _drawableFlags;

  /// Change the [_drawableFlags] field value.
  /// [drawableFlagsChanged] will be invoked only if the field's value has
  /// changed.
  set drawableFlags(int value) {
    if (_drawableFlags == value) {
      return;
    }
    int from = _drawableFlags;
    _drawableFlags = value;
    if (hasValidated) {
      drawableFlagsChanged(from, value);
    }
  }

  void drawableFlagsChanged(int from, int to);

  @override
  void copy(covariant DrawableBase source) {
    super.copy(source);
    _blendModeValue = source._blendModeValue;
    _drawableFlags = source._drawableFlags;
  }
}
