import 'package:flutter/foundation.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/core/core.dart';

/// This artboard type is purely for use by the runtime system and should not be
/// directly referenced. Use the Artboard type for any direct interactions with
/// an artboard, and use extension methods to add functionality to Artboard.
class RuntimeArtboard extends Artboard implements CoreContext {
  final _redraw = Event();
  ChangeNotifier get redraw => _redraw;

  /// Note that objects must be nullable as some may not resolve during load due
  /// to format differences.
  final List<Core?> _objects = [];

  Iterable<Core?> get objects => _objects;
  final Set<Component> _needDependenciesBuilt = {};

  @override
  T addObject<T extends Core>(T object) {
    object.context = this;
    object.id = _objects.length;

    _objects.add(object);
    return object;
  }

  @override
  void removeObject<T extends Core>(T object) {
    _objects.remove(object);
  }

  @override
  void markDependencyOrderDirty() {}

  @override
  bool markDependenciesDirty(covariant Core object) {
    if (object is Component) {
      _needDependenciesBuilt.add(object);
      return true;
    }

    return false;
  }

  void clean() {
    if (_needDependenciesBuilt.isNotEmpty) {
      // Copy it in case it is changed during the building (meaning this process
      // needs to recurse).
      Set<Component> needDependenciesBuilt =
          Set<Component>.from(_needDependenciesBuilt);
      _needDependenciesBuilt.clear();

      // First resolve the artboards
      for (final component in needDependenciesBuilt) {
        component.resolveArtboard();
      }

      // Then build the dependencies
      for (final component in needDependenciesBuilt) {
        component.buildDependencies();
      }

      sortDependencies();
      computeDrawOrder();
    }
  }

  @override
  T? resolve<T>(int id) {
    if (id >= _objects.length) {
      return null;
    }
    var object = _objects[id];
    if (object is T) {
      return object as T;
    }
    return null;
  }

  @override
  T resolveWithDefault<T>(int id, T defaultValue) {
    if (id >= _objects.length) {
      return defaultValue;
    }
    var object = _objects[id];
    if (object is T) {
      return object as T;
    }
    return defaultValue;
  }

  @override
  Core<CoreContext>? makeCoreInstance(int typeKey) {
    return null;
  }

  @override
  void dirty(void Function() dirt) {
    // TODO: Schedule a debounced callback for next frame
  }

  @override
  void markNeedsAdvance() {
    _redraw.notify();
  }
}
