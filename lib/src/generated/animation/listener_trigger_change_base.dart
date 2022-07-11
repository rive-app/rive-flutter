/// Core automatically generated
/// lib/src/generated/animation/listener_trigger_change_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/animation/listener_action_base.dart';
import 'package:rive/src/rive_core/animation/listener_input_change.dart';

abstract class ListenerTriggerChangeBase extends ListenerInputChange {
  static const int typeKey = 115;
  @override
  int get coreType => ListenerTriggerChangeBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ListenerTriggerChangeBase.typeKey,
        ListenerInputChangeBase.typeKey,
        ListenerActionBase.typeKey
      };
}
