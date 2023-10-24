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
  Uint8List? embeddedBytes;

  FileAssetImporter(
    this.fileAsset,
    this.assetLoader,
  );

  void resolveContents(FileAssetContents contents) {
    embeddedBytes = contents.bytes;
  }

  @override
  bool resolve() {
    // allow our loader to load the file asset.
    assetLoader?.load(fileAsset, embeddedBytes).then((loaded) {
      if (!loaded && embeddedBytes != null) {
        fileAsset.decode(embeddedBytes!);
      } else if (!loaded) {
        // TODO: improve error logging
        printDebugMessage(
          '''Rive asset (${fileAsset.name}) was not able to load:
  - Unique file name: ${fileAsset.uniqueFilename}
  - Asset id: ${fileAsset.id}''',
        );
      }
    });
    return super.resolve();
  }
}
