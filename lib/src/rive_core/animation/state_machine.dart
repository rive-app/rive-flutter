import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/state_machine_input.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/generated/animation/state_machine_base.dart';
export 'package:rive/src/generated/animation/state_machine_base.dart';

class StateMachine extends StateMachineBase {
  final StateMachineComponents<StateMachineInput> inputs =
      StateMachineComponents<StateMachineInput>();
  final StateMachineComponents<StateMachineLayer> layers =
      StateMachineComponents<StateMachineLayer>();
}
