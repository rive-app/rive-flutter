// Core automatically generated
// lib/src/generated/layout/track_sizing_function_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class TrackSizingFunctionBase extends Component {
  static const int typeKey = 176;
  @override
  int get coreType => TrackSizingFunctionBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {TrackSizingFunctionBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// MinTypeTag field with key 459.
  static const int minTypeTagPropertyKey = 459;
  static const int minTypeTagInitialValue = 3;
  int _minTypeTag = minTypeTagInitialValue;

  /// Layout tag (type) for min size value (fixed|minContent|maxContent|auto).
  int get minTypeTag => _minTypeTag;

  /// Change the [_minTypeTag] field value.
  /// [minTypeTagChanged] will be invoked only if the field's value has changed.
  set minTypeTag(int value) {
    if (_minTypeTag == value) {
      return;
    }
    int from = _minTypeTag;
    _minTypeTag = value;
    if (hasValidated) {
      minTypeTagChanged(from, value);
    }
  }

  void minTypeTagChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MinValueTag field with key 460.
  static const int minValueTagPropertyKey = 460;
  static const int minValueTagInitialValue = 0;
  int _minValueTag = minValueTagInitialValue;

  /// Dimension tag (type) for min size value (points|percent|auto).
  int get minValueTag => _minValueTag;

  /// Change the [_minValueTag] field value.
  /// [minValueTagChanged] will be invoked only if the field's value has
  /// changed.
  set minValueTag(int value) {
    if (_minValueTag == value) {
      return;
    }
    int from = _minValueTag;
    _minValueTag = value;
    if (hasValidated) {
      minValueTagChanged(from, value);
    }
  }

  void minValueTagChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MinValue field with key 461.
  static const int minValuePropertyKey = 461;
  static const double minValueInitialValue = 0;
  double _minValue = minValueInitialValue;

  /// Min size value.
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
  /// MaxTypeTag field with key 462.
  static const int maxTypeTagPropertyKey = 462;
  static const int maxTypeTagInitialValue = 4;
  int _maxTypeTag = maxTypeTagInitialValue;

  /// Layout tag for max size value
  /// (fixed|minContent|maxContent|fitContent|auto|fraction).
  int get maxTypeTag => _maxTypeTag;

  /// Change the [_maxTypeTag] field value.
  /// [maxTypeTagChanged] will be invoked only if the field's value has changed.
  set maxTypeTag(int value) {
    if (_maxTypeTag == value) {
      return;
    }
    int from = _maxTypeTag;
    _maxTypeTag = value;
    if (hasValidated) {
      maxTypeTagChanged(from, value);
    }
  }

  void maxTypeTagChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MaxValueTag field with key 463.
  static const int maxValueTagPropertyKey = 463;
  static const int maxValueTagInitialValue = 0;
  int _maxValueTag = maxValueTagInitialValue;

  /// Dimension tag (type) for max size value (points|percent|auto).
  int get maxValueTag => _maxValueTag;

  /// Change the [_maxValueTag] field value.
  /// [maxValueTagChanged] will be invoked only if the field's value has
  /// changed.
  set maxValueTag(int value) {
    if (_maxValueTag == value) {
      return;
    }
    int from = _maxValueTag;
    _maxValueTag = value;
    if (hasValidated) {
      maxValueTagChanged(from, value);
    }
  }

  void maxValueTagChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MaxValue field with key 464.
  static const int maxValuePropertyKey = 464;
  static const double maxValueInitialValue = 0;
  double _maxValue = maxValueInitialValue;

  /// Max size value.
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

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TrackSizingFunctionBase) {
      _minTypeTag = source._minTypeTag;
      _minValueTag = source._minValueTag;
      _minValue = source._minValue;
      _maxTypeTag = source._maxTypeTag;
      _maxValueTag = source._maxValueTag;
      _maxValue = source._maxValue;
    }
  }
}
