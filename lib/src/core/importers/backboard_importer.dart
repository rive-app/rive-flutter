import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/runtime_nested_artboard.dart';

class BackboardImporter extends ImportStackObject {
  final Backboard backboard;

  final HashMap<int, Artboard> artboardLookup;
  final Set<NestedArtboard> nestedArtboards = {};
  final List<FileAsset> fileAssets = [];
  final Set<FileAssetReferencer> fileAssetReferencers = {};
  BackboardImporter(this.artboardLookup, this.backboard);

  void addArtboard(Artboard object) {}
  void addNestedArtboard(NestedArtboard nestedArtboard) =>
      nestedArtboards.add(nestedArtboard);

  void addFileAsset(FileAsset fileAsset) => fileAssets.add(fileAsset);

  void addFileAssetReferencer(FileAssetReferencer referencer) =>
      fileAssetReferencers.add(referencer);

  @override
  bool resolve() {
    for (final nestedArtboard in nestedArtboards) {
      var artboard = artboardLookup[nestedArtboard.artboardId];

      if (artboard is RuntimeArtboard) {
        (nestedArtboard as RuntimeNestedArtboard).sourceArtboard = artboard;
      }
    }

    for (final referencer in fileAssetReferencers) {
      if (referencer.assetId >= 0 && referencer.assetId < fileAssets.length) {
        referencer.asset = fileAssets[referencer.assetId];
      }
    }
    return super.resolve();
  }
}
