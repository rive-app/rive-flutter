import 'package:rive/src/generated/animation/any_state_base.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';

export 'package:rive/src/generated/animation/any_state_base.dart';

class AnyState extends AnyStateBase {
  @override
  StateInstance makeInstance() => SystemStateInstance(this);
}
