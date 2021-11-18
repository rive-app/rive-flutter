import 'dart:typed_data';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/assets/file_asset_base.dart';
import 'package:rive/src/rive_core/backboard.dart';

export 'package:rive/src/generated/assets/file_asset_base.dart';

abstract class FileAsset extends FileAssetBase {
  Future<void> decode(Uint8List bytes);

  @override
  bool import(ImportStack stack) {
    var backboardImporter =
        stack.latest<BackboardImporter>(BackboardBase.typeKey);
    if (backboardImporter == null) {
      return false;
    }
    backboardImporter.addFileAsset(this);

    return super.import(stack);
  }
}

/// A mixin for any class that references a generic FileAsset.
abstract class FileAssetReferencer<T extends FileAsset> {
  T? _asset;
  T? get asset => _asset;

  int get assetId;
  set assetId(int value);

  set asset(T? value) {
    if (_asset == value) {
      return;
    }
    _asset = value;
    assetId = value?.id ?? Core.missingId;
  }

  /// Get the Core typeKey for the property that stores the assetId on the
  /// concrete object.
  int get assetIdPropertyKey;

  bool registerWithImporter(ImportStack stack) {
    var backboardImporter =
        stack.latest<BackboardImporter>(BackboardBase.typeKey);
    if (backboardImporter == null) {
      return false;
    }
    backboardImporter.addFileAssetReferencer(this);

    return true;
  }
}
