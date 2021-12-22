/// Core automatically generated
/// lib/src/generated/constraints/constraint_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/component.dart';

abstract class ConstraintBase extends Component {
  static const int typeKey = 79;
  @override
  int get coreType => ConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {ConstraintBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Strength field with key 172.
  static const double strengthInitialValue = 1.0;
  double _strength = strengthInitialValue;
  static const int strengthPropertyKey = 172;

  /// Strength of the constraint. 0 means off. 1 means fully constraining.
  double get strength => _strength;

  /// Change the [_strength] field value.
  /// [strengthChanged] will be invoked only if the field's value has changed.
  set strength(double value) {
    if (_strength == value) {
      return;
    }
    double from = _strength;
    _strength = value;
    if (hasValidated) {
      strengthChanged(from, value);
    }
  }

  void strengthChanged(double from, double to);

  @override
  void copy(covariant ConstraintBase source) {
    super.copy(source);
    _strength = source._strength;
  }
}
