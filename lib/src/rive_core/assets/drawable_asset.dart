import 'package:rive/src/generated/assets/drawable_asset_base.dart';

export 'package:rive/src/generated/assets/drawable_asset_base.dart';

abstract class DrawableAsset extends DrawableAssetBase {
  DrawableAsset();

  @override
  void heightChanged(double from, double to) {}

  @override
  void widthChanged(double from, double to) {}

  @override
  void assetIdChanged(int from, int to) {}
}
