import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyed_object_base.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';

import 'linear_animation.dart';

export 'package:rive/src/generated/animation/keyed_object_base.dart';

// ignore: one_member_abstracts
abstract class KeyedCallbackReporter {
  void reportKeyedCallback(
      int objectId, int propertyKey, double elapsedSeconds);
}

class KeyedObject extends KeyedObjectBase<RuntimeArtboard> {

  final Map<int, KeyedProperty> _keyedProperties = HashMap<int, KeyedProperty>();

  List<KeyedProperty>? _props;
  List<KeyedProperty> get keyedProperties =>
    _props ??= _keyedProperties.values.toList();

  List<KeyedProperty>? _keyedPropertiesNonCallback;
  List<KeyedProperty> get keyedPropertiesNonCallback =>
      _keyedPropertiesNonCallback ??= keyedProperties.whereNot((p) => p.isCallback).toList();

  List<KeyedProperty>? _keyedPropertiesCallback;
  List<KeyedProperty> get keyedPropertiesCallback =>
      _keyedPropertiesCallback ??= keyedProperties.where((p) => p.isCallback).toList();

  @override
  K? clone<K extends Core>() => this as K;

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
    _keyedPropertiesNonCallback = _props = null;

    return true;
  }

  /// Called by rive_core to remove a KeyedObject to the animation. This should
  /// be @internal when it's supported.
  bool internalRemoveKeyedProperty(KeyedProperty property) {
    var removed = _keyedProperties.remove(property.propertyKey);
    _keyedPropertiesNonCallback = _props = null;

    if (_keyedProperties.isEmpty) {
      // Remove this keyed property.
      context.removeObject(this);
    }
    // assert(removed == null || removed == property,
    //     '$removed was not $property or null');

    return removed != null;
  }

  void reportKeyedCallbacks(
    double secondsFrom,
    double secondsTo, {
    required KeyedCallbackReporter reporter,
    bool isAtStartFrame = false,
  }) {
    var ps = keyedPropertiesCallback; //keyedProperties;
    var t = ps.length;
    // KeyedProperty keyedProperty;
    for (var i = 0; i < t; i++) {
      // keyedProperty = ps[i];

      // if (!keyedProperty.isCallback) {
      //   continue;
      // }

      ps[i].reportKeyedCallbacks(
        objectId,
        secondsFrom,
        secondsTo,
        reporter: reporter,
        isAtStartFrame: isAtStartFrame,
      );
    }
  }

  void apply(
    double time,
    double mix,
    CoreContext coreContext,
  ) {
    var object = coreContext.resolve(objectId);
    if (object == null) {
      return;
    }

    var ps = keyedPropertiesNonCallback;
    var t = ps.length;
    KeyedProperty p;
    for (var i = 0; i < t; i++) { // for indexed has the best performance in Dart
      p = ps[i];
      if (p.keyframes.isEmpty) continue;
      p.apply(time, mix, object);
    }
  }

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
