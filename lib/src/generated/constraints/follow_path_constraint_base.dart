// Core automatically generated
// lib/src/generated/constraints/follow_path_constraint_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/transform_space_constraint.dart';

abstract class FollowPathConstraintBase extends TransformSpaceConstraint {
  static const int typeKey = 165;
  @override
  int get coreType => FollowPathConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        FollowPathConstraintBase.typeKey,
        TransformSpaceConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Distance field with key 363.
  static const double distanceInitialValue = 0;
  double _distance = distanceInitialValue;
  static const int distancePropertyKey = 363;

  /// Distance along the path to follow.
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
  /// Orient field with key 364.
  static const bool orientInitialValue = true;
  bool _orient = orientInitialValue;
  static const int orientPropertyKey = 364;

  /// True when the orientation from the path is copied to the constrained
  /// transform.
  bool get orient => _orient;

  /// Change the [_orient] field value.
  /// [orientChanged] will be invoked only if the field's value has changed.
  set orient(bool value) {
    if (_orient == value) {
      return;
    }
    bool from = _orient;
    _orient = value;
    if (hasValidated) {
      orientChanged(from, value);
    }
  }

  void orientChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// Offset field with key 365.
  static const bool offsetInitialValue = false;
  bool _offset = offsetInitialValue;
  static const int offsetPropertyKey = 365;

  /// True when the local translation is used to offset the transformed one.
  bool get offset => _offset;

  /// Change the [_offset] field value.
  /// [offsetChanged] will be invoked only if the field's value has changed.
  set offset(bool value) {
    if (_offset == value) {
      return;
    }
    bool from = _offset;
    _offset = value;
    if (hasValidated) {
      offsetChanged(from, value);
    }
  }

  void offsetChanged(bool from, bool to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is FollowPathConstraintBase) {
      _distance = source._distance;
      _orient = source._orient;
      _offset = source._offset;
    }
  }
}
