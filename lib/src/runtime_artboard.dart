import 'package:flutter/foundation.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/core/core.dart';

class RuntimeArtboard extends Artboard implements CoreContext {
  /// Returns an animation with the given name, or null if no animation with
  /// that name exists in the artboard
  LinearAnimationInstance animationByName(String name) {
    final animation = animations.firstWhere(
      (animation) => animation is LinearAnimation && animation.name == name,
      orElse: () => null,
    );
    if (animation != null) {
      return LinearAnimationInstance(animation as LinearAnimation);
    }
    return null;
  }

  final _redraw = Event();
  ChangeNotifier get redraw => _redraw;

  final List<Core> _objects = [];

  Iterable<Core> get objects => _objects;
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
  void markDependencyOrderDirty() {
    // TODO: implement markDependencyOrderDirty
  }

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
  T resolve<T>(int id) {
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
  Core<CoreContext> makeCoreInstance(int typeKey) {
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
