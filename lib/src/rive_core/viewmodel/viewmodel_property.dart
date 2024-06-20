import 'package:rive/src/generated/viewmodel/viewmodel_property_base.dart';
import 'package:rive/src/rive_core/backboard.dart';

export 'package:rive/src/generated/viewmodel/viewmodel_property_base.dart';

class ViewModelProperty extends ViewModelPropertyBase {
  Backboard? backboard;

  @override
  void onAdded() {}

  @override
  void propertyOrderChanged(int from, int to) {}
}
