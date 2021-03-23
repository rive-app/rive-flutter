abstract class Parentable<T> {
  T? get parent;
}

/// Get the top most components (any child that has an ancestor in the set
/// should be pruned).
Set<T> tops<T extends Parentable<T>>(Iterable<T> parentables) {
  var tips = <T>{};
  outerLoop:
  for (final item in parentables) {
    for (T? parent = item.parent; parent != null; parent = parent.parent) {
      if (parentables.contains(parent)) {
        continue outerLoop;
      }
    }
    tips.add(item);
  }
  return tips;
}

bool isChildOf<T extends Parentable<T>>(T child, Iterable<T> parents) {
  for (T? parent = child; parent != null; parent = parent.parent) {
    if (parents.contains(parent)) {
      return true;
    }
  }
  return false;
}
