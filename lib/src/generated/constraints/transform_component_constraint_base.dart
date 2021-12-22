/// Core automatically generated
/// lib/src/generated/constraints/transform_component_constraint_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/transform_space_constraint.dart';

abstract class TransformComponentConstraintBase
    extends TransformSpaceConstraint {
  static const int typeKey = 85;
  @override
  int get coreType => TransformComponentConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransformComponentConstraintBase.typeKey,
        TransformSpaceConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// MinMaxSpaceValue field with key 195.
  static const int minMaxSpaceValueInitialValue = 0;
  int _minMaxSpaceValue = minMaxSpaceValueInitialValue;
  static const int minMaxSpaceValuePropertyKey = 195;

  /// The min/max transform space.
  int get minMaxSpaceValue => _minMaxSpaceValue;

  /// Change the [_minMaxSpaceValue] field value.
  /// [minMaxSpaceValueChanged] will be invoked only if the field's value has
  /// changed.
  set minMaxSpaceValue(int value) {
    if (_minMaxSpaceValue == value) {
      return;
    }
    int from = _minMaxSpaceValue;
    _minMaxSpaceValue = value;
    if (hasValidated) {
      minMaxSpaceValueChanged(from, value);
    }
  }

  void minMaxSpaceValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// CopyFactor field with key 182.
  static const double copyFactorInitialValue = 1;
  double _copyFactor = copyFactorInitialValue;
  static const int copyFactorPropertyKey = 182;

  /// Copy factor.
  double get copyFactor => _copyFactor;

  /// Change the [_copyFactor] field value.
  /// [copyFactorChanged] will be invoked only if the field's value has changed.
  set copyFactor(double value) {
    if (_copyFactor == value) {
      return;
    }
    double from = _copyFactor;
    _copyFactor = value;
    if (hasValidated) {
      copyFactorChanged(from, value);
    }
  }

  void copyFactorChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MinValue field with key 183.
  static const double minValueInitialValue = 0;
  double _minValue = minValueInitialValue;
  static const int minValuePropertyKey = 183;

  /// Minimum value.
  double get minValue => _minValue;

  /// Change the [_minValue] field value.
  /// [minValueChanged] will be invoked only if the field's value has changed.
  set minValue(double value) {
    if (_minValue == value) {
      return;
    }
    double from = _minValue;
    _minValue = value;
    if (hasValidated) {
      minValueChanged(from, value);
    }
  }

  void minValueChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MaxValue field with key 184.
  static const double maxValueInitialValue = 0;
  double _maxValue = maxValueInitialValue;
  static const int maxValuePropertyKey = 184;

  /// Maximum value.
  double get maxValue => _maxValue;

  /// Change the [_maxValue] field value.
  /// [maxValueChanged] will be invoked only if the field's value has changed.
  set maxValue(double value) {
    if (_maxValue == value) {
      return;
    }
    double from = _maxValue;
    _maxValue = value;
    if (hasValidated) {
      maxValueChanged(from, value);
    }
  }

  void maxValueChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Offset field with key 188.
  static const bool offsetInitialValue = false;
  bool _offset = offsetInitialValue;
  static const int offsetPropertyKey = 188;

  /// True when the original component (rotation/scale/translation) is used to
  /// offset the copied one.
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

  /// --------------------------------------------------------------------------
  /// DoesCopy field with key 189.
  static const bool doesCopyInitialValue = true;
  bool _doesCopy = doesCopyInitialValue;
  static const int doesCopyPropertyKey = 189;

  /// Whether the component is copied.
  bool get doesCopy => _doesCopy;

  /// Change the [_doesCopy] field value.
  /// [doesCopyChanged] will be invoked only if the field's value has changed.
  set doesCopy(bool value) {
    if (_doesCopy == value) {
      return;
    }
    bool from = _doesCopy;
    _doesCopy = value;
    if (hasValidated) {
      doesCopyChanged(from, value);
    }
  }

  void doesCopyChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// Min field with key 190.
  static const bool minInitialValue = false;
  bool _min = minInitialValue;
  static const int minPropertyKey = 190;

  /// Whether min is used.
  bool get min => _min;

  /// Change the [_min] field value.
  /// [minChanged] will be invoked only if the field's value has changed.
  set min(bool value) {
    if (_min == value) {
      return;
    }
    bool from = _min;
    _min = value;
    if (hasValidated) {
      minChanged(from, value);
    }
  }

  void minChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// Max field with key 191.
  static const bool maxInitialValue = false;
  bool _max = maxInitialValue;
  static const int maxPropertyKey = 191;

  /// Whether max is used.
  bool get max => _max;

  /// Change the [_max] field value.
  /// [maxChanged] will be invoked only if the field's value has changed.
  set max(bool value) {
    if (_max == value) {
      return;
    }
    bool from = _max;
    _max = value;
    if (hasValidated) {
      maxChanged(from, value);
    }
  }

  void maxChanged(bool from, bool to);

  @override
  void copy(covariant TransformComponentConstraintBase source) {
    super.copy(source);
    _minMaxSpaceValue = source._minMaxSpaceValue;
    _copyFactor = source._copyFactor;
    _minValue = source._minValue;
    _maxValue = source._maxValue;
    _offset = source._offset;
    _doesCopy = source._doesCopy;
    _min = source._min;
    _max = source._max;
  }
}
