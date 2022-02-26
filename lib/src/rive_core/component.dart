import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/utilities/dependency_sorter.dart';
import 'package:rive/src/utilities/tops.dart';

export 'package:rive/src/generated/component_base.dart';

abstract class Component extends ComponentBase<RuntimeArtboard>
    implements DependencyGraphNode<Component>, Parentable<Component> {
  Artboard? _artboard;
  dynamic _userData;

  /// Override to true if you want some object inheriting from Component to not
  /// have a parent. Most objects will validate that they have a parent during
  /// the onAdded callback otherwise they are considered invalid and are culled
  /// from core.
  bool get canBeOrphaned => false;

  // Used during update process.
  int graphOrder = 0;
  int dirt = 0xFFFF;

  // This is really only for sanity and earlying out of recursive loops.
  static const int maxTreeDepth = 5000;

  bool addDirt(int value, {bool recurse = false}) {
    if ((dirt & value) == value) {
      // Already marked.
      return false;
    }

    // Make sure dirt is set before calling anything that can set more dirt.
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

  /// The artboard this component belongs to.
  Artboard? get artboard => _artboard;

  // Note that this isn't a setter as we don't want anything externally changing
  // the artboard.
  void _changeArtboard(Artboard? value) {
    if (_artboard == value) {
      return;
    }
    _artboard?.removeComponent(this);
    _artboard = value;
    _artboard?.addComponent(this);
  }

  /// Called whenever we're resolving the artboard, we piggy back on that
  /// process to visit ancestors in the tree. This is a good opportunity to
  /// check if we have an ancestor of a specific type. For example, a Path needs
  /// to know which Shape it's within.
  @mustCallSuper
  void visitAncestor(Component ancestor) {}

  /// Find the artboard in the hierarchy.
  bool resolveArtboard() {
    int sanity = maxTreeDepth;
    for (Component? curr = this;
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
    parent = context.resolve(to);
  }

  ContainerComponent? _parent;
  @override
  ContainerComponent? get parent => _parent;

  set parent(ContainerComponent? value) {
    if (_parent == value) {
      return;
    }
    var old = _parent;
    _parent = value;
    parentId = value?.id ?? Core.missingId;
    parentChanged(old, value);
  }

  @protected
  void parentChanged(ContainerComponent? from, ContainerComponent? to) {
    from?.children.remove(this);
    from?.childRemoved(this);

    to?.children.add(this);
    to?.childAdded(this);

    // We need to resolve our artboard.
    markRebuildDependencies();
  }

  /// Components that depend on this component.
  final Set<Component> _dependents = {};

  /// Components that this component depends on.
  final Set<Component> _dependsOn = {};

  @override
  Set<Component> get dependents => _dependents;

  /// Mark [dependent] as a component which must update after this. Provide
  /// [via] as the Component registering the dependency when it is not
  /// [dependent] itself. At edit time this allows the editor to rebuild both
  /// [dependent] and [via] when [dependent] has its dependencies cleared.
  bool addDependent(Component dependent, {Component? via}) {
    assert(artboard == dependent.artboard,
        'Components must be in the same artboard.');

    if (!_dependents.add(dependent)) {
      return false;
    }
    dependent._dependsOn.add(this);

    return true;
  }

  bool isValidParent(Component parent) => parent is ContainerComponent;

  void markRebuildDependencies() {
    if (!context.markDependenciesDirty(this)) {
      // no context, or already dirty.
      return;
    }
    for (final dependent in _dependents) {
      dependent.markRebuildDependencies();
    }
  }

  void clearDependencies() {
    for (final parentDep in _dependsOn) {
      parentDep._dependents.remove(this);
    }
    _dependsOn.clear();
  }

  void buildDependencies() {}

  /// Something we depend on has been removed. It's important to clear out any
  /// stored references to that dependency so it can be garbage collected (if
  /// necessary).
  void onDependencyRemoved(Component dependent) {}

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {
    if (parentId != Core.missingId) {
      parent = context.resolve(parentId);
    }
  }

  /// When a component has been removed from the Core Context, we clean up any
  /// dangling references left on the parent and on any other dependent
  /// component. It's important for specialization of Component to respond to
  /// override [onDependencyRemoved] and clean up any further stored references
  /// to that component (for example the target of a Constraint).
  @override
  @mustCallSuper
  void onRemoved() {
    super.onRemoved();
    for (final parentDep in _dependsOn) {
      parentDep._dependents.remove(this);
    }
    _dependsOn.clear();

    for (final dependent in _dependents) {
      dependent.onDependencyRemoved(this);
    }
    _dependents.clear();

    // silently clear from the parent in order to not cause any further undo
    // stack changes
    if (parent != null) {
      parent!.children.remove(this);
      parent!.childRemoved(this);
    }

    // The artboard containing this component will need its dependencies
    // re-sorted.

    if (artboard != null) {
      context.markDependencyOrderDirty();
      _changeArtboard(null);
    }
  }

  @override
  String toString() {
    return '${super.toString()} ($id) -> $name';
  }

  @override
  void nameChanged(String from, String to) {
    /// Changing name doesn't really do anything.
  }

  @override
  bool import(ImportStack stack) {
    var artboardImporter = stack.latest<ArtboardImporter>(ArtboardBase.typeKey);
    if (artboardImporter == null) {
      return false;
    }
    artboardImporter.addComponent(this);

    return super.import(stack);
  }
}
