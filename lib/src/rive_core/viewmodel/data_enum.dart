import 'package:rive/src/generated/viewmodel/data_enum_base.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/viewmodel/data_enum_value.dart';

export 'package:rive/src/generated/viewmodel/data_enum_base.dart';

class DataEnum extends DataEnumBase {
  DataEnumValues children = DataEnumValues();
  void addValue(DataEnumValue item) {
    if (!children.contains(item)) {
      children.add(item);
    }
  }

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  @override
  void onRemoved() {
    children.toList().forEach((child) => child.remove());
    super.onRemoved();
  }

  void removeValue(DataEnumValue item) {
    children.remove(item);
  }

  void internalAddValue(DataEnumValue item) {
    addValue(item);
  }
}
