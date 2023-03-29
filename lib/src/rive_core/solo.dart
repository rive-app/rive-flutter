import 'package:rive/src/generated/solo_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/container_component.dart';

export 'package:rive/src/generated/solo_base.dart';

class Solo extends SoloBase {
  Component? _activeComponent;
  @override
  void activeComponentIdChanged(int from, int to) =>
      activeComponent = context.resolve(to);

  Component? get activeComponent => _activeComponent;

  set activeComponent(Component? value) {
    if (_activeComponent == value) {
      return;
    }
    _activeComponent = value;
    activeComponentId = value?.id ?? Core.missingId;
    propagateCollapseToChildren(isCollapsed);
  }

  @override
  void propagateCollapseToChildren(bool collapse) {
    for (final child in children) {
      child.propagateCollapse(collapse || child != _activeComponent);
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    propagateCollapseToChildren(isCollapsed);
  }

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    propagateCollapseToChildren(isCollapsed);
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    if (activeComponentId != Core.missingId) {
      activeComponent = context.resolve(activeComponentId);
    }
  }

  @override
  void onAdded() {
    super.onAdded();
    propagateCollapseToChildren(isCollapsed);
  }
}
