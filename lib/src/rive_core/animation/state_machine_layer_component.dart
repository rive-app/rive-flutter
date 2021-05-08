// We really want this file to import core for the flutter runtime, so make the
// linter happy...

// ignore: unused_import
import 'package:rive/src/core/core.dart';

import 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';
export 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';

abstract class StateMachineLayerComponent
    extends StateMachineLayerComponentBase<RuntimeArtboard> {}
