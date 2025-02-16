

import 'package:stokanal/collections.dart';

class DependencyHelper<T extends dynamic, U extends dynamic> {

  final dependents = UniqueList.of<U>(); // set should stay ordered
  T? dependencyRoot;

  DependencyHelper();

  bool addDependent(U value) {

    // if (!dependents.contains(value)) {
    //   dependents.add(value);
    //   return true;
    // }
    // return false;

    // /// STOKANAL-FORK-EDIT: use add directly
    return dependents.add(value);
  }

  void addDirt(int dirt, {bool recurse = false}) {

    /// STOKANAL-FORK-EDIT: do not use forEach

    // UniqueList
    final t = dependents.length;
    for (var i = 0; i < t; i++) {
      dependents[i].addDirt(dirt, recurse: recurse);
    }

    // // Set
    // for (final dependent in dependents) {
    //   dependent.addDirt(dirt, recurse: recurse);
    // }
  }

  // void onComponentDirty(U component) {
  //   dependencyRoot?.onComponentDirty(component);
  // }

  void clear() =>
    dependents.clear();
}
