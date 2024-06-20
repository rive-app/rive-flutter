import 'package:collection/collection.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_instance_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

export 'package:rive/src/generated/viewmodel/viewmodel_instance_base.dart';

class ViewModelInstance extends ViewModelInstanceBase {
  List<ViewModelInstanceValue> propertyValues = [];
  ViewModel? viewModel;

  @override
  void update(int dirt) {}

  @override
  bool get canBeOrphaned => true;

  @override
  void onAdded() {
    viewModel?.addInstance(this);
  }

  @override
  void viewModelIdChanged(int from, int to) {}

  @override
  void nameChanged(String from, String to) {}

  void addPropertyValue(ViewModelInstanceValue value) {
    propertyValues.add(value);
  }

  bool removePropertyValue(ViewModelInstanceValue value) {
    final result = propertyValues.remove(value);

    return result;
  }

  void removeValueByPropertyId(int id) {
    final propertyValue = propertyValues.firstWhereOrNull((element) {
      return element.viewModelPropertyId == id;
    });
    if (propertyValue != null) {
      propertyValue.remove();
    }
  }

  bool internalRemovePropertyValue(ViewModelInstanceValue value) {
    return removePropertyValue(value);
  }

  ViewModelInstanceValue?
      propertyValueByPropertyId<T extends ViewModelInstanceValue?>(
          int propertyId) {
    final propertyValue = propertyValues.firstWhereOrNull(
        (property) => property.viewModelPropertyId == propertyId);
    assert(propertyValue is T?);
    return propertyValue;
  }
}
