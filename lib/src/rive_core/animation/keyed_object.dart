import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyed_object_base.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';

import 'linear_animation.dart';

export 'package:rive/src/generated/animation/keyed_object_base.dart';

class KeyedObject extends KeyedObjectBase<RuntimeArtboard> {
  final HashMap<int, KeyedProperty> _keyedProperties =
      HashMap<int, KeyedProperty>();

  Iterable<KeyedProperty> get keyedProperties => _keyedProperties.values;

  @override
  void onAddedDirty() {}

  @override
  void onAdded() {}


  bool isValidKeyedProperty(KeyedProperty property) {
    var value = _keyedProperties[property.propertyKey];

    // If the property is already keyed, that's ok just make sure the
    // KeyedObject matches.
    if (value != null && value != property) {
      return false;
    }
    return true;
  }

  /// Called by rive_core to add a KeyedProperty to the animation. This should
  /// be @internal when it's supported.
  bool internalAddKeyedProperty(KeyedProperty property) {
    var value = _keyedProperties[property.propertyKey];

    // If the property is already keyed, that's ok just make sure the
    // KeyedObject matches.
    if (value != null && value != property) {
      return false;
    }
    _keyedProperties[property.propertyKey] = property;

    return true;
  }

  /// Called by rive_core to remove a KeyedObject to the animation. This should
  /// be @internal when it's supported.
  bool internalRemoveKeyedProperty(KeyedProperty property) {
    var removed = _keyedProperties.remove(property.propertyKey);

    if (_keyedProperties.isEmpty) {
      // Remove this keyed property.
      context.removeObject(this);
    }
    // assert(removed == null || removed == property,
    //     '$removed was not $property or null');

    return removed != null;
  }

  void apply(double time, double mix, CoreContext coreContext) {
    Core? object = coreContext.resolve(objectId);
    if (object == null) {
      return;
    }
    for (final keyedProperty in _keyedProperties.values) {
      keyedProperty.apply(time, mix, object);
    }
  }

  @override
  void objectIdChanged(int from, int to) {}

  @override
  bool import(ImportStack stack) {
    var animationHelper =
        stack.latest<LinearAnimationImporter>(LinearAnimationBase.typeKey);
    if (animationHelper == null) {
      return false;
    }
    animationHelper.addKeyedObject(this);

    return super.import(stack);
  }
}
