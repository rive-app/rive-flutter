import 'package:rive/src/generated/data_bind/data_bind_context_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/data_bind/data_bind.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_color.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_number.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_string.dart';
import 'package:rive_common/utilities.dart';

export 'package:rive/src/generated/data_bind/data_bind_context_base.dart';

abstract class DataBindContextInterface {
  bool addDirt(int value, {bool recurse = false});
}

class DataBindContext extends DataBindContextBase
    with DataBindContextInterface {
  @override
  void sourcePathIdsChanged(List<int> from, List<int> to) {}

  final List<int> _ids = [];

  void onTargetPropertyChanged(dynamic from, dynamic to) {
    addDirt(ComponentDirt.bindings);
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();

    var reader = BinaryReader.fromList(sourcePathIds);
    while (!reader.isEOF) {
      _ids.add(reader.readVarUint());
    }
  }

  void bindToContext() {
    final dataContext = artboard?.dataContext;
    if (dataContext != null) {
      final value = dataContext.getViewModelProperty(_ids);
      if (value is ViewModelInstanceNumber) {
        value.addDependent(this);
      } else if (value is ViewModelInstanceString) {
        value.addDependent(this);
      } else if (value is ViewModelInstanceColor) {
        value.addDependent(this);
      }
    }
  }

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.bindings != 0) {
      final dataContext = artboard?.dataContext;
      if (dataContext != null) {
        final value = dataContext.getViewModelProperty(_ids);
        if (modeValue == BindMode.oneWay.index ||
            modeValue == BindMode.twoWay.index) {
          if (value is ViewModelInstanceNumber) {
            RiveCoreContext.setDouble(
                target!, propertyKey, value.propertyValue);
          } else if (value is ViewModelInstanceString) {
            RiveCoreContext.setString(
                target!, propertyKey, value.propertyValue);
          } else if (value is ViewModelInstanceColor) {
            RiveCoreContext.setColor(target!, propertyKey, value.propertyValue);
          }
        }
      }
    }
    super.update(dirt);
  }

  @override
  void updateSourceBinding() {
    if (modeValue == BindMode.oneWayToSource.index ||
        modeValue == BindMode.twoWay.index) {
      final dataContext = artboard?.dataContext;
      if (dataContext != null) {
        final property = dataContext.getViewModelProperty(_ids);
        if (property is ViewModelInstanceNumber) {
          final value = RiveCoreContext.getDouble(target!, propertyKey);
          property.propertyValue = value;
        } else if (property is ViewModelInstanceString) {
          final value = RiveCoreContext.getString(target!, propertyKey);
          property.propertyValue = value;
        }
      }
    }
  }
}
