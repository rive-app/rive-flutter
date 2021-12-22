/// Core automatically generated lib/src/generated/assets/image_asset_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/assets/asset_base.dart';
import 'package:rive/src/generated/assets/file_asset_base.dart';
import 'package:rive/src/rive_core/assets/drawable_asset.dart';

abstract class ImageAssetBase extends DrawableAsset {
  static const int typeKey = 105;
  @override
  int get coreType => ImageAssetBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ImageAssetBase.typeKey,
        DrawableAssetBase.typeKey,
        FileAssetBase.typeKey,
        AssetBase.typeKey
      };
}
