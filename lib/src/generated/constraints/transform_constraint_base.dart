// Core automatically generated
// lib/src/generated/constraints/transform_constraint_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/transform_space_constraint.dart';

abstract class TransformConstraintBase extends TransformSpaceConstraint {
  static const int typeKey = 83;
  @override
  int get coreType => TransformConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransformConstraintBase.typeKey,
        TransformSpaceConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// OriginX field with key 372.
  static const int originXPropertyKey = 372;
  static const double originXInitialValue = 0.0;
  double _originX = originXInitialValue;

  /// Origin x in normalized coordinates (0.5 = center, 0 = left, 1 = right).
  double get originX => _originX;

  /// Change the [_originX] field value.
  /// [originXChanged] will be invoked only if the field's value has changed.
  set originX(double value) {
    if (_originX == value) {
      return;
    }
    double from = _originX;
    _originX = value;
    if (hasValidated) {
      originXChanged(from, value);
    }
  }

  void originXChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// OriginY field with key 373.
  static const int originYPropertyKey = 373;
  static const double originYInitialValue = 0.0;
  double _originY = originYInitialValue;

  /// Origin y in normalized coordinates (0.5 = center, 0 = top, 1 = bottom).
  double get originY => _originY;

  /// Change the [_originY] field value.
  /// [originYChanged] will be invoked only if the field's value has changed.
  set originY(double value) {
    if (_originY == value) {
      return;
    }
    double from = _originY;
    _originY = value;
    if (hasValidated) {
      originYChanged(from, value);
    }
  }

  void originYChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TransformConstraintBase) {
      _originX = source._originX;
      _originY = source._originY;
    }
  }
}
