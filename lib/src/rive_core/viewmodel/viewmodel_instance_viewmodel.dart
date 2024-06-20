import 'package:rive/src/generated/viewmodel/viewmodel_instance_viewmodel_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance.dart';

export 'package:rive/src/generated/viewmodel/viewmodel_instance_viewmodel_base.dart';

class ViewModelInstanceViewModel extends ViewModelInstanceViewModelBase {
  ViewModelInstance? referenceViewModelInstance;

  @override
  void propertyValueChanged(int from, int to) {}

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    referenceViewModelInstance =
        context.resolve<ViewModelInstance>(propertyValue);
  }
}
