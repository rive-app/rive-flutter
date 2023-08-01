import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rive/src/asset.dart';
import 'package:rive/src/debug.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/utilities/utilities.dart';

/// Base class for resolving out of band Rive assets, such as images and fonts.
///
/// See [CallbackAssetLoader] and [LocalAssetLoader] for an example of how to
/// use this.
abstract class FileAssetLoader {
  Future<bool> load(FileAsset asset);
  bool isCompatible(FileAsset asset) => true;
}

/// Loads assets from Rive's CDN.
///
/// This is used internally by Rive to load assets from the CDN. It is not
/// intended to be used by end users. Instead extend [FileAssetLoader] for
/// custom asset loading, or use [CallbackAssetLoader].
class CDNAssetLoader extends FileAssetLoader {
  CDNAssetLoader();

  @override
  bool isCompatible(FileAsset asset) => asset.cdnUuid.isNotEmpty;

  @override
  Future<bool> load(FileAsset asset) async {
    // TODO (Max): Do we have a URL builder?
    // TODO (Max): We should aim to get loading errors exposed where
    // possible, this includes failed network requests but also
    // failed asset.decode

    var url = asset.cdnBaseUrl;

    if (!url.endsWith('/')) {
      url += '/';
    }
    url += formatUuid(
      uuidVariant2(asset.cdnUuid),
    );

    final res = await http.get(Uri.parse(url));

    if ((res.statusCode / 100).floor() == 2) {
      try {
        await asset.decode(
          Uint8List.view(res.bodyBytes.buffer),
        );
      } on Exception catch (e) {
        printDebugMessage(
          '''Unable to parse response ${asset.runtimeType}.
  - Url: $url
  - Exception: $e''',
        );
        return false;
      }

      return true;
    } else {
      return false;
    }
  }
}

/// Convenience class for loading assets from the local file system.
///
/// Specify the [fontPath] and [imagePath] to load assets from the asset bundle.
///
/// If more control is desired, extend [FileAssetLoader] and override [load].
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
        assetPath = imagePath + asset.uniqueFilename;
        break;
      case Type.font:
        assetPath = fontPath + asset.uniqueFilename;
        break;
    }

    final bytes = await _assetBundle.load(assetPath);
    await asset.decode(Uint8List.view(bytes.buffer));
    return true;
  }
}

/// Convenience class that extends [FileAssetLoader] and allows you to
/// register a callback for loading Rive assets.
///
/// The callback will be called for each asset that needs to be loaded manually.
/// See [RiveFile] for additional options. Which assets are embedded are defined
/// within the Rive editor.
///
/// This callback will be triggered for any **referenced** assets.
///
/// Set [loadEmbeddedAssets] to false to disable loading embedded assets
///
/// Set [loadCdnAssets] to false to disable loading
/// assets from the Rive CDN.
///
/// ### Example usage:
/// Loading from assets. Here only assets marked as **referenced** will trigger
/// the callback.
/// ```dart
/// final riveFile = await RiveFile.asset(
///  'assets/asset.riv',
///  loadEmbeddedAssets: true,
///  loadCdnAssets: true,
///  assetLoader: CallbackAssetLoader(
///    (asset) async {
///      final res =
///          await http.get(Uri.parse('https://picsum.photos/1000/1000'));
///      await asset.decode(Uint8List.view(res.bodyBytes.buffer));
///      return true;
///    },
///  ),
/// );
/// ```
class CallbackAssetLoader extends FileAssetLoader {
  Future<bool> Function(FileAsset) callback;

  CallbackAssetLoader(this.callback);

  @override
  Future<bool> load(FileAsset asset) async {
    return callback(asset);
  }
}

/// Convenience class that extends [FileAssetLoader] and allows you to
/// register fallbacks for loading Rive assets, such as images and fonts.
///
/// For example, you can use this to load assets from the CDN, and if that
/// fails, load them from the asset bundle.
///
/// Alternatively, extend [FileAssetLoader] and override [load] for more
/// custom control in how assets are resolved.
class FallbackAssetLoader extends FileAssetLoader {
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
