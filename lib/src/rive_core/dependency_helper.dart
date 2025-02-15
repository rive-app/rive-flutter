

import 'package:stokanal/collections.dart';

class DependencyHelper<T extends dynamic, U extends dynamic> {

  final UniqueList<U> dependents = UniqueList.hashed(); // set should stay ordered

  // final dependents = <U>{}; // set should stay ordered
  // final dependentsList = <U>[]; // it's a copy of the set used to iterate over

  // Set<U> get dependents => _dependents;

  // final dependents = <U>[]; // set should stay ordered
  T? dependencyRoot;

  DependencyHelper();

  bool addDependent(U value) {

    // if (!dependents.contains(value)) {
    //   dependents.add(value);
    //   return true;
    // }
    // return false;

    // /// STOKANAL-FORK-EDIT: use add directly
    if (dependents.add(value)) {
      // dependentsList.add(value);
      return true;
    }

    return false;
  }

  void addDirt(int dirt, {bool recurse = false}) {

    /// STOKANAL-FORK-EDIT: do not use forEach

    final t = dependents.length;
    for (var i = 0; i < t; i++) {
      dependents[i].addDirt(dirt, recurse: recurse);
    // for (final dependent in _dependents) {
    //   dependent.addDirt(dirt, recurse: recurse);
    }

    // dependents
    //     .forEach((dependent) => dependent.addDirt(dirt, recurse: recurse));
  }

  // void onComponentDirty(U component) {
  //   dependencyRoot?.onComponentDirty(component);
  // }

  void clear() =>
    dependents.clear();
}
