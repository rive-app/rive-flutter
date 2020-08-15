/// Core automatically generated
/// lib/src/generated/shapes/clipping_shape_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class ClippingShapeBase extends Component {
  static const int typeKey = 42;
  @override
  int get coreType => ClippingShapeBase.typeKey;
  @override
  Set<int> get coreTypes => {ClippingShapeBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// ShapeId field with key 92.
  int _shapeId;
  static const int shapeIdPropertyKey = 92;

  /// Identifier used to track the shape to use as a clipping source.
  int get shapeId => _shapeId;

  /// Change the [_shapeId] field value.
  /// [shapeIdChanged] will be invoked only if the field's value has changed.
  set shapeId(int value) {
    if (_shapeId == value) {
      return;
    }
    int from = _shapeId;
    _shapeId = value;
    shapeIdChanged(from, value);
  }

  void shapeIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// ClipOpValue field with key 93.
  int _clipOpValue = 0;
  static const int clipOpValuePropertyKey = 93;

  /// Backing enum value for the clipping operation type (intersection or
  /// difference).
  int get clipOpValue => _clipOpValue;

  /// Change the [_clipOpValue] field value.
  /// [clipOpValueChanged] will be invoked only if the field's value has
  /// changed.
  set clipOpValue(int value) {
    if (_clipOpValue == value) {
      return;
    }
    int from = _clipOpValue;
    _clipOpValue = value;
    clipOpValueChanged(from, value);
  }

  void clipOpValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// IsVisible field with key 94.
  bool _isVisible = true;
  static const int isVisiblePropertyKey = 94;
  bool get isVisible => _isVisible;

  /// Change the [_isVisible] field value.
  /// [isVisibleChanged] will be invoked only if the field's value has changed.
  set isVisible(bool value) {
    if (_isVisible == value) {
      return;
    }
    bool from = _isVisible;
    _isVisible = value;
    isVisibleChanged(from, value);
  }

  void isVisibleChanged(bool from, bool to);
}
