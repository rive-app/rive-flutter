import 'package:rive/src/generated/viewmodel/viewmodel_instance_value_base.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/data_bind/data_bind_context.dart';
import 'package:rive/src/rive_core/dependency_helper.dart';

class ViewModelInstanceValue extends ViewModelInstanceValueBase {
  final DependencyHelper<Artboard, DataBindContextInterface> _dependencyHelper =
      DependencyHelper();

  @override
  void viewModelPropertyIdChanged(int from, int to) {}

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  void addDependent(DataBindContextInterface value) {
    _dependencyHelper.addDependent(value);
  }

  bool addDirt(int value, {bool recurse = true}) {
    _dependencyHelper.addDirt(value);
    return true;
  }
}
