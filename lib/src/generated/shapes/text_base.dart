/// Core automatically generated lib/src/generated/shapes/text_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/node.dart';

abstract class TextBase extends Node {
  static const int typeKey = 110;
  @override
  int get coreType => TextBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TextBase.typeKey,
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 218.
  static const String valueInitialValue = '';
  String _value = valueInitialValue;
  static const int valuePropertyKey = 218;

  /// The value stored in the Text object.
  String get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(String value) {
    if (_value == value) {
      return;
    }
    String from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(String from, String to);

  @override
  void copy(covariant TextBase source) {
    super.copy(source);
    _value = source._value;
  }
}
