// Core automatically generated lib/src/generated/event_base.dart.
// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class EventBase extends ContainerComponent {
  static const int typeKey = 128;
  @override
  int get coreType => EventBase.typeKey;
  @override
  Set<int> get coreTypes => {
        EventBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Trigger field with key 395.
  static const int triggerPropertyKey = 395;
  void trigger(CallbackData value);
}
