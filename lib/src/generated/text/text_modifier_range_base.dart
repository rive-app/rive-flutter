/// Core automatically generated
/// lib/src/generated/text/text_modifier_range_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class TextModifierRangeBase extends ContainerComponent {
  static const int typeKey = 158;
  @override
  int get coreType => TextModifierRangeBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TextModifierRangeBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// ModifyFrom field with key 327.
  static const double modifyFromInitialValue = 0;
  double _modifyFrom = modifyFromInitialValue;
  static const int modifyFromPropertyKey = 327;
  double get modifyFrom => _modifyFrom;

  /// Change the [_modifyFrom] field value.
  /// [modifyFromChanged] will be invoked only if the field's value has changed.
  set modifyFrom(double value) {
    if (_modifyFrom == value) {
      return;
    }
    double from = _modifyFrom;
    _modifyFrom = value;
    if (hasValidated) {
      modifyFromChanged(from, value);
    }
  }

  void modifyFromChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ModifyTo field with key 336.
  static const double modifyToInitialValue = 1;
  double _modifyTo = modifyToInitialValue;
  static const int modifyToPropertyKey = 336;
  double get modifyTo => _modifyTo;

  /// Change the [_modifyTo] field value.
  /// [modifyToChanged] will be invoked only if the field's value has changed.
  set modifyTo(double value) {
    if (_modifyTo == value) {
      return;
    }
    double from = _modifyTo;
    _modifyTo = value;
    if (hasValidated) {
      modifyToChanged(from, value);
    }
  }

  void modifyToChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Strength field with key 334.
  static const double strengthInitialValue = 1;
  double _strength = strengthInitialValue;
  static const int strengthPropertyKey = 334;
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

  /// --------------------------------------------------------------------------
  /// UnitsValue field with key 316.
  static const int unitsValueInitialValue = 0;
  int _unitsValue = unitsValueInitialValue;
  static const int unitsValuePropertyKey = 316;
  int get unitsValue => _unitsValue;

  /// Change the [_unitsValue] field value.
  /// [unitsValueChanged] will be invoked only if the field's value has changed.
  set unitsValue(int value) {
    if (_unitsValue == value) {
      return;
    }
    int from = _unitsValue;
    _unitsValue = value;
    if (hasValidated) {
      unitsValueChanged(from, value);
    }
  }

  void unitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// TypeValue field with key 325.
  static const int typeValueInitialValue = 0;
  int _typeValue = typeValueInitialValue;
  static const int typeValuePropertyKey = 325;
  int get typeValue => _typeValue;

  /// Change the [_typeValue] field value.
  /// [typeValueChanged] will be invoked only if the field's value has changed.
  set typeValue(int value) {
    if (_typeValue == value) {
      return;
    }
    int from = _typeValue;
    _typeValue = value;
    if (hasValidated) {
      typeValueChanged(from, value);
    }
  }

  void typeValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// ModeValue field with key 326.
  static const int modeValueInitialValue = 0;
  int _modeValue = modeValueInitialValue;
  static const int modeValuePropertyKey = 326;
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

  /// --------------------------------------------------------------------------
  /// Clamp field with key 333.
  static const bool clampInitialValue = false;
  bool _clamp = clampInitialValue;
  static const int clampPropertyKey = 333;
  bool get clamp => _clamp;

  /// Change the [_clamp] field value.
  /// [clampChanged] will be invoked only if the field's value has changed.
  set clamp(bool value) {
    if (_clamp == value) {
      return;
    }
    bool from = _clamp;
    _clamp = value;
    if (hasValidated) {
      clampChanged(from, value);
    }
  }

  void clampChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// FalloffFrom field with key 317.
  static const double falloffFromInitialValue = 0;
  double _falloffFrom = falloffFromInitialValue;
  static const int falloffFromPropertyKey = 317;
  double get falloffFrom => _falloffFrom;

  /// Change the [_falloffFrom] field value.
  /// [falloffFromChanged] will be invoked only if the field's value has
  /// changed.
  set falloffFrom(double value) {
    if (_falloffFrom == value) {
      return;
    }
    double from = _falloffFrom;
    _falloffFrom = value;
    if (hasValidated) {
      falloffFromChanged(from, value);
    }
  }

  void falloffFromChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// FalloffTo field with key 318.
  static const double falloffToInitialValue = 1;
  double _falloffTo = falloffToInitialValue;
  static const int falloffToPropertyKey = 318;
  double get falloffTo => _falloffTo;

  /// Change the [_falloffTo] field value.
  /// [falloffToChanged] will be invoked only if the field's value has changed.
  set falloffTo(double value) {
    if (_falloffTo == value) {
      return;
    }
    double from = _falloffTo;
    _falloffTo = value;
    if (hasValidated) {
      falloffToChanged(from, value);
    }
  }

  void falloffToChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Offset field with key 319.
  static const double offsetInitialValue = 0;
  double _offset = offsetInitialValue;
  static const int offsetPropertyKey = 319;
  double get offset => _offset;

  /// Change the [_offset] field value.
  /// [offsetChanged] will be invoked only if the field's value has changed.
  set offset(double value) {
    if (_offset == value) {
      return;
    }
    double from = _offset;
    _offset = value;
    if (hasValidated) {
      offsetChanged(from, value);
    }
  }

  void offsetChanged(double from, double to);

  @override
  void copy(covariant TextModifierRangeBase source) {
    super.copy(source);
    _modifyFrom = source._modifyFrom;
    _modifyTo = source._modifyTo;
    _strength = source._strength;
    _unitsValue = source._unitsValue;
    _typeValue = source._typeValue;
    _modeValue = source._modeValue;
    _clamp = source._clamp;
    _falloffFrom = source._falloffFrom;
    _falloffTo = source._falloffTo;
    _offset = source._offset;
  }
}
