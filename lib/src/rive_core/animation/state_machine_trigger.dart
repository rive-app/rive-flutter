import 'package:rive/src/generated/animation/state_machine_trigger_base.dart';
export 'package:rive/src/generated/animation/state_machine_trigger_base.dart';

class StateMachineTrigger extends StateMachineTriggerBase {
  void fire() {}

  @override
  void publicChanged(bool from, bool to) {}

  @override
  bool isValidType<T>() => T == bool;
}
