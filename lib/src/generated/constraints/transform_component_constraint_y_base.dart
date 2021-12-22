/// Core automatically generated
/// lib/src/generated/constraints/transform_component_constraint_y_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/generated/constraints/transform_space_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/transform_component_constraint.dart';

abstract class TransformComponentConstraintYBase
    extends TransformComponentConstraint {
  static const int typeKey = 86;
  @override
  int get coreType => TransformComponentConstraintYBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransformComponentConstraintYBase.typeKey,
        TransformComponentConstraintBase.typeKey,
        TransformSpaceConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// CopyFactorY field with key 185.
  static const double copyFactorYInitialValue = 1;
  double _copyFactorY = copyFactorYInitialValue;
  static const int copyFactorYPropertyKey = 185;

  /// Copy factor.
  double get copyFactorY => _copyFactorY;

  /// Change the [_copyFactorY] field value.
  /// [copyFactorYChanged] will be invoked only if the field's value has
  /// changed.
  set copyFactorY(double value) {
    if (_copyFactorY == value) {
      return;
    }
    double from = _copyFactorY;
    _copyFactorY = value;
    if (hasValidated) {
      copyFactorYChanged(from, value);
    }
  }

  void copyFactorYChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MinValueY field with key 186.
  static const double minValueYInitialValue = 0;
  double _minValueY = minValueYInitialValue;
  static const int minValueYPropertyKey = 186;

  /// Minimum value.
  double get minValueY => _minValueY;

  /// Change the [_minValueY] field value.
  /// [minValueYChanged] will be invoked only if the field's value has changed.
  set minValueY(double value) {
    if (_minValueY == value) {
      return;
    }
    double from = _minValueY;
    _minValueY = value;
    if (hasValidated) {
      minValueYChanged(from, value);
    }
  }

  void minValueYChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MaxValueY field with key 187.
  static const double maxValueYInitialValue = 0;
  double _maxValueY = maxValueYInitialValue;
  static const int maxValueYPropertyKey = 187;

  /// Maximum value.
  double get maxValueY => _maxValueY;

  /// Change the [_maxValueY] field value.
  /// [maxValueYChanged] will be invoked only if the field's value has changed.
  set maxValueY(double value) {
    if (_maxValueY == value) {
      return;
    }
    double from = _maxValueY;
    _maxValueY = value;
    if (hasValidated) {
      maxValueYChanged(from, value);
    }
  }

  void maxValueYChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// DoesCopyY field with key 192.
  static const bool doesCopyYInitialValue = true;
  bool _doesCopyY = doesCopyYInitialValue;
  static const int doesCopyYPropertyKey = 192;

  /// Whether the Y component is copied.
  bool get doesCopyY => _doesCopyY;

  /// Change the [_doesCopyY] field value.
  /// [doesCopyYChanged] will be invoked only if the field's value has changed.
  set doesCopyY(bool value) {
    if (_doesCopyY == value) {
      return;
    }
    bool from = _doesCopyY;
    _doesCopyY = value;
    if (hasValidated) {
      doesCopyYChanged(from, value);
    }
  }

  void doesCopyYChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// MinY field with key 193.
  static const bool minYInitialValue = false;
  bool _minY = minYInitialValue;
  static const int minYPropertyKey = 193;

  /// Whether min Y is used.
  bool get minY => _minY;

  /// Change the [_minY] field value.
  /// [minYChanged] will be invoked only if the field's value has changed.
  set minY(bool value) {
    if (_minY == value) {
      return;
    }
    bool from = _minY;
    _minY = value;
    if (hasValidated) {
      minYChanged(from, value);
    }
  }

  void minYChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// MaxY field with key 194.
  static const bool maxYInitialValue = false;
  bool _maxY = maxYInitialValue;
  static const int maxYPropertyKey = 194;

  /// Whether max Y is used.
  bool get maxY => _maxY;

  /// Change the [_maxY] field value.
  /// [maxYChanged] will be invoked only if the field's value has changed.
  set maxY(bool value) {
    if (_maxY == value) {
      return;
    }
    bool from = _maxY;
    _maxY = value;
    if (hasValidated) {
      maxYChanged(from, value);
    }
  }

  void maxYChanged(bool from, bool to);

  @override
  void copy(covariant TransformComponentConstraintYBase source) {
    super.copy(source);
    _copyFactorY = source._copyFactorY;
    _minValueY = source._minValueY;
    _maxValueY = source._maxValueY;
    _doesCopyY = source._doesCopyY;
    _minY = source._minY;
    _maxY = source._maxY;
  }
}
