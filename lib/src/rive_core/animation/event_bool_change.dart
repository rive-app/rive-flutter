import 'package:rive/src/generated/animation/event_bool_change_base.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

export 'package:rive/src/generated/animation/event_bool_change_base.dart';

class EventBoolChange extends EventBoolChangeBase {
  @override
  void valueChanged(bool from, bool to) {}

  @override
  void perform(StateMachineController controller) =>
      controller.setInputValue(inputId, value);
}
