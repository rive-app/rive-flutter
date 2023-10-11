import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/nested_trigger_base.dart';
import 'package:rive/src/rive_core/notifier.dart';

export 'package:rive/src/generated/animation/nested_trigger_base.dart';

class NestedTrigger extends NestedTriggerBase {
  final Notifier firedTrigger = Notifier();

  @override
  void fire(CallbackData data) {
    // Need to pass the CallbackData?
    firedTrigger.notify();

    updateValue();
  }

  @override
  void updateValue() => nestedStateMachine?.setInputValue(inputId, true);
}
