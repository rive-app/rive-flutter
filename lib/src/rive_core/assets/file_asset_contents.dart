import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/assets/file_asset_contents_base.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';

export 'package:rive/src/generated/assets/file_asset_contents_base.dart';

/// Stores the data of the bytes into an object that is always imported in
/// context of a FileAsset.
class FileAssetContents extends FileAssetContentsBase {
  @override
  void bytesChanged(List<int> from, List<int> to) {}

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  /// Never permanently added to core, so always invalidate.
  @override
  bool validate() => false;

  @override
  bool import(ImportStack stack) {
    var fileAssetImporter =
        stack.latest<FileAssetImporter>(FileAssetBase.typeKey);
    if (fileAssetImporter == null) {
      return false;
    }
    fileAssetImporter.loadContents(this);

    return super.import(stack);
  }
}
