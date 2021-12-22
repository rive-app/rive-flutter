/// Core automatically generated lib/src/generated/nested_artboard_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/drawable.dart';

abstract class NestedArtboardBase extends Drawable {
  static const int typeKey = 92;
  @override
  int get coreType => NestedArtboardBase.typeKey;
  @override
  Set<int> get coreTypes => {
        NestedArtboardBase.typeKey,
        DrawableBase.typeKey,
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// ArtboardId field with key 197.
  static const int artboardIdInitialValue = -1;
  int _artboardId = artboardIdInitialValue;
  static const int artboardIdPropertyKey = 197;

  /// Identifier used to track the Artboard nested.
  int get artboardId => _artboardId;

  /// Change the [_artboardId] field value.
  /// [artboardIdChanged] will be invoked only if the field's value has changed.
  set artboardId(int value) {
    if (_artboardId == value) {
      return;
    }
    int from = _artboardId;
    _artboardId = value;
    if (hasValidated) {
      artboardIdChanged(from, value);
    }
  }

  void artboardIdChanged(int from, int to);

  @override
  void copy(covariant NestedArtboardBase source) {
    super.copy(source);
    _artboardId = source._artboardId;
  }
}
