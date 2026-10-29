import 'dart:async' show Completer;
import 'dart:typed_data';

import 'package:rive/rive.dart' as rive;
import 'package:rive/src/errors.dart';
import 'package:rive_native/rive_native.dart' show AssetLoaderCallback;

/// {@template FileLoader}
/// A class that loads a Rive file from an asset, URL, or file.
///
/// To be used with [RiveWidgetBuilder].
///
/// - The [riveFactory] parameter is the Rive factory to use to decode the Rive
/// file, and determines the desired renderer to use.
///
/// This class caches the loaded file, and returns the same file instance
/// for subsequent calls to [file].
/// {@endtemplate}
class FileLoader {
  final rive.Factory riveFactory;
  final rive.File? _providedFile;
  final String? _asset;
  final Uint8List? _bytes;
  final String? _url;
  final AssetLoaderCallback? assetLoader;

  Completer<rive.File>? _loadCompleter;
  rive.File? _loadedFile;

  /// {@macro FileLoader}
  /// - The [asset] parameter is the asset to load the Rive file from.
  FileLoader.fromAsset(String asset,
      {required this.riveFactory, this.assetLoader})
      : _asset = asset,
        _bytes = null,
        _providedFile = null,
        _url = null;

  /// {@macro FileLoader}
  /// - The [url] parameter is the URL to load the Rive file from.
  FileLoader.fromUrl(String url, {required this.riveFactory, this.assetLoader})
      : _url = url,
        _asset = null,
        _bytes = null,
        _providedFile = null;

  /// {@macro FileLoader}
  /// - The [bytes] parameter is the bytes to load the Rive file from.
  FileLoader.fromBytes(Uint8List bytes,
      {required this.riveFactory, this.assetLoader})
      : _bytes = bytes,
        _asset = null,
        _providedFile = null,
        _url = null;

  /// {@macro FileLoader}
  /// - The [file] parameter is the file to load the Rive file from.
  FileLoader.fromFile(rive.File file, {required this.riveFactory})
      : assetLoader = null,
        _providedFile = file,
        _asset = null,
        _bytes = null,
        _url = null;

  Future<rive.File> file() async {
    if (_providedFile != null) {
      _loadedFile = _providedFile;
      return _providedFile;
    }

    if (_loadCompleter != null) {
      return _loadCompleter!.future;
    }

    _loadCompleter = Completer<rive.File>();

    try {
      rive.File? file;

      if (_asset != null) {
        try {
          file = await rive.File.asset(_asset,
              riveFactory: riveFactory, assetLoader: assetLoader);
        } catch (e) {
          // Handle the case where the asset doesn't exist or has empty data
          throw RiveFileLoaderException(
              'Failed to load Rive file from asset: $_asset. Error: $e');
        }
        if (file == null) {
          throw RiveFileLoaderException(
              'Failed to decode Rive file from asset: $_asset');
        }
      } else if (_bytes != null) {
        try {
          file = await rive.File.decode(_bytes,
              riveFactory: riveFactory, assetLoader: assetLoader);
        } catch (e) {
          // Handle the case where the bytes are invalid or empty
          throw RiveFileLoaderException(
              'Failed to load Rive file from bytes. Error: $e');
        }
        if (file == null) {
          throw RiveFileLoaderException(
              'Failed to decode Rive file from bytes');
        }
      } else if (_url != null) {
        try {
          file = await rive.File.url(_url,
              riveFactory: riveFactory, assetLoader: assetLoader);
        } catch (e) {
          // Handle the case where the URL fails to load
          throw RiveFileLoaderException(
              'Failed to load Rive file from URL: $_url. Error: $e');
        }
        if (file == null) {
          throw RiveFileLoaderException(
              'Failed to decode Rive file from URL: $_url');
        }
      } else {
        throw RiveFileLoaderException(
            'No asset, URL, or file provided to RiveFileLoader');
      }

      _loadedFile = file;
      _loadCompleter!.complete(file);
      return file;
    } on RiveFileLoaderException catch (e) {
      _loadCompleter!.completeError(e);
      rethrow;
    } on Exception catch (e) {
      final riveException =
          RiveFileLoaderException('Unexpected error loading Rive file: $e');
      _loadCompleter!.completeError(riveException);
      throw riveException;
    }
  }

  /// Returns the file synchronously if it's already available.
  ///
  /// This will return the file immediately if:
  /// - The FileLoader was created with [FileLoader.fromFile]
  /// - The file has been loaded via [FileLoader.file] and is cached
  ///
  /// Returns `null` if the file is not yet available.
  rive.File? get fileSync => _providedFile ?? _loadedFile;

  /// Returns whether the file is currently available synchronously.
  bool get isFileAvailable => fileSync != null;

  void dispose() {
    _providedFile?.dispose();
    _loadedFile?.dispose();
    _loadCompleter = null;
  }
}
