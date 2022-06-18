import 'package:rive/src/core/importers/artboard_import_stack_object.dart';
import 'package:rive/src/rive_core/animation/listener_action.dart';
import 'package:rive/src/rive_core/animation/state_machine_listener.dart';

class StateMachineListenerImporter extends ArtboardImportStackObject {
  final StateMachineListener listener;
  StateMachineListenerImporter(this.listener);

  void addAction(ListenerAction change) {
    // listener.context.addObject(change);
    listener.internalAddAction(change);
  }
}
