/// Core automatically generated lib/src/generated/shapes/image_base.dart.
/// Do not modify manually.

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

  @override
  void copy(covariant ImageBase source) {
    super.copy(source);
    _assetId = source._assetId;
  }
}
