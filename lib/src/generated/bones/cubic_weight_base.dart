/// Core automatically generated lib/src/generated/bones/cubic_weight_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/bones/weight.dart';

abstract class CubicWeightBase extends Weight {
  static const int typeKey = 46;
  @override
  int get coreType => CubicWeightBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {CubicWeightBase.typeKey, WeightBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// InValues field with key 110.
  static const int inValuesInitialValue = 255;
  int _inValues = inValuesInitialValue;
  static const int inValuesPropertyKey = 110;
  int get inValues => _inValues;

  /// Change the [_inValues] field value.
  /// [inValuesChanged] will be invoked only if the field's value has changed.
  set inValues(int value) {
    if (_inValues == value) {
      return;
    }
    int from = _inValues;
    _inValues = value;
    if (hasValidated) {
      inValuesChanged(from, value);
    }
  }

  void inValuesChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// InIndices field with key 111.
  static const int inIndicesInitialValue = 1;
  int _inIndices = inIndicesInitialValue;
  static const int inIndicesPropertyKey = 111;
  int get inIndices => _inIndices;

  /// Change the [_inIndices] field value.
  /// [inIndicesChanged] will be invoked only if the field's value has changed.
  set inIndices(int value) {
    if (_inIndices == value) {
      return;
    }
    int from = _inIndices;
    _inIndices = value;
    if (hasValidated) {
      inIndicesChanged(from, value);
    }
  }

  void inIndicesChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// OutValues field with key 112.
  static const int outValuesInitialValue = 255;
  int _outValues = outValuesInitialValue;
  static const int outValuesPropertyKey = 112;
  int get outValues => _outValues;

  /// Change the [_outValues] field value.
  /// [outValuesChanged] will be invoked only if the field's value has changed.
  set outValues(int value) {
    if (_outValues == value) {
      return;
    }
    int from = _outValues;
    _outValues = value;
    if (hasValidated) {
      outValuesChanged(from, value);
    }
  }

  void outValuesChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// OutIndices field with key 113.
  static const int outIndicesInitialValue = 1;
  int _outIndices = outIndicesInitialValue;
  static const int outIndicesPropertyKey = 113;
  int get outIndices => _outIndices;

  /// Change the [_outIndices] field value.
  /// [outIndicesChanged] will be invoked only if the field's value has changed.
  set outIndices(int value) {
    if (_outIndices == value) {
      return;
    }
    int from = _outIndices;
    _outIndices = value;
    if (hasValidated) {
      outIndicesChanged(from, value);
    }
  }

  void outIndicesChanged(int from, int to);

  @override
  void copy(covariant CubicWeightBase source) {
    super.copy(source);
    _inValues = source._inValues;
    _inIndices = source._inIndices;
    _outValues = source._outValues;
    _outIndices = source._outIndices;
  }
}
