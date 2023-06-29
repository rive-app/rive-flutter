/// Core automatically generated lib/src/generated/draw_target_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/component.dart';

abstract class DrawTargetBase extends Component {
  static const int typeKey = 48;
  @override
  int get coreType => DrawTargetBase.typeKey;
  @override
  Set<int> get coreTypes => {DrawTargetBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// DrawableId field with key 119.
  static const int drawableIdInitialValue = -1;
  int _drawableId = drawableIdInitialValue;
  static const int drawableIdPropertyKey = 119;

  /// Id of the drawable this target references.
  int get drawableId => _drawableId;

  /// Change the [_drawableId] field value.
  /// [drawableIdChanged] will be invoked only if the field's value has changed.
  set drawableId(int value) {
    if (_drawableId == value) {
      return;
    }
    int from = _drawableId;
    _drawableId = value;
    if (hasValidated) {
      drawableIdChanged(from, value);
    }
  }

  void drawableIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PlacementValue field with key 120.
  static const int placementValueInitialValue = 0;
  int _placementValue = placementValueInitialValue;
  static const int placementValuePropertyKey = 120;

  /// Backing enum value for the Placement.
  int get placementValue => _placementValue;

  /// Change the [_placementValue] field value.
  /// [placementValueChanged] will be invoked only if the field's value has
  /// changed.
  set placementValue(int value) {
    if (_placementValue == value) {
      return;
    }
    int from = _placementValue;
    _placementValue = value;
    if (hasValidated) {
      placementValueChanged(from, value);
    }
  }

  void placementValueChanged(int from, int to);

  @override
  void copy(covariant DrawTargetBase source) {
    super.copy(source);
    _drawableId = source._drawableId;
    _placementValue = source._placementValue;
  }
}
