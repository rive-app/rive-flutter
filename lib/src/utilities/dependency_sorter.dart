import 'dart:collection';
import 'package:graphs/graphs.dart';

/// Interface for a node in the dependency graph.
abstract class DependencyGraphNode<T> {
  Set<T> get dependents;
}

/// A simple dependency sorter which will solve well formed dependency
/// structures. It'll detect dependency cycles but it will not help find what
/// caused the cycle or provide any attempt at a best guess for order in cyclic
/// scenarios. Use this as a best case first run and fall back to a more complex
/// solver if this one finds a cycle.
class DependencySorter<T extends DependencyGraphNode<T>> {
  final _perm = HashSet<T>();
  final _temp = HashSet<T>();
  var _order = <T>[];
  List<T> get order => _order.reversed.toList();

  List<T> sort(T root) {
    _order = <T>[];
    if (!visit(root)) {
      return [];
    }
    return _order.reversed.toList();
  }

  void reset() {
    _order = <T>[];
  }

  bool visit(T n) {
    if (_perm.contains(n)) {
      return true;
    }
    if (_temp.contains(n)) {
      // cycle detected!
      return false;
    }

    _temp.add(n);

    final dependents = n.dependents;
    for (final T d in dependents) {
      if (!visit(d)) {
        return false;
      }
    }
    _perm.add(n);

    // Note that we're adding in reverse order intentionally so we don't have to
    // keep inserting at the start and re-alloc-ing the whole list...It does
    // mean we need to reverse the list afterwards.
    _order.add(n);

    return true;
  }
}

/// Sorts dependencies for Actors even when cycles are present
///
/// Any nodes that form part of a cycle can be found in `cycleNodes` after
/// `sort`. NOTE: Nodes isolated by cycles will not be found in `_order` or
/// `cycleNodes` e.g. `A -> B <-> C -> D` isolates D when running a sort based
/// on A
class TarjansDependencySorter<T extends DependencyGraphNode<T>>
    extends DependencySorter<T> {
  final _cycleNodes = HashSet<T>();

  HashSet<T> get cycleNodes => _cycleNodes;

  @override
  List<T> sort(T root) {
    _order = <T>[];

    if (!visit(root)) {
      // if we detect cycles, go find them all
      findCycles(root);

      // revisit the tree, skipping nodes on any cycle.
      visit(root);
    }

    return _order.reversed.toList();
  }

  HashSet<T> findCycles(T n) {
    _perm.clear();
    _temp.clear();
    _cycleNodes.clear();
    _order.clear();

    var cycles = stronglyConnectedComponents<T>([n], (node) => node.dependents);

    cycles.forEach((cycle) {
      // cycles of len 1 are not cycles.
      if (cycle.length > 1) {
        cycle.forEach(_cycleNodes.add);
      }
    });
    return _cycleNodes;
  }

  @override
  bool visit(T n) {
    if (cycleNodes.contains(n)) {
      // skip any nodes on a known cycle.
      return true;
    }

    return super.visit(n);
  }
}
