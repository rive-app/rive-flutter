import 'dart:collection';

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
  final HashMap<int, KeyedProperty> _keyedProperties =
      HashMap<int, KeyedProperty>();

  Iterable<KeyedProperty> get keyedProperties => _keyedProperties.values;

  // @override
  // String toString() => 'KeyedObject[$count]';

  // static int _objectCount = 0;
  // // static final List<LinearAnimation> _all = <LinearAnimation>[];
  // // static void dump() {
  // //   log('DUMPING LINEAR ANIMATIONS all=${_all.length} keyed=${_all.where((a) => a._keyedObjects.isNotEmpty).length} keys=${_all.map((a) => a._keyedObjects.length).sum}');
  // //   log(_all.where((a) => a._keyedObjects.isNotEmpty).map((a) => a.toString()).join('\n'));
  // // }

  // final int count = ++_objectCount;
  // late final bool logging = count % 50000 == 0;

  /// STOKANAL-FORK-EDIT: Reuse this object for every animation
  @override
  K? clone<K extends Core>() => this as K;

  // KeyedObject() {
  //
  //   if (logging) {
  //     log('CONSTRUCTED >> $this');
  //     debugPrintStack();
  //   }
  // }

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

  void reportKeyedCallbacks(
    double secondsFrom,
    double secondsTo, {
    required KeyedCallbackReporter reporter,
    bool isAtStartFrame = false,
  }) {
    for (final keyedProperty
        in _keyedProperties.values.where((property) => property.isCallback)) {
      keyedProperty.reportKeyedCallbacks(
        objectId,
        secondsFrom,
        secondsTo,
        reporter: reporter,
        isAtStartFrame: isAtStartFrame,
      );
    }
  }

  /// STOKANAL-FORK-EDIT: iterate properties with a list rather than with a map
  late final List<KeyedProperty> _properties = _keyedProperties.values.toList(growable: false);

  void apply(
    double time,
    double mix,
    CoreContext coreContext,
  ) {
    Core? object = coreContext.resolve(objectId);
    if (object == null) {
      return;
    }
    // for (final keyedProperty in _keyedProperties.values) {
    /// STOKANAL-FORK-EDIT: iterate properties with a list rather than with a map
    for (final keyedProperty in _properties) {
      if (keyedProperty.isCallback) {
        continue;
      }
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
