import 'package:rive/src/generated/animation/exit_state_base.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';

export 'package:rive/src/generated/animation/exit_state_base.dart';

class ExitState extends ExitStateBase {
  @override
  StateInstance makeInstance() => SystemStateInstance(this);
}
