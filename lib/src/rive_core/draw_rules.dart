import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/draw_rules_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/draw_target.dart';

export 'package:rive/src/generated/draw_rules_base.dart';

class DrawRules extends DrawRulesBase {
  final Set<DrawTarget> _targets = {};
  Set<DrawTarget> get targets => _targets;

  DrawTarget? _activeTarget;
  DrawTarget? get activeTarget => _activeTarget;
  set activeTarget(DrawTarget? value) =>
      drawTargetId = value?.id ?? Core.missingId;

  @override
  void drawTargetIdChanged(int from, int to) {
    _activeTarget = context.resolve(to);
    artboard?.markDrawOrderDirty();
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    _activeTarget = context.resolve(drawTargetId);
  }

  @override
  void update(int dirt) {}

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    switch (child.coreType) {
      case DrawTargetBase.typeKey:
        _targets.add(child as DrawTarget);

        break;
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    switch (child.coreType) {
      case DrawTargetBase.typeKey:
        _targets.remove(child as DrawTarget);
        if (_targets.isEmpty) {
          remove();
        }

        break;
    }
  }
}
