import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';

/// Represents the instance of a [LayerState] which is being used in a
/// [LayerController] of a [StateMachineController]. Abstract representation of
/// an Animation (for [AnimationState]) or set of Animations in the case of a
/// [BlendState].
abstract class StateInstance {
  final LayerState state;

  StateInstance(this.state);

  void advance(double seconds, HashMap<int, dynamic> inputValues);
  void apply(CoreContext core, double mix);

  bool get keepGoing;

  void dispose() {}
}

/// A single one of these is created per Layer which just represents/wraps the
/// AnyState but conforms to the instance interface.
class SystemStateInstance extends StateInstance {
  SystemStateInstance(LayerState state) : super(state);
  @override
  void advance(double seconds, HashMap<int, dynamic> inputValues) {}

  @override
  void apply(CoreContext core, double mix) {}

  @override
  bool get keepGoing => false;
}
