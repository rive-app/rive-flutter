import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/listener_fire_event_base.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/animation/listener_fire_event_base.dart';

class ListenerFireEvent extends ListenerFireEventBase {
  Event? _event;
  Event? get event => _event;
  set event(Event? value) {
    if (_event == value) {
      return;
    }

    _event = value;

    eventId = _event?.id ?? Core.missingId;
  }

  @override
  void eventIdChanged(int from, int to) {
    event = context.resolveWithDefault(to, Event.unknown);
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    event = context.resolveWithDefault(eventId, Event.unknown);
  }

  @override
  void perform(StateMachineController controller, Vec2D position) {
    // TODO: listener.stateMachine.fireEvent()
  }
}
