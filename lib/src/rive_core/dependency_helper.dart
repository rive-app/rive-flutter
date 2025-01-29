

class DependencyHelper<T extends dynamic, U extends dynamic> {

  final dependents = <U>{}; // set should stay ordered
  T? dependencyRoot;

  DependencyHelper();

  bool addDependent(U value) {

    // if (!dependents.contains(value)) {
    //   dependents.add(value);

    /// STOKANAL-FORK-EDIT: use add directly
    if (dependents.add(value)) {
      return true;
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
