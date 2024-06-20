import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_instance_list_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_list_item.dart';
export 'package:rive/src/generated/viewmodel/viewmodel_instance_list_base.dart';

class ViewModelInstanceList extends ViewModelInstanceListBase {
  ViewModelListItems children = ViewModelListItems();

  void addItem(ViewModelInstanceListItem item) {
    if (!children.contains(item)) {
      children.add(item);
    }
  }

  bool removeItem(ViewModelInstanceListItem item) {
    return children.remove(item);
  }

  void internalAddItem(ViewModelInstanceListItem item) {
    addItem(item);
  }

  /// Called by rive_core to remove a ListItem from the list.
  bool internalRemoveListItem(ViewModelInstanceListItem item) {
    var removed = removeItem(item);

    return removed;
  }
}
