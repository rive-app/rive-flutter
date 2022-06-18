import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/listener_action_base.dart';
import 'package:rive/src/rive_core/animation/state_machine_listener.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

export 'package:rive/src/generated/animation/listener_action_base.dart';

abstract class ListenerAction extends ListenerActionBase {
  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  /// Perform the action.
  void perform(StateMachineController controller, Vec2D position);

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
