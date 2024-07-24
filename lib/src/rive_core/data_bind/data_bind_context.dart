import 'package:rive/src/generated/data_bind/data_bind_context_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/data_bind/data_context.dart';
import 'package:rive/src/rive_core/data_bind_flags.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_color.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_number.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_string.dart';
import 'package:rive_common/utilities.dart';

export 'package:rive/src/generated/data_bind/data_bind_context_base.dart';

// ignore: one_member_abstracts
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

  @override
  void bind(DataContext? dataContext) {
    if (dataContext != null) {
      final value = dataContext.getViewModelProperty(_ids);
      if (value != null) {
        if (value is ViewModelInstanceNumber) {
          value.addDependent(this);
        } else if (value is ViewModelInstanceString) {
          value.addDependent(this);
        } else if (value is ViewModelInstanceColor) {
          value.addDependent(this);
        }
        source = value;
        super.bind(dataContext);
      }
    }
  }

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.bindings != 0) {
      if ((flags & DataBindFlags.direction == DataBindFlags.toTarget) ||
          (flags & DataBindFlags.twoWay == DataBindFlags.twoWay)) {
        if (contextValue != null) {
          contextValue!.apply(target!, propertyKey);
        }
      }
    }
    super.update(dirt);
  }

  @override
  void updateSourceBinding() {
    if ((flags & DataBindFlags.direction == DataBindFlags.toSource) ||
        (flags & DataBindFlags.twoWay == DataBindFlags.twoWay)) {
      if (contextValue != null) {
        contextValue!.applyToSource(target!, propertyKey);
      }
    }
  }
}
