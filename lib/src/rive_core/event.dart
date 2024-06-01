import 'package:rive/src/generated/event_base.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/custom_property.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';
import 'package:rive_common/utilities.dart';

export 'package:rive/src/generated/event_base.dart';

class Event extends EventBase {
  final List<CustomProperty> customProperties = [];

  double _secondsDelay = 0.0;
  double get secondsDelay => _secondsDelay;

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

  @override
  void trigger(CallbackData data) {
    if (data.context is StateMachineController) {
      var controller = data.context as StateMachineController;
      _secondsDelay = data.delay;
      controller.reportEvent(this);
    }
  }
}
