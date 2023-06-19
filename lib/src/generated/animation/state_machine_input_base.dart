import 'package:rive/src/rive_core/animation/state_machine_component.dart';

abstract class StateMachineInputBase extends StateMachineComponent {
  static const int typeKey = 55;
  @override
  int get coreType => StateMachineInputBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {StateMachineInputBase.typeKey, StateMachineComponentBase.typeKey};
}
