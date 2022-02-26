/// Core automatically generated lib/src/generated/shapes/forced_edge_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/component.dart';

abstract class ForcedEdgeBase extends Component {
  static const int typeKey = 112;
  @override
  int get coreType => ForcedEdgeBase.typeKey;
  @override
  Set<int> get coreTypes => {ForcedEdgeBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// FromId field with key 219.
  static const int fromIdInitialValue = 0;
  int _fromId = fromIdInitialValue;
  static const int fromIdPropertyKey = 219;

  /// Identifier used to track MeshVertex the force edge extends from.
  int get fromId => _fromId;

  /// Change the [_fromId] field value.
  /// [fromIdChanged] will be invoked only if the field's value has changed.
  set fromId(int value) {
    if (_fromId == value) {
      return;
    }
    int from = _fromId;
    _fromId = value;
    if (hasValidated) {
      fromIdChanged(from, value);
    }
  }

  void fromIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// ToId field with key 220.
  static const int toIdInitialValue = 0;
  int _toId = toIdInitialValue;
  static const int toIdPropertyKey = 220;

  /// Identifier used to track MeshVertex the force edge extends to.
  int get toId => _toId;

  /// Change the [_toId] field value.
  /// [toIdChanged] will be invoked only if the field's value has changed.
  set toId(int value) {
    if (_toId == value) {
      return;
    }
    int from = _toId;
    _toId = value;
    if (hasValidated) {
      toIdChanged(from, value);
    }
  }

  void toIdChanged(int from, int to);

  @override
  void copy(covariant ForcedEdgeBase source) {
    super.copy(source);
    _fromId = source._fromId;
    _toId = source._toId;
  }
}
