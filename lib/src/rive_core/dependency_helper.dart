

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

    // using set or unique list
    return dependents.add(value);
  }

  void addDirt(int dirt, {bool recurse = false}) {

    /// STOKANAL-FORK-EDIT: do not use forEach

    // UniqueList
    var list = dependents.list;
    final t = list.length;
    for (var i = 0; i < t; i++) {
      list[i].addDirt(dirt, recurse: recurse);
    }

    // // Set
    // for (final dependent in dependents) {
    //   dependent.addDirt(dirt, recurse: recurse);
    // }
  }

  void clear() =>
    dependents.clear();
}
