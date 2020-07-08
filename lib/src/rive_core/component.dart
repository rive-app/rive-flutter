import 'package:rive/src/core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/utilities/dependency_sorter.dart';
import 'package:rive/src/utilities/tops.dart';
export 'package:rive/src/generated/component_base.dart';

abstract class Component extends ComponentBase<RuntimeArtboard>
    implements DependencyGraphNode<Component>, Parentable<Component> {
  Artboard _artboard;
  dynamic _userData;
  bool get canBeOrphaned => false;
  int graphOrder = 0;
  int dirt = 255;
  static const int maxTreeDepth = 5000;
  bool addDirt(int value, {bool recurse = false}) {
    if ((dirt & value) == value) {
      return false;
    }
    dirt |= value;
    onDirty(dirt);
    artboard?.onComponentDirty(this);
    if (!recurse) {
      return true;
    }
    for (final d in dependents) {
      d.addDirt(value, recurse: recurse);
    }
    return true;
  }

  void onDirty(int mask) {}
  void update(int dirt);
  Artboard get artboard => _artboard;
  void _changeArtboard(Artboard value) {
    if (_artboard == value) {
      return;
    }
    _artboard?.removeComponent(this);
    _artboard = value;
    _artboard?.addComponent(this);
  }

  void visitAncestor(Component ancestor) {}
  bool resolveArtboard() {
    int sanity = maxTreeDepth;
    for (Component curr = this;
        curr != null && sanity > 0;
        curr = curr.parent, sanity--) {
      visitAncestor(curr);
      if (curr is Artboard) {
        _changeArtboard(curr);
        return true;
      }
    }
    _changeArtboard(null);
    return false;
  }

  dynamic get userData => _userData;
  set userData(dynamic value) {
    if (value == _userData) {
      return;
    }
    dynamic last = _userData;
    _userData = value;
    userDataChanged(last, value);
  }

  void userDataChanged(dynamic from, dynamic to) {}
  @override
  void parentIdChanged(int from, int to) {
    parent = context?.resolve(to);
  }

  ContainerComponent _parent;
  @override
  ContainerComponent get parent => _parent;
  set parent(ContainerComponent value) {
    if (_parent == value) {
      return;
    }
    var old = _parent;
    _parent = value;
    parentId = value?.id;
    parentChanged(old, value);
  }

  @protected
  void parentChanged(ContainerComponent from, ContainerComponent to) {
    if (from != null) {
      from.children.remove(this);
      from.childRemoved(this);
    }
    if (to != null) {
      to.children.add(this);
      to.childAdded(this);
    }
    markRebuildDependencies();
  }

  final Set<Component> _dependents = {};
  final Set<Component> _dependsOn = {};
  @override
  Set<Component> get dependents => _dependents;
  bool addDependent(Component dependent) {
    assert(dependent != null, "Dependent cannot be null.");
    assert(artboard == dependent.artboard,
        "Components must be in the same artboard.");
    if (!_dependents.add(dependent)) {
      return false;
    }
    dependent._dependsOn.add(this);
    return true;
  }

  bool isValidParent(Component parent) => parent is ContainerComponent;
  void markRebuildDependencies() {
    if (context == null || !context.markDependenciesDirty(this)) {
      return;
    }
    for (final dependent in _dependents) {
      dependent.markRebuildDependencies();
    }
  }

  @mustCallSuper
  void buildDependencies() {
    for (final parentDep in _dependsOn) {
      parentDep._dependents.remove(this);
    }
    _dependsOn.clear();
  }

  void onDependencyRemoved(Component dependent) {}
  @override
  @mustCallSuper
  void onAdded() {
    if (!canBeOrphaned && parent == null) {
      remove();
    }
  }

  @override
  void onAddedDirty() {
    if (parentId != null) {
      parent = context?.resolve(parentId);
    }
  }

  @override
  @mustCallSuper
  void onRemoved() {
    for (final parentDep in _dependsOn) {
      parentDep._dependents.remove(this);
    }
    _dependsOn.clear();
    for (final dependent in _dependents) {
      dependent.onDependencyRemoved(this);
    }
    _dependents.clear();
    if (parent != null) {
      parent.children.remove(this);
      parent.childRemoved(this);
    }
    if (artboard != null) {
      context?.markDependencyOrderDirty();
      _changeArtboard(null);
    }
  }

  @override
  String toString() {
    return '${super.toString()} ($id)';
  }

  void remove() => context?.removeObject(this);
  @override
  void nameChanged(String from, String to) {}
}
