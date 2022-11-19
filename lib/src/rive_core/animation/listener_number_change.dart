import 'package:rive/src/generated/animation/listener_number_change_base.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/animation/listener_number_change_base.dart';

class ListenerNumberChange extends ListenerNumberChangeBase {
  @override
  void valueChanged(double from, double to) {}

  @override
  void perform(StateMachineController controller, Vec2D position) =>
      controller.setInputValue(inputId, value);
}
