import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/rive.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/notifier.dart';
// import 'package:stokanal/logging.dart';

/// Adds getters for linear animations and state machines
extension RuntimeArtboardGetters on RuntimeArtboard {
  /// Returns an iterable of linear animations in the artboard
  Iterable<LinearAnimation> get linearAnimations =>
      animations.whereType<LinearAnimation>();

  /// Returns an iterable of state machines in the artboard
  Iterable<StateMachine> get stateMachines =>
      animations.whereType<StateMachine>();
}

extension ArtboardRuntimeExtensions on Artboard {
  NestedArtboard? nestedArtboard(String name) {
    for (final artboard in activeNestedArtboards) {
      if (artboard.name == name) {
        return artboard;
      }
    }
    return null;
  }

  NestedArtboard? nestedArtboardAtPath(String path) {
    const delimiter = '/';
    final dIndex = path.indexOf(delimiter);
    final artboardName = dIndex == -1 ? path : path.substring(0, dIndex);
    final restOfPath =
        dIndex == -1 ? '' : path.substring(dIndex + 1, path.length);
    if (artboardName.isNotEmpty) {
      final nested = nestedArtboard(artboardName);
      if (nested != null) {
        if (restOfPath.isEmpty) {
          return nested;
        } else {
          return nested.nestedArtboardAtPath(restOfPath);
        }
      }
    }
    return null;
  }

  T? findSMI<T>(String name, String path) {
    final nested = nestedArtboardAtPath(path);
    if (nested != null) {
      if (nested.mountedArtboard is RuntimeMountedArtboard) {
        final runtimeMountedArtboard =
            nested.mountedArtboard as RuntimeMountedArtboard;
        final controllers = runtimeMountedArtboard.controllers;
        for (final controller in controllers) {
          for (final input in controller.inputs) {
            if (input is T && input.name == name) {
              return input as T;
            }
          }
        }
      }
    }
    return null;
  }

  /// Find a boolean input with a given name on a nested artboard at path.
  SMIBool? getBoolInput(String name, String path) =>
      findSMI<SMIBool>(name, path);

  /// Find a trigger input with a given name on a nested artboard at path.
  SMITrigger? getTriggerInput(String name, String path) =>
      findSMI<SMITrigger>(name, path);

  /// Find a number input with a given name on a nested artboard at path.
  ///
  /// See [triggerInput] to directly fire a trigger by its name.
  SMINumber? getNumberInput(String name, String path) =>
      findSMI<SMINumber>(name, path);

  /// Convenience method for firing a trigger input with a given name
  /// on a nested artboard at path.
  ///
  /// Also see [getTriggerInput] to get a reference to the trigger input. If the
  /// trigger happens frequently, it's more efficient to get a reference to the
  /// trigger input and call `trigger.fire()` directly.
  void triggerInput(String name, String path) =>
      getTriggerInput(name, path)?.fire();
}

/// This artboard type is purely for use by the runtime system and should not be
/// directly referenced. Use the Artboard type for any direct interactions with
/// an artboard, and use extension methods to add functionality to Artboard.
class RuntimeArtboard extends Artboard implements CoreContext {
  final _redraw = Notifier();
  ChangeNotifier get redraw => _redraw;

  /// Note that objects must be nullable as some may not resolve during load due
  /// to format differences.
  final _objects = <Core?>[];

  Iterable<Core?> get objects => _objects;
  final _needDependenciesBuilt = <Component>{};

  /// Indicates if this artboard is playing or paused
  bool _isPlaying = true;

  @override
  T? addObject<T extends Core>(T? object) {
    object?.context = this;
    object?.id = _objects.length;
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
    if (id < 0 || id >= _objects.length) {
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
    if (id < 0 || id >= _objects.length) {
      return defaultValue;
    }
    var object = _objects[id];
    if (object is T) {
      return object as T;
    }
    return defaultValue;
  }

  @override
  Core<CoreContext>? makeCoreInstance(int typeKey) =>
      RiveCoreContext.makeCoreInstance(typeKey);

  @override
  void dirty(void Function() dirt) {
    // TODO: Schedule a debounced callback for next frame
  }

  @override
  void markNeedsAdvance() {
    _redraw.notify();
  }

  @override
  Artboard instance() {
    var artboard = RuntimeArtboard();
    artboard.context = artboard;
    artboard.frameOrigin = frameOrigin;
    artboard.copy(this);
    artboard._objects.add(artboard);
    // First copy the objects ensuring onAddedDirty can later find them in the
    // _objects list.
    for (final object in _objects.skip(1)) {
      Core? clone = object?.clone();
      artboard.addObject(clone);
    }

    // Then run the onAddedDirty loop.
    for (final object in artboard.objects.skip(1)) {
      if (object is Component &&
          object.parentId == ComponentBase.parentIdInitialValue) {
        object.parent = artboard;
      }
      object?.onAddedDirty();
    }

    // animations.forEach(artboard.animations.add);
    for (final a in animations) {
      artboard.animations.add(a);
    }

    for (final object in artboard.objects) { //.toList(growable: false)) {
      if (object == null) {
        continue;
      }
      object.onAdded();
      InternalCoreHelper.markValid(object);
    }
    artboard.clean();

    // dump();

    return artboard;
  }

  /// STOKANAL-FORK-EDIT: Reuse this object for every animation
  void dump() {
    log(toString());
    log(objects
      .map((o) => o.runtimeType)
      .groupListsBy((o) => o)
      .entries
      .sorted((e1, e2) => e2.value.length - e1.value.length)
      .map((e) => '${e.key}: ${e.value.length}')
      .join('\n'));
  }

  /// STOKANAL-FORK-EDIT: Reuse this object for every animation
  @override
  String toString() {
    // LinearAnimation.dump(); // uncomment to dump animations
    return 'RuntimeArtboard[$name ${objects.length}]';
  }

  void addNestedEventListener(StateMachineController controller) {

    activeNestedArtboards.forEach((artboard) {
      if (artboard.mountedArtboard is RuntimeMountedArtboard) {
        (artboard.mountedArtboard as RuntimeMountedArtboard).eventCallback =
            (event, target) => _handleNestedEvent(event, target, controller);
      }
    });
  }

  void _handleNestedEvent(
      Event event, NestedArtboard target, StateMachineController controller) {
    if (controller.hasListenerWithTarget(target)) {
      controller.reportNestedEvent(event, target);
      SchedulerBinding.instance
          .addPostFrameCallback((_) => controller.isActive = true);
    }
  }

  @override
  void pause() {
    _isPlaying = false;
  }

  @override
  void play() {
    _isPlaying = true;
    markNeedsAdvance();
  }

  @override
  bool get isPlaying => _isPlaying;

  // @override
  void dispose() {
    // log('DISPOSING > $runtimeType ${artboard.name}');
  }
}
