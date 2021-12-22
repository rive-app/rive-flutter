/// Core automatically generated lib/src/generated/assets/file_asset_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/assets/asset.dart';

abstract class FileAssetBase extends Asset {
  static const int typeKey = 103;
  @override
  int get coreType => FileAssetBase.typeKey;
  @override
  Set<int> get coreTypes => {FileAssetBase.typeKey, AssetBase.typeKey};

  /// --------------------------------------------------------------------------
  /// AssetId field with key 204.
  static const int assetIdInitialValue = 0;
  int _assetId = assetIdInitialValue;
  static const int assetIdPropertyKey = 204;

  /// Id of the asset as stored on the backend
  int get assetId => _assetId;

  /// Change the [_assetId] field value.
  /// [assetIdChanged] will be invoked only if the field's value has changed.
  set assetId(int value) {
    if (_assetId == value) {
      return;
    }
    int from = _assetId;
    _assetId = value;
    if (hasValidated) {
      assetIdChanged(from, value);
    }
  }

  void assetIdChanged(int from, int to);

  @override
  void copy(covariant FileAssetBase source) {
    super.copy(source);
    _assetId = source._assetId;
  }
}
