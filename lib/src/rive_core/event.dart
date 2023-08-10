import 'package:rive/src/generated/event_base.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/custom_property.dart';
import 'package:rive_common/utilities.dart';

export 'package:rive/src/generated/event_base.dart';

class Event extends EventBase {
  final List<CustomProperty> customProperties = [];

  @override
  void typeChanged(String from, String to) {}

  @override
  void update(int dirt) {}

  @override
  void changeArtboard(Artboard? value) {
    artboard?.internalRemoveEvent(this);
    super.changeArtboard(value);
    artboard?.internalAddEvent(this);
  }

  void _syncCustomProperties() {
    var nextCustomProperties = children.whereType<CustomProperty>().toSet();
    if (!iterableEquals(customProperties, nextCustomProperties)) {
      customProperties.clear();
      customProperties.addAll(nextCustomProperties);
    }
  }

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    _syncCustomProperties();
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    _syncCustomProperties();
  }

  static final _UnknownEvent unknown = _UnknownEvent();
}

class _UnknownEvent extends Event {}
