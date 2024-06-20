import 'package:rive/src/rive_core/viewmodel/viewmodel_instance.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_viewmodel.dart';

class DataContext {
  final ViewModelInstance viewModelInstance;
  DataContext? parent;

  DataContext(this.viewModelInstance);

  ViewModelInstanceValue? getViewModelProperty(List<int> path) {
    if (path.isNotEmpty) {
      if (path.first == viewModelInstance.viewModelId) {
        ViewModelInstance? viewModelInstanceTarget = viewModelInstance;
        int index = 1;
        while (index < path.length - 1) {
          viewModelInstanceTarget = (viewModelInstanceTarget!
                  .propertyValueByPropertyId<ViewModelInstanceViewModel>(
                      path[index]) as ViewModelInstanceViewModel)
              .referenceViewModelInstance;
          if (viewModelInstanceTarget == null) {
            return parent?.getViewModelProperty(path);
          }
          index += 1;
        }
        return viewModelInstanceTarget!.propertyValueByPropertyId(path[index]);
      }
    }
    return parent?.getViewModelProperty(path);
  }

  ViewModelInstance? getViewModelInstance(List<int> path) {
    if (path.isNotEmpty && path.first == viewModelInstance.viewModelId) {
      ViewModelInstance? viewModelInstanceTarget = viewModelInstance;
      int index = 1;
      while (index < path.length) {
        final viewModelInstanceViewModel = viewModelInstanceTarget!
            .propertyValueByPropertyId<ViewModelInstanceViewModel?>(
                path[index]) as ViewModelInstanceViewModel?;
        if (viewModelInstanceViewModel == null) {
          return parent?.getViewModelInstance(path);
        }
        viewModelInstanceTarget =
            viewModelInstanceViewModel.referenceViewModelInstance;
        if (viewModelInstanceTarget == null) {
          return parent?.getViewModelInstance(path);
        }
        index += 1;
      }
      return viewModelInstanceTarget;
    }
    return parent?.getViewModelInstance(path);
  }
}
