import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/file_asset_contents.dart';

/// A helper for resolving Rive file assets (like images) that are provided out
/// of band with regards to the .riv file itself.
// ignore: one_member_abstracts
abstract class FileAssetResolver {
  Future<Uint8List> loadContents(FileAsset asset);
}

class FileAssetImporter extends ImportStackObject {
  final FileAssetResolver? assetResolver;
  final FileAsset fileAsset;

  FileAssetImporter(this.fileAsset, this.assetResolver);

  bool _loadedContents = false;

  void loadContents(FileAssetContents contents) {
    _loadedContents = true;
    fileAsset.decode(contents.bytes);
  }

  @override
  bool resolve() {
    if (!_loadedContents) {
      // try to get them out of band
      assetResolver?.loadContents(fileAsset).then(fileAsset.decode);
    }
    return super.resolve();
  }
}
