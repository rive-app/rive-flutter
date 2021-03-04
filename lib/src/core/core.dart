import 'dart:collection';

export 'package:rive/src/animation_list.dart';
export 'package:rive/src/state_machine_components.dart';
export 'package:rive/src/state_transition_conditions.dart';
export 'package:rive/src/container_children.dart';
export 'package:rive/src/runtime_artboard.dart';
export 'package:rive/src/generated/rive_core_context.dart';
export 'package:rive/src/core/importers/artboard_importer.dart';
export 'package:rive/src/core/importers/linear_animation_importer.dart';
export 'package:rive/src/core/importers/keyed_object_importer.dart';
export 'package:rive/src/core/importers/keyed_property_importer.dart';
export 'package:rive/src/core/importers/state_machine_importer.dart';
export 'package:rive/src/core/importers/state_machine_layer_importer.dart';
export 'package:rive/src/core/importers/layer_state_importer.dart';
export 'package:rive/src/core/importers/state_transition_importer.dart';

typedef PropertyChangeCallback = void Function(dynamic from, dynamic to);
typedef BatchAddCallback = void Function();

abstract class Core<T extends CoreContext> {
  covariant T context;
  int get coreType;
  int id;
  Set<int> get coreTypes => {};

  void onAddedDirty();
  void onAdded();
  void onRemoved() {}
  void remove() => context?.removeObject(this);
  bool import(ImportStack stack) => true;
}

abstract class CoreContext {
  Core makeCoreInstance(int typeKey);
  T resolve<T>(int id);
  void markDependencyOrderDirty();
  bool markDependenciesDirty(covariant Core rootObject);
  void removeObject<T extends Core>(T object);
  T addObject<T extends Core>(T object);
  void markNeedsAdvance();
  void dirty(void Function() dirt);
}

// ignore: one_member_abstracts
abstract class ImportStackObject {
  void resolve();
}

/// Interface to help objects that need to parent themselves to some other
/// object previously imported.
abstract class ImportHelper<T extends Core<CoreContext>> {
  bool import(T object, ImportStack stack) => true;
}

/// Stack to help the RiveFile locate latest ImportStackObject created of a
/// certain type.
class ImportStack {
  final _latests = HashMap<int, ImportStackObject>();
  T latest<T extends ImportStackObject>(int coreType) {
    var latest = _latests[coreType];
    if (latest is T) {
      return latest;
    }
    return null;
  }

  void makeLatest(int coreType, ImportStackObject importObject) {
    if (importObject != null) {
      _latests[coreType] = importObject;
    } else {
      _latests.remove(coreType);
    }
  }

  void resolve() {
    for (final object in _latests.values) {
      object.resolve();
    }
  }
}
