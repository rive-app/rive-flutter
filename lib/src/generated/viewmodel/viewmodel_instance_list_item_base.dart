// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_instance_list_item_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class ViewModelInstanceListItemBase<T extends CoreContext>
    extends Core<T> {
  static const int typeKey = 427;
  @override
  int get coreType => ViewModelInstanceListItemBase.typeKey;
  @override
  Set<int> get coreTypes => {ViewModelInstanceListItemBase.typeKey};

  /// --------------------------------------------------------------------------
  /// UseLinkedArtboard field with key 547.
  static const int useLinkedArtboardPropertyKey = 547;
  static const bool useLinkedArtboardInitialValue = true;
  bool _useLinkedArtboard = useLinkedArtboardInitialValue;

  /// Whether the artboard linked to the view model should be used.
  bool get useLinkedArtboard => _useLinkedArtboard;

  /// Change the [_useLinkedArtboard] field value.
  /// [useLinkedArtboardChanged] will be invoked only if the field's value has
  /// changed.
  set useLinkedArtboard(bool value) {
    if (_useLinkedArtboard == value) {
      return;
    }
    bool from = _useLinkedArtboard;
    _useLinkedArtboard = value;
    if (hasValidated) {
      useLinkedArtboardChanged(from, value);
    }
  }

  void useLinkedArtboardChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// ViewModelId field with key 549.
  static const int viewModelIdPropertyKey = 549;
  static const int viewModelIdInitialValue = -1;
  int _viewModelId = viewModelIdInitialValue;

  /// The view model id.
  int get viewModelId => _viewModelId;

  /// Change the [_viewModelId] field value.
  /// [viewModelIdChanged] will be invoked only if the field's value has
  /// changed.
  set viewModelId(int value) {
    if (_viewModelId == value) {
      return;
    }
    int from = _viewModelId;
    _viewModelId = value;
    if (hasValidated) {
      viewModelIdChanged(from, value);
    }
  }

  void viewModelIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// ViewModelInstanceId field with key 550.
  static const int viewModelInstanceIdPropertyKey = 550;
  static const int viewModelInstanceIdInitialValue = -1;
  int _viewModelInstanceId = viewModelInstanceIdInitialValue;

  /// The view model instance id.
  int get viewModelInstanceId => _viewModelInstanceId;

  /// Change the [_viewModelInstanceId] field value.
  /// [viewModelInstanceIdChanged] will be invoked only if the field's value has
  /// changed.
  set viewModelInstanceId(int value) {
    if (_viewModelInstanceId == value) {
      return;
    }
    int from = _viewModelInstanceId;
    _viewModelInstanceId = value;
    if (hasValidated) {
      viewModelInstanceIdChanged(from, value);
    }
  }

  void viewModelInstanceIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// ArtboardId field with key 551.
  static const int artboardIdPropertyKey = 551;
  static const int artboardIdInitialValue = -1;
  int _artboardId = artboardIdInitialValue;

  /// The artboard id to link the viewmodel to if implicit is set to false.
  int get artboardId => _artboardId;

  /// Change the [_artboardId] field value.
  /// [artboardIdChanged] will be invoked only if the field's value has changed.
  set artboardId(int value) {
    if (_artboardId == value) {
      return;
    }
    int from = _artboardId;
    _artboardId = value;
    if (hasValidated) {
      artboardIdChanged(from, value);
    }
  }

  void artboardIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ViewModelInstanceListItemBase) {
      _useLinkedArtboard = source._useLinkedArtboard;
      _viewModelId = source._viewModelId;
      _viewModelInstanceId = source._viewModelInstanceId;
      _artboardId = source._artboardId;
    }
  }
}
