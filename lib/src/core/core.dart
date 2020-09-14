export 'package:rive/src/fractional/fractional.dart';
export 'package:rive/src/animation_list.dart';
export 'package:rive/src/container_children.dart';
export 'package:rive/src/runtime_artboard.dart';
export 'package:rive/src/generated/rive_core_context.dart';


typedef PropertyChangeCallback = void Function(dynamic from, dynamic to);
typedef BatchAddCallback = void Function();


abstract class Core<T extends CoreContext> {
  covariant T context;
  int get coreType;
  int id;
  Set<int> get coreTypes => {};

  void onAddedDirty();
  void onAdded();
  void onRemoved();
}

abstract class CoreContext{
  Core makeCoreInstance(int typeKey);
  T resolve<T>(int id);
  void markDependencyOrderDirty();
  bool markDependenciesDirty(covariant Core rootObject);
  void removeObject<T extends Core>(T object);
  T addObject<T extends Core>(T object);
  void markNeedsAdvance();
  void dirty(void Function() dirt);
}
