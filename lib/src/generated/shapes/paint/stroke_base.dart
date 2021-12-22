/// Core automatically generated
/// lib/src/generated/shapes/paint/stroke_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint.dart';

abstract class StrokeBase extends ShapePaint {
  static const int typeKey = 24;
  @override
  int get coreType => StrokeBase.typeKey;
  @override
  Set<int> get coreTypes => {
        StrokeBase.typeKey,
        ShapePaintBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Thickness field with key 47.
  static const double thicknessInitialValue = 1;
  double _thickness = thicknessInitialValue;
  static const int thicknessPropertyKey = 47;
  double get thickness => _thickness;

  /// Change the [_thickness] field value.
  /// [thicknessChanged] will be invoked only if the field's value has changed.
  set thickness(double value) {
    if (_thickness == value) {
      return;
    }
    double from = _thickness;
    _thickness = value;
    if (hasValidated) {
      thicknessChanged(from, value);
    }
  }

  void thicknessChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Cap field with key 48.
  static const int capInitialValue = 0;
  int _cap = capInitialValue;
  static const int capPropertyKey = 48;
  int get cap => _cap;

  /// Change the [_cap] field value.
  /// [capChanged] will be invoked only if the field's value has changed.
  set cap(int value) {
    if (_cap == value) {
      return;
    }
    int from = _cap;
    _cap = value;
    if (hasValidated) {
      capChanged(from, value);
    }
  }

  void capChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Join field with key 49.
  static const int joinInitialValue = 0;
  int _join = joinInitialValue;
  static const int joinPropertyKey = 49;
  int get join => _join;

  /// Change the [_join] field value.
  /// [joinChanged] will be invoked only if the field's value has changed.
  set join(int value) {
    if (_join == value) {
      return;
    }
    int from = _join;
    _join = value;
    if (hasValidated) {
      joinChanged(from, value);
    }
  }

  void joinChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// TransformAffectsStroke field with key 50.
  static const bool transformAffectsStrokeInitialValue = true;
  bool _transformAffectsStroke = transformAffectsStrokeInitialValue;
  static const int transformAffectsStrokePropertyKey = 50;
  bool get transformAffectsStroke => _transformAffectsStroke;

  /// Change the [_transformAffectsStroke] field value.
  /// [transformAffectsStrokeChanged] will be invoked only if the field's value
  /// has changed.
  set transformAffectsStroke(bool value) {
    if (_transformAffectsStroke == value) {
      return;
    }
    bool from = _transformAffectsStroke;
    _transformAffectsStroke = value;
    if (hasValidated) {
      transformAffectsStrokeChanged(from, value);
    }
  }

  void transformAffectsStrokeChanged(bool from, bool to);

  @override
  void copy(covariant StrokeBase source) {
    super.copy(source);
    _thickness = source._thickness;
    _cap = source._cap;
    _join = source._join;
    _transformAffectsStroke = source._transformAffectsStroke;
  }
}
