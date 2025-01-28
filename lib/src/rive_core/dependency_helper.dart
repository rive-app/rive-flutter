class DependencyHelper<T extends dynamic, U extends dynamic> {

  /// STOKANAL-FORK-EDIT: make if final
  // final dependents = <U>{};
  final dependents = <U>[];
  T? dependencyRoot;

  DependencyHelper();

  bool addDependent(U value) {

    // if (!dependents.contains(value)) {
    //   dependents.add(value);

    // if (dependents.add(value)) {
    //   return true;
    // }

    /// STOKANAL-FORK-EDIT: use add directly
    if (!dependents.contains(value)) {
      dependents.add(value);
    }
    return false;
  }

  void addDirt(int dirt, {bool recurse = false}) {

    /// STOKANAL-FORK-EDIT: do not use forEach
    for (final dependent in dependents) {
      dependent.addDirt(dirt, recurse: recurse);
    }

    // dependents
    //     .forEach((dependent) => dependent.addDirt(dirt, recurse: recurse));
  }

  void onComponentDirty(U component) {
    dependencyRoot?.onComponentDirty(component);
  }

  void clear() {
    dependents.clear();
  }
}
