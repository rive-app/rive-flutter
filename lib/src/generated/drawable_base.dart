/// Core automatically generated lib/src/generated/drawable_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/rive_core/node.dart';

abstract class DrawableBase extends Node {
  static const int typeKey = 13;
  @override
  int get coreType => DrawableBase.typeKey;
  @override
  Set<int> get coreTypes => {
        DrawableBase.typeKey,
        NodeBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// DrawOrder field with key 22.
  int _drawOrder;
  static const int drawOrderPropertyKey = 22;
  int get drawOrder => _drawOrder;

  /// Change the [_drawOrder] field value.
  /// [drawOrderChanged] will be invoked only if the field's value has changed.
  set drawOrder(int value) {
    if (_drawOrder == value) {
      return;
    }
    int from = _drawOrder;
    _drawOrder = value;
    drawOrderChanged(from, value);
  }

  void drawOrderChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// BlendModeValue field with key 23.
  int _blendModeValue = 3;
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
    blendModeValueChanged(from, value);
  }

  void blendModeValueChanged(int from, int to);
}
