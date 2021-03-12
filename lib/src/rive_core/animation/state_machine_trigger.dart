import 'package:rive/src/generated/animation/state_machine_trigger_base.dart';
export 'package:rive/src/generated/animation/state_machine_trigger_base.dart';

class StateMachineTrigger extends StateMachineTriggerBase {
  bool _triggered = false;
  bool get triggered => _triggered;
  void fire() {
    _triggered = true;
  }

  void reset() {
    _triggered = false;
  }

  @override
  bool isValidType<T>() => T == bool;
  @override
  dynamic get controllerValue => _triggered;
}
