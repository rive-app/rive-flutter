import 'package:rive/src/generated/viewmodel/viewmodel_instance_list_item_base.dart';

export 'package:rive/src/generated/viewmodel/viewmodel_instance_list_item_base.dart';

class ViewModelInstanceListItem extends ViewModelInstanceListItemBase {
  @override
  void instanceListIdChanged(int from, int to) {}

  @override
  void viewModelIdChanged(int from, int to) {}

  @override
  void viewModelInstanceIdChanged(int from, int to) {}

  @override
  void artboardIdChanged(int from, int to) {}

  @override
  void onAdded() {}

  @override
  void useLinkedArtboardChanged(bool from, bool to) {}

  @override
  void onAddedDirty() {}
}
