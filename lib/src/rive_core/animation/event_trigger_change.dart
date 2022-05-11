import 'package:rive/src/generated/animation/event_trigger_change_base.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

export 'package:rive/src/generated/animation/event_trigger_change_base.dart';

class EventTriggerChange extends EventTriggerChangeBase {
  @override
  void perform(StateMachineController controller) =>
      controller.setInputValue(inputId, true);
}
