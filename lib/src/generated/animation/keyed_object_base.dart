/// Core automatically generated
/// lib/src/generated/animation/keyed_object_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class KeyedObjectBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 25;
  @override
  int get coreType => KeyedObjectBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyedObjectBase.typeKey};

  /// --------------------------------------------------------------------------
  /// ObjectId field with key 51.
  static const int objectIdInitialValue = 0;
  int _objectId = objectIdInitialValue;
  static const int objectIdPropertyKey = 51;

  /// Identifier used to track the object that is keyed.
  int get objectId => _objectId;

  /// Change the [_objectId] field value.
  /// [objectIdChanged] will be invoked only if the field's value has changed.
  set objectId(int value) {
    if (_objectId == value) {
      return;
    }
    int from = _objectId;
    _objectId = value;
    if (hasValidated) {
      objectIdChanged(from, value);
    }
  }

  void objectIdChanged(int from, int to);

  @override
  void copy(covariant KeyedObjectBase source) {
    _objectId = source._objectId;
  }
}
