import 'dart:collection';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/generated/animation/keyed_object_base.dart';
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
  @override
  bool validate() {
    if (!super.validate()) {
      return false;
    }
    var component = context.resolve<Component>(objectId);
    if (component == null) {
      return false;
    }
    return true;
  }

  @override
  void onRemoved() {
    super.onRemoved();
  }

  bool isValidKeyedProperty(KeyedProperty property) {
    var value = _keyedProperties[property.propertyKey];
    if (value != null && value != property) {
      return false;
    }
    return true;
  }

  bool internalAddKeyedProperty(KeyedProperty property) {
    var value = _keyedProperties[property.propertyKey];
    if (value != null && value != property) {
      return false;
    }
    _keyedProperties[property.propertyKey] = property;
    return true;
  }

  bool internalRemoveKeyedProperty(KeyedProperty property) {
    var removed = _keyedProperties.remove(property.propertyKey);
    if (_keyedProperties.isEmpty) {
      context.removeObject(this);
    }
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
