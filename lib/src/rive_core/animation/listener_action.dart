import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/listener_action_base.dart';
import 'package:rive/src/rive_core/animation/state_machine_listener.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/animation/listener_action_base.dart';

abstract class ListenerAction extends ListenerActionBase {
  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  /// Perform the action.
  void perform(StateMachineController controller, Vec2D position,
      Vec2D previousPosition);

  @override
  bool import(ImportStack importStack) {
    var importer = importStack
        .latest<StateMachineListenerImporter>(StateMachineListenerBase.typeKey);
    if (importer == null) {
      return false;
    }
    importer.addAction(this);

    return super.import(importStack);
  }
}
