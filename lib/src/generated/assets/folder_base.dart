import 'package:rive/src/rive_core/assets/asset.dart';

abstract class FolderBase extends Asset {
  static const int typeKey = 102;
  @override
  int get coreType => FolderBase.typeKey;
  @override
  Set<int> get coreTypes => {FolderBase.typeKey, AssetBase.typeKey};
}
