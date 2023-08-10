// Core automatically generated lib/src/generated/assets/file_asset_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
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

  /// --------------------------------------------------------------------------
  /// CdnUuid field with key 359.
  static final Uint8List cdnUuidInitialValue = Uint8List(0);
  Uint8List _cdnUuid = cdnUuidInitialValue;
  static const int cdnUuidPropertyKey = 359;

  /// The cdn uuid if it exists
  Uint8List get cdnUuid => _cdnUuid;

  /// Change the [_cdnUuid] field value.
  /// [cdnUuidChanged] will be invoked only if the field's value has changed.
  set cdnUuid(Uint8List value) {
    if (listEquals(_cdnUuid, value)) {
      return;
    }
    Uint8List from = _cdnUuid;
    _cdnUuid = value;
    if (hasValidated) {
      cdnUuidChanged(from, value);
    }
  }

  void cdnUuidChanged(Uint8List from, Uint8List to);

  /// --------------------------------------------------------------------------
  /// CdnBaseUrl field with key 362.
  static const String cdnBaseUrlInitialValue =
      'https://public.rive.app/cdn/uuid';
  String _cdnBaseUrl = cdnBaseUrlInitialValue;
  static const int cdnBaseUrlPropertyKey = 362;

  /// Set the base url of our cdn.
  String get cdnBaseUrl => _cdnBaseUrl;

  /// Change the [_cdnBaseUrl] field value.
  /// [cdnBaseUrlChanged] will be invoked only if the field's value has changed.
  set cdnBaseUrl(String value) {
    if (_cdnBaseUrl == value) {
      return;
    }
    String from = _cdnBaseUrl;
    _cdnBaseUrl = value;
    if (hasValidated) {
      cdnBaseUrlChanged(from, value);
    }
  }

  void cdnBaseUrlChanged(String from, String to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is FileAssetBase) {
      _assetId = source._assetId;
      _cdnUuid = source._cdnUuid;
      _cdnBaseUrl = source._cdnBaseUrl;
    }
  }
}
