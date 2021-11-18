import 'dart:typed_data';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/file_asset_contents.dart';

class FileAssetImporter extends ImportStackObject {
  final FileAsset fileAsset;

  FileAssetImporter(this.fileAsset);

  void loadContents(FileAssetContents contents) {
    fileAsset.decode(contents.bytes as Uint8List);
  }
}
