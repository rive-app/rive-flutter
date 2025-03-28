// Core automatically generated
// lib/src/generated/constraints/distance_constraint_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/rive_core/constraints/targeted_constraint.dart';

const _coreTypes = {
  DistanceConstraintBase.typeKey,
  TargetedConstraintBase.typeKey,
  ConstraintBase.typeKey,
  ComponentBase.typeKey
};

abstract class DistanceConstraintBase extends TargetedConstraint {
  static const int typeKey = 82;
  @override
  int get coreType => DistanceConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// Distance field with key 177.
  static const int distancePropertyKey = 177;
  static const double distanceInitialValue = 100.0;

  @nonVirtual
  double distance_ = distanceInitialValue;

  /// The unit distance the constraint will move the constrained object relative
  /// to the target.
  @nonVirtual
  double get distance => distance_;

  /// Change the [distance_] field value.
  /// [distanceChanged] will be invoked only if the field's value has changed.
  set distance(double value) {
    if (distance_ == value) {
      return;
    }
    double from = distance_;
    distance_ = value;
    if (hasValidated) {
      distanceChanged(from, value);
    }
  }

  void distanceChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ModeValue field with key 178.
  static const int modeValuePropertyKey = 178;
  static const int modeValueInitialValue = 0;
  int _modeValue = modeValueInitialValue;

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
  void copy(Core source) {
    super.copy(source);
    if (source is DistanceConstraintBase) {
      distance_ = source.distance_;
      _modeValue = source._modeValue;
    }
  }
}
