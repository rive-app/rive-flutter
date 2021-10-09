import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/asset_base.dart';
import 'package:rive/src/rive_core/backboard.dart';

class Asset extends AssetBase {
  Backboard? _backboard;
  Backboard? get backboard => _backboard;
  set backboard(Backboard? value) {
    if (_backboard == value) {
      return;
    }
    _backboard = value;
  }

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  @override
  bool import(ImportStack stack) {
    return super.import(stack);
  }
}
