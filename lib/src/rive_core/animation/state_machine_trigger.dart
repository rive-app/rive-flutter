import 'package:rive/src/generated/animation/state_machine_trigger_base.dart';
export 'package:rive/src/generated/animation/state_machine_trigger_base.dart';

class StateMachineTrigger extends StateMachineTriggerBase {
  void fire() {}

  @override
  bool isValidType<T>() => T == bool;
}
