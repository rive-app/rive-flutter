import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/blend_animation_direct_base.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_number.dart';

export 'package:rive/src/generated/animation/blend_animation_direct_base.dart';

class BlendAnimationDirect extends BlendAnimationDirectBase {
  StateMachineNumber? _input;
  StateMachineNumber? get input => _input;

  @override
  void inputIdChanged(int from, int to) {}

  @override
  bool import(ImportStack stack) {
    var importer = stack.latest<StateMachineImporter>(StateMachineBase.typeKey);
    if (importer == null) {
      return false;
    }
    if (inputId >= 0 && inputId < importer.machine.inputs.length) {
      var found = importer.machine.inputs[inputId];
      if (found is StateMachineNumber) {
        _input = found;
        inputId = found.id;
      }
    }

    return super.import(stack);
  }
}
