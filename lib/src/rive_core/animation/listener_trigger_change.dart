import 'package:rive/src/generated/animation/listener_trigger_change_base.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

export 'package:rive/src/generated/animation/listener_trigger_change_base.dart';

class ListenerTriggerChange extends ListenerTriggerChangeBase {
  @override
  void perform(StateMachineController controller, Vec2D position) =>
      controller.setInputValue(inputId, true);
}
