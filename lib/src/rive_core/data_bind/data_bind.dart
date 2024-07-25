import 'package:rive/src/generated/data_bind/data_bind_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value_boolean.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value_color.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value_number.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value_string.dart';
import 'package:rive/src/rive_core/data_bind/data_context.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_boolean.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_color.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_enum.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_list.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_number.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_string.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

export 'package:rive/src/generated/data_bind/data_bind_base.dart';

class DataBind extends DataBindBase {
  Component? target;
  ViewModelInstanceValue? source;
  ContextValue? contextValue;

  int dirt = ComponentDirt.filthy;

  bool addDirt(int value, {bool recurse = false}) {
    if ((dirt & value) == value) {
      return false;
    }

    dirt |= value;
    return true;
  }

  @override
  void onAddedDirty() {}

  @override
  void onAdded() {}

  void update(int dirt) {}

  void updateSourceBinding() {}

  @override
  void propertyKeyChanged(int from, int to) {
    // TODO: @hernan implement propertyKeyChanged
  }

  @override
  // ignore: override_on_non_overriding_member
  void targetIdChanged(int from, int to) {
    // TODO: @hernan implement nameChanged
  }

  @override
  void flagsChanged(int from, int to) {}

  void bind(DataContext? dataContext) {
    switch (source?.coreType) {
      case ViewModelInstanceNumberBase.typeKey:
        contextValue = ContextValueNumber(source);
        break;
      case ViewModelInstanceStringBase.typeKey:
        contextValue = ContextValueString(source);
        break;
      case ViewModelInstanceEnumBase.typeKey:
        break;
      case ViewModelInstanceListBase.typeKey:
        break;
      case ViewModelInstanceColorBase.typeKey:
        contextValue = ContextValueColor(source);
        break;
      case ViewModelInstanceBooleanBase.typeKey:
        contextValue = ContextValueBoolean(source);
        break;
    }
  }
}
