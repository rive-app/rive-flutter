/// Core automatically generated
/// lib/src/generated/constraints/transform_space_constraint_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/rive_core/constraints/targeted_constraint.dart';

abstract class TransformSpaceConstraintBase extends TargetedConstraint {
  static const int typeKey = 90;
  @override
  int get coreType => TransformSpaceConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransformSpaceConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// SourceSpaceValue field with key 179.
  static const int sourceSpaceValueInitialValue = 0;
  int _sourceSpaceValue = sourceSpaceValueInitialValue;
  static const int sourceSpaceValuePropertyKey = 179;

  /// The source transform space.
  int get sourceSpaceValue => _sourceSpaceValue;

  /// Change the [_sourceSpaceValue] field value.
  /// [sourceSpaceValueChanged] will be invoked only if the field's value has
  /// changed.
  set sourceSpaceValue(int value) {
    if (_sourceSpaceValue == value) {
      return;
    }
    int from = _sourceSpaceValue;
    _sourceSpaceValue = value;
    if (hasValidated) {
      sourceSpaceValueChanged(from, value);
    }
  }

  void sourceSpaceValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// DestSpaceValue field with key 180.
  static const int destSpaceValueInitialValue = 0;
  int _destSpaceValue = destSpaceValueInitialValue;
  static const int destSpaceValuePropertyKey = 180;

  /// The destination transform space.
  int get destSpaceValue => _destSpaceValue;

  /// Change the [_destSpaceValue] field value.
  /// [destSpaceValueChanged] will be invoked only if the field's value has
  /// changed.
  set destSpaceValue(int value) {
    if (_destSpaceValue == value) {
      return;
    }
    int from = _destSpaceValue;
    _destSpaceValue = value;
    if (hasValidated) {
      destSpaceValueChanged(from, value);
    }
  }

  void destSpaceValueChanged(int from, int to);

  @override
  void copy(covariant TransformSpaceConstraintBase source) {
    super.copy(source);
    _sourceSpaceValue = source._sourceSpaceValue;
    _destSpaceValue = source._destSpaceValue;
  }
}
