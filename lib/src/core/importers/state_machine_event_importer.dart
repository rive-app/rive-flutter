import 'package:rive/src/core/importers/artboard_import_stack_object.dart';
import 'package:rive/src/rive_core/animation/event_input_change.dart';
import 'package:rive/src/rive_core/animation/state_machine_event.dart';

class StateMachineEventImporter extends ArtboardImportStackObject {
  final StateMachineEvent event;
  StateMachineEventImporter(this.event);

  void addInputChange(EventInputChange change) {
    // Other state machine importers do this, do we really need it?
    // event.context.addObject(change);
    event.internalAddInputChange(change);
  }
}
