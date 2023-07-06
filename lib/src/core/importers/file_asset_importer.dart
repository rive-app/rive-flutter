import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/file_asset_contents.dart';

/// QUESTION: renamed this to loader & importer
/// we use the "importer" names elsewhere
///
/// but IMO, the function names are pretty telling,
/// now the loader has "loadContents" & the resolver has "resolve"
/// before this was backwards.
/// (
///   also as part of our import process, we import components,
///   some components have additional *resolvers* added to the stack, which
///   get ... resolved... and when components mention assets, those assets get
///   loaded
/// )

// ignore: one_member_abstracts
abstract class FileAssetLoader {
  Future<bool> load(FileAsset asset);
  bool isCompatible(FileAsset asset) => true;
}

// this should be the resolver.
class FileAssetImporter extends ImportStackObject {
  final FileAssetLoader? assetLoader;
  final FileAsset fileAsset;
  final bool importEmbeddedAssets;

  FileAssetImporter(
    this.fileAsset,
    this.assetLoader, {
    this.importEmbeddedAssets = true,
  });

  bool _contentsResolved = false;

  // awkward name
  void resolveContents(FileAssetContents contents) {
    if (importEmbeddedAssets) {
      _contentsResolved = true;
      fileAsset.decode(contents.bytes);
    }
  }

  @override
  bool resolve() {
    if (!_contentsResolved) {
      // try to get them out of band
      assetLoader?.load(fileAsset);
    }
    return super.resolve();
  }
}
