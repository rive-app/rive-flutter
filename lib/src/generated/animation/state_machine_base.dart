import 'package:rive/src/rive_core/animation/animation.dart';

abstract class StateMachineBase extends Animation {
  static const int typeKey = 53;
  @override
  int get coreType => StateMachineBase.typeKey;
  @override
  Set<int> get coreTypes => {StateMachineBase.typeKey, AnimationBase.typeKey};
}
