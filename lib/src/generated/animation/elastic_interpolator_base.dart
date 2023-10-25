// Core automatically generated
// lib/src/generated/animation/elastic_interpolator_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyframe_interpolator.dart';

abstract class ElasticInterpolatorBase extends KeyFrameInterpolator {
  static const int typeKey = 174;
  @override
  int get coreType => ElasticInterpolatorBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ElasticInterpolatorBase.typeKey, KeyFrameInterpolatorBase.typeKey};

  /// --------------------------------------------------------------------------
  /// EasingValue field with key 405.
  static const int easingValuePropertyKey = 405;
  static const int easingValueInitialValue = 1;
  int _easingValue = easingValueInitialValue;
  int get easingValue => _easingValue;

  /// Change the [_easingValue] field value.
  /// [easingValueChanged] will be invoked only if the field's value has
  /// changed.
  set easingValue(int value) {
    if (_easingValue == value) {
      return;
    }
    int from = _easingValue;
    _easingValue = value;
    if (hasValidated) {
      easingValueChanged(from, value);
    }
  }

  void easingValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Amplitude field with key 406.
  static const int amplitudePropertyKey = 406;
  static const double amplitudeInitialValue = 1;
  double _amplitude = amplitudeInitialValue;

  /// The amplitude for the easing expressed as a percentage of the change.
  double get amplitude => _amplitude;

  /// Change the [_amplitude] field value.
  /// [amplitudeChanged] will be invoked only if the field's value has changed.
  set amplitude(double value) {
    if (_amplitude == value) {
      return;
    }
    double from = _amplitude;
    _amplitude = value;
    if (hasValidated) {
      amplitudeChanged(from, value);
    }
  }

  void amplitudeChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Period field with key 407.
  static const int periodPropertyKey = 407;
  static const double periodInitialValue = 1;
  double _period = periodInitialValue;

  /// The period of the elastic expressed as a percentage of the time
  /// difference.
  double get period => _period;

  /// Change the [_period] field value.
  /// [periodChanged] will be invoked only if the field's value has changed.
  set period(double value) {
    if (_period == value) {
      return;
    }
    double from = _period;
    _period = value;
    if (hasValidated) {
      periodChanged(from, value);
    }
  }

  void periodChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ElasticInterpolatorBase) {
      _easingValue = source._easingValue;
      _amplitude = source._amplitude;
      _period = source._period;
    }
  }
}
