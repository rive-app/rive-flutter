// Core automatically generated lib/src/generated/nested_artboard_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
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
  static const int artboardIdPropertyKey = 197;
  static const int artboardIdInitialValue = -1;
  int _artboardId = artboardIdInitialValue;

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

  /// --------------------------------------------------------------------------
  /// Fit field with key 538.
  static const int fitPropertyKey = 538;
  static const int fitInitialValue = 0;
  int _fit = fitInitialValue;

  /// Fit type for the nested artboard's runtime artboard.
  int get fit => _fit;

  /// Change the [_fit] field value.
  /// [fitChanged] will be invoked only if the field's value has changed.
  set fit(int value) {
    if (_fit == value) {
      return;
    }
    int from = _fit;
    _fit = value;
    if (hasValidated) {
      fitChanged(from, value);
    }
  }

  void fitChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Alignment field with key 539.
  static const int alignmentPropertyKey = 539;
  static const int alignmentInitialValue = 0;
  int _alignment = alignmentInitialValue;

  /// Alignment type for the nested artboard's runtime artboard.
  int get alignment => _alignment;

  /// Change the [_alignment] field value.
  /// [alignmentChanged] will be invoked only if the field's value has changed.
  set alignment(int value) {
    if (_alignment == value) {
      return;
    }
    int from = _alignment;
    _alignment = value;
    if (hasValidated) {
      alignmentChanged(from, value);
    }
  }

  void alignmentChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// DataBindPathIds field with key 582.
  static const int dataBindPathIdsPropertyKey = 582;
  static final Uint8List dataBindPathIdsInitialValue = Uint8List(0);
  Uint8List _dataBindPathIds = dataBindPathIdsInitialValue;

  /// Path to the selected property.
  Uint8List get dataBindPathIds => _dataBindPathIds;

  /// Change the [_dataBindPathIds] field value.
  /// [dataBindPathIdsChanged] will be invoked only if the field's value has
  /// changed.
  set dataBindPathIds(Uint8List value) {
    if (listEquals(_dataBindPathIds, value)) {
      return;
    }
    Uint8List from = _dataBindPathIds;
    _dataBindPathIds = value;
    if (hasValidated) {
      dataBindPathIdsChanged(from, value);
    }
  }

  void dataBindPathIdsChanged(Uint8List from, Uint8List to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is NestedArtboardBase) {
      _artboardId = source._artboardId;
      _fit = source._fit;
      _alignment = source._alignment;
      _dataBindPathIds = source._dataBindPathIds;
    }
  }
}
