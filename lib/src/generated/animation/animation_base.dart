/// Core automatically generated
/// lib/src/generated/animation/animation_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class AnimationBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 27;
  @override
  int get coreType => AnimationBase.typeKey;
  @override
  Set<int> get coreTypes => {AnimationBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Name field with key 55.
  static const String nameInitialValue = '';
  String _name = nameInitialValue;
  static const int namePropertyKey = 55;

  /// Name of the animation.
  String get name => _name;

  /// Change the [_name] field value.
  /// [nameChanged] will be invoked only if the field's value has changed.
  set name(String value) {
    if (_name == value) {
      return;
    }
    String from = _name;
    _name = value;
    if (hasValidated) {
      nameChanged(from, value);
    }
  }

  void nameChanged(String from, String to);

  @override
  void copy(covariant AnimationBase source) {
    _name = source._name;
  }
}
