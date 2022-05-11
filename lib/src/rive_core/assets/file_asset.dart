import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/assets/file_asset_base.dart';
import 'package:rive/src/rive_core/backboard.dart';

export 'package:rive/src/generated/assets/file_asset_base.dart';

abstract class FileAsset extends FileAssetBase {
  @override
  void assetIdChanged(int from, int to) {}

  Future<void> decode(Uint8List bytes);

  @override
  bool import(ImportStack stack) {
    var backboardImporter =
        stack.latest<BackboardImporter>(BackboardBase.typeKey);
    if (backboardImporter == null) {
      return false;
    }

    // When we paste a FileAssetReference (e.g an Image) into a file, we want to
    // prevent the asset being readded if there is already a copy of it in the
    // file. We check if an asset with the same assetId  already exists, and if
    // so add it to the backboard importer, any fileAssetReferences will map
    // to the existing asset instead.
    for (final object in backboardImporter.backboard.assets) {
      if (object is FileAsset && object.assetId == assetId) {
        backboardImporter.addFileAsset(object);
        return false;
      }
    }

    backboardImporter.addFileAsset(this);
    return super.import(stack);
  }

  /// Returns the file extension, for example for an image it would be png.
  String get fileExtension;

  /// Returns a unique filename, useful for resolving files out of band.
  String get uniqueFilename {
    // remove final extension
    var uniqueFilename = name;
    var index = uniqueFilename.lastIndexOf('.');
    if (index != -1) {
      uniqueFilename = uniqueFilename.substring(0, index);
    }
    return '$uniqueFilename-$assetId.$fileExtension';
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
