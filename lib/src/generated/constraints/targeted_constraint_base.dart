/// Core automatically generated
/// lib/src/generated/constraints/targeted_constraint_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/constraints/constraint.dart';

abstract class TargetedConstraintBase extends Constraint {
  static const int typeKey = 80;
  @override
  int get coreType => TargetedConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// TargetId field with key 173.
  static const int targetIdInitialValue = -1;
  int _targetId = targetIdInitialValue;
  static const int targetIdPropertyKey = 173;

  /// Identifier used to track the TransformComponent used as the target for the
  /// constraint.
  int get targetId => _targetId;

  /// Change the [_targetId] field value.
  /// [targetIdChanged] will be invoked only if the field's value has changed.
  set targetId(int value) {
    if (_targetId == value) {
      return;
    }
    int from = _targetId;
    _targetId = value;
    if (hasValidated) {
      targetIdChanged(from, value);
    }
  }

  void targetIdChanged(int from, int to);

  @override
  void copy(covariant TargetedConstraintBase source) {
    super.copy(source);
    _targetId = source._targetId;
  }
}
