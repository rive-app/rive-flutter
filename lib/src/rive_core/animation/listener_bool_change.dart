import 'package:rive/src/generated/animation/listener_bool_change_base.dart';
import 'package:rive/src/rive_core/animation/nested_bool.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/animation/listener_bool_change_base.dart';

class ListenerBoolChange extends ListenerBoolChangeBase {
  @override
  void valueChanged(int from, int to) {}

  @override
  void perform(StateMachineController controller, Vec2D position,
      Vec2D previousPosition) {
    var nestedInput = nestedInputForController(controller);
    bool? newValue;
    switch (value) {
      case 0:
        newValue = false;
        break;
      case 1:
        newValue = true;
        break;
      default:
        // Toggle
        dynamic existing = nestedInput != null && nestedInput is NestedBool
            ? nestedInput.nestedValue
            : controller.getInputValue(inputId);
        if (existing is bool) {
          newValue = !existing;
        } else {
          newValue = true;
        }
        break;
    }
    if (nestedInput != null && nestedInput is NestedBool) {
      nestedInput.nestedValue = newValue;
    } else {
      controller.setInputValue(inputId, newValue);
    }
  }
}
