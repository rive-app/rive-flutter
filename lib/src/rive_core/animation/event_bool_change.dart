import 'package:rive/src/generated/animation/event_bool_change_base.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

export 'package:rive/src/generated/animation/event_bool_change_base.dart';

class EventBoolChange extends EventBoolChangeBase {
  @override
  void valueChanged(int from, int to) {}

  @override
  void perform(StateMachineController controller) {
    switch (value) {
      case 0:
        controller.setInputValue(inputId, false);
        break;
      case 1:
        controller.setInputValue(inputId, true);
        break;
      default:
        // Toggle
        dynamic existing = controller.getInputValue(inputId);
        if (existing is bool) {
          controller.setInputValue(inputId, !existing);
        } else {
          controller.setInputValue(inputId, true);
        }

        break;
    }
  }
}
