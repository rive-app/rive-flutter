/// Core automatically generated lib/src/generated/bones/bone_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/bones/skeletal_component_base.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/rive_core/bones/skeletal_component.dart';

abstract class BoneBase extends SkeletalComponent {
  static const int typeKey = 40;
  @override
  int get coreType => BoneBase.typeKey;
  @override
  Set<int> get coreTypes => {
        BoneBase.typeKey,
        SkeletalComponentBase.typeKey,
        TransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Length field with key 89.
  double _length = 0;
  static const int lengthPropertyKey = 89;
  double get length => _length;

  /// Change the [_length] field value.
  /// [lengthChanged] will be invoked only if the field's value has changed.
  set length(double value) {
    if (_length == value) {
      return;
    }
    double from = _length;
    _length = value;
    lengthChanged(from, value);
  }

  void lengthChanged(double from, double to);
}
