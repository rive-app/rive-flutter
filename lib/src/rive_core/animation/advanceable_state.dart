import 'package:rive/src/generated/animation/advanceable_state_base.dart';
export 'package:rive/src/generated/animation/advanceable_state_base.dart';

abstract class AdvanceableState extends AdvanceableStateBase {
  @override
  void speedChanged(double from, double to) {}
}
