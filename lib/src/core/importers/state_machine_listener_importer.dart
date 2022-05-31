import 'package:rive/src/core/importers/artboard_import_stack_object.dart';
import 'package:rive/src/rive_core/animation/listener_input_change.dart';
import 'package:rive/src/rive_core/animation/state_machine_listener.dart';

class StateMachineListenerImporter extends ArtboardImportStackObject {
  final StateMachineListener event;
  StateMachineListenerImporter(this.event);

  void addInputChange(ListenerInputChange change) {
    // Other state machine importers do this, do we really need it?
    // event.context.addObject(change);
    event.internalAddInputChange(change);
  }
}
