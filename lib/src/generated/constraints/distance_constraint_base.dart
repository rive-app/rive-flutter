/// Core automatically generated
/// lib/src/generated/constraints/distance_constraint_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/rive_core/constraints/targeted_constraint.dart';

abstract class DistanceConstraintBase extends TargetedConstraint {
  static const int typeKey = 82;
  @override
  int get coreType => DistanceConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        DistanceConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Distance field with key 177.
  static const double distanceInitialValue = 100.0;
  double _distance = distanceInitialValue;
  static const int distancePropertyKey = 177;

  /// The unit distance the constraint will move the constrained object relative
  /// to the target.
  double get distance => _distance;

  /// Change the [_distance] field value.
  /// [distanceChanged] will be invoked only if the field's value has changed.
  set distance(double value) {
    if (_distance == value) {
      return;
    }
    double from = _distance;
    _distance = value;
    if (hasValidated) {
      distanceChanged(from, value);
    }
  }

  void distanceChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ModeValue field with key 178.
  static const int modeValueInitialValue = 0;
  int _modeValue = modeValueInitialValue;
  static const int modeValuePropertyKey = 178;

  /// Backing value for the mode enum.
  int get modeValue => _modeValue;

  /// Change the [_modeValue] field value.
  /// [modeValueChanged] will be invoked only if the field's value has changed.
  set modeValue(int value) {
    if (_modeValue == value) {
      return;
    }
    int from = _modeValue;
    _modeValue = value;
    if (hasValidated) {
      modeValueChanged(from, value);
    }
  }

  void modeValueChanged(int from, int to);

  @override
  void copy(covariant DistanceConstraintBase source) {
    super.copy(source);
    _distance = source._distance;
    _modeValue = source._modeValue;
  }
}
