import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_base.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property.dart';

export 'package:rive/src/generated/viewmodel/viewmodel_base.dart';

class ViewModel extends ViewModelBase {
  ViewModelProperties children = ViewModelProperties();
  List<ViewModelInstance> instances = [];

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {
    // TODO: @hernan implement
  }

  @override
  void defaultInstanceIdChanged(int from, int to) {}

  void addProperty(ViewModelProperty item) {
    if (!children.contains(item)) {
      children.add(item);
    }
  }

  T? property<T extends ViewModelProperty>(int id) {
    for (final property in children) {
      if (property.id == id && property is T) {
        return property;
      }
    }
    return null;
  }

  void removeProperty(ViewModelProperty item) {}

  void internalAddProperty(ViewModelProperty item) {
    addProperty(item);
  }

  void addInstance(ViewModelInstance value) {
    instances.add(value);
  }

  bool removeInstance(ViewModelInstance value) {
    if (value.id == defaultInstanceId) {
      return false;
    }
    return instances.remove(value);
  }

  ViewModelInstance instance(int id) {
    return instances.firstWhere((element) => element.id == id);
  }

  ViewModelInstance get defaultInstance => instance(defaultInstanceId);

  bool internalRemoveInstance(ViewModelInstance value) {
    return removeInstance(value);
  }
}
