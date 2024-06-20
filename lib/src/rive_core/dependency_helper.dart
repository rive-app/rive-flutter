class DependencyHelper<T extends dynamic, U extends dynamic> {
  Set<U> dependents = {};
  T? dependencyRoot;

  DependencyHelper();

  bool addDependent(U value) {
    if (!dependents.contains(value)) {
      dependents.add(value);
      return true;
    }
    return false;
  }

  void addDirt(int dirt, {bool recurse = false}) {
    dependents
        .forEach((dependent) => dependent.addDirt(dirt, recurse: recurse));
  }

  void onComponentDirty(U component) {
    dependencyRoot?.onComponentDirty(component);
  }

  void clear() {
    dependents.clear();
  }
}
