/// Core automatically generated lib/src/generated/shapes/text_run_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/drawable.dart';

abstract class TextRunBase extends Drawable {
  static const int typeKey = 113;
  @override
  int get coreType => TextRunBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TextRunBase.typeKey,
        DrawableBase.typeKey,
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// PointSize field with key 221.
  static const double pointSizeInitialValue = 16;
  double _pointSize = pointSizeInitialValue;
  static const int pointSizePropertyKey = 221;

  /// The point size for text styled by this run.
  double get pointSize => _pointSize;

  /// Change the [_pointSize] field value.
  /// [pointSizeChanged] will be invoked only if the field's value has changed.
  set pointSize(double value) {
    if (_pointSize == value) {
      return;
    }
    double from = _pointSize;
    _pointSize = value;
    if (hasValidated) {
      pointSizeChanged(from, value);
    }
  }

  void pointSizeChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// TextLength field with key 222.
  static const int textLengthInitialValue = 0;
  int _textLength = textLengthInitialValue;
  static const int textLengthPropertyKey = 222;

  /// The length of the text styled by this run.
  int get textLength => _textLength;

  /// Change the [_textLength] field value.
  /// [textLengthChanged] will be invoked only if the field's value has changed.
  set textLength(int value) {
    if (_textLength == value) {
      return;
    }
    int from = _textLength;
    _textLength = value;
    if (hasValidated) {
      textLengthChanged(from, value);
    }
  }

  void textLengthChanged(int from, int to);

  @override
  void copy(covariant TextRunBase source) {
    super.copy(source);
    _pointSize = source._pointSize;
    _textLength = source._textLength;
  }
}
