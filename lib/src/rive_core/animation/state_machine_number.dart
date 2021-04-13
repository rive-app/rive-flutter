import 'package:rive/src/generated/animation/state_machine_number_base.dart';
export 'package:rive/src/generated/animation/state_machine_number_base.dart';

class StateMachineNumber extends StateMachineNumberBase {
  @override
  void valueChanged(double from, double to) {}
  @override
  bool isValidType<T>() => T == double;
  @override
  dynamic get controllerValue => value;
}
