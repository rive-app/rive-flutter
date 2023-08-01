import 'package:rive/src/asset_loader.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/debug.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/file_asset_contents.dart';

// TODO: Deprecated. Remove this in the next major version (0.12.0).
// ignore: one_member_abstracts
abstract class FileAssetResolver {
  Future<Uint8List> loadContents(FileAsset asset);
}

class FileAssetImporter extends ImportStackObject {
  final FileAssetLoader? assetLoader;
  final FileAsset fileAsset;
  final bool loadEmbeddedAssets;

  FileAssetImporter(
    this.fileAsset,
    this.assetLoader, {
    this.loadEmbeddedAssets = true,
  });

  bool _contentsResolved = false;

  void resolveContents(FileAssetContents contents) {
    if (loadEmbeddedAssets) {
      _contentsResolved = true;
      fileAsset.decode(contents.bytes);
    }
  }

  @override
  bool resolve() {
    if (!_contentsResolved) {
      // try to get them out of band
      assetLoader?.load(fileAsset).then((loaded) {
        // TODO: improve error logging
        if (!loaded) {
          printDebugMessage(
            '''Rive asset (${fileAsset.name}) was not able to load:
  - Unique file name: ${fileAsset.uniqueFilename}
  - Asset id: ${fileAsset.id}''',
          );
        }
      });
    }
    return super.resolve();
  }
}
