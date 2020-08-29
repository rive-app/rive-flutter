/// Core automatically generated
/// lib/src/generated/shapes/paint/trim_path_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class TrimPathBase extends Component {
  static const int typeKey = 47;
  @override
  int get coreType => TrimPathBase.typeKey;
  @override
  Set<int> get coreTypes => {TrimPathBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Start field with key 114.
  double _start = 0;
  static const int startPropertyKey = 114;
  double get start => _start;

  /// Change the [_start] field value.
  /// [startChanged] will be invoked only if the field's value has changed.
  set start(double value) {
    if (_start == value) {
      return;
    }
    double from = _start;
    _start = value;
    startChanged(from, value);
  }

  void startChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// End field with key 115.
  double _end = 0;
  static const int endPropertyKey = 115;
  double get end => _end;

  /// Change the [_end] field value.
  /// [endChanged] will be invoked only if the field's value has changed.
  set end(double value) {
    if (_end == value) {
      return;
    }
    double from = _end;
    _end = value;
    endChanged(from, value);
  }

  void endChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Offset field with key 116.
  double _offset = 0;
  static const int offsetPropertyKey = 116;
  double get offset => _offset;

  /// Change the [_offset] field value.
  /// [offsetChanged] will be invoked only if the field's value has changed.
  set offset(double value) {
    if (_offset == value) {
      return;
    }
    double from = _offset;
    _offset = value;
    offsetChanged(from, value);
  }

  void offsetChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ModeValue field with key 117.
  int _modeValue = 0;
  static const int modeValuePropertyKey = 117;
  int get modeValue => _modeValue;

  /// Change the [_modeValue] field value.
  /// [modeValueChanged] will be invoked only if the field's value has changed.
  set modeValue(int value) {
    if (_modeValue == value) {
      return;
    }
    int from = _modeValue;
    _modeValue = value;
    modeValueChanged(from, value);
  }

  void modeValueChanged(int from, int to);
}
