/// Core automatically generated
/// lib/src/generated/shapes/paint/trim_path_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/component.dart';

abstract class TrimPathBase extends Component {
  static const int typeKey = 47;
  @override
  int get coreType => TrimPathBase.typeKey;
  @override
  Set<int> get coreTypes => {TrimPathBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Start field with key 114.
  static const double startInitialValue = 0;
  double _start = startInitialValue;
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
    if (hasValidated) {
      startChanged(from, value);
    }
  }

  void startChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// End field with key 115.
  static const double endInitialValue = 0;
  double _end = endInitialValue;
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
    if (hasValidated) {
      endChanged(from, value);
    }
  }

  void endChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Offset field with key 116.
  static const double offsetInitialValue = 0;
  double _offset = offsetInitialValue;
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
    if (hasValidated) {
      offsetChanged(from, value);
    }
  }

  void offsetChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ModeValue field with key 117.
  static const int modeValueInitialValue = 0;
  int _modeValue = modeValueInitialValue;
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
    if (hasValidated) {
      modeValueChanged(from, value);
    }
  }

  void modeValueChanged(int from, int to);

  @override
  void copy(covariant TrimPathBase source) {
    super.copy(source);
    _start = source._start;
    _end = source._end;
    _offset = source._offset;
    _modeValue = source._modeValue;
  }
}
