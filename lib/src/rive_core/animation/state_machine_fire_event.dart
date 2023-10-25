library rive_core;

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/state_machine_fire_event_base.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer_component.dart';
import 'package:rive/src/rive_core/enum_helper.dart';

export 'package:rive/src/generated/animation/state_machine_fire_event_base.dart';

enum StateMachineFireOccurance {
  atStart,
  atEnd,
}

class StateMachineFireEvent extends StateMachineFireEventBase {
  @override
  void onAddedDirty() {}

  @override
  void eventIdChanged(int from, int to) {}

  @override
  void occursValueChanged(int from, int to) {}

  StateMachineFireOccurance get occurs =>
      enumAt(StateMachineFireOccurance.values, occursValue);

  @override
  bool import(ImportStack importStack) {
    var importer = importStack.latest<StateMachineLayerComponentImporter>(
        StateMachineLayerComponentBase.typeKey);
    if (importer == null) {
      return false;
    }
    importer.addFireEvent(this);

    return super.import(importStack);
  }
}
