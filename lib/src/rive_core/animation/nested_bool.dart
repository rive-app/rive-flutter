import 'package:rive/src/generated/animation/nested_bool_base.dart';
export 'package:rive/src/generated/animation/nested_bool_base.dart';

class NestedBool extends NestedBoolBase {
  @override
  void nestedValueChanged(bool from, bool to) => updateValue();

  @override
  void updateValue() => nestedStateMachine?.setInputValue(inputId, nestedValue);
}
