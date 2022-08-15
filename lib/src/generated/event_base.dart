/// Core automatically generated lib/src/generated/event_base.dart.
/// Do not modify manually.

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
  /// Type field with key 244.
  static const String typeInitialValue = '';
  String _type = typeInitialValue;
  static const int typePropertyKey = 244;

  /// Intent of the event.
  String get type => _type;

  /// Change the [_type] field value.
  /// [typeChanged] will be invoked only if the field's value has changed.
  set type(String value) {
    if (_type == value) {
      return;
    }
    String from = _type;
    _type = value;
    if (hasValidated) {
      typeChanged(from, value);
    }
  }

  void typeChanged(String from, String to);

  @override
  void copy(covariant EventBase source) {
    super.copy(source);
    _type = source._type;
  }
}
