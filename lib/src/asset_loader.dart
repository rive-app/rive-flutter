import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rive/src/asset.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/utilities/utilities.dart';

import 'core/importers/file_asset_importer.dart';

class CDNAssetLoader extends FileAssetLoader {
  final String baseUrl;
  CDNAssetLoader(this.baseUrl);

  @override
  bool isCompatible(FileAsset asset) => asset.cdnUuid.isNotEmpty;

  @override
  Future<bool> load(FileAsset asset) async {
    // do we have a url builder, dart seems to suck a bit for this.
    var url = baseUrl;
    if (!baseUrl.endsWith('/')) {
      url += '/';
    }
    url += formatUuid(
      uuidVariant2(asset.cdnUuid),
    );

    final res = await http.get(Uri.parse(url));
    await asset.decode(
      Uint8List.view(res.bodyBytes.buffer),
    );
    return true;
  }
}

class LocalAssetLoader extends FileAssetLoader {
  final String fontPath;
  final String imagePath;
  final AssetBundle _assetBundle;

  LocalAssetLoader({
    required this.fontPath,
    required this.imagePath,
    AssetBundle? assetBundle,
  }) : _assetBundle = assetBundle ?? rootBundle;

  @override
  Future<bool> load(FileAsset asset) async {
    String? assetPath;
    switch (asset.type) {
      case Type.unknown:
        return false;
      case Type.image:
        assetPath = imagePath + asset.name;
        break;
      case Type.font:
        assetPath = fontPath + asset.name;
        break;
    }

    final bytes = await _assetBundle.load(assetPath);
    await asset.decode(Uint8List.view(bytes.buffer));
    return true;
  }
}

class CallbackAssetLoader extends FileAssetLoader {
  Future<bool> Function(FileAsset) callback;

  CallbackAssetLoader(this.callback);

  @override
  Future<bool> load(FileAsset asset) async {
    return callback(asset);
  }
}

// Just a thought, can load assets from a few sources
// maybe pointless tbh, if people have a path here, they should sort it out...
// might be helpful users have a few different setups & simple want to
// be able to copy pasta their asset loading setup.
class FallbackAssetLoader extends FileAssetLoader {
  // by default, unless the data was inline we check locally & then on our cdn
  final List<FileAssetLoader> fileAssetLoaders;

  FallbackAssetLoader(this.fileAssetLoaders);

  @override
  Future<bool> load(FileAsset asset) async {
    for (var i = 0; i < fileAssetLoaders.length; i++) {
      final resolver = fileAssetLoaders[i];
      if (!resolver.isCompatible(asset)) {
        continue;
      }
      final success = await resolver.load(asset);
      if (success) {
        return true;
      }
    }
    return false;
  }
}
