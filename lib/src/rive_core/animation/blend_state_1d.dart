import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/blend_state_1d_base.dart';
import 'package:rive/src/rive_core/animation/blend_state_1d_instance.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_number.dart';

export 'package:rive/src/generated/animation/blend_state_1d_base.dart';

class BlendState1D extends BlendState1DBase {
  StateMachineNumber? _input;
  StateMachineNumber? get input => _input;

  void _changeInput(StateMachineNumber? value) {
    if (value == _input) {
      return;
    }

    _input = value;
  }

  @override
  void inputIdChanged(int from, int to) {
    _changeInput(context.resolve<StateMachineNumber>(to));
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    _changeInput(context.resolve<StateMachineNumber>(inputId));
  }

  @override
  StateInstance makeInstance() => BlendState1DInstance(this);

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
