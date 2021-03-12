import 'package:rive/src/generated/animation/state_machine_double_base.dart';
export 'package:rive/src/generated/animation/state_machine_double_base.dart';

class StateMachineDouble extends StateMachineDoubleBase {
  @override
  void valueChanged(double from, double to) {}
  @override
  bool isValidType<T>() => T == double;
  @override
  dynamic get controllerValue => value;
}
