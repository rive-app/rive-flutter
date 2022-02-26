import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/draw_rules.dart';
import 'package:rive/src/rive_core/drawable.dart';

typedef bool DescentCallback(Component component);

abstract class ContainerComponent extends ContainerComponentBase {
  final ContainerChildren children = ContainerChildren();

  /// Adds the child to the children list and re-wires the parent reference of
  /// the child to the parent. Effectively detach and append.
  void appendChild(Component child) {
    child.parent = this;
  }

  void prependChild(Component child) {
    child.parent = this;
  }

  @mustCallSuper
  void childAdded(Component child) {}

  void childRemoved(Component child) {}

  // Make sure that the current function can be applied to the current
  // [Component], before descending onto all the children.
  bool forAll(DescentCallback cb) {
    if (cb(this) == false) {
      return false;
    }
    forEachChild(cb);
    return true;
  }

  // Recursively descend onto all the children in the hierarchy tree.
  // If the callback returns false, it won't recurse down a particular branch.
  void forEachChild(DescentCallback cb) {
    for (final child in children) {
      if (cb(child) == false) {
        continue;
      }

      // TODO: replace with a more robust check.
      if (child is ContainerComponent) {
        child.forEachChild(cb);
      }
    }
  }

  /// Recursive version of [Component.remove]. This should only be called when
  /// you know this is the only part of the branch you are removing in your
  /// operation. If your operation could remove items from the same branch
  /// multiple times, you should consider building up a list of the individual
  /// items to remove and then remove them individually to avoid calling remove
  /// multiple times on children.
  void removeRecursive() {
    Set<Component> deathRow = {this};
    forEachChild((child) => deathRow.add(child));
    deathRow.forEach(context.removeObject);
  }

  void buildDrawOrder(
      List<Drawable> drawables, DrawRules? rules, List<DrawRules> allRules) {
    for (final child in children) {
      if (child is ContainerComponent) {
        child.buildDrawOrder(drawables, rules, allRules);
      }
    }
  }
}
