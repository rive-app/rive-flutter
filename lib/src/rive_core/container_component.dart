import 'package:flutter/material.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/draw_rules.dart';
import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/generated/container_component_base.dart';

typedef bool DescentCallback(Component component);

abstract class ContainerComponent extends ContainerComponentBase {
  final ContainerChildren children = ContainerChildren();
  void appendChild(Component child) {
    child.parent = this;
  }

  void prependChild(Component child) {
    child.parent = this;
  }

  @mustCallSuper
  void childAdded(Component child) {}
  void childRemoved(Component child) {}
  bool forAll(DescentCallback cb) {
    if (cb(this) == false) {
      return false;
    }
    forEachChild(cb);
    return true;
  }

  void forEachChild(DescentCallback cb) {
    for (final child in children) {
      if (cb(child) == false) {
        continue;
      }
      if (child is ContainerComponent) {
        child.forEachChild(cb);
      }
    }
  }

  void removeRecursive() {
    assert(context != null);
    Set<Component> deathRow = {this};
    forEachChild((child) => deathRow.add(child));
    deathRow.forEach(context.removeObject);
  }

  void buildDrawOrder(
      List<Drawable> drawables, DrawRules rules, List<DrawRules> allRules) {
    for (final child in children) {
      if (child is ContainerComponent) {
        child.buildDrawOrder(drawables, rules, allRules);
      }
    }
  }
}
