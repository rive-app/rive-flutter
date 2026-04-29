import 'package:rive/src/generated/backboard_base.dart';
import 'package:rive/src/rive_core/assets/asset.dart';

export 'package:rive/src/generated/backboard_base.dart';

class Backboard extends BackboardBase {
  static final Backboard unknown = Backboard();

  final List<Asset> assets = <Asset>[];

  bool internalAddAsset(Asset asset) {
    if (assets.contains(asset)) {
      return false;
    }
    assets.add(asset);

    return true;
  }

  bool internalRemoveAsset(Asset asset) {
    bool removed = assets.remove(asset);

    return removed;
  }

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}
}
