

class DependencyHelper<T extends dynamic, U extends dynamic> {

  final _dependents = <U>{}; // set should stay ordered
  final _dependentsList = <U>[]; // it's a copy of the set used to iterate over

  Set<U> get dependents => _dependents;

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
    if (_dependents.add(value)) {
      _dependentsList.add(value);
      return true;
    }

    return false;
  }

  void addDirt(int dirt, {bool recurse = false}) {

    /// STOKANAL-FORK-EDIT: do not use forEach

    var t = _dependentsList.length;
    for (var i = 0; i < t; i++) {
      _dependentsList[i].addDirt(dirt, recurse: recurse);
    // for (final dependent in _dependents) {
    //   dependent.addDirt(dirt, recurse: recurse);
    }

    // dependents
    //     .forEach((dependent) => dependent.addDirt(dirt, recurse: recurse));
  }

  // void onComponentDirty(U component) {
  //   dependencyRoot?.onComponentDirty(component);
  // }

  void clear() {
    _dependents.clear();
  }
}
