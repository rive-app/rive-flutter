/// Core automatically generated
/// lib/src/generated/constraints/ik_constraint_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/rive_core/constraints/targeted_constraint.dart';

abstract class IKConstraintBase extends TargetedConstraint {
  static const int typeKey = 81;
  @override
  int get coreType => IKConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        IKConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// InvertDirection field with key 174.
  static const bool invertDirectionInitialValue = false;
  bool _invertDirection = invertDirectionInitialValue;
  static const int invertDirectionPropertyKey = 174;

  /// True when the direction taken towards the target should be inverted from
  /// the default.
  bool get invertDirection => _invertDirection;

  /// Change the [_invertDirection] field value.
  /// [invertDirectionChanged] will be invoked only if the field's value has
  /// changed.
  set invertDirection(bool value) {
    if (_invertDirection == value) {
      return;
    }
    bool from = _invertDirection;
    _invertDirection = value;
    if (hasValidated) {
      invertDirectionChanged(from, value);
    }
  }

  void invertDirectionChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// ParentBoneCount field with key 175.
  static const int parentBoneCountInitialValue = 0;
  int _parentBoneCount = parentBoneCountInitialValue;
  static const int parentBoneCountPropertyKey = 175;

  /// The number of bones above this one that are influenced by this IK
  /// constraint.
  int get parentBoneCount => _parentBoneCount;

  /// Change the [_parentBoneCount] field value.
  /// [parentBoneCountChanged] will be invoked only if the field's value has
  /// changed.
  set parentBoneCount(int value) {
    if (_parentBoneCount == value) {
      return;
    }
    int from = _parentBoneCount;
    _parentBoneCount = value;
    if (hasValidated) {
      parentBoneCountChanged(from, value);
    }
  }

  void parentBoneCountChanged(int from, int to);

  @override
  void copy(covariant IKConstraintBase source) {
    super.copy(source);
    _invertDirection = source._invertDirection;
    _parentBoneCount = source._parentBoneCount;
  }
}
