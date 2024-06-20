import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

class ViewModelInstanceImporter extends ImportStackObject {
  final ViewModelInstance viewModelInstance;
  ViewModelInstanceImporter(this.viewModelInstance);

  void addValue(ViewModelInstanceValue value) {
    viewModelInstance.addPropertyValue(value);
  }
}
