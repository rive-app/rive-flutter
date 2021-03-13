import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rive/rive.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/widgets/artboard_provider/artboard_provider.dart';

/// An [ArtboardProvider] that allows loading [Artboard]s from assets.
class AssetArtboardProvider implements ArtboardProvider {
  /// A name of the animation asset to load.
  final String assetName;

  /// A collection of the assets to load the animation from.
  ///
  /// By default, equals to [rootBundle].
  final AssetBundle bundle;

  /// Creates a new instance of the [AssetArtboardProvider] with the given
  /// [assetName] and [bundle].
  ///
  /// The [assetName] must not be `null`.
  AssetArtboardProvider({
    @required this.assetName,
    AssetBundle bundle,
  })  : assert(assetName != null),
        bundle = bundle ?? rootBundle;

  @override
  FutureOr<Artboard> load({
    String artboardName,
  }) async {
    final assetBytes = await bundle.load(assetName);

    final riveFile = RiveFile();
    riveFile.import(assetBytes);

    if (artboardName == null) return riveFile.mainArtboard;

    return riveFile.artboardByName(artboardName);
  }
}
