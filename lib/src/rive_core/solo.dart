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
    _updateCollapse();
  }

  void _updateCollapse() {
    for (final child in children) {
      if (child == _activeComponent) {
        child.propagateCollapse(false);
      } else {
        child.propagateCollapse(true);
      }
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    _updateCollapse();
  }

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    _updateCollapse();
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    if (activeComponentId != Core.missingId) {
      activeComponent = context.resolve(activeComponentId);
    }
  }
}
