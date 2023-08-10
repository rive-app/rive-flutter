// Core automatically generated lib/src/generated/shapes/image_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/drawable.dart';

abstract class ImageBase extends Drawable {
  static const int typeKey = 100;
  @override
  int get coreType => ImageBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ImageBase.typeKey,
        DrawableBase.typeKey,
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// AssetId field with key 206.
  static const int assetIdInitialValue = -1;
  int _assetId = assetIdInitialValue;
  static const int assetIdPropertyKey = 206;

  /// Image drawable for an image asset
  int get assetId => _assetId;

  /// Change the [_assetId] field value.
  /// [assetIdChanged] will be invoked only if the field's value has changed.
  set assetId(int value) {
    if (_assetId == value) {
      return;
    }
    int from = _assetId;
    _assetId = value;
    if (hasValidated) {
      assetIdChanged(from, value);
    }
  }

  void assetIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// OriginX field with key 380.
  static const double originXInitialValue = 0.5;
  double _originX = originXInitialValue;
  static const int originXPropertyKey = 380;

  /// Origin x in normalized coordinates (0.5 = center, 0 = left, 1 = right).
  double get originX => _originX;

  /// Change the [_originX] field value.
  /// [originXChanged] will be invoked only if the field's value has changed.
  set originX(double value) {
    if (_originX == value) {
      return;
    }
    double from = _originX;
    _originX = value;
    if (hasValidated) {
      originXChanged(from, value);
    }
  }

  void originXChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// OriginY field with key 381.
  static const double originYInitialValue = 0.5;
  double _originY = originYInitialValue;
  static const int originYPropertyKey = 381;

  /// Origin y in normalized coordinates (0.5 = center, 0 = top, 1 = bottom).
  double get originY => _originY;

  /// Change the [_originY] field value.
  /// [originYChanged] will be invoked only if the field's value has changed.
  set originY(double value) {
    if (_originY == value) {
      return;
    }
    double from = _originY;
    _originY = value;
    if (hasValidated) {
      originYChanged(from, value);
    }
  }

  void originYChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ImageBase) {
      _assetId = source._assetId;
      _originX = source._originX;
      _originY = source._originY;
    }
  }
}
