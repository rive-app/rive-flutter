import 'package:rive/src/generated/data_bind/data_bind_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value_color.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value_number.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value_string.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_color.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_enum.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_list.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_number.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_string.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

export 'package:rive/src/generated/data_bind/data_bind_base.dart';

enum BindMode {
  oneWay,
  twoWay,
  oneWayToSource,
  once,
}

class DataBind extends DataBindBase {
  Component? target;
  ViewModelInstanceValue? source;
  ContextValue? contextValue;

  @override
  void onAddedDirty() {
    target = context.resolve(targetId);
    super.onAddedDirty();
  }

  @override
  void update(int dirt) {
    // TODO: @hernan implement update
  }

  void updateSourceBinding() {}

  @override
  void propertyKeyChanged(int from, int to) {
    // TODO: @hernan implement propertyKeyChanged
  }

  @override
  void targetIdChanged(int from, int to) {
    // TODO: @hernan implement nameChanged
  }

  @override
  void modeValueChanged(int from, int to) {
    // TODO: @hernan implement nameChanged
  }

  void bind() {
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
    }
  }
}
