library rive_core;

import 'package:rive/src/generated/animation/listener_fire_event_base.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/animation/listener_fire_event_base.dart';

class ListenerFireEvent extends ListenerFireEventBase {
  @override
  void eventIdChanged(int from, int to) {}

  @override
  void perform(StateMachineController controller, Vec2D position) {
    Event? event = controller.artboard?.context.resolve(eventId);
    if (event != null) {
      controller.reportEvent(event);
    }
  }
}
