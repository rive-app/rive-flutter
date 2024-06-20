import 'package:rive/src/generated/viewmodel/viewmodel_instance_enum_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';

export 'package:rive/src/generated/viewmodel/viewmodel_instance_enum_base.dart';

class ViewModelInstanceEnum extends ViewModelInstanceEnumBase {
  @override
  void propertyValueChanged(int from, int to) {
    addDirt(ComponentDirt.bindings);
  }
}
