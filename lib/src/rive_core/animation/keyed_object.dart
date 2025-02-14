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

  /// STOKANAL-FORK-EDIT: Keeping a copy of values lazily
  List<KeyedProperty>? _props;
  List<KeyedProperty> get keyedProperties =>
    _props ??= _keyedProperties.values.toList();

  List<KeyedProperty>? _propsNonCallback;
  List<KeyedProperty> get propsNonCallback =>
      _propsNonCallback ??= keyedProperties.whereNot((p) => p.isCallback).toList();

  /// STOKANAL-FORK-EDIT: Reuse this object for every animation
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
    _propsNonCallback = _props = null;

    return true;
  }

  /// Called by rive_core to remove a KeyedObject to the animation. This should
  /// be @internal when it's supported.
  bool internalRemoveKeyedProperty(KeyedProperty property) {
    var removed = _keyedProperties.remove(property.propertyKey);
    _propsNonCallback = _props = null;

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

    var ps = keyedProperties;
    var t = ps.length;
    KeyedProperty keyedProperty;
    for (var i = 0; i < t; i++) {
      keyedProperty = ps[i];
    // for (final keyedProperty in keyedProperties) {

      if (!keyedProperty.isCallback) {
        continue;
      }

      keyedProperty.reportKeyedCallbacks(
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

    var ps = propsNonCallback;
    var t = ps.length;
    for (var i = 0; i < t; i++) {
      ps[i].apply(time, mix, object);
    }
    // for (final keyedProperty in propsNonCallback) {
    //   keyedProperty.apply(time, mix, object);
    // }
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
