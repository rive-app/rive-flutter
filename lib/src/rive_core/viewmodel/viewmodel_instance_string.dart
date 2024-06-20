import 'package:rive/src/generated/viewmodel/viewmodel_instance_string_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';

export 'package:rive/src/generated/viewmodel/viewmodel_instance_string_base.dart';

class ViewModelInstanceString extends ViewModelInstanceStringBase {
  @override
  void propertyValueChanged(String from, String to) {
    addDirt(ComponentDirt.bindings);
  }
}
