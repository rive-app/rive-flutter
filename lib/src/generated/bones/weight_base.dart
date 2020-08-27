/// Core automatically generated lib/src/generated/bones/weight_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class WeightBase extends Component {
  static const int typeKey = 45;
  @override
  int get coreType => WeightBase.typeKey;
  @override
  Set<int> get coreTypes => {WeightBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Values field with key 102.
  int _values = 255;
  static const int valuesPropertyKey = 102;
  int get values => _values;

  /// Change the [_values] field value.
  /// [valuesChanged] will be invoked only if the field's value has changed.
  set values(int value) {
    if (_values == value) {
      return;
    }
    int from = _values;
    _values = value;
    valuesChanged(from, value);
  }

  void valuesChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Indices field with key 103.
  int _indices = 1;
  static const int indicesPropertyKey = 103;
  int get indices => _indices;

  /// Change the [_indices] field value.
  /// [indicesChanged] will be invoked only if the field's value has changed.
  set indices(int value) {
    if (_indices == value) {
      return;
    }
    int from = _indices;
    _indices = value;
    indicesChanged(from, value);
  }

  void indicesChanged(int from, int to);
}
