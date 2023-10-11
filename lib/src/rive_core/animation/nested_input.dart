import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/nested_input_base.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';

export 'package:rive/src/generated/animation/nested_input_base.dart';

abstract class NestedInput extends NestedInputBase {
  @override
  void inputIdChanged(int from, int to) {}

  NestedArtboard? get nestedArtboard =>
      nestedStateMachine?.parent is NestedArtboard
          ? nestedStateMachine?.parent as NestedArtboard
          : null;

  NestedStateMachine? get nestedStateMachine =>
      parent is NestedStateMachine ? parent as NestedStateMachine : null;

  @override
  bool validate() => super.validate() && nestedStateMachine != null;

  void updateValue();

  @override
  void update(int dirt) {}

  @override
  bool import(ImportStack importStack) {
    var importer = importStack
        .latest<NestedStateMachineImporter>(NestedStateMachineBase.typeKey);
    if (importer == null) {
      return false;
    }
    importer.addNestedInput(this);

    return super.import(importStack);
  }
}
